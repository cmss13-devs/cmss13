#!/bin/bash

# Default maps which are already included in the dme
# Other exempt maps also go in here. Please include a comment describing why it's exempt if it's not a default map
EXEMPT_MAPS=(
    "maps/Z.01.LV624.dmm"
    "maps/Z.02.Admin_Level.dmm"
    "maps/Z.03.USS_Almayer.dmm"
    # Whiskey is broken as fuck right now.
    # Remove the line when it's back in working order
    "maps/Z.01.Whiskey_Outpost_v2.dmm"
)

# Include everything but backup files and nightmare inserts
for filename in $(find maps -name '*.dmm' ! -wholename '*/backup/*.dmm' ! -wholename '*/Nightmare/*.dmm'); do
    # Skip maps that are already included/exempt from CI
    if [[ ${EXEMPT_MAPS[*]} =~ "$filename" ]]; then
        continue
    fi

    # Insert the includes
    echo "#include \"$filename\"" >> ColonialMarinesALPHA.dme
done
