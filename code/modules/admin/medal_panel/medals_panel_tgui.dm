GLOBAL_DATUM_INIT(medals_panel, /datum/medals_panel_tgui, new)

/datum/medals_panel_tgui
	var/name = "Medals Panel"

/datum/medals_panel_tgui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MedalsPanel", "Medals Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/medals_panel_tgui/ui_state(mob/user)
	return GLOB.admin_state

/datum/medals_panel_tgui/ui_data(mob/user)
	var/list/data = list()
	var/list/uscm_awards = list()
	var/list/xeno_awards = list()
	var/list/uscm_award_ckeys = list()
	var/list/xeno_award_ckeys = list()

	// Break the medals up by recipient and then pack each medal into a string
	for(var/recipient_name as anything in GLOB.medal_awards)
		var/datum/recipient_awards/recipient_award = GLOB.medal_awards[recipient_name]
		uscm_awards[recipient_name] = list()
		uscm_award_ckeys[recipient_name] = recipient_award.recipient_ckey ? " ([recipient_award.recipient_ckey])" : ""
		for(var/i in 1 to length(recipient_award.medal_names)) // We're assuming everything is same length
			uscm_awards[recipient_name] += "[recipient_award.medal_names[i]]: \'[recipient_award.medal_citations[i]]\' by [recipient_award.giver_rank[i] ? "[recipient_award.giver_rank[i]] " : ""][recipient_award.giver_name[i] ? "[recipient_award.giver_name[i]] " : ""]([recipient_award.giver_ckey[i]])."

	for(var/recipient_name as anything in GLOB.jelly_awards)
		var/datum/recipient_awards/recipient_award = GLOB.jelly_awards[recipient_name]
		xeno_awards[recipient_name] = list()
		xeno_award_ckeys[recipient_name] = recipient_award.recipient_ckey ? " ([recipient_award.recipient_ckey])" : ""
		for(var/i in 1 to length(recipient_award.medal_names)) // We're assuming everything is same length
			xeno_awards[recipient_name] += "[recipient_award.medal_names[i]]: \'[recipient_award.medal_citations[i]]\' by [recipient_award.giver_rank[i] ? "[recipient_award.giver_rank[i]] " : ""][recipient_award.giver_name[i] ? "[recipient_award.giver_name[i]] " : ""]([recipient_award.giver_ckey[i]])."

	data["uscm_awards"] = uscm_awards
	data["xeno_awards"] = xeno_awards
	data["uscm_award_ckeys"] = uscm_award_ckeys
	data["xeno_award_ckeys"] = xeno_award_ckeys
	return data

/datum/medals_panel_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("refresh")
			return TRUE

		if("add_medal")
			usr.client.award_medal()
			return TRUE

		if("add_jelly")
			usr.client.award_jelly() // Done this way to re-use some hive-selection code in event_tab.dm
			return TRUE

		if("delete_medal")
			remove_award(params["recipient"], TRUE, params["index"] + 1) // Why is byond not 0 indexed?
			return TRUE

		if("delete_jelly")
			remove_award(params["recipient"], FALSE, params["index"] + 1) // Why is byond not 0 indexed?
			return TRUE

