#!/bin/sh
exec "$(dirname "$0")/../bootstrap/python" -m mapmerge2.merge_driver --posthoc "$@"
