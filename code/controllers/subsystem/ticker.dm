SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = SS_INIT_TICKER

	priority = SS_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/current_state = GAME_STATE_STARTUP	//State of current round used by process()
	var/force_ending = FALSE					//Round was ended by admin intervention
	var/bypass_checks = FALSE 				//Bypass mode init checks
	var/setup_failed = FALSE 				//If the setup has failed at any point

	var/start_immediately = FALSE //If true, there is no lobby phase, the game starts immediately.
	var/setup_done = FALSE //All game setup done including mode post setup and

	var/datum/game_mode/mode = null

	var/list/login_music = null						//Music played in pregame lobby

	var/delay_end = FALSE					//If set true, the round will not restart on it's own
	var/admin_delay_notice = ""				//A message to display to anyone who tries to restart the world after a delay

	var/time_left							//Pre-game timer
	var/start_at

	var/roundend_check_paused = FALSE

	var/round_start_time = 0
	var/list/round_start_events
	var/list/round_end_events

	var/graceful = FALSE //Will this server gracefully shut down?

	var/queue_delay = 0
	var/list/queued_players = list()		//used for join queues when the server exceeds the hard population cap

	// TODO: move this into mapview ss
	var/toweractive = FALSE

	var/list/minds = list()

	var/automatic_delay_end = FALSE

/datum/controller/subsystem/ticker/Initialize(timeofday)
	load_mode()

	var/all_music = CONFIG_GET(keyed_list/lobby_music)
	var/key = SAFEPICK(all_music)
	if(key)
		var/music_options = splittext(all_music[key], " ")
		login_music = list(music_options[1], music_options[2], music_options[3])

	return ..()


/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_STARTUP)
			if(Master.initializations_finished_with_no_players_logged_in && !length(GLOB.clients))
				return
			if(isnull(start_at))
				start_at = time_left || world.time + (CONFIG_GET(number/lobby_countdown) * 10)
			to_chat(world, SPAN_ROUNDBODY("Welcome to the pre-game lobby of [CONFIG_GET(string/servername)]!"))
			to_chat(world, SPAN_ROLE_BODY("Please, setup your character and select ready. Game will start in [round(time_left / 10) || CONFIG_GET(number/lobby_countdown)] seconds."))
			current_state = GAME_STATE_PREGAME
			fire()

		if(GAME_STATE_PREGAME)
			if(isnull(time_left))
				time_left = max(0, start_at - world.time)
			if(start_immediately)
				time_left = 0

			//countdown
			if(time_left < 0)
				return
			time_left -= wait

			if(time_left <= 0)
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)
				if(start_immediately)
					fire()

		if(GAME_STATE_SETTING_UP)
			setup_failed = !setup()
			if(setup_failed)
				current_state = GAME_STATE_STARTUP
				time_left = null
				start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
				start_immediately = FALSE
				Master.SetRunLevel(RUNLEVEL_LOBBY)

		if(GAME_STATE_PLAYING)
			mode.process(wait * 0.1)

			if(!roundend_check_paused && mode.check_finished(force_ending) || force_ending)
				current_state = GAME_STATE_FINISHED
				ooc_allowed = TRUE
				mode.declare_completion(force_ending)
				addtimer(CALLBACK(src, .proc/Reboot), 63 SECONDS)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)


