#!/bin/bash
rsync -avzp -e "ssh -q" --delete /drives/c/Users/bill.stone/OneDrive\ for\ Business/Personal/mRemoteNG/* wrstone@ma.sdf.org:/meta/w/wrstone/Backups/mRemoteNG
