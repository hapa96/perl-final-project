use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use FindBin;                     # locate this script
use lib "../lib";  # use the parent directory
use Parser ; # own module to parse a master file
use Util;


my %master_exam = parse_master_file("../data/MasterFiles/FHNW_entrance_exam_master_file_2017.txt");
create_new_test(%master_exam);
