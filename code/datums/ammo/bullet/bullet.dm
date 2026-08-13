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
