#define XENO_QUEEN_AGE_TIME (10 MINUTES)
#define XENO_QUEEN_TEMP_AGE_DURATION (1 MINUTES)
#define XENO_QUEEN_TEMP_AGE_EXTENSION (15 SECONDS)
#define XENO_QUEEN_DEATH_DELAY (5 MINUTES)
#define YOUNG_QUEEN_HEALTH_MULTIPLIER 0.5

/datum/caste_datum/queen
	caste_type = XENO_CASTE_QUEEN
	tier = 0

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_9 //Queen and Ravs have extra multiplier when dealing damage in multitile_interaction.dm
	max_health = XENO_HEALTH_QUEEN
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_QUEEN

	build_time_mult = BUILD_TIME_MULT_BUILDER

	is_intelligent = 1
	evolution_allowed = FALSE
	caste_desc = "The Queen, in all her glory."
	spit_types = list(/datum/ammo/xeno/toxin/queen, /datum/ammo/xeno/acid/spatter)
	can_hold_facehuggers = 0
	can_hold_eggs = CAN_HOLD_ONE_HAND
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	can_be_revived = FALSE

	behavior_delegate_type = /datum/behavior_delegate/queen

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 55

	aura_strength = 4
	tacklestrength_min = 5
	tacklestrength_max = 6

	minimum_xeno_playtime = 9 HOURS
	minimum_evolve_time = 0

	minimap_icon = "xenoqueen"
	minimap_background = "xeno_ruler"

	royal_caste = TRUE


/proc/update_living_queens() // needed to update when you change a queen to a different hive
	outer_loop:
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.living_xeno_queen)
				if(hive.living_xeno_queen.hivenumber == hive.hivenumber)
					continue
			for(var/mob/living/carbon/xenomorph/queen/Q in GLOB.living_xeno_list)
				if(Q.hivenumber == hive.hivenumber && !should_block_game_interaction(Q))
					hive.living_xeno_queen = Q
					xeno_message(SPAN_XENOANNOUNCE("A new Queen has risen to lead the Hive! Rejoice!"),3,hive.hivenumber)
					continue outer_loop
			hive.living_xeno_queen = null

/mob/hologram/queen
	name = "Queen Eye"
	action_icon_state = "queen_exit"
	motion_sensed = TRUE

	color = "#a800a8"

	hud_possible = list(XENO_STATUS_HUD)

	var/mob/is_watching

	var/hivenumber = XENO_HIVE_NORMAL
	var/next_point = 0

	var/point_delay = 1 SECONDS


/mob/hologram/queen/Initialize(mapload, mob/living/carbon/xenomorph/viewing_xeno)
	if(!viewing_xeno)
		return INITIALIZE_HINT_QDEL

	var/datum/hive_status/hive = viewing_xeno.hive
	if(!hive)
		return INITIALIZE_HINT_QDEL

	if(!isqueen(viewing_xeno) && !(hive.living_xeno_queen == viewing_xeno))
		return INITIALIZE_HINT_QDEL

	var/mob/living/carbon/xenomorph/queen/viewing_queen = viewing_xeno
	if(istype(viewing_queen))
		if(!hive.allow_no_queen_actions && !viewing_queen.ovipositor)
			return INITIALIZE_HINT_QDEL

	// Make sure to turn off any previous overwatches
	viewing_xeno.overwatch(stop_overwatch = TRUE)

	. = ..()
	RegisterSignal(viewing_xeno, COMSIG_MOB_PRE_CLICK, PROC_REF(handle_overwatch))
	RegisterSignal(viewing_xeno, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, PROC_REF(exit_hologram))
	RegisterSignal(viewing_xeno, COMSIG_XENO_OVERWATCH_XENO, PROC_REF(start_watching))
	RegisterSignal(viewing_xeno, list(
		COMSIG_XENO_STOP_OVERWATCH,
		COMSIG_XENO_STOP_OVERWATCH_XENO
	), PROC_REF(stop_watching))
	RegisterSignal(viewing_xeno, COMSIG_MOB_REAL_NAME_CHANGED, PROC_REF(on_name_changed))
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(turf_weed_only))

	// Default color
	if(viewing_xeno.hive.color)
		color = viewing_xeno.hive.color

	hivenumber = viewing_xeno.hivenumber
	med_hud_set_status()
	add_to_all_mob_huds()

	viewing_xeno.sight |= SEE_TURFS|SEE_OBJS

