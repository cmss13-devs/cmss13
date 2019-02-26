var/bomb_set = FALSE

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Nuke the entire site from orbit, it's the only way to be sure. Too bad we don't have any orbital nukes."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1
	unacidable = 1
	var/timing = FALSE
	var/deployable = FALSE
	var/timeleft = 480
	var/safety = TRUE
	var/being_used = FALSE
	var/end_round = TRUE
	use_power = 0
	req_access = list(ACCESS_MARINE_PREP)
	flags_atom = FPRINT

/obj/machinery/nuclearbomb/process()
	. = ..()
	if(timing)
		bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
		timeleft--
		if(timeleft <= 0)
			explode()
	else
		stop_processing()

/obj/machinery/nuclearbomb/attack_alien(mob/living/carbon/Xenomorph/M)
	return attack_hand(M)

/obj/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && bomb_set && iswirecutter(O))
		user.visible_message("\red [user] begins to diffuse [src].", "\red You begin to diffuse [src]. This will take some time...")
		if(do_after(user, 150, FALSE, 5, BUSY_ICON_HOSTILE))
			disable()
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/machinery/nuclearbomb/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isAI(user))
		return

	user.set_interaction(src)
	if(deployable)
		if (!ishuman(user) && !isXenoQueen(user))
			usr << "\red You don't have the dexterity to do this!"
			return

		if (isXenoQueen(user))
			if(timing && bomb_set)
				user.visible_message("\red [user] begins to diffuse [src].", "\red You begin to diffuse [src]. This will take some time...")
				if(do_after(user, 150, FALSE, 5, BUSY_ICON_HOSTILE))
					disable()
			return
		ui_interact(user)

	else
		make_deployable()

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isAI(user) || being_used)
		return

	var/data[0]
	data = list(
		"anchor" = anchored,
		"safety" = safety,
		"timing" = timing,
		"timeleft" = timeleft
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl","Nuclear Control Panel", 550, 250)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "Make Deployable"
	set src in oview(1)

	if (!usr.canmove || usr.stat || usr.is_mob_restrained() || being_used || timing)
		return

	if (!ishuman(usr))
		usr << "\red You don't have the dexterity to do this!"
		return

	var/area/A = get_area(src)
	if (!A.can_nuke_area)
		usr << "\red You don't want to deploy this here!"
		return

	usr.visible_message("\red [usr] begins to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"].", "\red you begin to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"].")
	being_used = TRUE
	if(do_after(usr, 50, FALSE, 5, BUSY_ICON_HOSTILE))
		if (deployable)
			deployable = FALSE
			anchored = FALSE
			icon_state = "nuclearbomb0"
		else
			deployable = TRUE
			anchored = TRUE
			icon_state = "nuclearbomb1"
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
	being_used = FALSE

/obj/machinery/nuclearbomb/Topic(href, href_list)
	..()
	if (!usr.canmove || usr.stat || usr.is_mob_restrained() || being_used || !in_range(src, usr))
		return
	usr.set_interaction(src)
	var/area/A = get_area(src)
	switch(href_list["command"])
		if ("toggleNuke")
			if (timing == -1)
				return

			if(!ishuman(usr))
				return

			if(!allowed(usr))
				usr << "\red Access denied!"
				return

			if (!anchored)
				usr << "\red Engage anchors first!"
				return

			if (safety)
				usr << "\red The safety is still on."
				return

			if (!A.can_nuke_area)
				usr << "\red You cannot deploy [src] here!"
				return

			usr.visible_message("\red [usr] begins to [timing ? "disengage" : "engage"] [src]!", "\red you begin to [timing ? "disengage" : "engage"] [src].")
			being_used = TRUE
			if(do_after(usr, 50, FALSE, 5, BUSY_ICON_HOSTILE))
				timing = !timing
				if (timing)
					icon_state = "nuclearbomb2"
					if(!safety)
						bomb_set = TRUE
						start_processing()
						var/name = "[MAIN_AI_SYSTEM] Nuclear Tracker"
						var/input = "ALERT.\n\nNUCLEAR EXPLOSIVE ORDINANCE ACTIVATED.\n\nDETONATION IN [timeleft] SECONDS."
						command_announcement.Announce(input, name, new_sound = 'sound/misc/notice1.ogg')
					else
						bomb_set = FALSE
				else
					icon_state = "nuclearbomb1"
					disable()
				playsound(src.loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE

		if ("toggleSafety")
			if (timing)
				usr << "\red Disengage first!"
				return
			if (!A.can_nuke_area)
				usr << "\red You cannot deploy [src] here!"
				return
			usr.visible_message("\red [usr] begins to [safety ? "disable" : "enable"] the safety on [src]!", "\red you begin to [safety ? "disable" : "enable"] the safety on [src].")
			being_used = TRUE
			if(do_after(usr, 50, FALSE, 5, BUSY_ICON_HOSTILE))
				safety = !safety
				playsound(src.loc, 'sound/items/poster_being_created.ogg', 100, 1)
			being_used = FALSE
			if(safety)
				timing = FALSE
				bomb_set = FALSE
		if ("toggleAnchor")
			if (timing)
				usr << "\red Disengage first!"
				return
			if (!A.can_nuke_area)
				usr << "\red You cannot deploy [src] here!"
				return
			being_used = TRUE
			if(do_after(usr, 50, FALSE, 5, BUSY_ICON_HOSTILE))
				if(!anchored)
					visible_message("\red With a steely snap, bolts slide out of [src] and anchor it to the flooring.")
				else
					visible_message("\red The anchoring bolts slide back into the depths of [src].")
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
				anchored = !anchored
			being_used = FALSE

	add_fingerprint(usr)
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.interactee == src))
			attack_hand(M)


/obj/machinery/nuclearbomb/proc/announce_xenos()
	for(var/datum/hive_status/hive in hive_datum)
		hive.handle_nuke_alert(timing)

/obj/machinery/nuclearbomb/ex_act(severity)
	return

/obj/machinery/nuclearbomb/proc/disable()
	if(!timing)
		return
	timing = FALSE
	bomb_set = FALSE
	var/name = "[MAIN_AI_SYSTEM] Nuclear Tracker"
	var/input = "ALERT.\n\nNUCLEAR EXPLOSIVE ORDINANCE DEACTIVATED"
	command_announcement.Announce(input, name, new_sound = 'sound/misc/notice1.ogg')
	announce_xenos()

/obj/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		stop_processing()
		r_FAL
	timing = -1
	safety = TRUE
	icon_state = "nuclearbomb3"

	EvacuationAuthority.trigger_self_destruct(list(z), src, FALSE, NUKE_EXPLOSION_GROUND_FINISHED, FALSE, end_round)

	sleep(100)
	explosion_rec(loc, 500, 50)
	cdel(src)
	r_TRU

/obj/item/disk/nuclear/Dispose()
	if(blobstart.len > 0)
		var/obj/D = new /obj/item/disk/nuclear(pick(blobstart))
		message_admins("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
		log_game("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
	. = ..()
