////////////////////////////////
/proc/message_admins(var/msg) // +ADMIN and above
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_admin(msg)
	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (R_ADMIN & C.admin_holder.rights))
			to_chat(C, msg)

/proc/message_staff(var/msg, var/jmp_x=0, var/jmp_y=0, var/jmp_z=0) // +MOD and above, not mentors
	log_admin(msg)

	msg = "<span class=\"prefix\">STAFF LOG:</span> <span class=\"message\">[msg]"
	if(jmp_x && jmp_y && jmp_z)
		msg += " (<a href='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[jmp_x];Y=[jmp_y];Z=[jmp_z]'>JMP</a>)"
	msg += "</span>"

	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			to_chat(C, SPAN_ADMIN(msg))

/proc/msg_admin_attack(var/text, jump_x, jump_y, jump_z) //Toggleable Attack Messages; server logs don't include the JMP part
	log_attack(text)
	var/rendered = SPAN_COMBAT("<span class=\"prefix\">ATTACK:</span> [text] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[jump_x];Y=[jump_y];Z=[jump_z]'>JMP</a>)")
	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_ATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

/proc/msg_admin_niche(var/msg) //Toggleable Niche Messages
	log_admin(msg)
	msg = SPAN_ADMIN("<span class=\"prefix\">ADMIN NICHE LOG:</span> [msg]")
	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_NICHELOGS)
				to_chat(C, msg)

/proc/msg_admin_ff(var/text)
	log_attack(text) //Do everything normally BUT IN GREEN SO THEY KNOW
	var/rendered = SPAN_COMBAT("<span class=\"prefix\">ATTACK:</span> <font color=#00ff00><b>[text]</b></font>") //I used <font> because I never learned html correctly, fix this if you want
	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_FFATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying


/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || !infos.len) return 0
	else return 1

/datum/admins/proc/player_notes_copy(var/key as text)
	set category = null
	set name = "Player Notes Copy"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat = "<html>"
	dat += "<body>"
	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, key))
	for(var/datum/view_record/note_view/N in NL)
		if(N.is_confidential)
			continue
		var/ban_text = N.ban_time ? "Banned for [N.ban_time] | " : ""
		dat += "[ban_text][N.text]<br/>on [N.date]<br/><br/>"

	dat += "</body></html>"

	show_browser(usr, dat, "Copying notes for [key]", "notescopy", "size=480x480")


/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN)) return
	var/L[] //List reference.
	var/r //rank --This will always be a string.
	var/c //ckey --This will always be a string.
	var/i //individual record / ban reason
	var/t //text to show in the window
	var/u //unban button href arg
	var/dat = "<table>"
	for(r in jobban_keylist)
		L = jobban_keylist[r]
		for(c in L)
			i = jobban_keylist[r][c] //These are already strings, as you're iterating through them. Anyway, establish jobban.
			t = "[c] - [r] ## [i]"
			u = "[c] - [r]"
			dat += "<tr><td>[t] (<A href='?src=\ref[src];removejobban=[u]'>unban</A>)</td></tr>"
	dat += "</table>"
	show_browser(usr, dat, "Job Bans", "ban", "size=400x400")


/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(master_mode == "secret")
		dat += "<A href='?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
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
	message_staff("[key_name_admin(usr)] toggled respawn to [CONFIG_GET(flag/respawn) ? "On" : "Off"].")
	world.update_status()


////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
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
