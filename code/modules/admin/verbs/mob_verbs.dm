// Converted this into a proc. Verb will be separate
/client/proc/change_ckey(mob/M in mob_list, var/a_ckey = null)
	var/new_ckey = a_ckey

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!M || M.disposed)
		return //mob was garbage collected

	if(!new_ckey)
		new_ckey = input("Enter new ckey:","CKey") as null|text

	if(!new_ckey)
		return
	if (M.client)
		M.ghostize()
	message_admins("[key_name_admin(usr)] modified [M.name]/([M.ckey])'s ckey to [new_ckey]", 1)
	 
	M.ckey = new_ckey
	var/mob/living/carbon/Xenomorph/XNO = M
	if(istype(XNO))
		XNO.generate_name()

/client/proc/cmd_admin_changekey(mob/O in mob_list)
	set name = "Change CKey"
	set category = null

	if(!istype(O) || (!check_rights(R_ADMIN|R_DEBUG|R_MOD))) // Copied Matt's checks
		return
	change_ckey(O)

/client/proc/cmd_admin_ghostchange(var/mob/living/M, var/mob/dead/observer/O)
	if(!istype(O) || (!check_rights(R_ADMIN|R_DEBUG, 0))) //Let's add a few extra sanity checks.
		return
	if(alert("Do you want to possess this mob?", "Switch Ckey", "Yes", "No") == "Yes")
		if(!M || !O) //Extra check in case the mob was deleted while we were transfering.
			return
		change_ckey(M, O.ckey)
	else return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in mob_list)
	set name = "Check Contents"
	set category = null

	var/list/L = M.get_contents()
	var/dat
	for(var/t in L)
		dat += "[t]<br>"

	show_browser(usr, dat, "Contents of [M]", "content")

/client/proc/cmd_admin_addhud(mob/M as mob in mob_list)
	set name = "Add HUD To"
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Why do you need to add a HUD to a ghost?")
		return

	var/list/listed_huds = list("Medical HUD", "Security HUD", "Squad HUD", "Xeno Status HUD")
	var/hud_choice = input("Choose a HUD to toggle", "Toggle HUD", null) as null|anything in listed_huds
	var/datum/mob_hud/H
	switch(hud_choice)
		if("Medical HUD")
			H = huds[MOB_HUD_MEDICAL_ADVANCED]
		if("Security HUD")
			H = huds[MOB_HUD_SECURITY_ADVANCED]
		if("Squad HUD")
			H = huds[MOB_HUD_SQUAD]
		if("Xeno Status HUD")
			H = huds[MOB_HUD_XENO_STATUS]
		else return

	H.add_hud_to(M)
	to_chat(src, SPAN_INFO("[hud_choice] enabled."))
	message_admins(SPAN_INFO("[key_name(usr)] has given a [hud_choice] to [M]."))

