/datum/caste_datum/boiler
	caste_name = "Boiler"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	max_health = XENO_HEALTH_LOWHIGH
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	xeno_explosion_resistance = XENO_MEDIUM_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_SLOWMEDIUM
	speed_mod = XENO_SPEED_MOD_SMALL

	behavior_delegate_type = /datum/behavior_delegate/boiler_base

	evolution_allowed = FALSE
	deevolves_to = "Spitter"
	spit_delay = 40
	caste_desc = "Gross!"
	acid_level = 3
	caste_luminosity = 2

/datum/caste_datum/boiler/mature
	upgrade_name = "Mature"
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 20
	spit_delay = 35
	caste_desc = "Some sort of abomination. It looks a little more dangerous."

/datum/caste_datum/boiler/elder
	upgrade_name = "Elder"
	caste_desc = "Some sort of abomination. It looks pretty strong."
	upgrade = 2
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 25
	spit_delay = 35

/datum/caste_datum/boiler/ancient
	upgrade_name = "Ancient"
	caste_desc = "A devestating piece of alien artillery."
	upgrade = 3
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	spit_delay = 35

/mob/living/carbon/Xenomorph/Boiler
	caste_name = "Boiler"
	name = "Boiler"
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/mob/xenos/boiler.dmi'
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

	var/obj/item/explosive/grenade/grenade_type = "/obj/item/explosive/grenade/xeno"

	tileoffset = 0
	viewsize = 14

	var/datum/effect_system/smoke_spread/xeno_acid/smoke

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/Boiler,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/activable/bombard, 
		/datum/action/xeno_action/activable/acid_lance,
		/datum/action/xeno_action/onclick/dump_acid,
	)

/mob/living/carbon/Xenomorph/Boiler/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	see_in_dark = 20
	ammo = ammo_list[/datum/ammo/xeno/boiler_gas]

/mob/living/carbon/Xenomorph/Boiler/Dispose()
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

// No special behavior for boilers
/datum/behavior_delegate/boiler_base
	name = "Base Boiler Behavior Delegate"


