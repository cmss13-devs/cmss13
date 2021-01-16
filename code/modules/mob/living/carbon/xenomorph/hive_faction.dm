GLOBAL_LIST_INIT(hive_alliable_factions, generate_alliable_factions())

/proc/generate_alliable_factions()
	. = list()
	.["Xenomorph"] = list()

	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		.["Xenomorph"] += hive.internal_faction

	.["Human"] = FACTION_LIST_HUMANOID

	.["Raw"] = .["Human"] + .["Xenomorph"]

/datum/hive_faction_ui
	var/name = "Hive Faction"

	var/datum/hive_status/assoc_hive = null

/datum/hive_faction_ui/New(var/datum/hive_status/hive_to_assign)
	. = ..()
	assoc_hive = hive_to_assign

/datum/hive_faction_ui/ui_state(mob/user)
	return GLOB.hive_state_queen[assoc_hive.internal_faction]

/datum/hive_faction_ui/tgui_interact(mob/user, datum/tgui/ui)
	if(!assoc_hive)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HiveFaction", "[assoc_hive.name] Faction Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/hive_faction_ui/ui_data(mob/user)
	. = list()
	.["current_allies"] = assoc_hive.allies

/datum/hive_faction_ui/ui_static_data(mob/user)
	. = list()
	.["glob_factions"] = GLOB.hive_alliable_factions

/datum/hive_faction_ui/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_ally")
			if(isnull(params["should_ally"]) || isnull(params["target_faction"]))
				return

			if(!(params["target_faction"] in GLOB.hive_alliable_factions["Raw"]))
				return

			var/should_ally = text2num(params["should_ally"])
			assoc_hive.allies[params["target_faction"]] = should_ally
			. = TRUE
