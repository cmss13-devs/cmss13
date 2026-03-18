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

/datum/ammo/energy/yautja/caster/bolt/single_stun
	name = "stun bolt"
	var/stun_time = 3

	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/bolt/single_stun/on_hit_mob(mob/all_targets, obj/projectile/stun_bolt)
	var/mob/living/carbon/any_target = all_targets

	if(isyautja(any_target) || ispredalien(any_target))
		return

	if(istype(any_target))
		to_chat(any_target, SPAN_DANGER("An electric shock ripples through your body, freezing you in place!"))
		log_attack("[key_name(any_target)] was stunned by a high power stun bolt from [key_name(stun_bolt.firer)] at [get_area(stun_bolt)]")

		if(ishuman(any_target))
			stun_time++
		any_target.apply_effect(stun_time, WEAKEN)
		any_target.apply_effect(stun_time, STUN)
	..()

/datum/ammo/energy/yautja/caster/sphere/aoe_stun
	name = "plasma immobilizer"
	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST
	accurate_range = 20
	max_range = 20

	var/stun_range = 7 // Big
	var/stun_time = 6

/datum/ammo/energy/yautja/caster/sphere/aoe_stun/on_hit_mob(mob/all_targets, obj/projectile/stun_projectile)
	do_area_stun(stun_projectile)

/datum/ammo/energy/yautja/caster/sphere/aoe_stun/on_hit_turf(turf/any_turf, obj/projectile/stun_projectile)
	do_area_stun(stun_projectile)

/datum/ammo/energy/yautja/caster/sphere/aoe_stun/on_hit_obj(obj/any_object, obj/projectile/stun_projectile)
	do_area_stun(stun_projectile)

/datum/ammo/energy/yautja/caster/sphere/aoe_stun/do_at_max_range(obj/projectile/stun_projectile)
	do_area_stun(stun_projectile)

/datum/ammo/energy/yautja/caster/sphere/aoe_stun/proc/do_area_stun(obj/projectile/stun_projectile)
	playsound(stun_projectile, 'sound/weapons/wave.ogg', 75, 1, 25)

	for(var/mob/living/carbon/any_target in orange(stun_range, stun_projectile))
		log_attack("[key_name(any_target)] was stunned by a plasma immobilizer from [key_name(stun_projectile.firer)] at [get_area(stun_projectile)]")
		var/stun_time = src.stun_time

		if(isyautja(any_target))
			stun_time -= 2

		if(ispredalien(any_target))
			continue
		to_chat(any_target, SPAN_DANGER("A powerful electric shock ripples through your body, freezing you in place!"))
		any_target.apply_effect(stun_time, STUN)
		any_target.apply_effect(stun_time, WEAKEN)


// --- LETHAL AMMO --- \\

/datum/ammo/energy/yautja/caster/bolt/single_lethal
	name = "plasma bolt"
	icon_state = "pulse1"
	flags_ammo_behavior = AMMO_IGNORE_RESIST
	shell_speed = AMMO_SPEED_TIER_6
	damage = 75 // This will really only be used to kill people, so it should be decent at doing so.

