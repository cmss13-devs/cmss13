var/bomb_set = FALSE

/obj/structure/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Nuke the entire site from orbit, it's the only way to be sure. Too bad we don't have any orbital nukes."
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi'
	icon_state = "nuclearbomb0"
	density = 1
	unslashable = TRUE
	unacidable = TRUE
	anchored = 0
	var/timing = FALSE
	var/deployable = FALSE
	var/explosion_time = null
	var/timeleft = 4800
	var/safety = TRUE
	var/being_used = FALSE
	var/end_round = TRUE
	pixel_x = -16
	use_power = 0
	req_access = list(ACCESS_MARINE_PREP)
	flags_atom = FPRINT

/obj/structure/machinery/nuclearbomb/power_change()
	return

/obj/structure/machinery/nuclearbomb/process()
	. = ..()
	if(timing)
		bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
		timeleft = explosion_time - world.time
		if(world.time >= explosion_time)
			explode()
	else
		stop_processing()

/obj/structure/machinery/nuclearbomb/attack_alien(mob/living/carbon/Xenomorph/M)
	return attack_hand(M)

/obj/structure/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && bomb_set && iswirecutter(O))
		user.visible_message(SPAN_DANGER("[user] begins to diffuse [src]."), SPAN_DANGER("You begin to diffuse [src]. This will take some time..."))
		if(do_after(user, 150, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/structure/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isAI(user))
		return

	if(isYautja(user))
		to_chat(usr, SPAN_YAUTJABOLD("A human Purification Device. Primitive and bulky, but effective. You don't have time to try figure out their counterintuitive controls. Better leave hunting grounds before it detonates."))

	user.set_interaction(src)
	if(deployable)
		if (!ishuman(user) && !isXenoQueen(user))
			to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
			return

		if (isXenoQueen(user))
			if(timing && bomb_set)
				user.visible_message(SPAN_DANGER("[user] begins to diffuse [src]."), SPAN_DANGER("You begin to diffuse [src]. This will take some time..."))
				if(do_after(user, 150, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
					disable()
			return
		ui_interact(user)

	else
		make_deployable()

/obj/structure/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isAI(user) || being_used)
		return

	var/timer = duration2text_sec(timeleft)

	var/data[0]
	data = list(
		"anchor" = anchored,
		"safety" = safety,
		"timing" = timing,
		"timeleft" = timer
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl","Nuclear Fission Explosives Control Panel", 500, 250)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "Make Deployable"
	set src in oview(1)

	if (!usr.canmove || usr.stat || usr.is_mob_restrained() || being_used || timing)
		return

	if (!ishuman(usr))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return

	var/area/A = get_area(src)
	if (!A.can_build_special)
		to_chat(usr, SPAN_DANGER("You don't want to deploy this here!"))
		return

	usr.visible_message(SPAN_WARNING("[usr] begins to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."), SPAN_WARNING("You begin to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."))
	being_used = TRUE
	if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
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

/obj/structure/machinery/nuclearbomb/Topic(href, href_list)
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
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return

			if (!anchored)
				to_chat(usr, SPAN_DANGER("Engage anchors first!"))
				return

			if (safety)
				to_chat(usr, SPAN_DANGER("The safety is still on."))
				return

			if (!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return

			usr.visible_message(SPAN_WARNING("[usr] begins to [timing ? "disengage" : "engage"] [src]!"), SPAN_WARNING("You begin to [timing ? "disengage" : "engage"] [src]."))
			being_used = TRUE
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				timing = !timing
				if(timing)
					icon_state = "nuclearbomb2"
					if(!safety)
						bomb_set = TRUE
						explosion_time = world.time + timeleft
						start_processing()
						var/name = "[MAIN_AI_SYSTEM] Nuclear Tracker"
						var/input = "ALERT.\n\nNUCLEAR EXPLOSIVE ORDINANCE ACTIVATED.\n\nDETONATION IN [timeleft/10] SECONDS."
						marine_announcement(input, name, 'sound/misc/notice1.ogg')
						announce_xenos()
						announce_yautja()
						message_admins("[src] has been activated by [key_name(usr, 1)](<A HREF='?_src_=admin_holder;adminplayerobservejump=[usr]'>JMP</A>)")
					else
						bomb_set = FALSE
				else
					icon_state = "nuclearbomb1"
					disable()
					message_admins("[src] has been deactivated by [key_name(usr, 1)](<A HREF='?_src_=admin_holder;adminplayerobservejump=[usr]'>JMP</A>)")
				playsound(src.loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE

		if ("toggleSafety")
			if (timing)
				to_chat(usr, SPAN_DANGER("Disengage first!"))
				return
			if (!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return
			usr.visible_message(SPAN_WARNING("[usr] begins to [safety ? "disable" : "enable"] the safety on [src]!"), SPAN_WARNING("You begin to [safety ? "disable" : "enable"] the safety on [src]."))
			being_used = TRUE
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				safety = !safety
				playsound(src.loc, 'sound/items/poster_being_created.ogg', 100, 1)
			being_used = FALSE
			if(safety)
				timing = FALSE
				bomb_set = FALSE
		if ("toggleAnchor")
			if (timing)
				to_chat(usr, SPAN_DANGER("Disengage first!"))
				return
			if (!A.can_build_special)
				to_chat(usr, SPAN_DANGER("You cannot deploy [src] here!"))
				return
			being_used = TRUE
			if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(!anchored)
					visible_message(SPAN_DANGER("With a steely snap, bolts slide out of [src] and anchor it to the flooring."))
				else
					visible_message(SPAN_DANGER("The anchoring bolts slide back into the depths of [src]."))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
				anchored = !anchored
			being_used = FALSE

	add_fingerprint(usr)
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.interactee == src))
			attack_hand(M)

/obj/structure/machinery/nuclearbomb/proc/announce_yautja()
	var/t_left = duration2text_sec(rand(timeleft - timeleft / 10, timeleft + timeleft / 10))
	if(timing)
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>A human Purification Device has been detected. You have approximately [t_left] to abandon the hunting grounds before it activates."))
	else
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>The human Purification Device's signature has disappeared."))

/obj/structure/machinery/nuclearbomb/proc/announce_xenos()
	for(var/datum/hive_status/hive in hive_datum)
		hive.handle_nuke_alert(timing, get_area(loc))

/obj/structure/machinery/nuclearbomb/ex_act(severity)
	return

/obj/structure/machinery/nuclearbomb/proc/disable()
	timing = FALSE
	bomb_set = FALSE
	timeleft = explosion_time - world.time
	explosion_time = null
	var/name = "[MAIN_AI_SYSTEM] Nuclear Tracker"
	var/input = "ALERT.\n\nNUCLEAR EXPLOSIVE ORDINANCE DEACTIVATED"
	marine_announcement(input, name, 'sound/misc/notice1.ogg')
	announce_xenos()
	announce_yautja()

/obj/structure/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		stop_processing()
		return FALSE
	timing = -1
	safety = TRUE
	icon_state = "nuclearbomb3"

	EvacuationAuthority.trigger_self_destruct(list(z), src, FALSE, NUKE_EXPLOSION_GROUND_FINISHED, FALSE, end_round)

	sleep(100)
	cell_explosion(loc, 500, 150, null, initial(name))
	qdel(src)
	return TRUE

/obj/item/disk/nuclear/Dispose()
	if(blobstart.len > 0)
		var/obj/D = new /obj/item/disk/nuclear(pick(blobstart))
		message_admins("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
		log_game("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
	. = ..()
