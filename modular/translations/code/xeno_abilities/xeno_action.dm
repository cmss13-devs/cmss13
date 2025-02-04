/datum/action/xeno_action/New(Target, override_icon_state)
	. = ..()
	update_desc()

/// Helper proc for replacing text
/datum/action/xeno_action/proc/replace_in_desc(what_to_replace, replace_with, type)
	switch(type)
		if(DESCRIPTION_REPLACEMENT_TIME)
			desc = replacetext_char(desc, what_to_replace, "[round(replace_with, 0.1)] сек.")
		if(DESCRIPTION_REPLACEMENT_DISTANCE)
			desc = replacetext_char(desc, what_to_replace, "[replace_with] кл.")
		else
			desc = replacetext_char(desc, what_to_replace, replace_with)

/// Called when something changes and we need to reconstruct description
/datum/action/xeno_action/proc/update_desc()
	desc = initial(desc)
	apply_replaces_in_desc()
	post_desc()
	button.desc = desc

/// Override this to replace %TEXT% in desc with actual values
/datum/action/xeno_action/proc/apply_replaces_in_desc()
	return

/// Adds misc info post action's desc, like cooldown
/datum/action/xeno_action/proc/post_desc()
	if(xeno_cooldown)
		desc += "<br>Перезарядка: [round(xeno_cooldown / 10, 0.1)] сек."
	if(charge_time)
		desc += "<br>Задержка перед активацией: [round(charge_time / 10, 0.1)] сек."
