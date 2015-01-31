#!/bin/bash
#
# weewx backup (originally based on wview)

TODAY=`date +%Y_%m_%d`
TMPDIR="/var/tmp"

ARCHIVE_FILE=weewx.sdb
STATS_FILE=stats.sdb
ARCHIVE_DIR=/home/weewx/archive
DESTDIR=/mnt/weewxBackup/data

# if the archive isn't present, there is a typo above
if [ ! -f $ARCHIVE_DIR/$ARCHIVE_FILE ]; then
	logger "$0 exiting - srcfile not found"
	exit 1
fi

# weewx v3 eliminates the stats file
if [ -f $ARCHIVE_DIR/$STATS_FILE ]; then
    STATS_PRESENT=1
fi

# stash a copy to a scratch directory without stopping weewx
# we rely on the os to ensure the file we copy is intact
# (crossing fingers)
cd $ARCHIVE_DIR
cp $ARCHIVE_FILE ${TMPDIR}
if [ x$STATS_PRESENT = "x1" ]; then
   cp $STATS_FILE   ${TMPDIR}
fi

# now work on the stashed files to gzip them with a timestamp
# this is done since it takes some time
cd "${TMPDIR}"
gzip -c ${ARCHIVE_FILE} > $ARCHIVE_FILE.$TODAY.gz
mv $ARCHIVE_FILE.$TODAY.gz $DESTDIR
if [ x$STATS_PRESENT = "x1" ]; then
  gzip -c ${STATS_FILE} > $STATS_FILE.$TODAY.gz
  mv $STATS_FILE.$TODAY.gz $DESTDIR
fi

# always nice to leave positive log messages
logger "WEEWX_BACKUP - complete to $DESTDIR"

# cleanup temporary stuff
rm -f "${TMPDIR}"/$ARCHIVE_FILE.$TODAY.gz 
rm -f "${TMPDIR}"/$ARCHIVE_FILE
if [ x$STATS_PRESENT = "x1" ]; then
  rm -f "${TMPDIR}"/$STATS_FILE.$TODAY.gz 
  rm -f "${TMPDIR}"/$STATS_FILE
fi


