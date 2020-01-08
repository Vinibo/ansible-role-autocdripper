#!/bin/bash
LOCKDIR=/var/lock/autocdripper.lock
LOGFILE=/var/log/autocdripper/$(date +%F).log

function cleanup {

if rmdir $LOCKDIR; then
    echo "Finished $(date)" >> $LOGFILE
else
    echo "Failed to remove lock dir '$LOCKDIR'" >> $LOGFILE
    exit 1
fi
}

if mkdir $LOCKDIR; then
    trap "cleanup" EXIT
    echo "Acquired Lock, running" >> $LOGFILE
    echo "Started $(date) $$" >> $LOGFILE
    OPERATION_RESULT=`abcde -c /usr/share/autocdripper/abcde.conf`

    if [[ $OPERATION_RESULT -eq 0 ]]; then
        echo "Extraction completed at $(date) $$" >> $LOGFILE
    else
        # Disc is probably not an audio-cd
        eject
        echo "Unable to perform extraction $(date) $$" >> $LOGFILE
    fi
else
    echo "Could not create lock, already running? '$LOCKDIR'"
    exit 1
fi