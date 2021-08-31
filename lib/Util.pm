package Util;
use v5.34;
use warnings;
use diagnostics;
use experimental 'signatures';
use Exporter ('import');
use Data::Show;
use Algorithm::Numerical::Shuffle qw (shuffle);


our @EXPORT = qw(create_blank_exam);

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
    # edit copy of original exam
    my %master_exam = %parsed_exam;

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
        $question->{"Question"}{"Answers"} = [shift @all_questions];
    }
}

1; #Magic true value required at the end of module

