/datum/ammo/xeno/acid/turret
	name = "strong acid spit"
	icon_state = "xeno_acid_weak"
	sound_hit = "acid_hit"
	sound_bounce = "acid_bounce"
	damage_type = BURN
	spit_cost = 25
	flags_ammo_behavior = AMMO_ACIDIC|AMMO_XENO
	accuracy = HIT_ACCURACY_TIER_MAX
	damage = 100
	max_range = 10
	penetration = ARMOR_PENETRATION_TIER_10 // Fuck your acid armor
	shell_speed = AMMO_SPEED_TIER_6 // As close to undodgable as possible

/obj/effect/alien/resin/moba_turret
	name = "acid pillar"
	desc = "A resin pillar that is oozing with acid potent enough to pierce even the strongest armor."
	icon = 'icons/obj/structures/alien/structures64x96.dmi'
	icon_state = "left_turret"
	anchored = TRUE
	density = TRUE
	can_block_movement = TRUE
	layer = ABOVE_XENO_LAYER
	health = 2000
	bound_height = 92
	bound_width = 64
	bound_x = -0
	bound_y = -32
	maptext_y = 98
	maptext_width = 64
	pixel_y = -32

	var/hivenumber = XENO_HIVE_NORMAL

	var/firing_cooldown_time = 2 SECONDS
	COOLDOWN_DECLARE(firing_cooldown)
	var/range = 5
	var/datum/ammo/used_ammo
	var/datum/weakref/last_fired_target
	/// Every time the turret fires at a player, we add a stack of heat. Heat increases damage by matter of projectile_damage * 1.4^H
	/// Heat decays after a few seconds of not shooting at anything
	var/heat_stacks = 0
	/// How much gold to split between all nearby enemies when this tower is destroyed
	var/gold_bounty = 250
	/// How much gold to give to each person on the enemy team when this tower is destroyed
	var/global_gold_bounty = 50


/obj/effect/alien/resin/moba_turret/Initialize(mapload, hivenum)
	. = ..()
	used_ammo = new /datum/ammo/xeno/acid/turret
	if(hivenum)
		hivenumber = hivenum
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		name = "[lowertext(hive.prefix)][name]"
	START_PROCESSING(SSprocessing, src)
	//transform *= 3
	enable_pixel_scaling()
	for(var/turf/open/floor/tile in range(1, src))
		RegisterSignal(tile, COMSIG_TURF_ENTER, PROC_REF(on_try_enter))
	healthcheck()
	if(!(locate(/obj/effect/moba_reuse_object_spawner) in get_turf(src)))
		new /obj/effect/moba_reuse_object_spawner(get_turf(src), type)
	if(gold_bounty || global_gold_bounty)
		AddComponent(/datum/component/moba_obj_destroyed_reward, gold_bounty, 0, hivenumber, global_gold_bounty)

/obj/effect/alien/resin/moba_turret/proc/get_target_priority(mob/living/current_mob, mob/living/last_hit)
	if(get_dist(src, current_mob) > range)
		return 0

	if(current_mob.ally_of_hivenumber(hivenumber))
		return 0

	if(current_mob.stat == DEAD)
		return 0

	//if(HAS_TRAIT_FROM(current_mob, TRAIT_CLOAKED, "bush"))
	//	return 0

	if((current_mob == last_hit) && (last_hit.stat == CONSCIOUS))
		return 5

	if(HAS_TRAIT(current_mob, TRAIT_MOBA_ATTACKED_HIVE(hivenumber)))
		return 4

	if(HAS_TRAIT(current_mob, TRAIT_MOBA_MINION))
		return 3

	switch(current_mob.stat)
		if(CONSCIOUS)
			return 2
		if(UNCONSCIOUS)
			return 1
		if(DEAD)
			return 0

/obj/effect/alien/resin/moba_turret/proc/on_try_enter(datum/source, atom/movable/mover)
	if(!istype(mover, /obj/projectile))
		return COMPONENT_TURF_DENY_MOVEMENT
	return COMPONENT_TURF_ALLOW_MOVEMENT

