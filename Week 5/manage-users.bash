#! /bin/bash

# Storyline: Script to add and delete VPN peers

while getopts 'hdaeu:' OPTION ; do

    case "$OPTION" in

        d) u_del=${OPTION}
        ;;
        a) u_add=${OPTION}
        ;;
        e) u_exists=${OPTION}
        ;;
        u) t_user=${OPTARG}
        ;;
        h)
            echo ""
            echo "Useage: $(basename $0) [-a]|[-d]|[-e] -u username"
            echo ""
            exit 1
        ;;
        *)
            echo "Invalid value."
            exit 1
        ;;    

    esac
done

# Check to see if -a and -d are empty or if they are both specified throw an error
if [[ (${u_del} == "" && ${u_add} == "" && ${u_exists} == "") 
    || (${u_del} != "" && ${u_add} != "" && ${u_exists} != "") ]]
then

    echo "Please specify -a or -d or -e and -u with a username"

fi

# Check to ensure that -u is specified
if [[ (${u_del} != "" || ${u_add} != "" || ${u_exists} != "") && ${t_user} == "" ]]
then

    echo "Please specify a user! (-u)"
    echo "Useage: $(basename $0) [-a]|[-d] -u username"
    exit 1

fi

# Delete a user
if [[ ${u_del} ]]
then

    echo "Deleting user..."
    sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf

fi

# Add a user
if [[ ${u_add} ]]
then

    echo "Creating user..."
    bash peer.bash ${t_user}

fi

# Check if user exists
if [[ ${u_exists} ]]
then 

    echo "Checking for user..."  

    if [[ grep -q ${t_user} "wg0.conf" ]]
    then

        echo "That user exists"

    else
        
        echo "That user doesn't exist"

    fi
fi

