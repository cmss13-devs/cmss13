var/global/datum/controller/gameticker/ticker = new()



/datum/controller/gameticker
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = FALSE
	var/datum/game_mode/mode = null
	var/post_game = FALSE
	var/event_time = null
	var/event = FALSE

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/pregame_timeleft = 0
	var/game_start_time = 0 // Global world start time.
	var/toweractive = FALSE
	var/delay_end = FALSE	//if set to nonzero, the round will not restart on it's own
	var/automatic_delay_end = FALSE

	var/round_end_announced = FALSE // Spam Prevention. Announce round end only once.
	var/datum/mind/liaison = null

/datum/controller/gameticker/proc/pregame()
	login_music = pick(
	"sound/music/1.ogg",
	"sound/music/2.ogg",
	"sound/music/3.ogg",
	"sound/music/4.ogg",
	"sound/music/5.ogg",
	"sound/music/6.ogg")
	do
		pregame_timeleft = PREROUND_TIME
		if(round_statistics)
			to_world("<center>[SPAN_BLUE("<B>[round_statistics.name]</B>")]</center>")
		to_world(SPAN_NOTICE("<center><B>Welcome to the pre-game lobby of Colonial Marines!</B></center>"))
		to_world(SPAN_NOTICE("<center>Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds.</center>"))
		while(current_state == GAME_STATE_PREGAME)
			for(var/i=0, i<10, i++)
				sleep(1)
				vote.process()
			if(going)
				pregame_timeleft--
			if(pregame_timeleft == config.vote_autogamemode_timeleft)
				if(!vote.time_remaining)
					vote.autogamemode()	//Quit calling this over and over and over and over.
					while(vote.time_remaining)
						for(var/i=0, i<10, i++)
							sleep(1)
							vote.process()
			if(pregame_timeleft <= 0)
				current_state = GAME_STATE_SETTING_UP
	while (!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	if(master_mode=="secret")
		hide_mode = 1
	var/list/datum/game_mode/runnable_modes
	if((master_mode=="random") || (master_mode=="secret"))
		runnable_modes = config.get_runnable_modes()
		if (runnable_modes.len==0)
			current_state = GAME_STATE_PREGAME
			to_world("<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")
			return 0
		if(secret_force_mode != "secret")
			var/datum/game_mode/M = config.pick_mode(secret_force_mode)
			if(M.can_start())
				mode = config.pick_mode(secret_force_mode)
		RoleAuthority.reset_roles()
		if(!mode)
			mode = pickweight(runnable_modes)
		if(mode)
			var/mtype = src.mode.type
			mode = new mtype
	else
		if(map_tag == MAP_WHISKEY_OUTPOST)
			mode = config.pick_mode("Whiskey Outpost")
			RoleAuthority.replace_jobs(src.mode.roles_for_mode)
		else
			mode = config.pick_mode(master_mode)
	if (!mode.can_start())
		to_world("<B>Unable to start [mode.name].</B> Not enough players, [mode.required_players] players needed. Reverting to pre-game lobby.")
		QDEL_NULL(mode)
		current_state = GAME_STATE_PREGAME
		RoleAuthority.reset_roles()
		return 0

	var/can_continue = src.mode.pre_setup()//Setup special modes
	if(!can_continue)
		QDEL_NULL(mode)
		current_state = GAME_STATE_PREGAME
		to_world("<B>Error setting up [master_mode].</B> Reverting to pre-game lobby.")
		RoleAuthority.reset_roles()
		return 0

	if(hide_mode)
		var/list/modes = new
		for (var/datum/game_mode/M in runnable_modes)
			modes+=M.name
		modes = sortList(modes)
		to_world("<B>The current game mode is - Secret!</B>")
		to_world("<B>Possibilities:</B> [english_list(modes)]")
	else
		src.mode.announce()

	//Configure mode and assign player to special mode stuff
	if (!(mode.flags_round_type & MODE_NO_SPAWN))
		if(mode.flags_round_type & MODE_NEW_SPAWN)
			var/roles_to_roll = null
			if(length(mode.roles_to_roll))
				roles_to_roll = mode.roles_to_roll
			RoleAuthority.setup_candidates_and_roles(roles_to_roll) //Distribute jobs
			create_characters() // Create and equip characters
		else
			var/roles_to_roll = null
			if(length(mode.roles_to_roll))
				roles_to_roll = mode.roles_to_roll
			RoleAuthority.setup_candidates_and_roles(roles_to_roll) //Distribute jobs
			old_create_characters() //Create player characters and transfer them
			equip_characters()

	collect_minds()
	GLOB.data_core.manifest()

	spawn(2)
		mode.initialize_emergency_calls()

	current_state = GAME_STATE_PLAYING

	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc(TRUE)

	run_mapdaemon_batch()
	begin_game_recording()

	if((master_mode == "Distress Signal") && SSevents)
		SSevents.Initialize()

	//here to initialize the random events nicely at round start
	setup_economy()

	shuttle_controller.setup_shuttle_docks()

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			qdel(S)
		if(round_statistics)
			to_world(SPAN_BLUE("<B>Welcome to [round_statistics.name]</B>"))
		to_world(SPAN_BLUE("<B>Enjoy the game!</B>"))

	if(config.autooocmute)
		to_world(SPAN_DANGER("<B>The OOC channel has been globally disabled due to round start!</B>"))
		ooc_allowed = !( ooc_allowed )

	supply_controller.process() 		//Start the supply shuttle regenerating points -- TLE

	Master.SetRunLevel(RUNLEVEL_GAME)

	if(config.sql_enabled)
		spawn(MINUTES_5)
		for(var/i in GLOB.closet_list) //Set up special equipment for lockers and vendors, depending on gamemode
			var/obj/structure/closet/C = i
			C.select_gamemode_equipment(mode.type)
		for(var/obj/structure/machinery/vending/V in machines)
			V.select_gamemode_equipment(mode.type)

	game_start_time = world.time
	return 1

/datum/controller/gameticker/proc/create_characters()
	if(!RoleAuthority)
		return

	for(var/mob/new_player/player in GLOB.player_list)
		if(!player || !player.ready || !player.mind || !player.job)
			continue

		INVOKE_ASYNC(src, .proc/spawn_and_equip_char, player)

/datum/controller/gameticker/proc/spawn_and_equip_char(var/mob/new_player/player)
	var/datum/job/J = RoleAuthority.roles_for_mode[player.job]
	var/mob/M = J.spawn_in_player(player)
	if(istype(M))
		J.equip_job(M)
		EquipCustomItems(M)

		if(M.client)
			var/client/C = M.client
			if(C.player_data && C.player_data.playtime_loaded && length(C.player_data.playtimes) == 0)
				msg_admin_niche("NEW PLAYER: <b>[key_name(player, 1, 1, 0)] (<A HREF='?_src_=admin_holder;ahelp=adminmoreinfo;extra=\ref[player]'>?</A>)</b>. IP: [player.lastKnownIP], CID: [player.computer_id]")

	QDEL_IN(player, 5)

/datum/controller/gameticker/proc/old_create_characters()
	for(var/mob/new_player/player in GLOB.player_list)
		if(!(player && player.ready && player.mind))
			continue

		if(!player.job && !player.mind.roundstart_picked)
			continue

		player.create_character()
		qdel(player)

/datum/controller/gameticker/proc/collect_minds()
	for(var/mob/living/player in GLOB.alive_mob_list)
		if(player.mind)
			ticker.minds += player.mind

/datum/controller/gameticker/proc/equip_characters()
	var/captainless=1
	if(mode && istype(mode,/datum/game_mode/huntergames)) // || istype(mode,/datum/game_mode/whiskey_outpost)
		return

	for(var/mob/living/carbon/human/player in GLOB.human_mob_list)
		if(player.mind)
			if(player.job == "Commanding Officers")
				captainless = FALSE
			if(player.job)
				RoleAuthority.equip_role(player, RoleAuthority.roles_by_name[player.job])
				EquipCustomItems(player)
			if(player.client)
				var/client/C = player.client
				if(C.player_data && C.player_data.playtime_loaded && length(C.player_data.playtimes) == 0)
					msg_admin_niche("NEW PLAYER: <b>[key_name(player, 1, 1, 0)] (<A HREF='?_src_=admin_holder;ahelp=adminmoreinfo;extra=\ref[player]'>?</A>)</b>. IP: [player.lastKnownIP], CID: [player.computer_id]")
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!istype(M,/mob/new_player))
				to_chat(M, "Marine commanding officer position not forced on anyone.")

