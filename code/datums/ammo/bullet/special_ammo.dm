/*
//======
					Special Ammo
//======
*/

/datum/ammo/bullet/smartgun
	name = "smartgun tracer bullet"
	icon_state = "bullet_iff"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage_falloff = DAMAGE_FALLOFF_TIER_9
	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 30
	penetration = 0
	effective_range_max = 1

/datum/ammo/bullet/smartgun/alt
	name = "smartgun bullet"
	icon_state = "redbullet"

	damage_falloff = DAMAGE_FALLOFF_TIER_6
	effective_range_max = 7

/datum/ammo/bullet/smartgun/setup_faction_clash_values()
	. = ..()
	max_range = 17
	accurate_range = 12
	effective_range_max = 12

/datum/ammo/bullet/smartgun/armor_piercing
	name = "\improper AP smartgun tracer bullet"
	icon_state = "bullet_ap_iff"

	damage_falloff = DAMAGE_FALLOFF_TIER_9_5
	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_2
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_8
	damage_armor_punch = 1

/datum/ammo/bullet/smartgun/armor_piercing/alt
	name = "\improper AP smartgun bullet"
	icon_state = "bullet"

	damage_falloff = DAMAGE_FALLOFF_TIER_7
	effective_range_max = 7

/datum/ammo/bullet/smartgun/dirty
	name = "irradiated smartgun tracer bullet"
	icon_state = "bullet_iff"
	debilitate = list(0,0,0,3,0,0,0,1)

	shrapnel_chance = SHRAPNEL_CHANCE_TIER_7
	accurate_range = 32
	accuracy = HIT_ACCURACY_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_9
	damage = 40
	penetration = 0

/datum/ammo/bullet/smartgun/dirty/alt
	name = "irradiated smartgun bullet"
	icon_state = "redbullet"

	damage_falloff = DAMAGE_FALLOFF_TIER_6
	effective_range_max = 7

/datum/ammo/bullet/smartgun/dirty/armor_piercing
	name = "irradiated AP smartgun tracer bullet"
	icon_state = "bullet_ap_iff"
	debilitate = list(0,0,0,3,0,0,0,1)

	accurate_range = 22
	accuracy = HIT_ACCURACY_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_9_5
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_7
	damage_armor_punch = 3

/datum/ammo/bullet/smartgun/dirty/armor_piercing/alt
	name = "irradiated AP smartgun bullet"
	icon_state = "bullet"

	damage_falloff = DAMAGE_FALLOFF_TIER_7
	effective_range_max = 7

/datum/ammo/bullet/smartgun/holo_target //Royal marines smartgun bullet has only diff between regular ammo is this one does holostacks
	name = "holo-targeting smartgun tracer bullet"
	icon_state = "bullet_iff"

	damage = 30
	/// inflicts this many holo stacks per bullet hit
	var/holo_stacks = 15
	/// modifies the default cap limit of 100 by this amount
	var/bonus_damage_cap_increase = 0
	/// multiplies the default drain of 5 holo stacks per second by this amount
	var/stack_loss_multiplier = 1

/datum/ammo/bullet/smartgun/holo_target/alt
	name = "holo-targeting smartgun bullet"
	icon_state = "redbullet"

	damage_falloff = DAMAGE_FALLOFF_TIER_6
	effective_range_max = 7

/datum/ammo/bullet/smartgun/holo_target/on_hit_mob(mob/hit_mob, obj/projectile/bullet)
	. = ..()
	hit_mob.AddComponent(/datum/component/bonus_damage_stack, holo_stacks, world.time, bonus_damage_cap_increase, stack_loss_multiplier)

/datum/ammo/bullet/smartgun/holo_target/ap
	name = "holo-targeting AP smartgun tracer bullet"
	icon_state = "bullet_ap_iff"

	// Same as /datum/ammo/bullet/smartgun/armor_piercing
	damage_falloff = DAMAGE_FALLOFF_TIER_9_5
	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_2
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_8
	damage_armor_punch = 1

/datum/ammo/bullet/smartgun/holo_target/ap/alt
	name = "holo-targeting AP smartgun bullet"
	icon_state = "bullet"

	// Same as /datum/ammo/bullet/smartgun/armor_piercing/alt
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	effective_range_max = 7

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
	damage = 36
	penetration= ARMOR_PENETRATION_TIER_10 //Bumped the penetration to serve a different role from sentries, MGs are a bit more offensive
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/machinegun/setup_faction_clash_values()
	. = ..()
	accurate_range = 12 //we revert the reduction

/datum/ammo/bullet/machinegun/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/datum/ammo/bullet/machinegun/doorgun
	flags_ammo_behavior = AMMO_BALLISTIC | AMMO_IGNORE_COVER

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
	scatter = 0

/datum/ammo/bullet/machinegun/auto/setup_faction_clash_values()
	accuracy = HIT_ACCURACY_TIER_4
	scatter = SCATTER_AMOUNT_TIER_5
	penetration = ARMOR_PENETRATION_TIER_2
	. = ..()

/datum/ammo/bullet/machinegun/auto/set_bullet_traits()
	return

/datum/ammo/bullet/machinegun/medium // for T37, UPP MMG
	name = "medium machinegun bullet"

	accurate_range = 10
	damage =  50
	penetration = ARMOR_PENETRATION_TIER_6
	accuracy = -HIT_ACCURACY_TIER_2 // 75 accuracy
	shell_speed = AMMO_SPEED_TIER_2
	max_range = 15
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_8

/datum/ammo/bullet/machinegun/medium/set_bullet_traits()
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
	SIGNAL_HANDLER
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		damage = 15

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

/datum/ammo/bullet/pkp/setup_faction_clash_values()
	. = ..()
	accurate_range = 14
