#!/bin/bash

# resourcers:
#   https://www.chromium.org/developers/design-documents/network-stack/socks-proxy
#   chrome://net-internals/#proxy

google-chrome --proxy-server="socks5://localhost:1080" \
              --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost" \
              --user-data-dir="/tmp/chrome-tmp-profile"  \
              --incognito "$@"

