#!/usr/bin/env bash
set -e

TEST_CONFIG=$1
BINARY=/tests/firefox-nightly/firefox
CONFIG_FILE=/tests/venv/config.json

echo $TEST_CONFIG > $CONFIG_FILE

if [ "$TEST_ENV" == "prod" ] && [ -z "$TESTFILE" ]; then
  TESTFILE="test_sync.js"
fi

if [ ! -z "$TESTFILE" ]; then
  TESTFILE_ARGS="--testfile='$TESTFILE'"
fi

if [ "$TEST_ENV" == "prod" ]; then
  echo "xvfb-run /tests/venv/bin/runtps --debug --binary='$BINARY' --configfile='$CONFIG_FILE' $TESTFILE_ARGS"
elif [ "$TEST_ENV" == "stage" ]; then
  echo "MOZ_HEADLESS=1 /tests/venv/bin/runtps --debug --binary='$BINARY' --configfile='$CONFIG_FILE' $TESTFILE_ARGS"
else
  echo "Unknown environment: $TEST_ENV"
  exit 127
fi
