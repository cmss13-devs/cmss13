/datum/configuration
	//roundstart stuff
	var/xeno_number_divider = 4 //What weight do we want to give towards considering roundstart survivors & xenos from readied players.
	var/surv_number_divider = 20

	var/datum/combat_configuration/marine_melee //This is all used in the new fancy xeno & marine armor code. See Neth's documentation on what these do.
	var/datum/combat_configuration/marine_ranged
	var/datum/combat_configuration/marine_ranged_stats
	var/datum/combat_configuration/marine_explosive
	var/datum/combat_configuration/marine_fire
	var/datum/combat_configuration/marine_organ_damage

	var/datum/combat_configuration/xeno_melee
	var/datum/combat_configuration/xeno_ranged
	var/datum/combat_configuration/xeno_ranged_stats
	var/datum/combat_configuration/xeno_explosive
	var/datum/combat_configuration/xeno_explosive_small
	var/datum/combat_configuration/xeno_fire

/*
////SLOWDOWN MODS////
*/
	var/slowdown_none = 0
	var/slowdown_low = 0.10
	var/slowdown_med = 0.25
	var/slowdown_high = 0.40


/datum/configuration/proc/load_combat_config() //Translate of our config vars into datums for ease of usage within the armor equations.
	marine_melee = new /datum/combat_configuration/marine/melee()
	marine_ranged = new /datum/combat_configuration/marine/ranged()
	marine_ranged_stats = new /datum/combat_configuration/marine/ranged/stats()
	marine_explosive = new /datum/combat_configuration/marine/explosive()
	marine_fire = new /datum/combat_configuration/marine/fire()
	marine_organ_damage = new /datum/combat_configuration/marine/organ_damage()

	xeno_melee = new /datum/combat_configuration/xeno/melee()
	xeno_ranged = new /datum/combat_configuration/xeno/ranged()
	xeno_ranged_stats = new /datum/combat_configuration/xeno/ranged/stats()
	xeno_explosive = new /datum/combat_configuration/xeno/explosive()
	xeno_explosive_small = new /datum/combat_configuration/xeno/explosive/small()
	xeno_fire = new /datum/combat_configuration/xeno/fire()

