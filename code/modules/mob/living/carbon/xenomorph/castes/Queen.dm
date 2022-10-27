#define XENO_QUEEN_AGE_TIME	(10 MINUTES)
#define XENO_QUEEN_DEATH_DELAY (5 MINUTES)
#define YOUNG_QUEEN_HEALTH_MULTIPLIER 0.5

/datum/caste_datum/queen
	caste_type = XENO_CASTE_QUEEN
	tier = 0

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_9	//Queen and Ravs have extra multiplier when dealing damage in multitile_interaction.dm
	max_health = XENO_HEALTH_QUEEN
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_10
	crystal_max = XENO_CRYSTAL_MEDIUM
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_QUEEN

	build_time_mult = BUILD_TIME_MULT_BUILDER

	is_intelligent = 1
	evolution_allowed = FALSE
	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE|FIRE_IMMUNITY_NO_IGNITE
	caste_desc = "The biggest and baddest xeno. The Queen controls the hive and plants eggs"
	spit_types = list(/datum/ammo/xeno/toxin/queen, /datum/ammo/xeno/acid/medium)
	can_hold_facehuggers = 0
	can_hold_eggs = CAN_HOLD_ONE_HAND
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	can_be_revived = FALSE

	behavior_delegate_type = /datum/behavior_delegate/queen

	spit_delay = 25

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 55

	aura_strength = 4
	tacklestrength_min = 5
	tacklestrength_max = 6

	minimum_xeno_playtime = 9 HOURS

/proc/update_living_queens() // needed to update when you change a queen to a different hive
	outer_loop:
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.living_xeno_queen)
				if(hive.living_xeno_queen.hivenumber == hive.hivenumber)
					continue
			for(var/mob/living/carbon/Xenomorph/Queen/Q in GLOB.living_xeno_list)
				if(Q.hivenumber == hive.hivenumber && !is_admin_level(Q.z))
					hive.living_xeno_queen = Q
					xeno_message(SPAN_XENOANNOUNCE("A new Queen has risen to lead the Hive! Rejoice!"),3,hive.hivenumber)
					continue outer_loop
			hive.living_xeno_queen = null

/mob/hologram/queen
	name = "Queen Eye"
	action_icon_state = "queen_exit"

	color = "#a800a8"

	hud_possible = list(XENO_STATUS_HUD)
	var/mob/is_watching

	var/hivenumber = XENO_HIVE_NORMAL
	var/next_point = 0

	var/point_delay = 1 SECONDS


/mob/hologram/queen/Initialize(mapload, mob/living/carbon/Xenomorph/Queen/Q)
	if(!istype(Q))
		stack_trace("Tried to initialize a /mob/hologram/queen on type ([Q.type])")
		return INITIALIZE_HINT_QDEL

	if(!Q.ovipositor)
		return INITIALIZE_HINT_QDEL

	// Make sure to turn off any previous overwatches
	Q.overwatch(stop_overwatch = TRUE)

	. = ..()
	RegisterSignal(Q, COMSIG_MOB_PRE_CLICK, .proc/handle_overwatch)
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, .proc/exit_hologram)
	RegisterSignal(Q, COMSIG_XENO_OVERWATCH_XENO, .proc/start_watching)
	RegisterSignal(Q, list(
		COMSIG_XENO_STOP_OVERWATCH,
		COMSIG_XENO_STOP_OVERWATCH_XENO
	), .proc/stop_watching)
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, .proc/turf_weed_only)

	// Default colour
	if(Q.hive.color)
		color = Q.hive.color

	hivenumber = Q.hivenumber
	med_hud_set_status()
	add_to_all_mob_huds()

	Q.sight |= SEE_TURFS|SEE_OBJS

/mob/hologram/queen/proc/exit_hologram()
	SIGNAL_HANDLER
	qdel(src)

/mob/hologram/queen/handle_move(mob/living/carbon/Xenomorph/X, NewLoc, direct)
	if(is_watching && (turf_weed_only(src, is_watching.loc) & COMPONENT_TURF_DENY_MOVEMENT))
		return COMPONENT_OVERRIDE_MOVE

	X.overwatch(stop_overwatch = TRUE)

	return ..()


