#!/bin/bash
set -e
source dependencies.sh
echo "Downloading BYOND version ${BYOND_MAJOR}.${BYOND_MINOR} (windows)..."
curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond.zip" -o C:/byond.zip -A "CMSS13/1.0 Continuous Integration"
if [ $? -ne 0 ] || !(unzip -qt C:/byond.zip); then
	echo "Attempting fallback mirror..."
	rm C:/byond.zip
	curl "https://cmss13-devs.github.io/byond-build-mirror/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond.zip" -o C:/byond.zip -A "CMSS13/1.0 Continuous Integration"
	if [ $? -ne 0 ] || !(unzip -qt C:/byond.zip); then
		echo "Failure!"
		exit 1
	fi
fi
