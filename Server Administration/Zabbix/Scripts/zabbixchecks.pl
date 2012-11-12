#!/usr/bin/perl

##############################################################################################
#
#
#			   _____        _      _      _           ___  _                  _         
#			  / _  /  __ _ | |__  | |__  (_)__  __   / __\| |__    ___   ___ | | __ ___ 
#			  \// /  / _` || '_ \ | '_ \ | |\ \/ /  / /   | '_ \  / _ \ / __|| |/ // __|
#			   / //\| (_| || |_) || |_) || | >  <  / /___ | | | ||  __/| (__ |   < \__ \
#			  /____/ \__,_||_.__/ |_.__/ |_|/_/\_\ \____/ |_| |_| \___| \___||_|\_\|___/
#
#
#       @file			zabbix.checks.pl
#       @description	This is a script that will run when Zabbix talks to the server and asks
#							for data. Arguments will be provided to it in the command line for 
#                       	each data metric and it'll just be awesome. Enjoy.
#       @author         Pierce Moore
#       @site           http://www.piercemoore.com
#       @license        Just normal open source stuff. Use it, love it, make it better. Just 
#                       	give me credit.
#
##############################################################################################

###
# Let's include some Perl modules so that we can easily work with this script
###
use strict;
use warnings;
use Getopt::Long;
#use ZabbixChecks;
# use Config::Simple;

###
# Let's read the config file into the current program and parse it.
###
# $conf = new Config::Simple('zabbixchecks.conf');

# Then let's define some colors for use in messaging
our $ANSI_black		=	"\033[0;30m";
our $ANSI_brown		=	"\033[0;33m";
our $ANSI_yellow		=	"\033[1;33m";
our $ANSI_white		=	"\033[1;37m";
our $ANSI_blue		=	"\033[0;34m";
our $ANSI_blue_lt	=	"\033[1;34m";
our $ANSI_green		=	"\033[0;32m";
our $ANSI_green_lt	=	"\033[1;32m";
our $ANSI_cyan		=	"\033[0;36m";
our $ANSI_cyan_lt	=	"\033[1;36m";
our $ANSI_red		=	"\033[0;31m";
our $ANSI_red_lt		=	"\033[1;31m";
our $ANSI_purple		=	"\033[0;35m";
our $ANSI_purple_lt	=	"\033[1;35m";
our $ANSI_grey_lt	=	"\033[1;30m";
our $ANSI_grey_dk	=	"\033[0;37m";
our $ANSI_clear		=	"\033[0m";

###
# Let's bring in the ZabbixChecks helper object
###
#my $zc = ZabbixChecks->new();

###
# And now that's out of the way, let's start working with arguments and options/flags
###
# Count arguments first
my $argCount = $#ARGV + 1;

###
# Now let's see if they called any specific flags
###
my %options = ();

GetOptions(
	"h|H|?|help"	=>	\$options{help},
	"r|reload"		=>	\$options{reload},
	"R|restart"		=>	\$options{restart},
	"s|start"		=>	\$options{start},
	"S|stop"		=>	\$options{stop},
	"v|version"		=>	\$options{version},
	"V|verbose"		=>	\$options{verbose},
	"c=s"	=>	\$options{configFile},
	"config=s"	=>	\$options{configFile},
	"get=s"			=>	\$options{getParam}
);

###
# Before we do anything else, let's see if a flag was used. If so, we're going to just do that and stop.
###
#$zc->init( $options );

show_help() if defined $options{help};

print "[ $ANSI_blue_lt";
print %options;
print "] $ANSI_clear";

foreach( @ARGV ) {
	print "[ $ANSI_green_lt $_ $ANSI_clear ]\n";
}

if ( $argCount != 1 ) {

#	print "\nUsage: zabbix.checks.pl \[\03[32m\] metric ";
	print "$ANSI_blue_lt Metric here $ANSI_clear \n \n";
}

###
# Let's create our subroutines
###
sub show_help {
	print "
#################################################################
#                    ZabbixChecks Help                          #
#################################################################
	$ANSI_green_lt Usage: $ANSI_clear 
		zabbixchecks get [$ANSI_green_lt metric $ANSI_clear]
		zabbixchecks -[$ANSI_green_lt switch $ANSI_clear]
		zabbixchecks [ start | stop | reload | restart | status ]

	Available switches:
		[-h,-H,--help] 		: $ANSI_grey_dk Show this help file $ANSI_clear
		[ -v  , --version ] 	: $ANSI_grey_dk Show the version number of this installation $ANSI_clear
		[$ANSI_red_lt -V , --verbose $ANSI_clear] 	: $ANSI_red_lt Show verbose output ( $ANSI_yellow WARNING: $ANSI_red_lt Not recommended while Zabbix agent is running!!! $ANSI_red ) $ANSI_clear
		[ -r , --reload ] 	: $ANSI_cyan Reload configuration $ANSI_clear
		[ -R , --restart ] 	: $ANSI_cyan_lt Restart the ZabbixChecks helper $ANSI_clear
		[ -s , --start ] 	: $ANSI_green_lt Start the ZabbixChecks helper $ANSI_clear
		[$ANSI_red_lt -S $ANSI_clear] 			: $ANSI_red_lt Stop the ZabbixChecks helper $ANSI_clear
		[ -c ] 			: $ANSI_purple_lt Load your own custom config file $ANSI_clear
		
	------------------------------------------------------------
	For a complete list of ZabbixChecks metrics, run 'zabbixchecks --params'
";
	exit;
}

exit;
