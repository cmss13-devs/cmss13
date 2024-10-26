/*
//======
					Energy Ammo
//======
*/

/datum/ammo/energy
	ping = null //no bounce off. We can have one later.
	sound_hit = "energy_hit"
	sound_miss = "energy_miss"
	sound_bounce = "energy_bounce"

	damage_type = BURN
	flags_ammo_behavior = AMMO_ENERGY

	accuracy = HIT_ACCURACY_TIER_4

/datum/ammo/energy/emitter //Damage is determined in emitter.dm
	name = "emitter bolt"
	icon_state = "emitter"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_ARMOR

	accurate_range = 6
	max_range = 6

/datum/ammo/energy/taser
	name = "taser bolt"
	icon_state = "stun"
	damage_type = OXY
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST|AMMO_ALWAYS_FF //Not that ignoring will do much right now.
	stamina_damage = 45
	accuracy = HIT_ACCURACY_TIER_8
	shell_speed = AMMO_SPEED_TIER_1 // Slightly faster
	hit_effect_color = "#FFFF00"

/datum/ammo/energy/taser/on_hit_mob(mob/mobs, obj/projectile/P)
	if(ishuman(mobs))
		var/mob/living/carbon/human/humanus = mobs
		humanus.disable_special_items() // Disables scout cloak
		humanus.make_jittery(40)

/datum/ammo/energy/taser/precise
	name = "precise taser bolt"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST|AMMO_MP

/datum/ammo/energy/rxfm_eva
	name = "laser blast"
	icon_state = "laser_new"
	flags_ammo_behavior = AMMO_LASER
	accurate_range = 14
	max_range = 22
	damage = 45
	stamina_damage = 25 //why not
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/energy/rxfm_eva/on_hit_mob(mob/living/M, obj/projectile/P)
	..()
	if(prob(10)) //small chance for one to ignite on hit
		M.fire_act()

/datum/ammo/energy/laz_uzi
	name = "laser bolt"
	icon_state = "laser_new"
	flags_ammo_behavior = AMMO_ENERGY
	damage = 40
	accurate_range = 5
	effective_range_max = 7
	max_range = 10
	shell_speed = AMMO_SPEED_TIER_4
	scatter = SCATTER_AMOUNT_TIER_6
	accuracy = HIT_ACCURACY_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_8

/datum/ammo/energy/yautja
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	accurate_range = 12
	shell_speed = AMMO_SPEED_TIER_3
	damage_type = BURN
	flags_ammo_behavior = AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/pistol
	name = "plasma pistol bolt"
	icon_state = "ion"

	damage = 40
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/energy/yautja/pistol/incendiary
	damage = 10

/datum/ammo/energy/yautja/pistol/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shrapnel/plasma
	name = "plasma wave"
	shrapnel_chance = 0
	penetration = ARMOR_PENETRATION_TIER_10
	accuracy = HIT_ACCURACY_TIER_MAX
	damage = 15
	icon_state = "shrapnel_plasma"
	damage_type = BURN

/datum/ammo/bullet/shrapnel/plasma/on_hit_mob(mob/living/hit_mob, obj/projectile/hit_projectile)
	hit_mob.Stun(2)

/datum/ammo/energy/yautja/caster
	name = "root caster bolt"
	icon_state = "ion"

/datum/ammo/energy/yautja/caster/stun
	name = "low power stun bolt"
	debilitate = list(2,2,0,0,0,1,0,0)

	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/bolt
	name = "plasma bolt"
	icon_state = "pulse1"
	flags_ammo_behavior = AMMO_IGNORE_RESIST
	shell_speed = AMMO_SPEED_TIER_6
	damage = 35

/datum/ammo/energy/yautja/caster/bolt/stun
	name = "high power stun bolt"
	var/stun_time = 2

	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/bolt/stun/on_hit_mob(mob/M, obj/projectile/P)
	var/mob/living/carbon/C = M
	var/stun_time = src.stun_time
	if(istype(C))
		if(isyautja(C) || ispredalien(C))
			return
		to_chat(C, SPAN_DANGER("An electric shock ripples through your body, freezing you in place!"))
		log_attack("[key_name(C)] was stunned by a high power stun bolt from [key_name(P.firer)] at [get_area(P)]")

		if(ishuman(C))
			stun_time++
		C.apply_effect(stun_time, WEAKEN)
		C.apply_effect(stun_time, STUN)
	..()

/datum/ammo/energy/yautja/caster/sphere
	name = "plasma eradicator"
	icon_state = "bluespace"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_HITS_TARGET_TURF
	shell_speed = AMMO_SPEED_TIER_4
	accuracy = HIT_ACCURACY_TIER_8

	damage = 55

	accurate_range = 8
	max_range = 8

	var/vehicle_slowdown_time = 5 SECONDS

/datum/ammo/energy/yautja/caster/sphere/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(P, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/on_hit_turf(turf/T, obj/projectile/P)
	cell_explosion(P, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/on_hit_obj(obj/O, obj/projectile/P)
	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = O
		multitile_vehicle.next_move = world.time + vehicle_slowdown_time
		playsound(multitile_vehicle, 'sound/effects/meteorimpact.ogg', 35)
		multitile_vehicle.at_munition_interior_explosion_effect(cause_data = create_cause_data("Plasma Eradicator", P.firer))
		multitile_vehicle.interior_crash_effect()
		multitile_vehicle.ex_act(150, P.dir, P.weapon_cause_data, 100)
	cell_explosion(get_turf(P), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/do_at_max_range(obj/projectile/P)
	cell_explosion(get_turf(P), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)


/datum/ammo/energy/yautja/caster/sphere/stun
	name = "plasma immobilizer"
	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST
	accurate_range = 20
	max_range = 20

	var/stun_range = 4 // Big
	var/stun_time = 6

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_mob(mob/M, obj/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_turf(turf/T,obj/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_obj(obj/O,obj/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/do_at_max_range(obj/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/proc/do_area_stun(obj/projectile/P)
	playsound(P, 'sound/weapons/wave.ogg', 75, 1, 25)
	FOR_DVIEW(var/mob/living/carbon/M, src.stun_range, get_turf(P), HIDE_INVISIBLE_OBSERVER)
		var/stun_time = src.stun_time
		log_attack("[key_name(M)] was stunned by a plasma immobilizer from [key_name(P.firer)] at [get_area(P)]")
		if (isyautja(M))
			stun_time -= 2
		if(ispredalien(M))
			continue
		to_chat(M, SPAN_DANGER("A powerful electric shock ripples through your body, freezing you in place!"))
		M.apply_effect(stun_time, STUN)
		M.apply_effect(stun_time, WEAKEN)
	FOR_DVIEW_END

/datum/ammo/energy/yautja/rifle/bolt
	name = "plasma rifle bolt"
	icon_state = "ion"
	damage_type = BURN
	debilitate = list(0,2,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_IGNORE_RESIST

	damage = 55
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/energy/yautja/rifle/bolt/on_hit_mob(mob/hit_mob, obj/projectile/hit_projectile)
	if(isxeno(hit_mob))
		var/mob/living/carbon/xenomorph/xeno = hit_mob
		xeno.apply_damage(damage * 0.75, BURN)
		xeno.AddComponent(/datum/component/status_effect/interference, 30, 30)

/datum/ammo/energy/yautja/rifle/bolt/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

