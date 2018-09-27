/datum/caste_datum/hivelord
	caste_name = "Hivelord"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	max_health = 200
	plasma_max = 800
	upgrade_threshold = 800
	evolution_allowed = FALSE
	plasma_gain = 35
	caste_desc = "A builder of REALLY BIG hives."
	speed = 0.4
	aura_strength = 1 //Hivelord's aura is not extremely strong, but better than Drones. At the top, it's just a bit above a young Queen. Climbs by 0.5 to 2.5
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	xeno_explosion_resistance = 40

/datum/caste_datum/hivelord/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 25
	max_health = 220
	plasma_max = 900
	plasma_gain = 40
	upgrade_threshold = 1600
	caste_desc = "A builder of REALLY BIG hives. It looks a little more dangerous."
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	speed = 0.3
	aura_strength = 1.5

/datum/caste_datum/hivelord/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 30
	max_health = 240
	plasma_max = 1000
	plasma_gain = 50
	upgrade_threshold = 3200
	caste_desc = "A builder of REALLY BIG hives. It looks pretty strong."
	armor_deflection = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	speed = 0.2
	aura_strength = 2

/datum/caste_datum/hivelord/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 30
	melee_damage_upper = 35
	max_health = 260
	plasma_max = 1200
	plasma_gain = 70
	caste_desc = "An extreme construction machine. It seems to be building walls..."
	armor_deflection = 20
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	speed = 0.1

/mob/living/carbon/Xenomorph/Hivelord
	caste_name = "Hivelord"
	name = "Hivelord"
	desc = "A huge ass xeno covered in weeds! Oh shit!"
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Hivelord Walking"
	health = 200
	maxHealth = 200
	plasma_stored = 800
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	var/speed_activated = 0
	tier = 2
	upgrade = 0
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



/mob/living/carbon/Xenomorph/Hivelord/movement_delay()
	. = ..()

	if(speed_activated)
		if(locate(/obj/effect/alien/weeds) in loc)
			. -= 1.5
