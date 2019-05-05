/datum/caste_datum/drone
	caste_name = "Drone"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	plasma_gain = XENO_PLASMA_GAIN_LOWMED
	plasma_max = XENO_PLASMA_VERYHIGH
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_LOWMEDIUM
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_CONVERT( XENO_SPEED_HIGH )
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR

	aura_strength = 0.5 //Drone's aura is the weakest. At the top of their evolution, it's equivalent to a Young Queen Climbs by 0.5 to 2
	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list("Queen", "Burrower", "Carrier", "Hivelord") //Add more here seperated by commas
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	xeno_explosion_resistance = 20
	acid_level = 1
	weed_level = 1

/datum/caste_datum/drone/mature
	upgrade_name = "Mature"
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	aura_strength = 1.5

/datum/caste_datum/drone/elder
	upgrade_name = "Elder"
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	upgrade = 2
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	aura_strength = 2

/datum/caste_datum/drone/ancient
	upgrade_name = "Ancient"
	caste_desc = "A very mean architect."
	upgrade = 3
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	aura_strength = 2.2

/mob/living/carbon/Xenomorph/Drone
	caste_name = "Drone"
	name = "Drone"
	desc = "An Alien Drone"
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Drone Walking"
	tier = 1
	pixel_x = -12
	old_x = -12
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/emit_pheromones,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

/datum/caste_datum/drone/New()
	..()
	young_multipliers()
/datum/caste_datum/drone/mature/New()
	..()
	mature_multipliers()
/datum/caste_datum/drone/elder/New()
	..()
	elder_multipliers()
/datum/caste_datum/drone/ancient/New()
	..()
	ancient_multipliers()