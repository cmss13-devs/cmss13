/*
//======
					Revolver Ammo
//======
*/

/datum/ammo/bullet/revolver
	name = "revolver bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 72
	penetration = ARMOR_PENETRATION_TIER_1
	accuracy = HIT_ACCURACY_TIER_1

/datum/ammo/bullet/revolver/marksman
	name = "marksman revolver bullet"
	damage = 55
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	penetration = ARMOR_PENETRATION_TIER_7

/datum/ammo/bullet/revolver/heavy
	name = "heavy revolver bullet"

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_4
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/revolver/heavy/on_hit_mob(mob/entity, obj/projectile/bullet)
	slowdown(entity, bullet)
	pushback(entity, bullet, 4)

/datum/ammo/bullet/revolver/incendiary
	name = "incendiary revolver bullet"
	damage = 40

/datum/ammo/bullet/revolver/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/revolver/marksman/toxin
	name = "toxic revolver bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/status_effect/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.turf_flags & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_obj(obj/O, obj/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/revolver/penetrating
	name = "wall-penetrating revolver bullet"
	shrapnel_chance = 0

	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/revolver/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/revolver/upp
	name = "heavy revolver bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	penetration = ARMOR_PENETRATION_TIER_4
	damage = 70


/datum/ammo/bullet/revolver/upp/shrapnel
	name = "shrapnel shot"
	headshot_state = HEADSHOT_OVERLAY_HEAVY //Gol-dang shotgun blow your fething head off.
	debilitate = list(0,0,0,0,0,0,0,0)
	icon_state = "shrapnelshot"
	handful_state = "shrapnel"
	bonus_projectiles_type = /datum/ammo/bullet/revolver/upp/shrapnel_bits

	max_range = 6
	damage = 40 // + TIER_4 * 3
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	penetration = ARMOR_PENETRATION_TIER_8
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	shrapnel_chance = 100
	shrapnel_type = /obj/item/shard/shrapnel/upp
	//roughly 90 or so damage with the additional shrapnel, around 130 in total with primary round

/datum/ammo/bullet/revolver/upp/shrapnel/on_hit_mob(mob/M, obj/projectile/P)
	pushback(M, P, 1)

/datum/ammo/bullet/revolver/upp/shrapnel_bits
	name = "small shrapnel"
	icon_state = "shrapnelshot_bit"

	max_range = 6
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_4
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	shrapnel_type = /obj/item/shard/shrapnel/upp/bits

/datum/ammo/bullet/revolver/small
	name = "small revolver bullet"
	headshot_state = HEADSHOT_OVERLAY_LIGHT

	damage = 45

	penetration = ARMOR_PENETRATION_TIER_3

/datum/ammo/bullet/revolver/small/cmb
	damage = 60

/datum/ammo/bullet/revolver/small/hollowpoint
	name = "small hollowpoint revolver bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	damage = 75 // way too strong because it's hard to make a good balance between HP and normal with this system, but the damage falloff is really strong
	penetration = 0
	damage_falloff = DAMAGE_FALLOFF_TIER_6

/datum/ammo/bullet/revolver/mateba
	name = ".454 heavy revolver bullet"

	damage = 60
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/revolver/mateba/highimpact
	name = ".454 heavy high-impact revolver bullet"
	debilitate = list(0,2,0,0,0,1,0,0)
	penetration = ARMOR_PENETRATION_TIER_1
	flags_ammo_behavior = AMMO_BALLISTIC

/datum/ammo/bullet/revolver/mateba/highimpact/ap
	name = ".454 heavy high-impact armor piercing revolver bullet"
	penetration = ARMOR_PENETRATION_TIER_10
	damage = 45

/datum/ammo/bullet/revolver/mateba/highimpact/New()
	..()
	RegisterSignal(src, COMSIG_AMMO_POINT_BLANK, PROC_REF(handle_battlefield_execution))

/datum/ammo/bullet/revolver/mateba/highimpact/on_hit_mob(mob/M, obj/projectile/P)
	knockback(M, P, 4)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive //if you ever put this in normal gameplay, i am going to scream
	name = ".454 heavy explosive revolver bullet"
	damage = 100
	damage_var_low = PROJECTILE_VARIANCE_TIER_10
	damage_var_high = PROJECTILE_VARIANCE_TIER_1
	penetration = ARMOR_PENETRATION_TIER_10
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_BALLISTIC

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_mob(mob/M, obj/projectile/P)
	..()
	cell_explosion(get_turf(M), 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_obj(obj/O, obj/projectile/P)
	..()
	cell_explosion(get_turf(O), 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_turf(turf/T, obj/projectile/P)
	..()
	cell_explosion(T, 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/webley //Mateba round without the knockdown.
	name = ".455 Webley bullet"
	damage = 60
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_2
