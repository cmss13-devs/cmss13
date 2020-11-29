/datum/caste_datum/boiler
	caste_name = "Boiler"
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_1

	behavior_delegate_type = /datum/behavior_delegate/boiler_base

	evolution_allowed = FALSE
	deevolves_to = "Spitter"
	spit_delay = 35
	caste_desc = "Gross!"
	acid_level = 3
	caste_luminosity = 2
	
	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25
	tacklestrength_min = 3
	tacklestrength_max = 4

/mob/living/carbon/Xenomorph/Boiler
	caste_name = "Boiler"
	name = "Boiler"
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon_source = "alien_boiler"
	icon_size = 64
	icon_state = "Boiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	drag_delay = 6 //pulling a big dead xeno is hard
	mutation_type = BOILER_NORMAL

	tileoffset = 0
	viewsize = 16

	var/datum/effect_system/smoke_spread/xeno_acid/smoke

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/bombard, //1st macro
		/datum/action/xeno_action/activable/acid_lance, //2nd macro
		/datum/action/xeno_action/onclick/dump_acid, //3rd macro
		/datum/action/xeno_action/onclick/toggle_long_range/boiler, //4th macro
	)

/mob/living/carbon/Xenomorph/Boiler/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	smoke.source_mob = src
	see_in_dark = 20
	ammo = ammo_list[/datum/ammo/xeno/boiler_gas]

/mob/living/carbon/Xenomorph/Boiler/Destroy()
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

/turf/proc/can_bombard(var/mob/bombarder)
	if(!can_be_dissolved() && density) return FALSE
	for(var/atom/A in src)
		if(istype(A, /obj/structure/machinery)) continue // Machinery shouldn't block boiler gas (e.g. computers)
		if(ismob(A)) continue // Mobs shouldn't block boiler gas

		if(A && A.unacidable && A.density) return FALSE

	return TRUE

/mob/living/carbon/Xenomorph/Boiler/proc/can_bombard_turf(var/atom/target, var/length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(src)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	while(current != target_turf)
		if(steps > length) return FALSE
		if(!current) return FALSE

		if(!current.can_bombard(src)) return FALSE
		if(current.opacity)	return FALSE
		for(var/atom/A in current)
			if(A.opacity) return FALSE

		current = get_step_towards(current, target_turf)
		steps++

	return TRUE

// No special behavior for boilers
/datum/behavior_delegate/boiler_base
	name = "Base Boiler Behavior Delegate"


