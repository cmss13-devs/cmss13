#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

st=0

echo "Checking for map issues"
if grep -El '^\".+\" = \(.+\)' maps/**/*.dmm;	then
	echo
	echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
	st=1
fi;
if grep -P 'Merge conflict marker' maps/**/*.dmm; then
	echo
	echo -e "${RED}ERROR: Merge conflict markers detected in map, please resolve all merge failures!${NC}"
	st=1
fi;
if grep -El '(new|newlist|icon|matrix|sound)\(.+\)' maps/**/*.dmm;	then
	echo
	echo -e "${RED}ERROR: Using unsupported procs in variables in a map file! Please remove all instances of this.${NC}"
	st=1
fi;
#if grep -P '^\ttag = \"icon' maps/**/*.dmm;	then
#	echo
#	echo -e "${RED}ERROR: tag vars from icon state generation detected in maps, please remove them.${NC}"
#	st=1
#fi;
if grep -P 'step_[xy]' maps/**/*.dmm;	then
	echo
	echo -e "${RED}ERROR: step_x/step_y variables detected in maps, please remove them.${NC}"
	st=1
fi;
if grep -P 'pixel_[^xy]' maps/**/*.dmm;	then
	echo
	echo -e "${RED}ERROR: incorrect pixel offset variables detected in maps, please remove them.${NC}"
	st=1
fi;
#if grep -P '/obj/structure/cable(/\w+)+\{' maps/**/*.dmm;	then
#	echo
#	echo -e "${RED}ERROR: Variable editted cables detected, please remove them.${NC}"
#	st=1
#fi;
if grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?[013-9]\d*?[^\d]*?\s*?\},?\n' maps/**/*.dmm ||
	grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d+?[0-46-9][^\d]*?\s*?\},?\n' maps/**/*.dmm ||
	grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d{3,1000}[^\d]*?\s*?\},?\n' maps/**/*.dmm ;	then
	echo -e "${RED}ERROR: found an APC with a manually set pixel_x or pixel_y that is not +-25.${NC}"
	st=1
fi;
if grep -P '^/area/.+[\{]' maps/**/*.dmm;	then
	echo -e "${RED}ERROR: Vareditted /area path use detected in maps, please replace with proper paths.${NC}"
	st=1
fi;
if grep -P '\W\/turf\s*[,\){]' maps/**/*.dmm; then
	echo
	echo -e "${RED}ERROR: base /turf path use detected in maps, please replace with proper paths.${NC}"
	st=1
fi;
#if grep -P '^/*var/' code/**/*.dm; then
#	echo
#	echo -e "${RED}ERROR: Unmanaged global var use detected in code, please use the helpers.${NC}"
#	st=1
#fi;
echo "Checking for whitespace issues"
if grep -P '(^ {2})|(^ [^ * ])|(^    +)' code/**/*.dm; then
	echo
	echo -e "${RED}ERROR: space indentation detected.${NC}"
	st=1
fi;
if grep -P '^\t+ [^ *]' code/**/*.dm; then
	echo
	echo -e "${RED}ERROR: mixed <tab><space> indentation detected.${NC}"
	st=1
fi;
nl='
'
nl=$'\n'
while read f; do
	t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
	if [[ ! ${t%x} =~ $r1 ]]; then
		echo
		echo -e "${RED}ERROR: file $f is missing a trailing newline.${NC}"
		st=1
	fi;
done < <(find . -type f -name '*.dm')
echo "Checking for common mistakes"
#if grep -P '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' code/**/*.dm; then
#	echo
#	echo -e "${RED}ERROR: changed files contains proc argument starting with 'var'.${NC}"
#	st=1
#fi;
#if ls maps/*.json | grep -P "[A-Z]"; then
#	echo
#	echo -e "${RED}ERROR: Uppercase in a map json detected, these must be all lowercase.${NC}"
#	st=1
#fi;
if grep -i '/obj/effect/mapping_helpers/custom_icon' maps/**/*.dmm; then
	echo
	echo -e "${RED}ERROR: Custom icon helper found. Please include dmis as standard assets instead for built-in maps.${NC}"
	st=1
fi;
for json in maps/*.json
do
	map_path=$(jq -r '.map_path' $json)
	while read map_file; do
		filename="maps/$map_path/$map_file"
		if [ ! -f $filename ]
		then
			echo
			echo -e "${RED}ERROR: found invalid file reference to $filename in _maps/$json.${NC}"
			st=1
		fi
	done < <(jq -r '[.map_file] | flatten | .[]' $json)
done

if grep -P '(new|newlist|icon|matrix|sound)\(.+\)' maps/**/*.dmm;	then
	echo
	echo -e "${RED}ERROR: Using unsupported procs in variables in a map file! Please remove all instances of this.${NC}"
	st=1
fi;

# Check for non-515 compatable .proc/ syntax
if grep -P --exclude='_byond_version_compat.dm' '\.proc/' code/**/*.dm; then
	echo
	echo -e "${RED}ERROR: Outdated proc reference use detected in code, please use proc reference helpers.${NC}"
	st=1
fi;

if [ $st = 0 ]; then
	echo
	echo -e "${GREEN}No errors found using grep!${NC}"
fi;

if [ $st = 1 ]; then
	echo
	echo -e "${RED}Errors found, please fix them and try again.${NC}"
fi;

exit $st
