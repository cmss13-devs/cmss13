/** Hunter Games gamemode
 * Battle royale mode inspired by the hunger games.
 * Players are spawned as contestants with (basically) no rules.
 * They are to fight to the death, there can only be one.
 * Predators will appear to agitate and moderate the games.
 * They want good, brutal fights to determine the strongest prey to hunt themselves.
 */

/proc/check_hunter_games() // abbreviated gamemode checker for hunter games
	if(SSticker.mode == GAMEMODE_HUNTER_GAMES || GLOB.master_mode == GAMEMODE_HUNTER_GAMES)
		return TRUE
	return FALSE

/datum/game_mode/hunter_games
	name = "Hunter Games"
	config_tag = "Hunter Games"
	required_players = 1
	flags_round_type = MODE_NO_LATEJOIN|MODE_PREDATOR|MODE_NEW_SPAWN

	latejoin_larva_drop = 0
	latejoin_larva_drop_early = 0
	corpses_to_spawn = 0

	votable = FALSE
	vote_cycle = 15 // approx. once a day, if it wins the vote
//	probability = 10  is this percent? I have no clue I can't figure out what this does.
	taskbar_icon = 'icons/taskbar/gml_hgames.png'

	// IBs are off and all splints are nanosplints, but you can't be revived-- permadeath helps discourage teams stomping.
	hardcore = TRUE
	starting_round_modifiers = list(
		/datum/gamemode_modifier/permadeath,
		/datum/gamemode_modifier/disable_ib,
		/datum/gamemode_modifier/indestructible_splints,
		)

	/// Time between spectator voted supply drops
	var/drop_time = 8 MINUTES
	/// ???
	var/waiting_for_drop_votes = FALSE
	/// ???
	var/list/supply_votes[]
	///
	var/list/players = list()

	/// Whether the round has concluded.
	var/finished = 0

/datum/game_mode/hunter_games/New()
	. = ..()
	required_players = CONFIG_GET(number/hunter_games_required_players)

/datum/game_mode/hunter_games/get_roles_list()
	return GLOB.ROLES_HUNTER_GAMES

/datum/game_mode/hunter_games/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/////////////////////
///// PRE SETUP /////
/////////////////////

/datum/game_mode/hunter_games/pre_setup()
	. = ..()

	// No xenos, so no tunnels.
	QDEL_LIST(GLOB.xeno_tunnels)
	QDEL_LIST(GLOB.ammo_magazine_list)
	QDEL_LIST(GLOB.corpse_spawns)	// Delete the prop chestburst corpses, they tend to contain guns and other loot we want to control.

	// Delete all the guns, replace any guns with a melee landmark as a fallback for maps without melee landmarks
	// the only guns should be from supply drops.
	for(var/gun in GLOB.gun_list)
		new /obj/effect/landmark/melee_weapon(get_turf(gun))
		qdel(gun)

	// weapon placing code goes here
	for(var/melee_spawner in GLOB.melee_weapon)
		place_drop(get_turf(melee_spawner))

	for(var/good_item in GLOB.good_items)
		place_drop(get_turf(good_item))

// this block below needs to be evaluated its copypasta
/*	for(var/mob/new_player/player in GLOB.new_player_list)
		if(player && player.ready)
			if(player.mind)
				player.job = "ROLE"
			else
				if(player.client)
					player.mind = new(player.key)
					player.mind_initialize()
*/
//////////////////////
///// POST SETUP /////
//////////////////////

/datum/game_mode/hunter_games/post_setup()
	. = ..()


///////////////////
///// PROCESS /////
///////////////////

/datum/game_mode/hunter_games/process()
	. = ..()

	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.



/datum/game_mode/hunter_games/announce_bioscans()
	return // Scan what?

/datum/game_mode/hunter_games/declare_completion_announce_fallen_soldiers()
	set waitfor = 0
	sleep(2 SECONDS)
	GLOB.fallen_list += GLOB.fallen_list_cross
	if(length(GLOB.fallen_list))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("In Flanders fields...<br>")
		dat += SPAN_CENTERBOLD("In memoriam of our fallen fighters: <br>")
		for(var/i = 1 to length(GLOB.fallen_list))
			if(i != length(GLOB.fallen_list))
				dat += "[GLOB.fallen_list[i]], "
			else
				dat += "[GLOB.fallen_list[i]].<br>"
		to_world("[dat]")

/datum/game_mode/hunter_games/declare_completion_announce_xenomorphs()
	return // Shouldn't be any.

/datum/game_mode/hunter_games/declare_completion_announce_medal_awards()
	return // Also shouldn't be any.

/datum/game_mode/hunter_games/declare_fun_facts() // no need for xeno facts
	set waitfor = 0
	sleep(2 SECONDS)
	to_chat_spaced(world, margin_bottom = 0, html = SPAN_ROLE_BODY("|______________________|"))
	to_world(SPAN_ROLE_HEADER("FUN FACTS"))
	var/list/fact_types = subtypesof(/datum/random_fact)
	for(var/fact_type as anything in fact_types)
		var/datum/random_fact/fact_human = new fact_type(set_check_human = TRUE, set_check_xeno = FALSE)
		fact_human.announce()
	to_chat_spaced(world, margin_top = 0, html = SPAN_ROLE_BODY("|______________________|"))

/datum/game_mode/hunter_games/get_escape_menu()
	return "Trying to be the last one standing on..."

/datum/game_mode/hunter_games/check_finished()
	if(finished != 0)
		return TRUE

	return FALSE

///////////////////////////
//Checks to see who won///
//////////////////////////
/*
/datum/game_mode/hunter_games/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(ROUND_TIME < 10 MINUTES)
		return
	var/living_player_list[]
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_INFESTATION_X_MINOR

//	if(!num_humans && num_xenos) //No humans remain alive.
//		round_finished = MODE_INFESTATION_X_MAJOR //Evacuation did not take place. Everyone died.
//	else if(num_humans && !num_xenos)
//		if(SSticker.mode && SSticker.mode.is_in_endgame)
//			round_finished = MODE_INFESTATION_X_MINOR //Evacuation successfully took place.
//		else
//			SSticker.roundend_check_paused = TRUE
//			round_finished = MODE_INFESTATION_M_MAJOR //Humans destroyed the xenomorphs.
//			ares_conclude()
//			addtimer(VARSET_CALLBACK(SSticker, roundend_check_paused, FALSE), MARINE_MAJOR_ROUND_END_DELAY)
//	else if(!num_humans && !num_xenos)
//		round_finished = MODE_INFESTATION_DRAW_DEATH //Both were somehow destroyed.
*/
///Checks for humans groundside.
/datum/game_mode/hunter_games/proc/check_ground_humans()
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_HUNTER_GAMES_GROUND_CHECK))
		return

	var/groundside_humans = 0

	for(var/mob/current_mob in GLOB.player_list)
		if(!is_ground_level(current_mob.z) || !current_mob.client || current_mob.stat == DEAD)
			continue

		if(ishuman_strict(current_mob))
			groundside_humans++
			continue

	TIMER_COOLDOWN_START(src, COOLDOWN_HUNTER_GAMES_GROUND_CHECK, 1 MINUTES)
