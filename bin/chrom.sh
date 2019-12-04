chrome-cachetmp.sh
----------------------------
#!/bin/bash

export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp --disk-cache-size=50000000"
chromium "$@"




chrome-proxy-incognito.sh
----------------------------
#!/bin/bash

# resourcers:
#   https://www.chromium.org/developers/design-documents/network-stack/socks-proxy
#   chrome://net-internals/#proxy

google-chrome --proxy-server="socks5://localhost:1080" \
              --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost" \
              --incognito "$@"




chrome-tmp-proxy-incognito.sh
----------------------------
#!/bin/bash

# resourcers:
#   https://www.chromium.org/developers/design-documents/network-stack/socks-proxy
#   chrome://net-internals/#proxy

google-chrome --proxy-server="socks5://localhost:1080" \
              --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost" \
              --user-data-dir="/tmp/chrome-tmp-profile"  \
              --incognito "$@"




chrome-tmp.sh
----------------------------
#!/bin/bash

google-chrome --proxy-server=socks5://localhost:9999 --user-data-dir="${HOME}/.config/chrome-tmp-profile" "$@"


chromium-cachetmp.sh
----------------------------
#!/bin/bash

chromium --disk-cache-dir=/tmp/chromium-cache/ &> /dev/null
