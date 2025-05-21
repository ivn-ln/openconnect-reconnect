#!/bin/bash
set -e

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]"
	exit 1
fi

# Credentials
VPN_USER="${2:-REPLACE THIS}"
VPN_CERT="${4:-REPLACE THIS}"
VPN_PASS="${3:-REPLACE THIS}"

TIMEOUT_TIME=5

# FIFO for the password
PIPE_PATH=/tmp/vpn
if [[ ! -e "$PIPE_PATH" ]]; then
	mkfifo "$PIPE_PATH"
fi

# Kill all openconnect instances (mostly for debug purposes) and remove the pipe
cleanup() {
	pkill openconnect
	rm -f "$PIPE_PATH"
	exit
}

# Clean up on exit, exit on SIGINT
trap "echo \"Cleaning up\" $(cleanup)" EXIT
trap exit INT

while true; do
	# Connection
	echo "$VPN_PASS" > "$PIPE_PATH" &
	openconnect "$1" \
	-u "$VPN_USER" \
	--servercert "$VPN_CERT" \
	--passwd-on-stdin < "$PIPE_PATH" 2>&1 &

	VPN_PID=$!

	# Check connection every TIMEOUT_TIMER seconds
	while kill -0 "$VPN_PID" 2>/dev/null; do
		if ! ping -c 1 -W "$TIMEOUT_TIME" 8.8.8.8 &> /dev/null; then
			echo -e "\nConnection dropped!"
			kill -2 "$VPN_PID"
			wait "$VPN_PID"
			break
		fi
	done

	echo -e "Reconnecting to VPN...\n"
	sleep 1
done
