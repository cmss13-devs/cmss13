/*
//======
					Pistol Ammo
//======
*/

// Used by M4A3, M4A3 Custom and B92FS
/datum/ammo/bullet/pistol
	name = "pistol bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	damage = 40
	penetration= ARMOR_PENETRATION_TIER_2
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pistol/tiny
	name = "light pistol bullet"

/datum/ammo/bullet/pistol/tranq
	name = "tranquilizer bullet"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	stamina_damage = 30
	damage = 15

//2020 rebalance: is supposed to counter runners and lurkers, dealing high damage to the only castes with no armor.
//Limited by its lack of versatility and lower supply, so marines finally have an answer for flanker castes that isn't just buckshot.

/datum/ammo/bullet/pistol/hollow
	name = "hollowpoint pistol bullet"

	damage = 55 //hollowpoint is strong
	penetration = 0 //hollowpoint can't pierce armor!
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_3 //hollowpoint causes shrapnel

// Used by M4A3 AP and mod88
/datum/ammo/bullet/pistol/ap
	name = "armor-piercing pistol bullet"

	damage = 25
	accuracy = HIT_ACCURACY_TIER_2
	penetration= ARMOR_PENETRATION_TIER_8
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pistol/ap/penetrating
	name = "wall-penetrating pistol bullet"
	shrapnel_chance = 0

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/pistol/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/pistol/ap/toxin
	name = "toxic pistol bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/pistol/ap/toxin/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/pistol/ap/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.turf_flags & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/ap/toxin/on_hit_obj(obj/O, obj/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/le
	name = "armor-shredding pistol bullet"

	damage = 15
	penetration = ARMOR_PENETRATION_TIER_4
	pen_armor_punch = 3

/datum/ammo/bullet/pistol/rubber
	name = "rubber pistol bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 25
	shrapnel_chance = 0

// Reskinned rubber bullet used for the ES-4 CL pistol.
/datum/ammo/bullet/pistol/rubber/stun
	name = "stun pistol bullet"
	sound_override = null

// Used by M1911, Deagle and KT-42
/datum/ammo/bullet/pistol/heavy
	name = "heavy pistol bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	damage = 55
	penetration = ARMOR_PENETRATION_TIER_3
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pistol/heavy/super //Commander's variant
	name = ".50 heavy pistol bullet"
	damage = 60
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/pistol/heavy/super/highimpact
	name = ".50 high-impact pistol bullet"
	penetration = ARMOR_PENETRATION_TIER_1
	debilitate = list(0,1.5,0,0,0,1,0,0)
	flags_ammo_behavior = AMMO_BALLISTIC

/datum/ammo/bullet/pistol/heavy/super/highimpact/ap
	name = ".50 high-impact armor piercing pistol bullet"
	penetration = ARMOR_PENETRATION_TIER_10
	damage = 45

/datum/ammo/bullet/pistol/heavy/super/highimpact/upp
	name = "high-impact pistol bullet"
	sound_override = 'sound/weapons/gun_DE50.ogg'
	penetration = ARMOR_PENETRATION_TIER_6
	debilitate = list(0,1.5,0,0,0,1,0,0)
	flags_ammo_behavior = AMMO_BALLISTIC

/datum/ammo/bullet/pistol/heavy/super/highimpact/New()
	..()
	RegisterSignal(src, COMSIG_AMMO_POINT_BLANK, PROC_REF(handle_battlefield_execution))

/datum/ammo/bullet/pistol/heavy/super/highimpact/on_hit_mob(mob/M, obj/projectile/P)
	knockback(M, P, 4)

/datum/ammo/bullet/pistol/deagle
	name = ".50 heavy pistol bullet"
	damage = 45
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_5

/datum/ammo/bullet/pistol/incendiary
	name = "incendiary pistol bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_3
	damage = 20

/datum/ammo/bullet/pistol/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

// Used by the hipower
// I know that the 'high power' in the name is supposed to mean its 'impressive' magazine capacity
// but this is CM, half our guns have baffling misconceptions and mistakes (how do you grab the type-71?) so it's on-brand.
// maybe in the far flung future of 2280 someone screwed up the design.

/datum/ammo/bullet/pistol/highpower
	name = "high-powered pistol bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = HIT_ACCURACY_TIER_3
	damage = 36
	penetration = ARMOR_PENETRATION_TIER_5
	damage_falloff = DAMAGE_FALLOFF_TIER_7

// Used by VP78 and Auto 9
/datum/ammo/bullet/pistol/squash
	name = "squash-head pistol bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	debilitate = list(0,0,0,0,0,0,0,2)

	effective_range_max = 3
	accuracy = HIT_ACCURACY_TIER_4
	damage = 45
	penetration= ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_6 //"VP78 - the only pistol viable as a primary."-Vampmare, probably.

/datum/ammo/bullet/pistol/squash/toxin
	name = "toxic squash-head pistol bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/pistol/squash/toxin/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/pistol/squash/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.turf_flags & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/squash/toxin/on_hit_obj(obj/O, obj/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/squash/penetrating
	name = "wall-penetrating squash-head pistol bullet"
	shrapnel_chance = 0
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/pistol/squash/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/pistol/squash/incendiary
	name = "incendiary squash-head pistol bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accuracy = HIT_ACCURACY_TIER_3
	damage = 35

/datum/ammo/bullet/pistol/squash/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))


/datum/ammo/bullet/pistol/mankey
	name = "live monkey"
	icon_state = "monkey1"
	ping = null //no bounce off.
	damage_type = BURN
	debilitate = list(4,4,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_IGNORE_ARMOR

	damage = 15
	damage_var_high = PROJECTILE_VARIANCE_TIER_5
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/bullet/pistol/mankey/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/pistol/mankey/on_hit_mob(mob/M,obj/projectile/P)
	if(P && P.loc && !M.stat && !istype(M,/mob/living/carbon/human/monkey))
		P.visible_message(SPAN_DANGER("The [src] chimpers furiously!"))
		new /mob/living/carbon/human/monkey(P.loc)

/datum/ammo/bullet/pistol/smart
	name = "smartpistol bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_8
	damage = 30
	penetration = 20
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

