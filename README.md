# FileDozer

FileDozer is a simple utility which allows users to search and process files through the command line. It is designed around Perl and its core modules only. No external dependencies are required, making this a lightweight and mobile solution.

The design goal behind FileDozer was to create an elegant, portable, and efficient file searching tool as an alternate solution to built-in Linux utilities such as **find** or **locate** when dealing with certain file searches. Additionally, FileDozer is an effective tool to use on Windows, where the built-in file searching tools are abysmal.

FileDozer depends upon the core module [**File::Find**](https://perldoc.perl.org/File/Find.html) for file searching operations.

## Features
- Match files and paths using Perl Compatible Regular Expressions (PCRE). Multiple expressions supported.
- Filter out files and paths using Perl Compatible Regular Expressions (PCRE). Multiple expressions supported.
- Execute custom commands on each file discovered. Multiple commands supported.
- Multiple parent search directories supported.
- Recursive directory searching for files.
- Ignore case sensitivity option.

## Help
```
FileDozer - Perl File Finder and Processor | Steve Collmann - stevcoll@gmail.com

Options:
   -m, --match           Perl Compatible Regular Expression (PCRE) to match files in search. Multiple parameters supported.
   -f, --filter          Perl Compatible Regular Expression (PCRE) to filter out files in search. Multiple parameters supported.
   -e, --exec            System command to run on each file located in search. Multiple parameters supported.
   -d, --dir             Directory to search recursively. Defaults to working directory. Multiple parameters supported.
   -n, --nocase          Case insensitive search will be performed.
   -q, --quiet           Do not prompt before executing commands on each file. Use at your own risk!
   -h, --help            Show this help screen.
   
Examples:
   ./filedozer.pl -m nmap                                 ## Path search using fixed string and present working directory as root.
   ./filedozer.pl -m "msfconsole$"                        ## File search utilizing regex to match "msfconsole" at the end of line.
   ./filedozer.pl -m backup -m "\.gz$" -d /               ## File search for "backup" string AND ".gz" extension. Specify starting directory of "/".
   ./filedozer.pl -m "log.*apache" -f "tar\.gz$"          ## Alternative combined search using regex. Filter out any "tar.gz" extensions.
   ./filedozer.pl -m "\.(txt|conf)$" -e cat -d /var/log   ## File search for "txt" and "conf" extensions. Run command "cat" on all files found.

Notes:
   - Any part of the absolute file path can be matched with an expression. Utilize regex boundaries in order to preent this.
   - Match option supports multiple parameters; ALL conditions must be met in order for a file to be matched.
   - Filter option supports multiple parameters; ANY condition met will negate the possibility of a file match.
   - Exec option supports multiple parameters; ALL commands will be run on each file matched.
   - Dir option supports multiple parameters; ALL directories will be processed for matching files.

```

## Author
Steve Collmann, stevcoll@gmail.com
