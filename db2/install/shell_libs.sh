#
# shell functions 
#

ERR=0
ERR_MESSAGE=""
PROMPT_ON_ERROR="TRUE"

function test_for_root {
	if [ ! $UID -eq 0 ] ; then
		echo "You have to be root to execute this script!"
		echo "Exit now!"
		exit 1
	fi
} 



function reset_error {
ERR=0
ERR_MESSAGE=""

}

function get_key {
	stty raw
	eval $1='`dd bs=1 count=1 2>/dev/null`'
	stty cooked
}

function check_error {
ERR=$?

if [ $ERR == 0 ] ; then
	echo "OK"
else 
	echo "Errorcode: $ERR"
	echo "$ERR_MESSAGE"
	if [ "$PROMPT_ON_ERROR" == "TRUE" ] ; then 
	    echo "Press 'y' to go on or 'q' to exit."
	    while true; do
		    get_key ANSWER
		    if [ "$ANSWER" == "y" ] ; then
			    break;
		    elif [ "$ANSWER" == "q" ] ; then
			    exit 1;
		    fi
	    done
	elif [ "$PROMPT_ON_ERROR" == "EXIT" ] ; then
	    exit 1
	fi    
fi
reset_error
}

function check_user_id {
    ERR_MESSAGE=`id $1 2>&1`
}