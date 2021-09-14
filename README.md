# perl-final-project
Final Project for "Introduction to Perl for Programmers" @fhnw
|Author        | Mail                          | Date     |
|:-------------|:------------------------------|:---------|
|Pascal Hauser |pascal.hauser1@students.fhnw.ch|30.08.2021|


This Repository contains the solutions for the tasks 1a, 1b, 2, 3

## How-to-use
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

### Used CPAN Modules
* [DATA::SHOW](https://metacpan.org/pod/Data::Show)
* [experimental](https://metacpan.org/pod/experimental)
* [Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars)
* [Exporter](https://metacpan.org/pod/Exporter)
* []()TODO:


## Idea
### File parsing
For parsing the master file, I make use of the module [Regexp::Grammers](https://metacpan.org/pod/Regexp::Grammars) on CPAN. With this Module, the parsing can be done quite easy and robust. 
