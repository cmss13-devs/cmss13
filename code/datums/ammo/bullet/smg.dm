/*
//======
					SMG Ammo
//======
*/
//2020 SMG/ammo rebalance. default ammo actually has penetration so it can be useful, by 4khan: should be meh against t3s, better under 15 armor. Perfectly does this right now (oct 2020)
//has reduced falloff compared to the m39. this means it is best for kiting castes (mostly t2s and below admittedly)
//while the m39 ap is better for shredding them at close range, but has reduced velocity, so it's better for just running in and erasing armor-centric castes (defender, crusher)
// which i think is really interesting and good balance, giving both ammo types a reason to exist even against ravagers.
//i feel it is necessary to reflavor the default bullet, because otherwise, people won't be able to notice it has less falloff and faster bullet speed. even with a changelog,
//way too many people don't read the changelog, and after one or two months the changelog entry is all but archive, so there needs to be an ingame description of what the ammo does
//in comparison to armor-piercing rounds.

/datum/ammo/bullet/smg
	name = "submachinegun bullet"
	damage = 34
	accurate_range = 4
	effective_range_max = 4
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = DAMAGE_FALLOFF_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/smg/m39
	name = "high-velocity submachinegun bullet" //i don't want all smgs to inherit 'high velocity'

/datum/ammo/bullet/smg/ap
	name = "armor-piercing submachinegun bullet"

	damage = 26
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/smg/heap
	name = "high-explosive armor-piercing submachinegun bullet"

	damage = 45
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/smg/ap/toxin
	name = "toxic submachinegun bullet"
	var/acid_per_hit = 5
	var/organic_damage_mult = 3

/datum/ammo/bullet/smg/ap/toxin/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/status_effect/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/smg/ap/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.turf_flags & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/smg/ap/toxin/on_hit_obj(obj/O, obj/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/smg/nail
	name = "7x45mm plasteel nail"
	icon_state = "nail-projectile"

	damage = 25
	penetration = ARMOR_PENETRATION_TIER_5
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	accurate_range = 5
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/smg/incendiary
	name = "incendiary submachinegun bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 25
	accuracy = -HIT_ACCURACY_TIER_2

/datum/ammo/bullet/smg/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/smg/ap/penetrating
	name = "wall-penetrating submachinegun bullet"
	shrapnel_chance = 0

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/smg/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/smg/le
	name = "armor-shredding submachinegun bullet"

	scatter = SCATTER_AMOUNT_TIER_10
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4
	shell_speed = AMMO_SPEED_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_10
	pen_armor_punch = 4

/datum/ammo/bullet/smg/rubber
	name = "rubber submachinegun bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 10
	shrapnel_chance = 0

/datum/ammo/bullet/smg/mp27
	name = "simple submachinegun bullet"
	damage = 40
	accurate_range = 5
	effective_range_max = 7
	penetration = 0
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
	accuracy = HIT_ACCURACY_TIER_2

// less damage than the m39, but better falloff, range, and AP

/datum/ammo/bullet/smg/ppsh
	name = "crude submachinegun bullet"
	damage = 26
	accurate_range = 7
	effective_range_max = 7
	penetration = ARMOR_PENETRATION_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	scatter = SCATTER_AMOUNT_TIER_5

/datum/ammo/bullet/smg/pps43
	name = "simple submachinegun bullet"
	damage = 35
	accurate_range = 7
	effective_range_max = 10
	penetration = ARMOR_PENETRATION_TIER_4
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6

/datum/ammo/bullet/smg/p90
	name = "submachinegun bullet"

	damage = 22
	accurate_range = 5
	effective_range_max = 8
	penetration = ARMOR_PENETRATION_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6

/datum/ammo/bullet/smg/p90/twe_ap
	name = "armor-piercing submachinegun bullet"

	damage = 26
	accurate_range = 5
	effective_range_max = 8
	penetration = ARMOR_PENETRATION_TIER_4
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
