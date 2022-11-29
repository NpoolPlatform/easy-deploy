#!/bin/bash

source /etc/profile.d/boostd-env.sh
LOG_FILE=/var/log/lotus/boostd-import.log

function error() {
  echo "  <E> $1 ~"
  echo "  <E> $1 ~" >> $LOG_FILE
  exit 1
}


function info() {
  echo "  <I> $1 ~" >> $LOG_FILE
}


function checkstatus() {
  importdone="false"
  while true;do
    status=`sqlite3 -readonly /opt/data/boost.db "select Checkpoint from deals where ID=\"$uuid\""`
    [ "x$status" != "xAccepted" ] && break
    sleep 30
  done
}

# ls /mnt/sd*/*/* > carfilelist
ls carfilelist
[ ! 0 -eq $? ] && error "No carfile list"

while true
do
  dealist=`sqlite3 -readonly /opt/data/boost.db 'select ID, PieceCID, InboundFilePath from deals where Checkpoint="Accepted";'`
  for i in $dealist
  do
    curtime=`date +%Y%m%d%H%M`
    uuid=`echo $i | awk -F '|' '{ print $1 }'`
    carname=`echo $i | awk -F '|' '{ print $2 }'`
    file_url=`grep $carname carfilelist`

    info "$curtime --- boostd import-data $uuid $file_url"
    boostd import-data $uuid $file_url
    checkstatus $uuid
  done
done
