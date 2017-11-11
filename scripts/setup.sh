#!/bin/bash

cp /assets/config/gcds-config.xml /usr/local/GoogleCloudDirSync/gcds-config.xml
LDAP_PASS_ENCRYPTED=$(echo $LDAP_PW | /usr/local/GoogleCloudDirSync/encrypt-util -c gcds-config.xml | grep -Po "(?<=cut and paste\): )([a-zA-Z0-9\+=/]+)$")
echo "encrypted pw: $LDAP_PASS_ENCRYPTED"

sed -ri "s@(<authCredentialsEncrypted>).+(<\/authCredentialsEncrypted>)@\1${LDAP_PASS_ENCRYPTED}\2@" /usr/local/GoogleCloudDirSync/gcds-config.xml
# if the oAuth2RefreshToken value hasn't been encrypted in this volume, the auth tool will throw an error:
sed -ri "s@(<oAuth2RefreshToken>).+(<\/oAuth2RefreshToken>)@\1${LDAP_PASS_ENCRYPTED}\2@" /usr/local/GoogleCloudDirSync/gcds-config.xml
sed -ri "s@(<hostname>).+(<\/hostname>)@\1${HOST}\2@" /usr/local/GoogleCloudDirSync/gcds-config.xml
sed -ri "s@(<port>).+(<\/port>)@\1${PORT}\2@" /usr/local/GoogleCloudDirSync/gcds-config.xml

mkdir /var/log/gcds

if [ $DRY_RUN  = "TRUE" ];  then
    echo "$CRON_EXP root /usr/local/GoogleCloudDirSync/sync-cmd -c gcds-config.xml -r /var/log/gcds/gcds.log" >> /etc/crontab
else
    echo "$CRON_EXP root /usr/local/GoogleCloudDirSync/sync-cmd -c gcds-config.xml -r /var/log/gcds/gcds.log -a" >> /etc/crontab
fi

cron -f
