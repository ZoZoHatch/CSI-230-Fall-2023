#!/bin/bash

# Storyline: a script to create a wireguard server


# Create private key
p="$(wg genkey)"

# Create public key
pub="$(echo ${p} | wg pubkey)"

# Set the addresses
address="10.254.132.0/24,127.16.28.0/24"

# Set server IP addressses
serverAddress="10.254.132.1/24,127.16.28.1/24"

# Set the Listen port
lport="4282"

# Create the format for the client config options
peerInfo="# ${address} 162.243.2.92:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

#default config
: '
[Interface]
Address = 10.254.132.1/24,172.16.28.1/24
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = 4282
PrivateKey =
'

echo "${peerInfo}
[Interface]
Address = ${serverAddress}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport}
PrivateKey = ${p}
" > wg0.conf
