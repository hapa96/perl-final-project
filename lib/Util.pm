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

#Helper Function for removing Crosses and shuffle the questions 
sub remove_cross_and_shuffle(@all_questions){
    for my $question(@all_questions){
        
        #remove Cross
        map {$_ =~ s%\[ X \]
                    %\[ \]%xms} @{$question};

        #Shuffle the array inplace in a random order
        @${question} = shuffle(@{$question});
    }
    return @all_questions
}


sub create_blank_exam(%parsed_exam){
    # create a deep copy of the hash %parsed_exam
    my %master_exam = %{dclone(\%parsed_exam)};    

    #create array of all questions
    my @all_questions;
    my @arr = @{$master_exam{'Exam'}{'Questions'}};

    for my $ref (@arr) {
        my %entry = %{$ref};
        if (exists($entry{"Question"}{"Answers"}{"Other_Answer"})) {
            my $tmp_arr = [($entry{"Question"}{"Answers"}{"Other_Answer"} -> @*,$entry{"Question"}{"Answers"}{"Correct_Answer"})];
            push(@all_questions,  $tmp_arr );
        }
    }
    my @shuffeld_questions = remove_cross_and_shuffle(@all_questions);
    
    for my $question (@{$master_exam{'Exam'}{'Questions'}}){
        $question->{"Question"}{"Answers"} = shift @all_questions;
    }
    return %master_exam;
}



# Check Question and Answers are present in students Exam
sub validate_exam( %args){
    my $exam_name = $args{exam_name};
    my %master_exam = %{$args{master_exam}};
    my %student_exam = %{$args{student_exam}};
    my @master_questions = @{$master_exam{'Exam'}{'Questions'}};
    my @student_questions = @{$student_exam{'Exam'}{'Questions'}};
    if(check_questions(master_questions => \@master_questions, student_questions => \@student_questions,exam_name => $exam_name)){
        check_answers(master_questions => \@master_questions, student_questions => \@student_questions,exam_name => $exam_name);
    }

}


#Check, that all questions from master file are present in the students exam file. If one question does not exist at all, return false. otherwise return true
sub check_questions(%args){
    my $all_questions_present = 1;
    my $printed_error_for_exam = 0;
    my $exam_name = $args{exam_name};
    my @master_questions = @{$args{master_questions}};
    my @student_questions = @{$args{student_questions}};
    for my $i (keys @master_questions){
        my %master_question = %{$master_questions[$i]};
        my $desired_question = $master_question{'Question'}{'Task'};

        #Check if student exam has record
        unless (exists ($student_questions[$i])){
            $printed_error_for_exam ?  print "": print RED, "Warning: $exam_name: \n", RESET;
            print WHITE, "\t Missing Question:  $desired_question\n \n", RESET;
            $all_questions_present = 0;
            $printed_error_for_exam = 1;
            next; #start next iteration
        }

        my %student_question = %{$student_questions[$i]};
        
        #Check, that question is exactly the same
        $master_question{"Question"}{"Task"} =~  s/^\s+|\s+$//g;
        $student_question{"Question"}{"Task"} =~ s/^\s+|\s+$//g;
        unless ($master_question{'Question'}{'Task'} eq $student_question{'Question'}{'Task'}){
            my $actual_question = $student_question{'Question'}{'Task'};
            $printed_error_for_exam ? print "" : print RED, "Warning: $exam_name: \n", RESET;
            print WHITE, "\t Question is not the same. Please Check:\n", RESET; 
            print BLUE, "\t Expected:\n \t \t $desired_question\n", RESET;
            print YELLOW "\t Got:\n \t \t$actual_question \n\n", RESET;
            $printed_error_for_exam = 1;
        }
    }
    return $all_questions_present;
}   

#Check that all the answers are present in the exam file
sub check_answers(%args){
    my $printed_error_for_exam = 0; #Flag that indicates if an error message was printed during this subroutine
    my $exam_name = $args{exam_name};
    my @master_questions = @{$args{master_questions}};
    my @student_questions = @{$args{student_questions}};
    
    for my $question (keys @master_questions){
        my %master_answers_hash = %{$master_questions[$question]};
        my %exam_answers_hash = %{$student_questions[$question]};

        #Create flatend array with all question for each question
        my @master_answers = ($master_answers_hash{'Question'}{'Answers'}{'Correct_Answer'}, $master_answers_hash{'Question'}{'Answers'}{'Other_Answer'} -> @* );
        my @exam_answers = $exam_answers_hash{'Question'}{'Answers'} -> @*; 
        
        #remove Checkbox, leading spaces and ending spaces
        map {$_ =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg } @master_answers;
        map {$_ =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg } @exam_answers;

        #check, that every answer in the master file is present in the exam file
        for my $answer (@master_answers){
            unless(grep {$_ eq $answer} @exam_answers){    
                $printed_error_for_exam ? print "" : print RED, "Warning: $exam_name: \n" , RESET;    
                print WHITE, "\t Missing answer: $answer\n";
                $printed_error_for_exam = 1;
            }
        }
    }
}
# Check the exam and increment
sub correct_exams(%args){
    my %res = (
        name => $args{exam_name},
        result => 0,
    );
    my %master_exam = %{$args{master_exam}};
    my %student_exam = %{$args{student_exam}};
    my @master_questions = @{$master_exam{'Exam'}{'Questions'}};
    my @student_questions = @{$student_exam{'Exam'}{'Questions'}};

    for my $question(keys @master_questions){
        my %master_answers_hash = %{$master_questions[$question]};
        unless (exists ($student_questions[$question])){
        next;
        }
        my %students_answers_hash = %{$student_questions[$question]};
        my @students_answers = $students_answers_hash{"Question"}{"Answers"} -> @*;
        my @given_ansers = grep {$_ =~ m{^ \s* \[ \s* [Xx] \s* \] }xms } @students_answers;
        
        if(scalar (@given_ansers) > 1) {
            next;
        };

        $given_ansers[0] =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg;
        $master_answers_hash{'Question'}{'Answers'}{'Correct_Answer'} =~ s/^\s*?\[[^\]]+\]\h|\R*//xmsg;

        if ($given_ansers[0] eq $master_answers_hash{'Question'}{'Answers'}{'Correct_Answer'}){
            $res{"result"}++;
        }
    }
    return \%res;
}



1; #Magic true value required at the end of module

