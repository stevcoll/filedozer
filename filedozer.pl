#!/usr/bin/perl

##############################################################
#  Script     : filedozer.pl
#  Author     : Steve Collmann
#  Email      : stevcoll@gmail.com
#  Created    : 02/06/2020
#  Updated    : 02/06/2020
#  Description: Perl File Finder and Processor Tool
##############################################################

use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Getopt::Long;
use File::Find;
use Cwd;

$| = 1;  ## Disable output buffering

GetOptions(
  'h|?|help' => sub { help(); },
  'm|match=s' => \my @matches,
  'f|filter=s' => \my @filters,
  'e|exec=s' => \my @commands,
  'd|dir=s' => \(my @dirs = (cwd)),  ## Default to present working directory
  'n|nocase' => \my $nocase,
  'q|quiet' => \my $quiet,
) or help();

help() unless @matches;

foreach my $dir (@dirs) {
  find(\&process, $dir);
}

sub process {
  return if -d $File::Find::name;  ## Do not process directories
  my $file = $File::Find::name;

  foreach my $filter (@filters) {
    if ($nocase) {
      return if $file =~ /$filter/i;
    } else {
      return if $file =~ /$filter/;
    }
  }

  foreach my $match (@matches) {
    if ($nocase) {
      return if $file !~ /$match/i;
    } else {
      return if $file !~ /$match/;
    }
  }

  foreach my $command (@commands) {
    print BOLD RED $command . " " . $file, RESET, "\n";
    unless ($quiet) {
      print "\nExecute Command? [y/N] ";
      my $execute = <STDIN>;
      chomp $execute;
      next unless $execute eq 'Y' || $execute eq 'y';
    }
    system($command . " " . $file);
    print "\n";
  }
  print $file . "\n" unless @commands;
}

sub help {
print 'FileDozer - Perl File Finder and Command Processor

Options:
   -m, --match           Perl Compatible Regular Expression (PCRE) to match files in search. Multiple parameters supported.
   -f, --filter          Perl Compatible Regular Expression (PCRE) to filter out files in search. Multiple parameters supported.
   -e, --exec            System command to run on each file located in search. Multiple parameters supported.
   -d, --dir             Parent directory to utilize in search. Subdirectories will be searched recursively. Multiple parameters supported.
   -n, --nocase          Case insensitive search will be performed.
   -q, --quiet           Do not prompt before executing commands on each file. Use at your own risk!
   -h, --help            Show this help screen.
   
Examples:
   ./filedozer.pl -m nmap                                  ## Path search using fixed string and present working directory as root.
   ./filedozer.pl -m "msfconsole\$"                        ## File search utilizing regex to match "metasploit" at the end of line.
   ./filedozer.pl -m backup -m "\.gz\$" -d /               ## File search for "backup" string AND ".gz" extension. Specify starting directory.
   ./filedozer.pl -m "log.*apache" -f "tar\.gz\$"          ## Alternative combined search using regex. Filter out any "tar.gz" extensions.
   ./filedozer.pl -m "\.(txt|conf)\$" -e cat -d /var/log   ## File search for ".gz" extension. Run command "zcat" on all files found.

Notes:
   - Any part of the absolute file path can be matched with an expression. Utilize regex boundaries in order to preent this.
   - Match option supports multiple parameters; ALL conditions must be met in order for a file to be matched.
   - Filter option supports multiple parameters; ANY condition met will negate the possibility of a file match.
   - Exec option supports multiple parameters; ALL commands will be run on each file matched.
   - Dir option supports multiple parameters; ALL directories will be processed for matching files.
';
  exit;
}
