//THIS IS A BLANK LABEL ONLY SO PEOPLE CAN SEE WHEN WE RUNNIN DIS BITCH.   Should probably write a real one one day.  Maybe.
/datum/game_mode/infection
	name = "Infection"
	config_tag = "Infection"
	required_players = 0 //otherwise... no zambies
	latejoin_larva_drop = 0
	flags_round_type = MODE_INFECTION //Apparently without this, the game mode checker ignores this as a potential legit game mode.
	votable = FALSE // infection borked
	taskbar_icon = 'icons/taskbar/gml_infection.png'

/datum/game_mode/infection/announce()
	to_world("<B>The current game mode is - ZOMBIES!</B>")
	to_world("<B>Just have fun and role-play!</B>")
	to_world("<B>If you die as a zombie, you come back.  NO MATTER HOW MUCH DAMAGE.</B>")
	to_world("<B>Don't ahelp asking for specific details, you won't get them.</B>")

/datum/game_mode/infection/get_roles_list()
	return GLOB.ROLES_USCM

/datum/game_mode/infection/pre_setup()
	return ..()

/datum/game_mode/infection/post_setup()
	initialize_post_survivor_list()
	initialize_post_marine_gear_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()

	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(map_announcement)), 20 SECONDS)
	return ..()

/datum/game_mode/infection/proc/map_announcement()
	if(SSmapping.configs[GROUND_MAP].infection_announce_text)
		var/rendered_announce_text = replacetext(SSmapping.configs[GROUND_MAP].infection_announce_text, "###SHIPNAME###", MAIN_SHIP_NAME)
		marine_announcement(rendered_announce_text, "[MAIN_SHIP_NAME]")
	else if(SSmapping.configs[GROUND_MAP].announce_text) //if we missed a infection text for above, or just don't need a special one, we just use default announcement
		var/rendered_announce_text = replacetext(SSmapping.configs[GROUND_MAP].announce_text, "###SHIPNAME###", MAIN_SHIP_NAME)
		marine_announcement(rendered_announce_text, "[MAIN_SHIP_NAME]")

/datum/game_mode/infection/proc/initialize_post_survivor_list()
	if(synth_survivor)
		transform_survivor(synth_survivor, TRUE)
	for(var/datum/mind/survivor in survivors)
		if(transform_survivor(survivor) == 1)
			survivors -= survivor

/datum/game_mode/infection/can_start(bypass_checks = FALSE)
	initialize_starting_survivor_list()
	return TRUE

//We don't actually need survivors to play, so long as aliens are present.
/datum/game_mode/infection/proc/initialize_starting_survivor_list()
	var/list/datum/mind/possible_human_survivors = get_players_for_role(JOB_SURVIVOR)
	var/list/datum/mind/possible_synth_survivors = get_players_for_role(JOB_SYNTH_SURVIVOR)

	var/list/datum/mind/possible_survivors = possible_human_survivors.Copy() //making a copy so we'd be able to distinguish between survivor types

	for(var/datum/mind/A in possible_synth_survivors)
		if(A.roundstart_picked)
			possible_synth_survivors -= A
			continue

		if(A.current.client?.check_whitelist_status(WHITELIST_SYNTHETIC))
			if(A in possible_survivors)
				continue //they are already applying to be a survivor
			else
				possible_survivors += A
				continue

		possible_synth_survivors -= A

	possible_survivors = shuffle(possible_survivors) //Shuffle them up a bit
	if(length(possible_survivors)) //We have some, it looks like.
		for(var/datum/mind/A in possible_survivors) //Strip out any xenos first so we don't double-dip.
			if(A.roundstart_picked)
				possible_survivors -= A

		if(length(possible_survivors)) //We may have stripped out all the contendors, so check again.
			var/i = surv_starting_num
			var/datum/mind/new_survivor
			while(i > 0)
				if(!length(possible_survivors))
					break  //Ran out of candidates! Can't have a null pick(), so just stick with what we have.
				new_survivor = pick(possible_survivors)
				if(!new_survivor)
					break  //We ran out of survivors!
				if(!synth_survivor && (new_survivor in possible_synth_survivors))
					new_survivor.roundstart_picked = TRUE
					synth_survivor = new_survivor
				else if(new_survivor in possible_human_survivors) //so we don't draft people that want to be synth survivors but not normal survivors
					new_survivor.roundstart_picked = TRUE
					survivors += new_survivor
					i--
				possible_survivors -= new_survivor //either we drafted a survivor, or we're skipping over someone, either or - remove them

/datum/game_mode/infection/check_win()
	var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/zed = living_player_list[2]

	if(num_humans <=0 && zed >= 1)
		round_finished = MODE_INFECTION_ZOMBIE_WIN

/datum/game_mode/infection/check_finished()
	if(round_finished) return 1

/datum/game_mode/infection/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			check_win()
			round_checkwin = 0

/datum/game_mode/infection/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
	world << musical_track

	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)
		GLOB.round_statistics.log_round_statistics()

	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()


	return 1
