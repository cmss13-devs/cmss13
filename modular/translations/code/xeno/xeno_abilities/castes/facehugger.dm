/datum/action/xeno_action/activable/pounce/facehugger

/datum/action/xeno_action/activable/pounce/facehugger/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Если цель находится на расстоянии %HUG_RANGE% во время прыжка, то вы обхватите цель."
	replace_in_desc("%HUG_RANGE%", 1, DESCRIPTION_REPLACEMENT_DISTANCE)

// Handled by basic version
/datum/action/xeno_action/onclick/toggle_long_range/facehugger
