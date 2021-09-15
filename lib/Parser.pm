package Parser;
use v5.34;
use warnings;
use diagnostics;
use experimental 'signatures';
use Regexp::Grammars;
use Exporter ('import');


our @EXPORT = ('parse_master_file', 'parse_exam_file');
# Parses a master file and generates a new hash for further procedure.
#  Parameter:
#       - $parse_exam_file :    Path to the corresponding master file
#
#  Returns:
#       - %parsed_exam :    Hash datastructure of the parsed file
sub parse_master_file($path_to_file){
    my $parser = qr{
        #<debug:on>

        <Exam>

        <nocontext:> 

        <rule: Exam>               <Intro> <[Questions]>*

        <rule: Questions>          <.Empty_Line>*? <Question> <.Empty_Line>*? <.Delimeter>*

        <rule: Intro>              <Intro_Text>  <Delimeter> <.Delimeter>* <.Empty_Line>*

        <rule: Question>           <Task> <Answers> 

        <rule: Answers>            <Correct_Answer> <[Other_Answer]>{4}

        <token: Delimeter>          [_=-]+ \R* 

        <token: Task>               \s*? [0-9]* [.] .+? (?: \.\.\.|:|\?) \R

        <token: Correct_Answer>     ^ \s*? \[ \s* X \] \N+? \n

        <token: Other_Answer>       ^ \s*? \[ \s*  \] \N+? \n

        <token: Intro_Text>         ^ .+? (Scoring:) .+? (Warning:) [^_]*

        <token: Empty_Line>        \s* \R

        
    }xms;

    parse_content($parser, $path_to_file );

}
# Parses an exam file and generates a new hash for further procedure.
#  Parameter:
#       - $parse_exam_file :    Path to the corresponding master file
#
#  Returns:
#       - %parsed_exam :    Hash datastructure of the parsed file
sub parse_exam_file($path_to_file){
    my $parser = qr{
        
        #<debug:on>
        
        <Exam>
       
        <nocontext:> 

        <rule: Exam>               <.Intro> <[Questions]>*

        <rule: Questions>          <.Empty_Line>*? <Question> <.Empty_Line>*? <.Delimeter>+

        <rule: Intro>              <Intro_Text> <.Empty_Line>*? <.Delimeter> <.Empty_Line>*?

        <rule: Question>           <Task> <.Empty_Line>+? <[Answers]>{5} <.Empty_Line>*?
        
        <token: Delimeter>          [_=-]+ \R* 

        <token: Answers>            ^ \s* \[ [^]]* \] \N* \R 

        <token: Task>               \s*? \d+ [.] \N* \R (?: \N* \S \N* \R )*

        <token: Intro_Text>         ^ .+? (?: Scoring:) .+? (?: Warning:) [^_]*

        <token: Empty_Line>         \s* \R

        
    }xms;

    parse_content($parser, $path_to_file );

}
#Helper Function for Parsing a file
# Parameters:
#    -$parser        : grammer for parsing the file
#    -$path_to_file  : path to the corresponding file
# Returns:
#    -%parsed_exam   : Hash datastrucure of the parsed file
sub parse_content($parser, $path_to_file ){
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
