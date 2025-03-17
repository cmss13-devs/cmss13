#define NARRATION_METHOD_SAY "Say"
#define NARRATION_METHOD_ME "Me"
#define NARRATION_METHOD_DIRECT "Direct"

// Converted this into a proc. Verb will be separate
/client/proc/change_ckey(mob/M in GLOB.mob_list, a_ckey = null)
	var/new_ckey = a_ckey

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!M || QDELETED(M))
		return //mob was garbage collected

	if(!new_ckey)
		new_ckey = input("Enter new ckey:","CKey") as null|text

	if(!new_ckey)
		return
	if (M.client)
		M.ghostize(FALSE)
	M.aghosted = FALSE //Incase you ckey into an aghosted body.
	message_admins("[key_name_admin(usr)] modified [key_name(M)]'s ckey to [new_ckey]", 1)

	M.ckey = new_ckey
	M.client?.change_view(GLOB.world_view_size)

/client/proc/cmd_admin_changekey(mob/O in GLOB.mob_list)
	set name = "Change CKey"
	set category = null

	if(!istype(O) || (!check_rights(R_ADMIN|R_DEBUG|R_MOD))) // Copied Matt's checks
		return
	change_ckey(O)

/client/proc/cmd_admin_ghostchange(mob/living/M, mob/dead/observer/O)
	if(!istype(O) || (!check_rights(R_ADMIN|R_DEBUG, 0))) //Let's add a few extra sanity checks.
		return
	if(alert("Do you want to possess this mob?", "Switch Ckey", "Yes", "No") == "Yes")
		if(!M || !O) //Extra check in case the mob was deleted while we were transfering.
			return
		change_ckey(M, O.ckey)
	else
		return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in GLOB.living_mob_list)
	set name = "Check Contents"
	set category = null

	var/list/L = M.get_contents()
	var/dat
	for(var/t in L)
		dat += "[t]<br>"

	show_browser(usr, dat, "Contents of [M]", "content")

/client/proc/cmd_admin_addhud(mob/M as mob in GLOB.mob_list)
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
	var/hud_choice = tgui_input_list(usr, "Choose a HUD to toggle", "Toggle HUD", listed_huds)
	var/datum/mob_hud/H
	switch(hud_choice)
		if("Medical HUD")
			H = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
		if("Security HUD")
			H = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
		if("Squad HUD")
			H = GLOB.huds[MOB_HUD_FACTION_OBSERVER]
		if("Xeno Status HUD")
			H = GLOB.huds[MOB_HUD_XENO_STATUS]
		else
			return

	H.add_hud_to(M, HUD_SOURCE_ADMIN)
	to_chat(src, SPAN_INFO("[hud_choice] enabled."))
	message_admins(SPAN_INFO("[key_name(usr)] has given a [hud_choice] to [M]."))

