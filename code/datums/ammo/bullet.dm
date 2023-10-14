/*
//======
					Default Ammo
//======
*/
//Only when things screw up do we use this as a placeholder.
/datum/ammo/bullet
	name = "default bullet"
	icon_state = "bullet"
	headshot_state = HEADSHOT_OVERLAY_LIGHT
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit  = "ballistic_hit"
	sound_armor  = "ballistic_armor"
	sound_miss  = "ballistic_miss"
	sound_bounce = "ballistic_bounce"
	sound_shield_hit = "ballistic_shield_hit"

	accurate_range_min = 0
	damage = 10
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_1
	shrapnel_type = /obj/item/shard/shrapnel
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/proc/handle_battlefield_execution(datum/ammo/firing_ammo, mob/living/hit_mob, obj/projectile/firing_projectile, mob/living/user, obj/item/weapon/gun/fired_from)
	SIGNAL_HANDLER

	if(!user || hit_mob == user || user.zone_selected != "head" || user.a_intent != INTENT_HARM || !ishuman_strict(hit_mob))
		return

	if(!skillcheck(user, SKILL_EXECUTION, SKILL_EXECUTION_TRAINED))
		to_chat(user, SPAN_DANGER("You don't know how to execute someone correctly."))
		return

	var/mob/living/carbon/human/execution_target = hit_mob

	if(execution_target.status_flags & PERMANENTLY_DEAD)
		to_chat(user, SPAN_DANGER("[execution_target] has already been executed!"))
		return

	INVOKE_ASYNC(src, PROC_REF(attempt_battlefield_execution), src, execution_target, firing_projectile, user, fired_from)

	return COMPONENT_CANCEL_AMMO_POINT_BLANK

/datum/ammo/bullet/proc/attempt_battlefield_execution(datum/ammo/firing_ammo, mob/living/carbon/human/execution_target, obj/projectile/firing_projectile, mob/living/user, obj/item/weapon/gun/fired_from)
	user.affected_message(execution_target,
		SPAN_HIGHDANGER("You aim \the [fired_from] at [execution_target]'s head!"),
		SPAN_HIGHDANGER("[user] aims \the [fired_from] directly at your head!"),
		SPAN_DANGER("[user] aims \the [fired_from] at [execution_target]'s head!"))

	user.next_move += 1.1 SECONDS //PB has no click delay; readding it here to prevent people accidentally queuing up multiple executions.

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || !user.Adjacent(execution_target))
		fired_from.delete_bullet(firing_projectile, TRUE)
		return

	if(!(fired_from.flags_gun_features & GUN_SILENCED))
		playsound(user, fired_from.fire_sound, fired_from.firesound_volume, FALSE)
	else
		playsound(user, fired_from.fire_sound, 25, FALSE)

	shake_camera(user, 1, 2)

	execution_target.apply_damage(damage * 3, BRUTE, "head", no_limb_loss = TRUE, permanent_kill = TRUE) //Apply gobs of damage and make sure they can't be revived later...
	execution_target.apply_damage(200, OXY) //...fill out the rest of their health bar with oxyloss...
	execution_target.death(create_cause_data("execution", user)) //...make certain they're properly dead...
	shake_camera(execution_target, 3, 4)
	execution_target.update_headshot_overlay(headshot_state) //...and add a gory headshot overlay.

	execution_target.visible_message(SPAN_HIGHDANGER(uppertext("[execution_target] WAS EXECUTED!")), \
		SPAN_HIGHDANGER("You WERE EXECUTED!"))

	user.count_niche_stat(STATISTICS_NICHE_EXECUTION, 1, firing_projectile.weapon_cause_data?.cause_name)

	var/area/execution_area = get_area(execution_target)

	msg_admin_attack(FONT_SIZE_HUGE("[key_name(usr)] has battlefield executed [key_name(execution_target)] in [get_area(usr)] ([usr.loc.x],[usr.loc.y],[usr.loc.z])."), usr.loc.x, usr.loc.y, usr.loc.z)
	log_attack("[key_name(usr)] battlefield executed [key_name(execution_target)] at [execution_area.name].")

	if(flags_ammo_behavior & AMMO_EXPLOSIVE)
		execution_target.gib()


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
	if(T.flags_turf & TURF_ORGANIC)
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
	if(T.flags_turf & TURF_ORGANIC)
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

