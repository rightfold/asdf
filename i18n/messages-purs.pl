#!/usr/bin/env perl

use strict;
use warnings;

if (@ARGV != 1) {
    print STDERR "Usage: $0 MODULE < FILE > FILE\n";
    exit 1;
}

print "module $ARGV[0] where\n";
while (<STDIN>) {
    s/^\s+|\s+$//g;
    next if /^#/ || /^$/;
    my ($key, $value) = split /\s+/, $_, 2;
    $key =~ s/\./_/g;
    print "m_$key :: String\n";
    print "m_$key = \"$value\"\n";
}
