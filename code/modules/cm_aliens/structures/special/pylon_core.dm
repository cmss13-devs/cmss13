#define PYLON_REPAIR_TIME (4 SECONDS)
#define PYLON_WEEDS_REGROWTH_TIME (15 SECONDS)

//Hive Pylon - Remote building location for other structures, generates strong weeds

/obj/effect/alien/resin/special/pylon
	name = XENO_STRUCTURE_PYLON
	desc = "A towering spike of resin. Its base pulsates with large tendrils."
	icon_state = "pylon"
	health = 1800
	light_range = 2
	block_range = 0
	var/cover_range = WEED_RANGE_PYLON
	var/node_type = /obj/effect/alien/weeds/node/pylon
	var/obj/effect/alien/weeds/node/node
	var/linked_turfs = list()

	var/damaged = FALSE
	var/plasma_stored = 0
	var/plasma_required_to_repair = 1000

	var/protection_level = TURF_PROTECTION_CAS

	/// How many lesser drone spawns this pylon is able to spawn currently
	var/lesser_drone_spawns = 0
	/// The maximum amount of lesser drone spawns this pylon can hold
	var/lesser_drone_spawn_limit = 5

	plane = FLOOR_PLANE

/obj/effect/alien/resin/special/pylon/endgame/update_icon()
	if(protection_level == TURF_PROTECTION_OB)
		icon_state = "pylon_active"
		return

	icon_state = "pylon"

/obj/effect/alien/resin/special/pylon/Initialize(mapload, hive_ref)
	. = ..()

	node = place_node()
	for(var/turf/A as anything in RANGE_TURFS(floor(cover_range*PYLON_COVERAGE_MULT), loc))
		LAZYADD(A.linked_pylons, src)
		linked_turfs += A

	if(light_range)
		set_light(light_range)

/obj/effect/alien/resin/special/pylon/Destroy()
	for(var/turf/A as anything in linked_turfs)
		LAZYREMOVE(A.linked_pylons, src)

	if(node)
		QDEL_NULL(node)
	. = ..()

/obj/effect/alien/resin/special/pylon/process(delta_time)
	if(lesser_drone_spawns < lesser_drone_spawn_limit)
		// One every 10 seconds while on ovi, one every 120-ish seconds while off ovi
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		lesser_drone_spawns = min(lesser_drone_spawns + ((faction_module.living_xeno_queen?.ovipositor ? 0.1 : 0.008) * delta_time), lesser_drone_spawn_limit)

/obj/effect/alien/resin/special/pylon/attack_alien(mob/living/carbon/xenomorph/M)
	if(isxeno_builder(M) && M.a_intent == INTENT_HELP && M.faction == faction)
		do_repair(M) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()

/obj/effect/alien/resin/special/pylon/get_examine_text(mob/user)
	. = ..()

	if(!isobserver(user) && !isxeno(user))
		return

	var/lesser_count = 0
	for(var/mob/living/carbon/xenomorph/lesser_drone/lesser in faction.total_mobs)
		lesser_count++

	. += "Currently holding [SPAN_NOTICE("[floor(lesser_drone_spawns)]")]/[SPAN_NOTICE("[lesser_drone_spawn_limit]")] lesser drones."
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	. += "There are currently [SPAN_NOTICE("[lesser_count]")] lesser drones in the hive. The hive can support a total of [SPAN_NOTICE("[faction_module.lesser_drone_limit]")] lesser drones at present."

/obj/effect/alien/resin/special/pylon/attack_ghost(mob/dead/observer/user)
	. = ..()
	spawn_lesser_drone(user)

