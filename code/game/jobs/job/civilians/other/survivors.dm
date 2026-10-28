#define SURVIVOR_TO_TOTAL_SPAWN_RATIO 1/9

GLOBAL_LIST_EMPTY(spawned_survivors)

/datum/job/civilian/survivor
	title = JOB_SURVIVOR
	selection_class = "job_special"
	// For the roundstart precount, then gets further limited by set_spawn_positions.
	total_positions = 8
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE
	job_options = SURVIVOR_VARIANT_LIST
	var/intro_text
	var/story_text
	/// Whether or not the survivor is an inherently hostile to marines.
	var/hostile = FALSE
	/// How many survs have been spawned total
	var/static/total_spawned = 0
	/// Assoc list of new_player to landmark that have been slotted
	var/list/slotted_landmarks
	/// List of survivor landmarks for the current scenario sorted by priority
	var/list/available_landmarks
	/// List of all generic survivor landmarks (INSERT_NONE and lowest priority)
	var/list/generic_landmarks
	/// Flag to determine if there is an insert, if there is but a player has opted out of too many archetypes, we can know to simply not spawn them.
	var/insert_present_flag = FALSE

/datum/job/civilian/survivor/set_spawn_positions(count)
	spawn_positions = clamp((floor(count * SURVIVOR_TO_TOTAL_SPAWN_RATIO)), 2, 8)
	total_positions = spawn_positions

/datum/job/civilian/survivor/get_total_positions(latejoin)
	var/normal_positions = ..()

	// Determine the normal surv limit
	var/datum/job/civilian/survivor/base_job = GLOB.RoleAuthority.roles_by_path[/datum/job/civilian/survivor]
	if(!base_job)
		stack_trace("/datum/job/civilian/survivor is not present in GLOB.RoleAuthority.roles_by_path!")
		return 0
	var/base_positions = latejoin ? base_job.total_positions : base_job.spawn_positions

	// Count all current_positions
	var/exisiting_positions = 0
	for(var/surv_type in typesof(/datum/job/civilian/survivor))
		var/datum/job/civilian/survivor/surv_job = GLOB.RoleAuthority.roles_by_path[surv_type]
		if(surv_job)
			exisiting_positions += surv_job.current_positions

	var/available_positions = max(min(base_positions - exisiting_positions, normal_positions), 0)
	return available_positions + current_positions // check_role_entry() checks our own current_positions count already

/datum/job/civilian/survivor/create_landmark_lists(force)
	if(!isnull(available_landmarks) && !force)
		return // Already set up

	slotted_landmarks = list()
	available_landmarks = list()
	generic_landmarks = list()

	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.generic_survivor_spawns) //make a list of all valid generic spawns
		generic_landmarks += spawner

	var/hostile_scenario = SSnightmare.get_scenario_is_hostile_survivor()
	for(var/priority = 1 to LOWEST_SPAWN_PRIORITY)
		if(length(GLOB.survivor_spawns_by_priority["[priority]"]))
			for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.survivor_spawns_by_priority["[priority]"])
				if(!insert_present_flag && spawner.archetype != INSERT_NONE) //set flag for an insert being present
					insert_present_flag = TRUE
				if(spawner.archetype == INSERT_SYNTH) //Don't add synths or COs to normal survivor spawns
					continue
				if(spawner.archetype == INSERT_CO)
					continue
				if(spawner.hostile == hostile_scenario)
					available_landmarks += spawner

/// Returns a list of all the archetypes the player has opted into, if none, they don't get a spot
/datum/job/civilian/survivor/proc/get_valid_prefs(mob/new_player)
	var/list/insert_prefs = list()

	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_STANDARD))
		insert_prefs += INSERT_STANDARD
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_CORPORATE))
		insert_prefs += INSERT_CORPORATE
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_LEADER))
		insert_prefs += INSERT_LEADER
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_MEDIC))
		insert_prefs += INSERT_MEDIC
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_ENGINEER))
		insert_prefs += INSERT_ENGINEER
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_SPECIALIST))
		insert_prefs += INSERT_SPECIALIST
	if(HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_SMARTGUNNER))
		insert_prefs += INSERT_SMARTGUNNER

	return insert_prefs

