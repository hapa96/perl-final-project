use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use lib "../lib";  # use the parent directory

#Custom Modules in lib folder
use Parser ; 
use Util;
use Printer;

my $master_file_name = $ARGV[0];

#Task 1a
my %master_exam = parse_master_file($master_file_name);
show %master_exam;   
my %blank_exam = create_blank_exam(%master_exam);          
print_exam_to_file($master_file_name, %blank_exam);

show %master_exam;