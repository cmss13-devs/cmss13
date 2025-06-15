#define STATE_MARINE_CAPTURED "marine"
#define STATE_BROKEN "broken"
#define STATE_XENO_CAPTURED "xeno"

GLOBAL_DATUM(transformer, /obj/structure/machinery/transformer)

/obj/structure/machinery/transformer
	name = "HVT-7T high voltage transformer"
	desc = "A static heavy-duty transformer tower disconnected from the main colony powergrid. Used to power landing zones."
	use_power = USE_POWER_NONE
	icon = 'icons/obj/structures/machinery/transformer.dmi'
	icon_state = "transformer"
	needs_power = FALSE
	bound_height = 64
	bound_width = 64
	density = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

	var/state = STATE_BROKEN
	var/shutdown_timer
	var/turn_on_timer
	var/active_since = 0
	var/linked_lz
	var/obj/structure/machinery/backup_generator/backup

/obj/structure/machinery/transformer/Initialize(mapload, ...)
	RegisterSignal(get_turf(src), COMSIG_WEEDNODE_GROWTH, PROC_REF(handle_xeno_acquisition))
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "hvt")
	GLOB.transformer = src
	START_PROCESSING(SSslowobj, src)

	. = ..()

/obj/structure/machinery/transformer/Destroy()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)
	SSminimaps.remove_marker(src)
	backup = null
	GLOB.transformer = null
	STOP_PROCESSING(SSslowobj, src)
	. = ..()

/obj/structure/machinery/transformer/process(deltatime)
	if(state != STATE_MARINE_CAPTURED || !SSobjectives.first_drop_complete)
		return

	var/groundside_humans = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue

		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans += 1

			if(groundside_humans > 12)
				break

	if(groundside_humans >= 12)
		return

	if(turn_on_timer)
		deltimer(turn_on_timer)

	if(shutdown_timer)
		deltimer(shutdown_timer)
	turn_off()
	STOP_PROCESSING(SSslowobj, src)


/obj/structure/machinery/transformer/proc/is_active()
	return state == STATE_MARINE_CAPTURED || shutdown_timer && timeleft(shutdown_timer) > 0 || backup?.is_active()

/obj/structure/machinery/transformer/proc/handle_xeno_acquisition(turf/weeded_turf)
	SIGNAL_HANDLER

	if(state == STATE_XENO_CAPTURED || state == STATE_MARINE_CAPTURED)
		return

	if(!weeded_turf.weeds)
		return

	if(weeded_turf.weeds.weed_strength < WEED_LEVEL_HIVE)
		return

	if(!weeded_turf.weeds.parent)
		return

	if(!istype(weeded_turf.weeds.parent, /obj/effect/alien/weeds/node/pylon/cluster))
		return

	if(SSticker.mode.is_in_endgame)
		return

	var/obj/effect/alien/weeds/node/pylon/cluster/parent_node = weeded_turf.weeds.parent

	RegisterSignal(parent_node, COMSIG_PARENT_QDELETING, PROC_REF(uncorrupt))

	state = STATE_XENO_CAPTURED
	update_icon()

/obj/structure/machinery/transformer/proc/uncorrupt()
	state = STATE_BROKEN
	update_icon()

/obj/structure/machinery/transformer/update_icon()
	overlays.Cut()

	switch(state)
		if(STATE_MARINE_CAPTURED)
			overlays += image(icon, "marine-captured")
			overlays += image(icon, "on-overlay")
		if(STATE_XENO_CAPTURED)
			overlays += image(icon, "xeno-captured")

/obj/structure/machinery/transformer/attackby(obj/item/item, mob/user)
	if(state != STATE_BROKEN)
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
		return

	if(!HAS_TRAIT(item, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("[src] is completely broken, you need a blowtorch!"))
		return

	if(!SSticker.mode.active_lz || linked_lz && !(SSticker.mode.active_lz.linked_lz == linked_lz))
		to_chat(user, SPAN_WARNING("[src] beeps three times, indicating there is no landing zone being used, or it does not power the one being used."))
		return

	var/obj/item/tool/weldingtool/welder = item

	if(welder.get_fuel() < 1)
		to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	to_chat(user, SPAN_NOTICE("You start repairing [src]."))

	if(!do_after(user, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	if(state != STATE_BROKEN)
		return

	if(!welder.remove_fuel(1, user))
		return

	to_chat(user, SPAN_NOTICE("You repair [src]."))
	playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)

	state = STATE_MARINE_CAPTURED
	GLOB.transformer = src
	update_icon()
	if(shutdown_timer)
		deltimer(shutdown_timer)
		shutdown_timer = null
	turn_on_timer = addtimer(CALLBACK(src, PROC_REF(turn_on)), 30 SECONDS, TIMER_STOPPABLE)
	marine_announcement("Power Alert: \nColony transformer turning on. Power grid will be operational in approximately 30 seconds.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts' power source is powering up, It will be restored in approximately 30 seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/obj/structure/machinery/transformer/proc/turn_on()
	marine_announcement("Power Alert: \nColony transformer active. Power grid operational.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts' power source has been restored!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_ON)
	active_since = world.time

/obj/structure/machinery/transformer/attack_alien(mob/living/carbon/xenomorph/alien)
	if(state != STATE_MARINE_CAPTURED)
		return

	if(alien.action_busy)
		return

	if(alien.mob_size < MOB_SIZE_BIG)
		to_chat(alien, SPAN_WARNING("You are too small to damage [src]!"))
		return

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)

	if(!do_after(alien, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(alien, SPAN_WARNING("You were interrupted!"))
		return

	if(state != STATE_MARINE_CAPTURED)
		return

	playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
	state = STATE_BROKEN
	update_icon()
	var/time_to_shutdown = min(world.time - active_since, 5 MINUTES) / 600
	marine_announcement("Power Alert: \nColony transformer unresponsive. Power Grid shutdown estimated in [round(time_to_shutdown)] minutes.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts' power source was destroyed, It will shutdown in [round(time_to_shutdown)] minutes!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	shutdown_timer = addtimer(CALLBACK(src, PROC_REF(turn_off)), time_to_shutdown MINUTES, TIMER_STOPPABLE)
	if(turn_on_timer)
		deltimer(turn_on_timer)
		turn_on_timer = null

/obj/structure/machinery/transformer/proc/turn_off()
	shutdown_timer = null
	marine_announcement("Power Alert: \nPower grid shutting down.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts' power source has shutdown!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)

/obj/structure/machinery/transformer/lz1
	linked_lz = DROPSHIP_LZ1

/obj/structure/machinery/transformer/lz2
	linked_lz = DROPSHIP_LZ2

/obj/structure/machinery/transformer/active
	state = STATE_MARINE_CAPTURED

#undef STATE_MARINE_CAPTURED
#undef STATE_BROKEN
#undef STATE_XENO_CAPTURED

