#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Set switches for which firewall formats to use
while getopts 'icwmp' OPTION ; do
    case "$OPTION" in

        i) 
            f_IPtable=${OPTION}
        ;;
        c) 
            f_cisco=${OPTION}
        ;;
        w) 
            f_windows=${OPTION}
        ;;
        m) 
            f_macOS=${OPTION}
        ;;
        p) 
            p_cisco=${OPTION}
        ;;        
        *)
            echo "Invalid value."
            exit 1
        ;;    
    esac
done

# if no switch, throw error
if [[ f_IPtable == "" && f_cisco == "" && f_windows == "" && f_macOS == "" ]]
then

    echo "Please specify at least one switch: "
    echo "-i: iptables"
    echo "-c: cisco"
    echo "-w: windows"
    echo "-m: macOS"
    exit 1

fi

pFile="emerging-drop.suricata.rules"

# Check if the rules file already exists
if [[ -f "${pFile}" ]]
then

    # Prompt if we want to download the file again
    echo "The file ${pFile} already exists."    
    read -p "Do you want to download it again? [y/N]" to_overwrite

    if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" || "${to_overwrite}" == "" ]]
    then

        echo "Skipping download..."

    elif [[ "${to_overwrite}" == "y" || "${to_overwrite}" == "Y" ]]
    then

        # Download the list of IPs to block
        echo "Downloading file from rules.emergingthreats.net..."
        wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -0 /tmp/${pFile} 

    else    # if not y || n then error

        echo "Invalid value"
        exit 1

    fi
else

    # Download the list of IPs to block
    echo "Downloading file from rules.emergingthreats.net..."
    wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -0 /tmp/${pFile} 

fi

# Regex to extract the IPs
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/${pFile} 
| sort -u | tee badIPs.txt

# Regex to get IPs w/o the tailing number
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badIPs.txt | tee badIPs_notail.txt
 
if [[ ${f_macOS} ]]
then
    # Add header to Apple firewall file so Mac doesn't get angry
    echo '

    scrub-anchor "com.apple/*"
    nat-anchor "com.apple/*"
    rdr-anchor "com.apple/*"
    dummynet-anchor "com.apple/*"
    anchor "com.apple/*"
    load anchor "com.apple" from "/etc pf.anchors/com.apple"

    ' | tee pf.conf
fi

# Create firewall rulesets
for eachIP in $(cat badIPs.txt)
do
    # iptable firewall format
    if [[ ${f_IPtable} ]]
    then
        echo "iptables -a INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
    fi
    
    # Apple firewall format
    if [[ ${f_macOS} ]]
    then
        echo "block in from ${eachIP} to any" | tee -a pf.conf
    fi
done

for eachIP in $(cat badIPs_notail.txt)
do
    # cisco firewall format
    if [[ ${f_cisco} ]]
    then
        echo "deny ip host ${eachip} any" | tee -a badips.cisco
    fi

    # windows firewall format
    if [[ ${f_windows} ]]
    then
        echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
    fi
done

# Parse Cisco file
if [[ ${c} ]]
then

    # Get the file to parse
    wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -0 /tmp/targetedthreats.csv

    # Get the line that have a domain
    egrep '"domain"' /tmp/targetedthreats.csv | tee temp_threats.txt 

    # Add a header to the file
    echo "class-map match-any BAD_URLS" | tee ciscothreats.txt

    for eachIP in $(cat temp_threats.txt)
    do
        dom=${eachIP} | cut -d\, -f2    
        echo "match protocol http host ${dom}" | tee -a ciscothreats.txt
    done

    rm temp_threats.txt
fi

exit 0