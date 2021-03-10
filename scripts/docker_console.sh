#!/bin/bash
# ------------------------------------------------------------------
# [Boris Mihajlovski] Build/Run docker container for react app
# ------------------------------------------------------------------

SUBJECT=4c7977c8-81ef-11eb-8dcd-0242ac130003

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
    echo "$(basename $0)" " is already running"
    exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Body --------------------------------------------------------

# Update the base image
docker pull node:14.15.1-stretch-slim

docker build --force-rm -t weather-app-demo -f Dockerfile .

docker run --rm -it --name=weather-app-demo \
    -v "$(pwd)":/project --mount source=weather-app-demo,target=/project/app/node_modules \
    -v /tmp:/tmp --hostname weather-app-demo \
    -p 3000:3000 \
    weather-app-demo tmux -L weather-app-demo

DANGLING=$(docker images -f "dangling=true" -q)
if [ "x""$DANGLING" != "x" ]; then
    docker rmi $DANGLING
fi

echo "Successfuly destroyed all linked containers"

exit 0