#!/bin/bash
set -euo pipefail

MAP=$1

echo Testing $MAP

tools/deploy.sh ci_test
mkdir ci_test/config
mkdir ci_test/data

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt

#set the map
cp maps/$MAP.json ci_test/data/next_map.json
cp maps/templates/space.json ci_test/data/next_ship.json

cd ci_test
DreamDaemon colonialmarines.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
