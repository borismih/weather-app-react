#!/bin/bash
# ------------------------------------------------------------------
# [Boris Mihajlovski] Build/Run docker container for react app
# ------------------------------------------------------------------

SUBJECT=876b797a-7a0c-11eb-9439-0242ac130002

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

docker build --force-rm -t react-weather-app -f Dockerfile .

docker run --rm -it --name=react-weather-app \
    -v "$(pwd)":/project --mount source=react-weather-app,target=/project/app/node_modules \
    -v /tmp:/tmp --hostname react-weather-app \
    -p 3000:3000 \
    react-weather-app tmux -L react-weather-app

DANGLING=$(docker images -f "dangling=true" -q)
if [ "x""$DANGLING" != "x" ]; then
    docker rmi $DANGLING
fi

echo "Successfuly destroyed all linked containers"

exit 0