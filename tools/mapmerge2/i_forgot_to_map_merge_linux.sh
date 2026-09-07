#!/bin/sh
"$(dirname "$0")/../bootstrap/python" -m hooks.install "$@"
"$(dirname "$0")/../bootstrap/python" -m mapmerge2.fixup "$@"
