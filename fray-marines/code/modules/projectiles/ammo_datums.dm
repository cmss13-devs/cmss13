/datum/ammo/flamethrower/tank_flamer/buffed/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T)) return
	var/datum/reagent/napalm/blue/B = new()
	new /obj/flamer_fire(T, cause_data, B, 1)

/datum/ammo/rocket/ap/tank
	accurate_range = 8
	max_range = 10

/datum/ammo/bullet/pistol/ap/cluster
	name = "cluster pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/heavy/cluster
	name = "heavy cluster pistol bullet"
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/heavy/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/squash/cluster
	name = "cluster squash-head pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 2

/datum/ammo/bullet/pistol/squash/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/revolver/cluster
	name = "cluster revolver bullet"
	shrapnel_chance = 0
	var/cluster_addon = 4
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/revolver/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/smg/ap/cluster
	name = "cluster submachinegun bullet"
	shrapnel_chance = 0
	penetration = ARMOR_PENETRATION_TIER_4
	var/cluster_addon = 0.8

/datum/ammo/bullet/smg/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/rifle/ap/cluster
	name = "cluster rifle bullet"
	shrapnel_chance = 0

	penetration = ARMOR_PENETRATION_TIER_6
	var/cluster_addon = 1

/datum/ammo/bullet/rifle/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/*
//======
					Xeno Spits
//======
*/

/datum/ammo/xeno/sticky
	name = "sticky resin spit"
	icon_state = "sticky"
	sound_hit  = "alien_resin_move"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_RESIST
	added_spit_delay = 5
	spit_cost = 40

	shell_speed = AMMO_SPEED_TIER_3
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_4
	max_range = 10

	var/need_weeds_to_stick = TRUE
	var/effect_time = 3.5 SECONDS
	var/effect_max = 20 SECONDS
	var/resin_type = /obj/effect/alien/resin/sticky/thin

/datum/ammo/xeno/sticky/on_hit_mob(mob/M,obj/projectile/P)
	if (!isxeno(M))
		var/add_time = M.superslowed + effect_time / 10
		M.SetSuperslow(min(add_time, effect_max / 10))
		M.visible_message(SPAN_DANGER("[M]'s movements are slowed."))
	drop_resin(get_turf(M))

/datum/ammo/xeno/sticky/on_hit_obj(obj/O,obj/projectile/P)
	drop_resin(get_turf(O))

/datum/ammo/xeno/sticky/on_hit_turf(turf/T,obj/projectile/P)
	drop_resin(T)

/datum/ammo/xeno/sticky/do_at_max_range(obj/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/proc/drop_resin(turf/T)
	if (T.density || !resin_type)
		return

	if (need_weeds_to_stick)
		var/obj/effect/alien/weeds/weed = locate() in T
		if(!weed)
			return

	for(var/obj/O in T.contents)
		if (istype(O, /obj/effect/alien/egg))
			return
		if (istype(O, /obj/structure/mineral_door) || istype(O, /obj/effect/alien/resin) || istype(O, /obj/structure/bed))
			return
		if (O.density && !(O.flags_atom & ON_BORDER))
			return

	new resin_type(T)

/datum/ammo/xeno/sticky/strong
	name = "sticky resin spatter"
	max_range = 6

	need_weeds_to_stick = FALSE
	effect_time = 5 SECONDS
	resin_type = /obj/effect/alien/resin/sticky

/datum/ammo/xeno/sticky/strong/on_hit_mob(mob/M,obj/projectile/P)
	. =	..()

	if (!isxeno(M))
		M.AdjustStun(1)

/datum/ammo/xeno/sticky/heal
	name = "living resin spit"
	icon_state = "boiler_railgun"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_IGNORE_XENO_IFF
	added_spit_delay = 0
	spit_cost = 50

	effect_time = 1 SECONDS
	resin_type = null

	var/heal_range = 0
	var/heal_amount = 30
	var/shield_decay = 5
	var/shield_duration = 25 SECONDS

/datum/ammo/xeno/sticky/heal/on_hit_mob(mob/M,obj/projectile/P)
	heal_xeno_in_radius(get_turf(M), P)
	..()

/datum/ammo/xeno/sticky/heal/on_hit_obj(obj/O,obj/projectile/P)
	heal_xeno_in_radius(get_turf(O), P)

/datum/ammo/xeno/sticky/heal/on_hit_turf(turf/T,obj/projectile/P)
	var/turf/center = T.density && heal_range ? get_step(T,reverse_dir[P.dir]) : T
	heal_xeno_in_radius(center, P)

/datum/ammo/xeno/sticky/heal/do_at_max_range(obj/projectile/P)
	heal_xeno_in_radius(get_turf(P), P)

/datum/ammo/xeno/sticky/heal/proc/heal_xeno_in_radius(turf/center, obj/projectile/P)
	for(var/mob/living/carbon/xenomorph/buddy in range(heal_range,center))
		if (buddy == P.firer || buddy.stat == DEAD)
			continue

		if (SEND_SIGNAL(buddy, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			continue

		if (buddy.health < buddy.maxHealth)
			to_chat(buddy, SPAN_XENOHIGHDANGER("You are healed by [P.firer]!"))
			buddy.visible_message(SPAN_BOLDNOTICE("[P] quickly wraps around [buddy], sealing some of its wounds!"))

		buddy.flick_heal_overlay(2 SECONDS, "#FFA800") //FFA800
		buddy.xeno_jitter(1 SECONDS)
		buddy.add_xeno_shield(heal_amount/2, XENO_SHIELD_SOURCE_SPITTER_SUPPRESSOR, duration = shield_duration, decay_amount_per_second = shield_decay)
		buddy.gain_health(heal_amount)

		if (!heal_range) /// без усиления мы будем лечить лишь одного
			break

/datum/ammo/xeno/sticky/heal/strong
	name = "living resin spatter"
	max_range = 6

	effect_time = 1.5 SECONDS
	heal_amount = 90
	heal_range = 1