/mob/hologram/queen/proc/exit_hologram()
	SIGNAL_HANDLER

	var/obj/structure/tent/tent = locate() in ((get_turf(linked_mob)).contents)

	var/atom/movable/screen/plane_master/roof/roof_plane = linked_mob.hud_used.plane_masters["[ROOF_PLANE]"]

	if(!tent)
		roof_plane?.invisibility = 0
	else if (roof_plane?.invisibility == 0)
		roof_plane?.invisibility = INVISIBILITY_MAXIMUM

	qdel(src)

/mob/hologram/queen/handle_move(mob/living/carbon/xenomorph/X, NewLoc, direct)
	if(is_watching && (turf_weed_only(src, is_watching.loc) & COMPONENT_TURF_DENY_MOVEMENT))
		return COMPONENT_OVERRIDE_MOVE

	X.overwatch(stop_overwatch = TRUE)

	return ..()


/mob/hologram/queen/proc/start_watching(mob/living/carbon/xenomorph/X, mob/living/carbon/xenomorph/target)
	SIGNAL_HANDLER
	forceMove(target)
	is_watching = target

	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_watching_qdeleted))
	return

// able to stop watching here before the loc is set to null
/mob/hologram/queen/proc/target_watching_qdeleted(mob/living/carbon/xenomorph/target)
	SIGNAL_HANDLER
	stop_watching(linked_mob, target)

/mob/hologram/queen/proc/stop_watching(mob/living/carbon/xenomorph/X, mob/living/carbon/xenomorph/target)
	SIGNAL_HANDLER
	if(target)
		if(loc == target)
			var/turf/T = get_turf(target)

			if(T)
				forceMove(T)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)

	if(!isturf(loc) || (turf_weed_only(src, loc) & COMPONENT_TURF_DENY_MOVEMENT))
		forceMove(X.loc)

	is_watching = null
	X.reset_view()
	return

/mob/hologram/queen/proc/on_name_changed(mob/parent, old_name, new_name)
	SIGNAL_HANDLER
	name = "[initial(src.name)] ([new_name])"

/mob/hologram/queen/proc/turf_weed_only(mob/self, turf/crossing_turf)
	SIGNAL_HANDLER

	if(!crossing_turf)
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(crossing_turf, /turf/closed/wall))
		var/turf/closed/wall/crossing_wall = crossing_turf
		if(crossing_wall.turf_flags & TURF_HULL)
			return COMPONENT_TURF_DENY_MOVEMENT

	var/list/turf_area = range(3, crossing_turf)

	var/obj/effect/alien/weeds/nearby_weeds = locate() in turf_area
	if(nearby_weeds && HIVE_ALLIED_TO_HIVE(nearby_weeds.hivenumber, hivenumber))
		var/obj/effect/alien/crossing_turf_weeds = locate() in crossing_turf
		if(crossing_turf_weeds && !(crossing_turf_weeds.hivenumber == XENO_HIVE_PATHOGEN))
			crossing_turf_weeds.update_icon() //randomizes the icon of the turf when crossed over*/
		return COMPONENT_TURF_ALLOW_MOVEMENT

	return COMPONENT_TURF_DENY_MOVEMENT

/mob/hologram/queen/proc/handle_overwatch(mob/living/carbon/xenomorph/queen/Q, atom/A, mods)
	SIGNAL_HANDLER

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(mods[SHIFT_CLICK] && mods[MIDDLE_CLICK])
		if(next_point > world.time)
			return COMPONENT_INTERRUPT_CLICK

		next_point = world.time + point_delay

		var/message = SPAN_XENONOTICE("[Q] points at [A].")

		to_chat(Q, message)
		for(var/mob/living/carbon/xenomorph/X in viewers(7, src))
			if(X == Q)
				continue
			to_chat(X, message)

		var/obj/effect/overlay/temp/point/big/queen/point = new(T, src, A)
		point.color = color

		return COMPONENT_INTERRUPT_CLICK

	if(!mods[CTRL_CLICK])
		return

	if(isxeno(A))
		var/mob/living/carbon/xenomorph/X = A
		if(X.ally_of_hivenumber(hivenumber))
			Q.overwatch(A)
		return COMPONENT_INTERRUPT_CLICK

	if(!(turf_weed_only(src, T) & COMPONENT_TURF_ALLOW_MOVEMENT))
		return

	forceMove(T)
	if(is_watching)
		Q.overwatch(stop_overwatch = TRUE)

	return COMPONENT_INTERRUPT_CLICK

