/client/verb/own_records()
	set name = "View Own Records"
	set category = "OOC.Records"

	var/list/options = list("Admin", "Merit", "Whitelist")

	var/choice = tgui_input_list(usr, "What record do you wish to view?", "Record Choice", options)
	switch(choice)
		if("Admin")
			show_own_notes(NOTE_ADMIN, choice)
		if("Merit")
			show_own_notes(NOTE_MERIT, choice)
		if("Whitelist")
			show_own_notes(NOTE_WHITELIST, choice)
		else
			return
	to_chat(usr, SPAN_NOTICE("Displaying your [choice] Record."))

/client/proc/show_own_notes(note_category, category_text)
	var/datum/entity/player/P = get_player_from_key(ckey)
	if(!P.migrated_notes)
		to_chat(usr, "Error: notes not yet migrated for that key. Please try again in 5 minutes.")
		return

	var/dat = "<html>"
	dat += "<body>"

	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, ckey))
	for(var/datum/view_record/note_view/N as anything in NL)

		if(N.is_confidential)
			continue
		if(!(!N.note_category && (note_category == NOTE_ADMIN)))
			if(N.note_category != note_category)
				continue
		var/admin_ckey = N.admin_ckey

		var/color = "#008800"

		switch(note_category)
			if(NOTE_MERIT)
				color = "#9e3dff"
			if(NOTE_WHITELIST)
				color = "#324da5"

		dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i> on <i><font color=blue>[N.date] [NOTE_ROUND_ID(N)]</i></font> "
		dat += "<br><br>"

	dat += "<br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Your [category_text] Record", "ownrecords", "size=480x480")




//Disclaimer - Below is the worst DM code I have ever written.
//It is written as proof of concept and needs heavy refinement.
//Contributions and suggestions are welcome.
//Kindly, forest2001

/client/proc/other_records()
	set name = "View Target Records"
	set category = "OOC.Records"

	///Management Access
	var/manager = FALSE
	///Edit Access
	var/add_wl = FALSE
	var/del_wl = FALSE

	///Note category options
	var/list/options = list()

	if(CLIENT_IS_STAFF(src))
		options = GLOB.note_categories.Copy()
		if(admin_holder.rights & R_PERMISSIONS)
			manager = TRUE
	else if(!isCouncil(src))
		to_chat(usr, SPAN_WARNING("Error: you are not authorised to view the records of another player!"))
		return

	var/target = input(usr, "What CKey do you wish to check?", "Target")
	if(!target)
		to_chat(src, SPAN_WARNING("Invalid Target"))
		return
	target = ckey(target)

	if(manager || isCouncil(src))
		options |= "Whitelist"
		add_wl = TRUE
	if(manager || isSenator(src))
		del_wl = TRUE

	var/choice = tgui_input_list(usr, "What record do you wish to view?", "Record Choice", options)
	if(!choice)
		return
	switch(choice)
		if("Admin")
			show_other_record(NOTE_ADMIN, choice, target, TRUE)
		if("Merit")
			show_other_record(NOTE_MERIT, choice, target, TRUE)
		if("Whitelist")
			show_other_record(NOTE_WHITELIST, choice, target, add_wl, del_wl)
	to_chat(usr, SPAN_NOTICE("Displaying [target]'s [choice] notes."))


/client/proc/show_other_record(note_category, category_text, target, can_edit = FALSE, can_del = FALSE)
	var/datum/entity/player/P = get_player_from_key(target)
	if(!P?.migrated_notes)
		to_chat(usr, "Error: notes not yet migrated for that key. Please try again in 5 minutes.")
		return

	var/dat = "<html>"
	dat += "<body>"

	var/color = "#008800"
	var/add_dat = "<A href='?src=\ref[admin_holder];[HrefToken()];add_player_info=[target]'>Add Admin Note</A><br><A href='?src=\ref[admin_holder];[HrefToken()];add_player_info_confidential=[target]'>Add Confidential Admin Note</A><br>"
	switch(note_category)
		if(NOTE_MERIT)
			color = "#9e3dff"
			add_dat = "<A href='?src=\ref[usr];add_merit_info=[target]'>Add Merit Note</A><br>"
		if(NOTE_WHITELIST)
			color = "#324da5"
			add_dat = "<A href='?src=\ref[usr];add_wl_info=[target]'>Add Whitelist Note</A><br>"

	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, target))
	for(var/datum/view_record/note_view/N as anything in NL)
		if(N.is_confidential)
			color = "#AA0055"
		if(!N.note_category && !(note_category == NOTE_ADMIN))
			continue
		else if(N.note_category && (N.note_category != note_category))
			continue
		var/admin_ckey = N.admin_ckey

		dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i> on <i><font color=blue>[N.date] [NOTE_ROUND_ID(N)]</i></font> "
		///Can remove notes from anyone other than yourself, unless you're the host. So long as you have deletion access anyway.
		if((can_del && target != get_player_from_key(key)) || ishost(usr))
			dat += "<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];remove_wl_info=[key];remove_index=[N.id]'>Remove</A>"

		dat += "<br><br>"

	dat += "<br>"
	if(can_edit || ishost(src))
		dat += add_dat

	dat += "</body></html>"
	show_browser(src, dat, "[target]'s [category_text] Notes", "otherplayersinfo", "size=480x480")

GLOBAL_DATUM_INIT(medals_view_tgui, /datum/medals_view_tgui, new)


/datum/medals_view_tgui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MedalsViewer", "[user.ckey]'s Medals")
		ui.open()

/datum/medals_view_tgui/ui_static_data(mob/user)
	. = ..()
	.["medals"] = list()

	for(var/datum/view_record/medal_view/medal as anything in get_medals(user))
		var/xeno_medal = FALSE
		if(medal.medal_type in GLOB.xeno_medals)
			xeno_medal = TRUE

		var/list/current_medal = list(
			"round_id" = medal.round_id,
			"medal_type" = medal.medal_type,
			"medal_icon" = replacetext(medal.medal_type, " ", "-"),
			"xeno_medal" = xeno_medal,
			"recipient_name" = medal.recipient_name,
			"recipient_role" = medal.recipient_role,
			"giver_name" = medal.giver_name,
			"citation" = medal.citation
		)

		.["medals"] += list(current_medal)

/datum/medals_view_tgui/proc/get_medals(mob/user)
	return DB_VIEW(/datum/view_record/medal_view, DB_COMP("player_id", DB_EQUALS, user.client.player_data.id))


/datum/medals_view_tgui/ui_state(mob/user)
	return GLOB.always_state

/datum/medals_view_tgui/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/medal)
	)

/client/verb/view_own_medals()
	set name = "View Own Medals"
	set category = "OOC.Records"

	GLOB.medals_view_tgui.tgui_interact(mob)

GLOBAL_DATUM_INIT(medals_view_given_tgui, /datum/medals_view_tgui/given_medals, new)


/datum/medals_view_tgui/given_medals/get_medals(mob/user)
	return DB_VIEW(/datum/view_record/medal_view, DB_COMP("giver_player_id", DB_EQUALS, user.client.player_data.id))


/datum/medals_view_tgui/given_medals/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MedalsViewer", "[user.ckey]'s Given Medals")
		ui.open()


/client/verb/view_given_medals()
	set name = "View Medals Given to Others"
	set category = "OOC.Records"

	GLOB.medals_view_given_tgui.tgui_interact(mob)
