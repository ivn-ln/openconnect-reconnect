#!/bin/bash

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]"
	exit 1
fi

# Credentials
VPN_USER="${2:-replace this}"
VPN_CERT="${4:-replace this}"
VPN_PASS="${3:-replace this}"

# Regex pattern for output to ignore
FILTER_PATTERN="replace this"

# Timeout time for pings
TIMEOUT_TIMER=10

while true; do
	exit_flag=false
	
	# Connection
	echo "$VPN_PASS" | sudo openconnect "$1" \
		-u "$VPN_USER" \
		--servercert "$VPN_CERT" \
		2>&1 | while read -r line; do
			# Check whether to filter
			if ! echo "$line" | grep -qP "$FILTER_PATTERN"; then
				echo "$line"
			fi
		done &
	
	VPN_PID=$!

	# Check connection every TIMEOUT_TIMER seconds
	while [[ $(nmcli networking connectivity) == "full" ]]; do
		if ! ping -c 1 -W $TIMEOUT_TIMER 8.8.8.8 &>/dev/null; then
			echo -e "\n Restarting VPN..."
			exit_flag=true
			kill "$VPN_PID"
			break
		fi
	done

	if $exit_flag; then
		echo -e "\nReconnecting to VPN...\n"
	else
		echo "Exiting"
		break
	fi
done