/mob/hologram/queen/handle_view(mob/M, atom/target)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE

		if(is_watching)
			M.client.set_eye(is_watching)
		else
			M.client.set_eye(src)

	return COMPONENT_OVERRIDE_VIEW

/mob/hologram/queen/Destroy()
	if(linked_mob)
		var/mob/living/carbon/xenomorph/queen/Q = linked_mob
		if((Q.hive.living_xeno_queen == Q) || (istype(Q) && Q.ovipositor))
			give_action(linked_mob, /datum/action/xeno_action/onclick/eye)

		linked_mob.sight &= ~(SEE_TURFS|SEE_OBJS)

	remove_from_all_mob_huds()
	is_watching = null

	return ..()

/mob/living/carbon/xenomorph/queen
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_QUEEN
	name = XENO_CASTE_QUEEN
	desc = "A huge, looming alien creature. The biggest and the baddest."
	icon_size = 64
	icon_state = "Queen Walking"
	plasma_types = list(PLASMA_ROYAL,PLASMA_CHITIN,PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	attacktext = "bites"
	attack_sound = null
	friendly = "nuzzles"
	wall_smash = 0
	pixel_x = -29 //new offsets for the much bigger sprite.
	old_x = -29
	xenonid_pixel_x = -16
	mob_size = MOB_SIZE_IMMOBILE
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 0 //Queen doesn't count towards population limit.
	hive_pos = XENO_QUEEN
	small_explosives_stun = FALSE
	pull_speed = 3 //screech/neurodragging is cancer, at the very absolute least get some runner to do it for teamwork
	organ_value = 8000 // queen is expensive
	claw_type = CLAW_TYPE_VERY_SHARP
	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE|FIRE_IMMUNITY_NO_IGNITE

	icon_xeno = 'icons/mob/xenos/castes/tier_4/queen.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_4/queen.dmi'

	acid_overlay = icon('icons/mob/xenos/castes/tier_4/queen.dmi', "Queen-Spit")

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Queen_1","Queen_2","Queen_3")
	weed_food_states_flipped = list("Queen_1","Queen_2","Queen_3")

	var/breathing_counter = 0
	var/ovipositor = FALSE //whether the Queen is attached to an ovipositor
	var/queen_ability_cooldown = 0
	var/egg_amount = 0 //amount of eggs inside the queen
	var/screech_sound_effect_list = list('sound/voice/alien_queen_screech.ogg') //the noise the Queen makes when she screeches. Done this way for VV purposes.
	var/queen_ovipositor_icon
	var/queen_standing_icon

	tileoffset = 0
	viewsize = 12

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction/not_primary, //normally fifth macro but not as important for queen
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro, and fits near the resin structure buttons
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/grow_ovipositor,
		/datum/action/xeno_action/activable/info_marker/queen,
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/onclick/toggle_seethrough,
	)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/claw_toggle,
		/mob/living/carbon/xenomorph/proc/construction_toggle,
		/mob/living/carbon/xenomorph/proc/destruction_toggle,
		/mob/living/carbon/xenomorph/proc/unnesting_toggle,
		/mob/living/carbon/xenomorph/proc/set_orders,
		/mob/living/carbon/xenomorph/proc/hive_message,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	var/list/mobile_abilities = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction/not_primary, //normally fifth macro but not as important for queen
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro, and fits near the resin structure buttons
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/grow_ovipositor,
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/activable/info_marker/queen,
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		/datum/action/xeno_action/activable/xeno_spit/queen_macro, //third macro
		/datum/action/xeno_action/onclick/shift_spits,
		//second macro
	)

	// Abilities they get when they've successfully aged.
	var/mobile_aged_abilities = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		/datum/action/xeno_action/activable/xeno_spit/queen_macro, //third macro
		/datum/action/xeno_action/onclick/shift_spits, //second macro
	)

	skull = /obj/item/skull/queen
	pelt = /obj/item/pelt/queen

	/// Whether queen has completed normal maturity
	var/queen_aged = FALSE
	/// Normal maturity timer
	var/queen_age_timer_id = TIMER_ID_NULL
	/// Temporary maturity timer
	var/queen_age_temp_timer_id = TIMER_ID_NULL

	bubble_icon = "alienroyal"

