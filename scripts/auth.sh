#!/bin/bash

/usr/local/GoogleCloudDirSync/upgrade-config -Oauth $DOMAIN -c /usr/local/GoogleCloudDirSync/gcds-config.xml

# Do a dry run for testing
/usr/local/GoogleCloudDirSync/sync-cmd -c gcds-config.xml
