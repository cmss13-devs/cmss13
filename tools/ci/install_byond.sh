#!/bin/bash
set -euo pipefail

# BYOND_MAJOR and BYOND_MINOR can be explicitly set, such as in alt_byond_versions.txt
if [ -z "${BYOND_MAJOR+x}" ]; then
  source dependencies.sh
fi

if [ -d "$HOME/BYOND/byond/bin" ] && grep -Fxq "${BYOND_MAJOR}.${BYOND_MINOR}" $HOME/BYOND/version.txt;
then
  echo "Using cached directory."
else
  echo "Setting up BYOND version ${BYOND_MAJOR}.${BYOND_MINOR} (linux)..."
  rm -rf "$HOME/BYOND"
  mkdir -p "$HOME/BYOND"
  cd "$HOME/BYOND"
  curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip -A "CMSS13/1.0 Continuous Integration"
  if [ $? -ne 0 ] || !(unzip -qt byond.zip); then
    echo "Attempting fallback mirror..."
    rm byond.zip
    curl "https://cmss13-devs.github.io/byond-build-mirror/www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip -A "CMSS13/1.0 Continuous Integration"
    if [ $? -ne 0 ] || !(unzip -qt byond.zip); then
      echo "Failure!"
      exit 1
    fi
  fi
  unzip byond.zip
  rm byond.zip
  cd byond
  make here
  echo "$BYOND_MAJOR.$BYOND_MINOR" > "$HOME/BYOND/version.txt"
  cd ~/
fi
