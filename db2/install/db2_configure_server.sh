#!/bin/bash
#
# configure a server for a database
#

# sourcing functions
. $PWD/shell_libs.sh

#
# defining globals
#

DB2SERVICENAME=""
DB2SERVICEPORT=""
DB2I_USER=db2inst1
DB2HOME=/opt/IBM/db2/V8.1
DB2EXE=db2
PROMPT_ON_ERROR="EXIT"

function helpfunc {
    echo "$0 creates and configures a service for db2"
    echo "usage: $0 --servicename <servicename> [--port <port>] [--db2i_user <user>] [--db2home <home_dir>]"
    echo ""
    echo "--db2home:        home directory of db2, default: /opt/IBM/V8.1"
    echo "--db2i_user:      instance owner user, default db2inst1"
    echo "--servicename:    name of the service"
    echo "--port:           port of the service"
    echo "--help:           display this help"
}

function get_options {

while true ; do
        case $1 in
		--db2home) DB2HOME=$2; shift 2;
			   if [ ! -d "$DB2HOME" ] ; then
				echo "$DB2HOME does not exist! Exit now!"
				exit 1;
			   fi
			   ;;
		--db2i_user) DB2I_USER=$2; shift 2;
			    check_user_id $DB2I_USER
			    check_error
			    ;;
		--servicename) DB2SERVICENAME=$2; shift 2;
			    echo -n "checking service $DB2SERVICENAME .. "
			    $PWD/db2_manipulate_services.pl --find --service $DB2SERVICENAME
			    check_error
			    ;;
		--port) DB2SERVICEPORT=$2; shift 2;
			echo -n "checking port $DB2SERVICEPORT .. "
			$PWD/db2_manipulate_services.pl --find --port $DB2SERVICEPORT
			check_error
			;;
		--help) helpfunc
			exit 1
			;;

		*) if [ ! -z "$1" ] ; then
			echo "unknown option: $1 ! Exit now!";
			exit 1;
		   fi
		   break;;
	esac
done
}

get_options $@
if [ -z "$DB2SERVICENAME" ] ; then
    echo "You have to specify a servicename!"
    echo "use $0 --help to diplay help messages."
    exit 1
fi
if [ -z "$DB2SERVICEPORT" ] ; then
    echo "You have to specify a serviceport!"
    echo "use $0 --help to diplay help messages."
    exit 1
fi

if [ ! -d "$DB2HOME" ] ; then
    echo "$DB2HOME does not exist!"
    echo "use $0 --help to diplay help messages."
    exit 1;
fi 

if [ ! -f "/home/$DB2I_USER/sqllib/db2profile" ] ; then
    echo "The file /home/$DB2I_USER/sqllib/db2profile does not exist."
    echo "May be the instance owner of db2 is wrong."
    echo "use $0 --help to diplay help messages."
    exit 1
fi

if [ ! -f "$DB2HOME/bin/db2" ] ; then
    echo "The file $DB2HOME/bin/db2 does not exist."
    echo "May be the Home directory of DB2 is wrong."
    echo "use $0 --help to diplay help messages."
    exit 1
fi


echo -n "Adding $DB2_SERVICENAME to /etc/services .. "
ERR_MESSAGE=`./db2_manipulate_services.pl --add --service $DB2SERVICENAME --port $DB2SERVICEPORT 2>&1`
check_error
. /home/$DB2I_USER/sqllib/db2profile
echo -n "update database manager configuration .. "
ERR_MESSAGE=`su - $DB2I_USER -c "db2 update database manager configuration using svcename $DB2SERVICENAME  2>&1"`
check_error
echo -n "setup tcpip .. "
ERR_MESSAGE=`su - $DB2I_USER -c "db2set DB2COMM=tcpip 2>&1"`
check_error
echo -n "Stopping db2 .. "
ERR_MESSAGE=`su - $DB2I_USER -c "db2 db2stop"`
check_error
echo -n "Starting db2 .. "
ERR_MESSAGE=`su - $DB2I_USER -c "db2 db2start"`
check_error
echo "Displaying configuration. "
db2 get database manager configuration | less
			    