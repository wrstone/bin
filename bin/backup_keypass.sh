#!/bin/bash
rsync -avzp -e "ssh -q" --delete /drives/c/Users/bill.stone/OneDrive\ for\ Business/DM\ Infrastructure/KeePass2/* wrstone@ma.sdf.org:/meta/w/wrstone/Backups/KeePass2
rsync -avzp -e "ssh -q" --delete /drives/c/Users/bill.stone/OneDrive\ for\ Business/Personal/KeyPass2/* wrstone@ma.sdf.org:/meta/w/wrstone/Backups/KeePass2
