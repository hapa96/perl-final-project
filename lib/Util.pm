package Util;
use v5.34;
use warnings;
use diagnostics;
use experimental 'signatures';
use Exporter ('import');
use Data::Show;
use Algorithm::Numerical::Shuffle qw (shuffle);
use Storable qw(dclone); # To create a deep copy of an object
use Term::ANSIColor qw(:constants);



our @EXPORT = qw(create_blank_exam validate_exam correct_exams );

# Creates a new Exam based on a master file
#   Parameters:
#       - %parsed_exam : Hashtree from the parsed master file
#   Returns:
#       - %blank_exam : The Hashtree of the new blank exam file

sub create_blank_exam(%parsed_exam){
    # create a deep copy of the hash %parsed_exam
    my %blank_exam = %{dclone(\%parsed_exam)};

    my @all_questions;
    my @arr = @{$blank_exam{'Exam'}{'Questions'}};

    #combine all answers as an array
    for my $ref (@arr) {
        my %entry = %{$ref};
        my $tmp_arr = [($entry{"Question"}{"Answers"}{"Other_Answer"} -> @*,$entry{"Question"}{"Answers"}{"Correct_Answer"})];
        push(@all_questions,  $tmp_arr );
    }
    remove_cross_and_shuffle(@all_questions);
    
    for my $question (@{$blank_exam{'Exam'}{'Questions'}}){
        $question->{"Question"}{"Answers"} = shift @all_questions;
    }
    return %blank_exam;
}

# Removes all the crosses and shuffles the question 
#   Parameters:
#       - @questions : Array with all questions
sub remove_cross_and_shuffle(@questions){
    for my $question(@questions){
        
        #remove Cross
        map {$_ =~ s%\[ X \]
                    %\[ \]%xms} @{$question};

        #Shuffle the array inplace in a random order
        @${question} = shuffle(@{$question});
    }
}


# Validates the exam in two steps. First checks that all the questions are present in the exam file. Afterwars check, that all the possible
# Answers are present as well.
#   Parameters:
#       - master_questions          : Array ref. to the questions of the master file 
#       - student_questions         : Array ref. to the questions of the student file
#       - exam_name                 : Name of the corresponding student file

sub validate_exam( %args){
    my $exam_name = $args{exam_name};
    my @master_questions = @{$args{master_exam}->{'Exam'}{'Questions'}};
    my @student_questions = @{$args{student_exam}->{'Exam'}{'Questions'}};
    if(check_questions(master_questions => \@master_questions, student_questions => \@student_questions,exam_name => $exam_name)){
        check_answers(master_questions => \@master_questions, student_questions => \@student_questions,exam_name => $exam_name);
    }
}



# Checks, that all questions from master file are present in the students exam file. 
#   Parameters:
#       - master_questions          : Array ref. to the questions of the master file 
#       - student_questions         : Array ref. to the questions of the student file
#       - exam_name                 : Name of the corresponding student file
#   Returns:
#       - $all_questions_present    : Returns true, if all questions from the master file are present.

sub check_questions(%args){
    my $all_questions_present = 1;
    my $printed_error_for_exam = 0; # Flag that ensures, that the file name is printed just the first time
    my $exam_name = $args{exam_name};

    my @master_questions = @{$args{master_questions}};
    my @student_questions = @{$args{student_questions}};
    for my $index (keys @master_questions){
        my $desired_question = $master_questions[$index]->{'Question'}{'Task'};
        #Check if student exam has record
        unless (exists ($student_questions[$index])){
            $printed_error_for_exam ?  print "": print RED, "Warning: $exam_name: \n", RESET;
            print WHITE, "\t Missing Question:  $desired_question\n \n", RESET;
            $all_questions_present = 0;
            $printed_error_for_exam = 1;
            next; #start next iteration
        }
        my $student_question = $student_questions[$index] -> {"Question"}{"Task"};
        
        #Check, that question is exactly the same
        $desired_question =~  s/^\s+|\s+$//g;
        $student_question =~ s/^\s+|\s+$//g;
        unless ($desired_question eq $student_question){
            $printed_error_for_exam ? print "" : print RED, "Warning: $exam_name: \n", RESET;
            print WHITE, "\t Question is not the same. Please Check:\n", RESET; 
            print BLUE, "\t Expected:\n \t \t $desired_question\n", RESET;
            print YELLOW "\t Got:\n \t \t $student_question \n\n", RESET;
            $printed_error_for_exam = 1;
        }
    }
    return $all_questions_present; 
}   

# Checks, that all possible answers from the master file are present in the exam file as well. If not, print directly out to console for further investigations.
#   Parameters:
#       - master_questions          : Array ref. to the questions of the master file 
#       - student_questions         : Array ref. to the questions of the student file
#       - exam_name                 : Name of the corresponding student file

sub check_answers(%args){
    my $printed_error_for_exam = 0; #Flag that indicates if an error message was printed during this subroutine
    my $exam_name = $args{exam_name};
    my @master_questions = @{$args{master_questions}};
    my @student_questions = @{$args{student_questions}};
    
    for my $question (keys @master_questions){
        #Create flatend array with all question for each question
        my @master_answers = ($master_questions[$question] -> {'Question'}{'Answers'}{'Correct_Answer'}, @{$master_questions[$question] -> {'Question'}{'Answers'}{'Other_Answer'}});
        my @exam_answers = @{$student_questions[$question] -> {'Question'}{'Answers'}}; 
        
        #remove Checkbox, leading spaces and ending spaces
        map {$_ =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg } @master_answers;
        map {$_ =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg } @exam_answers;

        #Checks, that every answer in the master file is present in the exam file
        for my $answer (@master_answers){
            unless(grep {$_ eq $answer} @exam_answers){    
                $printed_error_for_exam ? print "" : print RED, "Warning: $exam_name: \n" , RESET;    
                print WHITE, "\t Missing answer: $answer\n";
                $printed_error_for_exam = 1;
            }
        }
    }
}
# Corrects the students exam based on the master exam
#   Parameters:
#       - master_exam          : Hashtree of the master exam file
#       - student_exam         : Hashtree of the student exam file
#       - exam_name            : Name of the corresponding student file
#   Returns:
#       - %result              : Returns a result tree with name and score of the corrsponding student
sub correct_exams(%args){
    my %result = (
        name => $args{exam_name},
        result => 0,
    );
    my @master_questions = @{$args{master_exam}->{'Exam'}{'Questions'}};
    my @student_questions = @{$args{student_exam}->{'Exam'}{'Questions'}};

    for my $question(keys @master_questions){
        #next iteration if current quesion is not present in the students question
        next unless (exists ($student_questions[$question]));
        my @students_answers = $student_questions[$question]->{"Question"}{"Answers"} -> @*;
        my @given_ansers = grep {$_ =~ m{^ \s* \[ \s* [Xx] \s* \] }xms } @students_answers;
        
        #If @given_answers is not 1 (more than one or none answer was choosen)
        next unless(scalar (@given_ansers) == 1);

        #remove the checkbox, leading and ending whitespaces as well as all kind of new lines
        $given_ansers[0] =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg;
        $master_questions[$question]->{'Question'}{'Answers'}{'Correct_Answer'} =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg;
        
        #If the same answer was choosen, increment result counter
        $result{"result"}++ if ($given_ansers[0] eq $master_questions[$question]->{'Question'}{'Answers'}{'Correct_Answer'})
            
    }
    return \%result;
}



1; #Magic true value required at the end of module

