#!/bin/bash
#
# weewx backup (originally based on wview)

TODAY=`date +%Y_%m_%d`

#----------- START EDITING HERE ------------------------

# files to back up
#    typically this would be only 'weewx.sdb'
FILE_LIST="vp2.sdb mem.sdb purpleair.sdb ecowitt.sdb"

# location of weewx database(s)
ARCHIVE_DIR=/home/pi/weewx-data/archive

# where to back up to
DESTDIR=/home/pi/weewx-backups

# scratch dir to work in
TMPDIR="/var/tmp"

#------------- STOP EDITING HERE -----------------------

# processing every file, we:
#    cd to the archive dir and copy to a tmpdir
#    cd to the tmpdir and gzip the copy up
#    move the gzipped copy to the destination dir
#    clean up the temporary unzipped copy

logger "WEEWX_BACKUP - starting"
for f in ${FILE_LIST}
do
  cd ${ARCHIVE_DIR}
  if [ -f ${f} ]
  then
     logger "WEEWX_BACKUP - backing up ${f}"

     cp ${f} ${TMPDIR}
     cd ${TMPDIR}

     gzip -c ${f} > ${f}.${TODAY}.gz

     mv ${f}.${TODAY}.gz ${DESTDIR}

     rm -f ${TMPDIR}/${f}
  else
     logger -m "WEEWX_BACKUP - cannot find db file ${ARCHIVE_DIR}/${f}"
  fi
done

logger "WEEWX_BACKUP - complete to $DESTDIR"

