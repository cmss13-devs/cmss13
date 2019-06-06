/datum/configuration
	var/proj_base_accuracy_mult = 0.01
	var/proj_base_damage_mult = 0.01

	var/proj_variance_high = 105
	var/proj_variance_low = 98

	var/min_hit_accuracy = 2
	var/low_hit_accuracy = 7
	var/med_hit_accuracy = 13
	var/hmed_hit_accuracy = 21
	var/high_hit_accuracy = 27
	var/max_hit_accuracy = 40

	var/base_hit_accuracy_mult = 1
	var/min_hit_accuracy_mult = 0.05
	var/low_hit_accuracy_mult = 0.13
	var/med_hit_accuracy_mult = 0.19
	var/hmed_hit_accuracy_mult = 0.24
	var/high_hit_accuracy_mult = 0.37
	var/max_hit_accuracy_mult = 0.50

	var/base_hit_damage = 10
	var/min_hit_damage = 16
	var/mlow_hit_damage = 22
	var/low_hit_damage = 29
	var/hlow_hit_damage = 31
	var/hlmed_hit_damage = 34
	var/lmed_hit_damage = 38
	var/lmed_plus_hit_damage = 43
	var/med_hit_damage = 47
	var/hmed_hit_damage = 51
	var/high_hit_damage = 68
	var/mhigh_hit_damage = 76
	var/max_hit_damage = 88
	var/super_hit_damage = 121
	var/ultra_hit_damage = 153

	var/base_hit_damage_mult = 1
	var/min_hit_damage_mult = 0.06
	var/low_hit_damage_mult = 0.12
	var/med_hit_damage_mult = 0.21
	var/hmed_hit_damage_mult = 0.28
	var/high_hit_damage_mult = 0.35
	var/max_hit_damage_mult = 0.45

	var/tactical_damage_falloff = 0.8
	var/reg_damage_falloff = 1 //in config it was 0.89 but referenced wrong var
	var/buckshot_v2_damage_falloff = 3
	var/buckshot_damage_falloff = 5 //ditto but 18.3 (!!!)
	var/extra_damage_falloff = 10 //ditto but 9.75

	var/min_burst_value = 1
	var/low_burst_value = 2
	var/med_burst_value = 3
	var/high_burst_value = 4
	var/mhigh_burst_value = 5
	var/max_burst_value = 6

	var/min_fire_delay = 1
	var/mlow_fire_delay = 2
	var/low_fire_delay = 3
	var/med_fire_delay = 4
	var/high_fire_delay = 5
	var/mhigh_fire_delay = 6
	var/max_fire_delay = 7

	var/min_scatter_value = 1
	var/mlow_scatter_value = 2
	var/low_scatter_value = 3
	var/lmed_scatter_value = 4
	var/med_scatter_value = 5
	var/hmed_scatter_value = 6
	var/high_scatter_value = 7
	var/mhigh_scatter_value = 8
	var/max_scatter_value = 10
	var/super_scatter_value = 15
	var/ultra_scatter_value = 20

	var/min_recoil_value = 1
	var/low_recoil_value = 2
	var/med_recoil_value = 3
	var/high_recoil_value = 4
	var/max_recoil_value = 5

	var/min_shrapnel_chance = 3
	var/low_shrapnel_chance = 9
	var/med_shrapnel_chance = 24
	var/high_shrapnel_chance = 45
	var/max_shrapnel_chance = 75

	var/min_shell_range = 4
	var/close_shell_range = 5
	var/near_shell_range = 7
	var/short_shell_range = 11
	var/norm_shell_range = 22
	var/long_shell_range = 33
	var/max_shell_range = 44

	var/slow_shell_speed = 1
	var/reg_shell_speed = 2
	var/fast_shell_speed = 3
	var/super_shell_speed = 4
	var/ultra_shell_speed = 6

	var/min_armor_penetration = 5
	var/mlow_armor_penetration = 12
	var/low_armor_penetration = 23
	var/hlow_armor_penetration = 26
	var/med_armor_penetration = 31
	var/hmed_armor_penetration = 36
	var/high_armor_penetration = 48
	var/mhigh_armor_penetration = 66
	var/max_armor_penetration = 87

	var/min_proj_extra = 1
	var/low_proj_extra = 2
	var/med_proj_extra = 3
	var/high_proj_extra = 5
	var/max_proj_extra = 8

	var/min_proj_variance = 1
	var/low_proj_variance = 3
	var/med_proj_variance = 7
	var/high_proj_variance = 9
	var/max_proj_variance = 12
	
	//weapon settling multiplier
	var/weapon_settle_accuracy_multiplier = 4
	var/weapon_settle_scatter_multiplier = 2

	//roundstart stuff
	var/xeno_number_divider = 5
	var/surv_number_divider = 20

	var/datum/combat_configuration/marine_melee
	var/datum/combat_configuration/marine_ranged
	var/datum/combat_configuration/marine_explosive
	var/datum/combat_configuration/marine_fire
	var/datum/combat_configuration/marine_organ_damage

	var/datum/combat_configuration/xeno_melee
	var/datum/combat_configuration/xeno_ranged
	var/datum/combat_configuration/xeno_explosive
	var/datum/combat_configuration/xeno_explosive_small
	var/datum/combat_configuration/xeno_fire

/datum/configuration/proc/load_combat_config()
	marine_melee = new /datum/combat_configuration/marine/melee()
	marine_ranged = new /datum/combat_configuration/marine/ranged()
	marine_explosive = new /datum/combat_configuration/marine/explosive()
	marine_fire = new /datum/combat_configuration/marine/fire()
	marine_organ_damage = new /datum/combat_configuration/marine/organ_damage()

	xeno_melee = new /datum/combat_configuration/xeno/melee()
	xeno_ranged = new /datum/combat_configuration/xeno/ranged()
	xeno_explosive = new /datum/combat_configuration/xeno/explosive()
	xeno_explosive_small = new /datum/combat_configuration/xeno/explosive/small()
	xeno_fire = new /datum/combat_configuration/xeno/fire()

