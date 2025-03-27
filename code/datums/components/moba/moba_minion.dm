/datum/component/moba_minion
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/xenomorph/parent_xeno
	var/atom/movable/target
	var/turf/next_turf_target
	var/is_moving_to_next_point = FALSE
	var/is_moving_to_target = FALSE
	var/walk_to_delay = 0.7 SECONDS

	/// If we don't move for a while then we die
	var/ticks_since_last_move = 0
	var/turf/last_turf
	var/map_id

/datum/component/moba_minion/Initialize(map_id, gold_on_kill, xp_on_kill)
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	parent_xeno = parent
	src.map_id = map_id

	START_PROCESSING(SSprocessing, src)
	parent_xeno.a_intent_change(INTENT_HARM)
	parent_xeno.need_weeds = FALSE
	ADD_TRAIT(parent_xeno, TRAIT_MOBA_MINION, TRAIT_SOURCE_INHERENT)
	// We don't want minions passing through each other and players
	parent_xeno.pass_flags = new()
	parent_xeno.pass_flags.flags_pass = PASS_MOB_IS_XENO
	parent_xeno.pass_flags.flags_can_pass_all = PASS_MOB_THRU_XENO|PASS_AROUND|PASS_HIGH_OVER_ONLY
	parent_xeno.melee_damage_lower *= 0.75 // Less damage overall since they shouldn't be a massive threat to players
	parent_xeno.melee_damage_upper = parent_xeno.melee_damage_lower
	parent_xeno.gibs_path = /obj/effect/decal/remains/xeno/decaying
	parent_xeno.blood_path = /obj/effect/decal/cleanable/blood/xeno/decaying
	RegisterSignal(parent_xeno, COMSIG_MOB_DEATH, PROC_REF(on_death))
	parent_xeno.AddComponent(\
		/datum/component/moba_death_reward,\
		gold_on_kill,\
		xp_on_kill,\
		parent_xeno.hivenumber,\
		TRUE,\
		0.2,\
	)

/datum/component/moba_minion/Destroy(force, silent)
	REMOVE_TRAIT(parent_xeno, TRAIT_MOBA_MINION, TRAIT_SOURCE_INHERENT)
	parent_xeno = null
	target = null
	next_turf_target = null
	last_turf = null
	return ..()

/datum/component/moba_minion/process(delta_time) // We do the bound_width/height bullshit so that AI can actually attack large objects
	if(parent_xeno.stat == DEAD)
		return

	if(ticks_since_last_move >= 10)
		parent_xeno.death(create_cause_data("getting stuck"))
		return

	if(!parent_xeno.check_state())
		return

	var/turf/parent_turf = get_turf(parent_xeno)
	if(parent_turf == last_turf)
		ticks_since_last_move++

	last_turf = parent_turf

	if(!target)
		try_find_target()

	var/target_dist = get_dist(parent_xeno, target)

	if(target && (target_dist >= 4))
		target = null

	if(target && (target_dist > max((target.bound_height + target.bound_width) / 96, 1)))
		move_to_target()

	if(target && ((target_dist <= max((target.bound_height + target.bound_width) / 96, 1))))
		attack_target()

	if(!target && !is_moving_to_next_point)
		move_to_next_point()

/datum/component/moba_minion/proc/try_find_target()
	var/mob/living/best_target_found
	var/best_weight_found
	var/list/view_list = view(4, parent_xeno)
	for(var/mob/living/possible_target in view_list)
		var/weight = 0
		if((possible_target.stat == DEAD) || parent_xeno.hive.is_ally(possible_target) || HAS_TRAIT(possible_target, TRAIT_CLOAKED))
			continue

		if(HAS_TRAIT(possible_target, TRAIT_MOBA_ATTACKED_HIVE(parent_xeno.hive.hivenumber))) // If attacked a friendly player, they're on our shitlist
			weight = 4

		else if(HAS_TRAIT(possible_target, TRAIT_MOBA_PARTICIPANT))
			weight = 1

		else if(HAS_TRAIT(possible_target, TRAIT_MOBA_MINION))
			weight = 2

		if(weight > best_weight_found)
			best_target_found = possible_target
			best_weight_found = weight

	var/seen_turret = FALSE

	for(var/obj/effect/alien/resin/moba_turret/turret in view_list)
		if(turret.hivenumber == parent_xeno.hive.hivenumber)
			continue

		if(best_weight_found <= 2)
			best_target_found = turret
			seen_turret = TRUE

	if(!seen_turret) // We prioritize the things that are shooting at us first
		for(var/obj/effect/alien/resin/moba_hive_core/nexus in view_list)
			if(nexus.hivenumber == parent_xeno.hive.hivenumber)
				continue

			if(best_weight_found <= 2)
				best_target_found = nexus

	target = best_target_found
	if(target) // Zonenote consider having them return to the tile they came from if they move to target someone
		is_moving_to_next_point = FALSE
		walk(parent_xeno, 0) // stops them walking

/datum/component/moba_minion/proc/attack_target()
	var/target_is_minion = HAS_TRAIT(target, TRAIT_MOBA_MINION) // minions do less damage to eachother to ensure that clashes last longer and that CS is easier to claim
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD)
			target = null
			return

	is_moving_to_target = FALSE
	if(target_is_minion)
		parent_xeno.melee_damage_upper *= MOBA_MINION_V_MINION_DAMAGE_MULT
		parent_xeno.melee_damage_lower = parent_xeno.melee_damage_upper
	target.attack_alien(parent_xeno)
	if(target_is_minion)
		parent_xeno.melee_damage_upper *= (1 / MOBA_MINION_V_MINION_DAMAGE_MULT)
		parent_xeno.melee_damage_lower = parent_xeno.melee_damage_upper
	ticks_since_last_move = 0 // if we're attacking something, we can assume we're not really stuck

/datum/component/moba_minion/proc/move_to_target()
	walk_to(parent_xeno, target, 1, walk_to_delay)
	is_moving_to_target = TRUE

/datum/component/moba_minion/proc/move_to_next_point()
	is_moving_to_next_point = TRUE
	walk_to(parent_xeno, next_turf_target, 0, walk_to_delay)

/datum/component/moba_minion/proc/on_death(datum/source, datum/cause_data/cause)
	SIGNAL_HANDLER

	if(parent_xeno)
		walk(parent_xeno, 0)
		QDEL_IN(parent_xeno, rand(15 SECONDS, 25 SECONDS))

	if(cause?.weak_mob)
		var/mob/living/carbon/xenomorph/xeno = cause.weak_mob.resolve()
		if(!istype(xeno))
			return

		var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
		for(var/datum/moba_player/player as anything in (parent_xeno.hivenumber == XENO_HIVE_MOBA_LEFT ? controller.team2 : controller.team1))
			if(player.get_tied_xeno() != xeno)
				continue

			player.creep_score += MOBA_CS_PER_MINION
			break
