#!/bin/bash


DB2NODE=""
DB2DATABASE=""
DB2SERVER=""
DB2SERVICE=""
DB2PORT=""
#home of db2
DB2HOME=/opt/IBM/db2/V8.1
#home base for db2 users
#may be /opt/IBM/db2/V8.1/home ???
DB2USERBASE=/home
#executables 
INSTANCEBIN=$DB2HOME/instance/db2icrt
#auth option
AUTHTYPE=server
# user and groups
DB2I_USER=db2inst1
DB2I_UID=9000
DB2I_GROUP=db2grp1
DB2I_GID=9000

DB2AS_USER=db2as
DB2AS_UID=9001
DB2AS_GROUP=db2asgrp
DB2AS_GID=9001


## do we need this
DB2F_USER=db2fenc1
DB2F_UID=9002
DB2F_GROUP=db2fgrp1
DB2F_GID=9002

. $PWD/shell_libs


function helpfunc {

echo "$0 creates usergroups, users needed by db2 and configure the connection to the db server"
echo "usage: $0 [options]"
echo "options:"
echo "--db2home:        home directory of db2, default: /opt/IBM/V8.1"
echo "--db2homebase:    home base for db2 system users: /home"
echo "--db2node:        the name of the node, added to your node directory"
echo "--db2database:    the name of the database, residing on the server"
echo "--db2service:     a name for the service, which should be added to your services file"
echo "--db2port:        a port used by the service, corresponding to the port on the server"    
echo "--db2i_user:      instance owner user, default db2inst1"
echo "--db2i_uid:       instance owner uid , default 9000"
echo "--db2i_group:     instance owner group, default is db2grp1"
echo "--db2i_gid:       instance owner group gid , default 9000"
echo "--db2as_user:     administration server user, default db2as"
echo "--db2as_uid:      administration server user uid , default 9001"
echo "--db2as_group:	administration server group, db2asgrp"
echo "--db2as_gid:      administration server group gid , default 9001"
echo "--db2f_user:      fenced user, default db2fenc1"
echo "--db2f_uid:       fenced user uid , default 9002"
echo "--db2f_group:     fenced user group, default is db2fgrp1"
echo "--db2f_gid:       fenced user group gid , default 9002"
echo "--authtype type:  authentification type of an instance, default is server"
echo "                  possible values are:"
echo "                           server"
echo "                           client"
echo "                           dcs"
echo "                           server_enrypt"
}


#checking all options
function get_options {

while true ; do
	echo $1
        case $1 in
		--db2home) DB2HOME=$2; shift 2;
			   if [ ! -d "$DB2HOME" ] ; then
				echo "$DB2HOME does not exist! Exit now!"
				exit 1;
			   fi
			   ;; 
		--db2homebase) DB2HOMEBASE=$2 shift 2;
			   ;;
	        --db2node) DB2NODE=$2; shift 2;
			   ;;
		--db2database) DB2DATABASE=$2; shift 2;
			    ;;
		--db2service) DB2SERVICE=$2; shift 2;
			    echo -n "checking service $DB2SERVICE .. "
			    $PWD/db2_manipulate_services.pl --find --service $DB2SERVICE
			    check_error
			    ;;
	        --db2port) DB2PORT=$2; shift 2;
			    echo -n "checking port $DB2PORT .. "
			    $PWD/db2_manipulate_services.pl --find --port $DB2PORT
			    check_error
			    ;;
				
		--db2i_user) DB2I_USER=$2; shift 2;;
		--db2i_uid)  DB2I_UID=$2; shift 2;
			     if [ ! $DB2I_UID -gt 99 ] ; then
				echo "db2i_uid [$DB2I_UID] is smaller than 100! Exit now!"
				exit 1;
			     fi
			     ;;
		--db2i_group) DB2I_GROUP=$2; shift 2;;
		--db2i_gid)  DB2I_GID=$2; shift 2;
                             if [ ! $DB2I_GID -gt 99 ] ; then
                                echo "db2i_gid [$DB2I_GID] is smaller than 100! Exit now!"
                                exit 1;
                             fi
                             ;;
		--db2as_user) DB2AS_USER=$2; shift 2;;
                --db2as_uid)  DB2AS_UID=$2; shift 2;
                             if [ ! $DB2AS_UID -gt 99 ] ; then
                                echo "db2as_uid [$DB2AS_UID] is smaller than 100! Exit now!"
                                exit 1;
                             fi
                             ;;
                --db2as_group) DB2AS_GROUP=$2; shift 2;;
                --db2as_gid)  DB2AS_GID=$2; shift 2;
                             if [ ! $DB2AS_GID -gt 99 ] ; then
                                echo "db2as_gid [$DB2AS_GID] is smaller than 100! Exit now!"
                                exit 1;
                             fi
                             ;;
		--db2f_user) DB2F_USER=$2; shift 2;;
                --db2f_uid)  DB2F_UID=$2; shift 2;
                             if [ ! $DB2F_UID -gt 99 ] ; then
                                echo "db2f_uid [$DB2F_UID] is smaller than 100! Exit now!"
                                exit 1;
                             fi
                             ;;
                --db2f_group) DB2F_GROUP=$2; shift 2;;
                --db2f_gid)  DB2F_GID=$2; shift 2;
                             if [ ! $DB2F_GID -gt 99 ] ; then
                                echo "db2F_gid [$DB2F_GID] is smaller than 100! Exit now!"
                                exit 1;
                             fi
                             ;;
		--authtype) case $2 in
				server) AUTHTYPE=$2; shift 2;;
				client) AUTHTYPE=$2; shift 2;;
				dcs) AUTHTYPE=$2; shift 2;;
				server_encrypt) AUTHTYPE=$2; shift 2;;
				*) echo "unknown value for authtype."
				   echo "possible values are server,client,dcs, server_encrypt."
				   echo "exit now!"
				   ;;
			     esac
			     ;;
		--help) helpfunc; exit 1;;
		*) if [ ! -z "$1" ] ; then
			echo "unknown option: $1 ! Exit now!"
			echo "use $0 --help"  
			exit 1;
		   fi
		   break;;
		
		esac
