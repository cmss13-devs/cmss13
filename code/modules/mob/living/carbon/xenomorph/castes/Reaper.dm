/datum/caste_datum/reaper
	caste_type = XENO_CASTE_REAPER
	caste_desc = "A flexible frontline supporter."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3

	behavior_delegate_type = /datum/behavior_delegate/base_reaper

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_CARRIER)
	throwspeed = SPEED_AVERAGE
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 35
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 3

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "reaper"

/mob/living/carbon/xenomorph/reaper
	caste_type = XENO_CASTE_REAPER
	name = XENO_CASTE_REAPER
	desc = "A horrifying alien with a grim visage. The stench of rot follows it wherever it goes."
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/reaper.dmi'
	icon_state = "Reaper Walking"
	plasma_types = list(PLASMA_PURPLE, PLASMA_PHEROMONE)

	drag_delay = 6

	mob_size = MOB_SIZE_BIG
	tier = 3
	pixel_x = -16
	old_x = -16

	organ_value = 3000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction/not_primary,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/activable/haul_corpse, //second macro
		/datum/action/xeno_action/activable/flesh_harvest, //third macro
		/datum/action/xeno_action/activable/rapture, //fourth macro
		/datum/action/xeno_action/onclick/emit_mist, //fifth macro
		/datum/action/xeno_action/onclick/tacmap,
	)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xenonid = 'icons/mob/xenonids/reaper.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Reaper_1","Reaper_2","Reaper_3")
	weed_food_states_flipped = list("Reaper_1","Reaper_2","Reaper_3")

	// Reaper vars
	var/list/corpses_hauled = list()
	var/corpse_no = 0
	var/corpse_max = 4

/mob/living/carbon/xenomorph/reaper/get_status_tab_items()
	. = ..()
	. += "Hauled corpses: [corpse_no] / [corpse_max]"

/datum/behavior_delegate/base_reaper
	name = "Base Reaper Behavior Delegate"

	var/flesh_plasma = 0
	var/flesh_plasma_max = 1000
	var/passive_flesh_regen = 1
	var/passive_flesh_multi= 1
	var/passive_multi_max = 5
	var/pause_decay = FALSE
	var/pause_dur = 5 SECONDS
	var/unpause_incoming = FALSE
	var/harvesting = FALSE // So you can't harvest multiple corpses at once

/datum/behavior_delegate/base_reaper/proc/mult_decay()
	if(passive_flesh_multi < 1)
		passive_flesh_multi = 1
	if(pause_decay == FALSE && passive_flesh_multi > 1)
		passive_flesh_multi -= 1

/datum/behavior_delegate/base_reaper/proc/unpause_decay()
	pause_decay = FALSE
	unpause_incoming = FALSE
	pause_dur = 5 SECONDS

/datum/behavior_delegate/base_reaper/append_to_stat()
	. = ..()
	. += "Flesh Plasma: [flesh_plasma]"
	. += "Passive Gain: [passive_flesh_regen * passive_flesh_multi]"

/datum/behavior_delegate/base_reaper/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	passive_flesh_multi += 1

/datum/behavior_delegate/base_reaper/on_life()
	if(passive_flesh_multi > passive_multi_max)
		passive_flesh_multi = passive_multi_max
	if(flesh_plasma > flesh_plasma_max)
		flesh_plasma = flesh_plasma_max
	if(flesh_plasma < 0)
		flesh_plasma = 0

	flesh_plasma += passive_flesh_regen * passive_flesh_multi

	mult_decay()
	if(pause_decay == TRUE && unpause_incoming == FALSE)
		unpause_incoming = TRUE
		addtimer(CALLBACK(src, PROC_REF(unpause_decay)), pause_dur)

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_flesh = round((flesh_plasma / flesh_plasma_max) * 100, 10)
	if(percentage_flesh)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_flesh]")