/datum/job/civilian/survivor/assign_landmark(mob/new_player, latejoin)
	if(!new_player?.client)
		return FALSE

	if(slotted_landmarks[new_player] != null)
		return TRUE // Already assigned a landmark (namely precount may have slotted us)

	var/list/valid_prefs = get_valid_prefs(new_player)
	var/no_insert_archetypes = length(valid_prefs) == 0 // If the player's valid_prefs list is 0, they have opted out of all possible insert archetypes and cannot spawn if an insert is present
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in available_landmarks) // for inserts with a higher than default priority to spawn (all of them)
		// There is an insert and player has opted out of inserts, return FALSE
		if(no_insert_archetypes && spawner.archetype != INSERT_NONE)
			return FALSE
		if((spawner.archetype in valid_prefs) || (spawner.archetype == INSERT_NONE && spawner.spawn_priority != LOWEST_SPAWN_PRIORITY)) //only add landmarks that match prefs or generic ones with elevated priority (none exist yet)
			slotted_landmarks[new_player] = spawner
			available_landmarks -= spawner
			GLOB.survivor_spawns_by_priority -= spawner
			return TRUE

	if(insert_present_flag) // There is an insert, but you didn't qualify for ANY spots in it, likely due to disabling most (but not all!) prefs. A shame... a real shame...
		return FALSE

	// There is no insert, so now we have to assign a random generic spawn
	var/obj/effect/landmark/survivor_spawner/spawner = SAFEPICK(generic_landmarks)
	if(spawner) //if there is a generic spawn, use it
		slotted_landmarks[new_player] = spawner
		generic_landmarks -= spawner
		GLOB.generic_survivor_spawns -= spawner
		return TRUE

	return FALSE

/datum/job/civilian/survivor/equip_job(mob/living/survivor)
	var/generated_account = generate_money_account(survivor)
	addtimer(CALLBACK(src, PROC_REF(announce_entry_message), survivor, generated_account), 2 SECONDS)
	if(MODE_HAS_FLAG(MODE_SURVIVE))
		GLOB.data_core.manifest_inject(survivor)

/datum/job/civilian/survivor/announce_entry_message(mob/living/carbon/human/survivor, datum/money_account/account, whitelist_status) //The actual message that is displayed to the mob when they enter the game as a new player.
	if(survivor?.loc && survivor.client)
		//Document syntax cannot have tabs for proper formatting.
		var/entrydisplay = " \
			[SPAN_ROLE_BODY("|______________________|")] \n\
			[SPAN_ROLE_BODY("[generate_entry_message(survivor)]<br>[account ? "Your account number is: <b>[account.account_number]</b>. Your account pin is: <b>[account.remote_access_pin]</b>." : "You do not have a bank account."]")] \n\
			[SPAN_ROLE_BODY("|______________________|")] \
		"
		to_chat_spaced(survivor, html = entrydisplay)

/datum/job/civilian/survivor/can_play_role_in_scenario(client/client)
	. = ..()
	if(!.)
		return .

	if(MODE_HAS_FLAG(MODE_SURVIVE))
		return TRUE // Hostile/non-hostile preference is ignored for this mode

	if(SSnightmare.get_scenario_is_hostile_survivor())
		return HAS_FLAG(client.prefs?.toggles_survivor, PLAY_SURVIVOR_HOSTILE)
	else
		return HAS_FLAG(client.prefs?.toggles_survivor, PLAY_SURVIVOR_NON_HOSTILE)

/datum/job/civilian/survivor/spawn_in_player(mob/new_player/NP)
	. = ..()
	total_spawned++

	var/mob/living/carbon/human/H = .

	GLOB.spawned_survivors += WEAKREF(H)

	var/obj/effect/landmark/survivor_spawner/picked_spawner = slotted_landmarks[NP]
	if(!picked_spawner)
		// Generally this shouldn't happen since role authority shouldn't be rolling us for a survivor in a hostile scenario
		message_admins("Failed to spawn_in_player [key_name_admin(H)] as a survivor! This likely means NIGHTMARE_SCENARIO_HOSTILE_SURVIVOR is incorrect for this map!")
		H.send_to_lobby()
		qdel(H)
		return null

	H.forceMove(get_turf(picked_spawner))

	handle_equip_gear(H, picked_spawner)

	if(picked_spawner.roundstart_damage_max > 0)
		if(istype(picked_spawner) && picked_spawner.roundstart_damage_max > 0)
			for(var/i in 0 to picked_spawner.roundstart_damage_times)
				H.take_limb_damage(rand(picked_spawner.roundstart_damage_min, picked_spawner.roundstart_damage_max), 0)

	H.name = H.get_visible_name()

	if(length(picked_spawner.intro_text))
		intro_text = picked_spawner.intro_text

	if(picked_spawner.story_text)
		story_text = picked_spawner.story_text

	if(picked_spawner.hostile)
		hostile = TRUE

	new /datum/cm_objective/move_mob/almayer/survivor(H)

