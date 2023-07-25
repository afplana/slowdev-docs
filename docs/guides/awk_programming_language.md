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

Print the first column of output from the ps command:

```sh
ps | awk '{print $1}'
```

Print specific columns from /etc/passwd, using ":" as a field separator:

```sh
awk -F ":" '{print $1" | "$3" | "$4}' /etc/passwd
```

### Filters and Pattern Matching

AWK is excellent for filtering data and pattern matching.

Print lines longer than 8 characters:

```sh
awk 'length($0) > 8' /etc/shells
```

Print processes running zsh:

```sh
ps -ef | awk '{if($NF == "/bin/zsh") print $0}'
```

### Looping Constructs

AWK includes looping constructs for more complex data manipulation.

An example of a for loop in AWK:

```sh
awk 'BEGIN {for(i=1; i<=10; i++) print "square root of:", i, "is: ", i*i;}'
```

### Text Substitution

Replace all occurrences of 'PS' with 'PlayStation':

```sh
awk '{ gsub(/PS/, "PlayStation"); print }'
```

### Handling Files

Count lines in a file:

```sh
awk 'END {print NR}' /etc/shells
```

Remove leading space in a file:

```sh
awk '{$1=$1}1' file.txt
awk '{ $1=$1 }; { print }' file.txt # alternative version
```

### Advanced Usage

More advanced commands can perform tasks like math operations, text manipulation, or multi-file processing.

Total capacity of disks performing a sum of used + available space:

```sh
df | awk '/\/dev\/disk/ {print $1"\t"$4 + $3"\t"$NF}'
```

Print the index where character 'b' appeared on the file /etc/shells:

```sh
awk 'match($0, /b/) {print $0 "has \"b\" character at ", RSTART}' /etc/shells
```

Remove escape character \ from JSON objects:

```sh
awk '{gsub(/\\\"/, "\""); print}'
```

## Summary

AWK is a versatile tool for text processing on Unix-based systems. With its powerful pattern scanning and text processing abilities, AWK is an essential tool for any Unix/Linux sysadmin or developer. This guide provides a basic understanding of AWK and its most common uses, but its capabilities extend far beyond these examples.