/mob/living/carbon/xenomorph/queen/set_resting(new_resting, silent, instant)
	if(ovipositor && new_resting)
		return
	return ..()

/mob/living/carbon/xenomorph/queen/get_organ_icon()
	return "heart_t3"

/mob/living/carbon/xenomorph/queen/corrupted
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_CORRUPTED

/mob/living/carbon/xenomorph/queen/forsaken
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_FORSAKEN

/mob/living/carbon/xenomorph/queen/forsaken/combat_ready
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_FORSAKEN
	queen_aged = TRUE

/mob/living/carbon/xenomorph/queen/alpha
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_ALPHA

/mob/living/carbon/xenomorph/queen/bravo
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_BRAVO

/mob/living/carbon/xenomorph/queen/charlie
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_CHARLIE

/mob/living/carbon/xenomorph/queen/delta
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_DELTA

/mob/living/carbon/xenomorph/queen/k_series
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_K_SERIES

/mob/living/carbon/xenomorph/queen/mutated
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_MUTATED

/mob/living/carbon/xenomorph/queen/combat_ready
	AUTOWIKI_SKIP(FALSE)
	queen_aged = TRUE

/mob/living/carbon/xenomorph/queen/Initialize()
	. = ..()
	SStracking.set_leader("hive_[hivenumber]", src)
	if(!should_block_game_interaction(src))//so admins can safely spawn Queens in Thunderdome for tests.
		xeno_message(SPAN_XENOANNOUNCE("A new Queen has risen to lead the Hive! Rejoice!"),3,hivenumber)
		notify_ghosts(header = "New Queen", message = "A new Queen has risen.", source = src, action = NOTIFY_ORBIT)
	playsound(loc, 'sound/voice/alien_queen_command.ogg', 75, 0)
	set_resin_build_order(GLOB.resin_build_order_drone)
	for(var/datum/action/xeno_action/action in actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			choose_resin_ability.update_button_icon(selected_resin)
			break // Don't need to keep looking

	if(hive.dynamic_evolution && !queen_aged)
		queen_age_timer_id = addtimer(CALLBACK(src, PROC_REF(make_combat_effective)), XENO_QUEEN_AGE_TIME, TIMER_UNIQUE|TIMER_STOPPABLE)
	else
		make_combat_effective()

	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	if(hive.hivenumber == XENO_HIVE_NORMAL)
		AddComponent(/datum/component/tacmap, has_drawing_tools=TRUE, minimap_flag=get_minimap_flag_for_faction(hive.hivenumber), has_update=TRUE, drawing=TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_block))

/mob/living/carbon/xenomorph/queen/proc/check_block(mob/queen, turf/new_loc)
	SIGNAL_HANDLER
	if(body_position == LYING_DOWN || stat == UNCONSCIOUS)
		return
	for(var/mob/living/carbon/xenomorph/xeno in new_loc.contents)
		if(xeno.stat == DEAD)
			continue
		if(xeno.pass_flags.flags_pass & (PASS_MOB_THRU_XENO|PASS_MOB_THRU) || xeno.flags_pass_temp & PASS_MOB_THRU)
			continue
		if(xeno.hivenumber == hivenumber && !(queen.client?.prefs?.toggle_prefs & TOGGLE_AUTO_SHOVE_OFF))
			xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
			playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)

