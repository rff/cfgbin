#!/bin/bash

route add -net 192.168.0.0/16 gw 172.16.0.172
route add -net 10.100.0.0/16 gw 172.16.0.172
