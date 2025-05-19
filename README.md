Small bash script to filter out openconnect output and reconnect on termination or user defined output

Define default values
```
# Credentials
VPN_USER="${2:-replace this}"
VPN_CERT="${4:-replace this}"
VPN_PASS="${3:-replace this}"

# Regex pattern for output to ignore
FILTER_PATTERN="replace this"
# Regex pattern to reconnect on
RECONNECT_PATTERN="CSTP Dead Peer Detection detected dead peer!|DTLS handshake failed: Resource temporarily unavailable, try again."
```

Usage: `vpn.bash <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]`