/datum/controller/gameticker/process()
	if(current_state != GAME_STATE_PLAYING)
		return 0

	mode.process()

	var/game_finished = 0
	var/mode_finished = 0
	if (config.continous_rounds)
		if(EvacuationAuthority.dest_status == NUKE_EXPLOSION_FINISHED || EvacuationAuthority.dest_status == NUKE_EXPLOSION_GROUND_FINISHED) game_finished = 1
		mode_finished = (!post_game && mode.check_finished())
	else
		game_finished = (mode.check_finished() /* || (emergency_shuttle.returned() && emergency_shuttle.evac == 1)*/)
		mode_finished = game_finished

	if(!EvacuationAuthority.dest_status != NUKE_EXPLOSION_IN_PROGRESS && game_finished && (mode_finished || post_game))
		current_state = GAME_STATE_FINISHED

		spawn(1)
			declare_completion()

		spawn(50)
			end_game_recording()

			if (EvacuationAuthority.dest_status == NUKE_EXPLOSION_FINISHED || EvacuationAuthority.dest_status == NUKE_EXPLOSION_GROUND_FINISHED)
				log_game("Round ended by nuke")
			else
				log_game("Round ended by proper completion")

			if(config.autooocmute && !ooc_allowed)
				to_world(SPAN_DANGER("<B>The OOC channel has been globally enabled due to round end!</B>"))
				ooc_allowed = 1

			if(!delay_end && !automatic_delay_end)
				sleep(restart_timeout)
				if(!delay_end && !automatic_delay_end)
					world.Reboot()
				else
					to_world({"<hr>
					[SPAN_CENTERBOLD("An admin has delayed the round end.")]
					<hr>
					"})
			else
				to_world({"<hr>
					[SPAN_CENTERBOLD("An admin has delayed the round end.")]
					<hr>
					"})

	else if (mode_finished)
		post_game = TRUE

		mode.cleanup()

		//call a transfer shuttle vote
		spawn(50)
			if(!round_end_announced) // Spam Prevention. Now it should announce only once.
				to_world(SPAN_WARNING("The round has ended!"))
				round_end_announced = TRUE

	return 1

/datum/controller/gameticker/proc/calculate_end_statistics()
	mode.calculate_end_statistics()

/datum/controller/gameticker/proc/declare_completion()
	mode.declare_completion()//To declare normal completion.

	//calls auto_declare_completion_* for all modes
	for(var/handler in typesof(/datum/game_mode/proc))
		if (findtext("[handler]","auto_declare_completion_"))
			call(mode, handler)()

	return 1

/world/proc/has_round_started()
	return ticker && ticker.current_state >= GAME_STATE_PLAYING
