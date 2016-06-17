#!/bin/bash

################################################################################
#                                                                              #
#  Copyright (C) 2016 Jack-Benny Persson <jack-benny@cyberinfo.se>             #
#                                                                              #
#   This program is free software; you can redistribute it and/or modify       #
#   it under the terms of the GNU General Public License as published by       #
#   the Free Software Foundation; either version 2 of the License, or          #
#   (at your option) any later version.                                        #
#                                                                              #
#   This program is distributed in the hope that it will be useful,            #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#   GNU General Public License for more details.                               #
#                                                                              #
#   You should have received a copy of the GNU General Public License          #
#   along with this program; if not, write to the Free Software                #
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  #
#                                                                              #
################################################################################

###############################################################################
#                                                                             # 
# Nagios plugin to test IMAP servers with STARTTLS. The plugin also try to    #
# login with a username and password.                                         #
#                                                                             #
###############################################################################

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

VERSION="Version 0.1"
AUTHOR="(c) 2016 Jack-Benny Persson (jack-benny@cyberinfo.se)"

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

shopt -s extglob

# Function to login/logout from IMAP-servers
login() {
sleep 2
echo "a login $Username $Password"
sleep 1
echo "a logout"
}

# Print version information
print_version()
{
    printf "\n\n$0 - $VERSION\n"
}

#Print help information
print_help()
{
    print_version
    printf "$AUTHOR\n"
    printf "Test/monitor a IMAP server with STARTTLS and login with a username/password\n"
/bin/cat <<EOT
Options:
-h
   Print detailed help screen
-V
   Print version information
-p | --port
  Port to connect to
-H | --hostname
  Hostname to connect to
-U | --username
  Username to use for login
-P | --password
  Password to use for login
EOT
}

# Test if openssl is installed
openssl -h 2> /dev/null
if [ $? != 0 ]; then
    echo "There is a problem with your OpenSSL program"
    exit $STATE_UNKNOWN
fi


# Parse command line options
while [[ -n "$1" ]]; do 
   case "$1" in

       -h | --help)
           print_help
           exit $STATE_OK
           ;;

       -V | --version)
           print_version
           exit $STATE_OK
           ;;

       -p | --port)
           Port="$2"
           shift 2
           ;;

       -H | --hostname)
           Host="$2"
           shift 2
           ;;

       -U | --username)
           Username="$2"
           shift 2
           ;;

       -P | --password)
           Password="$2"
           shift 2
           ;;
       -\?)
           print_help
           exit $STATE_OK
           ;;

       *)
           printf "\nInvalid option '$1'"
           print_help
           exit $STATE_UNKNOWN
           ;;
   esac
done

# Check if everything is set
if [[ -z "$Host" ]]; then
    printf "\nHostname not set"
    print_help
    exit $STATE_UNKNOWN
fi

if [[ -z "$Port" ]]; then
    printf "\nPort not set"
    print_help
    exit $STATE_UNKNOWN
fi

if [[ -z "$Username" ]]; then
    printf "\nUsername not set"
    print_help
    exit $STATE_UNKNOWN
fi

if [[ -z "$Password" ]]; then
    printf "\nPassword not set"
    print_help
    exit $STATE_UNKNOWN
fi

# Main program/logic
out=`login | openssl s_client -crlf -connect $Host:$Port -starttls imap 2>&1 | grep "a OK Logged in"`
if [ $? == 0 ]; then
    echo "IMAP OK: $out"
    exit $STATE_OK
else
    echo "IMAP CRITICAL: Can't login to IMAP server $Host:$Port"
    exit $STATE_CRITICAL
fi

# If we ended down here, it's an unknown mystery
exit $STATE_UNKNOWN