/obj/effect/alien/resin/special/pylon/proc/do_repair(mob/living/carbon/xenomorph/xeno)
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
	if(!do_after(xeno, PYLON_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
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

	var/obj/effect/alien/weeds/node/pylon/N = locate() in loc
	if(!N)
		return
	for(var/obj/effect/alien/weeds/W in N.children)
		if(get_dist(N, W) >= N.node_range)
			continue
		if(istype(W, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(W, TYPE_PROC_REF(/obj/effect/alien/weeds, weed_expand), N), PYLON_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(xeno, SPAN_XENONOTICE("We have successfully repaired \the [name]."))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/pylon/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/pylon_node = new node_type(loc, null, null, faction)
	pylon_node.resin_parent = src
	return pylon_node

/obj/effect/alien/resin/special/pylon/proc/spawn_lesser_drone(mob/xeno_candidate)
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(!faction_module.can_spawn_as_lesser_drone(xeno_candidate, src))
		return FALSE

	if(tgui_alert(xeno_candidate, "Are you sure you want to become a lesser drone?", "Confirmation", list("Yes", "No")) != "Yes")
		return FALSE

	if(!faction_module.can_spawn_as_lesser_drone(xeno_candidate, src))
		return FALSE

	var/mob/living/carbon/xenomorph/lesser_drone/new_drone = new(loc, null, faction)
	xeno_candidate.mind.transfer_to(new_drone, TRUE)
	lesser_drone_spawns -= 1
	new_drone.visible_message(SPAN_XENODANGER("A lesser drone emerges out of [src]!"), SPAN_XENODANGER("You emerge out of [src] and awaken from your slumber. For the Hive!"))
	playsound(new_drone, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	new_drone.generate_name()

	return TRUE

/obj/effect/alien/resin/special/pylon/endgame
	cover_range = WEED_RANGE_CORE
	protection_level = TURF_PROTECTION_CAS
	var/activated = FALSE

/obj/effect/alien/resin/special/pylon/endgame/Initialize(mapload, mob/builder)
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.active_endgame_pylons += src

/obj/effect/alien/resin/special/pylon/endgame/Destroy()
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.active_endgame_pylons -= src
	if(activated)
		activated = FALSE

		if(hijack_delete)
			return ..()

		faction_announcement("ALERT.\n\nEnergy build up around communication relay at [get_area_name(src)] halted.", "[MAIN_AI_SYSTEM] Biological Scanner")

		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			var/datum/faction/check_faction = GLOB.faction_datums[faction_to_get]
			if(!length(check_faction.total_mobs))
				continue

			if(check_faction == faction)
				xeno_announcement(SPAN_XENOANNOUNCE("We have lost our control of the tall's communication relay at [get_area_name(src)]."), faction, XENO_GENERAL_ANNOUNCE)
			else
				xeno_announcement(SPAN_XENOANNOUNCE("Another hive has lost control of the tall's communication relay at [get_area_name(src)]."), faction, XENO_GENERAL_ANNOUNCE)
		faction_module.hive_ui.update_pylon_status()
	return ..()

/// Checks if all comms towers are connected and then starts end game content on all pylons if they are
/obj/effect/alien/resin/special/pylon/endgame/proc/comms_relay_connection()
	faction_announcement("ALERT.\n\nIrregular build up of energy around communication relays at [get_area_name(src)], biological hazard detected.\n\nDANGER: Hazard is strengthening xenomorphs, advise urgent termination of hazard by ground forces.", "[MAIN_AI_SYSTEM] Biological Scanner")

	for(var/faction_to_get in FACTION_LIST_XENOMORPH)
		var/datum/faction/check_faction = GLOB.faction_datums[faction_to_get]
		if(!length(check_faction.total_mobs))
			continue

		if(check_faction == faction)
			xeno_announcement(SPAN_XENOANNOUNCE("We have harnessed the tall's communication relay at [get_area_name(src)].\n\nWe will now grow royal resin from this pylon. Hold it!"), faction, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Another hive has harnessed the tall's communication relay at [get_area_name(src)].[faction.faction_is_ally(check_faction) ? "" : " Stop them!"]"), faction, XENO_GENERAL_ANNOUNCE)

	activated = TRUE
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.check_if_hit_larva_from_pylon_limit()
	addtimer(CALLBACK(src, PROC_REF(give_royal_resin)), XENO_PYLON_ACTIVATION_COOLDOWN, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_LOOP|TIMER_DELETE_ME)

/// Looped proc via timer to give larva after time
/obj/effect/alien/resin/special/pylon/endgame/proc/give_royal_resin()
	if(!activated)
		return

	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(!faction_module.hive_location || !faction_module.living_xeno_queen)
		return

	if(faction_module.buff_points < faction_module.max_buff_points)
		faction_module.buff_points += 1

	faction_module.check_if_hit_larva_from_pylon_limit()

//Hive Core - Generates strong weeds, supports other buildings
/obj/effect/alien/resin/special/pylon/core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. It looks very much alive."
	icon_state = "core"
	health = 1200
	light_range = 4
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
	var/last_larva_time = 0
	var/last_larva_queue_time = 0
	var/last_surge_time = 0
	var/spawn_cooldown = 30 SECONDS
	var/surge_cooldown = 90 SECONDS
	var/surge_incremental_reduction = 3 SECONDS

	protection_level = TURF_PROTECTION_OB

	lesser_drone_spawn_limit = 10

/obj/effect/alien/resin/special/pylon/core/Initialize(mapload)
	. = ..()

	// Pick the closest xeno resource activator

	update_minimap_icon()

	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.set_hive_location(src, faction)

/obj/effect/alien/resin/special/pylon/core/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, faction.minimap_flag, "core")

/obj/effect/alien/resin/special/pylon/core/process()
	. = ..()
	update_minimap_icon()

	// Handle spawning larva if core is connected to a hive
	if(faction)
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		for(var/mob/living/carbon/xenomorph/larva/worm in range(2, src))
			if((!worm.ckey || worm.stat == DEAD) && worm.burrowable && (worm.faction == faction) && !QDELETED(worm))
				visible_message(SPAN_XENODANGER("[worm] quickly burrows into \the [src]."))
				if(!worm.banished)
					// Goob job bringing her back home, but no doubling please
					faction_module.stored_larva++
					faction_module.hive_ui.update_burrowed_larva()
				qdel(worm)

		var/count_spawned = 0
		var/spawning_larva = can_spawn_larva() && (last_larva_time + spawn_cooldown) < world.time
		if(spawning_larva)
			last_larva_time = world.time
		if(spawning_larva || (last_larva_queue_time + spawn_cooldown * 4) < world.time)
			last_larva_queue_time = world.time
			var/list/players_with_xeno_pref = get_alien_candidates(faction)
			if(spawning_larva)
				var/i = 0
				while(i < length(players_with_xeno_pref) && can_spawn_larva())
					if(spawn_burrowed_larva(players_with_xeno_pref[++i]))
						// We were in spawning_larva mode and successfully spawned someone
						count_spawned++
			// Update everyone's queue status
			message_alien_candidates(players_with_xeno_pref, dequeued = count_spawned)

		if(faction_module.hijack_burrowed_surge && (last_surge_time + surge_cooldown) < world.time)
			last_surge_time = world.time
			faction_module.stored_larva++
			faction_module.hijack_burrowed_left--
			if(GLOB.xeno_queue_candidate_count < 1 + count_spawned)
				notify_ghosts(header = "Claim Xeno", message = "The Hive has gained another burrowed larva! Click to take it.", source = src, action = NOTIFY_JOIN_XENO, enter_link = "join_xeno=1")
			if(surge_cooldown > 30 SECONDS) //mostly for sanity purposes
				surge_cooldown = surge_cooldown - surge_incremental_reduction //ramps up over time
			if(faction_module.hijack_burrowed_left < 1)
				faction_module.hijack_burrowed_surge = FALSE
				xeno_message(SPAN_XENOANNOUNCE("The hive's power wanes. We will no longer gain pooled larva over time."), 3, faction)

	// Hive core can repair itself over time
	if(health < maxhealth && last_healed <= world.time)
		health += min(heal_amount, maxhealth-health)
		last_healed = world.time + heal_interval

/obj/effect/alien/resin/special/pylon/core/proc/can_spawn_larva()
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(faction_module.hardcore)
		return FALSE

	return faction_module.stored_larva

/obj/effect/alien/resin/special/pylon/core/proc/spawn_burrowed_larva(mob/xeno_candidate)
	if(can_spawn_larva() && xeno_candidate)
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(loc, faction)
		if(isnull(new_xeno))
			return FALSE

		new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly emerges from [src]!"),
		SPAN_XENODANGER("We emerge from [src] and awaken from our slumber. For the Hive!"))
		msg_admin_niche("[key_name(new_xeno)] emerged from \a [src]. [ADMIN_JMP(src)]")
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(!SSticker.mode.transfer_xeno(xeno_candidate, new_xeno))
			qdel(new_xeno)
			return FALSE
		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva awakened from slumber!"))
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(new_xeno.client)
			if(new_xeno.client.prefs.toggles_flashing & FLASH_POOLSPAWN)
				window_flash(new_xeno.client)

		faction_module.stored_larva--
		faction_module.hive_ui.update_burrowed_larva()

		return TRUE
	return FALSE

/obj/effect/alien/resin/special/pylon/core/attackby(obj/item/attack_item, mob/user)
	if(!istype(attack_item, /obj/item/grab) || !isxeno(user))
		return ..(attack_item, user)

	var/larva_amount = 0 // The amount of larva they get

	var/obj/item/grab/grab = attack_item
	if(!isxeno(grab.grabbed_thing))
		return
	var/mob/living/carbon/carbon_mob = grab.grabbed_thing
	if(carbon_mob.buckled)
		to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
		return
	if(!faction || carbon_mob.stat != DEAD)
		return

	if(SSticker.mode && !(SSticker.mode.flags_round_type & MODE_XVX))
		return // For now, disabled on gamemodes that don't support it (primarily distress signal)

	// Will probably allow for hives to slowly gain larva by killing hostile xenos and taking them to the hive core
	// A self sustaining cycle until one hive kills more of the other hive to tip the balance

	// Makes attacking hives very profitable if they can successfully wipe them out without suffering any significant losses
	var/mob/living/carbon/xenomorph/xeno = carbon_mob
	if(xeno.faction != faction)
		if(isqueen(xeno))
			larva_amount = 5
		else
			larva_amount += max(xeno.tier, 1) // Now you always gain larva.
	else
		return

	if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
		return

	visible_message(SPAN_DANGER("[src] engulfs [xeno] in resin!"))
	playsound(src, "alien_resin_build", 25, 1)
	qdel(xeno)

	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.stored_larva += larva_amount
	faction_module.hive_ui.update_burrowed_larva()

/obj/effect/alien/resin/special/pylon/core/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent != INTENT_HELP && M.can_destroy_special() && M.faction == faction)
		if(!hardcore && last_attempt + 6 SECONDS > world.time)
			to_chat(M,SPAN_WARNING("We have attempted to destroy \the [src] too recently! Wait a bit!")) // no spammy
			return XENO_NO_DELAY_ACTION

		else if(warn && world.time > XENOMORPH_PRE_SETUP_CUTOFF)
			if((alert(M, "Are we sure that you want to destroy the hive core? (There will be a 5 minute cooldown before you can build another one.)", , "Yes", "No") != "Yes"))
				return XENO_NO_DELAY_ACTION

			INVOKE_ASYNC(src, PROC_REF(startDestroying),M)
			return XENO_NO_DELAY_ACTION

		else if(world.time < XENOMORPH_PRE_SETUP_CUTOFF)
			if((alert(M, "Are we sure that we want to remove the hive core? No cooldown will be applied.", , "Yes", "No") != "Yes"))
				return XENO_NO_DELAY_ACTION

			INVOKE_ASYNC(src, PROC_REF(startDestroying),M)
			return XENO_NO_DELAY_ACTION

	if(faction)
		var/current_health = health
		if(hardcore && M.ally_faction(faction))
			return XENO_NO_DELAY_ACTION
		. = ..()

		if(hardcore && last_attacked_message < world.time && current_health > health)
			xeno_message(SPAN_XENOANNOUNCE("The hive core is under attack!"), 2, faction)
			last_attacked_message = world.time + next_attacked_message
	else
		. = ..()

/obj/effect/alien/resin/special/pylon/core/Destroy()
	if(faction)
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		visible_message(SPAN_XENOHIGHDANGER("The resin roof withers away as \the [src] dies!"), max_distance = WEED_RANGE_CORE)
		faction_module.hive_location = null
		if(world.time < XENOMORPH_PRE_SETUP_CUTOFF && !hardcore)
			. = ..()
			return
		faction_module.hivecore_cooldown = TRUE
		INVOKE_ASYNC(src, PROC_REF(cooldownFinish), faction) // start cooldown
		if(hardcore)
			xeno_message(SPAN_XENOANNOUNCE("We can no longer gain new sisters or another Queen. Additionally, we are unable to heal if our Queen is dead"), 2, faction)
			faction_module.hardcore = TRUE
			faction_module.allow_queen_evolve = FALSE
			faction_module.hive_structures_limit[XENO_STRUCTURE_CORE] = 0
			xeno_announcement("\The [faction] has lost their hive core!", "everything", HIGHER_FORCE_ANNOUNCE)

		if(faction_module.hijack_burrowed_surge)
			visible_message(SPAN_XENODANGER("We hear something resembling a scream from [src] as it's destroyed!"))
			xeno_message(SPAN_XENOANNOUNCE("Psychic pain storms throughout the hive as [src] is destroyed! We will no longer gain burrowed larva over time."), 3, faction)
			faction_module.hijack_burrowed_surge = FALSE

	SSminimaps.remove_marker(src)
	. = ..()

/obj/effect/alien/resin/special/pylon/core/proc/startDestroying(mob/living/carbon/xenomorph/M)
	xeno_message(SPAN_XENOANNOUNCE("[M] is destroying \the [src]!"), 3, faction)
	visible_message(SPAN_DANGER("[M] starts destroying \the [src]!"))
	last_attempt = world.time //spamcheck
	if(!do_after(M, 5 SECONDS , INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(M,SPAN_WARNING("You stop destroying \the [src]."))
		visible_message(SPAN_WARNING("[M] stops destroying \the [src]."))
		last_attempt = world.time // update the spam check
		return XENO_NO_DELAY_ACTION
	qdel(src)

/obj/effect/alien/resin/special/pylon/core/proc/cooldownFinish(datum/faction/faction)
	sleep(HIVECORE_COOLDOWN)
	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(faction_module.hivecore_cooldown) // check if its true so we don't double set it.
		faction_module.hivecore_cooldown = FALSE
		xeno_message(SPAN_XENOANNOUNCE("The weeds have recovered! A new hive core can be built!"), 3, faction)
	else
		log_admin("Hivecore cooldown reset proc aborted due to hivecore cooldown var being set to false before the cooldown has finished!")
		// Tell admins that this condition is reached so they know what has happened if it fails somehow
		return

#undef PYLON_REPAIR_TIME
#undef PYLON_WEEDS_REGROWTH_TIME
