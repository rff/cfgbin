#!/bin/bash

google-chrome --proxy-server=socks5://localhost:9999 --user-data-dir="${HOME}/.config/chrome-tmp-profile" "$@"
