GLOBAL_LIST_INIT(resin_build_order_primeweave, list(
	/datum/resin_construction/resin_turf/wall/thick,
	/datum/resin_construction/resin_turf/wall/reflective,
	/datum/resin_construction/resin_turf/membrane/thick,
	/datum/resin_construction/resin_obj/door/thick,
	/datum/resin_construction/resin_obj/acid_pillar/weave,
	/datum/resin_construction/resin_obj/shield_dispenser,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike,
	/datum/resin_construction/resin_obj/resin_node,
	/datum/resin_construction/resin_obj/movable/thick_wall,
	/datum/resin_construction/resin_obj/movable/thick_membrane,
))


/datum/caste_datum/prime_weaver
	caste_type = WEAVE_CASTE_PRIME
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_7
	melee_damage_upper = XENO_DAMAGE_TIER_8
	max_health = 1800
	plasma_gain = 10
	plasma_max = 1400
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_6
	armor_deflection = XENO_ARMOR_TIER_4
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_5

	evolves_to = null
	deevolves_to = null
	caste_desc = "The Weave Incarnate!"
	acid_level = 3
	weed_level = WEED_LEVEL_HIVE
	evolution_allowed = FALSE

	aura_strength = 10

	tackle_chance = 75
	tackle_min = 2
	tackle_max = 6
	tacklestrength_min = 5
	tacklestrength_max = 6

	burrow_cooldown = 10
	tunnel_cooldown = 45
	widen_cooldown = 30
	tremor_cooldown = 250

	minimum_evolve_time = 0

	minimap_icon = "carrier"

/mob/living/carbon/xenomorph/prime_weaver
	hivenumber = XENO_HIVE_WEAVE
	caste_type = WEAVE_CASTE_PRIME
	name = WEAVE_CASTE_PRIME
	desc = "The Weave is all. And it's right here."
	icon = 'icons/mob/xenonids/weave.dmi'
	icon_size = 64
	icon_state = "Prime Weaver Walking"
	plasma_stored = 100
	plasma_types = list(PLASMA_WEAVE, PLASMA_WEAVE, PLASMA_WEAVE, PLASMA_WEAVE_EXALTED)//Deliberate tripling, to affect ratio of extracted blood and plasma.
	pixel_x = -16
	old_x = -16
	tier = 3
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/strong/weave,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/change_fruit/weave,
		/datum/action/xeno_action/onclick/plant_resin_fruit/weave/pure, //second macro
		/datum/action/xeno_action/activable/burrow, //third macro
		/datum/action/xeno_action/onclick/tremor, //fourth macro
		/datum/action/xeno_action/activable/spray_acid/weaveguard/prime,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/create_pool,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord/weave_macro,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/onclick/exude_energy,
		/datum/action/xeno_action/activable/weave_bless,
		/datum/action/xeno_action/onclick/weave_heal
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
	)

	icon_xeno = 'icons/mob/xenonids/weave.dmi'
	icon_xenonid = 'icons/mob/xenonids/weave.dmi'

	max_placeable = 5
	available_fruits = list(/obj/effect/alien/resin/fruit/weave, /obj/effect/alien/resin/fruit/weave/exalted)
	selected_fruit = /obj/effect/alien/resin/fruit/weave

	extra_build_dist = 9
	can_stack_builds = TRUE
	mob_size = MOB_SIZE_BIG
	universal_understand = TRUE

	speaking_noise = 'sound/voice/weave_talk3.ogg'

/mob/living/carbon/xenomorph/prime_weaver/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..()
	sight |= SEE_THRU//Changes what counts as Line-of-Sight, allowing Psychic speech through walls, but not hearing replies.
	resin_build_order = GLOB.resin_build_order_primeweave
	hive.add_hive_leader(src)

/mob/living/carbon/xenomorph/prime_weaver/update_icons()
	if (stat == DEAD)
		icon_state = "Prime Weaver Dead"
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "Prime Weaver Sleeping"
		else
			icon_state = "Prime Weaver Knocked Down"
	else if (HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		icon_state = "Prime Weaver Burrowed"
	else
		icon_state = "Prime Weaver Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()


/mob/living/carbon/xenomorph/prime_weaver/generate_name()
	if(!nicknumber)
		generate_and_set_nicknumber()
	var/name_prefix = hive.prefix
	if(HAS_TRAIT(src, TRAIT_NO_PREFIX))
		name_prefix = ""

	age = XENO_NORMAL
	if(client)
		hud_update()

	name = "[name_prefix]Prime Weaver"

	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"

	if(!HAS_TRAIT(src, TRAIT_NO_COLOR))
		color = hive.color

	//Update linked data so they show up properly
	change_real_name(src, name)
