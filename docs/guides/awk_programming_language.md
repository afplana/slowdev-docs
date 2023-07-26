# AWK Programming Language

AWK is a powerful data-driven scripting language that ships with Unix and Unix-like system. It's used for pattern scanning and processing language and is often used as a data extraction and reporting tool.

## Understanding AWK

The AWK command has the following structure:

```sh
awk 'pattern {action}' file
```

Here, AWK reads the provided file(s), and for each line, if it matches the pattern, the action is executed.

## Useful AWK Commands

### Printing Columns

AWK is often used to print specific columns or fields in a data stream or file.

**Print the first column of output from the ps command:**

```sh
ps | awk '{print $1}'
```

`ps` is a command that reports a snapshot of current processes. The pipe operator (`|`) passes the output of the ps command to the awk command. `awk '{print $1}'` prints the first field (column) of each line. The `$1` denotes the first field. This will print the process IDs (PIDs) of all running processes because the ps command outputs the PID in the first column.

**Print specific columns from /etc/passwd, using ":" as a field separator:**

```sh
awk -F ":" '{print $1" | "$3" | "$4}' /etc/passwd
```

This command reads the `/etc/passwd` file, and for each line (representing a user), it prints the username (`$1`), the user ID (`$3`), and the group ID (`$4`), separated by `|`.

### Filters and Pattern Matching

AWK is excellent for filtering data and pattern matching.

**Print lines longer than 8 characters:**

```sh
awk 'length($0) > 8' /etc/shells
```

`length($0) > 8` is a condition that checks if the length of the current line (`$0`) is greater than 8. If the condition is true, AWK performs the default action, which is to print the entire line. In this context, it will print lines from the `/etc/shells` file that are longer than 8 characters.

**Print processes running zsh:**

```sh
ps -ef | awk '{if($NF == "/bin/zsh") print $0}'
```

Filters processes that are instances of `/bin/zsh` and prints their details. `{if($NF == "/bin/zsh") print $0}` is the AWK command's action block where `if` statement checks if the last field (`$NF`) of the current record (i.e., line) equals `"/bin/zsh"`. `$NF` is a built-in AWK variable where `NF` stands for Number of Fields in the current record. The dollar sign `$` is used to refer to the content of a field. `$NF` thus refers to the content of the last field of the current line.

### Looping Constructs

AWK includes looping constructs for more complex data manipulation.

**An example of a for loop in AWK:**

```sh
awk 'BEGIN {for(i=1; i<=10; i++) print "square root of:", i, "is: ", i*i;}'
```

Prints the square of numbers from 1 to 10. `BEGIN` is a special kind of pattern, which is not tested against input records. The action associated with `BEGIN` is performed once only, before the first input record is read and `{for(i=1; i<=10; i++) print "square root of:", i, "is: ", i*i;}` is the action block that starts with a for loop.

### Text Substitution

**Replace all occurrences of 'PS' with 'PlayStation':**

```sh
awk '{ gsub(/PS/, "PlayStation"); print }'
```

`gsub(/PS/, "PlayStation")` is a function in AWK that globally replaces all occurrences of the string `'PS'` with `'PlayStation'` in the input record. The `gsub` function takes two arguments: the first is a regular expression that matches the string to replace (`/PS/`), and the second is the replacement string (`"PlayStation"`). `print` without an argument prints the entire line (or record). In this context, it prints the modified line after the gsub function has replaced `'PS'` with `'PlayStation'`.

### Handling Files

**Count lines in a file:**

```sh
awk 'END {print NR}' /etc/shells
```

`END` is a special pattern in AWK that matches the end of the input. The associated action is performed after all input has been read. `{print NR}` prints the value of `NR`, a built-in variable in AWK that keeps track of the number of input records (lines) read so far. In this context, the command will print the total number of lines in the `/etc/shells` file.

**Remove leading space in a file:**

```sh
awk '{$1=$1}1' file.txt
awk '{ $1=$1 }; { print }' file.txt # alternative version
```

`awk '{$1=$1}1'` may look strange, but it's a common idiom in AWK for removing leading and trailing white space. `$1=$1` effectively reconstructs the line, removing leading and trailing spaces. The `1` after the action is AWK shorthand for `{print}`, so it prints the line after the leading and trailing white spaces have been removed.

### Advanced Usage

More advanced commands can perform tasks like math operations, text manipulation, or multi-file processing.

**Total capacity of disks performing a sum of used + available space:**

```sh
df | awk '/\/dev\/disk/ {print $1"\t"$4 + $3"\t"$NF}'
```

`df` reports the amount of disk space used and available on file systems. The command filters lines starting with `/dev/disk`, and for each of those lines, it prints the disk name, the sum of used and available space, and the mount point.

**Print the index where character 'b' appeared on the file /etc/shells:**

```sh
awk 'match($0, /b/) {print $0 "has \"b\" character at ", RSTART}' /etc/shells
```

`match($0, /b/)` is a function that searches for the pattern `/b/` in the line (`$0`). `RSTART` is a built-in variable in AWK that contains the starting position of the string matched by the match function. The command will print lines from the `/etc/shells` file that contain the letter `'b'`, and the position of `'b'` in each line.

**Remove escape character \ from JSON objects:**

```sh
awk '{gsub(/\\\"/, "\""); print}'
```

This command removes escape characters before quotes in the input with the `gsub` function that substitute regex patterns globally taking in this case two parameters one is the regex and the second the replacement.

**In general:**

- `$1`, `$2`, etc., are variables that represent the respective fields (columns) in the input. These are specified based on the field separator defined (`-F` option or `FS` variable).
- `$0` represents the entire line.
- `NR` and `NF` are built-in AWK variables that represent the Number of Records (lines processed so far) and Number of Fields in the current line, respectively.
- `gsub` is a function that globally substitutes a regex pattern in the form `gsub(regexp, replacement [, target])`. The target is optional and defaults to `$0` (the entire line) if not specified.
- `print` is a statement that prints its arguments. The arguments can be fields, strings, or variables.
- `match(string, regexp)` is a function that searches string for the longest, leftmost substring matched by regexp and returns its starting position. The variable `RSTART` is set to the start of the matched substring.
- `substr(string, start [, length ])` is a function that returns a length-character-long substring of string, starting at character number start.
- `length(string)` is a function that returns the length of string. If no argument is supplied, the length of `$0` is used.
- `BEGIN` and `END` are special AWK patterns. The `BEGIN` block is executed before any input is read, and the `END` block is executed after all input has been read.
- The pipe symbol `|` in Unix/Linux is used to pipe one command to another. That is, it directs the output from the first command into the input for the second command.
- `if` is a control flow statement that allows code to be executed if a certain condition is met.
- A loop, like the `for` loop in one of the examples, repeatedly executes its body until the control condition is met. The `for(i=1; i<=10; i++)` loop will execute the body ten times, with `i` taking values from 1 to 10.
- `$NF` refers to the content of the last field of the current line. For instance, when processing the output of `ps -ef`, if `/bin/zsh` appears in the last field of a line, that process is a `zsh` shell process.
- `uniq` is a Unix command that removes duplicate lines from a sorted file.
- `-F` is an option to set the field separator for the input file. For example, `awk -F ":"` sets the field separator to `:`.

## Summary

AWK is a versatile tool for text processing on Unix-based systems. With its powerful pattern scanning and text processing abilities, AWK is an essential tool for any Unix/Linux sysadmin or developer. This guide provides a basic understanding of AWK and its most common uses, but its capabilities extend far beyond these examples.
