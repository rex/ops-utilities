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
# Let's read the config file into the current program and parse it.
###
source ./zabbixchecks.conf

###
# Let's include some handy functions that will do the heavy lifting for the daemon
###
source /etc/rc.d/init.d/functions

# Then let's define some colors for use in messaging
ANSI_black='\e[0;30m'
ANSI_brown='\e[0;33m'
ANSI_yellow='\e[1;33m'
ANSI_white='\e[1;37m'
ANSI_blue='\e[0;34m'
ANSI_blue_lt='\e[1;34m'
ANSI_green='\e[0;32m'
ANSI_green_lt='\e[1;32m'
ANSI_cyan='\e[0;36m'
ANSI_cyan_lt='\e[1;36m'
ANSI_red='\e[0;31m'
ANSI_red_lt='\e[1;31m'
ANSI_purple='\e[0;35m'
ANSI_purple_lt='\e[1;35m'
ANSI_grey_lt='\e[1;30m'
ANSI_grey_dk='\e[0;37m'
ANSI_clear='\e[0m'

# Column number to place the status message
RES_COL=60
# Command to move out to the configured column number
MOVE_TO_COL="echo -en \\033[${RES_COL}G"

###
# Before we can do anything else, we have to create our subroutines
###
function show_help {
echo -e "
#################################################################
#                    ZabbixChecks Help                          #
################################################################# $ANSI_green_lt
Usage: $ANSI_clear 
   zabbixchecks get [$ANSI_green_lt metric $ANSI_clear]
   zabbixchecks -[$ANSI_green_lt switch $ANSI_clear]
   zabbixchecks [$ANSI_green_lt start $ANSI_clear|$ANSI_red_lt stop $ANSI_clear| reload | restart | status ] $ANSI_green_lt

Available switches: $ANSI_clear
   [ -h,-H,? ] 	:  Show this help file 
   [ -v ] 	:  Show the version number of this installation
   [$ANSI_red_lt -V $ANSI_clear] 	: $ANSI_red_lt Show verbose output ( $ANSI_yellow WARNING: $ANSI_red_lt Not recommended while Zabbix agent is running!!! $ANSI_red ) $ANSI_clear
   [ -r ] 	: $ANSI_cyan Reload configuration $ANSI_clear
   [ -R ] 	: $ANSI_cyan Restart the ZabbixChecks helper $ANSI_clear
   [ -s ] 	: $ANSI_green_lt Start the ZabbixChecks helper $ANSI_clear
   [$ANSI_red_lt -S $ANSI_clear] 	: $ANSI_red_lt Stop the ZabbixChecks helper $ANSI_clear
   [ -c ] 	:  Load your own custom config file
   [ -m ]	:  Display a complete list of metrics tracked by ZabbixChecks $ANSI_green_lt

Example Commands: $ANSI_clear
   ---- $ANSI_blue_lt Get $ANSI_clear ----
   zabbixchecks get mysql.status[uptime]
   zabbixchecks get mysql.current[loggedinusers]
   zabbixchecks get mysql.size[table,orders]
   zabbixchecks get cpu.load
   zabbixchecks get backup.age

   ---- $ANSI_blue_lt Switch Commands $ANSI_clear ----
   zabbixchecks -c /path/to/custom/config/file.conf
   zabbixchecks -r
   zabbixchecks -R
   zabbixchecks ?

   ---- $ANSI_blue_lt Command Arguments $ANSI_clear ----
   zabbixchecks start
   zabbixchecks restart
   zabbixchecks reload
   zabbixchecks stop
   zabbixchecks status

"
}

function show_message {
	
	$MOVE_TO_COL

	case $1 in
		success)
			COLOR=$ANSI_green_lt
			;;
		error)
			COLOR=$ANSI_red_lt
			;;
		info)
			COLOR=$ANSI_cyan
			;;
		warning)
			COLOR=$ANSI_yellow
			;;
	esac

	echo -en "[$COLOR $2 $ANSI_clear]"
	echo -ne "\r"
	echo ""
}

function show_version {

echo -ne "$ANSI_blue_lt
ZabbixChecks $ANSI_clear
Version:"

show_message info $conf_version

}

function make_verbose {

    echo -n $"Enabling verbose messages: "
	conf_verbose="1"
	echo_success
	echo ""
}

function do_check {

	if [ $conf_verbose == "1" ]; then
		echo -n "Checking metric:"
		show_message info $1
	fi

	case "$1" in

		"mysql.status[uptime]")
			VAL=$(mysqladmin -u$conf_mysql_user -p$conf_mysql_pass status)
			;;
		*)
			echo -n $"Attempting metric $1..."
			show_message error "$1 not found"
			;;
	esac

	if [ $conf_verbose == "1" ]; then
		echo -n "Current Value:"
		if [ ${#VAL} -lt 10 ]; then
			show_message info $VAL
		else
			show_message error "Too Long"
			echo "-----------------------------------"
			echo "Value too large for standard display, printing below:"
			echo ""
			echo $VAL
			echo ""
		fi
	else
		echo $VAL
	fi
}

###
# And now that's out of the way, let's start working with arguments and options/flags
###
while getopts "hHvV:rRsSc:m" OPTION
do 
	case $OPTION in
		h|H|"?")
			show_help
			;;
		v)
			show_version
			;;
		V)
			make_verbose
			do_check $OPTARG
			;;
		r)	
			do_reload
			;;
		R)
			do_restart
			;;
		s)	
			do_start
			;;
		S)
			do_stop
			;;
		c)
			CONF_FILE=$OPTARG
			do_customconfig
			do_check
			;;
		m)
			show_metrics
			;;
	esac
done

###
# Once we are past the command-line options, let's get into the real meat of ZabbixChecks
###
case "$1" in
	get)
		do_check $2
		;;
	start)
		do_start
		;;
	stop)
		do_stop
		;;
	restart)
		do_restart
		;;
	reload)
		do_reload
		;;
	status)
		do_statuscheck
		;;
esac

exit