/datum/job/civilian/survivor/generate_entry_message(mob/living/carbon/human/survivor)
	if(intro_text)
		for(var/line in intro_text)
			to_chat(survivor, line)
	else
		to_chat(survivor, "<h2>You are a survivor!</h2>")
		to_chat(survivor, SPAN_NOTICE(SSmapping.configs[GROUND_MAP].survivor_message))
		to_chat(survivor, SPAN_NOTICE("You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit."))
		to_chat(survivor, SPAN_NOTICE("You are NOT aware of the marines or their intentions."))

	if(story_text)
		to_chat(survivor, story_text)
		survivor.mind.memory += story_text
	else
		tell_survivor_story(survivor)

	if(hostile)
		to_chat(survivor, SPAN_HIGHDANGER("You are HOSTILE to the USCM!"))
	else if(survivor.faction == FACTION_CLF)
		to_chat(survivor, SPAN_HIGHDANGER("You are HOSTILE to the USCM, but NOT to other survivors!"))
	else
		to_chat(survivor, SPAN_XENOHIGHDANGER("You are NON-HOSTILE to the USCM!"))

/datum/job/civilian/survivor/proc/tell_survivor_story(mob/living/carbon/human/H)
	var/list/survivor_story = list(
								"You watched as a larva burst from the chest of your friend, {name}. You tried to capture the alien thing, but it escaped through the ventilation.",
								"{name} was attacked by a facehugging alien, which impregnated them with an alien lifeform. {name}'s chest exploded in gore as some creature escaped.",
								"You watched in horror as {name} got the alien lifeform's acid on their skin, melting away their flesh. You can still hear the screaming and panic.",
								"The Colony Marshal, {name}, made an announcement that the hostile lifeforms killed many, and that everyone should hide or stay behind closed doors.",
								"You were there when the alien lifeforms broke into the mess hall and dragged away the others. It was a terrible sight, and you have tried avoid large open areas since.",
								"It was horrible, as you watched your friend, {name}, get mauled by the horrible monsters. Their screams of agony hunt you in your dreams, leading to insomnia.",
								"You tried your best to hide, and you have seen the creatures travel through the underground tunnels and ventilation shafts. They seem to like the dark.",
								"When you woke up, it felt like you've slept for years. You don't recall much about your old life, except maybe your name. Just what the hell happened to you?",
								"You were on the front lines, trying to fight the aliens. You have seen them hatch more monsters from other humans, and you know better than to fight against death.",
								"You found something, something incredible. But your discovery was cut short when the monsters appeared and began taking people. Damn the beasts!",
								"{name} protected you when the aliens came. You don't know what happened to them, but that was some time ago, and you haven't seen them since. Maybe they are alive."
								)

	/*
	var/list/survivor_multi_story = list(
										"You were separated from your friend, {surv}. You hope they're still alive.",
										"You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help.",
										"Something spooked you when you were out with {surv} scavenging. You took off in the opposite direction from them, and you haven't seen them since.",
										"When {name} became infected, you and {surv} argued over what to do with the afflicted. You nearly came to blows before walking away, leaving them behind.",
										"You ran into {surv} when out looking for supplies. After a tense stand off, you agreed to stay out of each other's way. They didn't seem so bad.",
										"A lunatic by the name of {name} was preaching doomsday to anyone who would listen. {surv} was there too, and you two shared a laugh before the creatures arrived.",
										"Your last decent memory before everything went to hell is of {surv}. They were generally a good person to have around, and they helped you through tough times.",
										"When {name} called for evacuation, {surv} came with you. The aliens appeared soon after and everyone scattered. You hope your friend {surv} is alright.",
										"You remember an explosion. Then everything went dark. You can only recall {name} and {surv}, who were there. Maybe they know what really happened?",
										"The aliens took your mutual friend, {name}. {surv} helped with the rescue. When you got to the alien hive, your friend was dead. You took different passages out.",
										"You were playing basketball with {surv} when the creatures descended. You bolted in opposite directions, and actually managed to lose the monsters, somehow."
										)
										*/

	var/random_name = random_name(pick(FEMALE, MALE))
	var/temp_story = "<b>Your story thus far</b>: " + replacetext(pick(survivor_story), "{name}", "[random_name]")
	to_chat(H, temp_story)
	H.mind.memory += temp_story

	return TRUE

