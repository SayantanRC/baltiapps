#!sbin/sh

# This script only allows unpacking user apps and optional extras like calls, sms etc.
# This does not restore system apps
# The restoration process must be completed using the helper app.

# Usage:
# 1. Put this script under internal storage (/sdcard/)
# 2. Extract the migrate backup zip in, say, /sdcard/backup.
# 3. Go to TWRP main menu -> Mount -> Data and System
# 4. Go to TWRP main menu -> Advanced -> Terminal
#    OR
#    Connect device to PC and open an ADB shell
# 5. Execute this script: 
#    (the first parameter is the location of the extracted backup zip)
#
#    chmod +x /sdcard/manual_twrp_install.sh
#    sh /sdcard/manual_twrp_install.sh /sdcard/backup

if [ -z $1 ]; then
    echo "Please provide path to extracted zip"
    exit 1
fi

CACHE=/data/local/tmp/migrate_cache/

# make cache
echo "Making cache"
mkdir -p $CACHE

# move inside the extracted backup
cd $1

echo "Copying apps"

# copy app info, apks and permission to cache
cp *.json $CACHE
cp -a *.app $CACHE
cp *.perm $CACHE

# copy app data
cp *.tar.gz /data/data/

# copy extras
echo "Copying extras"
cp *.calls.db $CACHE 2>/dev/null
cp *.sms.db $CACHE 2>/dev/null
cp *.vcf $CACHE 2>/dev/null
cp default.kyb $CACHE 2>/dev/null
cp screen.dpi $CACHE 2>/dev/null

# copy package data
echo "Copying package-data"
cp package-data* $CACHE

# inject helper
echo "Deleting and injecting helper"
rm -r /system/app/MigrateHelper 2>/dev/null
cp -a system /
mv /system/app/helper/ /system/app/MigrateHelper

echo "Done!! Please reboot."