/mob/living/carbon/xenomorph/queen/generate_name()
	if(!nicknumber)
		generate_and_set_nicknumber()
	var/name_prefix = hive.prefix
	if(queen_aged)
		age_xeno()
		switch(age)
			if(XENO_YOUNG)
				name = "[name_prefix]Young Queen" //Young
			if(XENO_NORMAL)
				name = "[name_prefix]Queen"  //Regular
			if(XENO_MATURE)
				name = "[name_prefix]Empress"  //Mature
			if(XENO_ELDER)
				name = "[name_prefix]Elder Empress"  //Elite
			if(XENO_ANCIENT)
				name = "[name_prefix]Ancient Empress"  //Ancient
			if(XENO_PRIME)
				name = "[name_prefix]Prime Empress" //Prime
	else
		age = XENO_NORMAL
		if(client)
			hud_update()

		name = "[name_prefix]Immature Queen"

	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
		if(client?.prefs?.show_queen_name)
			name += " (" + replacetext((name_client_prefix + name_client_postfix), "-","") + ")"


	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"

	//Update linked data so they show up properly
	change_real_name(src, name)

/mob/living/carbon/xenomorph/queen/set_hive_and_update(new_hivenumber)
	if(!..())
		return FALSE
	update_living_queens()

/// Signal handler for COMSIG_MOB_TAKE_DAMAGE intended to extend temporary maturity by XENO_QUEEN_TEMP_AGE_EXTENSION up to XENO_QUEEN_TEMP_AGE_DURATION
/mob/living/carbon/xenomorph/queen/proc/on_take_damage(owner, damage_data, damage_type)
	SIGNAL_HANDLER
	if(queen_age_temp_timer_id == TIMER_ID_NULL)
		CRASH("[src] called on_take_damage when not temporarily mature!")
	if(damage_data["enviro"])
		return
	var/damage = damage_data["damage"]
	if(damage < 5)
		return
	var/new_duration = min(timeleft(queen_age_temp_timer_id) + XENO_QUEEN_TEMP_AGE_EXTENSION, XENO_QUEEN_TEMP_AGE_DURATION)
	queen_age_temp_timer_id = addtimer(CALLBACK(src, PROC_REF(refresh_combat_effective)), new_duration, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)

/// Performs all updates to abilities, name, and health depending on maturity
/mob/living/carbon/xenomorph/queen/proc/refresh_combat_effective()
	if(queen_age_temp_timer_id != TIMER_ID_NULL && isnull(timeleft(queen_age_temp_timer_id)))
		queen_age_temp_timer_id = TIMER_ID_NULL
		UnregisterSignal(src, COMSIG_MOB_TAKE_DAMAGE)

	refresh_combat_abilities()
	recalculate_actions()
	recalculate_health()
	generate_name()

/// Matures the queen either permanently or temporarily
/mob/living/carbon/xenomorph/queen/proc/make_combat_effective(temporary=FALSE)
	if(temporary)
		if(timeleft(queen_age_timer_id) <= XENO_QUEEN_TEMP_AGE_DURATION)
			// Just give them full maturity
			temporary = FALSE
		else
			var/already_temp_mature = queen_age_temp_timer_id != TIMER_ID_NULL
			if(!already_temp_mature)
				RegisterSignal(src, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_take_damage))
			queen_age_temp_timer_id = addtimer(CALLBACK(src, PROC_REF(refresh_combat_effective)), XENO_QUEEN_TEMP_AGE_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)
			if(already_temp_mature)
				return

	if(!temporary)
		queen_aged = TRUE
		if(queen_age_timer_id != TIMER_ID_NULL)
			deltimer(queen_age_timer_id)
			queen_age_timer_id = TIMER_ID_NULL
		if(queen_age_temp_timer_id != TIMER_ID_NULL)
			deltimer(queen_age_temp_timer_id)
			queen_age_temp_timer_id = TIMER_ID_NULL
			UnregisterSignal(src, COMSIG_MOB_TAKE_DAMAGE)

	refresh_combat_effective()

/mob/living/carbon/xenomorph/queen/proc/end_temporary_maturity()
	if(queen_age_temp_timer_id == TIMER_ID_NULL)
		return
	deltimer(queen_age_temp_timer_id)
	queen_age_temp_timer_id = TIMER_ID_NULL
	UnregisterSignal(src, COMSIG_MOB_TAKE_DAMAGE)
	refresh_combat_effective()

