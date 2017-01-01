#!/bin/bash
# This script will generate a report of system activity.

date
hostname
echo ""
df -h
echo ""
echo "root is logged on the following terminals:"
w | grep root