/mob/hologram/queen/proc/start_watching(var/mob/living/carbon/Xenomorph/X, var/mob/living/carbon/Xenomorph/target)
	SIGNAL_HANDLER
	forceMove(target)
	is_watching = target

	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/target_watching_qdeleted)
	return

// able to stop watching here before the loc is set to null
/mob/hologram/queen/proc/target_watching_qdeleted(var/mob/living/carbon/Xenomorph/target)
	SIGNAL_HANDLER
	stop_watching(linked_mob, target)

/mob/hologram/queen/proc/stop_watching(var/mob/living/carbon/Xenomorph/X, var/mob/living/carbon/Xenomorph/target)
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

/mob/hologram/queen/proc/turf_weed_only(var/mob/self, var/turf/T)
	SIGNAL_HANDLER

	if(!T)
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(T, /turf/closed/wall))
		var/turf/closed/wall/W = T
		if(W.hull)
			return COMPONENT_TURF_DENY_MOVEMENT

	var/list/turf_area = range(3, T)

	var/obj/effect/alien/weeds/W = locate() in turf_area
	if(W && HIVE_ALLIED_TO_HIVE(W.hivenumber, hivenumber))
		return COMPONENT_TURF_ALLOW_MOVEMENT

	return COMPONENT_TURF_DENY_MOVEMENT

/mob/hologram/queen/proc/handle_overwatch(var/mob/living/carbon/Xenomorph/Queen/Q, var/atom/A, var/mods)
	SIGNAL_HANDLER

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(mods["shift"] && mods["middle"])
		if(next_point > world.time)
			return COMPONENT_INTERRUPT_CLICK

		next_point = world.time + point_delay

		var/message = SPAN_XENONOTICE("[Q] points at [A].")

		to_chat(Q, message)
		for(var/mob/living/carbon/Xenomorph/X in viewers(7, src))
			if(X == Q) continue
			to_chat(X, message)

		var/obj/effect/overlay/temp/point/big/queen/point = new(T, src)
		point.color = color

		return COMPONENT_INTERRUPT_CLICK

	if(!mods["ctrl"])
		return

	if(isXeno(A))
		var/mob/living/carbon/Xenomorph/X = A
		if(X.ally_of_hivenumber(hivenumber))
			Q.overwatch(A)
		return COMPONENT_INTERRUPT_CLICK

	if(!(turf_weed_only(src, T) & COMPONENT_TURF_ALLOW_MOVEMENT))
		return

	forceMove(T)
	if(is_watching)
		Q.overwatch(stop_overwatch = TRUE)

	return COMPONENT_INTERRUPT_CLICK

/mob/hologram/queen/handle_view(var/mob/M, var/atom/target)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE

		if(is_watching)
			M.client.eye = is_watching
		else
			M.client.eye = src

	return COMPONENT_OVERRIDE_VIEW


/mob/hologram/queen/Destroy()
	if(linked_mob)
		var/mob/living/carbon/Xenomorph/Queen/Q = linked_mob
		if(Q.ovipositor)
			give_action(linked_mob, /datum/action/xeno_action/onclick/eye)

		linked_mob.sight &= ~(SEE_TURFS|SEE_OBJS)

	remove_from_all_mob_huds()

	return ..()

