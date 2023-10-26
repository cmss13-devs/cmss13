/*
//======
					Sniper Ammo
//======
*/

/datum/ammo/bullet/sniper
	name = "sniper bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 70
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/on_hit_mob(mob/M,obj/projectile/P)
	if((P.projectile_flags & PROJECTILE_BULLSEYE) && M == P.original)
		var/mob/living/L = M
		L.apply_armoured_damage(damage*2, ARMOR_BULLET, BRUTE, null, penetration)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/incendiary
	name = "incendiary sniper bullet"
	damage_type = BRUTE
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER

	//Removed accuracy = 0, accuracy_var_high = Variance Tier 6, and scatter = 0. -Kaga
	damage = 60
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/sniper/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/sniper/incendiary/on_hit_mob(mob/M,obj/projectile/P)
	if((P.projectile_flags & PROJECTILE_BULLSEYE) && M == P.original)
		var/mob/living/L = M
		var/blind_duration = 5
		if(isxeno(M))
			var/mob/living/carbon/xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_BIG)
				blind_duration = 2
		L.AdjustEyeBlur(blind_duration)
		L.adjust_fire_stacks(10)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/flak
	name = "flak sniper bullet"
	damage_type = BRUTE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER

	accuracy = HIT_ACCURACY_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	damage = 55
	damage_var_high = PROJECTILE_VARIANCE_TIER_8 //Documenting old code: This converts to a variance of 96-109% damage. -Kaga
	penetration = 0

/datum/ammo/bullet/sniper/flak/on_hit_mob(mob/M,obj/projectile/P)
	if((P.projectile_flags & PROJECTILE_BULLSEYE) && M == P.original)
		var/slow_duration = 7
		var/mob/living/L = M
		if(isxeno(M))
			var/mob/living/carbon/xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_BIG)
				slow_duration = 4
		M.adjust_effect(slow_duration, SUPERSLOW)
		L.apply_armoured_damage(damage, ARMOR_BULLET, BRUTE, null, penetration)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))
	else
		burst(get_turf(M),P,damage_type, 2 , 2)
		burst(get_turf(M),P,damage_type, 1 , 2 , 0)

/datum/ammo/bullet/sniper/flak/on_near_target(turf/T, obj/projectile/P)
	burst(T,P,damage_type, 2 , 2)
	burst(T,P,damage_type, 1 , 2, 0)
	return 1

/datum/ammo/bullet/sniper/crude
	name = "crude sniper bullet"
	damage = 42
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/sniper/crude/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	pushback(M, P, 3)

/datum/ammo/bullet/sniper/upp
	name = "armor-piercing sniper bullet"
	damage = 80
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/sniper/anti_materiel
	name = "anti-materiel sniper bullet"

	shrapnel_chance = 0 // This isn't leaving any shrapnel.
	accuracy = HIT_ACCURACY_TIER_8
	damage = 125
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/sniper/anti_materiel/on_hit_mob(mob/M,obj/projectile/P)
	if((P.projectile_flags & PROJECTILE_BULLSEYE) && M == P.original)
		var/mob/living/L = M
		var/size_damage_mod = 0.8
		if(isxeno(M))
			var/mob/living/carbon/xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_XENO)
				size_damage_mod += 0.6
			if(target.mob_size >= MOB_SIZE_BIG)
				size_damage_mod += 0.6
		L.apply_armoured_damage(damage*size_damage_mod, ARMOR_BULLET, BRUTE, null, penetration)
		// 180% damage to all targets (225), 240% (300) against non-Runner xenos, and 300% against Big xenos (375). -Kaga
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/anti_materiel/vulture
	damage = 400 // Fully intended to vaporize anything smaller than a mini cooper
	accurate_range_min = 10
	handful_state = "vulture_bullet"
	sound_hit = 'sound/bullets/bullet_vulture_impact.ogg'
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER|AMMO_ANTIVEHICLE

/datum/ammo/bullet/sniper/anti_materiel/vulture/on_hit_mob(mob/hit_mob, obj/projectile/bullet)
	. = ..()
	knockback(hit_mob, bullet, 30)
	hit_mob.apply_effect(3, SLOW)

/datum/ammo/bullet/sniper/anti_materiel/vulture/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating/heavy)
	))

/datum/ammo/bullet/sniper/elite
	name = "supersonic sniper bullet"

	shrapnel_chance = 0 // This isn't leaving any shrapnel.
	accuracy = HIT_ACCURACY_TIER_8
	damage = 150
	shell_speed = AMMO_SPEED_TIER_6 + AMMO_SPEED_TIER_2

/datum/ammo/bullet/sniper/elite/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/sniper/elite/on_hit_mob(mob/M,obj/projectile/P)
	if((P.projectile_flags & PROJECTILE_BULLSEYE) && M == P.original)
		var/mob/living/L = M
		var/size_damage_mod = 0.5
		if(isxeno(M))
			var/mob/living/carbon/xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_XENO)
				size_damage_mod += 0.5
			if(target.mob_size >= MOB_SIZE_BIG)
				size_damage_mod += 1
			L.apply_armoured_damage(damage*size_damage_mod, ARMOR_BULLET, BRUTE, null, penetration)
		else
			L.apply_armoured_damage(damage, ARMOR_BULLET, BRUTE, null, penetration)
		// 150% damage to runners (225), 300% against Big xenos (450), and 200% against all others (300). -Kaga
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))