/client/proc/cmd_admin_gib(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Gib"

	if(!check_rights(R_ADMIN|R_FUN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)	return

	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

	if(istype(M, /mob/dead/observer))
		gibs(M.loc, M.viruses)
		return

	M.gib()

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in mob_list)
	set category = null
	set name = "Rejuvenate"
	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return

	M.revive(FALSE) // Argument means that viruses will be cured (except zombie virus)

	message_staff(WRAP_STAFF_LOG(usr, "ahealed [M.name] ([M.ckey]) in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

/client/proc/cmd_admin_subtle_message(mob/M as mob in mob_list)
	set name = "Subtle Message"
	set category = null

	if(!ismob(M))	
		return
	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/msg = input("You hear a voice in your head...:", text("Subtle PM to [M.key]")) as text

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.admin_holder && (usr.client.admin_holder.rights & R_MOD))
				to_chat(M, SPAN_ANNOUNCEMENT_HEADER_BLUE("You hear a voice in your head... [msg]"))

	message_staff(WRAP_STAFF_LOG(usr, "subtle messaged [M.name] ([M.ckey]), saying \"[msg]\" in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

/client/proc/cmd_admin_direct_narrate(var/mob/M)
	set name = "Narrate"
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text

	if(!msg)
		return

	to_chat(M, SPAN_ANNOUNCEMENT_HEADER_BLUE(msg))
	message_admins(SPAN_NOTICE("\bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]"), 1)

/client/proc/cmd_admin_attack_log(mob/M as mob in mob_list)
	set name = "Attack Log"
	set category = null

	to_chat(usr, SPAN_DANGER("<b>Attack Log for [mob]</b>"))
	for(var/t in M.attack_log)
		to_chat(usr, t)

/proc/possess(obj/O as obj in object_list)
	set name = "Possess Obj"
	set category = null

	var/turf/T = get_turf(O)

	if(T)
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location", 1)

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.loc = O
	usr.real_name = O.name
	usr.name = O.name
	usr.client.eye = O
	usr.control_object = O
	 
/proc/release(obj/O as obj in object_list)
	set name = "Release Obj"
	set category = null

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()
			H.change_real_name(H, usr.name_archive)

	usr.loc = O.loc // Appear where the object you were controlling is -- TLE
	usr.client.eye = usr
	usr.control_object = null

/client/proc/cmd_admin_drop_everything(mob/M as mob in mob_list)
	set name = "Drop Everything"
	set category = null

	if(!admin_holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		if(istype(W,/obj/item/alien_embryo)) continue
		M.drop_inv_item_on_ground(W)

	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!")

/client/proc/cmd_admin_change_their_hivenumber(var/mob/living/carbon/Xenomorph/X)
	set name = "Change Hivenumber"
	set category = null

	if(!istype(X))
		return

	var/hivenumber_status = X.hivenumber
	var/list/namelist = list("Normal","Corrupted","Alpha","Beta","Zeta")

	var/newhive = input(src,"Select a hive.", null, null) in namelist

	if(!X)
		to_chat(usr, "This xeno no longer exists")
		return
	var/newhivenumber
	var/newhivefaction
	switch(newhive)
		if("Normal")
			newhivenumber = XENO_HIVE_NORMAL
			newhivefaction = FACTION_XENOMORPH
		if("Corrupted")
			newhivenumber = XENO_HIVE_CORRUPTED
			newhivefaction = FACTION_XENOMORPH_CORRPUTED
		if("Alpha")
			newhivenumber = XENO_HIVE_ALPHA
			newhivefaction = FACTION_XENOMORPH_ALPHA
		if("Beta")
			newhivenumber = XENO_HIVE_BETA
			newhivefaction = FACTION_XENOMORPH_BETA
		if("Zeta")
			newhivenumber = XENO_HIVE_ZETA
			newhivefaction = FACTION_XENOMORPH_ZETA
	if(X.hivenumber != hivenumber_status)
		to_chat(usr, "Someone else changed this xeno while you were deciding")
		return

	X.set_hive_and_update(newhivenumber, newhivefaction)
	 
	message_admins(SPAN_NOTICE("[key_name(src)] changed hivenumber of [X] to [X.hivenumber]."))


/client/proc/cmd_admin_change_their_name(var/mob/living/carbon/X)
	set name = "Change Name"
	set category = null

	var/newname = input(usr, "What do you want to name them?", "Name:") as null|text
	if(!newname)
		return

	if(!X)
		to_chat(usr, "This mob no longer exists")
		return

	var/old_name = X.name
	X.change_real_name(X, newname)
	if(istype(X, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = X
		if(H.wear_id)
			H.wear_id.name = "[H.real_name]'s ID Card"
			H.wear_id.registered_name = "[H.real_name]"
			if(H.wear_id.assignment)
				H.wear_id.name += " ([H.wear_id.assignment])"
	 
	message_admins(SPAN_NOTICE("[key_name(src)] changed name of [old_name] to [newname]."))

/datum/admins/proc/togglesleep(var/mob/living/M as mob in mob_list)
	set name = "Toggle Sleeping"
	set category = null

	if(!check_rights(0))	return

	if (M.sleeping > 0)
		M.sleeping = 0
	else
		M.sleeping = 9999999

	message_staff("[key_name(usr)] used Toggle Sleeping on [key_name(M)].")
	return