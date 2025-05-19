#!/bin/bash

if [[ $# < 1 ]] then
	echo "Usage: $0 <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]"
	exit
fi

# Credentials
VPN_USER="${2:-replace this}"
VPN_CERT="${4:-replace this}"
VPN_PASS="${3:-replace this}"

# Regex pattern for output to ignore
FILTER_PATTERN="replace this"
# Regex pattern to reconnect on
RECONNECT_PATTERN="CSTP Dead Peer Detection detected dead peer!|DTLS handshake failed: Resource temporarily unavailable, try again."

while true; do
	# Connection
	echo "$VPN_PASS" | sudo openconnect "$1" \
	-u "$VPN_USER" \
	--servercert "$VPN_CERT" \
	2>&1 | {
		while read -r line; do
			# Check whether to filter
			echo "$line" | grep -qP "$FILTER_PATTERN"
			if [[ $? == 1 ]]; then
				echo "$line"
			fi
			# Check whether to reconnect
			if echo "$line" | grep -qP "$RECONNECT_PATTERN"; then
				break
			fi
		done
	}
	# Exit on SIGINT, otherwise reconnect
	if [[ "$?" != 130 ]] then
		echo -e "\nReconnecting...\n"
		sleep 5
	else
		break
	fi
done