/// When not on ovipositor, refreshes all mobile_abilities including mobile_aged_abilities if applicable
/mob/living/carbon/xenomorph/queen/proc/refresh_combat_abilities()
	if(ovipositor)
		return

	for(var/datum/action/xeno_action/action in actions)
		action.hide_from(src)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			choose_resin_ability.update_button_icon(selected_resin)

	var/list/abilities_to_give = mobile_abilities.Copy()

	if(!queen_aged && queen_age_temp_timer_id == TIMER_ID_NULL)
		abilities_to_give -= mobile_aged_abilities

	for(var/path in abilities_to_give)
		give_action(src, path)


/mob/living/carbon/xenomorph/queen/recalculate_health()
	. = ..()
	if(!queen_aged && queen_age_temp_timer_id == TIMER_ID_NULL)
		maxHealth *= YOUNG_QUEEN_HEALTH_MULTIPLIER

	if(health > maxHealth)
		health = maxHealth

/mob/living/carbon/xenomorph/queen/Destroy()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)

	if(hive && hive.living_xeno_queen == src)
		var/mob/living/carbon/xenomorph/queen/next_queen = null
		for(var/mob/living/carbon/xenomorph/queen/queen in hive.totalXenos)
			if(!should_block_game_interaction(queen) && queen != src && !QDELETED(queen))
				next_queen = queen
				break
		hive.set_living_xeno_queen(next_queen) // either null or a queen

	return ..()

/mob/living/carbon/xenomorph/queen/Life(delta_time)
	..()

	if(stat != DEAD)
		if(++breathing_counter >= rand(22, 27)) //Increase the breathing variable each tick. Play it at random intervals.
			playsound(loc, pick('sound/voice/alien_queen_breath1.ogg', 'sound/voice/alien_queen_breath2.ogg'), 15, 1, 4)
			breathing_counter = 0 //Reset the counter

		if(observed_xeno)
			if(observed_xeno.stat == DEAD || QDELETED(observed_xeno))
				overwatch(observed_xeno, TRUE)

		if(ovipositor && !is_mob_incapacitated(TRUE))
			egg_amount += 0.07 //one egg approximately every 30 seconds
			if(egg_amount >= 1)
				if(isturf(loc))
					var/turf/T = loc
					if(length(T.contents) <= 25) //so we don't end up with a million object on that turf.
						egg_amount--
						new /obj/item/xeno_egg(loc, hivenumber)
			overlays -= acid_overlay

		// Grant temporary maturity if near the hive_location for early game
		if(!queen_aged)
			// Explicitly requires queen to not be inside something (e.g. a tunnel)
			var/near_hive = hive?.hive_location && loc == get_turf(src) && (get_area(hive.hive_location) == get_area(src) || get_dist(hive.hive_location, src) <= 10)
			if(near_hive && ROUND_TIME < XENO_QUEEN_AGE_TIME * 2 && !is_mob_incapacitated(TRUE))
				make_combat_effective(temporary=TRUE)
			else if(queen_age_temp_timer_id != TIMER_ID_NULL)
				var/alert_time = timeleft(queen_age_temp_timer_id) - XENO_QUEEN_TEMP_AGE_EXTENSION * 0.5
				if(alert_time >= 0 && alert_time < delta_time SECONDS) // Only display once at a threshold within delta_time
					balloon_alert(src, "our maturity wanes soon!", text_color = "#7d32bb")

/mob/living/carbon/xenomorph/queen/get_status_tab_items()
	. = ..()
	var/stored_larvae = GLOB.hive_datum[hivenumber].stored_larva
	var/xeno_leader_num = hive?.queen_leader_limit - length(hive?.open_xeno_leader_positions)

	. += "Pooled Larvae: [stored_larvae]"
	. += "Leaders: [xeno_leader_num] / [hive?.queen_leader_limit]"
	. += "Royal Resin: [hive?.buff_points]"
	if(!queen_aged)
		if(queen_age_timer_id != TIMER_ID_NULL)
			. += "Maturity: [time2text(timeleft(queen_age_timer_id), "mm:ss")] remaining"
		if(queen_age_temp_timer_id != TIMER_ID_NULL)
			. += "Temporary Maturity: [time2text(timeleft(queen_age_temp_timer_id), "mm:ss")] remaining"

