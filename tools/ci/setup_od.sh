#!/bin/bash
set -eo pipefail

cd ~/OpenDream

dotnet restore
dotnet build -c Release
