#!/bin/bash

# Storyline: Script to perform local security checks

# Function to help check policy compliance
function checks() {

    if [[ $2 != $3 ]]
    then

        echo "The $1 is not compliant. The current policy should be: $2. Current Value is: $3."

    else

        echo "The $1 policy is compliant. Current Value is: $3."

    fi
}

# Check the password max days policy
pmax=$(egrep -i "^PASS_MAX_DAYS" /etc/login.defs | awk " { print $2 } ")
checks "Password Max Days" "365" "${pmax}"

# Check the password min days before change policy
pmin=$(egrep -i "^PASS_MIN_DAYS" /etc/login.defs | awk " { print $2 } ")
checks "Password Min Days" "14" "${pmin}"

# Check password age warning policy
page=$(egrep -i "^PASS_WARN_AGE" /etc/login.defs | awk " { print $2 } ")
checks "Password Age Warning" "7" "${page}"

# Check the SSH UsePAM configuration
chckSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk " { print $2 } ")
checks "SSH UsePAM" "yes" "${chckSSHPAM}"

# Check permission on users home directory
echo ""
for eachDir in $(ls -l /home } | egrep "^d" | awk " { print $3 } ")
do

    chDir=$(ls -ld /home/${eachDir} | awk " { print $1 } ")
    checks "Home directory ${eachDir}" "drwx------" "${chDir}"

done

# Check ip forward is disabled
ipForward=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* )
checks "IP forwarding" "net.ipv4.ip_forward = 0" ${ipForward}

# Check  