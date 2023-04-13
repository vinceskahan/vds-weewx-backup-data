#!/bin/bash
#
# back up a pip-installed v5 weewx completely
# excluding archive
#
# we save public_html to get the NOAA summaries
# since they can take forever to regenerate and
# we don't want to lose any resolution from the
# archive contents
#

# which user weewx runs as
WEEWX_USER="pi"

#--- you likely do not need to edit below here ---

WEEWX_DATA="/home/${WEEWX_USER}/weewx-data"
WEEWX_CODE="/home/${WEEWX_USER}/.local"
WEEWX_STARTUP_FILE="/etc/systemd/system/weewx.service"
CRONTABS="/var/spool/cron/crontabs"

BACKUP_LIST="${WEEWX_DATA} ${WEEWX_CODE} ${WEEWX_STARTUP_FILE} ${CRONTABS}"

echo "... backing up weewx software and data ..."
echo "backup list: ${BACKUP_LIST}"

# skip the archive, we save that nightly via cron
EXCLUDE_OPTS="--exclude=/home/pi/weewx-data/archive"

# use a date-specific filename
TODAY=`date +%Y_%m_%d_%H%M%S`
OUTPUT_FILE="/var/tmp/weewx-complete-backup-${TODAY}.tgz"

# remove the '2>/dev/null' to see any warnings or errors
# (recommended at least initially)
#
# add 'v' option for verbose

# back it up
tar zcf ${OUTPUT_FILE} ${EXCLUDE_OPTS} ${BACKUP_LIST} 2>/dev/null

echo "backup is in ${OUTPUT_FILE}"
echo "... done ..."

