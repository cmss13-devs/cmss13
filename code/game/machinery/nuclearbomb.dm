var/bomb_set = FALSE

/obj/structure/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Nuke the entire site from orbit, it's the only way to be sure. Too bad we don't have any orbital nukes."
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi'
	icon_state = "nuke"
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
	var/timer_announcements_flags = NUKE_SHOW_TIMER_ALL
	pixel_x = -16
	use_power = 0
	req_access = list()
	flags_atom = FPRINT
	var/command_lockout = FALSE //If set to TRUE, only command staff would be able to disable the nuke

/obj/structure/machinery/nuclearbomb/update_icon()
	overlays.Cut()
	if(anchored)
		var/image/I = image(icon, "+deployed")
		overlays += I
	if(!safety)
		var/image/I = image(icon, "+unsafe")
		overlays += I
	if(timing)
		var/image/I = image(icon, "+timing")
		overlays += I
	if(timing == -1)
		var/image/I = image(icon, "+activation")
		overlays += I

/obj/structure/machinery/nuclearbomb/power_change()
	return

/obj/structure/machinery/nuclearbomb/process()
	. = ..()
	if(timing)
		bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
		timeleft = explosion_time - world.time
		if(world.time >= explosion_time)
			explode()
		//3 warnings: 1. Halfway through, 2. 1 minute left, 3. 10 seconds left.
		//this structure allows varedits to var/timeleft without losing or spamming warnings.
		else if(timer_announcements_flags)
			if(timer_announcements_flags & NUKE_SHOW_TIMER_HALF)
				if(timeleft <= initial(timeleft) / 2 && timeleft >= initial(timeleft) / 2 - 30)
					announce_to_players(NUKE_SHOW_TIMER_HALF)
					timer_announcements_flags &= ~NUKE_SHOW_TIMER_HALF
					return
			if(timer_announcements_flags & NUKE_SHOW_TIMER_MINUTE)
				if(timeleft <= 600 && timeleft >= 570)
					announce_to_players(NUKE_SHOW_TIMER_MINUTE)
					timer_announcements_flags = NUKE_SHOW_TIMER_TEN_SEC
					return
			if(timer_announcements_flags & NUKE_SHOW_TIMER_TEN_SEC)
				if(timeleft <= 100 && timeleft >= 70)
					announce_to_players(NUKE_SHOW_TIMER_TEN_SEC)
					timer_announcements_flags = 0
					return
	else
		stop_processing()

/obj/structure/machinery/nuclearbomb/attack_alien(mob/living/carbon/Xenomorph/M)
	return attack_hand(M)