/obj/effect/alien/resin/moba_turret/process()
	if(!COOLDOWN_FINISHED(src, firing_cooldown))
		return

	var/mob/living/last_hit = last_fired_target?.resolve()
	var/highest_priority = 0
	var/mob/living/to_target
	for(var/mob/living/possible_target in urange(range, get_turf(src)))
		var/priority = get_target_priority(possible_target, last_hit)
		if(priority > highest_priority)
			highest_priority = priority
			to_target = possible_target

	if(to_target)
		fire_at_target(to_target)

/obj/effect/alien/resin/moba_turret/proc/fire_at_target(mob/living/target)
	COOLDOWN_START(src, firing_cooldown, firing_cooldown_time)

	var/obj/projectile/proj = new(get_turf(src), create_cause_data(used_ammo.name, C=src))
	proj.generate_bullet(used_ammo)
	RegisterSignal(proj, COMSIG_BULLET_PRE_HANDLE_MOB, PROC_REF(on_target_hit))

	if(HAS_TRAIT(target, TRAIT_MOBA_PARTICIPANT)) // minions are exempt from damage scaling
		heat_stacks++
		proj.damage *= (1.4 ** (heat_stacks - 1)) // Ramping damage if you decide to try and facetank a turret

	if(heat_stacks)
		addtimer(CALLBACK(src, PROC_REF(reset_heat)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

	proj.permutated += src
	proj.fire_at(target, src, src, used_ammo.max_range, used_ammo.shell_speed)
	last_fired_target = WEAKREF(target)
	playsound(loc, 'sound/effects/splat.ogg', 50, TRUE)
	flick("acid_pillar_attack", src)

/obj/effect/alien/resin/moba_turret/proc/on_target_hit(datum/source, mob/living/hit, retval)
	SIGNAL_HANDLER

	if(isxeno(hit))
		var/mob/living/carbon/xenomorph/xeno = hit
		if(xeno.hive.hivenumber == hivenumber)
			return COMPONENT_BULLET_PASS_THROUGH

/obj/effect/alien/resin/moba_turret/proc/reset_heat()
	heat_stacks = 0
	//visible_message(SPAN_XENONOTICE("[src]")) // maybe add a text indictation eventually

/obj/effect/alien/resin/moba_turret/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/effect/alien/resin/moba_turret/bullet_act(obj/projectile/Proj)
	visible_message(SPAN_XENOWARNING("[src] deflects the [Proj]!"))
	return // Can only be meleed
	// zonenote check on this once ranged minions are added

/obj/effect/alien/resin/moba_turret/attack_alien(mob/living/carbon/xenomorph/M)
	if((M.a_intent == INTENT_HELP) || (M.hive.hivenumber == hivenumber))
		return XENO_NO_DELAY_ACTION
	else
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("[M] claws [src]!"),
		SPAN_XENONOTICE("We claw [src]."))
		playsound(loc, "alien_resin_break", 25)

		health -= M.melee_damage_upper
		healthcheck()
		return XENO_ATTACK_ACTION

/obj/effect/alien/resin/moba_turret/healthcheck()
	. = ..()
	maptext = MAPTEXT("<center><h2>[floor(health / initial(health) * 100)]%</h2></center>")

/obj/effect/alien/resin/moba_turret/left
	hivenumber = XENO_HIVE_MOBA_LEFT
	icon_state = "left_turret"

/obj/effect/alien/resin/moba_turret/left/back
	health = 1500
	gold_bounty = 500

/obj/effect/alien/resin/moba_turret/left/near_hive
	health = 1250
	gold_bounty = 375

/obj/effect/alien/resin/moba_turret/left/hive_core
	range = 6
	health = 3500 // 75% more HP than standard


/obj/effect/alien/resin/moba_turret/right
	hivenumber = XENO_HIVE_MOBA_RIGHT
	icon_state = "right_turret"

/obj/effect/alien/resin/moba_turret/right/back
	health = 1500
	gold_bounty = 500

/obj/effect/alien/resin/moba_turret/right/near_hive
	health = 1250
	gold_bounty = 375

/obj/effect/alien/resin/moba_turret/right/hive_core
	range = 6
	health = 3500 // 75% more HP than standard
