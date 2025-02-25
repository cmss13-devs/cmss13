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
	penetration = ARMOR_PENETRATION_TIER_3
	shell_speed = AMMO_SPEED_TIER_6 // As close to undodgable as possible

/obj/effect/alien/resin/moba_turret
	name = "acid pillar"
	desc = "A resin pillar that is oozing with acid."
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "acid_pillar_idle"
	anchored = TRUE
	density = TRUE
	health = 2000
	pixel_y = 16
	bound_height = 96
	bound_width = 96
	maptext_y = 26

	var/hivenumber = XENO_HIVE_NORMAL

	var/firing_cooldown_time = 2 SECONDS
	COOLDOWN_DECLARE(firing_cooldown)
	var/range = 5
	var/datum/ammo/used_ammo
	var/datum/weakref/last_fired_target
	/// Every time the turret fires at a player, we add a stack of heat. Heat increases damage by matter of projectile_damage * 1.4^H
	/// Heat decays after a few seconds of not shooting at anything
	var/heat_stacks = 0


/obj/effect/alien/resin/moba_turret/Initialize(mapload, hive)
	. = ..()
	used_ammo = new /datum/ammo/xeno/acid/turret
	if(hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	START_PROCESSING(SSprocessing, src)
	transform *= 3
	enable_pixel_scaling()
	for(var/turf/open/floor/tile in range(1, src))
		RegisterSignal(tile, COMSIG_TURF_ENTER, PROC_REF(on_try_enter))
	healthcheck()

/obj/effect/alien/resin/moba_turret/proc/get_target_priority(mob/living/current_mob, mob/living/last_hit)
	if(get_dist(src, current_mob) > range)
		return 0

	if(current_mob.ally_of_hivenumber(hivenumber))
		return 0

	if((current_mob == last_hit) && (last_hit.stat == CONSCIOUS))
		return 5

	if(HAS_TRAIT(current_mob, TRAIT_MOBA_ATTACKED_HIVE(hivenumber)))
		return 4

	switch(current_mob.stat)
		if(CONSCIOUS)
			return 3
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
	maptext = MAPTEXT("<center>[floor(health / initial(health) * 100)]%</center>")

/obj/effect/alien/resin/moba_turret/left
	hivenumber = XENO_HIVE_MOBA_LEFT

/obj/effect/alien/resin/moba_turret/right
	hivenumber = XENO_HIVE_MOBA_RIGHT

/obj/effect/alien/resin/moba_turret/hive_core
	range = 6
	health = 3500 // 75% more HP than standard