/obj/structure/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && bomb_set && iswirecutter(O))
		user.visible_message(SPAN_DANGER("[user] begins to defuse [src]."), SPAN_DANGER("You begin to defuse [src]. This will take some time..."))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/structure/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isRemoteControlling(user))
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
				user.visible_message(SPAN_DANGER("[user] begins to defuse [src]."), SPAN_DANGER("You begin to defuse [src]. This will take some time..."))
				if(do_after(user, SECONDS_5, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
					disable()
			return
		ui_interact(user)

	else
		make_deployable()

/obj/structure/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	if(user.is_mob_incapacitated() || !user.canmove || get_dist(src, user) > 1 || isRemoteControlling(user) || being_used)
		return

	var/timer = duration2text_sec(timeleft)

	var/data[0]
	data = list(
		"anchor" = anchored,
		"safety" = safety,
		"timing" = timing,
		"timeleft" = timer,
		"command_lockout" = command_lockout,
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
		else
			deployable = TRUE
			anchored = TRUE
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
	being_used = FALSE
	update_icon()

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
					if(!safety)
						bomb_set = TRUE
						explosion_time = world.time + timeleft
						start_processing()
						announce_to_players()
						message_staff("[src] has been activated by [key_name(usr, 1)](<A HREF='?_src_=admin_holder;adminplayerobservejump=[usr]'>JMP</A>)")
					else
						bomb_set = FALSE
				else
					disable()
					message_staff("[src] has been deactivated by [key_name(usr, 1)](<A HREF='?_src_=admin_holder;adminplayerobservejump=[usr]'>JMP</A>)")
				playsound(src.loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE

		if ("toggleSafety")
			if(!allowed(usr))
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return
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

		if ("toggleCommandLockout")
			if(!ishuman(usr))
				return
			if(!allowed(usr))
				to_chat(usr, SPAN_DANGER("Access denied!"))
				return
			if(command_lockout)
				command_lockout = FALSE
				req_one_access = list()
				to_chat(usr, SPAN_DANGER("Command lockout disengaged."))
			else
				//Check if they have command access
				var/list/acc = list()
				var/mob/living/carbon/human/H = usr
				if(H.wear_id)
					acc += H.wear_id.GetAccess()
				if(H.get_active_hand())
					acc += H.get_active_hand().GetAccess()
				if(!(ACCESS_MARINE_BRIDGE in acc))
					to_chat(usr, SPAN_DANGER("Access denied!"))
					return

				command_lockout = TRUE
				req_one_access = list(ACCESS_MARINE_BRIDGE)
				to_chat(usr, SPAN_DANGER("Command lockout engaged."))

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

	update_icon()
	add_fingerprint(usr)
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.interactee == src))
			attack_hand(M)

//unified all announcements to one proc
/obj/structure/machinery/nuclearbomb/proc/announce_to_players(var/timer_warning)
	if(timer_warning)	//we check for timer warnings first
		//humans part
		var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
		var/list/humans_USCM = list()
		for(var/mob/M in humans_other)
			var/mob/living/carbon/human/H = M
			if(istype(H))							//if it's unconsious human or yautja, we remove them
				if(H.stat != CONSCIOUS || isYautja(H))
					humans_other.Remove(M)
					continue
			if(M.faction == FACTION_MARINE || M.faction == FACTION_SURVIVOR)			//separating marines from other factions. Survs go here too
				humans_USCM += M
				humans_other -= M
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		//preds part
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nYou have approximately [t_left] seconds to abandon the hunting grounds before activation of human Purification Device."))
		//xenos part
		var/warning
		if(timer_warning & NUKE_SHOW_TIMER_HALF)
			warning = "Hive killer is halfway through preparation cycle!"
		else if(timer_warning & NUKE_SHOW_TIMER_MINUTE)
			warning = "Hive killer is almost ready to trigger!"
		else
			warning = "DISABLE IT! NOW!"
		for(var/datum/hive_status/hive in hive_datum)
			if(!hive.totalXenos.len)
				return
			xeno_announcement(SPAN_XENOANNOUNCE(warning), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	//deal with start/stop announcements for players
	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_USCM = list()
	for(var/mob/M in humans_other)
		var/mob/living/carbon/human/H = M
		if(istype(H))							//if it's unconsious human or yautja, we remove them
			if(H.stat != CONSCIOUS || isYautja(H))
				humans_other.Remove(M)
				continue
		if(M.faction == FACTION_MARINE || M.faction == FACTION_SURVIVOR)			//separating marines from other factions. Survs go here too
			humans_USCM += M
			humans_other -= M
	if(timing)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>A human Purification Device has been detected. You have approximately [t_left] to abandon the hunting grounds before it activates."))
		for(var/datum/hive_status/hive in hive_datum)
			if(!hive.totalXenos.len)
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have deployed a hive killer at [get_area_name(loc)]! Stop it at all costs!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	else
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_USCM, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>The human Purification Device's signature has disappeared."))
		for(var/datum/hive_status/hive in hive_datum)
			if(!hive.totalXenos.len)
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The hive killer has been disabled! Rejoice!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	return

/obj/structure/machinery/nuclearbomb/ex_act(severity)
	return

/obj/structure/machinery/nuclearbomb/proc/disable()
	timing = FALSE
	bomb_set = FALSE
	timeleft = initial(timeleft)
	explosion_time = null
	announce_to_players()

/obj/structure/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		stop_processing()
		update_icon()
		return FALSE
	timing = -1
	update_icon()
	safety = TRUE

	EvacuationAuthority.trigger_self_destruct(list(z), src, FALSE, NUKE_EXPLOSION_GROUND_FINISHED, FALSE, end_round)

	sleep(100)
	cell_explosion(loc, 500, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name))
	qdel(src)
	return TRUE

/obj/structure/machinery/nuclearbomb/Destroy()
	if(timing != -1)
		message_staff("[src] has been unexpectedly deleted at ([x],[y],[x]). (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		log_game("[src] has been unexpectedly deleted at ([x],[y],[x]).")
	bomb_set = FALSE
	..()
