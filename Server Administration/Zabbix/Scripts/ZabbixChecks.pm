package ZabbixChecks;

# Class to grant the ZabbixChecks program a nice Object-Oriented interface
# zabbixchecks.pm

use strict;
use warnings;

###
# For convenience later on, let's define some colors for output using the following listing:
#	
#	--------------------------------------------------------------------------
# 	Source for this listing: http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
#	--------------------------------------------------------------------------
#
#	Black       0;30     Dark Gray     1;30
#	Blue        0;34     Light Blue    1;34
#	Green       0;32     Light Green   1;32
#	Cyan        0;36     Light Cyan    1;36
#	Red         0;31     Light Red     1;31
#	Purple      0;35     Light Purple  1;35
#	Brown       0;33     Yellow        1;33
#	Light Gray  0;37     White         1;37
#
###



# Constructor time
sub new {
	my $self = {};
	bless ( $self , "ZabbixChecks" );
	print "Hello from ZabbixChecks Module!";
	return $self;
} 



1;