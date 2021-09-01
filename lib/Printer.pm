package Printer;
use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use Exporter ('import');
use POSIX 'strftime';
use Term::ANSIColor qw(:constants);


our @EXPORT = qw(print_exam_to_file);


sub print_exam_to_file($master_file_name,%blank_exam ){
    print YELLOW, "Creating blank Exam based on $master_file_name ...\n", RESET;
    
    #Create name for new file
    my $timestamp = strftime '%Y%m%d-%H%M%S', localtime;
    my $exam_file_name = "$timestamp-$master_file_name"; 

    #create a new output file
    open my $output, '>', "../data/Output/$exam_file_name"
        or die "Couldn't open save file";
    
    #Print
    my $delimeter = $blank_exam{'Exam'}{'Intro'}{'Delimeter'};
    my $intro = $blank_exam{'Exam'}{'Intro'}{'Intro_Text'};
    my @questions = @{$blank_exam{'Exam'}{'Questions'}};
    #print Intro
    say {$output} "$intro \n";
    say {$output} "$delimeter";
    #print Questions
    for my $i (keys @questions){
        say {$output} $questions[$i]{"Question"}{"Task"};
        map {print{$output} $_} $questions[$i]{"Question"}{"Answers"} -> @*;
        say {$output} "\n $delimeter \n";
    }

    my $closed = close $output;
    print GREEN, "Sucessfully created new blank Exam '$exam_file_name' \n", RESET;

}




1; #Magic true value required at the end of module
