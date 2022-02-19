#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

if grep -El '^\".+\" = \(.+\)' maps/**/*.dmm;	then
    echo "ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
if grep -P 'step_[xy]' maps/**/*.dmm;	then
    echo "ERROR: step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
if grep -P '\W\/turf\s*[,\){]' maps/**/*.dmm; then
    echo "ERROR: base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
if ls maps/*.json | grep -P "[A-Z]"; then
    echo "Uppercase in a map json detected, these must be all lowercase."
    st=1
fi;
for json in maps/*.json
do
    map_path=$(jq -r '.map_path' $json)
    while read map_file; do
        filename="maps/$map_path/$map_file"
        if [ ! -f $filename ]
        then
            echo "found invalid file reference to $filename in maps/$json"
            st=1
        fi
    done < <(jq -r '[.map_file] | flatten | .[]' $json)
done

exit $st
