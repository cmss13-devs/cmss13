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

	var/hivenumber = XENO_HIVE_NORMAL

	var/firing_cooldown_time = 2 SECONDS
	COOLDOWN_DECLARE(firing_cooldown)
	var/range = 5
	var/datum/ammo/used_ammo
	var/datum/weakref/last_fired_target
	var/times_fired_at_last_fired_target = 0

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

/obj/effect/alien/resin/moba_turret/proc/get_target_priority(mob/living/current_mob, mob/living/last_hit)
	if(get_dist(src, current_mob) > range)
		return 0

	if(current_mob.ally_of_hivenumber(hivenumber))
		return 0

	if((current_mob == last_hit) && (last_hit.stat == CONSCIOUS))
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
	var/mob/living/last_hit = last_fired_target?.resolve()
	if(last_hit == target)
		times_fired_at_last_fired_target++
		addtimer(CALLBACK(src, PROC_REF(reset_last_fired_target)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	else
		times_fired_at_last_fired_target = 0

	var/obj/projectile/proj = new(get_turf(src), create_cause_data(used_ammo.name, C=src))
	proj.generate_bullet(used_ammo)
	proj.damage *= (1.2 ** times_fired_at_last_fired_target) // Ramping damage if you decide to try and facetank a turret
	proj.permutated += src
	proj.fire_at(target, src, src, used_ammo.max_range, used_ammo.shell_speed)
	last_fired_target = WEAKREF(target)
	playsound(loc, 'sound/effects/splat.ogg', 50, TRUE)
	flick("acid_pillar_attack", src)

/obj/effect/alien/resin/moba_turret/proc/reset_last_fired_target()
	last_fired_target = null
	times_fired_at_last_fired_target = 0

/obj/effect/alien/resin/moba_turret/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/effect/alien/resin/moba_turret/bullet_act(obj/projectile/Proj)
	visible_message(SPAN_XENOWARNING("[src] deflects the [Proj]!"))
	return // Can only be meleed
	// zonenote check on this once ranged minions are added

/obj/effect/alien/resin/moba_turret/left
	hivenumber = XENO_HIVE_MOBA_LEFT

/obj/effect/alien/resin/moba_turret/right
	hivenumber = XENO_HIVE_MOBA_RIGHT
