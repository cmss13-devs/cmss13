#!/bin/bash
set -euo pipefail

MAP=$1

echo Testing $MAP

tools/deploy.sh ci_test
mkdir ci_test/data

#set the map
cp maps/$MAP.json ci_test/data/next_map.json
# unit tests suppress the ship map code-side now, so this is unnecessary
# also it caused weird issues
# cp maps/templates/space.json ci_test/data/next_ship.json

cd ci_test
DreamDaemon colonialmarines.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
