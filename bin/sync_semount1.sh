#!/bin/bash
#############################################################################
#                                                                           #
#  NAME:     skeleton                                                       #
#  VERSION:  1.0                                                            #
#  AUTHOR:   William Stone III <wrs@wrstone.com>                            #
#  WRITTEN:  Thu Sep 13 15:00:43 UTC 2012                                   #
#  MODIFIED: Thu Oct 18 22:19:50 UTC 2012                                   #
#                                                                           #
#  PURPOSE:  This script is a skelton.  It checks that the user entered     #
#            a command-line option.  If there was a command-line option     #
#            given, it will enter the main body for processing; if not, it  #
#            prints usage instructions.                                     #
#                                                                           #
#            Modify this for your own scripts as appropriate.               #
#                                                                           #
#############################################################################

# Get the current program name
PROGRAM=`basename $0`

# Check to see if the user specified a command-line option
if [ "$1" != "" ]
then
	# The user called the script correctly, so we can do work
	echo "Add something useful here!"

else
	# The user didn't specify any command line options, so let's
	# give them instructions
	echo
	echo "Usage:  $PROGRAM [options]"
	echo "The program is supposed to be used a certain way."
	echo
fi
