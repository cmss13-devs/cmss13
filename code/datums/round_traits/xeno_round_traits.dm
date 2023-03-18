/datum/xeno_round_traits/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoRoundTraits")
		ui.open()

/datum/xeno_round_traits/ui_data(mob/user)
	var/data = list()

	data["traits"] = list()
	for(var/datum/round_trait/trait as anything in SSround.round_traits)
		if(!trait.show_in_xeno_report || !trait.xeno_report_message)
			continue

		var/trait_info = list()
		trait_info["name"] = trait.name
		trait_info["report"] = trait.xeno_report_message
		data["traits"] += list(trait_info)

	return data

/datum/xeno_round_traits/ui_static_data(mob/user)
	var/data = list()

	data["groundmap_name"] = SSmapping.configs[GROUND_MAP].map_name

	return data

/datum/xeno_round_traits/ui_state(mob/user)
	return GLOB.always_state