/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, SPAN_BOLDNOTICE("Enjoy the game!"))
	var/init_start = world.timeofday
	//Create and announce mode
	mode = config.pick_mode(GLOB.master_mode)

	CHECK_TICK
	if(!mode.can_start(bypass_checks))
		to_chat(world, "Reverting to pre-game lobby.")
		QDEL_NULL(mode)
		RoleAuthority.reset_roles()
		return FALSE

	CHECK_TICK
	if(!mode.pre_setup() && !bypass_checks)
		QDEL_NULL(mode)
		to_chat(world, "<b>Error in pre-setup for [GLOB.master_mode].</b> Reverting to pre-game lobby.")
		RoleAuthority.reset_roles()
		return FALSE

	CHECK_TICK
	mode.announce()

	if(CONFIG_GET(flag/autooocmute))
		ooc_allowed = FALSE

	CHECK_TICK
	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)
	CHECK_TICK

	//Configure mode and assign player to special mode stuff
	if (!(mode.flags_round_type & MODE_NO_SPAWN))
		var/roles_to_roll = null
		if(length(mode.roles_to_roll))
			roles_to_roll = mode.roles_to_roll
		RoleAuthority.setup_candidates_and_roles(roles_to_roll) //Distribute jobs
		if(mode.flags_round_type & MODE_NEW_SPAWN)
			create_characters() // Create and equip characters
		else
			old_create_characters() //Create player characters and transfer them
			equip_characters()

	GLOB.data_core.manifest()

	log_world("Game start took [(world.timeofday - init_start) / 10]s")
	round_start_time = world.time
	//SSdbcore.SetRoundStart()

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	CHECK_TICK

	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc(TRUE)

	run_mapdaemon_batch()
	begin_game_recording()

	if((master_mode == "Distress Signal") && SSevents)
		SSevents.Initialize()

	setup_economy()

	shuttle_controller.setup_shuttle_docks()

	PostSetup()
	return TRUE


/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE
	mode.initialize_emergency_calls()
	mode.post_setup()

	if(round_statistics)
		to_world(SPAN_BLUE("<B>Welcome to [round_statistics.name]</B>"))

	supply_controller.process() 		//Start the supply shuttle regenerating points -- TLE

	for(var/i in GLOB.closet_list) //Set up special equipment for lockers and vendors, depending on gamemode
		var/obj/structure/closet/C = i
		INVOKE_ASYNC(C, /obj/structure/closet.proc/select_gamemode_equipment, mode.type)
	for(var/obj/structure/machinery/vending/V in machines)
		INVOKE_ASYNC(V, /obj/structure/machinery/vending.proc/select_gamemode_equipment, mode.type)

	setup_done = TRUE


//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()


//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending
	mode = SSticker.mode

	login_music = SSticker.login_music

	delay_end = SSticker.delay_end

	time_left = SSticker.time_left

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players

	switch(current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			Master.SetRunLevel(RUNLEVEL_POSTGAME)


/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.time_left))
		return round(max(0, start_at - world.time) / 10)
	return round(time_left / 10)


/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(time_left))	//remember, negative means delayed
		start_at = world.time + newtime
	else
		time_left = newtime


/datum/controller/subsystem/ticker/proc/load_mode()
	var/mode = trim(file2text("data/mode.txt"))
	if(mode)
		GLOB.master_mode = mode
	else
		GLOB.master_mode = "Extended"
	log_game("Saved mode is '[GLOB.master_mode]'")


/datum/controller/subsystem/ticker/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	WRITE_FILE(F, the_mode)


/datum/controller/subsystem/ticker/proc/Reboot(reason, delay)
	set waitfor = FALSE

	if(usr && !check_rights(R_SERVER))
		return

	if(graceful)
		to_chat_forced(world, "<h3>[SPAN_BOLDNOTICE("Shutting down...")]</h3>")
		world.Reboot(FALSE)
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDNOTICE("An admin has delayed the round end."))
		return

	to_chat(world, SPAN_BOLDNOTICE("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	var/start_wait = world.time
	sleep(delay - (world.time - start_wait))

	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDNOTICE("Reboot was cancelled by an admin."))
		return

	log_game("Rebooting World. [reason]")
	to_chat_forced(world, "<h3>[SPAN_BOLDNOTICE("Rebooting...")]</h3>")

	world.Reboot(TRUE)

/datum/controller/subsystem/ticker/proc/create_characters()
	if(!RoleAuthority)
		return

	for(var/mob/new_player/player in GLOB.player_list)
		if(!player || !player.ready || !player.mind || !player.job)
			continue

		INVOKE_ASYNC(src, .proc/spawn_and_equip_char, player)

/datum/controller/subsystem/ticker/proc/spawn_and_equip_char(var/mob/new_player/player)
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

/datum/controller/subsystem/ticker/proc/old_create_characters()
	for(var/mob/new_player/player in GLOB.player_list)
		if(!(player && player.ready && player.mind))
			continue

		if(!player.job && !player.mind.roundstart_picked)
			continue

		player.create_character()
		qdel(player)

/datum/controller/subsystem/ticker/proc/equip_characters()
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

