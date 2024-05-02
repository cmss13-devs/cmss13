GLOBAL_VAR_INIT(bomb_set, FALSE)
/obj/structure/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Nuke the entire site from orbit, it's the only way to be sure. Too bad we don't have any orbital nukes."
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi'
	icon_state = "nuke"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	anchored = FALSE
	var/has_auth = FALSE
	var/crash_nuke = FALSE
	var/timing = FALSE
	var/deployable = FALSE
	var/explosion_time = null
	var/timeleft = 8 MINUTES
	var/safety = TRUE
	var/being_used = FALSE
	var/end_round = TRUE
	var/timer_announcements_flags = NUKE_SHOW_TIMER_ALL
	pixel_x = -16
	use_power = USE_POWER_NONE
	req_access = list()
	flags_atom = FPRINT
	var/command_lockout = FALSE //If set to TRUE, only command staff would be able to disable the nuke

/obj/structure/machinery/nuclearbomb/Initialize(mapload, ...)
	. = ..()

	update_minimap_icon()

/obj/structure/machinery/nuclearbomb/proc/update_minimap_icon()
	if(!is_ground_level(z))
		return

	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "nuke[timing ? "_on" : "_off"]", 'icons/ui_icons/map_blips_large.dmi')

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
	if(!timing)
		update_minimap_icon()
		return PROCESS_KILL

	GLOB.bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
	timeleft = explosion_time - world.time
	if(world.time >= explosion_time)
		explode()
		return
	//3 warnings: 1. Halfway through, 2. 1 minute left, 3. 10 seconds left.
	//this structure allows varedits to var/timeleft without losing or spamming warnings.
	if(!timer_announcements_flags)
		return

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

