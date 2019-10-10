@echo off
cd tools/changelogs
call python generate_changelogs.py dev
move *.yml ../../html/changelogs
cd ../GenerateChangelog
call python ss13_genchangelog.py ../../html/changelog.html ../../html/changelogs
pause