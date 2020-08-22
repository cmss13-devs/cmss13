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
		M.ghostize(FALSE)
	message_staff("[key_name_admin(usr)] modified [key_name(M)]'s ckey to [new_ckey]", 1)
	 
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
			H = huds[MOB_HUD_SQUAD_OBSERVER]
		if("Xeno Status HUD")
			H = huds[MOB_HUD_XENO_STATUS]
		else return

	H.add_hud_to(M)
	to_chat(src, SPAN_INFO("[hud_choice] enabled."))
	message_staff(SPAN_INFO("[key_name(usr)] has given a [hud_choice] to [M]."))

/client/proc/cmd_admin_gib(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Gib"

	if(!check_rights(R_ADMIN|R_FUN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)	return

	message_staff("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

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

	message_staff(WRAP_STAFF_LOG(usr, "ahealed [key_name(M)] in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

/client/proc/cmd_admin_subtle_message(mob/M as mob in mob_list)
	set name = "Subtle Message"
	set category = null

	if(!ismob(M))	
		return
	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/subtle_message_options = list("Voice in head", "Weston-Yamada", "USCM High Command", "Faction-specific")

	var/message_option = input("Choose the method of subtle messaging", "") in subtle_message_options

	if(message_option == "Faction-specific")
		message_option = input("Choose which faction", "")

	if(!message_option)
		return

	var/msg = input("Contents of the message", text("Subtle PM to [M.key]")) as text

	if (!msg)
		return

	switch(message_option)
		if("Voice in head")
			to_chat(M, SPAN_ANNOUNCEMENT_HEADER_BLUE("You hear a voice in your head... [msg]"))
		else
			var/mob/living/carbon/human/H = M

			if(!istype(H))
				to_chat(usr, "The person you are trying to contact is not human")
				return

			if(!istype(H.wear_ear, /obj/item/device/radio/headset))
				to_chat(usr, "The person you are trying to contact is not wearing a headset")
				return
			to_chat(H, SPAN_DANGER("Message received through headset. [message_option] Transmission <b>\"[msg]\"</b>"))

	message_staff(WRAP_STAFF_LOG(usr, "subtle messaged [key_name(M)] as [message_option], saying \"[msg]\" in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

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
	message_staff(SPAN_NOTICE("\bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]"), 1)

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
		message_staff("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		message_staff("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location", 1)

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

	message_staff("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!")

/client/proc/cmd_admin_change_their_hivenumber(var/mob/living/carbon/H)
	set name = "Change Hivenumber"
	set category = null

	if(!istype(H))
		return

	var/list/hives = list()
	for(var/datum/hive_status/hive in hive_datum)
		hives += list("[hive.name]" = hive.hivenumber)

	var/newhive = input(src,"Select a hive.", null, null) in hives

	if(!H)
		to_chat(usr, "This mob no longer exists")
		return

	if(isXeno(H))
		var/mob/living/carbon/Xenomorph/X = H
		X.set_hive_and_update(hives[newhive])
	else
		var/was_leader = FALSE
		if(H.hivenumber)
			var/datum/hive_status/hive = hive_datum[H.hivenumber]
			if(H == hive.leading_cult_sl)
				was_leader = TRUE
			hive.leading_cult_sl = null

		H.hivenumber = hives[newhive]

		var/datum/hive_status/hive = hive_datum[H.hivenumber]
		H.faction = hive.name

		if(was_leader && (!hive.leading_cult_sl || hive.leading_cult_sl.stat == DEAD))
			hive.leading_cult_sl = H
	 
	message_staff(SPAN_NOTICE("[key_name(src)] changed hivenumber of [H] to [H.hivenumber]."))


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
	 
	message_staff(SPAN_NOTICE("[key_name(src)] changed name of [old_name] to [newname]."))

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