done

test_for_root
get_options $@


echo -n "Adding group $DB2I_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2I_GID $DB2I_GROUP 2>&1`
check_error
echo -n "Adding group $DB2AS_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2AS_GID $DB2AS_GROUP 2>&1`
check_error
echo -n "Adding group $DB2F_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2F_GID $DB2F_GROUP 2>&1`
check_error

if [ ! -d "$DB2HOMEBASE" ] ; then
    echo -n "Adding directoy $DB2HOME ... "
    ERR_MESSAGE=`mkdir -p $DB2HOMEBASE`
    check_error
fi
#
# adding users
#
echo -n "Adding user $DB2I_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2HOMEBASE/$DB2I_USER -g $DB2I_GROUP -u $DB2I_UID \
		-s /bin/bash -c "DB2 instance owner" $DB2I_USER \
		-G $DB2AS_GROUP 2>&1`
check_error
echo -n "Adding user $DB2AS_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2HOMEBASE/$DB2AS_USER -g $DB2AS_GROUP -u $DB2AS_UID \
		-s /bin/bash -c "DB2 administration server user" $DB2AS_USER 2>&1` 
check_error
echo -n "Adding user $DB2F_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2HOMEBASE/$DB2F_USER -g $DB2F_GROUP -u $DB2F_UID \
		-s /bin/bash -c "DB2 fenced user" $DB2F_USER 2>&1`
check_error


if [ -z $DB2NODE ] ; then
    echo "option --db2node is missing."
    echo "use $0 --help to diplay help messages."
    exit 1
fi 
if [ -z $DB2DATABASE ] ; then
    echo "option --db2database is missing."
    echo "use $0 --help to diplay help messages."
    exit 1
fi 
if [ -z $DB2SERVICE ] ; then
    echo "option --db2service is missing."
    echo "use $0 --help to diplay help messages."
    exit 1
fi 
if [ -z $DB2PORT ] ; then
    $PWD/db2_manipulate_services.pl --find --service $DB2SERVICE --reverse
    if [ $? != 0 ] ; then
	echo "Service $DB2SERVICE is not defined!"
	echo "You have to set the --db2port option."
	echo "use $0 --help to diplay help messages."
	exit 1
    fi
else
    PROMPT_ON_ERROR="EXIT"
    echo -n "Checking Service .. "
    $PWD/db2_manipulate_services.pl --find --service $DB2SERVICE --reverse
    check_error
    echo -n "Checking Port .. "
    $PWD/db2_manipulate_services.pl --find --port $DB2PORT --reverse
    check_error
    $PWD/db2_manipulate_services.pl --add --service $DB2SERVICE --port $DB2PORT
    check_error
fi
    
    


echo -n "Cataloging client connection .. "
ERR_MESSAGE=`su - $DB2I_USER -c "db2 catalog tcpip node $DB2NODE remote $DB2SERVER server $DB2SERVICE"`
check_error