/datum/job/civilian/survivor/proc/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.equipment)
		arm_equipment(equipping_human, picked_spawner.equipment, FALSE, TRUE)
	else
		var/datum/job/mapped_job = GLOB.RoleAuthority.role_mappings[JOB_SURVIVOR]
		var/survivor_job_title = mapped_job?.title || JOB_SURVIVOR
		var/preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[survivor_job_title] || ANY_SURVIVOR
		if(preferred_variant != ANY_SURVIVOR)
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				// Soft cap met
				preferred_variant = ANY_SURVIVOR

		var/list/types_by_variant = SSmapping.configs[GROUND_MAP].get_relevant_survivor_types_by_variant()
		var/list/survivor_types
		if(preferred_variant != ANY_SURVIVOR && length(types_by_variant[preferred_variant]))
			survivor_types = types_by_variant[preferred_variant]
		else
			survivor_types = SSmapping.configs[GROUND_MAP].get_relevant_survivor_types()

		arm_equipment(equipping_human, pick(survivor_types), FALSE, TRUE)
		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

AddTimelock(/datum/job/civilian/survivor, list(
	JOB_SQUAD_ROLES = 5 HOURS,
	JOB_ENGINEER_ROLES = 5 HOURS,
	JOB_MEDIC_ROLES = 5 HOURS
))

/datum/job/civilian/survivor/synth
	title = JOB_SYNTH_SURVIVOR
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	total_positions = 1
	spawn_positions = 1
	job_options = null

/datum/job/civilian/survivor/synth/get_total_positions(latejoin)
	if(MODE_HAS_FLAG(MODE_SURVIVE)) // Survive mode doesn't share slots since base survivor type not in use
		return latejoin ? total_positions : spawn_positions
	return ..()

/datum/job/civilian/survivor/synth/set_spawn_positions(count)
	return

/datum/job/civilian/survivor/synth/create_landmark_lists(force)
	if(!isnull(available_landmarks) && !force)
		return // Already set up

	slotted_landmarks = list()
	available_landmarks = list()
	generic_landmarks = list()

	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.generic_survivor_spawns) //make a list of all valid generic spawns
		generic_landmarks += spawner

	var/hostile_scenario = SSnightmare.get_scenario_is_hostile_survivor()
	for(var/priority = 1 to LOWEST_SPAWN_PRIORITY)
		if(length(GLOB.survivor_spawns_by_priority["[priority]"]))
			for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.survivor_spawns_by_priority["[priority]"])
				if(spawner.archetype != INSERT_SYNTH) //Only add synth landmarks
					continue
				if(spawner.hostile == hostile_scenario)
					available_landmarks += spawner

/datum/job/civilian/survivor/synth/assign_landmark(mob/new_player, latejoin)
	if(MODE_HAS_FLAG(MODE_SURVIVE)) // Survive mode wants synths in the precount
		create_landmark_lists()

	if(!new_player?.client)
		return FALSE

	if(slotted_landmarks[new_player] != null)
		return TRUE // Already assigned a landmark (namely precount may have slotted us)

	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in available_landmarks)
		if(spawner.archetype == INSERT_SYNTH) //only pass synth landmarks
			// If there's an insert but we don't have the pref, return FALSE
			if(!HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_SYNTH))
				return FALSE
			slotted_landmarks[new_player] = spawner
			available_landmarks -= spawner
			GLOB.survivor_spawns_by_priority -= spawner
			return TRUE

	// There is no insert, so now we have to assign a random generic spawn
	var/obj/effect/landmark/survivor_spawner/spawner = SAFEPICK(generic_landmarks)
	if(spawner) //if there is a generic spawn, use it
		slotted_landmarks[new_player] = spawner
		generic_landmarks -= spawner
		GLOB.generic_survivor_spawns -= spawner
		return TRUE

	return FALSE

