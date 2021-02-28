#!/bin/bash
# ------------------------------------------------------------------
# [Boris Mihajlovski] Grunt serve from within docker container
# ------------------------------------------------------------------

VERSION=0.0.1
SUBJECT=876b7678-7a0c-11eb-9439-0242ac130002
USAGE="Usage: Run this script without any arguments."

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "$(basename $0)" " is already running"
   exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# scripts
IMIN="$(cd "$(dirname "$0")" && pwd)"

# --- Body --------------------------------------------------------
HERE=$(pwd)
SRC="$(dirname "$IMIN")"

cd $SRC/app
# echo "Serving" $1
echo "Serving Scheduling webApp"

npm start --live-reload=true --host=0.0.0.0

cd $HERE
exit 0