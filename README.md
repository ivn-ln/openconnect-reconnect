Small bash script for openconnect to reconnect on termination or ping failure

Define default values
```
# Credentials
VPN_USER="${2:-replace this}"
VPN_CERT="${4:-replace this}"
VPN_PASS="${3:-replace this}"

# Timeout time for pings
TIMEOUT_TIMER=10
```

Usage: `vpn.bash <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]`
