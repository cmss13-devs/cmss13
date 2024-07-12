/datum/ammo/bullet/shotgun/light/breaching/sparkshots
	name = "Sparkshot shell"
	icon_state = "flechette"
	handful_state = "sparkshot_shell"
	handful_type = /obj/item/ammo_magazine/handful/shotgun/light/breaching/sparkshots
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/light/breaching/sparkshots/spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	damage = 55
	max_range = 5
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	penetration = ARMOR_PENETRATION_TIER_1
	handful_state = "sparkshot_shell"

/datum/ammo/bullet/shotgun/light/breaching/sparkshots/spread
	name = "additional sparkshot fragments"
	bonus_projectiles_amount = 0
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	scatter = SCATTER_AMOUNT_TIER_3
	damage = 10
