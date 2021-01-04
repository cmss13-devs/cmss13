#!/bin/bash
set -euo pipefail

source dependencies.sh

source ~/.nvm/nvm.sh
nvm install $NODE_VERSION

echo "nvm installed node"

nvm use $NODE_VERSION

echo "nvm done"

npm install --global yarn

echo "npm done"

pip3 install --user PyYaml
pip3 install --user beautifulsoup4


