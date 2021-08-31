package Parser;
use v5.34;
use warnings;
use diagnostics;
use experimental 'signatures';
use Regexp::Grammars;
use Exporter ('import');


our @EXPORT = ('parse_master_file');

sub parse_master_file($path_to_file){
    my $parser = qr{

        <Exam>

        <nocontext:> 

        <rule: Exam>               <Intro> <[Questions]>*

        <rule: Questions>          <.Empty_Line>? <Question> <.Empty_Line>*? <Delimeter>

        <rule: Intro>              <Intro_Text>  <Delimeter> <.Empty_Line>*

        <rule: Delimeter>          ^ (_)+? $

        <rule: Question>           <Task> <Answers> <.Empty_Line>+?

        <rule: Answers>            <Correct_Answer> <[Other_Answer]>{4}

        <rule: Task>               ^ [1-9] [0-9]? [0-9]? \. .+? (\.\.\.|:|\?) $

        <rule: Correct_Answer>     ^ \s+? \[ \s* X \] \N+? \n

        <rule: Other_Answer>       ^ \s+? \[ \s*  \] \N+? \n

        <rule: Intro_Text>         ^ .+? (Scoring:) .+? (Warning:) .+?

        <token: Empty_Line>        \s* \n

        
    }xms;

    #Check if Filename exist
    my $filename;
    if(-e $path_to_file){
        $filename = $path_to_file;
    }
    else{
        warn "File '$path_to_file' was not found... Use FHNW_entrance_exam_master_file_2017.txt instead";
        $filename = "../data/MasterFiles/FHNW_entrance_exam_master_file_2017.txt"
    }

    my $opened = open(my $filehandler, "<", $filename );
    if( ! $opened){
        warn "\n Unable to open file '$filename' \n \t $!";
    }
    my $text = do {local $/; readline($filehandler);};

    if ($text =~ $parser){
        my %parsed_exam = %/;
    }
}



1; #Magic true value required at the end of module
