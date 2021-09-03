#!/usr/bin/env perl 

use v5.34;
use warnings;
use Test::More;
use Data::Show;

use lib "../lib";  # use the parent directory
use Parser;
#module under test
use Util;


# Tell the module how many tests you plan to run...
plan tests => 1;

my $EXPECTED = { name => "test_data/exam_correct.txt", result => 10 };
my $master_file = "test_data/valid_master_file_normal.txt";
my $exam_file = "test_data/exam_correct.txt";

my %exam_hash = parse_exam_file($exam_file);
my %master_hash = parse_master_file($master_file);

validate_exam(master_exam => \%master_hash, student_exam => \%exam_hash, exam_name => $exam_file) ;
my $result =  correct_exams(master_exam => \%master_hash, student_exam => \%exam_hash, exam_name => $exam_file);

is_deeply($result, $EXPECTED);
# Tell the testing module that we're finished (not required, but safer)...
done_testing();