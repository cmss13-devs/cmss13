/*
//======
					Misc Ammo
//======
*/

/datum/ammo/alloy_spike
	name = "alloy spike"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	ping = "ping_s"
	icon_state = "MSpearFlight"
	sound_hit = "alloy_hit"
	sound_armor = "alloy_armor"
	sound_bounce = "alloy_bounce"

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 12
	max_range = 12
	damage = 30
	penetration= ARMOR_PENETRATION_TIER_10
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_7
	shrapnel_type = /obj/item/shard/shrapnel

/datum/ammo/flamethrower
	name = "flame"
	icon_state = "pulse0"
	damage_type = BURN
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_HITS_TARGET_TURF

	max_range = 6
	damage = 35

/datum/ammo/flamethrower/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/flamethrower/on_hit_mob(mob/M, obj/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)

/datum/ammo/flamethrower/on_hit_obj(obj/O, obj/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)

/datum/ammo/flamethrower/on_hit_turf(turf/T, obj/projectile/P)
	drop_flame(T, P.weapon_cause_data)

/datum/ammo/flamethrower/do_at_max_range(obj/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)

/datum/ammo/flamethrower/tank_flamer
	flamer_reagent_id = "highdamagenapalm"
	max_range = 8
	shell_speed = 1.5

/datum/ammo/flamethrower/tank_flamer/drop_flame(turf/turf, datum/cause_data/cause_data)
	if(!istype(turf))
		return

	var/datum/reagent/napalm/high_damage/reagent = new()
	new /obj/flamer_fire(turf, cause_data, reagent, 1)

	var/datum/effect_system/smoke_spread/landingsmoke = new /datum/effect_system/smoke_spread
	landingsmoke.set_up(1, 0, turf, null, 4, cause_data)
	landingsmoke.start()
	landingsmoke = null

/datum/ammo/flamethrower/sentry_flamer
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_IGNORE_COVER|AMMO_FLAME
	flamer_reagent_id = "napalmx"

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 6
	max_range = 12
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/flamethrower/sentry_flamer/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/flamethrower/sentry_flamer/glob
	max_range = 14
	accurate_range = 10
	var/datum/effect_system/smoke_spread/phosphorus/smoke

/datum/ammo/flamethrower/sentry_flamer/glob/New()
	. = ..()
	smoke = new()

/datum/ammo/flamethrower/sentry_flamer/glob/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T))
		return
	smoke.set_up(1, 0, T, new_cause_data = cause_data)
	smoke.start()

/datum/ammo/flamethrower/sentry_flamer/glob/Destroy()
	qdel(smoke)
	return ..()

/datum/ammo/flamethrower/sentry_flamer/mini
	name = "normal fire"

/datum/ammo/flamethrower/sentry_flamer/mini/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T))
		return
	var/datum/reagent/napalm/ut/R = new()
	R.durationfire = BURN_TIME_INSTANT
	new /obj/flamer_fire(T, cause_data, R, 0)

/datum/ammo/flamethrower/sentry_flamer/wy
	name = "sticky fire"
	flamer_reagent_id = "stickynapalm"
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/flamethrower/sentry_flamer/upp
	name = "gel fire"
	flamer_reagent_id = "napalmgel"

/datum/ammo/flare
	name = "flare"
	ping = null //no bounce off.
	damage_type = BURN
	flags_ammo_behavior = AMMO_HITS_TARGET_TURF
	icon_state = "flare"

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 14
	shell_speed = AMMO_SPEED_TIER_3

	var/flare_type = /obj/item/device/flashlight/flare/on/gun
	handful_type = /obj/item/device/flashlight/flare

/datum/ammo/flare/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary, stacks = 2.5)
	))

/datum/ammo/flare/on_hit_mob(mob/M,obj/projectile/P)
	drop_flare(get_turf(M), P, P.firer)

/datum/ammo/flare/on_hit_obj(obj/O,obj/projectile/P)
	drop_flare(get_turf(P), P, P.firer)

/datum/ammo/flare/on_hit_turf(turf/T, obj/projectile/P)
	if(T.density && isturf(P.loc))
		drop_flare(P.loc, P, P.firer)
	else
		drop_flare(T, P, P.firer)

/datum/ammo/flare/do_at_max_range(obj/projectile/P, mob/firer)
	drop_flare(get_turf(P), P, P.firer)

/datum/ammo/flare/proc/drop_flare(turf/T, obj/projectile/fired_projectile, mob/firer)
	var/obj/item/device/flashlight/flare/G = new flare_type(T)
	var/matrix/rotation = matrix()
	rotation.Turn(fired_projectile.angle - 90)
	G.apply_transform(rotation)
	G.visible_message(SPAN_WARNING("\A [G] bursts into brilliant light nearby!"))
	return G

/datum/ammo/flare/signal
	name = "signal flare"
	icon_state = "flare_signal"
	flare_type = /obj/item/device/flashlight/flare/signal/gun
	handful_type = /obj/item/device/flashlight/flare/signal