/datum/ammo/energy/yautja/caster/bolt/single_lethal/on_hit_mob(mob/all_targets, obj/projectile/lethal_projectile)
	cell_explosion(lethal_projectile, 50, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, lethal_projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/aoe_lethal
	name = "plasma eradicator"
	icon_state = "bluespace"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_HITS_TARGET_TURF
	shell_speed = AMMO_SPEED_TIER_4
	accuracy = HIT_ACCURACY_TIER_8

	damage = 55

	accurate_range = 8
	max_range = 8

	var/vehicle_slowdown_time = 5 SECONDS

/datum/ammo/energy/yautja/caster/aoe_lethal/on_hit_mob(mob/all_targets, obj/projectile/lethal_projectile)
	cell_explosion(lethal_projectile, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, lethal_projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/aoe_lethal/on_hit_turf(mob/all_targets, obj/projectile/lethal_projectile)
	cell_explosion(lethal_projectile, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, lethal_projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/aoe_lethal/on_hit_obj(obj/any_object, obj/projectile/lethal_projectile)
	if(istype(any_object, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = any_object
		multitile_vehicle.next_move = world.time + vehicle_slowdown_time
		playsound(multitile_vehicle, 'sound/effects/meteorimpact.ogg', 35)
		multitile_vehicle.at_munition_interior_explosion_effect(cause_data = create_cause_data("Plasma Eradicator", lethal_projectile.firer))
		multitile_vehicle.interior_crash_effect()
		multitile_vehicle.ex_act(150, lethal_projectile.dir, lethal_projectile.weapon_cause_data, 100)
	cell_explosion(get_turf(lethal_projectile), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, lethal_projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/aoe_lethal/do_at_max_range(obj/projectile/lethal_projectile)
	cell_explosion(get_turf(lethal_projectile), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, lethal_projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/lance
	name = "plasma lance"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_HITS_TARGET_TURF|AMMO_ANTISTRUCT
	shell_speed = AMMO_SPEED_INSTANT // travels 300 tiles in one tick
	scatter = SCATTER_AMOUNT_NONE
	accuracy = HIT_ACCURACY_MULT_TIER_10
	penetration = ARMOR_PENETRATION_TIER_10
	damage = 50
	accurate_range = 10
	effective_range_max = 8
	max_range = 10
	var/vehicle_slowdown_time = 5 SECONDS

// master proc for drawing the laser beam from us to where the projectile hits, even if it hits something before it gets to where you clicked
/datum/ammo/energy/yautja/caster/lance/proc/shaboomboom(obj/projectile/projectile, atom/impact_atom)
	if(!projectile || !impact_atom)
		return
	var/mob/living/user = projectile.firer
	if(!user)
		return
	var/turf/impact_turf = get_turf(impact_atom)
	if(!impact_turf)
		return
	var/datum/beam/plasma_lance = user.beam(impact_turf, "light_beam", 'icons/effects/beam.dmi', time = 0.35 SECONDS, maxdistance = max_range, beam_type = /obj/effect/ebeam/laser/plasma_lance, always_turn = TRUE)
	if(!plasma_lance || !plasma_lance.visuals)
		return
	animate(plasma_lance.visuals, alpha = 0, time = 0.3 SECONDS, color = COLOR_PURPLE, luminosity = 3, easing = SINE_EASING|EASE_OUT)

/datum/ammo/energy/yautja/caster/lance/on_hit_mob(mob/mob, obj/projectile/projectile)
	shaboomboom(projectile, mob)
	var/turf/turf = get_turf(mob)
	if(!ispredalien(mob)) // AP rocket effects on all targets except predaliens because they're adapted against plasma weapons
		mob.ex_act(150, projectile.dir, projectile.weapon_cause_data, 100)
		mob.apply_effect(3, WEAKEN)
		mob.apply_effect(3, PARALYZE)
	if(ishuman_strict(mob))
		mob.ex_act(300, null, projectile.weapon_cause_data, 100)
	cell_explosion(turf, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/lance/on_hit_turf(turf/turf, obj/projectile/projectile)
	shaboomboom(projectile, turf)
	var/hit_something = 0
	for(var/mob/mob in turf)
		if(!ispredalien(mob))
			mob.ex_act(150, projectile.dir, projectile.weapon_cause_data, 100)
			mob.apply_effect(3, WEAKEN)
			mob.apply_effect(3, PARALYZE)
		hit_something = 1
	if(!hit_something)
		for(var/obj/object in turf)
			if(object.density)
				object.ex_act(150, projectile.dir, projectile.weapon_cause_data, 100)
				hit_something = 1
	if(!hit_something)
		turf.ex_act(150, projectile.dir, projectile.weapon_cause_data, 200)
	cell_explosion(turf, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/lance/on_hit_obj(obj/object, obj/projectile/projectile)
	shaboomboom(projectile, object)
	if(istype(object, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = object
		multitile_vehicle.next_move = world.time + vehicle_slowdown_time
		playsound(multitile_vehicle, 'sound/effects/meteorimpact.ogg', 35)
		multitile_vehicle.at_munition_interior_explosion_effect(cause_data = create_cause_data("Plasma Lance", projectile.firer))
		multitile_vehicle.interior_crash_effect()
		multitile_vehicle.ex_act(150, projectile.dir, projectile.weapon_cause_data, 100)
		cell_explosion(get_turf(projectile), 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)
	else
		var/turf/turf = get_turf(object)
		object.ex_act(150, projectile.dir, projectile.weapon_cause_data, 100)
		cell_explosion(turf, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)

/datum/ammo/energy/yautja/caster/lance/do_at_max_range(obj/projectile/projectile)
	shaboomboom(projectile, get_turf(projectile))
	cell_explosion(get_turf(projectile), 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)

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

