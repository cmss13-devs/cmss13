#define PYLON_REPAIR_TIME (4 SECONDS)
#define PYLON_WEEDS_REGROWTH_TIME (15 SECONDS)

//Hive Pylon - Remote building location for other structures, generates strong weeds

/obj/effect/alien/resin/special/pylon
	name = XENO_STRUCTURE_PYLON
	desc = "A towering spike of resin. Its base pulsates with large tendrils."
	icon_state = "pylon"
	health = 1800
	luminosity = 2
	block_range = 0
	var/cover_range = WEED_RANGE_PYLON
	var/node_type = /obj/effect/alien/weeds/node/pylon
	var/linked_turfs = list()

	var/damaged = FALSE
	var/plasma_stored = 0
	var/plasma_required_to_repair = 1000

	var/protection_level = TURF_PROTECTION_CAS

	plane = FLOOR_PLANE

/obj/effect/alien/resin/special/pylon/Initialize(mapload, hive_ref)
	. = ..()

	place_node()
	for(var/turf/A in range(round(cover_range*PYLON_COVERAGE_MULT), loc))
		LAZYADD(A.linked_pylons, src)
		linked_turfs += A

/obj/effect/alien/resin/special/pylon/Destroy()
	for(var/turf/A as anything in linked_turfs)
		LAZYREMOVE(A.linked_pylons, src)

	var/obj/effect/alien/weeds/node/pylon/W = locate() in loc
	if(W)
		qdel(W)
	. = ..()

/obj/effect/alien/resin/special/pylon/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoBuilder(M) && M.a_intent == INTENT_HELP && M.hivenumber == linked_hive.hivenumber)
		do_repair(M) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()

