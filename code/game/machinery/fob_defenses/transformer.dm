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
	var/obj/structure/machinery/backup_generator/backup

/obj/structure/machinery/transformer/Initialize(mapload, ...)
	RegisterSignal(get_turf(src), COMSIG_WEEDNODE_GROWTH, PROC_REF(handle_xeno_acquisition))
	GLOB.transformer = src
	. = ..()

/obj/structure/machinery/transformer/Destroy()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)
	backup = null
	GLOB.transformer = null
	. = ..()

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
	var/obj/effect/alien/resin/special/cluster/cluster_parent = parent_node.resin_parent

	var/list/held_children_weeds = parent_node.children
	var/cluster_loc = cluster_parent.loc
	var/linked_hive = cluster_parent.linked_hive

	parent_node.children = list()

	qdel(cluster_parent)

	var/obj/effect/alien/resin/special/pylon/endgame/new_pylon = new(cluster_loc, linked_hive)
	new_pylon.node.children = held_children_weeds

	for(var/obj/effect/alien/weeds/weed in new_pylon.node.children)
		weed.parent = new_pylon.node
		weed.spread_on_semiweedable = TRUE
		weed.weed_expand()

	RegisterSignal(new_pylon, COMSIG_PARENT_QDELETING, PROC_REF(uncorrupt))

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

	var/obj/item/tool/weldingtool/welder = item

	if(welder.get_fuel() < 1)
		to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	to_chat(user, SPAN_NOTICE("You start repairing [src]."))

	if(!do_after(user, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	if(!welder.remove_fuel(1, user))
		return

	to_chat(user, SPAN_NOTICE("You repair [src]."))
	playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)

	state = STATE_MARINE_CAPTURED
	update_icon()
	if(shutdown_timer)
		deltimer(shutdown_timer)
	marine_announcement("Power Alert: \nColony transformer online. Power grid operational.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhost's power source has been restored!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_ON)

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

	playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
	state = STATE_BROKEN
	update_icon()
	marine_announcement("Power Alert: \nColony transformer unresponsive. Power Grid shutdown estimated in 5 minutes.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhost's power source was destroyed, It will shutdown in 5 minutes!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	shutdown_timer = addtimer(CALLBACK(src, PROC_REF(turn_off)), 5 MINUTES, TIMER_STOPPABLE)

/obj/structure/machinery/transformer/proc/turn_off()
	shutdown_timer = null
	marine_announcement("Power Alert: \nPower grid shutting down.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhost's power source has shutdown!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)

/obj/structure/machinery/transformer/active
	state = STATE_MARINE_CAPTURED

#undef STATE_MARINE_CAPTURED
#undef STATE_BROKEN
#undef STATE_XENO_CAPTURED