/mob/living/carbon/Xenomorph/Queen
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
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_IMMOBILE
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 0 //Queen doesn't count towards population limit.
	hive_pos = XENO_QUEEN
	crystal_max = XENO_CRYSTAL_MEDIUM
	crystal_stored = XENO_CRYSTAL_MEDIUM
	small_explosives_stun = FALSE
	pull_speed = 3.0 //screech/neurodragging is cancer, at the very absolute least get some runner to do it for teamwork

	icon_xenonid = 'icons/mob/xenonids/queen.dmi'

	var/breathing_counter = 0
	var/ovipositor = FALSE //whether the Queen is attached to an ovipositor
	var/queen_ability_cooldown = 0
	var/egg_amount = 0 //amount of eggs inside the queen
	var/screech_sound_effect = 'sound/voice/alien_queen_screech.ogg' //the noise the Queen makes when she screeches. Done this way for VV purposes.
	var/egg_planting_range = 3 // in ovipositor queen can plant egg up to this amount of tiles away from her position
	var/queen_ovipositor_icon
	var/queen_standing_icon

	tileoffset = 0
	viewsize = 12

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction/queen_macro, //normally fifth macro but not as important for queen
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro, and fits near the resin structure buttons
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/grow_ovipositor,
		/datum/action/xeno_action/onclick/banish,
		/datum/action/xeno_action/onclick/readmit,
		/datum/action/xeno_action/onclick/queen_award,
		/datum/action/xeno_action/activable/info_marker/queen,
	)

	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/claw_toggle,
		/mob/living/carbon/Xenomorph/proc/construction_toggle,
		/mob/living/carbon/Xenomorph/proc/destruction_toggle,
		/mob/living/carbon/Xenomorph/proc/toggle_unnesting,
		/mob/living/carbon/Xenomorph/Queen/proc/set_orders,
		/mob/living/carbon/Xenomorph/Queen/proc/hive_message,
		/mob/living/carbon/Xenomorph/proc/rename_tunnel,
	)

	var/list/mobile_abilities = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction/queen_macro, //normally fifth macro but not as important for queen
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro, and fits near the resin structure buttons
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/grow_ovipositor,
		/datum/action/xeno_action/onclick/banish,
		/datum/action/xeno_action/onclick/readmit,
		/datum/action/xeno_action/onclick/queen_award,
		/datum/action/xeno_action/activable/info_marker/queen,
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		/datum/action/xeno_action/activable/xeno_spit/queen_macro, //third macro
		/datum/action/xeno_action/onclick/shift_spits, //second macro
	)

	// Abilities they get when they've successfully aged.
	var/mobile_aged_abilities = list(
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		/datum/action/xeno_action/activable/xeno_spit/queen_macro, //third macro
		/datum/action/xeno_action/onclick/shift_spits, //second macro
	)
	mutation_type = QUEEN_NORMAL
	claw_type = CLAW_TYPE_VERY_SHARP

	var/queen_aged = FALSE
	var/queen_age_timer_id = TIMER_ID_NULL

/mob/living/carbon/Xenomorph/Queen/can_destroy_special()
	return TRUE

/mob/living/carbon/Xenomorph/Queen/Corrupted
	hivenumber = XENO_HIVE_CORRUPTED

/mob/living/carbon/Xenomorph/Queen/Forsaken
	hivenumber = XENO_HIVE_FORSAKEN

/mob/living/carbon/Xenomorph/Queen/Forsaken/combat_ready
	hivenumber = XENO_HIVE_FORSAKEN
	queen_aged = TRUE

/mob/living/carbon/Xenomorph/Queen/Alpha
	hivenumber = XENO_HIVE_ALPHA

/mob/living/carbon/Xenomorph/Queen/Beta
	hivenumber = XENO_HIVE_BRAVO

/mob/living/carbon/Xenomorph/Queen/Gamma
	hivenumber = XENO_HIVE_CHARLIE

/mob/living/carbon/Xenomorph/Queen/Delta
	hivenumber = XENO_HIVE_DELTA

/mob/living/carbon/Xenomorph/Queen/Mutated
	hivenumber = XENO_HIVE_MUTATED

/mob/living/carbon/Xenomorph/Queen/combat_ready
	queen_aged = TRUE

