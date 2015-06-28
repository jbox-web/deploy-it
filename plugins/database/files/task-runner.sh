#!/bin/bash

set -e

status() {
  echo "-----> $*"
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
indent() {
  # if an arg is given it's a flag indicating we shouldn't indent the first line, so use :+ to tell SED accordingly if that parameter is set, otherwise null string for no range selector prefix (it selects from line 2 onwards and then every 1st line, meaning all lines)
  c="${1:+"2,999"} s/^/       /"
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

APP_DIR=/app
PROCFILE=${APP_DIR}/Procfile
SCALEFILE=${APP_DIR}/SCALE

for file in ${APP_DIR}/.profile.d/* ; do
  source $file
done

hash -r

cd ${APP_DIR}

cat "$PROCFILE" | while read line ; do

  if [ ! -n "$line" ] ; then
    continue
  fi

  TASK=${line%%:*}

  if [ -f "$SCALEFILE" ] ; then
    SCALE=$(egrep "^$TASK=" "$SCALEFILE")
    if [ -n "$SCALE" ] ; then
      NUM_PROCS=${SCALE#*=}
    fi
    if [ "$NUM_PROCS" -eq 0 ] ; then
      status "Running task : '$TASK'"

      CMD=$(ruby -e "require 'yaml';puts YAML::load_file('Procfile')['${TASK}']")

      echo $CMD | bash -e | indent

      if [ "$?" -ne 0 ] ; then
        status "${TASK} failed !"
        continue
      fi
    fi
  else
    case "$line" in
      web:*|worker:*|urgentworker:*|clock:*)
        continue
      ;;
    esac
  fi

done

exit 0