/obj/effect/alien/resin/special/pylon/proc/do_repair(mob/living/carbon/Xenomorph/M)
	if(!istype(M))
		return
	var/can_repair = damaged || health < maxhealth
	if(!can_repair)
		to_chat(M, SPAN_XENONOTICE("\The [name] is in good condition, you don't need to repair it."))
		return

	to_chat(M, SPAN_XENONOTICE("You begin adding the plasma to \the [name] to repair it."))
	xeno_attack_delay(M)
	if(!do_after(M, PYLON_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
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

	var/obj/effect/alien/weeds/node/pylon/N = locate() in loc
	if(!N)
		return
	for(var/obj/effect/alien/weeds/W in N.children)
		if(get_dist(N, W) >= N.node_range)
			continue
		if(istype(W, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(W, /obj/effect/alien/weeds.proc/weed_expand, N), PYLON_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(M, SPAN_XENONOTICE("You have successfully repaired \the [name]."))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/pylon/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/W = new node_type(loc, null, null, linked_hive)
	W.resin_parent = src

//Hive Core - Generates strong weeds, supports other buildings
/obj/effect/alien/resin/special/pylon/core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. It looks very much alive."
	icon_state = "core"
	health = 1200
	luminosity = 4
	cover_range = WEED_RANGE_CORE
	node_type = /obj/effect/alien/weeds/node/pylon/core
	var/hardcore = FALSE
	var/next_attacked_message = 5 SECONDS
	var/last_attacked_message = 0
	var/warn = TRUE // should we warn of hivecore destruction?
	var/heal_amount = 100
	var/heal_interval = 10 SECONDS
	var/last_healed = 0
	var/last_attempt = 0 // logs time of last attempt to prevent spam. if you want to destroy it, you must commit.

	protection_level = TURF_PROTECTION_OB


/obj/effect/alien/resin/special/pylon/core/Initialize(mapload, var/datum/hive_status/hive_ref)
	. = ..()

	// Pick the closest xeno resource activator

	if(hive_ref)
		hive_ref.set_hive_location(src, linked_hive.hivenumber)

/obj/effect/alien/resin/special/pylon/core/process()
	if(health >= maxhealth || last_healed > world.time) return

	health += min(heal_amount, maxhealth)
	last_healed = world.time + heal_interval


/obj/effect/alien/resin/special/pylon/core/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent != INTENT_HELP && M.can_destroy_special() && M.hivenumber == linked_hive.hivenumber)
		if(!hardcore && last_attempt + 6 SECONDS > world.time)
			to_chat(M,SPAN_WARNING("You have attempted to destroy \the [src] too recently! Wait a bit!")) // no spammy
			return XENO_NO_DELAY_ACTION

		else if(warn && world.time > HIVECORE_COOLDOWN_CUTOFF)
			if((alert(M, "Are you sure that you want to destroy the hive core? (There will be a 5 minute cooldown before you can build another one.)", , "Yes", "No") == "No"))
				return XENO_NO_DELAY_ACTION

			INVOKE_ASYNC(src, .proc/startDestroying,M)
			return XENO_NO_DELAY_ACTION

		else if(world.time < HIVECORE_COOLDOWN_CUTOFF)
			if((alert(M, "Are you sure that you want to remove the hive core? No cooldown will be applied.", , "Yes", "No") == "No"))
				return XENO_NO_DELAY_ACTION

			INVOKE_ASYNC(src, .proc/startDestroying,M)
			return XENO_NO_DELAY_ACTION

	if(linked_hive)
		var/current_health = health
		if(hardcore && HIVE_ALLIED_TO_HIVE(M.hivenumber, linked_hive.hivenumber))
			return XENO_NO_DELAY_ACTION
		. = ..()

		if(hardcore && last_attacked_message < world.time && current_health > health)
			xeno_message(SPAN_XENOANNOUNCE("The hive core is under attack!"), 2, linked_hive.hivenumber)
			last_attacked_message = world.time + next_attacked_message

	else
		. = ..()

/obj/effect/alien/resin/special/pylon/core/Destroy()

	if(linked_hive)
		visible_message(SPAN_XENOHIGHDANGER("The resin roof withers away as \the [src] dies!"), max_distance = WEED_RANGE_CORE)
		linked_hive.hive_location = null
		if(world.time < HIVECORE_COOLDOWN_CUTOFF && !hardcore)
			. = ..()
			return
		linked_hive.hivecore_cooldown = TRUE
		INVOKE_ASYNC(src, .proc/cooldownFinish,linked_hive) // start cooldown
		if(hardcore)
			xeno_message(SPAN_XENOANNOUNCE("You can no longer gain new sisters or another Queen. Additionally, you are unable to heal if your Queen is dead"), 2, linked_hive.hivenumber)
			linked_hive.hardcore = TRUE
			linked_hive.allow_queen_evolve = FALSE
			linked_hive.hive_structures_limit[XENO_STRUCTURE_CORE] = 0
			linked_hive.hive_structures_limit[XENO_STRUCTURE_POOL] = 0
			xeno_announcement("\The [linked_hive.name] has lost their hive core!", "everything", HIGHER_FORCE_ANNOUNCE)

			if(linked_hive.spawn_pool)
				qdel(linked_hive.spawn_pool)
	. = ..()

/obj/effect/alien/resin/special/pylon/core/proc/startDestroying(mob/living/carbon/Xenomorph/M)
	xeno_message(SPAN_XENOANNOUNCE("[M] is destroying \the [src]!"), 3, linked_hive.hivenumber)
	visible_message(SPAN_DANGER("[M] starts destroying \the [src]!"))
	last_attempt = world.time 		//spamcheck
	if(!do_after(M, 5 SECONDS , INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(M,SPAN_WARNING("You stop destroying \the [src]."))
		visible_message(SPAN_WARNING("[M] stops destroying \the [src]."))
		last_attempt = world.time // update the spam check
		return XENO_NO_DELAY_ACTION
	Destroy()



/obj/effect/alien/resin/special/pylon/core/proc/cooldownFinish(var/datum/hive_status/linked_hive)
	sleep(HIVECORE_COOLDOWN)
	if(linked_hive.hivecore_cooldown) // check if its true so we don't double set it.
		linked_hive.hivecore_cooldown = FALSE
		xeno_message(SPAN_XENOANNOUNCE("The weeds have recovered! A new hive core can be built!"), 3, linked_hive.hivenumber)
	else
		log_admin("Hivecore cooldown reset proc aborted due to hivecore cooldown var being set to false before the cooldown has finished!")
		// Tell admins that this condition is reached so they know what has happened if it fails somehow
		return

#undef PYLON_REPAIR_TIME
#undef PYLON_WEEDS_REGROWTH_TIME