/*
//======
					Revolver Ammo
//======
*/

/datum/ammo/bullet/revolver
	name = "revolver bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	damage = 55
	penetration = ARMOR_PENETRATION_TIER_1
	accuracy = HIT_ACCURACY_TIER_1

/datum/ammo/bullet/revolver/marksman
	name = "marksman revolver bullet"

	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	penetration = ARMOR_PENETRATION_TIER_7

/datum/ammo/bullet/revolver/heavy
	name = "heavy revolver bullet"

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_4
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/revolver/heavy/on_hit_mob(mob/M, obj/projectile/P)
	knockback(M, P, 4)

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
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
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
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/smg/ap/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
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

/*
//======
					Rifle Ammo
//======
*/

/datum/ammo/bullet/rifle
	name = "rifle bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	damage = 40
	penetration = ARMOR_PENETRATION_TIER_1
	accurate_range = 16
	accuracy = HIT_ACCURACY_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 24 //So S8 users don't have their bullets magically disappaer at 22 tiles (S8 can see 24 tiles)

/datum/ammo/bullet/rifle/holo_target
	name = "holo-targeting rifle bullet"
	damage = 30
	var/holo_stacks = 10

/datum/ammo/bullet/rifle/holo_target/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/bonus_damage_stack, holo_stacks, world.time)

/datum/ammo/bullet/rifle/holo_target/hunting
	name = "holo-targeting hunting bullet"
	damage = 25
	holo_stacks = 15

/datum/ammo/bullet/rifle/explosive
	name = "explosive rifle bullet"

	damage = 25
	accurate_range = 22
	accuracy = 0
	shell_speed = AMMO_SPEED_TIER_4
	damage_falloff = DAMAGE_FALLOFF_TIER_9

