//CO Whitelist is '1', Synthetic Whitelist is '2', Yautja Whitelist is '3'.

/client/verb/own_records()
	set name = "View Own Records"
	set category = "OOC.Records"

	var/list/options = list("Admin", "Merit", "Commanding Officer", "Synthetic", "Yautja")

	var/choice = tgui_input_list(usr, "What record do you wish to view?", "Record Choice", options)
	switch(choice)
		if("Admin")
			show_own_notes(NOTE_ADMIN, choice)
		if("Merit")
			show_own_notes(NOTE_MERIT, choice)
		if("Commanding Officer")
			show_own_notes(NOTE_COMMANDER, choice)
		if("Synthetic")
			show_own_notes(NOTE_SYNTHETIC, choice)
		if("Yautja")
			show_own_notes(NOTE_YAUTJA, choice)
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
			if(NOTE_COMMANDER)
				color = "#324da5"
			if(NOTE_SYNTHETIC)
				color = "#39e7a4"
			if(NOTE_YAUTJA)
				color = "#114e11"

		dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i> on <i><font color=blue>[N.date]</i></font> "
		dat += "<br><br>"

	dat += "<br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Your [category_text] Record", "ownrecords", "size=480x480")




//Disclaimer - Below is the worst DM code I have ever written.
//It is written as proof of concept and needs heavy refinement.
//Contributions and suggestions are welcome.
//Kindly, forest2001

/client/verb/other_records()
	set name = "View Target Records"
	set category = "OOC.Records"

	///Management Access
	var/MA
	///Edit Access
	var/edit_C = FALSE
	var/edit_S = FALSE
	var/edit_Y = FALSE

	///Note category options
	var/list/options = list()

	if(CLIENT_IS_STAFF(src))
		options = note_categories.Copy()
		if(admin_holder.rights & R_PERMISSIONS)
			MA = TRUE
	else if(!isCouncil(src))
		to_chat(usr, SPAN_WARNING("Error: you are not authorised to view the records of another player!"))
		return

	var/target = input(usr, "What CKey do you wish to check?", "Target")
	if(!target)
		to_chat(src, SPAN_WARNING("Invalid Target"))
		return
	target = ckey(target)

	if(RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_COMMANDER_COUNCIL)
		options |= "Commanding Officer"
		edit_C = TRUE
	if(RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_SYNTHETIC_COUNCIL)
		options |= "Synthetic"
		edit_S = TRUE
	if(RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_YAUTJA_COUNCIL)
		options |= "Yautja"
		edit_Y = TRUE

	var/choice = tgui_input_list(usr, "What record do you wish to view?", "Record Choice", options)
	if(!choice)
		return
	switch(choice)
		if("Admin")
			show_other_record(NOTE_ADMIN, choice, target, TRUE)
		if("Merit")
			show_other_record(NOTE_MERIT, choice, target, TRUE)
		if("Commanding Officer")
			if(MA || (RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_COMMANDER_LEADER))
				show_other_record(NOTE_COMMANDER, choice, target, TRUE, TRUE)
			else
				show_other_record(NOTE_COMMANDER, choice, target, edit_C)
		if("Synthetic")
			if(MA || (RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_SYNTHETIC_LEADER))
				show_other_record(NOTE_SYNTHETIC, choice, target, TRUE, TRUE)
			else
				show_other_record(NOTE_SYNTHETIC, choice, target, edit_S)
		if("Yautja")
			if(MA || (RoleAuthority.roles_whitelist[src.ckey] & WHITELIST_YAUTJA_LEADER))
				show_other_record(NOTE_YAUTJA, choice, target, TRUE, TRUE)
			else
				show_other_record(NOTE_YAUTJA, choice, target, edit_Y)
	to_chat(usr, SPAN_NOTICE("Displaying [target]'s [choice] notes."))


/client/proc/show_other_record(note_category, category_text, target, can_edit = FALSE, can_del = FALSE)
	var/datum/entity/player/P = get_player_from_key(target)
	if(!P?.migrated_notes)
		to_chat(usr, "Error: notes not yet migrated for that key. Please try again in 5 minutes.")
		return

	var/dat = "<html>"
	dat += "<body>"

	var/color = "#008800"
	var/add_dat = "<A href='?src=\ref[admin_holder];add_player_info=[target]'>Add Admin Note</A><br><A href='?src=\ref[admin_holder];add_player_info_confidential=[target]'>Add Confidential Admin Note</A><br>"
	switch(note_category)
		if(NOTE_MERIT)
			color = "#9e3dff"
			add_dat = "<A href='?src=\ref[usr];add_merit_info=[target]'>Add Merit Note</A><br>"
		if(NOTE_COMMANDER)
			color = "#324da5"
			add_dat = "<A href='?src=\ref[usr];add_wl_info_1=[target]'>Add Commander Note</A><br>"
		if(NOTE_SYNTHETIC)
			color = "#39e7a4"
			add_dat = "<A href='?src=\ref[usr];add_wl_info_2=[target]'>Add Synthetic Note</A><br>"
		if(NOTE_YAUTJA)
			color = "#114e11"
			add_dat = "<A href='?src=\ref[usr];add_wl_info_3=[target]'>Add Yautja Note</A><br>"

	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, target))
	for(var/datum/view_record/note_view/N as anything in NL)
		if(N.is_confidential)
			color = "#AA0055"
		if(!N.note_category && !(note_category == NOTE_ADMIN))
			continue
		else if(N.note_category && (N.note_category != note_category))
			continue
		var/admin_ckey = N.admin_ckey

		dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i> on <i><font color=blue>[N.date]</i></font> "
		///Can remove notes from anyone other than yourself, unless you're the host. So long as you have deletion access anyway.
		if((can_del && target != get_player_from_key(key)) || ishost(usr))
			dat += "<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];remove_wl_info=[key];remove_index=[N.id]'>Remove</A>"

		dat += "<br><br>"

	dat += "<br>"
	if(can_edit || ishost(src))
		dat += add_dat

	dat += "</body></html>"
	show_browser(src, dat, "[target]'s [category_text] Notes", "otherplayersinfo", "size=480x480")
