/datum/caste_datum/boiler
	caste_type = XENO_CASTE_BOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_6	//being a T3 AND an acid-focused xeno, gets higher damage for self defense
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3

	available_strains = list(/datum/xeno_strain/trapper)
	behavior_delegate_type = /datum/behavior_delegate/boiler_base

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_SPITTER)
	spit_delay = 30 SECONDS
	caste_desc = "Gross!"
	acid_level = 3
	caste_luminosity = 2
	spit_types = list(/datum/ammo/xeno/boiler_gas, /datum/ammo/xeno/boiler_gas/acid)
	fire_immunity = FIRE_VULNERABILITY
	// 3x fire damage
	fire_vulnerability_mult = FIRE_MULTIPLIER_DEADLY

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25
	tacklestrength_min = 3
	tacklestrength_max = 4

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "boiler"

/mob/living/carbon/xenomorph/boiler
	caste_type = XENO_CASTE_BOILER
	name = XENO_CASTE_BOILER
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/mob/xenos/castes/tier_3/boiler.dmi'
	icon_size = 64
	icon_state = "Boiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	drag_delay = 6 //pulling a big dead xeno is hard
	spit_delay  = 30 SECONDS
	tileoffset = 3
	viewsize = 7

	icon_xeno = 'icons/mob/xenos/castes/tier_3/boiler.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/boiler.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Boiler_1","Boiler_2","Boiler_3")
	weed_food_states_flipped = list("Boiler_1","Boiler_2","Boiler_3")

	var/datum/effect_system/smoke_spread/xeno_acid/smoke

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/boiler,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/xeno_spit/bombard, //1st macro
		/datum/action/xeno_action/onclick/shift_spits/boiler, //2nd macro
		/datum/action/xeno_action/activable/spray_acid/boiler, //3rd macro
		/datum/action/xeno_action/onclick/toggle_long_range/boiler, //4th macro
		/datum/action/xeno_action/onclick/acid_shroud, //5th macro
		/datum/action/xeno_action/onclick/tacmap,
	)

/mob/living/carbon/xenomorph/boiler/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	smoke.cause_data = create_cause_data(initial(caste_type), src)
	see_in_dark = 20
	ammo = GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid]
	spit_types = list(/datum/ammo/xeno/boiler_gas/acid, /datum/ammo/xeno/boiler_gas)
	recalculate_actions() // TODO220: WHY AMMO AND SPIT TYPE IS CHANGED IN INIT? Send to upstream

	update_icon_source()

/mob/living/carbon/xenomorph/boiler/Destroy()
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

// No special behavior for boilers
/datum/behavior_delegate/boiler_base
	name = "Base Boiler Behavior Delegate"
