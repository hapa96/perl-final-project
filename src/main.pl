use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use FindBin;                     # locate this script
use lib "../lib";  # use the parent directory
use Parser ; # own module to parse a master file

my %my_file = parse_master_file(" ");
