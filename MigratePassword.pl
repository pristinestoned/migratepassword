#!/usr/bin/perl
#
# Code written by Brian Ponnampalam brian2004 [at] hotmail.com
#
# A program to retrieve active users from passwd file that are using bash shell

use strict;

if ($> != 0) {
    print "\n$0 must be run as root.\n\n";
    exit 0;
}

my $pwdfile       = "/etc/passwd";
my $workpassfile  = "./workpasswd";
my @shadfile      = `cat /etc/shadow`;

open(INFO, $pwdfile) or die("Could not open file");
open(PASS, '>', $workpassfile) or die("Could not open file");

while (my $line = <INFO>) {

    my @users = split(/:/, $line);

    if ($line =~ /\/bin\/bash/) {
        print "Printing hash for: $users[0]\n";

        foreach my $passline (@shadfile) {

            my @passhash = split(/:/, $passline);

            if ($passline =~ /$users[0]/) {
                $line =~ s/:x:/:$passhash[1]:/g;
                print PASS $line;
            }
        }
    }
}

close(PASS);
close(INFO);
