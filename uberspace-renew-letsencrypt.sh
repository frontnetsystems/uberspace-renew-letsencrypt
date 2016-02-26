#!/bin/bash

current_date=$(date)

echo -e "\xF0\x9F\x95\x9D  Starting let's encrypt renewal at $current_date"

# define warntime in seconds, equals 10 days before cert expiration
# you can call the script weekly via cron then
WARNTIME=864000

echo -e "\xE2\x9C\x85  Using Warntime: $WARNTIME seconds"

# define let's encrypt work directory
LEDIR=/home/$USER/.config/letsencrypt

echo -e "\xE2\x9C\x85  Config directory is: $LEDIR"

# define let's encrypt cert directory - read and build path
CERTDIR=$(basename $LEDIR/live/*)
CERTDIR=$LEDIR/live/$CERTDIR

# check if let's encrypt cli parameters are set and set if necessary
# agree-dev-preview first, most likely commented out
if ! grep -q "agree-dev-preview" $LEDIR/cli.ini; then
        echo "agree-dev-preview = True" >> $LEDIR/cli.ini; else
        if grep -q "#agree-dev-preview = True" $LEDIR/cli.ini; then
                cp $LEDIR/cli.ini $LEDIR/cli.bak
                sed -i s/#agree-dev-preview/agree-dev-preview/g $LEDIR/cli.ini
        fi
fi
# now agree-tos
if ! grep -q "agree-tos" $LEDIR/cli.ini; then
        echo "agree-tos = True" >> $LEDIR/cli.ini; else
        if grep -q "#agree-tos = True" $LEDIR/cli.ini; then
                cp $LEDIR/cli.ini $LEDIR/cli.bak
                sed -i s/#agree-tos/agree-tos/g $LEDIR/cli.ini
        fi
fi
#and renew-by-default
if ! grep -q "renew-by-default" $LEDIR/cli.ini; then
        echo "renew-by-default = True" >> $LEDIR/cli.ini; else
        if grep -q "#renew-by-default = True" $LEDIR/cli.ini; then
                cp $LEDIR/cli.copy $LEDIR/cli.bak
                sed -i s/#renew-by-default/renew-by-default/g $LEDIR/cli.ini
        fi
fi

echo -e '\xE2\x8C\x9B  Checking certificate...'

# check expiration date from let's encrypt directory
if ! openssl x509 -in $CERTDIR/cert.pem -checkend $WARNTIME -noout; then
	echo -e "\xE2\x9D\x8C Certificate is expired. Renewing now."
	# create new certificates
	letsencrypt certonly
	# configure the uberspace webserver to use the new certificates
	uberspace-add-certificate -k $CERTDIR/privkey.pem -c $CERTDIR/cert.pem
else
	valid_till=$(/usr/local/bin/cert-info --file $CERTDIR/cert.pem --days-left)
	echo -e "\xE2\x9C\x85  Certificate looks good. It is still valid for $valid_till days! :)"
fi
exit 0
