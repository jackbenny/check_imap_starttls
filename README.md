# check_imap_starttls #
This is a Nagios plugin written in Bash to check IMAP-servers
with STARTTLS capabilities. The plugin also tries to login to the
server so it's required that you have an account on the server
you want to check.

## Usage ##

    (c) 2016 Jack-Benny Persson (jack-benny@cyberinfo.se)
    Test/monitor a IMAP server with STARTTLS and login with a username/password
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

## License ##
Copyright 2016, Jack-Benny Persson (jack-benny@cyberinfo.se) and released
under GNU GPL2.