/datum/job/civilian/survivor/synth/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.synth_equipment) //insert with synth
		arm_equipment(equipping_human, picked_spawner.synth_equipment, FALSE, TRUE) //use synth equipmnent
	else //else, use player prefs
		var/datum/job/mapped_job = GLOB.RoleAuthority.role_mappings[JOB_SURVIVOR]
		var/survivor_job_title = mapped_job?.title || JOB_SURVIVOR
		var/preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[survivor_job_title] || ANY_SURVIVOR
		if(preferred_variant != ANY_SURVIVOR)
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				// Soft cap met
				preferred_variant = ANY_SURVIVOR

		var/list/types_by_variant = SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant
		var/list/synth_survivor_types
		if(preferred_variant != ANY_SURVIVOR && length(types_by_variant[preferred_variant]))
			synth_survivor_types = types_by_variant[preferred_variant]
		else
			synth_survivor_types = SSmapping.configs[GROUND_MAP].synth_survivor_types

		arm_equipment(equipping_human, pick(synth_survivor_types), FALSE, TRUE)
		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

/datum/job/civilian/survivor/commanding_officer
	title = JOB_CO_SURVIVOR
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_COMMANDER
	total_positions = 0
	spawn_positions = 0
	job_options = null

/datum/job/civilian/survivor/commanding_officer/get_total_positions(latejoin)
	if(MODE_HAS_FLAG(MODE_SURVIVE)) // Survive mode doesn't share slots since base survivor type not in use
		return latejoin ? total_positions : spawn_positions
	return ..()

/datum/job/civilian/survivor/commanding_officer/set_spawn_positions()
	var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
	var/list/CO_insert_survivor_types = SSmapping.configs[GROUND_MAP].CO_insert_survivor_types
	if(!length(CO_survivor_types) && !length(CO_insert_survivor_types))
		return
	total_positions = 1
	spawn_positions = 1

/datum/job/civilian/survivor/commanding_officer/create_landmark_lists(force)
	if(!isnull(available_landmarks) && !force)
		return // Already set up

	slotted_landmarks = list()
	available_landmarks = list()
	generic_landmarks = list()

	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.generic_survivor_spawns) //make a list of all valid generic spawns
		generic_landmarks += spawner

	var/hostile_scenario = SSnightmare.get_scenario_is_hostile_survivor()
	for(var/priority = 1 to LOWEST_SPAWN_PRIORITY)
		if(length(GLOB.survivor_spawns_by_priority["[priority]"]))
			for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.survivor_spawns_by_priority["[priority]"])
				if(spawner.archetype == INSERT_SYNTH) //dont add synth spawns, add CO and normal ones as a fallback
					continue
				if(spawner.hostile == hostile_scenario)
					available_landmarks += spawner

/datum/job/civilian/survivor/commanding_officer/assign_landmark(mob/new_player, latejoin)
	if(!new_player?.client)
		return FALSE

	if(slotted_landmarks[new_player] != null)
		return TRUE // Already assigned a landmark (namely precount may have slotted us)

	//insert CO or map that allowed a CO to roll but has an insert with no CO, spawn as if normal survivor
	var/list/valid_prefs = get_valid_prefs(new_player)
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in available_landmarks)
		if(spawner.archetype == INSERT_CO || (spawner.archetype in valid_prefs) || (spawner.archetype == INSERT_NONE && spawner.spawn_priority != LOWEST_SPAWN_PRIORITY)) //only add landmarks that match prefs or CO or generic ones. CO landmarks are always the highest priority, so if one exists, it will get picked first
			//If there is an insert but the player has it disabled in prefs, return FALSE
			if(!HAS_FLAG(new_player.client.prefs.toggles_insert, PLAY_INSERT_CO))
				return FALSE
			slotted_landmarks[new_player] = spawner
			available_landmarks -= spawner
			GLOB.survivor_spawns_by_priority -= spawner
			return TRUE

	// There is no insert, so now we have to assign a random generic spawn
	var/obj/effect/landmark/survivor_spawner/spawner = SAFEPICK(generic_landmarks)
	if(spawner) //if there is a generic spawn, use it
		slotted_landmarks[new_player] = spawner
		generic_landmarks -= spawner
		GLOB.generic_survivor_spawns -= spawner
		return TRUE

	return FALSE

