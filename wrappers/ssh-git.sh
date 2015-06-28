#!/bin/sh

if [ -z "$PRIVATE_KEY" ] ; then
  # if PRIVATE_KEY is not specified, run ssh using default keyfile
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@"
else
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "$PRIVATE_KEY" "$@"
fi
