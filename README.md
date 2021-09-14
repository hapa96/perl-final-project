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
To keep the code organized and to meet the [DRY](https://de.wikipedia.org/wiki/Don%E2%80%99t_repeat_yourself) Programming Principle, code was organized within modules and than reused and tested in different places. Following the written modules with the corresponding **exported functions**. For more information about a specific function, please visit the commented sourcecode.

### [Parser](lib/Parser.pm)
Module for parsing exam and master file and return a hash data structure.
* `parse_master_file` Parse a master file and generates a new hash for further procedure.
* `parse_exam_file`   Parses an exam file and generates a new hash for further procedure.

### [Printer](lib/Printer.pm)
* `print_exam_to_file` Print a blank report from a master file to a file
* `print_result_to_console` Print all the results of the corrected exams to the console
* `console_printer` Print warnings to console
* `print_statistics_to_console` Print the generated statistics to the console
* `print_suspicious_exams` Print suspicious exams to the console

### [Util](lib/Util.pm)
* `create_blank_exam` Create a new Exam based on a master file
* `validate_exam` Validate the exam. Checks that all Questions and Answers are present
* `correct_exams` Correct the students exam based on the master exam
* `generate_statistics` Generate all the statistics from the result array
* `suspicious_results` Reports suspicous exams by definded criterias
* `compare_strings` Compare two strings using the Levenshtein Distance

## Testing
You can find all the tests for this project in the `test` folder. To run all the tests at once, you can execute the perl program [run_all_tests.pl](test/run_all_tests.pl)
```
perl run_all_tests.pl
```

# Ideas, Solution Approaches and Retrospectives
## Parsing the Files (Master and Exam)
For parsing the files I choose the Regexp::Grammars module from CPAN to parse the files. I thought it is a good idea to distinguish between the master file and the exam files to treat them differently. So I've written two different grammars. In retrospect, I would definitely not do that again. At the point Mr. Conway shared his solution with us, I was way too far with my project and invested too many hours in debugging the grammar to change it and all the functions that were written for my data structure. So I stuck with the plan and used my two grammars, knowing it's not the cleanest solution.

## Validate Exam Files
Before an exam file got corrected, it will be validated. A function within the [Util](lib/Util.pm) module named `validate_exam` does the job. *Extension 2- Inexact matching of questions and answers* is applied and prints warnings to the console, if a question or answer is not present or has slight differences compared with the master file.

## Correct an Exam
After the exam got validated propperly, the exam will be corrected. A function within the [Util](lib/Util.pm) module named `correct_exam` does the job.The function creates for a hash with all the information for an exam. A hash entry for an exam looks like the following:
```
my %result = (
        name                            => "exam_file_one",         # Name of the exam
        result                          => 10,                      # Total correct Answers
        answered                        => 12,                      # Total answered Questions
        total_questions                 => 12,                      # Total Questions in Master File
);
```
In the script [scoring-student-response.pl](src/scoring-student-response.pl) where this function got called, every hash will be pushed in a result array. This result array is than used to print the result to the console and generate statistics (*Extenion 3 Analyzing cohort performance and identifying below-expectation results*)

## Generating Statistics
To generate statistics from the checked exams, the function `generate_statistics` in the [Util](lib/Util.pm) module was created. This function takes the result array described before. The function  generates a new hash with all the information about the statistics of the exam results. This hash looks like the following:
```
my %stats = (
        average_question_answered       => int($answered_acc/$students),
        min_questions_answered          => $min_questions, 
        min_questions_answered_n        => $question_answered_stats{$min_questions},
        max_questions_answered          => $max_questions,
        max_questions_answered_n        => $question_answered_stats{$max_questions},
        average_correct_answers         => int($answered_correct_acc / $students),
        min_correct_answered            => $min_correct_answers,
        min_correct_answered_n          => $correct_answers_stats{$min_correct_answers},
        max_correct_answered            => $max_correct_answers,
        max_correct_answered_n          => $correct_answers_stats{$max_correct_answers},
    );
```
The result of the statistics will then get printed with the `print_statistics_to_console` function in the [Printer](lib/Printer.pm) module.
## Extension 3 - Analyzing cohort performance and identifying below-expectation results
The following criterias were choosen for suspicious exams:
* less than 50% of all questions answered
* score < 50%
* more than 50% of answered questions are wrong
The function `suspicious_results` within the [Util](lib/Util.pm) module takes the result array with the hashes of all exams and generates a new hash, that contains all the suspicious exams with the corresponding criteria that was meet. This hash looks like the following:
```

```
