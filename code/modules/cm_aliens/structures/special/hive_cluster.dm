#define CLUSTER_REPAIR_TIME (4 SECONDS)
#define CLUSTER_WEEDS_REGROWTH_TIME (15 SECONDS)

/obj/effect/alien/resin/special/cluster
	name = XENO_STRUCTURE_CLUSTER
	desc = "A large clump of gooey mass. It rhythmically pulses, as if its pumping something into the weeds below..."
	icon = 'icons/mob/hostiles/structures48x48.dmi'
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

/obj/effect/alien/resin/special/cluster/Initialize(mapload, hive_ref)
	. = ..()
	node = place_node()

/obj/effect/alien/resin/special/cluster/Destroy()
	QDEL_NULL(node)
	return ..()

/obj/effect/alien/resin/special/cluster/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoBuilder(M) && M.a_intent == INTENT_HELP && M.hivenumber == linked_hive.hivenumber)
		do_repair(M) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()

/obj/effect/alien/resin/special/cluster/proc/do_repair(mob/living/carbon/Xenomorph/M)
	if(!istype(M))
		return
	var/can_repair = damaged || health < maxhealth
	if(!can_repair)
		to_chat(M, SPAN_XENONOTICE("\The [name] is in good condition, you don't need to repair it."))
		return

	to_chat(M, SPAN_XENONOTICE("You begin adding the plasma to \the [name] to repair it."))
	xeno_attack_delay(M)
	if(!do_after(M, CLUSTER_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
		return

	var/amount_to_use = min(M.plasma_stored, (plasma_required_to_repair - plasma_stored))
	plasma_stored += amount_to_use
	M.plasma_stored -= amount_to_use

	if(plasma_stored < plasma_required_to_repair)
		to_chat(M, SPAN_WARNING("\The [name] requires [plasma_required_to_repair - plasma_stored] more plasma to repair it."))
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
		addtimer(CALLBACK(W, /obj/effect/alien/weeds.proc/weed_expand, node), CLUSTER_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(M, SPAN_XENONOTICE("You have successfully repaired \the [name]."))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/cluster/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/cluster/W = new node_type(loc, null, null, linked_hive)
	W.resin_parent = src
	return W

#undef CLUSTER_REPAIR_TIME
#undef CLUSTER_WEEDS_REGROWTH_TIME
