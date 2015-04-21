#!/bin/bash

export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp --disk-cache-size=50000000"
chromium "$@"