/mob/living/carbon/Xenomorph/Queen/Initialize()
	icon_xeno = get_icon_from_source(CONFIG_GET(string/alien_queen_standing))
	. = ..()
	if(!is_admin_level(z))//so admins can safely spawn Queens in Thunderdome for tests.
		xeno_message(SPAN_XENOANNOUNCE("A new Queen has risen to lead the Hive! Rejoice!"),3,hivenumber)
	playsound(loc, 'sound/voice/alien_queen_command.ogg', 75, 0)
	set_resin_build_order(GLOB.resin_build_order_drone)
	for(var/datum/action/xeno_action/action in actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(selected_resin)
				break // Don't need to keep looking

	if(hive.dynamic_evolution && !queen_aged)
		queen_age_timer_id = addtimer(CALLBACK(src, .proc/make_combat_effective), XENO_QUEEN_AGE_TIME, TIMER_UNIQUE|TIMER_STOPPABLE)
	else
		make_combat_effective()

	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")

/mob/living/carbon/Xenomorph/Queen/handle_name(var/datum/hive_status/in_hive)
	var/name_prefix = in_hive.prefix
	if(queen_aged)
		age_xeno()
		switch(age)
			if(XENO_NORMAL) name = "[name_prefix]Queen"			 //Young
			if(XENO_MATURE) name = "[name_prefix]Elder Queen"	 //Mature
			if(XENO_ELDER) name = "[name_prefix]Elder Empress"	 //Elite
			if(XENO_ANCIENT) name = "[name_prefix]Ancient Empress" //Ancient
			if(XENO_PRIME) name = "[name_prefix]Prime Empress" //Primordial
	else
		age = XENO_NORMAL
		if(client)
			hud_update()

		name = "[name_prefix]Young Queen"

	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"

	//Update linked data so they show up properly
	change_real_name(src, name)

/mob/living/carbon/Xenomorph/Queen/proc/make_combat_effective()
	queen_aged = TRUE

	give_combat_abilities()
	recalculate_actions()
	recalculate_health()
	generate_name()

/mob/living/carbon/Xenomorph/Queen/proc/give_combat_abilities()
	if(ovipositor)
		return

	for(var/datum/action/xeno_action/action in actions)
		action.hide_from(src)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(selected_resin)

	var/list/abilities_to_give = mobile_abilities.Copy()

	if(!queen_aged)
		abilities_to_give -= mobile_aged_abilities

	for(var/path in abilities_to_give)
		give_action(src, path)


/mob/living/carbon/Xenomorph/Queen/recalculate_health()
	. = ..()
	if(!queen_aged)
		maxHealth *= YOUNG_QUEEN_HEALTH_MULTIPLIER

	if(health > maxHealth)
		health = maxHealth

/mob/living/carbon/Xenomorph/Queen/Destroy()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)

	if(hive && hive.living_xeno_queen == src)
		var/mob/living/carbon/Xenomorph/Queen/next_queen = null
		for(var/mob/living/carbon/Xenomorph/Queen/queen in hive.totalXenos)
			if(!is_admin_level(queen.z) && queen != src && !QDELETED(queen))
				next_queen = queen
				break
		hive.set_living_xeno_queen(next_queen) // either null or a queen

	return ..()

/mob/living/carbon/Xenomorph/Queen/Life(delta_time)
	..()

	if(stat != DEAD)
		if(++breathing_counter >= rand(22, 27)) //Increase the breathing variable each tick. Play it at random intervals.
			playsound(loc, pick('sound/voice/alien_queen_breath1.ogg', 'sound/voice/alien_queen_breath2.ogg'), 15, 1, 4)
			breathing_counter = 0 //Reset the counter

		if(observed_xeno)
			if(observed_xeno.stat == DEAD || QDELETED(observed_xeno))
				overwatch(observed_xeno, TRUE)

		if(ovipositor && !is_mob_incapacitated(TRUE))
			egg_amount += 0.07 * mutators.egg_laying_multiplier //one egg approximately every 30 seconds
			if(egg_amount >= 1)
				if(isturf(loc))
					var/turf/T = loc
					if(T.contents.len <= 25) //so we don't end up with a million object on that turf.
						egg_amount--
						new /obj/item/xeno_egg(loc, hivenumber)

/mob/living/carbon/Xenomorph/Queen/Stat()
	..()
	var/stored_larvae = GLOB.hive_datum[hivenumber].stored_larva
	var/xeno_leader_num = hive?.queen_leader_limit - hive?.open_xeno_leader_positions.len

	. += "Pooled Larvae: [stored_larvae]"
	. += "Leaders: [xeno_leader_num] / [hive?.queen_leader_limit]"
	if(queen_age_timer_id != TIMER_ID_NULL)
		var/time_left = time2text(timeleft(queen_age_timer_id) + 1 MINUTES, "mm") // We add a minute so that it basically ceilings the value.
		. += "Maturity: [time_left == 1? "[time_left] minute" : "[time_left] minutes"] remaining"

