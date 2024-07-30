/datum/caste_datum/hivelord
	caste_type = XENO_CASTE_HIVELORD
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_7
	plasma_gain = XENO_PLASMA_GAIN_TIER_10
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_2

	available_strains = list(/datum/xeno_strain/resin_whisperer)

	evolution_allowed = FALSE
	caste_desc = "A builder of really big hives."
	deevolves_to = list(XENO_CASTE_DRONE)
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	build_time_mult = BUILD_TIME_MULT_HIVELORD
	behavior_delegate_type = /datum/behavior_delegate/hivelord_base
	max_build_dist = 1

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2.5

	minimum_evolve_time = 3 MINUTES

	minimap_icon = "hivelord"

/datum/caste_datum/hivelord/New()
	. = ..()

	resin_build_order = GLOB.resin_build_order_hivelord

/mob/living/carbon/xenomorph/hivelord
	caste_type = XENO_CASTE_HIVELORD
	name = XENO_CASTE_HIVELORD
	desc = "A builder of really big hives."
	icon = 'icons/mob/xenos/hivelord.dmi'
	icon_size = 64
	icon_state = "Hivelord Walking"
	plasma_types = list(PLASMA_PURPLE,PLASMA_PHEROMONE)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 2
	organ_value = 1500

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin/hivelord, //third macro
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // to be consistent with drone placement
		/datum/action/xeno_action/active_toggle/toggle_speed, //fourth macro
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
		/datum/action/xeno_action/onclick/tacmap,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xeno = 'icons/mob/xenos/hivelord.dmi'
	icon_xenonid = 'icons/mob/xenonids/hivelord.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Hivelord_1","Hivelord_2","Hivelord_3")
	weed_food_states_flipped = list("Hivelord_1","Hivelord_2","Hivelord_3")

/datum/behavior_delegate/hivelord_base
	name = "Base Hivelord Behavior Delegate"

	var/resin_walker = FALSE

	var/weed_speed_increase = XENO_SPEED_FASTMOD_TIER_10 * 3 // i love defines

/datum/behavior_delegate/hivelord_base/proc/toggle_resin_walker()
	if(!resin_walker)
		RegisterSignal(bound_xeno, COMSIG_XENO_MOVEMENT_DELAY, PROC_REF(handle_resin_walker))
		resin_walker = TRUE
		return TRUE
	else
		UnregisterSignal(bound_xeno, COMSIG_XENO_MOVEMENT_DELAY)
		resin_walker = FALSE
		return FALSE

/datum/behavior_delegate/hivelord_base/proc/handle_resin_walker(mob/user, list/speed_data)
	SIGNAL_HANDLER

	var/obj/effect/alien/weeds/turf_weeds = locate() in bound_xeno.loc
	if(!turf_weeds)
		return

	if(turf_weeds.linked_hive.hivenumber == bound_xeno.hivenumber)
		speed_data["speed"] += weed_speed_increase

/datum/behavior_delegate/hivelord_base/on_life()
	if(!resin_walker)
		return
	bound_xeno.plasma_stored -= 30
	if(bound_xeno.plasma_stored > 0)
		return
	toggle_resin_walker()
	to_chat(bound_xeno, SPAN_WARNING("You feel dizzy as the world slows down."))
	bound_xeno.recalculate_move_delay = TRUE
