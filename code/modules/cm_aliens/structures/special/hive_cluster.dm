#define CLUSTER_REPAIR_TIME (4 SECONDS)
#define CLUSTER_WEEDS_REGROWTH_TIME (15 SECONDS)

/obj/effect/alien/resin/special/cluster
	name = XENO_STRUCTURE_CLUSTER
	desc = "A large clump of gooey mass. It rhythmically pulses, as if its pumping something into the weeds below..."
	icon = 'icons/mob/xenos/structures48x48.dmi'
	icon_state = "hive_cluster_idle"

	pixel_x = -8
	pixel_y = -8

	health = 1200
	block_range = 0

	var/node_type = /obj/effect/alien/weeds/node/pylon/cluster
	var/obj/effect/alien/weeds/node/node

	var/damaged = FALSE
	var/plasma_stored = 0
	var/plasma_required_to_repair = 300
	COOLDOWN_DECLARE(time_for_auto_repair)

/obj/effect/alien/resin/special/cluster/Initialize(mapload, hive_ref)
	. = ..()
	node = place_node()
	update_minimap_icon()

	RegisterSignal(SSdcs, COMSIG_GLOB_BOOST_XENOMORPH_WALLS, PROC_REF(start_boost))
	RegisterSignal(SSdcs, COMSIG_GLOB_STOP_BOOST_XENOMORPH_WALLS, PROC_REF(stop_boost))
/obj/effect/alien/resin/special/cluster/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_XENO, "cluster")

/obj/effect/alien/resin/special/cluster/Destroy()
	QDEL_NULL(node)
	SSminimaps.remove_marker(src)
	return ..()

/obj/effect/alien/resin/special/cluster/attack_alien(mob/living/carbon/xenomorph/M)
	if(isxeno_builder(M) && M.a_intent == INTENT_HELP && M.hivenumber == linked_hive.hivenumber)
		do_repair(M) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()


/obj/effect/alien/resin/special/cluster/process()
	. = ..()

	if(!boosted_structure)
		STOP_PROCESSING(SSobj, src)
		return

	if(!COOLDOWN_FINISHED(src, time_for_auto_repair))
		return

	if(health <= maxhealth)
		automatic_repair()

	COOLDOWN_START(src, time_for_auto_repair, 20 SECONDS) // 20 seconds because it takes 15 seconds for weeds to grow back.

/obj/effect/alien/resin/special/cluster/proc/start_boost(source, hive_purchaser)
	SIGNAL_HANDLER
	if(hive_purchaser != src.linked_hive.hivenumber)
		return
	else
		boosted_structure = TRUE
		START_PROCESSING(SSdcs, src)

/obj/effect/alien/resin/special/cluster/proc/stop_boost(source, hive_purchaser)
	SIGNAL_HANDLER
	if(hive_purchaser != src.linked_hive.hivenumber)
		return
	else
		boosted_structure = FALSE

/obj/effect/alien/resin/special/cluster/proc/automatic_repair()
	damaged = FALSE
	health = initial(health)
	for(var/obj/effect/alien/weeds/W as anything in node.children)
		if(get_dist(node, W) >= node.node_range)
			continue
		if(istype(W, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(W, TYPE_PROC_REF(/obj/effect/alien/weeds, weed_expand), node), CLUSTER_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

/obj/effect/alien/resin/special/cluster/proc/do_repair(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return
	if(!xeno.plasma_max)
		return
	var/can_repair = damaged || health < maxhealth
	if(!can_repair)
		to_chat(xeno, SPAN_XENONOTICE("\The [name] is in good condition, you don't need to repair it."))
		return

	to_chat(xeno, SPAN_XENONOTICE("We begin adding the plasma to \the [name] to repair it."))
	xeno_attack_delay(xeno)
	if(!do_after(xeno, CLUSTER_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
		return

	var/amount_to_use = min(xeno.plasma_stored, (plasma_required_to_repair - plasma_stored))
	plasma_stored += amount_to_use
	xeno.plasma_stored -= amount_to_use

	if(plasma_stored < plasma_required_to_repair)
		to_chat(xeno, SPAN_WARNING("\The [name] requires [plasma_required_to_repair - plasma_stored] more plasma to repair it."))
		return

	damaged = FALSE
	plasma_stored = 0
	health = initial(health)

	if(!node)
		return
	for(var/obj/effect/alien/weeds/W as anything in node.children)
		if(get_dist(node, W) >= node.node_range)
			continue
		if(istype(W, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(W, TYPE_PROC_REF(/obj/effect/alien/weeds, weed_expand), node), CLUSTER_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(xeno, SPAN_XENONOTICE("We have successfully repaired \the [name]."))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/cluster/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/cluster/W = new node_type(loc, null, null, linked_hive)
	W.resin_parent = src
	return W

#undef CLUSTER_REPAIR_TIME
#undef CLUSTER_WEEDS_REGROWTH_TIME
