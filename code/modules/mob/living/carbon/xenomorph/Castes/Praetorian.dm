/datum/caste_datum/praetorian
	caste_name = "Praetorian"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_chance = 45
	max_health = 225
	plasma_gain = 25
	plasma_max = 800
	upgrade_threshold = 800
	evolution_allowed = FALSE
	spit_delay = 20
	speed = -0.5
	caste_desc = "Ptui!"
	armor_deflection = 35
	aura_strength = 1.5 //Praetorian's aura starts strong. They are the Queen's right hand. Climbs by 1 to 4.5
	spit_types = list(/datum/ammo/xeno/toxin/heavy, /datum/ammo/xeno/acid/heavy, /datum/ammo/xeno/sticky)

/datum/caste_datum/praetorian/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 250
	plasma_gain = 30
	plasma_max = 900
	upgrade_threshold = 1600
	spit_delay = 15
	caste_desc = "A giant ranged monster. It looks a little more dangerous."
	armor_deflection = 40
	tackle_chance = 50
	speed = -0.6
	aura_strength = 2.5

/datum/caste_datum/praetorian/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	max_health = 275
	plasma_gain = 40
	plasma_max = 1000
	upgrade_threshold = 3200
	spit_delay = 10
	caste_desc = "A giant ranged monster. It looks pretty strong."
	armor_deflection = 45
	tackle_chance = 55
	speed = -0.7
	aura_strength = 3.5

/datum/caste_datum/praetorian/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 35
	melee_damage_upper = 45
	max_health = 300
	plasma_gain = 50
	plasma_max = 1000
	spit_delay = 5
	caste_desc = "Its mouth looks like a minigun."
	armor_deflection = 50
	tackle_chance = 60
	speed = -0.8
	aura_strength = 4.5

/mob/living/carbon/Xenomorph/Praetorian
	caste_name = "Praetorian"
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Praetorian Walking"
	health = 225
	maxHealth = 225
	plasma_stored = 800
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	upgrade = 0
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
