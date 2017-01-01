#!/bin/bash
#############################################################################
#                                                                           #
#  NAME:     check-ms-blacklist.sh                                          #
#  VERSION:  1.0                                                            #
#  AUTHOR:   William Stone III <bill.stone@submittalexchange.com>           #
#  WRITTEN:  Wed Feb 17 13:53:38 UTC 2016                                   #
#  MODIFIED: Fri Feb 19 15:08:07 UTC 2016                                   #
#                                                                           #
#  PURPOSE:  This script checks the mail log files for evidence of black-   #
#            listing by  Microsoft.                                         #
#                                                                           #
#            If it is, it will use expect to send an email via an alternate #
#            mail server to "se.infrastructure@texturacorp.com".            #
#                                                                           #
#            The script accepts no command-line arguments.                  #
#                                                                           #
#  DEPENDANCIES:  This script requires that expect is installed on the      #
#            target server.                                                 #
#                                                                           #
#                                                                           #
#############################################################################

# Get the current program name
PROGRAM=`basename $0`

# Check that the program is being run by root
if [[ $EUID -ne 0 ]]; then
	echo "This program must be run with root permissions." 1>&2
	exit 3
else
	# Define the target email address for a failure notification
	RECIPIENT="se.infrastructure@texturacorp.com"

	# Define the email sender
	SENDER="blacklist@submittalexchange.com"

	# Define the mail server in use.
	# Note that on systems with correct hostnames, the following line should
	#  be commented out.  "SERVERNAME" should be replaced with the
	#  appropriate server name.
	# SERVER=SERVERNAME

	# Systems with standard hostnames should use the following line.
	#   It takes the server name from the system environment variable
	#   '$HOSTNAME'
	SERVER=$HOSTNAME

	# Define the outbound SMTP server.  It can't be the server on which
	#  the script resides, because it might be blacklisted.
	#  this should be the local WhatsUp Gold server.
	#  "SERVERNAME" should be changed to the appropriate SMTP server.
	SMTPSERVER=SERVERNAME

	# Define the SMTP port
	SMTPPORT=25

	# Define the log file to be checked
	LOGFILE=/var/log/mail.log

	# Set the subject line
	SUBJECT="Subject: $SERVER Blacklisted by Microsoft"

	# Set the email body
	BODY="$SERVER may be blacklisted by Microsoft.  Please open a Jira ticket and investigate."

	# Check to see if the user specified a command-line option
	if [ "$1" == "" ]; then
		# The user called the script correctly, so we can do work

		# Check the logfile for Microsoft's blocklist address
		grep -q 'delist@messaging.microsoft.com' $LOGFILE

		# If it found no error, note it.  Otherwise, send an email to
		#  the alternate address
		if [ $? != 0 ]; then
			# Tell the user it is not blacklisted
			echo "$SERVER not blacklisted."
			exit 0
		else
			# Tell the user that it is blacklisted
			echo $BODY

			# Run expect to send the mail via a different server
			/usr/bin/expect<<-EXEND

				spawn telnet $SMTPSERVER $SMTPPORT

				expect "Microsoft ESMTP MAIL Service"
				send "\nehlo devmail.submittalexchange.com\n"

				expect "250 OK"
				send "\nmail from: $SENDER\n"

				expect "Sender OK"
				send "\nrcpt to: $RECIPIENT\n"

				expect "texturacorp.com"
				send "\ndata\n"

				expect "354 Start mail input; end with <CRLF>.<CRLF>"
				send "$SUBJECT\n\n"
				send "$BODY\n\n"
				send "\r.\r"

				expect "Queued mail for delivery"
				send "quit\n"

				expect "Service closing transmission channel"

				expect eof

			EXEND

			exit 1
		fi

	else
		# The user specified command line options when none are needed,
        	# so let's give them instructions
		echo
		echo "Usage:  $PROGRAM"
		echo "Send an email to Microsoft to test for blacklisting.  If it has been"
		echo "blackisted, an email will be sent to a non-Textura email account."
		echo "There are no command-line arguments.  It must be run with root"
		echo "permissions."
		echo
		exit 2
	fi
fi
