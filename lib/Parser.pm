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

    <rule: Exam>            <Intro>  <[Exam_Components]>*

    <rule: Exam_Components> <Questions> | <Delimeter>

    <rule: Intro>           ^ .+? (Scoring:) .+? (Warning:).+? \n \n

    <rule: Delimeter>       (_){5,100} \n \n \n?

    <rule: Questions>       <Question> <Correct_Answer> <[Other_Answer]>{4} <.Empty_Line> 

    <rule: Question>        ^ [1-9] [0-9]? [0-9]? \. .+? (\.\.\.|:|\?) $

    <rule: Correct_Answer>  ^ \s+? \[ \s* X \] \N+? \n

    <rule: Other_Answer>    ^ \s+? \[ \s*  \] \N+? \n

    <token: Empty_Line>     \s* \n

    
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

    # #create array of all questions
    # my @all_questions;
    # my @arr = @{$parsed_exam{'Exam'}->{'Exam_Components'}};
    # show @arr;
    # for my $ref (@arr) {
    #     my %entry = %{$ref};
    #     if (exists($entry{"Questions"})) {
    #         push(@all_questions, $entry{"Questions"});
    #     }
    # }
    # show @all_questions;

1; #Magic true value required at the end of module
