/*
//======
					Tank Ammo
//======
*/

//Autocannon Ammo//

/datum/ammo/bullet/tank/flak
	name = "flak autocannon bullet"
	icon_state = "autocannon"
	sound_hit  = 'sound/weapons/sting_boom_small1.ogg'
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 60
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_6
	accurate_range = 32
	max_range = 32
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/tank/flak/on_hit_mob(mob/M,obj/projectile/P)
	burst(get_turf(M),P,damage_type, 2 , 3)
	burst(get_turf(M),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/flak/on_near_target(turf/T, obj/projectile/P)
	burst(get_turf(T),P,damage_type, 2 , 3)
	burst(get_turf(T),P,damage_type, 1 , 3, 0)
	return 1

/datum/ammo/bullet/tank/flak/on_hit_obj(obj/O,obj/projectile/P)
	burst(get_turf(P),P,damage_type, 2 , 3)
	burst(get_turf(P),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/flak/on_hit_turf(turf/T,obj/projectile/P)
	burst(get_turf(T),P,damage_type, 2 , 3)
	burst(get_turf(T),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/dualcannon
	name = "dualcannon bullet"
	icon_state = "autocannon"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 50
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 10
	max_range = 12
	shell_speed = AMMO_SPEED_TIER_5

/datum/ammo/bullet/tank/dualcannon/on_hit_mob(mob/M,obj/projectile/P)
	for(var/mob/living/carbon/L in get_turf(M))
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

/datum/ammo/bullet/tank/dualcannon/on_near_target(turf/T, obj/projectile/P)
	for(var/mob/living/carbon/L in T)
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)
	return 1

/datum/ammo/bullet/tank/dualcannon/on_hit_obj(obj/O,obj/projectile/P)
	for(var/mob/living/carbon/L in get_turf(O))
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

/datum/ammo/bullet/tank/dualcannon/on_hit_turf(turf/T,obj/projectile/P)
	for(var/mob/living/carbon/L in T)
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

//Minigun Ammo//

/datum/ammo/bullet/tank/minigun
	name = "minigun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	icon_state = "bullet_large"

	accuracy = -HIT_ACCURACY_TIER_1
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_8
	accurate_range = 12
	damage = 40
	penetration = ARMOR_PENETRATION_TIER_6
	damage_armor_punch = 1

/datum/ammo/bullet/tank/setup_faction_clash_values()
	. = ..()
	damage = 15
