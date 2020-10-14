/datum/job/antag
	selection_class = "job_antag"
	supervisors =   "antagonists"
	late_joinable = FALSE

#define PREDATOR_TO_MARINES_SPAWN_RATIO 1/40

/datum/job/antag/predator
	title = JOB_PREDATOR
	selection_class = "job_predator"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_WHITELISTED|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_YAUTJA
	minimum_playtimes = list()
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
	spawn_positions = max((count * PREDATOR_TO_MARINES_SPAWN_RATIO), 4)
	total_positions = spawn_positions

/datum/job/antag/predator/spawn_in_player(var/mob/new_player/NP)
	if(!istype(NP))
		return

	NP.spawning = TRUE
	NP.close_spawn_windows()

	var/mob/living/carbon/human/yautja/Y = new(NP.loc)
	Y.lastarea = get_area(NP.loc)

	var/datum/entity/clan_player/clan_info = NP.client.clan_info
	var/list/spawn_points = get_clan_spawnpoints(CLAN_SHIP_PUBLIC)
	if(clan_info)
		clan_info.sync()
		if(clan_info.clan_id)
			spawn_points = get_clan_spawnpoints(clan_info.clan_id)
	
	Y.loc = pick(spawn_points)
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

	if(ticker && ticker.mode)
		ticker.mode.initialize_predator(M, whitelist_status == CLAN_RANK_ADMIN)

#define XENO_TO_MARINES_SPAWN_RATIO 1/4

/datum/job/antag/xenos
	title = JOB_XENOMORPH
	role_ban_alternative = "Alien"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_CUSTOM_SPAWN
	supervisors = "Queen"
	selection_class = "job_xeno"
	minimum_playtimes = list()

/datum/job/antag/xenos/set_spawn_positions(var/count)
	spawn_positions = max((count * XENO_TO_MARINES_SPAWN_RATIO), 1)
	total_positions = spawn_positions

/datum/job/antag/xenos/spawn_in_player(var/mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	transform_to_xeno(H, XENO_HIVE_NORMAL)

/datum/job/antag/xenos/proc/transform_to_xeno(var/mob/living/carbon/human/H, var/hive_index)
	var/datum/mind/new_xeno = H.mind
	new_xeno.setup_xeno_stats()
	var/datum/hive_status/hive = hive_datum[hive_index]

	H.first_xeno = TRUE
	H.stat = 1
	H.loc = pick(xeno_spawn)

	var/list/survivor_types = list(
		"Survivor - Scientist",
		"Survivor - Doctor",
		"Survivor - Security",
		"Survivor - Engineer"
	)
	arm_equipment(H, pick(survivor_types), FALSE, FALSE)

	H.job = title
	H.apply_damage(50, BRUTE)
	H.spawned_corpse = TRUE

	var/obj/structure/bed/nest/start_nest = new /obj/structure/bed/nest(H.loc) //Create a new nest for the host
	H.statistic_exempt = TRUE
	H.buckled = start_nest
	H.dir = start_nest.dir
	H.update_canmove()
	start_nest.buckled_mob = H
	start_nest.afterbuckle(H)

	var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H) //Put the initial larva in a host
	embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)
	embryo.hivenumber = hive.hivenumber

/datum/job/antag/xenos/equip_job(mob/living/M)
	return

/datum/job/antag/xenos/queen
	title = JOB_XENOMORPH_QUEEN
	role_ban_alternative = "Queen"
	supervisors = "Queen Mother"
	selection_class = "job_xeno_queen"
	total_positions = 1
	spawn_positions = 1
	minimum_playtimes = list(
		JOB_XENOMORPH = HOURS_9
	)

/datum/job/antag/xenos/queen/set_spawn_positions(var/count)
	return spawn_positions

/datum/job/antag/xenos/queen/transform_to_xeno(var/mob/new_player/NP, var/hive_index)
	var/datum/mind/queen_mind = NP.mind
	var/mob/living/original = queen_mind.current
	queen_mind.setup_xeno_stats()
	var/datum/hive_status/hive = hive_datum[hive_index]
	if(hive.living_xeno_queen)
		return

	// Make the list pretty
	var/spawn_list_names = list()
	for(var/T in queen_spawn_list)
		spawn_list_names += get_area(T)

	// Timed input, answer before the time is up
	// H'yup, that's how you do it, ugly as fuck
	var/list/spawn_name = list("temp")
	var/datum/temp = new()
	var/expiration = world.time + MINUTES_2
	spawn()
		src = temp
		spawn_name[1] = input(original, "Where do you want to spawn?") as null|anything in spawn_list_names
	while(spawn_name[1] == "temp")
		if(world.time > expiration)
			del(temp)
			break
		else
			sleep(SECONDS_2)

	var/turf/QS
	for(var/T in queen_spawn_list)
		if(get_area(T) == spawn_name[1])
			QS = T

	// Pick a random one if nothing was picked
	if(isnull(QS))
		QS = pick(queen_spawn_list)
		// Support maps without queen spawns
		if(isnull(QS))
			QS = pick(xeno_spawn)

	if(QS in queen_spawn_list)
		queen_spawn_list -= QS

	var/mob/living/carbon/Xenomorph/new_queen = new /mob/living/carbon/Xenomorph/Queen(QS, null, hive.hivenumber)
	queen_mind.transfer_to(new_queen)
	queen_mind.name = queen_mind.current.name

	new_queen.generate_name()

	SSround_recording.recorder.track_player(new_queen)

	new_queen.update_icons()

/datum/job/antag/xenos/queen/announce_entry_message(var/mob/new_queen, var/account, var/whitelist_status)
	to_chat(new_queen, "<B>You are now the alien queen!</B>")
	to_chat(new_queen, "<B>Your job is to spread the hive.</B>")
	to_chat(new_queen, "<B>You should start by building a hive core.</B>")
	to_chat(new_queen, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")