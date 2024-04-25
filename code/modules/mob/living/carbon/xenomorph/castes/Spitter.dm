/datum/caste_datum/spitter
	caste_type = XENO_CASTE_SPITTER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_7
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_MOD_MED
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_5

	available_strains = list(/datum/xeno_strain/suppressor)

	caste_desc = "Ptui!"
	spit_types = list(/datum/ammo/xeno/acid, /datum/ammo/xeno/acid/spatter)
	evolves_to = list(XENO_CASTE_PRAETORIAN, XENO_CASTE_BOILER)
	deevolves_to = list(XENO_CASTE_SENTINEL)
	acid_level = 2

	spit_delay = 2.5 SECONDS

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "spitter"

/mob/living/carbon/xenomorph/spitter
	caste_type = XENO_CASTE_SPITTER
	name = XENO_CASTE_SPITTER
	desc = "A gross, oozing alien of some kind."
	icon_size = 48
	icon_state = "Spitter Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12

	tier = 2
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/xenos/spitter.dmi'
	icon_xenonid = 'icons/mob/xenonids/spitter.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")
