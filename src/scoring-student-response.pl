use v5.34;
use warnings;
use diagnostics;
use Data::Show;
use experimental 'signatures';
use FindBin;                     # locate this script
use lib "../lib";  # use the parent directory

#Custom Modules in lib folder
use Parser ; 

#1b
my $master_file_name = shift @ARGV;
my $regex_command = shift @ARGV;
my ($exam_folder, $search_key) = $regex_command =~ m{(^ .* /)(.* $)}xms;
my @desired_exams = `ls $exam_folder` ;
@desired_exams = grep /$search_key/, @desired_exams ;
chomp @desired_exams;
# show @desired_exams;
my @exams_hash_array;
#parse all the desired exams from students
for my $exam (@desired_exams){
    my %tmp_hash = parse_exam_file("$exam_folder/$exam");
    push @exams_hash_array, {%tmp_hash};
}
# show scalar(@desired_exams);
my $number_of_students =  scalar(@exams_hash_array);
#check all exams
# {
#     student => path,
#     correct => 10,
# }
my @results; # Array that stores all hashes about the result
 
my $i = 0;
for my $exam_ref (@exams_hash_array){
    
    my %exam = %{$exam_ref};
    my @arr =  @{$exam{"Exam"}{"Questions"}};
    my $len = scalar(@arr);
    my $name = $desired_exams[$i];
    say "$name - $len";
    $i++;
}


sub check_answer($correct_answer, @answers){
    chomp $correct_answer;
    chomp (@answers);
    # check that only one box is checked
    my $crosses = map {$_ =~ /\[ \s* X \s* \]/xms} @answers;
    show $crosses;
}