//Custom bump for crushers. This overwrites normal bumpcode from carbon.dm
/mob/living/carbon/Xenomorph/Queen/Collide(atom/A)
	set waitfor = 0

	if(stat || !istype(A) || A == src)
		return FALSE

	if(now_pushing)
		return FALSE//Just a plain ol turf, let's return.

	var/turf/T = get_step(src, dir)
	if(!T || !get_step_to(src, T)) //If it still exists, try to push it.
		return ..()

	return TRUE

/mob/living/carbon/Xenomorph/Queen/proc/set_orders()
	set category = "Alien"
	set name = "Set Hive Orders (50)"
	set desc = "Give some specific orders to the hive. They can see this on the status pane."

	if(!check_state())
		return
	if(last_special > world.time)
		return
	if(!check_plasma(50))
		return
	use_plasma(50)

	var/txt = strip_html(input("Set the hive's orders to what? Leave blank to clear it.", "Hive Orders",""))
	if(txt)
		xeno_message("<B>The Queen's will overwhelms your instincts...</B>", 3, hivenumber)
		xeno_message("<B>\""+txt+"\"</B>", 3, hivenumber)
		xeno_maptext(txt, "Hive Orders Updated", hivenumber)
		hive.hive_orders = txt
		log_hiveorder("[key_name(usr)] has set the Hive Order to: [txt]")
	else
		hive.hive_orders = ""

	last_special = world.time + 15 SECONDS

/mob/living/carbon/Xenomorph/Queen/proc/hive_message()
	set category = "Alien"
	set name = "Word of the Queen (50)"
	set desc = "Send a message to all aliens in the hive that is big and visible"
	if(health <= 0)
		to_chat(src, SPAN_WARNING("You can't do that while unconcious."))
		return FALSE
	if(!check_plasma(50))
		return FALSE

	// Get a reference to the ability to utilize cooldowns
	var/datum/action/xeno_action/onclick/queen_word/word_ability
	for(var/datum/action/xeno_action/action in actions)
		if(istype(action, /datum/action/xeno_action/onclick/queen_word))
			word_ability = action
			if(!word_ability.action_cooldown_check())
				return FALSE
			break

	var/input = stripped_multiline_input(src, "This message will be broadcast throughout the hive.", "Word of the Queen", "")
	if(!input)
		return FALSE

	use_plasma(50)
	if(word_ability)
		word_ability.apply_cooldown()

	xeno_announcement(input, hivenumber, "The words of the [name] reverberate in your head...")

	log_and_message_staff("[key_name_admin(src)] has created a Word of the Queen report:")
	log_admin("[key_name_admin(src)] Word of the Queen: [input]")
	return TRUE

/mob/living/carbon/Xenomorph/proc/claw_toggle()
	set name = "Permit/Disallow Slashing"
	set desc = "Allows you to permit the hive to harm."
	set category = "Alien"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(!hive)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		CRASH("[src] attempted to toggle slashing without a linked hive")

	if(pslash_delay)
		to_chat(src, SPAN_WARNING("You must wait a bit before you can toggle this again."))
		return

	pslash_delay = TRUE
	addtimer(CALLBACK(src, /mob/living/carbon/Xenomorph.proc/do_claw_toggle_cooldown), 30 SECONDS)

	var/choice = tgui_input_list(usr, "Choose which level of slashing hosts to permit to your hive.","Harming", list("Allowed", "Restricted - Hosts of Interest", "Forbidden"), theme="hive_status")

	if(choice == "Allowed")
		to_chat(src, SPAN_XENONOTICE("You allow slashing."))
		xeno_message(SPAN_XENOANNOUNCE("The Queen has <b>permitted</b> the harming of hosts! Go hog wild!"), 2, hivenumber)
		hive.slashing_allowed = XENO_SLASH_ALLOWED
	else if(choice == "Forbidden")
		to_chat(src, SPAN_XENONOTICE("You forbid slashing entirely."))
		xeno_message(SPAN_XENOANNOUNCE("The Queen has <b>forbidden</b> the harming of hosts. You can no longer slash your enemies."), 2, hivenumber)
		hive.slashing_allowed = XENO_SLASH_FORBIDDEN

