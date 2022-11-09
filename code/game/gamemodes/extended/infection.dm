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

/datum/game_mode/infection/pre_setup()
	return ..()

/datum/game_mode/infection/post_setup()
	initialize_post_survivor_list()
	initialize_post_marine_gear_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	spawn(50)
		marine_announcement("We've lost contact with the Weyland-Yutani's research facility, [name]. The [MAIN_SHIP_NAME] has been dispatched to assist.", "[MAIN_SHIP_NAME]")
	return ..()

/datum/game_mode/infection/proc/initialize_post_survivor_list()
	if(synth_survivor)
		transform_survivor(synth_survivor, TRUE)
	for(var/datum/mind/survivor in survivors)
		if(transform_survivor(survivor) == 1)
			survivors -= survivor
	tell_survivor_story()

/datum/game_mode/infection/can_start()
	initialize_starting_survivor_list()
	return 1

//We don't actually need survivors to play, so long as aliens are present.
/datum/game_mode/infection/proc/initialize_starting_survivor_list()
	var/list/datum/mind/possible_human_survivors = get_players_for_role(JOB_SURVIVOR)
	var/list/datum/mind/possible_synth_survivors = get_players_for_role(JOB_SYNTH_SURVIVOR)

	var/list/datum/mind/possible_survivors = possible_human_survivors.Copy() //making a copy so we'd be able to distinguish between survivor types

	for(var/datum/mind/A in possible_synth_survivors)
		if(A.roundstart_picked)
			possible_synth_survivors -= A
			continue

		if(RoleAuthority.roles_whitelist[ckey(A.key)] & WHITELIST_SYNTHETIC)
			if(A in possible_survivors)
				continue //they are already applying to be a survivor
			else
				possible_survivors += A
				continue

		possible_synth_survivors -= A

	possible_survivors = shuffle(possible_survivors) //Shuffle them up a bit
	if(possible_survivors.len) //We have some, it looks like.
		for(var/datum/mind/A in possible_survivors) //Strip out any xenos first so we don't double-dip.
			if(A.roundstart_picked)
				possible_survivors -= A

		if(possible_survivors.len) //We may have stripped out all the contendors, so check again.
			var/i = surv_starting_num
			var/datum/mind/new_survivor
			while(i > 0)
				if(!possible_survivors.len)
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
	var/living_player_list[] = count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
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

	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.end_round_player_population = GLOB.clients.len
		round_statistics.log_round_statistics()

	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	return 1
