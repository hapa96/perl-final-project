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


my $master_file_name = shift @ARGV;
my %master_exam = parse_master_file($master_file_name);
my $total_questions = scalar $master_exam{Exam} -> {Questions} -> @*;
my $regex_command = shift @ARGV;
my ($exam_folder, $search_key) = $regex_command =~ m{(^ .* /)(.* $)}xms;
my @desired_exams = `ls $exam_folder` ;
@desired_exams = grep /$search_key/, @desired_exams ;
chomp @desired_exams;
my @exams_hash_array;

#parse all the desired exams from students
for my $exam (@desired_exams){
    my %tmp_hash = parse_exam_file("$exam_folder/$exam");
    push @exams_hash_array, {%tmp_hash};
}

#validate all the exams --> Questions and Answers are present according to the master file
my $exam_index = 0;
my @results; 
for my $exam_ref (@exams_hash_array){
    validate_exam(master_exam => \%master_exam, student_exam => $exam_ref, exam_name => $desired_exams[$exam_index]);
    push (@results, correct_exams(master_exam => \%master_exam, student_exam => $exam_ref, exam_name => $desired_exams[$exam_index], total_questions => $total_questions));
    $exam_index++;
}
#Print the result for all files to the console
print_result_to_console(@results);
my %stats = generate_statistics(@results);
print_statistics_to_console(%stats);
my %suspicious_exams = suspicious_results(@results);
print_suspicious_exams(%suspicious_exams);