/datum/job/civilian/survivor/commanding_officer/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
	if(picked_spawner.equipment) //insert with CO, filtered by assign_landmark()
		arm_equipment(equipping_human, picked_spawner.equipment, FALSE, TRUE)
	else if(length(CO_survivor_types)) //map with guaranteed CO slot
		arm_equipment(equipping_human, pick(CO_survivor_types), FALSE, TRUE)
	else //map that has an insert that enabled rolling for CO but the insert didn't fire and there is no default CO equipment, thus equip as a normal survivor
		..()

/datum/job/civilian/survivor/commanding_officer/spawn_in_player(mob/new_player/new_player)
	. = ..()
	if(MODE_HAS_FLAG(MODE_SURVIVE)) // Also treat them as a late join for survive mode since its too awkward to precount them due to set_spawn_positions implementation
		SSticker.mode.latejoin_tally += GLOB.RoleAuthority.calculate_role_weight(src)

/datum/job/civilian/survivor/unlimited
	title = JOB_SURVIVOR_UNLIMITED
	total_positions = 0
	spawn_positions = INFINITY
	late_joinable = TRUE
	/// List of late join locker weakrefs
	var/list/datum/weakref/latejoin_lockers

/datum/job/civilian/survivor/unlimited/setup_requirements(list/L)
	return list() // No timelock

/datum/job/civilian/survivor/unlimited/set_spawn_positions(count)
	return

/datum/job/civilian/survivor/unlimited/get_total_positions(latejoin)
	if(!latejoin)
		return spawn_positions

	// Cleanup latejoin locker lists if conditions changed
	var/list/spawners = available_landmarks
	if(!insert_present_flag) // generics not relevant if an insert is present
		spawners += generic_landmarks
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in spawners)
		for(var/datum/weakref/locker_ref as anything in spawner.latejoin_lockers)
			var/obj/structure/closet/locker = locker_ref.resolve()
			if(!locker || locker.ever_opened || !locker.anchored)
				spawner.latejoin_lockers -= locker_ref
				latejoin_lockers -= locker_ref
				continue

	return length(latejoin_lockers) + current_positions

/datum/job/civilian/survivor/unlimited/create_landmark_lists(force)
	. = ..()

	if(!isnull(latejoin_lockers) && !force)
		return // Already set up

	latejoin_lockers = list()

	var/list/possible_lockers = list()
	for(var/obj/structure/closet/locker as anything in GLOB.closet_list)
		if(!is_ground_level(locker.z) || should_block_game_interaction(locker))
			continue
		if(locker.ever_opened)
			continue
		if(locker.type != /obj/structure/closet) // TODO: For now we strict type
			continue
		if(!locker.store_mobs || locker.wall_mounted || !locker.anchored)
			continue
		possible_lockers += locker

	var/list/spawners = available_landmarks
	if(!insert_present_flag) // generics not relevant if an insert is present
		spawners |= generic_landmarks
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in spawners)
		var/area/spawner_area = get_area(spawner)
		for(var/obj/structure/closet/locker as anything in possible_lockers)
			if(locker.loc?.loc != spawner_area)
				continue
			var/datum/weakref/reference = WEAKREF(locker)
			LAZYADD(spawner.latejoin_lockers, reference)
			latejoin_lockers |= reference

		if(!LAZYLEN(spawner.latejoin_lockers) && length(possible_lockers))
			// Try to ensure every spawner has atleast one latejoin possibility
			var/datum/weakref/reference = WEAKREF(pick(possible_lockers))
			LAZYADD(spawner.latejoin_lockers, reference)
			latejoin_lockers |= reference

	log_debug("Configured [length(latejoin_lockers)] late join lockers.[insert_present_flag ? " (Insert Present)" : ""]")

