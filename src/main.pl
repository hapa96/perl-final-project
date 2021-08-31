use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use FindBin;                     # locate this script
use lib "../lib";  # use the parent directory
use Parser ; # own module to parse a master file
use Util;

my $master_file_path = $ARGV[0];
#Task 1a
my %master_exam = parse_master_file($master_file_path);
create_blank_exam(%master_exam);
show %master_exam;