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
    result              => 10,
    answered            => 20,
    total_questions     => 20,
    },
    {
    name                => "1",
    result              => 10,
    answered            => 20,
    total_questions     => 20,       
    }];

 my $EXPECTED_1 = 
    {
      average_correct_answers   => 10,
      average_question_answered => 20,
      max_correct_answered      => 10,
      max_correct_answered_n    => 2,
      max_questions_answered    => 20,
      max_questions_answered_n  => 2,
      min_correct_answered      => 10,
      min_correct_answered_n    => 2,
      min_questions_answered    => 20,
      min_questions_answered_n  => 2,
    };

my $mock_data_2 = [
    {
    name                => "1",
    result              => 5,
    answered            => 15,
    total_questions     => 20,
    },
    {
    name                => "2",
    result              => 10,
    answered            => 20,
    total_questions     => 20,       
    },
    {
    name                => "2",
    result              => 20,
    answered            => 20,
    total_questions     => 20,       
    }];

 my $EXPECTED_2 = 
    {
      average_correct_answers   => 11,
      average_question_answered => 18,
      max_correct_answered      => 20,
      max_correct_answered_n    => 1,
      max_questions_answered    => 20,
      max_questions_answered_n  => 2,
      min_correct_answered      => 5,
      min_correct_answered_n    => 1,
      min_questions_answered    => 15,
      min_questions_answered_n  => 1,
    };


#Act
my %result_mock_1 = generate_statistics($mock_data_1 -> @*);
my %result_mock_2 = generate_statistics($mock_data_2 -> @*);


my $result_mock_1 = \%result_mock_1;
my $result_mock_2 = \%result_mock_2;

#Assert
is_deeply($result_mock_1, $EXPECTED_1);
is_deeply($result_mock_2, $EXPECTED_2);

# Tell the testing module that we're finished (not required, but safer)...
done_testing();

   
