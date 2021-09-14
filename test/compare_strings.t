#!/usr/bin/env perl 

use v5.34;
use warnings;
use Test::More;
use Data::Show;

use lib "../lib";  # use the parent directory
#module under test
use Util;

# Tell the module how many tests you plan to run...
plan tests => 4;
ok(compare_strings(master_string => "TEST", student_string => "tEsT") == 1);
ok(compare_strings(master_string => "Test", student_string => "Teest") == -1);
ok(compare_strings(master_string => "This Module can handle stop words", student_string => "Module can handle stop words") == 1);
ok(compare_strings(master_string => "MModule can handle stop words", student_string => "Module can handle stop words") == 0);

# Tell the testing module that we're finished (not required, but safer)...
done_testing();