/datum/caste_datum/boiler
	caste_type = XENO_CASTE_BOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_6	//being a T3 AND an acid-focused xeno, gets higher damage for self defense
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_1

	behavior_delegate_type = /datum/behavior_delegate/boiler_base

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_SPITTER)
	spit_delay = 35
	caste_desc = "Gross!"
	acid_level = 3
	caste_luminosity = 2
	spit_types = list(/datum/ammo/xeno/boiler_gas, /datum/ammo/xeno/boiler_gas/acid)

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25
	tacklestrength_min = 3
	tacklestrength_max = 4

/mob/living/carbon/Xenomorph/Boiler
	caste_type = XENO_CASTE_BOILER
	name = XENO_CASTE_BOILER
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/mob/hostiles/boiler.dmi'
	icon_size = 64
	icon_state = "Boiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	spit_types = list(/datum/ammo/xeno/boiler_gas, /datum/ammo/xeno/boiler_gas/acid)
	drag_delay = 6 //pulling a big dead xeno is hard
	mutation_type = BOILER_NORMAL

	tileoffset = 0
	viewsize = 16

	icon_xeno = 'icons/mob/hostiles/boiler.dmi'
	icon_xenonid = 'icons/mob/xenonids/boiler.dmi'

	var/datum/effect_system/smoke_spread/xeno_acid/smoke

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/xeno_spit/bombard, //1st macro
		/datum/action/xeno_action/onclick/shift_spits, //2nd macro
		/datum/action/xeno_action/onclick/dump_acid, //3rd macro
		/datum/action/xeno_action/onclick/toggle_long_range/boiler, //4th macro
	)

/mob/living/carbon/Xenomorph/Boiler/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	smoke.cause_data = create_cause_data(initial(caste_type), src)
	see_in_dark = 20
	ammo = GLOB.ammo_list[/datum/ammo/xeno/boiler_gas]
	spit_types = list(/datum/ammo/xeno/boiler_gas, /datum/ammo/xeno/boiler_gas/acid)

	update_icon_source()

/mob/living/carbon/Xenomorph/Boiler/Destroy()
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

// No special behavior for boilers
/datum/behavior_delegate/boiler_base
	name = "Base Boiler Behavior Delegate"

	var/frontal_armor = 20
	var/side_armor = 5000000000000000

/datum/behavior_delegate/boiler_base/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, .proc/apply_directional_armor)

/datum/behavior_delegate/boiler_base/proc/apply_directional_armor(mob/living/carbon/Xenomorph/X, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(X.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(X.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return
