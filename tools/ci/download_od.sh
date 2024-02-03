#!/bin/bash
set -eo pipefail

if [ -z "${OPENDREAM_VERSION+x}" ]; then
	source dependencies.sh
fi

git clone https://github.com/OpenDreamProject/OpenDream.git ~/OpenDream
cd ~/OpenDream
git checkout tags/${OPENDREAM_VERSION}
git submodule update --init --recursive
