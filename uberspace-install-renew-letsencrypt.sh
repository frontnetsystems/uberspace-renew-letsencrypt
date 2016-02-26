#!/bin/bash
script_path=$(pwd)
echo -e "\xF0\x9F\x91\x8B  Hi, this script will setup the automatic uberspace let's encrypt renewal."
echo -e "\xF0\x9F\x94\x93  Making uberspace-renew-letsencrypt.sh executable."
chmod +x "$script_path/uberspace-renew-letsencrypt.sh"
echo -e "\xF0\x9F\x93\xAC  Which email address should be used for receiving the cron logs? (Leave empty if you don't want to receive any e-mails.)"
echo -e -n "\xE2\x9C\x8F  Email address: "
read email
echo -e "\xF0\x9F\x94\x92  Backing up crontab to $script_path/crontab_before_install.bak."
(crontab -l) > "$script_path/crontab_before_install.bak"
echo -e "\xE2\x8F\xB3  Installing weekly cronjob for uberspace-renew-letsencrypt.sh"
(crontab -l; echo "MAILTO=\"$email\""; echo "0 0 * * 0 $script_path/uberspace-renew-letsencrypt.sh") | crontab
echo -e "\xE2\x9C\x85  Finished installing";