/mob/living/carbon/xenomorph/queen/handle_screech_act(mob/self, mob/living/carbon/xenomorph/queen/queen)
	return COMPONENT_SCREECH_ACT_CANCEL

/mob/living/carbon/xenomorph/queen/proc/screech_ready()
	to_chat(src, SPAN_WARNING("You feel your throat muscles vibrate. You are ready to screech again."))
	for(var/Z in actions)
		var/datum/action/A = Z
		A.update_button_icon()

/mob/living/carbon/xenomorph/queen/death(cause, gibbed)
	if(src == hive?.living_xeno_queen)
		UnregisterSignal(src, COMSIG_MOVABLE_PRE_MOVE)
		hive.xeno_queen_timer = world.time + XENO_QUEEN_DEATH_DELAY

		// Reset the banished ckey list
		if(length(hive.banished_ckeys))
			for(var/mob/living/carbon/xenomorph/target_xeno in hive.totalXenos)
				if(!target_xeno.ckey)
					continue
				for(var/mob_name in hive.banished_ckeys)
					if(target_xeno.ckey == hive.banished_ckeys[mob_name])
						target_xeno.banished = FALSE
						target_xeno.hud_update_banished()
						target_xeno.lock_evolve = FALSE
			hive.banished_ckeys = list()

	icon = queen_standing_icon
	return ..()

/mob/living/carbon/xenomorph/queen/proc/mount_ovipositor()
	if(ovipositor)
		return //sanity check
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, OVIPOSITOR_TRAIT)
	set_body_position(STANDING_UP)
	set_resting(FALSE)
	ovipositor = TRUE

	set_resin_build_order(GLOB.resin_build_order_ovipositor) // This needs to occur before we update the abilities so we can update the choose resin icon
	for(var/datum/action/xeno_action/action in actions)
		action.hide_from(src)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			choose_resin_ability.update_button_icon(selected_resin)

	var/list/immobile_abilities = list(
		// These already have their placement locked in:
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/place_construction/not_primary,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/activable/info_marker/queen,
		// Screech is typically new for this list, but its possible they never ovi and it then is forced here:
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		// These are new and their arrangement matters:
		/datum/action/xeno_action/onclick/remove_eggsac,
		/datum/action/xeno_action/onclick/set_xeno_lead,
		/datum/action/xeno_action/activable/queen_heal, //first macro
		/datum/action/xeno_action/activable/queen_give_plasma, //second macro
		/datum/action/xeno_action/activable/expand_weeds, //third macro
		/datum/action/xeno_action/activable/secrete_resin/remote/queen, //fifth macro
		/datum/action/xeno_action/onclick/eye,
	)

	for(var/path in immobile_abilities)
		give_action(src, path)

	ADD_TRAIT(src, TRAIT_ABILITY_NO_PLASMA_TRANSFER, TRAIT_SOURCE_ABILITY("Ovipositor"))
	ADD_TRAIT(src, TRAIT_ABILITY_OVIPOSITOR, TRAIT_SOURCE_ABILITY("Ovipositor"))

	extra_build_dist = IGNORE_BUILD_DISTANCE
	egg_planting_range = 3
	anchored = TRUE
	resting = FALSE
	update_icons()
	bubble_icon_x_offset = 32
	bubble_icon_y_offset = 32

	for(var/mob/living/carbon/xenomorph/leader in hive.xeno_leader_list)
		leader.handle_xeno_leader_pheromones()

	xeno_message(SPAN_XENOANNOUNCE("The Queen has grown an ovipositor, evolution progress resumed."), 3, hivenumber)

	// If minimap was open before going on ovi, switch to drawing tools version
	var/datum/action/minimap/minimap_action = locate() in actions
	if(minimap_action?.minimap_displayed)
		minimap_action.toggle_minimap(FALSE)
		var/datum/component/tacmap/tacmap_component = GetComponent(/datum/component/tacmap)
		if(tacmap_component)
			tacmap_component.show_tacmap(src)

	START_PROCESSING(SShive_status, hive.hive_ui)

	SEND_SIGNAL(src, COMSIG_QUEEN_MOUNT_OVIPOSITOR)

