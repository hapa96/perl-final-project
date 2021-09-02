package Printer;
use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use Exporter ('import');
use POSIX 'strftime';
use Term::ANSIColor qw(:constants);


our @EXPORT = qw(print_exam_to_file print_result_to_console);


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

    #Close Filehandler
    my $was_closed = close $output;
    if( ! $was_closed){
        warn "\n Unable to close filehandler \n \t $!";
    }
    print GREEN, "Sucessfully created new blank Exam '$exam_file_name' \n", RESET;
}

sub print_result_to_console(@results){
    print GREEN, "\n\nResults of Exam: \n", RESET;
    for my$result_ref(@results){
        my %result = %{$result_ref};
        print_pretty($result{"name"},$result{"result"})
    }
}

sub print_pretty($name, $result){
    my $width = 60;
    my $n_of_dots = $width - length ($name);
    my $dots = "." x $n_of_dots;
    print $name;
    print $dots;
    printf "%02d/%2d \n", $result ,30 ;
}



1; #Magic true value required at the end of module
