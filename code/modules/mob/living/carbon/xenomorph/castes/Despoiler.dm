/datum/caste_datum/despoiler
	caste_type = XENO_CASTE_DESPOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3


	tackle_min = 4
	tackle_max = 6

	minimap_icon = "xenoqueen"
	spit_types = list(/datum/ammo/xeno/acid/despoiler)


/mob/living/carbon/xenomorph/despoiler
	caste_type = XENO_CASTE_DESPOILER
	name = XENO_CASTE_DESPOILER
	desc = "A huge, looming beast of an alien."
	icon_size = 64
	icon_state = "Praetorian Walking"
	plasma_types = list(PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	organ_value = 3000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit/despoiler,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/praetorian.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Praetorian_1","Praetorian_2","Praetorian_3")
	weed_food_states_flipped = list("Praetorian_1","Praetorian_2","Praetorian_3")

	skull = /obj/item/skull/praetorian
	pelt = /obj/item/pelt/praetorian