/mob/living/carbon/xenomorph/queen/proc/dismount_ovipositor(instant_dismount)
	set waitfor = 0
	if(!instant_dismount)
		if(observed_xeno)
			overwatch(observed_xeno, TRUE)
		flick("ovipositor_dismount", src)
		sleep(5)
	else
		flick("ovipositor_dismount_destroyed", src)
		sleep(5)

	if(!ovipositor)
		return
	ovipositor = FALSE
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, OVIPOSITOR_TRAIT)
	update_icons()
	bubble_icon_x_offset = initial(bubble_icon_x_offset)
	bubble_icon_y_offset = initial(bubble_icon_y_offset)
	new /obj/ovipositor(loc)

	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	zoom_out()

	set_resin_build_order(GLOB.resin_build_order_drone) // This needs to occur before we update the abilities so we can update the choose resin icon
	refresh_combat_abilities()

	REMOVE_TRAIT(src, TRAIT_ABILITY_NO_PLASMA_TRANSFER, TRAIT_SOURCE_ABILITY("Ovipositor"))
	REMOVE_TRAIT(src, TRAIT_ABILITY_OVIPOSITOR, TRAIT_SOURCE_ABILITY("Ovipositor"))

	recalculate_actions()

	egg_amount = 0
	extra_build_dist = initial(extra_build_dist)
	egg_planting_range = initial(egg_planting_range)
	for(var/datum/action/xeno_action/action in actions)
		if(istype(action, /datum/action/xeno_action/onclick/grow_ovipositor))
			var/datum/action/xeno_action/onclick/grow_ovipositor/ovi_ability = action
			ovi_ability.apply_cooldown()
			break
	anchored = FALSE

	for(var/mob/living/carbon/xenomorph/L in hive.xeno_leader_list)
		L.handle_xeno_leader_pheromones()

	if(!instant_dismount)
		xeno_message(SPAN_XENOANNOUNCE("The Queen has shed her ovipositor, evolution progress paused."), 3, hivenumber)

	// Close tacmap drawing tools if open, and reopen the regular minimap
	var/datum/component/tacmap/tacmap_component = GetComponent(/datum/component/tacmap)
	var/had_tacmap_open = FALSE
	if(tacmap_component && (src in tacmap_component.interactees))
		tacmap_component.on_unset_interaction(src)
		tacmap_component.close_popout_tacmaps(src)
		had_tacmap_open = TRUE

	if(had_tacmap_open)
		var/datum/action/minimap/minimap_action = locate() in actions
		if(minimap_action && !minimap_action.minimap_displayed)
			minimap_action.action_activate()

	SEND_SIGNAL(src, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, instant_dismount)

/mob/living/carbon/xenomorph/queen/handle_special_state()
	if(ovipositor)
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/queen/handle_special_wound_states(severity)
	. = ..()
	if(ovipositor)
		return "Queen_ovipositor_[severity]" // I don't actually have it, but maybe one day.

/mob/living/carbon/xenomorph/queen/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, 1)

/datum/behavior_delegate/queen
	name = "Queen Behavior Delegate"

/datum/behavior_delegate/queen/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	var/mob/living/carbon/xenomorph/queen/Queen = bound_xeno
	if(Queen.ovipositor)
		Queen.icon = Queen.queen_ovipositor_icon
		Queen.icon_state = "[Queen.get_strain_name()] Queen Ovipositor"
		return TRUE

	// Switch icon back and then let normal icon behavior happen
	Queen.icon = Queen.queen_standing_icon

/mob/living/carbon/xenomorph/queen/alter_ghost(mob/dead/observer/ghost)
	ghost.icon = queen_standing_icon
	return ..()

/mob/living/carbon/xenomorph/queen/point_to_atom(atom/target_atom, turf/target_turf)
	recently_pointed_to = world.time + 1 SECONDS

	var/obj/effect/overlay/temp/point/big/greyscale/point = new(target_turf, src, target_atom)
	point.color = "#a800a8"

	visible_message("<b>[src]</b> points to [target_atom]", null, null, 5)

#undef XENO_QUEEN_AGE_TIME
#undef XENO_QUEEN_TEMP_AGE_DURATION
#undef XENO_QUEEN_TEMP_AGE_EXTENSION
#undef XENO_QUEEN_DEATH_DELAY
#undef YOUNG_QUEEN_HEALTH_MULTIPLIER
