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
	. = list()
	var/list/uscm_awards = list()
	var/list/xeno_awards = list()
	
	// Break the medals up by recipient and then pack each medal into a string
	for(var/recipient_name as anything in GLOB.medal_awards)
		var/datum/recipient_awards/RA = GLOB.medal_awards[recipient_name]
		uscm_awards[recipient_name] = list()
		for(var/i in 1 to RA.medal_names.len) // We're assuming everything is same length
			uscm_awards[recipient_name] += "[RA.medal_names[i]]: \'[RA.medal_citations[i]]\' by [RA.giver_rank[i]] [RA.giver_name[i]]"
		
	for(var/recipient_name as anything in GLOB.jelly_awards)
		var/datum/recipient_awards/RA = GLOB.jelly_awards[recipient_name]
		xeno_awards[recipient_name] = list()
		for(var/i in 1 to RA.medal_names.len) // We're assuming everything is same length
			xeno_awards[recipient_name] += "[RA.medal_names[i]]: \'[RA.medal_citations[i]]\' by [RA.giver_rank[i]] [RA.giver_name[i]]"
	
	.["uscm_awards"] = uscm_awards
	.["xeno_awards"] = xeno_awards

/datum/medals_panel_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("refresh")
			ui = SStgui.try_update_ui(usr, src, ui)

		if("add medal")
			usr.client.award_medal()

		if("add jelly")
			usr.client.award_jelly() // Done this way to re-use some hive-selection code in event_tab.dm

		if("delete medal")
			remove_award(params["recipient"], TRUE, params["index"] + 1) // Why is byond not 0 indexed?
		
		if("delete jelly")
			remove_award(params["recipient"], FALSE, params["index"] + 1) // Why is byond not 0 indexed?	
	