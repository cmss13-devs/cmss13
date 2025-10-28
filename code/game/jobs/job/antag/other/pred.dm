#define PREDATOR_TO_TOTAL_SPAWN_RATIO 1/80

/datum/job/antag/predator
	title = JOB_PREDATOR
	selection_class = "job_predator"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_YAUTJA
	supervisors = "Ancients"
	gear_preset = /datum/equipment_preset/yautja/blooded

	handle_spawn_and_equip = TRUE

/datum/job/antag/predator/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_PREDATOR][CLAN_RANK_YOUNG]" = /datum/equipment_preset/yautja/youngblood,
		"[JOB_PREDATOR][CLAN_RANK_BLOODED]" = /datum/equipment_preset/yautja/blooded,
		"[JOB_PREDATOR][CLAN_RANK_ELITE]" = /datum/equipment_preset/yautja/elite,
		"[JOB_PREDATOR][CLAN_RANK_ELDER]" = /datum/equipment_preset/yautja/elder,
		"[JOB_PREDATOR][CLAN_RANK_LEADER]" = /datum/equipment_preset/yautja/leader,
		"[JOB_PREDATOR][CLAN_RANK_ADMIN]" = /datum/equipment_preset/yautja/ancient
	)

/datum/job/antag/predator/set_spawn_positions(count)
	spawn_positions = max((floor(count * PREDATOR_TO_TOTAL_SPAWN_RATIO)), 4)
	total_positions = spawn_positions

/datum/job/antag/predator/spawn_and_equip(mob/new_player/player)
	player.spawning = TRUE
	player.close_spawn_windows()

	SSticker.mode.attempt_to_join_as_predator(player)

/datum/job/antag/predator/get_whitelist_status(client/player) // Might be a problem waiting here, but we've got no choice
	if(!player.clan_info)
		return CLAN_RANK_BLOODED

	player.clan_info.sync() // pause here might be problematic, we'll see. If DB dies, then we're fucked

	var/rank = GLOB.clan_ranks[player.clan_info.clan_rank]

	if(!rank)
		return CLAN_RANK_BLOODED

	if(!("[JOB_PREDATOR][rank]" in gear_preset_whitelist))
		return CLAN_RANK_BLOODED

	if(player.check_whitelist_status(WHITELIST_YAUTJA_LEADER|WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY) && get_desired_status(player.prefs.yautja_status, WHITELIST_COUNCIL) == WHITELIST_NORMAL)
		return CLAN_RANK_BLOODED

	return rank


/datum/job/antag/predator/announce_entry_message(mob/new_predator, account, whitelist_status)
	to_chat(new_predator, SPAN_NOTICE("You are <B>Yautja</b>, a great and noble hunter!"))
	to_chat(new_predator, SPAN_NOTICE("Follow the guidance of your elders and experienced hunters."))
	to_chat(new_predator, SPAN_NOTICE("Hunt at your discretion, yet be observant rather than violent."))
	to_chat(new_predator, SPAN_NOTICE("Most importantly, remember that dying in battle is the highest honour a Yautja could ask for."))

/datum/job/antag/predator/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()

	if(SSticker.mode)
		var/ignore_slot_count = whitelist_status == CLAN_RANK_ADMIN || whitelist_status == CLAN_RANK_LEADER || M?.client?.check_whitelist_status(WHITELIST_YAUTJA_LEADER|WHITELIST_YAUTJA_COUNCIL)
		SSticker.mode.initialize_predator(M, ignore_slot_count)

/datum/job/antag/young_blood
	title = ERT_JOB_YOUNGBLOOD
	selection_class = "ert_job_youngblood"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN
	supervisors = "Ancients"
	flags_whitelist = NO_FLAGS
	gear_preset = /datum/equipment_preset/yautja/non_wl

	handle_spawn_and_equip = TRUE

/datum/job/antag/young_blood/generate_entry_conditions(mob/living/hunter)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_predator(hunter, ignore_pred_num = TRUE)

/datum/timelock/young_blood
	name = "Young Blood Roles"

/datum/timelock/young_blood/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_YOUNGBLOOD_ROLES_LIST
