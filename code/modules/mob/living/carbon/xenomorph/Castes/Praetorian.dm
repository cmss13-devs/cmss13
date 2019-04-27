/datum/caste_datum/praetorian
	caste_name = "Praetorian"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_chance = 45
	max_health = XENO_UNIVERSAL_HPMULT * 260
	plasma_gain = 0.032
	plasma_max = 800
	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	spit_delay = 20
	speed = -0.5
	caste_desc = "Ptui!"
	armor_deflection = 35
	aura_strength = 1.5 //Praetorian's aura starts strong. They are the Queen's right hand. Climbs by 1 to 4.5
	spit_types = list(/datum/ammo/xeno/toxin/heavy, /datum/ammo/xeno/acid/heavy, /datum/ammo/xeno/sticky)
	xeno_explosion_resistance = 60
	acid_level = 2

/datum/caste_datum/praetorian/mature
	upgrade_name = "Mature"
	caste_desc = "A giant ranged monster. It looks a little more dangerous."
	upgrade = 1
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = XENO_UNIVERSAL_HPMULT * 270
	plasma_gain = 0.034
	plasma_max = 900
	spit_delay = 15
	armor_deflection = 40
	tackle_chance = 50
	speed = -0.6
	aura_strength = 2.5

/datum/caste_datum/praetorian/elder
	upgrade_name = "Elder"
	caste_desc = "A giant ranged monster. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	max_health = XENO_UNIVERSAL_HPMULT * 285
	plasma_gain = 0.04
	plasma_max = 1000
	spit_delay = 15
	armor_deflection = 42
	tackle_chance = 55
	speed = -0.7
	aura_strength = 3.5

/datum/caste_datum/praetorian/ancient
	upgrade_name = "Ancient"
	caste_desc = "Its mouth looks like a minigun."
	upgrade = 3
	melee_damage_lower = 35
	melee_damage_upper = 45
	max_health = XENO_UNIVERSAL_HPMULT * 295
	plasma_gain = 0.05
	plasma_max = 1100
	spit_delay = 12
	armor_deflection = 45
	tackle_chance = 55
	speed = -0.8
	aura_strength = 4

/datum/caste_datum/praetorian/primordial
	upgrade_name = "Primordial"
	caste_desc = "Why is this thing bigger than a dropship?!"
	upgrade = 4
	melee_damage_lower = 50
	melee_damage_upper = 60
	plasma_gain = 0.05
	plasma_max = 1500
	spit_delay = 0
	armor_deflection = 60
	tackle_chance = 60
	speed = -0.9
	aura_strength = 5
	max_health = XENO_UNIVERSAL_HPMULT * 350

/mob/living/carbon/Xenomorph/Praetorian
	caste_name = "Praetorian"
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Praetorian Walking"
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	var/sticky_cooldown = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/spray_acid
	)