////////////////////////////////
/proc/message_admins(msg, jmp_x=0, jmp_y=0, jmp_z=0) // +MOD and above, not mentors
	log_admin(msg)

	msg = "<span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]"
	if(jmp_x && jmp_y && jmp_z)
		msg += " (<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[jmp_x];Y=[jmp_y];Z=[jmp_z]'>JMP</a>)"
	msg += "</span>"

	for(var/client/C as anything in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			to_chat(C, SPAN_ADMIN(msg))

/proc/msg_admin_attack(text, jump_x, jump_y, jump_z) //Toggleable Attack Messages; server logs don't include the JMP part
	if(GLOB.perf_flags & PERF_TOGGLE_ATTACKLOGS)
		return
	log_attack(text)
	var/rendered = SPAN_COMBAT("<span class=\"prefix\">ATTACK:</span> [text] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[jump_x];Y=[jump_y];Z=[jump_z]'>JMP</a>)")
	for(var/client/C as anything in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_ATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

/proc/msg_admin_niche(msg) //Toggleable Niche Messages
	log_admin(msg)
	msg = SPAN_NICHE("<span class=\"prefix\">ADMIN NICHE LOG:</span> [msg]")
	for(var/client/C as anything in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_NICHELOGS)
				to_chat(C, msg)

/proc/msg_sea(msg, nosound = FALSE) //Only used for newplayer ticker message, hence no logging
	msg = FONT_SIZE_LARGE("<span class=\"admin\"><span class=\"prefix\">MENTOR ALERT:</span> <span class=\"message\">[msg]</span></span>")
	for(var/mob/possible_sea as anything in GLOB.player_list)
		if(!isSEA(possible_sea))
			continue

		to_chat(possible_sea, msg)
		if(possible_sea?.client.prefs?.toggles_sound & SOUND_ADMINHELP && !nosound)
			sound_to(possible_sea, 'sound/effects/mhelp.ogg')


/proc/msg_admin_ff(text, alive = TRUE)
	var/rendered
	if(alive)
		rendered = SPAN_COMBAT("<span class=\"prefix\">ATTACK:</span> <font color=#00FF00><b>[text]</b></font>") //I used <font> because I never learned html correctly, fix this if you want
	else
		rendered = SPAN_COMBAT("<span class=\"prefix\">ATTACK:</span> <font color=#FFA500><b>[text]</b></font>")
		text = "///DEAD/// - " + text
	log_attack(text) //Do everything normally BUT IN GREEN SO THEY KNOW
	for(var/client/C as anything in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_FFATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying


/datum/admins/proc/player_has_info(key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!LAZYLEN(infos)) return 0
	else return 1

/datum/admins/proc/player_notes_all(key as text)
	set category = null
	set name = "Player Record"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/dat = "<html>"
	dat += "<body>"
	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, key))
	for(var/datum/view_record/note_view/N in NL)
		var/admin_ckey = N.admin_ckey
		var/confidential_text = N.is_confidential ? " \[CONFIDENTIALLY\]" : ""
		var/color = "#008800"
		if(N.is_ban)
			var/time_d = N.ban_time ? "Banned for [N.ban_time] minutes | " : ""
			color = "#880000" //Removed confidential check because we can't make confidential bans
			dat += "<font color=[color]>[time_d][N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date] [NOTE_ROUND_ID(N)]</i></font> "
		else
			if(N.is_confidential)
				color = "#AA0055"
			else if(N.note_category == NOTE_MERIT)
				color = "#9e3dff"
			else if(N.note_category == NOTE_WHITELIST)
				color = "#324da5"

			dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date] [NOTE_ROUND_ID(N)]</i></font> "
		if(admin_ckey == usr.ckey || admin_ckey == "Adminbot" || check_for_rights(R_PERMISSIONS))
			dat += "<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];remove_player_info=[key];remove_index=[N.id]'>Remove</A>"

		dat += "<br><br>"
	dat += "</body></html>"

	show_browser(usr, dat, "Info on [key]", "allplayerinfo", "size=480x480")


/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN)) return
	var/L[] //List reference.
	var/r //rank --This will always be a string.
	var/c //ckey --This will always be a string.
	var/i //individual record / ban reason
	var/t //text to show in the window
	var/u //unban button href arg
	var/dat = "<table>"
	for(r in GLOB.jobban_keylist)
		L = GLOB.jobban_keylist[r]
		for(c in L)
			i = GLOB.jobban_keylist[r][c] //These are already strings, as you're iterating through them. Anyway, establish jobban.
			t = "[c] - [r] ## [i]"
			u = "[c] - [r]"
			dat += "<tr><td>[t] (<A href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];removejobban=[u]'>unban</A>)</td></tr>"
	dat += "</table>"
	show_browser(usr, dat, "Job Bans", "ban", "size=400x400")


/datum/admins/proc/Game()
	if(!check_rights(0)) return

	var/dat = {"
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];c_mode=1'>Change Game Mode</A><br>
		"}

	dat += {"
		<BR>
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];create_object=1'>Create Object</A><br>
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];quick_create_object=1'>Quick Create Object</A><br>
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];create_turf=1'>Create Turf</A><br>
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];create_mob=1'>Create Mob</A><br>
		<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];send_tip=1'>Immediately Send Tip</A><br>
		"}

	show_browser(usr, dat, "Game Panel", "admin2", "size=210x280")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc = "Respawn basically"
	set name = "Toggle Respawn"
	CONFIG_SET(flag/respawn, !CONFIG_GET(flag/respawn))
	if (CONFIG_GET(flag/respawn))
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn :(</B>")
	message_admins("[key_name_admin(usr)] toggled respawn to [CONFIG_GET(flag/respawn) ? "On" : "Off"].")
	world.update_status()


////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN)) return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(length(matches)==0)
		return

	var/chosen
	if(length(matches)==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(usr, "Select an atom type", "Spawn Atom", matches)
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")


/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()

/proc/ishost(whom)
	if(!whom)
		return 0
	var/client/C
	var/mob/M
	if(istype(whom, /client))
		C = whom
	else if(istype(whom, /mob))
		M = whom
		if(M.client)
			C = M.client
		else
			return 0
	else
		return 0
	if(C.admin_holder && R_HOST & C.admin_holder.rights)
		return 1
	else
		return 0

/datum/admins/proc/send_tip()
	if(SSticker)
		var/success = SSticker.send_tip_of_the_round()
		if(!success)
			to_chat(usr, SPAN_ADMINNOTICE("Sending tip failed!"))

/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/available_traits = list()

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.traits_by_type)
				if(istype(D,key))
					available_traits += GLOB.traits_by_type[key]
		if("Remove")
			if(!GLOB.trait_name_map)
				GLOB.trait_name_map = generate_trait_name_map()
			for(var/trait in D._status_traits)
				var/name = GLOB.trait_name_map[trait] || trait
				available_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in sort_list(available_traits)
	if(!chosen_trait)
		return
	chosen_trait = available_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			ADD_TRAIT(D,chosen_trait,source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in sort_list(D._status_traits[chosen_trait])
					if(!source)
						return
			REMOVE_TRAIT(D,chosen_trait,source)