/mob/living/carbon/Xenomorph/proc/do_claw_toggle_cooldown()
	pslash_delay = FALSE

/mob/living/carbon/Xenomorph/proc/construction_toggle()
	set name = "Permit/Disallow Construction Placement"
	set desc = "Allows you to permit the hive to place construction nodes freely."
	set category = "Alien"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	var/choice = tgui_input_list(usr, "Choose which level of construction placement freedom to permit to your hive.","Harming", list("Queen", "Leaders", "Anyone"), theme="hive_status")

	if(choice == "Anyone")
		to_chat(src, SPAN_XENONOTICE("You allow construction placement to all builder castes."))
		xeno_message("The Queen has <b>permitted</b> the placement of construction nodes to all builder castes!", hivenumber = src.hivenumber)
		hive.construction_allowed = NORMAL_XENO
	else if(choice == "Leaders")
		to_chat(src, SPAN_XENONOTICE("You restrict construction placement to leaders only."))
		xeno_message("The Queen has <b>restricted</b> the placement of construction nodes to leading builder castes only.", hivenumber = src.hivenumber)
		hive.construction_allowed = XENO_LEADER
	else if(choice == "Queen")
		to_chat(src, SPAN_XENONOTICE("You forbid construction placement entirely."))
		xeno_message("The Queen has <b>forbidden</b> the placement of construction nodes to herself.", hivenumber = src.hivenumber)
		hive.construction_allowed = XENO_QUEEN

/mob/living/carbon/Xenomorph/proc/destruction_toggle()
	set name = "Permit/Disallow Special Structure Destruction"
	set desc = "Allows you to permit the hive to destroy special structures freely."
	set category = "Alien"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	var/choice = tgui_input_list(usr, "Choose which level of destruction freedom to permit to your hive.","Harming", list("Queen", "Leaders", "Anyone"), theme="hive_status")

	if(choice == "Anyone")
		to_chat(src, SPAN_XENONOTICE("You allow special structure destruction to all builder castes and leaders."))
		xeno_message("The Queen has <b>permitted</b> the special structure destruction to all builder castes and leaders!", hivenumber = src.hivenumber)
		hive.destruction_allowed = NORMAL_XENO
	else if(choice == "Leaders")
		to_chat(src, SPAN_XENONOTICE("You restrict special structure destruction to leaders only."))
		xeno_message("The Queen has <b>restricted</b> the special structure destruction to leaders only.", hivenumber = src.hivenumber)
		hive.destruction_allowed = XENO_LEADER
	else if(choice == "Queen")
		to_chat(src, SPAN_XENONOTICE("You forbid special structure destruction entirely."))
		xeno_message("The Queen has <b>forbidden</b> the special structure destruction to anyone but herself.", hivenumber = src.hivenumber)
		hive.destruction_allowed = XENO_QUEEN

/mob/living/carbon/Xenomorph/proc/toggle_unnesting()
	set name = "Permit/Disallow Unnesting"
	set desc = "Allows you to restrict unnesting to drones."
	set category = "Alien"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	hive.unnesting_allowed = !hive.unnesting_allowed

	if(hive.unnesting_allowed)
		to_chat(src, SPAN_XENONOTICE("You have allowed everyone to unnest hosts."))
		xeno_message("The Queen has allowed everyone to unnest hosts.", hivenumber = src.hivenumber)
	else
		to_chat(src, SPAN_XENONOTICE("You have forbidden anyone to unnest hosts, except for the drone caste."))
		xeno_message("The Queen has forbidden anyone to unnest hosts, except for the drone caste.", hivenumber = src.hivenumber)

/mob/living/carbon/Xenomorph/Queen/handle_screech_act(var/mob/self, var/mob/living/carbon/Xenomorph/Queen/queen)
	return COMPONENT_SCREECH_ACT_CANCEL

/mob/living/carbon/Xenomorph/Queen/proc/screech_ready()
	to_chat(src, SPAN_WARNING("You feel your throat muscles vibrate. You are ready to screech again."))
	for(var/Z in actions)
		var/datum/action/A = Z
		A.update_button_icon()

