# perl-final-project
Final Project for "Introduction to Perl for Programmers" @fhnw
|Author        | Mail                          | Date     |
|:-------------|:------------------------------|:---------|
|Pascal Hauser |pascal.hauser1@students.fhnw.ch|30.08.2021|


## Structure 
The Project is structured as the following:
|Folder  | Description|
|--------|------------|
|data    | Files, that are required for the program to run. Also generated files from the program can be found here|
|lib     | Modules, that are used for the main program |     
|test    | Tests| 

## Development Environment
For Developing this project, `WSL:Ubuntu-20.4` with `perlbrew` and the newest perl `v.5.34` was used.

## Idea
### File parsing
For parsing the master file, I make use of the module [Regexp::Grammers](https://metacpan.org/pod/Regexp::Grammars) on CPAN. With this Module, the parsing can be done quite easy and robust. The Grammer for the file looks as the following:
```
        <Exam>

        <nocontext:> 

        <rule: Exam>               <Intro> <[Questions]>*

        <rule: Questions>          <.Empty_Line>? <Question> <.Empty_Line>*? <Delimeter>

        <rule: Intro>              <Intro_Text>  <Delimeter> <.Empty_Line>*

        <rule: Delimeter>          ^ (_)+? $

        <rule: Question>           <Task> <Answers> <.Empty_Line>+?

        <rule: Answers>            <Correct_Answer> <[Other_Answer]>{4}

        <rule: Task>               ^ [1-9] [0-9]? [0-9]? \. .+? (\.\.\.|:|\?) $

        <rule: Correct_Answer>     ^ \s+? \[ \s* X \] \N+? \n

        <rule: Other_Answer>       ^ \s+? \[ \s*  \] \N+? \n

        <rule: Intro_Text>         ^ .+? (Scoring:) .+? (Warning:) .+?

        <token: Empty_Line>        \s* \n
```

