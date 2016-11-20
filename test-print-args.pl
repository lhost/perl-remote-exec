#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub run(@)
{ 
	print Dumper({ command => $0, args => \@_ });
}