/mob/living/carbon/Xenomorph/Queen/proc/queen_gut(atom/target)
	if(!iscarbon(target))
		return FALSE

	var/mob/living/carbon/victim = target

	if(get_dist(src, victim) > 1)
		return FALSE

	if(!check_state())
		return FALSE

	if(isSynth(victim))
		var/obj/limb/head/synthhead = victim.get_limb("head")
		if(synthhead.status & LIMB_DESTROYED)
			return FALSE

	if(locate(/obj/item/alien_embryo) in victim) //Maybe they ate it??
		var/mob/living/carbon/human/human_victim = victim
		if(human_victim.status_flags & XENO_HOST)
			if(victim.stat != DEAD) //Not dead yet.
				to_chat(src, SPAN_XENOWARNING("The host and child are still alive!"))
				return FALSE
			else if(istype(human_victim) && (world.time <= human_victim.timeofdeath + human_victim.revive_grace_period)) //Dead, but the host can still hatch, possibly.
				to_chat(src, SPAN_XENOWARNING("The child may still hatch! Not yet!"))
				return FALSE

	if(isXeno(victim))
		var/mob/living/carbon/Xenomorph/xeno = victim
		if(hivenumber == xeno.hivenumber)
			to_chat(src, SPAN_WARNING("You can't bring yourself to harm a fellow sister to this magnitude."))
			return FALSE

	var/turf/cur_loc = victim.loc
	if(!istype(cur_loc))
		return FALSE

	if(action_busy)
		return FALSE

	if(!check_plasma(200))
		return FALSE

	visible_message(SPAN_XENOWARNING("[src] begins slowly lifting [victim] into the air."), \
	SPAN_XENOWARNING("You begin focusing your anger as you slowly lift [victim] into the air."))
	if(do_after(src, 80, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
		if(!victim)
			return FALSE
		if(victim.loc != cur_loc)
			return FALSE
		if(!check_plasma(200))
			return FALSE

		use_plasma(200)

		visible_message(SPAN_XENODANGER("[src] viciously smashes and wrenches [victim] apart!"), \
		SPAN_XENODANGER("You suddenly unleash pure anger on [victim], instantly wrenching \him apart!"))
		emote("roar")

		attack_log += text("\[[time_stamp()]\] <font color='red'>gibbed [key_name(victim)]</font>")
		victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>was gibbed by [key_name(src)]</font>")
		victim.gib(create_cause_data("Queen gutting", src)) //Splut

		stop_pulling()
		return TRUE

/mob/living/carbon/Xenomorph/Queen/death(var/cause, var/gibbed)
	if(hive.living_xeno_queen == src)
		hive.xeno_queen_timer = world.time + XENO_QUEEN_DEATH_DELAY
		hive.banished_ckeys   = list() // Reset the banished ckey list
	return ..()


/mob/living/carbon/Xenomorph/Queen/proc/mount_ovipositor()
	if(ovipositor)
		return //sanity check
	ovipositor = TRUE

	set_resin_build_order(GLOB.resin_build_order_ovipositor) // This needs to occur before we update the abilities so we can update the choose resin icon
	for(var/datum/action/xeno_action/action in actions)
		action.hide_from(src)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(selected_resin)

	var/list/immobile_abilities = list(
		// These already have their placement locked in:
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/place_construction/queen_macro,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/onclick/banish,
		/datum/action/xeno_action/onclick/readmit,
		/datum/action/xeno_action/onclick/queen_award,
		/datum/action/xeno_action/activable/info_marker/queen,
		// Screech is typically new for this list, but its possible they never ovi and it then is forced here:
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		// These are new and their arrangement matters:
		/datum/action/xeno_action/onclick/remove_eggsac,
		/datum/action/xeno_action/onclick/set_xeno_lead,
		/datum/action/xeno_action/activable/queen_heal, //first macro
		/datum/action/xeno_action/activable/queen_give_plasma, //second macro
		/datum/action/xeno_action/onclick/deevolve,
		/datum/action/xeno_action/onclick/queen_order,
		/datum/action/xeno_action/activable/expand_weeds, //third macro
		/datum/action/xeno_action/activable/secrete_resin/remote/queen, //fifth macro
		/datum/action/xeno_action/onclick/queen_tacmap,
		/datum/action/xeno_action/onclick/eye,
	)

	for(var/path in immobile_abilities)
		give_action(src, path)

	add_verb(src, /mob/living/carbon/Xenomorph/proc/xeno_tacmap)

	ADD_TRAIT(src, TRAIT_ABILITY_NO_PLASMA_TRANSFER, TRAIT_SOURCE_ABILITY("Ovipositor"))
	ADD_TRAIT(src, TRAIT_ABILITY_OVIPOSITOR, TRAIT_SOURCE_ABILITY("Ovipositor"))

	extra_build_dist = IGNORE_BUILD_DISTANCE
	anchored = TRUE
	resting = FALSE
	update_canmove()
	update_icons()

	for(var/mob/living/carbon/Xenomorph/leader in hive.xeno_leader_list)
		leader.handle_xeno_leader_pheromones()

	xeno_message(SPAN_XENOANNOUNCE("The Queen has grown an ovipositor, evolution progress resumed."), 3, hivenumber)

	START_PROCESSING(SShive_status, hive.hive_ui)

	SEND_SIGNAL(src, COMSIG_QUEEN_MOUNT_OVIPOSITOR)

/mob/living/carbon/Xenomorph/Queen/proc/dismount_ovipositor(instant_dismount)
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
	update_icons()
	new /obj/ovipositor(loc)

	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	zoom_out()

	set_resin_build_order(GLOB.resin_build_order_drone) // This needs to occur before we update the abilities so we can update the choose resin icon
	give_combat_abilities()

	remove_verb(src, /mob/living/carbon/Xenomorph/proc/xeno_tacmap)

	REMOVE_TRAIT(src, TRAIT_ABILITY_NO_PLASMA_TRANSFER, TRAIT_SOURCE_ABILITY("Ovipositor"))
	REMOVE_TRAIT(src, TRAIT_ABILITY_OVIPOSITOR, TRAIT_SOURCE_ABILITY("Ovipositor"))

	recalculate_actions()

	egg_amount = 0
	extra_build_dist = initial(extra_build_dist)
	for(var/datum/action/xeno_action/action in actions)
		if(istype(action, /datum/action/xeno_action/onclick/grow_ovipositor))
			var/datum/action/xeno_action/onclick/grow_ovipositor/ovi_ability = action
			ovi_ability.apply_cooldown()
			break
	anchored = FALSE
	update_canmove()

	for(var/mob/living/carbon/Xenomorph/L in hive.xeno_leader_list)
		L.handle_xeno_leader_pheromones()

	if(!instant_dismount)
		xeno_message(SPAN_XENOANNOUNCE("The Queen has shed her ovipositor, evolution progress paused."), 3, hivenumber)

	SEND_SIGNAL(src, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, instant_dismount)

/mob/living/carbon/Xenomorph/Queen/update_canmove()
	. = ..()
	if(ovipositor)
		lying = FALSE
		density = TRUE
		canmove = FALSE
		return canmove

/mob/living/carbon/Xenomorph/Queen/handle_special_state()
	if(ovipositor)
		return TRUE
	return FALSE

/mob/living/carbon/Xenomorph/Queen/handle_special_wound_states(severity)
	. = ..()
	if(ovipositor)
		return "Queen_ovipositor_[severity]" // I don't actually have it, but maybe one day.

/mob/living/carbon/Xenomorph/Queen/proc/in_egg_plant_range(var/turf/T)
	if(!ovipositor)
		return FALSE // can't range plant while not in ovi... but who the fuck cares, we can't plant anyways
	return get_dist(src, T) <= egg_planting_range

/mob/living/carbon/Xenomorph/Queen/gib(var/cause = "gibbing")
	death(cause, 1)

/datum/behavior_delegate/queen
	name = "Queen Behavior Delegate"

/datum/behavior_delegate/queen/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	var/mob/living/carbon/Xenomorph/Queen/Queen = bound_xeno
	if(Queen.ovipositor)
		Queen.icon = Queen.queen_ovipositor_icon
		Queen.icon_state = "[Queen.mutation_type] Queen Ovipositor"
		return TRUE

	// Switch icon back and then let normal icon behavior happen
	Queen.icon = Queen.queen_standing_icon
