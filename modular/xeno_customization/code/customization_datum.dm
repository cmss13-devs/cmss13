/// Assoc list: Caste Name - (Customization Name - Customization Datum)
GLOBAL_LIST_INIT_TYPED(xeno_customizations, /datum/xeno_customization_option, setup_all_xeno_customizations())

/proc/setup_all_xeno_customizations()
	var/list/data = list()
	for(var/customization in subtypesof(/datum/xeno_customization_option))
		var/datum/xeno_customization_option/select = new customization
		if(!select.caste)
			continue
		if(!select.icon_path)
			continue
		data["[select.caste]"] += list("[select.name]" = select)
	return data

/datum/xeno_customization_option
	var/name = "Call a coder!"
	var/customization_type = XENO_CUSTOMIZATION_NON_LORE_FRIENDLY
	var/icon_path
	var/caste
	var/slot
	var/donation_level
	var/full_body_customization = FALSE

/datum/xeno_customization_option/proc/is_locked(mob/user)
	// Do it later when SSCentral is active
	if(donation_level)
		to_chat(user, SPAN_WARNING("У вас не хватает уровня подписки!"))
		return TRUE
	return FALSE
