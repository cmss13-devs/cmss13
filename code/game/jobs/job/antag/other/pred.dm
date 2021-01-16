#define PREDATOR_TO_MARINES_SPAWN_RATIO 1/40

/datum/job/antag/predator
	title = JOB_PREDATOR
	selection_class = "job_predator"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_WHITELISTED|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_YAUTJA
	supervisors = "Ancients"
	gear_preset = "Yautja Blooded"

/datum/job/antag/predator/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_PREDATOR][CLAN_RANK_YOUNG]" = "Yautja Young",
		"[JOB_PREDATOR][CLAN_RANK_BLOODED]" = "Yautja Blooded",
		"[JOB_PREDATOR][CLAN_RANK_ELITE]" = "Yautja Elite",
		"[JOB_PREDATOR][CLAN_RANK_ELDER]" = "Yautja Elder",
		"[JOB_PREDATOR][CLAN_RANK_LEADER]" = "Yautja Leader",
		"[JOB_PREDATOR][CLAN_RANK_ADMIN]" = "Yautja Ancient"
	)

/datum/job/antag/predator/set_spawn_positions(var/count)
	spawn_positions = max((round(count * PREDATOR_TO_MARINES_SPAWN_RATIO)), 4)
	total_positions = spawn_positions

/datum/job/antag/predator/spawn_in_player(var/mob/new_player/NP)
	if(!istype(NP))
		return

	NP.spawning = TRUE
	NP.close_spawn_windows()

	var/mob/living/carbon/human/yautja/Y = new(NP.loc)
	Y.lastarea = get_area(NP.loc)

	var/clan_id = CLAN_SHIP_PUBLIC
	var/datum/entity/clan_player/clan_info = NP?.client?.clan_info
	clan_info?.sync()
	if(clan_info?.clan_id)
		clan_id = clan_info.clan_id
	SSpredships.load_new(clan_id)
	var/list/turf/spawn_points = SSpredships.get_clan_spawnpoints(clan_id)

	Y.forceMove(pick(spawn_points))
	Y.job = NP.job
	Y.name = NP.real_name
	Y.voice = NP.real_name

	NP.mind_initialize()
	NP.mind.transfer_to(Y, TRUE)
	NP.mind.setup_human_stats()

	return Y

/datum/job/antag/predator/get_whitelist_status(var/list/roles_whitelist, var/client/player) // Might be a problem waiting here, but we've got no choice
	. = ..()
	if(!.)
		return

	if(!player.clan_info)
		return CLAN_RANK_BLOODED

	player.clan_info.sync() // pause here might be problematic, we'll see. If DB dies, then we're fucked

	var/rank = clan_ranks[player.clan_info.clan_rank]

	if(!rank)
		return CLAN_RANK_BLOODED

	if(!("[JOB_PREDATOR][rank]" in gear_preset_whitelist))
		return CLAN_RANK_BLOODED

	if(\
		(roles_whitelist[player.ckey] & (WHITELIST_YAUTJA_LEADER|WHITELIST_YAUTJA_COUNCIL)) &&\
		get_desired_status(player.prefs.yautja_status, WHITELIST_COUNCIL) == WHITELIST_NORMAL\
	)
		return CLAN_RANK_BLOODED

	return rank


/datum/job/antag/predator/announce_entry_message(var/mob/new_predator, var/account, var/whitelist_status)
	to_chat(new_predator, SPAN_NOTICE("You are <B>Yautja</b>, a great and noble predator!"))
	to_chat(new_predator, SPAN_NOTICE("Your job is to first study your opponents. A hunt cannot commence unless intelligence is gathered."))
	to_chat(new_predator, SPAN_NOTICE("Hunt at your discretion, yet be observant rather than violent."))

/datum/job/antag/predator/generate_entry_conditions(mob/living/M, var/whitelist_status)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_predator(M, whitelist_status == CLAN_RANK_ADMIN)
