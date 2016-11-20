#!/usr/bin/perl -w

#
# perl-remote-exec.pl
#
# Developed by Lubomir Host <lubomir.host@gmail.com>
# Licensed under terms of GNU General Public License.
# All rights reserved.
#
# Changelog:
# 2016-11-17 - created
#

use strict;
use warnings;

use MIME::Base64 qw( encode_base64 decode_base64 );

$| = 1;

# piese of cake:
# loader replaces very very hard quote escaping for perl(shell(ssh(shell(perl -e))))
my $base64_loader = encode_base64('sub load { eval(decode_base64(shift)); if ($@) { print "{ \"error\": \"$@\" }"; } else { run(@_); } }', '');

# read source code into variable
sub encode_perl_code($)
{ # {{{
	my ($scriptname) = @_;

	my $code = '';
	open(CODE, '<', $scriptname) or die "Can't read perl code '$scriptname': $!";
	while (my $line = <CODE>) {
		$code .= $line;
	}
	close(CODE);

	my $encoded = encode_base64($code, '');

	return $encoded;
} # }}}

sub cmd_output($)
{ # {{{
	my ($command) = @_;
	my $out = '';

	#print "CMD_OUTPUT: $command\n";

	open(CMD, '-|', $command) or die $@;
	my $line;
	while (defined($line = <CMD>)) {
		$out .= $line;
	}
	close CMD;

	return $out;
} # }}}


my ($remote, $scriptname, @args) = @ARGV;
my $base64_code = encode_perl_code($scriptname);

my $output_str = cmd_output("ssh $remote "
	. "perl -MMIME::Base64 -e '\"eval decode_base64 qw=$base64_loader; load(\@ARGV);\"' "
	. "$base64_code "
	. join(' ', @args)
);

print "OUTPUT: '$output_str'\n";

# vim: ts=4 fdm=marker fdl=0 fdc=3

