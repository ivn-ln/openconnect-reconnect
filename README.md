Small bash script to filter out openconnect output and reconnect on termination or user defined output

Define default values
```
# Credentials
VPN_USER="${2:-replace this}"
VPN_CERT="${4:-replace this}"
VPN_PASS="${3:-replace this}"

# Regex pattern for output to ignore
FILTER_PATTERN="replace this"
# Timeout time for pings
TIMEOUT_TIMER=10
```

Usage: `vpn.bash <IP_ADDRESS> [USER] [PASSWORD] [CERTIFICATE]`
