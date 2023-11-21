/*
//======
					Rocket Ammo
//======
*/

/datum/ammo/rocket
	name = "high explosive rocket"
	icon_state = "missile"
	ping = null //no bounce off.
	sound_bounce = "rocket_bounce"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET|AMMO_STRIKES_SURFACE
	var/datum/effect_system/smoke_spread/smoke

	accuracy = HIT_ACCURACY_TIER_2
	accurate_range = 7
	max_range = 7
	damage = 15
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/rocket/New()
	..()
	smoke = new()

/datum/ammo/rocket/Destroy()
	qdel(smoke)
	smoke = null
	. = ..()

/datum/ammo/rocket/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(get_turf(M), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(M))
	if(ishuman_strict(M)) // No yautya or synths. Makes humans gib on direct hit.
		M.ex_act(350, P.dir, P.weapon_cause_data, 100)
	smoke.start()

/datum/ammo/rocket/on_hit_obj(obj/O, obj/projectile/P)
	cell_explosion(get_turf(O), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(O))
	smoke.start()

/datum/ammo/rocket/on_hit_turf(turf/T, obj/projectile/P)
	cell_explosion(T, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/do_at_max_range(obj/projectile/P)
	cell_explosion(get_turf(P), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(P))
	smoke.start()

/datum/ammo/rocket/ap
	name = "anti-armor rocket"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET

	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 6
	max_range = 6
	damage = 10
	penetration= ARMOR_PENETRATION_TIER_10

/datum/ammo/rocket/ap/on_hit_mob(mob/M, obj/projectile/P)
	var/turf/T = get_turf(M)
	M.ex_act(150, P.dir, P.weapon_cause_data, 100)
	M.apply_effect(2, WEAKEN)
	M.apply_effect(2, PARALYZE)
	if(ishuman_strict(M)) // No yautya or synths. Makes humans gib on direct hit.
		M.ex_act(300, P.dir, P.weapon_cause_data, 100)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/on_hit_obj(obj/O, obj/projectile/P)
	var/turf/T = get_turf(O)
	O.ex_act(150, P.dir, P.weapon_cause_data, 100)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/on_hit_turf(turf/T, obj/projectile/P)
	var/hit_something = 0
	for(var/mob/M in T)
		M.ex_act(150, P.dir, P.weapon_cause_data, 100)
		M.apply_effect(4, WEAKEN)
		M.apply_effect(4, PARALYZE)
		hit_something = 1
		continue
	if(!hit_something)
		for(var/obj/O in T)
			if(O.density)
				O.ex_act(150, P.dir, P.weapon_cause_data, 100)
				hit_something = 1
				continue
	if(!hit_something)
		T.ex_act(150, P.dir, P.weapon_cause_data, 200)

	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/do_at_max_range(obj/projectile/P)
	var/turf/T = get_turf(P)
	var/hit_something = 0
	for(var/mob/M in T)
		M.ex_act(250, P.dir, P.weapon_cause_data, 100)
		M.apply_effect(2, WEAKEN)
		M.apply_effect(2, PARALYZE)
		hit_something = 1
		continue
	if(!hit_something)
		for(var/obj/O in T)
			if(O.density)
				O.ex_act(250, P.dir, P.weapon_cause_data, 100)
				hit_something = 1
				continue
	if(!hit_something)
		T.ex_act(250, P.dir, P.weapon_cause_data)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/anti_tank
	name = "anti-tank rocket"
	damage = 100
	var/vehicle_slowdown_time = 5 SECONDS
	shrapnel_chance = 5
	shrapnel_type = /obj/item/large_shrapnel/at_rocket_dud

/datum/ammo/rocket/ap/anti_tank/on_hit_obj(obj/O, obj/projectile/P)
	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = O
		M.next_move = world.time + vehicle_slowdown_time
		playsound(M, 'sound/effects/meteorimpact.ogg', 35)
		M.at_munition_interior_explosion_effect(cause_data = create_cause_data("Anti-Tank Rocket"))
		M.interior_crash_effect()
		var/turf/T = get_turf(M.loc)
		M.ex_act(150, P.dir, P.weapon_cause_data, 100)
		smoke.set_up(1, T)
		smoke.start()
		return
	return ..()


/datum/ammo/rocket/ltb
	name = "cannon round"
	icon_state = "ltb"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET|AMMO_STRIKES_SURFACE

	accuracy = HIT_ACCURACY_TIER_3
	accurate_range = 32
	max_range = 32
	damage = 25
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/rocket/ltb/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(get_turf(M), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(M), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/on_hit_obj(obj/O, obj/projectile/P)
	cell_explosion(get_turf(O), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(O), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/on_hit_turf(turf/T, obj/projectile/P)
	cell_explosion(get_turf(T), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(T), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/do_at_max_range(obj/projectile/P)
	cell_explosion(get_turf(P), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(P), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/wp
	name = "white phosphorous rocket"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_EXPLOSIVE|AMMO_STRIKES_SURFACE
	damage_type = BURN

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 8
	damage = 90
	max_range = 8

/datum/ammo/rocket/wp/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/rocket/wp/drop_flame(turf/T, datum/cause_data/cause_data)
	playsound(T, 'sound/weapons/gun_flamethrower3.ogg', 75, 1, 7)
	if(!istype(T)) return
	smoke.set_up(1, T)
	smoke.start()
	var/datum/reagent/napalm/blue/R = new()
	new /obj/flamer_fire(T, cause_data, R, 3)

	var/datum/effect_system/smoke_spread/phosphorus/landingSmoke = new /datum/effect_system/smoke_spread/phosphorus
	landingSmoke.set_up(3, 0, T, null, 6, cause_data)
	landingSmoke.start()
	landingSmoke = null

/datum/ammo/rocket/wp/on_hit_mob(mob/M, obj/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)

/datum/ammo/rocket/wp/on_hit_obj(obj/O, obj/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)

/datum/ammo/rocket/wp/on_hit_turf(turf/T, obj/projectile/P)
	drop_flame(T, P.weapon_cause_data)

/datum/ammo/rocket/wp/do_at_max_range(obj/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)

/datum/ammo/rocket/wp/upp
	name = "extreme-intensity incendiary rocket"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_EXPLOSIVE|AMMO_STRIKES_SURFACE
	damage_type = BURN

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 8
	damage = 150
	max_range = 10

/datum/ammo/rocket/wp/upp/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/rocket/wp/upp/drop_flame(turf/T, datum/cause_data/cause_data)
	playsound(T, 'sound/weapons/gun_flamethrower3.ogg', 75, 1, 7)
	if(!istype(T)) return
	smoke.set_up(1, T)
	smoke.start()
	var/datum/reagent/napalm/upp/R = new()
	new /obj/flamer_fire(T, cause_data, R, 3)

/datum/ammo/rocket/wp/upp/on_hit_mob(mob/M, obj/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)

/datum/ammo/rocket/wp/upp/on_hit_obj(obj/O, obj/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)

/datum/ammo/rocket/wp/upp/on_hit_turf(turf/T, obj/projectile/P)
	drop_flame(T, P.weapon_cause_data)

/datum/ammo/rocket/wp/upp/do_at_max_range(obj/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)

/datum/ammo/rocket/wp/quad
	name = "thermobaric rocket"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_STRIKES_SURFACE

	damage = 100
	max_range = 32
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/rocket/wp/quad/on_hit_mob(mob/M, obj/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/on_hit_obj(obj/O, obj/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/on_hit_turf(turf/T, obj/projectile/P)
	drop_flame(T, P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/do_at_max_range(obj/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/custom
	name = "custom rocket"

/datum/ammo/rocket/custom/proc/prime(atom/A, obj/projectile/P)
	var/obj/item/weapon/gun/launcher/rocket/launcher = P.shot_from
	var/obj/item/ammo_magazine/rocket/custom/rocket = launcher.current_mag
	if(rocket.locked && rocket.warhead && rocket.warhead.detonator)
		if(rocket.fuel && rocket.fuel.reagents.get_reagent_amount(rocket.fuel_type) >= rocket.fuel_requirement)
			rocket.forceMove(P.loc)
		rocket.warhead.cause_data = P.weapon_cause_data
		rocket.warhead.prime()
		qdel(rocket)
	smoke.set_up(1, get_turf(A))
	smoke.start()

/datum/ammo/rocket/custom/on_hit_mob(mob/M, obj/projectile/P)
	prime(M, P)

/datum/ammo/rocket/custom/on_hit_obj(obj/O, obj/projectile/P)
	prime(O, P)

/datum/ammo/rocket/custom/on_hit_turf(turf/T, obj/projectile/P)
	prime(T, P)

/datum/ammo/rocket/custom/do_at_max_range(obj/projectile/P)
	prime(null, P)