/// Takes a list of survivor_spawner with insert archetypes and performs a weighted pick for one
/datum/job/civilian/survivor/proc/pick_fallback_spawner(list/spawner_options)
	RETURN_TYPE(/obj/effect/landmark/survivor_spawner)

	var/static/list/standard_pickweights = INSERT_TYPE_FALLBACK_PICK_WEIGHT
	var/list/archetypes = list()

	// Figure out what archetypes are even available
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in spawner_options)
		if(!(spawner.archetype in archetypes))
			archetypes[spawner.archetype] = standard_pickweights[spawner.archetype]

	// Pick one
	var/selected_type = pick_weight(archetypes)

	// Return one with that type we picked
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in spawner_options)
		if(spawner.archetype == selected_type)
			return spawner

	stack_trace("pick_fallback_spawner failed!") // Shouldn't happen unless you're misusing this proc
	return spawner_options[1]

/datum/job/civilian/survivor/unlimited/assign_landmark(mob/new_player, latejoin)
	create_landmark_lists() // Survive mode wants survivors in the precount

	if(!new_player?.client)
		return FALSE

	if(slotted_landmarks[new_player] != null)
		return TRUE // Already assigned a landmark (namely precount may have slotted us)

	// Mostly should replicate /datum/job/civilian/survivor/assign_landmark but latejoins require lockers, we don't consume the landmarks (and so select differently)
	var/static/list/standard_caps_per_insert_type = MAX_SURVIVOR_UNLIMITED_PER_INSERT_TYPE
	var/list/skipped = list()
	var/list/valid_prefs = get_valid_prefs(new_player)
	var/no_insert_archetypes = length(valid_prefs) == 0 // If the player's valid_prefs list is 0, they have opted out of all possible insert archetypes and cannot spawn if an insert is present
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in available_landmarks) // for inserts with a higher than default priority to spawn (all of them)
		// There is an insert and player has opted out of inserts, return FALSE
		if(no_insert_archetypes && spawner.archetype != INSERT_NONE)
			return FALSE
		if(latejoin && !LAZYLEN(spawner.latejoin_lockers))
			continue
		if((spawner.archetype in valid_prefs) || (spawner.archetype == INSERT_NONE && spawner.spawn_priority != LOWEST_SPAWN_PRIORITY)) //only add landmarks that match prefs or generic ones with elevated priority (none exist yet)
			if(standard_caps_per_insert_type[spawner.archetype] != -1 && SSticker.mode.survivors_by_insert_type_amounts[spawner.archetype] && SSticker.mode.survivors_by_insert_type_amounts[spawner.archetype] >= standard_caps_per_insert_type[spawner.archetype])
				// Soft cap met
				skipped += spawner
				continue

			slotted_landmarks[new_player] = spawner
			SSticker.mode.survivors_by_insert_type_amounts[spawner.archetype] += 1
			return TRUE

	if(length(skipped))
		var/obj/effect/landmark/survivor_spawner/spawner = pick_fallback_spawner(skipped)
		slotted_landmarks[new_player] = spawner
		SSticker.mode.survivors_by_insert_type_amounts[spawner.archetype] += 1
		return TRUE

	if(insert_present_flag) // There is an insert, but you didn't qualify for ANY spots in it, likely due to disabling most (but not all!) prefs. A shame... a real shame...
		return FALSE

	// There is no insert, so now we have to assign a random generic spawn
	for(var/obj/effect/landmark/survivor_spawner/spawner as anything in shuffle(generic_landmarks))
		if(latejoin && !LAZYLEN(spawner.latejoin_lockers))
			continue
		slotted_landmarks[new_player] = spawner
		return TRUE

	return FALSE

/datum/job/civilian/survivor/unlimited/spawn_in_player(mob/new_player/new_player, latejoin)
	if(!latejoin)
		return ..()

	var/obj/effect/landmark/survivor_spawner/picked_spawner = slotted_landmarks[new_player]
	. = ..()
	var/mob/living/carbon/human/character = .
	if(character)
		// ASSUMPTION: get_total_positions was performed before this call so its still up to date
		var/datum/weakref/locker_reference = pick_n_take(picked_spawner.latejoin_lockers)
		if(!length(picked_spawner.latejoin_lockers))
			picked_spawner.latejoin_lockers = null // For lazylist behavior
		var/obj/structure/closet/locker = locker_reference.resolve()
		character.forceMove(locker)
