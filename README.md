# perl-final-project
Final Project for "Introduction to Perl for Programmers" @fhnw
|Author        | Mail                          | Date     |
|:-------------|:------------------------------|:---------|
|Pascal Hauser |pascal.hauser1@students.fhnw.ch|30.08.2021|


This Repository contains the solutions for the tasks 1a, 1b, 2, 3

# How-to-use
### Task 1a: Randomization of questions
To generate a new exam from a master file, you can use the script [create-exam-file.pl](src/create-exam-file.pl) This script requires the path for the corresponding master file. By default, the script generates a new exam file and saves it in the folder `data/Output`
```
perl create-exam-file.pl  ../data/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
```
### Task 1b with Extension 2 and Extension 3
To score new exam file based on a master file, you can use the script [scoring-student-response.pl](src/scoring-student-response.pl). This scipt expects two additional arguments. ARGV0 = master file. ARGV1 = exam folder with REGEX Expression
```
 perl scoring-student-response.pl ../data/MasterFiles/FHNW_entrance_exam_master_file_2017.txt ../data/SampleResponses/.*
```
# Project Details
## Structure 
The Project is structured as the following:
|Folder  | Description|
|--------|------------|
|data    | Files, that are required for the program to run. Also generated files from the program can be found here|
|lib     | Modules, that are used for the main program |
|src     | Scripts that complete the tasks and uses modules from lib |     
|test    | Tests|

## Development Environment
For Developing this project, `WSL:Ubuntu-20.4` with `perlbrew` and the newest perl `v.5.34` was used.

## Used CPAN Modules
#### [DATA::SHOW](https://metacpan.org/pod/Data::Show)
Used in every perl file for dumping various data structures. Only used for development
#### [Experimental](https://metacpan.org/pod/experimental)
Used to define functions with parameters.
#### [Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars)
Used for parsing text files with a grammer. 
#### [Exporter](https://metacpan.org/pod/Exporter)
Used to export functions in a module.
#### [POSIX](https://metacpan.org/pod/POSIX)
Perl interface to IEEE Std 1003.1
#### [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor)
Used to print colored text  to the console
#### [Algorithm::Numerical::Shuffle](https://metacpan.org/pod/Algorithm::Numerical::Shuffle)
Used to shufle an Array inplace randomly (for Task 1a)
#### [Storable](https://metacpan.org/pod/Storable)
Used to create a deep copy of datastructures
#### [Lingua::StopWords](https://metacpan.org/pod/Lingua::StopWords)
Used to filter out StopWords from given Strings
#### [Text::Levenshtein::Damerau](https://metacpan.org/pod/Text::Levenshtein::Damerau)
Used to caluclate the [Damerau–Levenshtein Distance](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance) from two given strings

## Written Modules
To keep the code organized and to meet the [DRY](https://de.wikipedia.org/wiki/Don%E2%80%99t_repeat_yourself) Programming Principle, code was organized within modules and than reused and tested in different places. Following the written modules with the corresponding exported functions. For more information about a specific function, please visit the commented sourcecode.
### [Parser](lib/Parser.pm)
Module for parsing exam and master file and return a hash data structure.
* `parse_master_file`
* `parse_exam_file`

### [Printer](lib/Printer.pm)


### [Uril](lib/Util.pm)


## Testing