/datum/ammo/bullet/rifle/explosive/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(get_turf(M), 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/explosive/on_hit_obj(obj/O, obj/projectile/P)
	cell_explosion(get_turf(O), 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/explosive/on_hit_turf(turf/T, obj/projectile/P)
	if(T.density)
		cell_explosion(T, 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/ap
	name = "armor-piercing rifle bullet"

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_8

// Basically AP but better. Focused at taking out armour temporarily
/datum/ammo/bullet/rifle/ap/toxin
	name = "toxic rifle bullet"
	var/acid_per_hit = 7
	var/organic_damage_mult = 3

/datum/ammo/bullet/rifle/ap/toxin/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/rifle/ap/toxin/on_hit_turf(turf/T, obj/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/rifle/ap/toxin/on_hit_obj(obj/O, obj/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult


/datum/ammo/bullet/rifle/ap/penetrating
	name = "wall-penetrating rifle bullet"
	shrapnel_chance = 0

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/rifle/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/rifle/le
	name = "armor-shredding rifle bullet"

	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4
	pen_armor_punch = 5

/datum/ammo/bullet/rifle/heap
	name = "high-explosive armor-piercing rifle bullet"

	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 55//big damage, doesn't actually blow up because thats stupid.
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/rifle/rubber
	name = "rubber rifle bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 15
	shrapnel_chance = 0

/datum/ammo/bullet/rifle/incendiary
	name = "incendiary rifle bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 30
	shell_speed = AMMO_SPEED_TIER_4
	accuracy = -HIT_ACCURACY_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_10

/datum/ammo/bullet/rifle/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/rifle/m4ra
	name = "A19 high velocity bullet"
	shrapnel_chance = 0
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4

	damage = 55
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration= ARMOR_PENETRATION_TIER_7
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/incendiary
	name = "A19 high velocity incendiary bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 40
	accuracy = HIT_ACCURACY_TIER_4
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration= ARMOR_PENETRATION_TIER_5
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/rifle/m4ra/impact
	name = "A19 high velocity impact bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 40
	accuracy = -HIT_ACCURACY_TIER_2
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration = ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/impact/on_hit_mob(mob/M, obj/projectile/P)
	knockback(M, P, 32) // Can knockback basically at max range

/datum/ammo/bullet/rifle/m4ra/impact/knockback_effects(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		to_chat(target, SPAN_XENODANGER("You are shaken and slowed by the sudden impact!"))
		target.apply_effect(0.5, WEAKEN)
		target.apply_effect(2, SUPERSLOW)
		target.apply_effect(5, SLOW)
	else
		if(!isyautja(living_mob)) //Not predators.
			living_mob.apply_effect(1, SUPERSLOW)
			living_mob.apply_effect(2, SLOW)
			to_chat(living_mob, SPAN_HIGHDANGER("The impact knocks you off-balance!"))
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/bullet/rifle/mar40
	name = "heavy rifle bullet"

	damage = 55

/datum/ammo/bullet/rifle/type71
	name = "heavy rifle bullet"

	damage = 55
	penetration = ARMOR_PENETRATION_TIER_3

/datum/ammo/bullet/rifle/type71/ap
	name = "heavy armor-piercing rifle bullet"

	damage = 40
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/rifle/type71/heap
	name = "heavy high-explosive armor-piercing rifle bullet"

	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 65
	penetration = ARMOR_PENETRATION_TIER_10

/*
//======
					Shotgun Ammo
//======
*/

/datum/ammo/bullet/shotgun
	headshot_state = HEADSHOT_OVERLAY_HEAVY

/datum/ammo/bullet/shotgun/slug
	name = "shotgun slug"
	handful_state = "slug_shell"

	accurate_range = 6
	max_range = 8
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_4
	damage_armor_punch = 2
	handful_state = "slug_shell"

/datum/ammo/bullet/shotgun/slug/on_hit_mob(mob/M,obj/projectile/P)
	knockback(M, P, 6)

/datum/ammo/bullet/shotgun/slug/knockback_effects(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		to_chat(target, SPAN_XENODANGER("You are shaken and slowed by the sudden impact!"))
		target.apply_effect(0.5, WEAKEN)
		target.apply_effect(1, SUPERSLOW)
		target.apply_effect(3, SLOW)
	else
		if(!isyautja(living_mob)) //Not predators.
			living_mob.apply_effect(1, SUPERSLOW)
			living_mob.apply_effect(2, SLOW)
			to_chat(living_mob, SPAN_HIGHDANGER("The impact knocks you off-balance!"))
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/bullet/shotgun/beanbag
	name = "beanbag slug"
	headshot_state = HEADSHOT_OVERLAY_LIGHT //It's not meant to kill people... but if you put it in your mouth, it will.
	handful_state = "beanbag_slug"
	icon_state = "beanbag"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	sound_override = 'sound/weapons/gun_shotgun_riot.ogg'

	max_range = 12
	shrapnel_chance = 0
	damage = 0
	stamina_damage = 45
	accuracy = HIT_ACCURACY_TIER_3
	shell_speed = AMMO_SPEED_TIER_3
	handful_state = "beanbag_slug"

/datum/ammo/bullet/shotgun/beanbag/on_hit_mob(mob/M, obj/projectile/P)
	if(!M || M == P.firer) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		shake_camera(H, 2, 1)


/datum/ammo/bullet/shotgun/incendiary
	name = "incendiary slug"
	handful_state = "incendiary_slug"
	damage_type = BURN
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = -HIT_ACCURACY_TIER_2
	max_range = 12
	damage = 55
	penetration= ARMOR_PENETRATION_TIER_1
	handful_state = "incendiary_slug"

/datum/ammo/bullet/shotgun/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/incendiary/on_hit_mob(mob/M,obj/projectile/P)
	burst(get_turf(M),P,damage_type)
	knockback(M,P)

/datum/ammo/bullet/shotgun/incendiary/on_hit_obj(obj/O,obj/projectile/P)
	burst(get_turf(P),P,damage_type)

/datum/ammo/bullet/shotgun/incendiary/on_hit_turf(turf/T,obj/projectile/P)
	burst(get_turf(T),P,damage_type)


/datum/ammo/bullet/shotgun/flechette
	name = "flechette shell"
	icon_state = "flechette"
	handful_state = "flechette_shell"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/flechette_spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 30
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_7
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	handful_state = "flechette_shell"
	multiple_handful_name = TRUE

/datum/ammo/bullet/shotgun/flechette_spread
	name = "additional flechette"
	icon_state = "flechette"

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 30
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_7
	scatter = SCATTER_AMOUNT_TIER_5

/datum/ammo/bullet/shotgun/buckshot
	name = "buckshot shell"
	icon_state = "buckshot"
	handful_state = "buckshot_shell"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_5
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_5
	accurate_range = 4
	max_range = 4
	damage = 65
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_1
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	shell_speed = AMMO_SPEED_TIER_2
	damage_armor_punch = 0
	pen_armor_punch = 0
	handful_state = "buckshot_shell"
	multiple_handful_name = TRUE

/datum/ammo/bullet/shotgun/buckshot/incendiary
	name = "incendiary buckshot shell"
	handful_state = "incen_buckshot"
	handful_type = /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary

/datum/ammo/bullet/shotgun/buckshot/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/buckshot/on_hit_mob(mob/M,obj/projectile/P)
	knockback(M,P)

//buckshot variant only used by the masterkey shotgun attachment.
/datum/ammo/bullet/shotgun/buckshot/masterkey
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread/masterkey

	damage = 55

/datum/ammo/bullet/shotgun/spread
	name = "additional buckshot"
	icon_state = "buckshot"

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 4
	max_range = 6
	damage = 65
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_2
	scatter = SCATTER_AMOUNT_TIER_1
	damage_armor_punch = 0
	pen_armor_punch = 0

/datum/ammo/bullet/shotgun/spread/masterkey
	damage = 20

/*
					8 GAUGE SHOTGUN AMMO
*/

/datum/ammo/bullet/shotgun/heavy/buckshot
	name = "heavy buckshot shell"
	icon_state = "buckshot"
	handful_state = "heavy_buckshot"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/buckshot/spread
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	accurate_range = 3
	max_range = 3
	damage = 75
	penetration = 0
	shell_speed = AMMO_SPEED_TIER_2
	damage_armor_punch = 0
	pen_armor_punch = 0

/datum/ammo/bullet/shotgun/heavy/buckshot/on_hit_mob(mob/M,obj/projectile/P)
	knockback(M,P)

/datum/ammo/bullet/shotgun/heavy/buckshot/spread
	name = "additional heavy buckshot"
	max_range = 4
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0

//basically the same
/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath
	name = "dragon's breath shell"
	handful_state = "heavy_dragonsbreath"
	multiple_handful_name = TRUE
	damage_type = BURN
	damage = 60
	accurate_range = 3
	max_range = 4
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/spread

/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/spread
	name = "additional dragon's breath"
	bonus_projectiles_amount = 0
	accurate_range = 4
	max_range = 5 //make use of the ablaze property
	shell_speed = AMMO_SPEED_TIER_4 // so they hit before the main shell stuns


/datum/ammo/bullet/shotgun/heavy/slug
	name = "heavy shotgun slug"
	handful_state = "heavy_slug"

	accurate_range = 7
	max_range = 8
	damage = 90 //ouch.
	penetration = ARMOR_PENETRATION_TIER_6
	damage_armor_punch = 2

/datum/ammo/bullet/shotgun/heavy/slug/on_hit_mob(mob/M,obj/projectile/P)
	knockback(M, P, 7)

/datum/ammo/bullet/shotgun/heavy/slug/knockback_effects(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		to_chat(target, SPAN_XENODANGER("You are shaken and slowed by the sudden impact!"))
		target.apply_effect(0.5, WEAKEN)
		target.apply_effect(2, SUPERSLOW)
		target.apply_effect(5, SLOW)
	else
		if(!isyautja(living_mob)) //Not predators.
			living_mob.apply_effect(1, SUPERSLOW)
			living_mob.apply_effect(2, SLOW)
			to_chat(living_mob, SPAN_HIGHDANGER("The impact knocks you off-balance!"))
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/bullet/shotgun/heavy/beanbag
	name = "heavy beanbag slug"
	icon_state = "beanbag"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	handful_state = "heavy_beanbag"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	sound_override = 'sound/weapons/gun_shotgun_riot.ogg'

	max_range = 7
	shrapnel_chance = 0
	damage = 0
	stamina_damage = 100
	accuracy = HIT_ACCURACY_TIER_2
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/bullet/shotgun/heavy/beanbag/on_hit_mob(mob/M, obj/projectile/P)
	if(!M || M == P.firer)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		shake_camera(H, 2, 1)

/datum/ammo/bullet/shotgun/heavy/flechette
	name = "heavy flechette shell"
	icon_state = "flechette"
	handful_state = "heavy_flechette"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/flechette_spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_3
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_3
	max_range = 12
	damage = 45
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_10
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_2

/datum/ammo/bullet/shotgun/heavy/flechette_spread
	name = "additional heavy flechette"
	icon_state = "flechette"
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 45
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_10
	scatter = SCATTER_AMOUNT_TIER_4

//Enormous shell for Van Bandolier's superheavy double-barreled hunting gun.
/datum/ammo/bullet/shotgun/twobore
	name = "two bore bullet"
	icon_state = "autocannon"
	handful_state = "twobore"

	accurate_range = 8 //Big low-velocity projectile; this is for blasting dangerous game at close range.
	max_range = 14 //At this range, it's lost all its damage anyway.
	damage = 300 //Hits like a buckshot PB.
	penetration = ARMOR_PENETRATION_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_1 * 3 //It has a lot of energy, but the 26mm bullet drops off fast.
	effective_range_max = EFFECTIVE_RANGE_MAX_TIER_2 //Full damage up to this distance, then falloff for each tile beyond.
	var/hit_messages = list()

/datum/ammo/bullet/shotgun/twobore/on_hit_mob(mob/living/M, obj/projectile/P)
	var/mob/shooter = P.firer
	if(shooter && ismob(shooter) && HAS_TRAIT(shooter, TRAIT_TWOBORE_TRAINING) && M.stat != DEAD && prob(40)) //Death is handled by periodic life() checks so this should have a chance to fire on a killshot.
		if(!length(hit_messages)) //Pick and remove lines, refill on exhaustion.
			hit_messages = list("Got you!", "Aha!", "Bullseye!", "It's curtains for you, Sonny Jim!", "Your head will look fantastic on my wall!", "I have you now!", "You miserable coward! Come and fight me like a man!", "Tally ho!")
		var/message = pick_n_take(hit_messages)
		shooter.say(message)

	if(P.distance_travelled > 8)
		knockback(M, P, 12)

	else if(!M || M == P.firer || M.lying) //These checks are included in knockback and would be redundant above.
		return

	shake_camera(M, 3, 4)
	M.apply_effect(2, WEAKEN)
	M.apply_effect(4, SLOW)
	if(iscarbonsizexeno(M))
		to_chat(M, SPAN_XENODANGER("The impact knocks you off your feet!"))
	else //This will hammer a Yautja as hard as a human.
		to_chat(M, SPAN_HIGHDANGER("The impact knocks you off your feet!"))

	step(M, get_dir(P.firer, M))

/datum/ammo/bullet/shotgun/twobore/knockback_effects(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		to_chat(target, SPAN_XENODANGER("You are shaken and slowed by the sudden impact!"))
		target.apply_effect(0.5, WEAKEN)
		target.apply_effect(2, SUPERSLOW)
		target.apply_effect(5, SLOW)
	else
		if(!isyautja(living_mob)) //Not predators.
			living_mob.apply_effect(1, SUPERSLOW)
			living_mob.apply_effect(2, SLOW)
			to_chat(living_mob, SPAN_HIGHDANGER("The impact knocks you off-balance!"))
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/bullet/lever_action
	name = "lever-action bullet"

	damage = 80
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "lever_action_bullet"

//unused and not working. need to refactor MD code. Unobtainable.
//intended mechanic is to have xenos hit with it show up very frequently on any MDs around
/datum/ammo/bullet/lever_action/tracker
	name = "tracking lever-action bullet"
	icon_state = "redbullet"
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_3
	accuracy = HIT_ACCURACY_TIER_1
	handful_state = "tracking_lever_action_bullet"

/datum/ammo/bullet/lever_action/tracker/on_hit_mob(mob/M, obj/projectile/P, mob/user)
	//SEND_SIGNAL(user, COMSIG_BULLET_TRACKING, user, M)
	M.visible_message(SPAN_DANGER("You hear a faint beep under [M]'s [M.mob_size > MOB_SIZE_HUMAN ? "chitin" : "skin"]."))

/datum/ammo/bullet/lever_action/training
	name = "lever-action blank"
	icon_state = "blank"
	damage = 70  //blanks CAN hurt you if shot very close
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	damage_falloff = DAMAGE_FALLOFF_BLANK //not much, though (comparatively)
	shell_speed = AMMO_SPEED_TIER_5
	handful_state = "training_lever_action_bullet"

//unused, and unobtainable... for now
/datum/ammo/bullet/lever_action/marksman
	name = "marksman lever-action bullet"
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_6
	handful_state = "marksman_lever_action_bullet"

/datum/ammo/bullet/lever_action/xm88
	name = ".458 SOCOM round"

	damage = 80
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "boomslang_bullet"

/datum/ammo/bullet/lever_action/xm88/pen20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/lever_action/xm88/pen30
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/lever_action/xm88/pen40
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/lever_action/xm88/pen50
	penetration = ARMOR_PENETRATION_TIER_10

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

/datum/ammo/bullet/tank/flak
	name = "flak autocannon bullet"
	icon_state = "autocannon"
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

/*
//======
					Special Ammo
//======
*/

/datum/ammo/bullet/smartgun
	name = "smartgun bullet"
	icon_state = "redbullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 30
	penetration = 0

/datum/ammo/bullet/smartgun/armor_piercing
	name = "armor-piercing smartgun bullet"
	icon_state = "bullet"

	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_2
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_8
	damage_armor_punch = 1

/datum/ammo/bullet/smartgun/dirty
	name = "irradiated smartgun bullet"
	debilitate = list(0,0,0,3,0,0,0,1)

	shrapnel_chance = SHRAPNEL_CHANCE_TIER_7
	accurate_range = 32
	accuracy = HIT_ACCURACY_TIER_3
	damage = 40
	penetration = 0

/datum/ammo/bullet/smartgun/dirty/armor_piercing
	debilitate = list(0,0,0,3,0,0,0,1)

	accurate_range = 22
	accuracy = HIT_ACCURACY_TIER_3
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_7
	damage_armor_punch = 3

/datum/ammo/bullet/smartgun/holo_target //Royal marines smartgun bullet has only diff between regular ammo is this one does holostacks
	name = "holo-targeting smartgun bullet"
	damage = 30
///Stuff for the HRP holotargetting stacks
	var/holo_stacks = 15

/datum/ammo/bullet/smartgun/holo_target/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/bonus_damage_stack, holo_stacks, world.time)

/datum/ammo/bullet/smartgun/holo_target/ap
	name = "armor-piercing smartgun bullet"
	icon_state = "bullet"

	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_2
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_8
	damage_armor_punch = 1

/datum/ammo/bullet/smartgun/m56_fpw
	name = "\improper M56 FPW bullet"
	icon_state = "redbullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	max_range = 7
	accuracy = HIT_ACCURACY_TIER_7
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_1

/datum/ammo/bullet/turret
	name = "autocannon bullet"
	icon_state = "redbullet" //Red bullets to indicate friendly fire restriction
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_COVER

	accurate_range = 22
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_8
	max_range = 22
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_7
	damage_armor_punch = 0
	pen_armor_punch = 0
	shell_speed = 2*AMMO_SPEED_TIER_6
	accuracy = HIT_ACCURACY_TIER_5

/datum/ammo/bullet/turret/dumb
	icon_state = "bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

/datum/ammo/bullet/machinegun //Adding this for the MG Nests (~Art)
	name = "machinegun bullet"
	icon_state = "bullet" // Keeping it bog standard with the turret but allows it to be changed

	accurate_range = 12
	damage = 35
	penetration= ARMOR_PENETRATION_TIER_10 //Bumped the penetration to serve a different role from sentries, MGs are a bit more offensive
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/machinegun/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/datum/ammo/bullet/machinegun/auto // for M2C, automatic variant for M56D, stats for bullet should always be moderately overtuned to fulfill its ultra-offense + flank-push purpose
	name = "heavy machinegun bullet"

	accurate_range = 10
	damage =  50
	penetration = ARMOR_PENETRATION_TIER_6
	accuracy = -HIT_ACCURACY_TIER_2 // 75 accuracy
	shell_speed = AMMO_SPEED_TIER_2
	max_range = 15
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_8

/datum/ammo/bullet/machinegun/auto/set_bullet_traits()
	return

/datum/ammo/bullet/minigun
	name = "minigun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 12
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/minigun/New()
	..()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		damage = 15
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(setup_hvh_damage))

/datum/ammo/bullet/minigun/proc/setup_hvh_damage()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		damage = 15

/datum/ammo/bullet/minigun/tank
	accuracy = -HIT_ACCURACY_TIER_1
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_8
	accurate_range = 12

/datum/ammo/bullet/m60
	name = "M60 bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = HIT_ACCURACY_TIER_2
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 12
	damage = 45 //7.62x51 is scary
	penetration= ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pkp
	name = "machinegun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = HIT_ACCURACY_TIER_1
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 14
	damage = 35
	penetration= ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2