/datum/ammo/flare/signal/drop_flare(turf/T, obj/projectile/fired_projectile, mob/firer)
	var/obj/item/device/flashlight/flare/signal/gun/signal_flare = ..()
	signal_flare.activate_signal(firer)
	if(istype(fired_projectile.shot_from, /obj/item/weapon/gun/flare))
		var/obj/item/weapon/gun/flare/flare_gun_fired_from = fired_projectile.shot_from
		flare_gun_fired_from.last_signal_flare_name = signal_flare.name

/datum/ammo/flare/starshell
	name = "starshell ash"
	icon_state = "starshell_bullet"
	max_range = 5
	damage = 2.5
	flare_type = /obj/item/device/flashlight/flare/on/starshell_ash

/datum/ammo/flare/starshell/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff),
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary, stacks = 2)
	))

/datum/ammo/souto
	name = "Souto Can"
	ping = null //no bounce off.
	damage_type = BRUTE
	shrapnel_type = /obj/item/reagent_container/food/drinks/cans/souto/classic
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_IGNORE_ARMOR|AMMO_IGNORE_RESIST|AMMO_BALLISTIC|AMMO_STOPPED_BY_COVER|AMMO_SPECIAL_EMBED
	var/obj/item/reagent_container/food/drinks/cans/souto/can_type
	icon_state = "souto_classic"

	max_range = 12
	shrapnel_chance = 10
	accuracy = HIT_ACCURACY_TIER_8 + HIT_ACCURACY_TIER_8
	accurate_range = 12
	shell_speed = AMMO_SPEED_TIER_1

/datum/ammo/souto/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	if(ishuman(embedded_mob) && !isyautja(embedded_mob))
		if(istype(target_organ))
			target_organ.embed(new can_type)

/datum/ammo/souto/on_hit_mob(mob/M, obj/projectile/P)
	if(!M || M == P.firer)
		return
	if(M.throw_mode && !M.get_active_hand()) //empty active hand and we're in throw mode. If so we catch the can.
		if(!M.is_mob_incapacitated()) // People who are not able to catch cannot catch.
			if(length(P.contents) == 1)
				for(var/obj/item/reagent_container/food/drinks/cans/souto/S in P.contents)
					M.put_in_active_hand(S)
					for(var/mob/O in viewers(GLOB.world_view_size, P)) //find all people in view.
						O.show_message(SPAN_DANGER("[M] catches [S]!"), SHOW_MESSAGE_VISIBLE) //Tell them the can was caught.
					return //Can was caught.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human") //no effect on synths or preds.
			H.apply_effect(6, STUN)
			H.apply_effect(8, WEAKEN)
			H.apply_effect(15, DAZE)
			H.apply_effect(15, SLOW)
		shake_camera(H, 2, 1)
		if(length(P.contents))
			drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_hit_obj(obj/O,obj/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_hit_turf(turf/T, obj/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/do_at_max_range(obj/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_shield_block(mob/M, obj/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/proc/drop_can(loc, obj/projectile/P)
	if(length(P.contents))
		for(var/obj/item/I in P.contents)
			I.forceMove(loc)
	randomize_projectile(P)

/datum/ammo/souto/proc/randomize_projectile(obj/projectile/P)
	shrapnel_type = pick(typesof(/obj/item/reagent_container/food/drinks/cans/souto)-/obj/item/reagent_container/food/drinks/cans/souto)

/datum/ammo/grenade_container
	name = "grenade shell"
	ping = null
	damage_type = BRUTE
	var/nade_type = /obj/item/explosive/grenade/high_explosive
	icon_state = "grenade"
	flags_ammo_behavior = AMMO_IGNORE_COVER|AMMO_SKIPS_ALIENS

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 6

/datum/ammo/grenade_container/on_hit_mob(mob/M,obj/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/on_hit_obj(obj/O,obj/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/on_hit_turf(turf/T,obj/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/do_at_max_range(obj/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/proc/drop_nade(obj/projectile/P)
	var/turf/T = get_turf(P)
	var/obj/item/explosive/grenade/G = new nade_type(T)
	G.visible_message(SPAN_WARNING("\A [G] lands on [T]!"))
	G.det_time = 10
	G.cause_data = P.weapon_cause_data
	G.activate()

/datum/ammo/grenade_container/rifle
	flags_ammo_behavior = NO_FLAGS

/datum/ammo/grenade_container/smoke
	name = "smoke grenade shell"
	nade_type = /obj/item/explosive/grenade/smokebomb
	icon_state = "smoke_shell"

/datum/ammo/grenade_container/tank_glauncher
	max_range = 8

/datum/ammo/hugger_container
	name = "hugger shell"
	ping = null
	damage_type = BRUTE
	var/hugger_hive = XENO_HIVE_NORMAL
	icon_state = "smoke_shell"

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 6

/datum/ammo/hugger_container/on_hit_mob(mob/M,obj/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/on_hit_obj(obj/O,obj/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/on_hit_turf(turf/T,obj/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/do_at_max_range(obj/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/proc/spawn_hugger(turf/T)
	var/obj/item/clothing/mask/facehugger/child = new(T)
	child.hivenumber = hugger_hive
	INVOKE_ASYNC(child, TYPE_PROC_REF(/obj/item/clothing/mask/facehugger, leap_at_nearest_target))
