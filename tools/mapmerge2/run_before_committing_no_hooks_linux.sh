#!/bin/sh
exec "$(dirname "$0")/../bootstrap/python" -m mapmerge2.precommit --use-workdir "$@"
