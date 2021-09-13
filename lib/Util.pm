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
use Lingua::StopWords qw( getStopWords );
use Text::Levenshtein::Damerau qw (edistance);
use Printer;



our @EXPORT = qw(create_blank_exam validate_exam correct_exams compare_strings);

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
    my $all_questions_are_present = check_questions(master_questions => \@master_questions, student_questions => \@student_questions,exam_name => $exam_name);
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
    my @master_questions = @{$args{master_questions}};
    my @student_questions = @{$args{student_questions}};

    # Check if all questions are present in exam file
    my $all_files_are_present = 1;
    for my $master_index(keys @master_questions){
        my $highest = -1;
        my $used_question;
        my $student_index;
        for my $index (keys @student_questions){ 
            my $res = compare_strings(master_string =>$master_questions[$master_index] -> {Question}{Task}, student_string=>$student_questions[$index] -> {Question}{Task});
            if ($highest < $res){
                $student_index = $index;
                $highest = $res;
                if($highest == 0){
                    $used_question = $student_questions[$index] -> {Question}{Task};
                }
            }
        }
        #Distance is smaller than 10%
        if ($highest == 0){        
           console_printer(master_text =>$master_questions[$master_index] -> {Question}{Task}, exam_name => $args{exam_name}, used_instead => $used_question, type => "Question");
        }
        #Distance is bigger than 10%
        elsif($highest == -1){   
           console_printer(master_text =>$master_questions[$master_index] -> {Question}{Task}, exam_name => $args{exam_name}, type => "Question");
            $all_questions_present = 0;
        }
        if($highest != -1){
        #Check all answers from a question. Only check, if question is present.
        check_answers(master_question => $master_questions[$master_index], student_question => $student_questions[$student_index], exam_name => $args{exam_name});
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
    my @master_answers = ($args{master_question}  -> {'Question'}{'Answers'}{'Correct_Answer'}, @{$args{master_question} -> {'Question'}{'Answers'}{'Other_Answer'}});
    my @student_answers = @{$args{student_question} -> {'Question'}{'Answers'}};

    #remove checkboxes, whitespaces and newlines
    map {$_ =~ s{\[[^\]]*\]|\R*|\s{2,}}{}xmsg } @master_answers;
    map {$_ =~ s{\[[^\]]*\]|\R*|\s{2,}}{}xmsg } @student_answers;
    for my $master_answer (@master_answers){
        my $highest = -1;
        my $used_answer;
        for my $student_answer (@student_answers){
            my $res = compare_strings(master_string =>$master_answer, student_string=>$student_answer);
            if ($highest < $res){
                $highest = $res;
                if($highest == 0){
                    $used_answer = $student_answer;
                }
            }
        }
        next if $highest == 1;
        if ($highest == 0){        
           console_printer(master_text => $master_answer, exam_name => $args{exam_name}, used_instead => $used_answer, type => "Answer");
        }
        #Distance is bigger than 10%
        elsif($highest == -1){   
           console_printer(master_text => $master_answer, exam_name => $args{exam_name}, type => "Answer");
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
        $master_questions[$question]->{'Question'}{'Answers'}{'Correct_Answer'} =~ s{^\s*?\[[^\]]+\]\h|\R*}{}xmsg;
        
        #If the same answer was choosen, increment result counter
        $result{"result"}++ if ($given_ansers[0] eq $master_questions[$question]->{'Question'}{'Answers'}{'Correct_Answer'})
            
    }
    return \%result;
}

# Normalized a given string acording to the description
# removing any “stop words” from the text;
# removing any sequence of whitespace characters at the start and/or the end of the text;
# replacing any remaining sequence of whitespace characters within the text with a single space character.

#   Parameters:
#     - $string       string that will be normalized     
#   Returns:
#     - $string       Returns the normalized string
sub normalize_string($string){
    state $stopwords = getStopWords('en');
    $string = lc $string; 
    #remove stop words and more than one space character between the words
    $string = join ' ', grep { !$stopwords->{$_} } split /\s+/, $string;
    #remove leading and ending spaces
    $string =~  s{^\s+|\s+$}{}g;
   return $string;
}

# Funciton to compare two strings using the Levenshtein Distance.
# Parameters:   
#               $master_string:     String from the master file
#               $student_string:    String from the students exam file
# Returns:      Integer Number
#               - 1:                Strings are exactly identical
#               - 0:                Distance is smaller than 10%
#               - 1:                Strings are not identical
sub compare_strings(%args){
    my $master_string  = normalize_string($args{master_string});
    my $student_string = normalize_string($args{student_string});
    my $max_distance = int(0.1 * length($master_string));
    edistance($master_string, $student_string) <= $max_distance ? return $master_string eq $student_string  : return -1 ;
}

1; #Magic true value required at the end of module
