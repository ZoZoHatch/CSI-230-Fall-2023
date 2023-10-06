#!/bin/bash

#Storyline: Create peer VPN configuration file


# What is peer's name
echo -n "What is the peer's name? "
read the_client

# Filename variable
pFile = "${the_client}-wg0.conf"

# Check if the peer file exists
if [[ -f "${pFile}" ]]
then

    # Prompt if we need to overwrite the file
    echo "The file ${pFile} exists."
    echo -n "Do you want to overwrite it? [y/N]"
    read to_overwrite

    if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" || "${to_overwrite}" == "" ]]
    then

        echo "Exit..."
        exit 0

    elif [[ "${to_overwrite}" == "y" || "${to_overwrite}" == "Y" ]]
    then

        echo "Creating the wireguard config file..."

    else    # if not y || n then error

        echo "Invalid value"
        exit 1

    fi

fi

# Create private key
p="$(wg genkey)"

# Create public key
pub="$(echo ${p} | wg pubkey)"

# Gererate preshared key
pre="$(wg genpsk)"

# Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"

# Server Public key
pub="$(head -1 wg0.conf | awk ' { print $4 } ')"

# DNS server
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

# KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

# Listen port
lport="$(shuf -n1 -i 40000-50000)"

# Default routes for VPN
routes="$(dns="$(head -1 wg0.conf | awk ' { print $8 } ')"

# Create peer conf file
echo "[Interface]
Address = 10.2254.132.100/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[Peer]
AllowedIPS = ${routes}
PeersistentKeepAlive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pFile}

# Add our peer config to the server congfig
echo "# ${the_client} begin
[Peer]
Publickey = ${pub}
Presharedkey = ${pre}
AllowedIPS = ${routes}
# ${the_client} end" | tee -a wg0.conf

# Restart wire guard
wg addconf wg0 <(wg-quick strip wg0)

# Copy file to /etc/wireguard
cp wg0.conf /etc/wireguard