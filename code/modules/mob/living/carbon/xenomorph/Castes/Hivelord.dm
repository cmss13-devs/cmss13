/datum/caste_datum/hivelord
	caste_name = "Hivelord"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	max_health = XENO_UNIVERSAL_HPMOD * 220
	plasma_gain = 0.044
	plasma_max = 1000
	evolution_allowed = FALSE
	caste_desc = "A builder of really big hives."
	deevolves_to = "Drone"
	speed = 0.3
	aura_strength = 1 //Hivelord's aura is not extremely strong, but better than Drones. At the top, it's just a bit above a young Queen. Climbs by 0.5 to 2.5
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	xeno_explosion_resistance = 40
	acid_level = 2
	aura_strength = 1.5
	weed_level = 2 //Starts with wider weeds by default
	build_time = 5
	max_build_dist = 1

/datum/caste_datum/hivelord/mature
	upgrade_name = "Mature"
	caste_desc = "A builder of really big hives hives. It looks a little more dangerous."
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 25
	max_health = XENO_UNIVERSAL_HPMOD * 240
	plasma_gain = 0.045
	plasma_max = 1100
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	aura_strength = 2

/datum/caste_datum/hivelord/elder
	upgrade_name = "Elder"
	caste_desc = "A builder of really big hives. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 30
	max_health = XENO_UNIVERSAL_HPMOD * 265
	plasma_gain = 0.05
	plasma_max = 1100
	armor_deflection = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	aura_strength = 2.5
	speed = 0.2

/datum/caste_datum/hivelord/ancient
	upgrade_name = "Ancient"
	caste_desc = "An extreme construction machine. It seems to be building walls..."
	upgrade = 3
	melee_damage_lower = 30
	melee_damage_upper = 35
	max_health = XENO_UNIVERSAL_HPMOD * 280
	plasma_gain = 0.08
	plasma_max = 1200
	armor_deflection = 18
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 50
	aura_strength = 2.8
	speed = 0.3

/mob/living/carbon/Xenomorph/Hivelord
	caste_name = "Hivelord"
	name = "Hivelord"
	desc = "A builder of really big hives."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Hivelord Walking"
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/toggle_speed,
		)

