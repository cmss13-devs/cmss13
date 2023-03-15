//Fuck config files, we should stop using them
/datum/combat_configuration
	//our chance to crit in %
	var/critical_chance = 0
	//how much of an increase in %/100 we have per armor "level"
	//has to be defined down the line
	var/armor_effective_health = 0
	//how much armor you can have if it is completely broken. Also how much armor we count on crit
	var/armor_minimal_efficiency = 0.25
	//how much armor we need to do 1 step
	//should redefine down the line, because this value is SICK
	var/armor_steps = 1
	//how much slack we have to deal at least some damage.
	var/non_null_damage_mult = 2
	//how much armor we need to have to have a chance at completely absorbing the hit
	var/armor_full_deflection_mult = 1
	//how much armor we need before it is completely overwhelmed by damage
	var/armor_full_destruction_mult = 2
	//how strong can be the full armor overwhelming
	var/armor_max_full_destruction_mult = 4
	//multiplier over final damage to armor calc
	var/armor_integrity_damage_mult = 4
	//if armor doesn't break at all
	var/armor_ignore_integrity = 0
	//if you need to give additional damage for this damtype
	var/damage_initial_multiplier = 1
	//level of randomness over the armor value in %
	var/armor_random_range = 0

//Marine
/datum/combat_configuration/marine
	armor_minimal_efficiency = 0.25
	armor_effective_health = 0.1
	armor_steps = 5
	non_null_damage_mult = 2
	armor_full_deflection_mult = 2
	//Marine unga armor is made of pure unganite. Unbreakable completely
	armor_ignore_integrity = 1

//Marine Ranged (basically "hello HvH")
/datum/combat_configuration/marine/ranged
	//higher initial threshold to absorb damage, but slower falloff
	non_null_damage_mult = 4
	armor_full_deflection_mult = 2

/datum/combat_configuration/marine/ranged/stats

//Marine Melee (basically "pounce slash dead")
/datum/combat_configuration/marine/melee
	//lower crit chance (you expect the attack most of the time, we hope)
	//armor is not ok against slashes unless it has a lot of slash protection
	non_null_damage_mult = 5
	armor_full_deflection_mult = 2

//Marine Explosive (basically "OH FUCK SOMEONE SAID FRAG-OUT!")
/datum/combat_configuration/marine/explosive
	armor_minimal_efficiency = 0.1
	//some armor is better than no armor
	non_null_damage_mult = 8
	armor_full_deflection_mult = 4

//Marine Explosive (basically "AGH AGH IT BURNS IT BURNS!")
/datum/combat_configuration/marine/fire
	armor_minimal_efficiency = 1
	non_null_damage_mult = 2
	armor_full_deflection_mult = 1

/datum/combat_configuration/marine/bone_break
	armor_minimal_efficiency = 0
	non_null_damage_mult = 1
	armor_full_deflection_mult = 1
	armor_minimal_efficiency = 0
	armor_effective_health = 0.1
	armor_steps = 5
	armor_ignore_integrity = 0

/datum/combat_configuration/marine/organ_damage
	armor_minimal_efficiency = 0
	non_null_damage_mult = 1
	armor_full_deflection_mult = 1
	armor_minimal_efficiency = 0
	armor_effective_health = 0.1
	armor_steps = 5
	armor_ignore_integrity = 0


//XENO
/datum/combat_configuration/xeno
	armor_minimal_efficiency = 0.05
	armor_effective_health = 0.1
	armor_steps = 5
	non_null_damage_mult = 4
	armor_full_deflection_mult = 2
	armor_integrity_damage_mult = 4
	armor_ignore_integrity = TRUE

/datum/combat_configuration/xeno/ranged

/datum/combat_configuration/xeno/ranged/stats

/datum/combat_configuration/xeno/melee
	damage_initial_multiplier = 1.5

/datum/combat_configuration/xeno/explosive
	armor_steps = 10
	armor_minimal_efficiency = 0
	damage_initial_multiplier = 2
	armor_integrity_damage_mult = 4

/datum/combat_configuration/xeno/explosive/small
	armor_ignore_integrity = 1

/datum/combat_configuration/xeno/fire
	armor_minimal_efficiency = 1
