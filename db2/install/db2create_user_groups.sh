#!/bin/bash
##########################################
#
# script to configure db2 after manual installation
#
# frank balzer 2004, frank.balzer@suse.com
#

#
# global variables and default values
#

#home of db2
DB2HOME=/opt/IBM/db2/V8.1
#home base for db2 users
#may be /opt/IBM/db2/V8.1/home ???
DB2USERBASE=/home
#executables 
DASBIN=$DB2HOME/instance/dascrt
INSTANCEBIN=$DB2HOME/instance/db2icrt
#auth option
AUTHTYPE=server
#license file
#LICENSE=/home/db2install/ese/db2/license/db2ese.lic
LICENSE=""
LICENSEBIN=$DB2HOME/adm/db2licm
# user and groups
DB2I_USER=db2inst1
DB2I_UID=9000
DB2I_GROUP=db2grp1
DB2I_GID=9000

DB2AS_USER=db2as
DB2AS_UID=9001
DB2AS_GROUP=db2asgrp
DB2AS_GID=9001

DB2F_USER=db2fenc1
DB2F_UID=9002
DB2F_GROUP=db2fgrp1
DB2F_GID=9002


. $PWD/shell_libs.sh





	


function helpfunc {

echo "$0 creates usergroups, users needed by db2 as well as a DAS-Server and an instance"
echo "usage: $0 [options] license_file"
echo "options:"
echo "--db2home:        home directory of db2, default: /opt/IBM/V8.1"
echo "--db2userbase:    home base for db2 system users: /home"   
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

function lisence_error {

echo "Liscence file is missing or do not exists"
echo "usage: $0 [options] lisence_file"
echo " "
echo "use --help option to display help messages"
echo " "
}



#
# checkung for errors
#	if an error occurs, the function prompts to go on or exit
#


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
		--db2homebase) DB2USERBASE=$2 shift 2;
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
			LICENSE=$1
			if [ ! -f "$LICENSE" ] ; then
				echo "unknown option or license file does not exist: $1 ! Exit now!";
				exit 1;
			fi
		   fi
		   break;;
		
		esac
done
if [ -z "$LICENSE" ] ; then
	echo "License file parameter is missing."
	echo "use $0 --help to display help"
	exit 1
fi
}	

test_for_root
get_options $@
#
# adding groups
#
echo -n "Adding group $DB2I_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2I_GID $DB2I_GROUP 2>&1`
check_error
echo -n "Adding group $DB2AS_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2AS_GID $DB2AS_GROUP 2>&1`
check_error
echo -n "Adding group $DB2F_GROUP ... "
ERR_MESSAGE=`groupadd -g $DB2F_GID $DB2F_GROUP 2>&1`
check_error

if [ ! -d "$DB2USERBASE" ] ; then
    echo -n "Adding directoy $DB2HOME ... "
    ERR_MESSAGE=`mkdir -p $DB2USERBASE`
    check_error
fi
#
# adding users
#
echo -n "Adding user $DB2I_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2USERBASE/$DB2I_USER -g $DB2I_GROUP -u $DB2I_UID \
		-s /bin/bash -c "DB2 instance owner" $DB2I_USER \
		-G $DB2AS_GROUP 2>&1`
check_error
echo -n "Adding user $DB2AS_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2USERBASE/$DB2AS_USER -g $DB2AS_GROUP -u $DB2AS_UID \
		-s /bin/bash -c "DB2 administration server user" $DB2AS_USER 2>&1` 
check_error
echo -n "Adding user $DB2F_USER ... "
ERR_MESSAGE=`useradd -m -d $DB2USERBASE/$DB2F_USER -g $DB2F_GROUP -u $DB2F_UID \
		-s /bin/bash -c "DB2 fenced user" $DB2F_USER 2>&1`
check_error
#
# create db2 administration server
#
echo -n "Adding db2 administration server ... "
ERR_MESSAGE=`$DASBIN -u $DB2AS_USER 2>&1`
check_error
#
# create an instance
#
echo -n "Adding an instance $DB2I_USER ... "
ERR_MESSAGE=`$INSTANCEBIN -a $AUTHTYPE -u $DB2F_USER  $DB2I_USER 2>&1`
check_error
#
# installing the license
#
echo -n "Adding license file $LICENSE ... "
ERR_MESSAGE=`$LICENSEBIN -a $LICENSE 2>&1`
check_error


