

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if (usr.is_mob_incapacitated())
		return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	if(next_move < world.time)
		next_move = world.time + 2
	return

/mob/verb/toggle_normal_throw()
	set name = "Toggle Normal Throw"
	set category = "IC"
	set hidden = TRUE
	set src = usr

	to_chat(usr, SPAN_DANGER("This mob type cannot throw items."))
	return

/mob/verb/toggle_high_toss()
	set name = "Toggle High Toss"
	set category = "IC"
	set hidden = TRUE
	set src = usr

	to_chat(usr, SPAN_DANGER("This mob type cannot throw items."))
	return

/mob/proc/point_to(atom/A in view())
	//set name = "Point To"
	//set category = "Object"

	if(!isturf(src.loc) || !(A in view(src.loc)))//target is no longer visible to us
		return 0

	if(!A.mouse_opacity)//can't click it? can't point at it.
		return 0

	if(is_mob_incapacitated() || (status_flags & FAKEDEATH)) //incapacitated, can't point
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	if(recently_pointed_to > world.time)
		return 0

	next_move = world.time + 2

	point_to_atom(A, tile)
	return 1





/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		if(length(mind.memory) < 4000)
			mind.store_memory(msg)
		else
			src.sleeping = 9999999
			message_staff("[key_name(usr)] auto-slept for attempting to exceed mob memory limit. (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	var/is_admin = 0
	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		is_admin = 1

	if (!CONFIG_GET(flag/respawn) && !is_admin)
		to_chat(usr, SPAN_NOTICE(" Respawn is disabled."))
		return
	if (stat != 2)
		to_chat(usr, SPAN_NOTICE(" <B>You must be dead to use this!</B>"))
		return
	if (SSticker.mode && (SSticker.mode.name == "meteor" || SSticker.mode.name == "epidemic")) //BS12 EDIT
		to_chat(usr, SPAN_NOTICE(" Respawn is disabled for this roundtype."))
		return
	else
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")

		if (deathtime < 30 MINUTES && !is_admin)
			to_chat(usr, "You must wait 30 minutes to respawn!")
			return
		else
			to_chat(usr, "You can respawn now, enjoy your new life!")

	log_game("[usr.name]/[usr.key] used abandon mob.")

	to_chat(usr, SPAN_NOTICE(" <B>Make sure to play a different character, and please roleplay correctly!</B>"))

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.client) M.client.change_view(world_view_size)
//	M.Login()	//wat
	return


/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(!client)
		return FALSE

	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || istype(src, /mob/new_player))
		to_chat(usr, SPAN_NOTICE("You must be observing to use this!"))
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in GLOB.object_list)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/structure/machinery/bot))
			var/name = "BOT: [O.name]"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O


	for(var/mob/M in sortAtom(GLOB.mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = tgui_input_list(usr, "Please, select a player!", ok, creatures)

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "Object"
	reset_view(null)
	unset_interaction()
	if(istype(src, /mob/living))
		var/mob/living/M = src
		if(M.cameraFollow)
			M.cameraFollow = null


/mob/verb/eastface()
	set hidden = 1
	return facedir(EAST)

/mob/verb/westface()
	set hidden = 1
	return facedir(WEST)

/mob/verb/northface()
	set hidden = 1
	return facedir(NORTH)

/mob/verb/southface()
	set hidden = 1
	return facedir(SOUTH)


/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(NORTH)

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(SOUTH)

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(EAST)

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(WEST)



/mob/verb/stop_pulling()

	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		var/mob/M = pulling
		pulling.pulledby = null
		pulling = null

		grab_level = 0
		if(client)
			client.recalculate_move_delay()
		if(hud_used && hud_used.pull_icon)
			hud_used.pull_icon.icon_state = "pull0"
		if(istype(r_hand, /obj/item/grab))
			temp_drop_inv_item(r_hand)
		else if(istype(l_hand, /obj/item/grab))
			temp_drop_inv_item(l_hand)
		if(istype(M))
			if(M.client)
				//resist_grab uses long movement cooldown durations to prevent message spam
				//so we must undo it here so the victim can move right away
				M.client.next_movement = world.time
			M.update_transform(TRUE)
			M.update_canmove()
