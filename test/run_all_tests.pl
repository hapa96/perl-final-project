use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';

my @tests = glob('*.t' );

#run all the tests present in this folder
for my $test (@tests){
    my $result = `perlbrew exec perl $test`;
    say "$test: $result";
}