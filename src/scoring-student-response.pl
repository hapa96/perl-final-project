use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use FindBin;                     # locate this script
use lib "../lib";  # use the parent directory

#Custom Modules in lib folder
use Parser; 
use Util;
use Printer;
#1b
my $master_file_name = shift @ARGV;
my %master_exam = parse_master_file($master_file_name);
my $regex_command = shift @ARGV;
my ($exam_folder, $search_key) = $regex_command =~ m{(^ .* /)(.* $)}xms;
my @desired_exams = `ls $exam_folder` ;
@desired_exams = grep /$search_key/, @desired_exams ;
chomp @desired_exams;
#show @desired_exams;
my @exams_hash_array;
#parse all the desired exams from students
for my $exam (@desired_exams){
    my %tmp_hash = parse_exam_file("$exam_folder/$exam");
    push @exams_hash_array, {%tmp_hash};
}

#validate all the exams --> Questions and Answers are present according to the master file
my $index = 0;
my @results; 
for my $exam_ref (@exams_hash_array){
    my %exam = %{$exam_ref};
    validate_exam(master_exam => \%master_exam, student_exam => \%exam, exam_name => $desired_exams[$index]);
    push (@results, correct_exams(master_exam => \%master_exam, student_exam => \%exam, exam_name => $desired_exams[$index]));
    $index++;
}
print_result_to_console(@results);



#check all exams
# {
#     student => path,
#     correct => 10,
# }
# Array that stores all hashes about the result






sub check_answer($correct_answer, @answers){
    chomp $correct_answer;
    chomp (@answers);
    # check that only one box is checked
    my $crosses = map {$_ =~ /\[ \s* X \s* \]/xms} @answers;
    show $crosses;
}



