/datum/caste_datum/hivelord
	caste_name = "Hivelord"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	max_health = 220
	plasma_gain = 0.044
	plasma_max = 900
	evolution_allowed = FALSE
	caste_desc = "A builder of really big hives."
	speed = 0.3
	aura_strength = 1 //Hivelord's aura is not extremely strong, but better than Drones. At the top, it's just a bit above a young Queen. Climbs by 0.5 to 2.5
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	xeno_explosion_resistance = 40
	acid_level = 2
	aura_strength = 1.5
	weed_level = 2 //Starts with wider weeds by default

/datum/caste_datum/hivelord/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 25
	max_health = 230
	plasma_gain = 0.045
	plasma_max = 900
	caste_desc = "A builder of really big hives hives. It looks a little more dangerous."
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	aura_strength = 2

/datum/caste_datum/hivelord/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 30
	plasma_gain = 0.05
	plasma_max = 1000
	caste_desc = "A builder of really big hives. It looks pretty strong."
	armor_deflection = 15
	tackle_chance = 45
	speed = 0.2
	aura_strength = 2.5

/datum/caste_datum/hivelord/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	caste_desc = "An extreme construction machine. It seems to be building walls..."

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

