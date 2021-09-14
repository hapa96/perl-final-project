#!/usr/bin/env perl 
use v5.34;
use warnings;
use Test::More;
use Data::Show;

use lib "../lib";  # use the parent directory

#module under test
use Util;

# Tell the module how many tests you plan to run...
plan tests => 2;

#Arrange
my $mock_data_1 = [
    {
    name                => "1",
    result              => 18,
    answered            => 20,
    total_questions     => 20,
    },
    {
    name                => "1",
    result              => 15,
    answered            => 20,
    total_questions     => 20,       
    }];

my $EXPECTED_1 = {};

my $mock_data_2 = [
    {
    name                => "1",
    result              => 5,
    answered            => 15,
    total_questions     => 20,
    },
    {
    name                => "2",
    result              => 9,
    answered            => 20,
    total_questions     => 20,       
    },
    {
    name                => "2",
    result              => 9,
    answered            => 9,
    total_questions     => 20,       
    }];

my $EXPECTED_2 = 
{
    1 => {
            messages => 
            [
               "score < 50%",
               "more than 50% of answered questions are wrong",
             ],
            result => 5,
            total_questions => 20,
           },
    2 => {
            messages => 
            [
               "score < 50%",
               "more than 50% of answered questions are wrong",
               "less than 50% of all questions answered",
               "score < 50%",
            ],
            result => 9,
            total_questions => 20,
        },
};




#Act
my %result_mock_1 = suspicious_results($mock_data_1 -> @*);
my %result_mock_2 = suspicious_results($mock_data_2 -> @*);

my $result_mock_1 = \%result_mock_1;
my $result_mock_2 = \%result_mock_2;

#Assert
is_deeply($result_mock_1, $EXPECTED_1);
is_deeply($result_mock_2, $EXPECTED_2);

# Tell the testing module that we're finished (not required, but safer)...
done_testing();

   
