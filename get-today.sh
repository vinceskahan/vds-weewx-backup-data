#!/bin/sh
#
# quickie script to grab today's saved weewx data
#
# this expects a particular filename convention of course
# which is ala weewx.sdb.2014_12_31.gz
#
today=`date +%Y_%m_%d`

# this is the remote pathname to the source data to grab
remote_host="root@debian:/mnt/weewxBackup/data"

# add '-i key' if you have a passwordless keypair
# set up and you want to run this from cron to
# automate the pulls for hands-off operation

scp ${remote_host}/*sdb.${today}.gz .

