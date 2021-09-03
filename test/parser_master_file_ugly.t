#!/usr/bin/env perl 

use v5.34;
use warnings;
use Test::More;
use Data::Show;

use lib "../lib";  # use the parent directory
#module under test
use Parser;


# Tell the module how many tests you plan to run...
plan tests => 2;

#Files
my $valid_masterfile = "test_data/valid_master_file_ugly.txt";
# Call the function being tested, and remember the actual data structure it returns...
my %master_exam= parse_master_file($valid_masterfile);
my $master_ref = \%master_exam;
my $EXPECTED =     {
      Exam => {
        Intro => {
          Delimeter  => "________________________________________________________________________________\n\n",
          Intro_Text => "Complete this exam by placing an 'X' in the box beside each correct\nanswer, like so:\n\n    [ ] This is not the correct answer\n    [ ] This is not the correct answer either\n    [ ] This is an incorrect answer\n    [X] This is the correct answer\n    [ ] This is an irrelevant answer\n\nScoring: Each question is worth 2 points.\n         Final score will be: SUM / 10\n\nWarning: Each question has only one correct answer. Answers to questions\n         for which two or more boxes are marked with an 'X' will be scored as zero.\n\n",
        },
        Questions => [
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] Nothing: Perl variables don't have a static type\n",
                Other_Answer   => [
                                    "    [ ] The name of the variable\n",
                                    "    [ ] The type of the first value placed in the variable\n",
                                    "    [ ] The compile-time type declarator of the variable\n",
                                    "    [ ] Random chance\n",
                                  ],
              },
              Task => "1. The type of a Perl variable is determined by:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] List, scalar, and void\n",
                Other_Answer   => [
                                    "    [ ] List, linear, and void\n",
                                    "    [ ] List, scalar, and null\n",
                                    "    [ ] Null, scalar, and void\n",
                                    "    [ ] Blood, sweat, and tears\n",
                                  ],
              },
              Task => "2. Perl's three main types of call context (or \"amount context\") are:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] \$_\n",
                Other_Answer   => [
                                    "    [ ] \@_\n",
                                    "    [ ] \$\$\n",
                                    "    [ ] \$=\n",
                                    "    [ ] The last variable that was successfully assigned to\n",
                                  ],
              },
              Task => "3. The \"default variable\" (or \"topic variable\") is:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] \@ARGV\n",
                Other_Answer   => [
                                    "    [ ] \$ARGV\n",
                                    "    [ ] \@ARGS\n",
                                    "    [ ] \@ARG\n",
                                    "    [ ] \@_\n",
                                  ],
              },
              Task => "4. You can access the command-line arguments of a Perl program via:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] CPAN\n",
                Other_Answer   => [
                                    "    [ ] CSPAN\n",
                                    "    [ ] Github\n",
                                    "    [ ] Perlhub\n",
                                    "    [ ] www.perl.org\n",
                                  ],
              },
              Task => "5. The main repository for Open Source Perl modules is:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] '\$' for scalars, '\@' for arrays, '%' for hashes\n",
                Other_Answer   => [
                                    "    [ ] '\$' for scalars, '\@' for hashes, '%' for arrays\n",
                                    "    [ ] '\$' for scalars, '\@' for consts, '%' for literals\n",
                                    "    [ ] '\$' for numeric, '\@' for emails, '%' for percentages\n",
                                    "    [ ] '\$' for lookups, '\@' for reuses, '%' for declarations\n",
                                  ],
              },
              Task => "6. The three standard sigils for variable declarations are:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] 'my' variables are lexically scoped; 'our' variables are package scoped\n",
                Other_Answer   => [
                                    "    [ ] 'my' variables are subroutine scoped; 'our' variables are block scoped\n",
                                    "    [ ] 'my' variables are compile-time; 'our' variables are run-time\n",
                                    "    [ ] 'my' variables must be scalars; 'our' variables must be arrays or hashes\n",
                                    "    [ ] 'my' variables are assignable; 'our' variables are constants\n",
                                  ],
              },
              Task => "7. The difference between a 'my' variable and an 'our' variable is:\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] ...does not interpolate variables or backslashed escape sequences\n",
                Other_Answer   => [
                                    "    [ ] ...only interpolates variables, but not backslashed escape sequences\n",
                                    "    [ ] ...only interpolates backslashed escape sequences, but not variables\n",
                                    "    [ ] ...interpolates both variables and backslashed escape sequences\n",
                                    "    [ ] ...converts its contents to ASCII, even if they are Unicode characters\n",
                                  ],
              },
              Task => "8. A single-quoted string (such as: 'I will achieve 100% on this exam')...\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] ...another way of writing the double-quoted string: \"XXXXX\"\n",
                Other_Answer   => [
                                    "    [ ] ...another way of writing the single-quoted string: 'XXXXX'\n",
                                    "    [ ] ...another way of writing the list of strings:  ('X', 'X', 'X', 'X', 'X')\n",
                                    "    [ ] ...another way of writing the array of strings: ['X', 'X', 'X', 'X', 'X']\n",
                                    "    [ ] ...a call to the 'qq' function, passing it a block of code\n",
                                  ],
              },
              Task => "9. The term qq{XXXXX} is...\n",
            },
          },
          {
            Question => {
              Answers => {
                Correct_Answer => "    [X] 1'042\n",
                Other_Answer   => [
                                    "    [ ] 1042\n",
                                    "    [ ] 1_042\n",
                                    "    [ ] 1.042e3\n",
                                    "    [ ] 0b10000010010\n",
                                  ],
              },
              Task => "10. Which of the following is NOT a single valid Perl number?\n",
            },
          },
        ],
      },
    };
#Basic Test
ok(scalar(@{$master_exam{Exam}{Questions}}) == 10);
# Are the two data structures identical at every point???
is_deeply($master_ref, $EXPECTED);
# Tell the testing module that we're finished (not required, but safer)...
done_testing();