/obj/structure/machinery/nuclearbomb/attack_alien(mob/living/carbon/xenomorph/M)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, attack_hand), M)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && GLOB.bomb_set && HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		user.visible_message(SPAN_INFO("[user] begins to defuse \the [src]."), SPAN_INFO("You begin to defuse \the [src]. This will take some time..."))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/structure/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || get_dist(src, user) > 1 || isRemoteControlling(user))
		return

	if(isyautja(user))
		to_chat(usr, SPAN_YAUTJABOLD("A human Purification Device. Primitive and bulky, but effective. You don't have time to try figure out their counterintuitive controls. Better leave the hunting grounds before it detonates."))

	if(deployable)
		if(!ishuman(user) && (!isqueen(user) && (!isxeno(user) && !crash_nuke)))
			to_chat(usr, SPAN_INFO("You don't have the dexterity to do this!"))
			return

		if(isxeno(user))
			if(timing && GLOB.bomb_set)
				user.visible_message(SPAN_INFO("[user] begins engulfing \the [src] with resin."), SPAN_INFO("You start regurgitating and engulfing the \the [src] with resin... stopping the electronics from working, this will take some time..."))
				if(do_after(user, 5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
					disable()
			return
		tgui_interact(user)

	else
		make_deployable()


// TGUI \\

/obj/structure/machinery/nuclearbomb/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NuclearBomb", "[src.name]")
		ui.open()

/obj/structure/machinery/nuclearbomb/ui_state(mob/user)
	if(being_used)
		return UI_CLOSE
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/nuclearbomb/ui_status(mob/user)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/nuclearbomb/ui_data(mob/user)
	var/list/data = list()

	var/allowed = allowed(user)

	data["anchor"] = anchored
	data["safety"] = safety
	data["timing"] = timing
	data["timeleft"] = duration2text_sec(timeleft)
	data["command_lockout"] = command_lockout
	data["allowed"] = allowed
	data["being_used"] = being_used
	data["decryption_complete"] = TRUE //this is overridden by techweb nuke UI_data later, this just makes it default to true

	return data

/obj/structure/machinery/nuclearbomb/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/area/A = get_area(src)
	switch(action)
		if("toggleNuke")
			if(timing == -1)
				return

			if(!ishuman(ui.user))
				return

			if(!allowed(ui.user) || (crash_nuke && !has_auth))
				to_chat(ui.user, SPAN_INFO("Access denied!"))
				return

			if(!anchored)
				to_chat(ui.user, SPAN_INFO("Engage anchors first!"))
				return

			if(safety)
				to_chat(ui.user, SPAN_INFO("The safety is still on."))
				return

			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("You cannot deploy [src] here!"))
				return

			if(ui.user.action_busy)
				return

			ui.user.visible_message(SPAN_WARNING("[ui.user] begins to [timing ? "disengage" : "engage"] [src]!"), SPAN_WARNING("You begin to [timing ? "disengage" : "engage"] [src]."))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				timing = !timing
				if(timing)
					if(!safety)
						GLOB.bomb_set = TRUE
						explosion_time = world.time + timeleft
						update_minimap_icon()
						start_processing()
						announce_to_players()
						message_admins("\The [src] has been activated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
					else
						GLOB.bomb_set = FALSE
				else
					disable()
					message_admins("\The [src] has been deactivated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				playsound(loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE
			. = TRUE

		if("toggleSafety")
			if(!allowed(ui.user) || (crash_nuke && !has_auth))
				to_chat(ui.user, SPAN_INFO("Access denied!"))
				return
			if(timing)
				to_chat(ui.user, SPAN_INFO("Disengage first!"))
				return
			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("You cannot deploy [src] here!"))
				return
			if(ui.user.action_busy)
				return
			ui.user.visible_message(SPAN_WARNING("[ui.user] begins to [safety ? "disable" : "enable"] the safety on [src]!"), SPAN_WARNING("You begin to [safety ? "disable" : "enable"] the safety on [src]."))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				safety = !safety
				playsound(loc, 'sound/items/poster_being_created.ogg', 100, 1)
			being_used = FALSE
			if(safety)
				timing = FALSE
				GLOB.bomb_set = FALSE
			. = TRUE

		if("toggleCommandLockout")
			if(!ishuman(ui.user))
				return
			if(!allowed(ui.user) || (crash_nuke && !has_auth))
				to_chat(ui.user, SPAN_INFO("Access denied!"))
				return
			if(command_lockout)
				command_lockout = FALSE
				req_one_access = list()
				to_chat(ui.user, SPAN_INFO("Command lockout disengaged."))
			else
				//Check if they have command access
				var/list/acc = list()
				var/mob/living/carbon/human/H = ui.user
				if(H.wear_id)
					acc += H.wear_id.GetAccess()
				if(H.get_active_hand())
					acc += H.get_active_hand().GetAccess()
				if(!(ACCESS_MARINE_COMMAND in acc))
					to_chat(ui.user, SPAN_INFO("Access denied!"))
					return

				command_lockout = TRUE
				req_one_access = list(ACCESS_MARINE_COMMAND)
				to_chat(ui.user, SPAN_INFO("Command lockout engaged."))
			. = TRUE

		if("toggleAnchor")
			if(!allowed(ui.user) || (crash_nuke && !has_auth))
				to_chat(ui.user, SPAN_DANGER("Access denied!"))
				return
			if(timing)
				to_chat(ui.user, SPAN_INFO("Disengage first!"))
				return
			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("You cannot deploy [src] here!"))
				return
			if(ui.user.action_busy)
				return
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(!anchored)
					visible_message(SPAN_INFO("With a steely snap, bolts slide out of [src] and anchor it to the flooring."))
				else
					visible_message(SPAN_INFO("The anchoring bolts slide back into the depths of [src]."))
				playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
				anchored = !anchored
			being_used = FALSE
			. = TRUE

	update_icon()
	add_fingerprint(ui.user)

/obj/structure/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "Make Deployable"
	set src in oview(1)

	if(usr.is_mob_incapacitated() || being_used || timing || (crash_nuke && !has_auth))
		return

	if(!ishuman(usr))
		to_chat(usr, SPAN_INFO("You don't have the dexterity to do this!"))
		return

	var/area/A = get_area(src)
	if(!A.can_build_special)
		to_chat(usr, SPAN_INFO("You don't want to deploy this here!"))
		return

	usr.visible_message(SPAN_WARNING("[usr] begins to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."), SPAN_WARNING("You begin to [deployable ? "close" : "adjust"] several panels to make [src] [deployable ? "undeployable" : "deployable"]."))
	being_used = TRUE
	if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		if(deployable)
			deployable = FALSE
			anchored = FALSE
		else
			deployable = TRUE
			anchored = TRUE
		playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
	being_used = FALSE
	update_icon()

//unified all announcements to one proc
/obj/structure/machinery/nuclearbomb/proc/announce_to_players(timer_warning)

	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_uscm = list()
	for(var/mob/current_mob as anything in humans_other)
		if(current_mob.stat != CONSCIOUS || isyautja(current_mob))
			humans_other -= current_mob
			continue
		if(current_mob.faction == FACTION_MARINE || current_mob.faction == FACTION_SURVIVOR) //separating marines from other factions. Survs go here too
			humans_uscm += current_mob
			humans_other -= current_mob

	if(timer_warning) //we check for timer warnings first
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("WARNING.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		//preds part
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nYou have approximately [t_left] seconds to abandon the hunting grounds before activation of the human purification device."))
		//xenos part
		var/warning
		if(timer_warning & NUKE_SHOW_TIMER_HALF)
			warning = "A shiver goes down our carapace as we feel the approaching end... the hive killer is halfway through its preparation cycle!"
		else if(timer_warning & NUKE_SHOW_TIMER_MINUTE)
			warning = "Every sense in our form is screaming... the hive killer is almost ready to trigger!"
		else
			warning = "DISABLE IT! NOW!"
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.totalXenos.len)
				return
			xeno_announcement(SPAN_XENOANNOUNCE(warning), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	var/datum/hive_status/hive
	if(timing)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [round(timeleft/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/t_left = duration2text_sec(round(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>A human purification device has been detected. You have approximately [t_left] to abandon the hunting grounds before it activates."))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.totalXenos.len)
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have deployed a hive killer at [get_area_name(loc)]! Stop it at all costs!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	else
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>The human purification device's signature has disappeared."))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.totalXenos.len)
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The hive killer has been disabled! Rejoice!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	return

/obj/structure/machinery/nuclearbomb/ex_act(severity)
	return

/obj/structure/machinery/nuclearbomb/proc/disable()
	timing = FALSE
	GLOB.bomb_set = FALSE
	timeleft = initial(timeleft)
	explosion_time = null
	announce_to_players()

/obj/structure/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		update_minimap_icon()
		stop_processing()
		update_icon()
		return FALSE
	timing = -1
	update_icon()
	safety = TRUE

	playsound(src, 'sound/machines/Alarm.ogg', 75, 0, 30)
	SSticker.mode.on_nuclear_explosion()

	sleep(10 SECONDS)

	var/list/mob/alive_mobs = list() //Everyone who will be destroyed on the zlevel(s).
	var/list/mob/dead_mobs = list() //Everyone that needs embryos cleared
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/turf/current_turf = get_turf(current_mob)
		if(current_turf?.z == z)
			if(current_mob.stat == DEAD)
				dead_mobs |= current_mob
				continue
			alive_mobs |= current_mob

	for(var/mob/current_mob in alive_mobs)
		if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
			continue
		current_mob.death(create_cause_data("nuclear explosion"))

	for(var/mob/living/current_mob in (alive_mobs + dead_mobs))
		if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
			continue
		for(var/obj/item/alien_embryo/embryo in current_mob)
			qdel(embryo)

	cell_explosion(loc, 500, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)))
	qdel(src)
	return TRUE

/obj/structure/machinery/nuclearbomb/Destroy()
	GLOB.bomb_set = FALSE
	SSminimaps.remove_marker(src)
	return ..()

/obj/structure/machinery/nuclearbomb/tech
	var/decryption_time = 10 MINUTES
	var/decryption_end_time = null
	var/decrypting = FALSE

	timeleft = 1 MINUTES
	timer_announcements_flags = NUKE_DECRYPT_SHOW_TIMER_ALL

	var/list/linked_decryption_towers

/obj/structure/machinery/nuclearbomb/tech/Initialize(mapload)
	. = ..()

	linked_decryption_towers = list()

	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/nuclearbomb/tech/LateInitialize()
	. = ..()

	for(var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/possible_telecomm in GLOB.all_static_telecomms_towers)
		if(is_ground_level(possible_telecomm.z))
			linked_decryption_towers += possible_telecomm

	RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_TELECOMM_TURNED_OFF, PROC_REF(connected_comm_shutdown))

/obj/structure/machinery/nuclearbomb/tech/ui_data(mob/user)
	. = ..()

	.["decrypting"] = decrypting
	.["decryption_time"] = duration2text_sec(decryption_time)

	.["decryption_complete"] = decryption_time ? FALSE : TRUE

/obj/structure/machinery/nuclearbomb/tech/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("toggleEncryption")
			if(!ishuman(ui.user))
				return

			if(!allowed(ui.user))
				to_chat(ui.user, SPAN_INFO("Access denied!"))
				return

			if(!anchored)
				to_chat(ui.user, SPAN_INFO("Engage anchors first!"))
				return

			var/area/current_area = get_area(src)
			if(!current_area.can_build_special)
				to_chat(ui.user, SPAN_INFO("You cannot deploy [src] here!"))
				return

			if(is_ground_level(z))
				for(var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/telecomm_unit in linked_decryption_towers)
					if(!telecomm_unit.on)
						to_chat(ui.user, SPAN_INFO("The groundside telecommunication relays must be activated!"))
						return

			if(ui.user.action_busy)
				return

			if(being_used)
				return

			ui.user.visible_message(SPAN_WARNING("[ui.user] begins to [decrypting ? "stop the decryption process." : "start decrypting."]!"), SPAN_WARNING("You begin to [decrypting ? "stop the decryption process." : "start decrypting."]."))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				decrypting = !decrypting
				if(decrypting)
					//add signal handlers
					decryption_end_time = world.time + decryption_time
					start_processing()
					announce_to_players()
					message_admins("[src]'s encryption process has been started by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				else
					//remove signal handlers
					decryption_end_time = null
					announce_to_players()
					message_admins("[src]'s encryption process has been deactivated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				playsound(loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE
			return TRUE

/obj/structure/machinery/nuclearbomb/tech/process()
	if(!decrypting)
		return ..()

	decryption_time = decryption_end_time - world.time

	if(world.time > decryption_end_time)
		decrypting = FALSE
		decryption_time = 0
		announce_to_players(NUKE_DECRYPT_SHOW_TIMER_COMPLETE)
		timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_COMPLETE
		return PROCESS_KILL

	if(!timer_announcements_flags)
		return

	if(timer_announcements_flags & NUKE_DECRYPT_SHOW_TIMER_HALF)
		if(decryption_time <= initial(decryption_time) / 2 && decryption_time >= initial(decryption_time) / 2 - 30)
			announce_to_players(NUKE_DECRYPT_SHOW_TIMER_HALF)
			timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_HALF
			return
	if(timer_announcements_flags & NUKE_DECRYPT_SHOW_TIMER_MINUTE)
		if(decryption_time <= 600 && decryption_time >= 570)
			announce_to_players(NUKE_DECRYPT_SHOW_TIMER_MINUTE)
			timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_MINUTE
			return

/obj/structure/machinery/nuclearbomb/tech/announce_to_players(timer_warning)
	if(!decryption_time && (timer_warning != NUKE_DECRYPT_SHOW_TIMER_COMPLETE))
		return ..()

	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_uscm = list()
	for(var/mob/current_mob as anything in humans_other)
		var/mob/living/carbon/human/current_human = current_mob
		if(istype(current_human)) //if it's unconsious human or yautja, we remove them
			if(current_human.stat != CONSCIOUS || isyautja(current_human))
				humans_other -= current_mob
				continue
		if(current_mob.faction == FACTION_MARINE || current_mob.faction == FACTION_SURVIVOR)
			humans_uscm += current_mob
			humans_other -= current_mob

	if(timer_warning)
		if(timer_warning == NUKE_DECRYPT_SHOW_TIMER_COMPLETE)
			announcement_helper("DECRYPTION COMPLETE", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
			announcement_helper("DECRYPTION COMPLETE", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')

			yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nThe human purification device is able to be activated."))

			var/datum/hive_status/hive
			for(var/hivenumber in GLOB.hive_datum)
				hive = GLOB.hive_datum[hivenumber]
				if(!length(hive.totalXenos))
					return
				xeno_announcement(SPAN_XENOANNOUNCE("We get a sense of impending doom... the hive killer is ready to be activated."), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
			return

		announcement_helper("DECRYPTION IN [round(decryption_time/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("DECRYPTION IN [round(decryption_time/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')

		//preds part
		var/time_left = duration2text_sec(round(rand(decryption_time - decryption_time / 10, decryption_time + decryption_time / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nYou have approximately [time_left] seconds to abandon the hunting grounds before the human purification device is able to be activated."))

		//xenos part
		var/warning = "We are almost out of time, STOP THEM."
		if(timer_warning & NUKE_DECRYPT_SHOW_TIMER_HALF)
			warning = "The Hive grows restless! it's halfway done..."

		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.totalXenos.len)
				return
			xeno_announcement(SPAN_XENOANNOUNCE(warning), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	var/datum/hive_status/hive
	if(decrypting)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DECRYPTION STARTED.\n\nDECRYPTION IN [round(decryption_time/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DECRYPTION STARTED.\n\nDECRYPTION IN [round(decryption_time/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/time_left = duration2text_sec(round(rand(decryption_time - decryption_time / 10, decryption_time + decryption_time / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>A human purification device has been detected. You have approximately [time_left] before it finishes its initial phase."))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have started the initial phase of a hive killer at [get_area_name(loc)]! Destroy their communications relays!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE DECRYPTION HALTED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
	announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE DECRYPTION HALTED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
	yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!<br>The human purification device's signature has disappeared."))
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The hive killer's initial phase has been halted! Rejoice!"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)

/obj/structure/machinery/nuclearbomb/tech/proc/connected_comm_shutdown(obj/structure/machinery/telecomms/relay/preset/tower/telecomm_unit)
	SIGNAL_HANDLER

	if(!decrypting)
		return

	decrypting = FALSE
	announce_to_players()