/client/proc/cmd_admin_gib(mob/M as mob in GLOB.mob_list)
	set category = "Admin.Fun"
	set name = "Gib"

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)
		return

	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

	if(istype(M, /mob/dead/observer))
		gibs(M.loc, M.viruses)
		return

	M.gib()

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in GLOB.living_mob_list)
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

	message_admins(WRAP_STAFF_LOG(usr, "ahealed [key_name(M)] in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

/client/proc/cmd_admin_subtle_message(mob/M as mob in GLOB.mob_list)
	set name = "Subtle Message"
	set category = null

	if(!ismob(M))
		return
	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/subtle_message_options = list("Voice in head", "QM Psychic Whisper", "Weyland-Yutani", "USCM High Command", "Faction-specific")

	var/message_option = tgui_input_list(usr, "Choose the method of subtle messaging", "", subtle_message_options)

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

		if("QM Psychic Whisper")
			if(isxeno(M))
				to_chat(M, SPAN_XENONOTICE("You hear the voice of the Queen Mother... [msg]"))
			else
				to_chat(M, SPAN_XENONOTICE("You hear a strange, distant, alien voice in your head... [msg]"))
		else
			var/mob/living/carbon/human/H = M

			if(!istype(H))
				to_chat(usr, "The person you are trying to contact is not human")
				return

			if(!H.get_type_in_ears(/obj/item/device/radio/headset))
				to_chat(usr, "The person you are trying to contact is not wearing a headset")
				return
			to_chat(H, SPAN_ANNOUNCEMENT_HEADER_BLUE("Message received through headset. [message_option] Transmission <b>\"[msg]\"</b>"))

	var/message = WRAP_STAFF_LOG(usr, SPAN_STAFF_IC("subtle messaged [key_name(M)] as [message_option], saying \"[msg]\" in [get_area(M)] ([M.x],[M.y],[M.z])."))
	message_admins(message, M.x, M.y, M.z)
	admin_ticket_log(M, message)

/client/proc/cmd_admin_alert_message(mob/M)
	set name = "Alert Message"
	set category = "Admin.Game"

	if(!ismob(M))
		return
	if (!CLIENT_IS_STAFF(src))
		to_chat(src, "Only administrators may use this command.")
		return

	var/res = alert(src, "Do you wish to send an admin alert to this user?",,"Yes","No","Custom")
	switch(res)
		if("Yes")
			var/message = "An admin is trying to talk to you!<br>Check your chat window and click their name to respond or you may be banned!"

			show_blurb(M, 15, message, null, "center", "center", COLOR_RED, null, null, 1)
			log_admin("[key_name(src)] sent a default admin alert to [key_name(M)].")
			message_admins("[key_name(src)] sent a default admin alert to [key_name(M)].")
		if("Custom")
			var/message = input(src, "Input your custom admin alert text:", "Message") as text|null
			if(!message)
				return

			var/new_color = input(src, "Input your message color:", "Color Selector") as color|null
			if(!new_color)
				return

			show_blurb(M, 15, message, null, "center", "center", new_color, null, null, 1)
			log_admin("[key_name(src)] sent an admin alert to [key_name(M)] with custom message [message].")
			message_admins("[key_name(src)] sent an admin alert to [key_name(M)] with custom message [message].")
		else
			return

/client/proc/cmd_admin_object_narrate(obj/selected in view(src))
	set name = "Object Narrate"
	set category = null

	if(!check_rights(R_MOD))
		return

	var/type = tgui_input_list(usr,
				"What type of narration?",
				"Narration",
				list(NARRATION_METHOD_SAY, NARRATION_METHOD_ME, NARRATION_METHOD_DIRECT))
	if(!type)
		return
	var/message = input(usr,
				"What should it say?",
				"Narrating as [selected.name]")
	if(!message)
		return

	var/list/heard = get_mobs_in_view(GLOB.world_view_size, selected)

	switch(type)
		if(NARRATION_METHOD_SAY)
			selected.langchat_speech(message, heard, GLOB.all_languages, skip_language_check = TRUE)
			selected.visible_message("<b>[selected]</b> says, \"[message]\"")
		if(NARRATION_METHOD_ME)
			selected.langchat_speech(message, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
			selected.visible_message("<b>[selected]</b> [message]")
		if(NARRATION_METHOD_DIRECT)
			selected.visible_message("[message]")
	log_admin("[key_name(src)] sent an Object Narrate with message [message].")
	message_admins("[key_name(src)] sent an Object Narrate with message [message].")

/client/proc/cmd_admin_direct_narrate(mob/M in GLOB.mob_list)
	set name = "Narrate"
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!M)
		M = tgui_input_list(usr, "Direct narrate to who?", "Active Players", GLOB.player_list)

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text

	if(!msg)
		return

	to_chat(M, SPAN_ANNOUNCEMENT_HEADER_BLUE(msg))
	message_admins("\bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")

/client/proc/cmd_admin_attack_log(mob/M as mob in GLOB.mob_list)
	set name = "Attack Log"
	set category = null

	if (!CLIENT_IS_STAFF(src))
		to_chat(src, "Only administrators may use this command.")
		return

	to_chat(usr, SPAN_DANGER("<b>Attack Log for [mob]</b>"))
	for(var/t in M.attack_log)
		to_chat(usr, t)

/client/proc/possess(obj/O as obj in world)
	set name = "Possess Obj"
	set category = null

	if (!CLIENT_IS_STAFF(src))
		to_chat(src, "Only administrators may use this command.")
		return

	var/turf/T = get_turf(O)

	if(T)
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location", 1)

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.forceMove(O)
	usr.real_name = O.name
	usr.name = O.name
	usr.client.eye = O
	usr.control_object = O

/client/proc/release(obj/O as obj in world)
	set name = "Release Obj"
	set category = null

	if (!CLIENT_IS_STAFF(src))
		to_chat(src, "Only administrators may use this command.")
		return

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()
			H.change_real_name(H, usr.name_archive)

	usr.forceMove(O.loc )// Appear where the object you were controlling is -- TLE
	usr.client.eye = usr
	usr.control_object = null

/client/proc/cmd_admin_drop_everything(mob/M as mob in GLOB.mob_list)
	set name = "Drop Everything"
	set category = null

	if(!admin_holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		if(istype(W,/obj/item/alien_embryo))
			continue
		M.drop_inv_item_on_ground(W)

	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!")

/client/proc/cmd_admin_change_their_hivenumber(mob/living/carbon/H in GLOB.living_mob_list)
	set name = "Change Hivenumber"
	set category = null

	if(!istype(H))
		return

	var/list/hives = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		hives += list("[hive.name]" = hive.hivenumber)

	var/newhive = tgui_input_list(src,"Select a hive.", "Change Hivenumber", hives, theme="hive_status")

	if(!H)
		to_chat(usr, "This mob no longer exists")
		return

	if(isxeno(H))
		var/mob/living/carbon/xenomorph/X = H
		X.set_hive_and_update(hives[newhive])
	else
		var/was_leader = FALSE
		if(H.hivenumber)
			var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
			if(H == hive.leading_cult_sl)
				was_leader = TRUE
			hive.leading_cult_sl = null

		H.hivenumber = hives[newhive]

		var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
		H.faction = hive.internal_faction

		if(was_leader && (!hive.leading_cult_sl || hive.leading_cult_sl.stat == DEAD))
			hive.leading_cult_sl = H

	message_admins("[key_name(src)] changed hivenumber of [H] to [H.hivenumber].")


/client/proc/cmd_admin_change_their_name(mob/living/carbon/carbon in GLOB.living_mob_list)
	set name = "Change Name"
	set category = null

	var/newname = input(usr, "What do you want to name them?", "Name:") as null|text
	if(!newname)
		return

	if(!carbon)
		to_chat(usr, "This mob no longer exists")
		return

	var/old_name = carbon.name
	carbon.change_real_name(carbon, newname)
	if(ishuman(carbon))
		var/mob/living/carbon/human/human = carbon
		var/obj/item/card/id/card = human.get_idcard()
		if(card)
			card.name = "[human.real_name]'s [card.id_type]"
			card.registered_name = "[human.real_name]"
			if(card.assignment)
				card.name += " ([card.assignment])"

	message_admins("[key_name(src)] changed name of [old_name] to [newname].")

/datum/admins/proc/togglesleep(mob/living/M as mob in GLOB.mob_list)
	set name = "Toggle Sleeping"
	set category = null

	if(!check_rights(0))
		return

	if (M.sleeping > 0) //if they're already slept, set their sleep to zero and remove the icon
		M.sleeping = 0
		M.RemoveSleepingIcon()
	else
		M.sleeping = 9999999 //if they're not, sleep them and add the sleep icon, so other marines nearby know not to mess with them.
		M.AddSleepingIcon()

	message_admins("[key_name(usr)] used Toggle Sleeping on [key_name(M)].")
	return

#undef NARRATION_METHOD_SAY
#undef NARRATION_METHOD_ME
#undef NARRATION_METHOD_DIRECT
