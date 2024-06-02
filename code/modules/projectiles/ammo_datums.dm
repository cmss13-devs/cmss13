
/*
//========
					SHARP Dart Ammo
//========
*/
/datum/ammo/rifle/sharp
	name = "dart"
	ping = null //no bounce off.
	damage_type = BRUTE
	shrapnel_type = /obj/item/sharp
	flags_ammo_behavior = AMMO_SPECIAL_EMBED|AMMO_NO_DEFLECT|AMMO_STRIKES_SURFACE_ONLY|AMMO_HITS_TARGET_TURF
	icon_state = "sonicharpoon"
	var/embed_object = /obj/item/sharp/explosive

	shrapnel_chance = 100
	accuracy = HIT_ACCURACY_TIER_MAX
	accurate_range = 12
	max_range = 7
	damage = 35
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/rifle/sharp/on_embed(var/mob/embedded_mob, var/obj/limb/target_organ)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/humano = embedded_mob
	if(humano.species.flags & NO_SHRAPNEL)
		return
	if(istype(target_organ))
		target_organ.embed(new embed_object)

/datum/ammo/rifle/sharp/on_hit_obj(obj/O, obj/item/projectile/P)
	drop_dart(P.loc, P)

/datum/ammo/rifle/sharp/on_hit_turf(turf/T, obj/item/projectile/P)
	drop_dart(T, P)

/datum/ammo/rifle/sharp/do_at_max_range(obj/item/projectile/P)
	drop_dart(P.loc, P)

/datum/ammo/rifle/sharp/proc/drop_dart(var/loc, obj/item/projectile/P)
	new embed_object(loc, P.dir)

/datum/ammo/rifle/sharp/explosive
	name = "9X-E sticky explosive dart"

/datum/ammo/rifle/sharp/explosive/on_hit_mob(mob/living/M, obj/item/projectile/P)
	if(!M || M == P.firer) return
	var/mob/shooter = P.firer
	shake_camera(M, 2, 1)
	if(shooter && ismob(shooter))
		if(!M.get_target_lock(shooter.faction_group))
			var/obj/item/weapon/gun/rifle/sharp/weapon = P.shot_from
			if(weapon && weapon.explosion_delay_sharp)
				addtimer(CALLBACK(src, PROC_REF(delayed_explosion), P, M, shooter), 5 SECONDS)
			else
				addtimer(CALLBACK(src, PROC_REF(delayed_explosion), P, M, shooter), 1 SECONDS)

/datum/ammo/rifle/sharp/explosive/drop_dart(var/loc, obj/item/projectile/P, var/mob/shooter)
	var/signal_explosion = FALSE
	if(locate(/obj/item/explosive/mine) in get_turf(loc))
		signal_explosion = TRUE
	var/obj/item/explosive/mine/sharp/dart = new /obj/item/explosive/mine/sharp(loc)
	// if no darts on tile, don't arm, explode instead.
	if(signal_explosion)
		INVOKE_ASYNC(dart, TYPE_PROC_REF(/obj/item/explosive/mine/sharp, prime), shooter)
	else
		dart.anchored = TRUE
		addtimer(CALLBACK(dart, TYPE_PROC_REF(/obj/item/explosive/mine/sharp, deploy_mine), shooter), 3 SECONDS, TIMER_DELETE_ME)
		addtimer(CALLBACK(dart, TYPE_PROC_REF(/obj/item/explosive/mine/sharp, disarm)), 1 MINUTES, TIMER_DELETE_ME)

/datum/ammo/rifle/sharp/explosive/proc/delayed_explosion(obj/item/projectile/P, mob/M, mob/shooter)
	if(ismob(M))
		var/explosion_size = 100
		var/falloff_size = 50
		var/cause_data = create_cause_data("P9 SHARP Rifle", shooter)
		cell_explosion(get_turf(M), explosion_size, falloff_size, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, cause_data)
		playsound(get_turf(M), 'sound/weapons/gun_sharp_explode.ogg', 45)

/datum/ammo/rifle/sharp/track
	name = "9X-T sticky tracker dart"
	icon_state = "sonicharpoon_tracker"
	embed_object = /obj/item/sharp/track
	var/tracker_timer = 1 MINUTES

/datum/ammo/rifle/sharp/track/on_hit_mob(mob/living/M, obj/item/projectile/P)
	if(!M || M == P.firer) return
	shake_camera(M, 2, 1)
	var/obj/item/weapon/gun/rifle/sharp/weapon = P.shot_from
	if(weapon)
		weapon.sharp_tracked_mob_list |= M
	addtimer(CALLBACK(src, PROC_REF(remove_tracker), M, P), tracker_timer)

/datum/ammo/rifle/sharp/track/proc/remove_tracker(mob/living/M, obj/item/projectile/P)
	var/obj/item/weapon/gun/rifle/sharp/weapon = P.shot_from
	if(weapon)
		weapon.sharp_tracked_mob_list -= M

/datum/ammo/rifle/sharp/flechette
	name = "9X-F flechette dart"
	icon_state = "sonicharpoon_flechette"
	embed_object = /obj/item/sharp/flechette
	shrapnel_type = /datum/ammo/bullet/shotgun/flechette_spread

/datum/ammo/rifle/sharp/flechette/on_hit_mob(mob/living/M, obj/item/projectile/P)
	if(!M || M == P.firer) return
	var/mob/shooter = P.firer
	shake_camera(M, 2, 1)
	if(shooter && ismob(shooter))
		if(!M.get_target_lock(shooter.faction_group))
			create_flechette(M.loc, P)

/datum/ammo/rifle/sharp/flechette/on_pointblank(mob/living/M, obj/item/projectile/P)
	if(!M) return
	P.dir = get_dir(P.firer, M)

/datum/ammo/rifle/sharp/flechette/on_hit_obj(obj/O, obj/item/projectile/P)
	create_flechette(O.loc, P)

/datum/ammo/rifle/sharp/flechette/on_hit_turf(turf/T, obj/item/projectile/P)
	create_flechette(T, P)

/datum/ammo/rifle/sharp/flechette/do_at_max_range(obj/item/projectile/P)
	create_flechette(P.loc, P)

/datum/ammo/rifle/sharp/flechette/proc/create_flechette(var/loc, obj/item/projectile/P)
	var/shrapnel_count = 10
	var/direct_hit_shrapnel = 5
	var/dispersion_angle = 20
	create_shrapnel(loc, min(direct_hit_shrapnel, shrapnel_count), P.dir, dispersion_angle, shrapnel_type, P.weapon_cause_data, FALSE, 100)
	shrapnel_count -= direct_hit_shrapnel
	if(shrapnel_count)
		create_shrapnel(loc, shrapnel_count, P.dir, dispersion_angle ,shrapnel_type, P.weapon_cause_data, FALSE, 0)
	apply_explosion_overlay(loc)

/datum/ammo/rifle/sharp/flechette/proc/apply_explosion_overlay(var/turf/loc)
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)
