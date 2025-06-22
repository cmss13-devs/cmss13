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
	flags_round_type = MODE_NO_LATEJOIN|MODE_PREDATOR

	latejoin_larva_drop = 0
	latejoin_larva_drop_early = 0

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

	///
	var/list/players = list()

	/// Whether the round has concluded.
	var/finished = 0

/datum/game_mode/hunter_games/New()
	. = ..()
	required_players = CONFIG_GET(number/hunter_games_required_players)

/datum/game_mode/hunter_games/get_roles_list()
	return GLOB.ROLES_HUNTER_GAMES

/////////////////////
///// PRE SETUP /////
/////////////////////

/datum/game_mode/hunter_games/pre_setup()
	. = ..()

	// No xenos, so no tunnels.
	QDEL_LIST(GLOB.xeno_tunnels)

	// Delete all the guns, replace any guns with a melee landmark as a fallback for maps without melee landmarks
	// the only guns should be from supply drops.
	for(var/gun in GLOB.gun_list)
		new /obj/effect/landmark/melee_weapon(get_turf(gun))
		qdel(gun)

	for(var/magazine in GLOB.ammo_magazine_list)
		qdel(magazine)

	// Delete the prop chestburst corpses, they tend to contain guns and other loot we want to control.
	for(var/corpse in GLOB.corpse_spawns)
		qdel(corpse)

	// weapon placing code goes here
	for(var/melee_spawner in GLOB.melee_weapon)
		place_drop(get_turf(melee_spawner))

	for(var/good_item in GLOB.good_items)
		place_drop(get_turf(good_item))

// this block below needs to be evaluated its copypasta
	for(var/mob/new_player/player in GLOB.new_player_list)
		if(player && player.ready)
			if(player.mind)
				player.job = "ROLE"
			else
				if(player.client)
					player.mind = new(player.key)
					player.mind_initialize()

/datum/game_mode/hunter_games/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

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

/datum/game_mode/hunter_games/get_escape_menu()
	return "Trying to be the last one standing on..."

/datum/game_mode/hunter_games/check_finished()
	if(finished != 0)
		return TRUE

	return FALSE

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/hunter_games/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(ROUND_TIME < 10 MINUTES)
		return
//	var/living_player_list[] = count_humans_and_xenos(get_affected_zlevels())
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

