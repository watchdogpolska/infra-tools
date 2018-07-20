#!/bin/bash

if [ -z "$2" ]; then
  echo Usage: $0 lock_name command...
  exit 1
fi

LOCKDIR=/var/lock
LOCKFILE=${LOCKDIR}/$1
shift

exec 99>$LOCKFILE
flock -xn 99 || { echo Lock acquired by other process $(( $(date +%s)-$(cat $LOCKFILE-time) )) seconds ago, exiting && exit 1; }
date +%s > $LOCKFILE-time

trap "flock -u 99" EXIT

eval $@

