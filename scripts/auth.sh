#!/bin/bash

# if the oAuth2RefreshToken value hasn't been encrypted in this volume, the auth tool will throw an error:
ENCRYPTED_TOKEN=$(echo "secret" | /usr/local/GoogleCloudDirSync/encrypt-util -c /assets/config/gcds-config.xml | grep -Po "(?<=cut and paste\): )([a-zA-Z0-9\+=/]+)$")
sed -ri "s@(<oAuth2RefreshToken>).+(<\/oAuth2RefreshToken>)@\1${ENCRYPTED_TOKEN}\2@" /assets/config/gcds-config.xml

/usr/local/GoogleCloudDirSync/upgrade-config -Oauth $DOMAIN -c /assets/config/gcds-config.xml

# Do a dry run for testing
/usr/local/GoogleCloudDirSync/sync-cmd -c /assets/config/gcds-config.xml
