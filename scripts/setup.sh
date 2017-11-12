#!/bin/bash

LDAP_PASS_ENCRYPTED=$(echo $LDAP_PW | /usr/local/GoogleCloudDirSync/encrypt-util -c /assets/config/gcds-config.xml | grep -Po "(?<=cut and paste\): )([a-zA-Z0-9\+=/]+)$")
echo "encrypted pw: $LDAP_PASS_ENCRYPTED"

sed -ri "s@(<authCredentialsEncrypted>).+(<\/authCredentialsEncrypted>)@\1${LDAP_PASS_ENCRYPTED}\2@" /assets/config/gcds-config.xml
sed -ri "s@(<hostname>).+(<\/hostname>)@\1${HOST}\2@" /assets/config/gcds-config.xml
sed -ri "s@(<port>).+(<\/port>)@\1${PORT}\2@" /assets/config/gcds-config.xml

mkdir -p /var/log/gcds
echo "" >> /var/log/gcds/gcds.log

echo "SHELL=/bin/sh" > /etc/crontab
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/crontab

if [ $DRY_RUN  = "TRUE" ];  then
    echo "$CRON_EXP root /usr/local/GoogleCloudDirSync/sync-cmd -c /assets/config/gcds-config.xml >> /var/log/gcds/gcds.log 2>&1" >> /etc/crontab
else
    echo "$CRON_EXP root /usr/local/GoogleCloudDirSync/sync-cmd -c /assets/config/gcds-config.xml -a >> /var/log/gcds/gcds.log 2>&1" >> /etc/crontab
fi

cron

exec tail -f /var/log/gcds/gcds.log
