/datum/caste_datum/pathogen/archon
	caste_type = PATHOGEN_CREATURE_ARCHON
	tier = 0

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_9
	max_health = XENO_HEALTH_IMMORTAL
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_1

	build_time_mult = BUILD_TIME_MULT_BUILDER

	fire_vulnerability_mult = FIRE_MULTIPLIER_LOW

	is_intelligent = TRUE
	evolution_allowed = FALSE
	caste_desc = "Only the strong survive."
	weed_level = WEED_LEVEL_STANDARD
	can_be_revived = FALSE

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/archon
	deevolves_to = list()
	evolves_to = list()

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 55

	aura_strength = 4
	tacklestrength_min = 5
	tacklestrength_max = 6

	minimum_xeno_playtime = 9 HOURS
	minimum_evolve_time = 0

	minimap_icon = "archon"
	royal_caste = TRUE

/mob/living/carbon/xenomorph/archon
	caste_type = PATHOGEN_CREATURE_ARCHON
	name = PATHOGEN_CREATURE_ARCHON
	desc = "Nothing will survive..."
	icon_size = 64
	icon_state = "Archon Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 0
	organ_value = 50000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough/pathogen,
		/datum/action/xeno_action/onclick/xeno_resting/pathogen,
		/datum/action/xeno_action/onclick/release_haul/pathogen,
		/datum/action/xeno_action/watch_xeno/pathogen,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen,
		/datum/action/xeno_action/onclick/emit_pheromones/pathogen,
		/datum/action/xeno_action/activable/place_pathogen_structure/not_primary,
		/datum/action/xeno_action/activable/gut/archon,
		/datum/action/xeno_action/activable/tail_stab/pathogen/tier3,
		/datum/action/xeno_action/onclick/blight_wave/archon,
		/datum/action/xeno_action/activable/venator_savage/archon, // Macro 1
		/datum/action/xeno_action/activable/cyclone/archon, // Macro 2
		/datum/action/xeno_action/onclick/tail_sweep/pathogen, // Macro 3
		/datum/action/xeno_action/onclick/choose_resin/pathogen/not_primary,
		/datum/action/xeno_action/activable/secrete_resin/pathogen/archon, // Macro 4
		/datum/action/xeno_action/onclick/pathogen_paralyze, //Macro 5
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	icon_xeno = 'icons/mob/pathogen/archon.dmi'
	icon_xenonid = 'icons/mob/pathogen/archon.dmi'

	skull = /obj/item/skull/pathogen_archon
	pelt = /obj/item/pelt/pathogen_archon

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Archon_1","Archon_2","Archon_3")
	weed_food_states_flipped = list("Archon_1","Archon_2","Archon_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	fire_immunity = FIRE_VULNERABILITY
	//counts_for_slots = FALSE
	aura_strength = 5
	langchat_height = 64

/mob/living/carbon/xenomorph/archon/Initialize()
	. = ..()
	make_pathogen_speaker()
	SStracking.set_leader("hive_[hivenumber]", src)
	if(!should_block_game_interaction(src))//so admins can safely spawn Archons in Thunderdome for tests.
		xeno_message(SPAN_XENOANNOUNCE("A new Archon has risen to lead the Confluence! Rejoice!"),3,hivenumber)
		notify_ghosts(header = "New Archon", message = "A new Archon has risen.", source = src, action = NOTIFY_ORBIT)
	playsound(loc, 'sound/pathogen_creatures/announce_screech.ogg', 75, 0)
	set_resin_build_order(GLOB.resin_build_order_pathogen_base)
	for(var/datum/action/xeno_action/action in actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			choose_resin_ability.update_button_icon(selected_resin)
			break // Don't need to keep looking

	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	AddComponent(/datum/component/tacmap, has_drawing_tools=TRUE, minimap_flag=get_minimap_flag_for_faction(hive.hivenumber), has_update=TRUE, drawing=TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_block))

/mob/living/carbon/xenomorph/archon/proc/check_block(mob/archon, turf/new_loc)
	SIGNAL_HANDLER
	if(body_position == LYING_DOWN || stat == UNCONSCIOUS)
		return
	for(var/mob/living/carbon/xenomorph/xeno in new_loc.contents)
		if(xeno.stat == DEAD)
			continue
		if(xeno.pass_flags.flags_pass & (PASS_MOB_THRU_XENO|PASS_MOB_THRU) || xeno.flags_pass_temp & PASS_MOB_THRU)
			continue
		if(xeno.hivenumber == hivenumber && !(archon.client?.prefs?.toggle_prefs & TOGGLE_AUTO_SHOVE_OFF))
			xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
			playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)

/datum/action/xeno_action/activable/gut/archon
	button_icon_state = "template_pathogen"
	icon_file = 'icons/mob/hud/actions_pathogen.dmi'

/datum/action/xeno_action/onclick/tail_sweep/pathogen
	button_icon_state = "template_pathogen"
	icon_file = 'icons/mob/hud/actions_pathogen.dmi'

/datum/behavior_delegate/pathogen_base/archon
	name = "Base Archon Behavior Delegate"

	var/lifesteal_percent = 2
	var/max_lifesteal = 5
	var/lifesteal_range =  3 // Marines within 3 tiles of range will give extra health
	var/lifesteal_lock_duration = 20 // This will remove the glow effect after 2 seconds
	var/color = "#999b7c"
	var/emote_cooldown = 0

	var/kills = 0
	var/max_kills = 20

/datum/behavior_delegate/pathogen_base/archon/append_to_stat()
	. = list()
	. += "Kills: [kills]/[max_kills]"

/datum/behavior_delegate/pathogen_base/archon/on_kill_mob(mob/M)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/pathogen_base/archon/melee_attack_modify_damage(original_damage, mob/living/carbon/attacked_mob)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/attacked_human = attacked_mob
		if(isspeciesyautja(attacked_human))
			original_damage *= 1.5

	return original_damage + kills

/datum/behavior_delegate/pathogen_base/archon/melee_attack_additional_effects_target(mob/living/carbon/carbon)
	..()

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	var/final_lifesteal = lifesteal_percent
	var/list/mobs_in_range = oviewers(lifesteal_range, bound_xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(final_lifesteal >= max_lifesteal)
			break

		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(bound_xeno.can_not_harm(mob))
			continue

		final_lifesteal++

// This part is then outside the for loop
		if(final_lifesteal >= max_lifesteal)
			bound_xeno.add_filter("self_heal", 1, list("type" = "outline", "color" = color, "size" = 1, "alpha" = 90))
			bound_xeno.visible_message(SPAN_DANGER("[bound_xeno.name] glows as it heals even more from its injuries!"), SPAN_XENODANGER("We glow as we heal even more from our injuries!"))
			bound_xeno.flick_heal_overlay(2 SECONDS, "#00B800")
		if(istype(bound_xeno) && world.time > emote_cooldown && bound_xeno)
			bound_xeno.emote("roar")
			bound_xeno.xeno_jitter(1 SECONDS)
			emote_cooldown = world.time + 5 SECONDS
		addtimer(CALLBACK(src, PROC_REF(lifesteal_lock)), lifesteal_lock_duration/2)

	bound_xeno.gain_health(clamp(final_lifesteal / 100 * (bound_xeno.maxHealth - bound_xeno.health), 20, 40))

/datum/behavior_delegate/pathogen_base/archon/proc/lifesteal_lock()
	bound_xeno.remove_filter("self_heal")
