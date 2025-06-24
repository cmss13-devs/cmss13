/** Hunter Games gamemode
 * Battle royale mode inspired by the hunger games.
 * Players are spawned as contestants with (basically) no rules.
 * They are to fight to the death, there can only be one.
 * Predators will appear to agitate and moderate the games.
 * They want good, brutal fights to determine the strongest prey to hunt themselves.
 *
 * On every few process() we check for how many contestants are left alive, and end the game if a win condition is met.
 * Guns are replaced with melee weapons.
 */

/// Supply drop quality defines. passed as an arg to place_drop()

/// The melee weapons scattered around everywhere.
#define DROP_MELEE_WEAPON "drop_melee_weapon"
/// Some rarer, fancy stuff placed around.
#define DROP_GOOD_ITEM "drop_good_item"

/proc/check_hunter_games() // abbreviated gamemode checker for hunter games
	if(SSticker.mode == GAMEMODE_HUNTER_GAMES || GLOB.master_mode == GAMEMODE_HUNTER_GAMES)
		return TRUE
	return FALSE

/datum/game_mode/hunter_games
	name = GAMEMODE_HUNTER_GAMES
	config_tag = "Hunter Games"
	required_players = 2 // Generally intended as a lowpop mode.
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
	var/list/supply_votes = list()
	/// Snapshot of contestant # made during each win check.
	var/last_tally


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

	for(var/melee_spawner in GLOB.melee_weapon) // Spawn the roundstart melee weapons scattered around.
		place_drop(get_turf(melee_spawner), DROP_MELEE_WEAPON)

	for(var/good_item in GLOB.good_items) // Spawn some rare, upgraded goodies.
		place_drop(get_turf(good_item), DROP_GOOD_ITEM)

//////////////////////
///// POST SETUP /////
//////////////////////

/datum/game_mode/hunter_games/post_setup()
	. = ..()

	CONFIG_SET(flag/remove_gun_restrictions, TRUE) //This will allow anyone to use cool guns.
	addtimer(CALLBACK(src, PROC_REF(hunter_games_announce)), 10 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(hunter_games_announce_yautja)), 20 SECONDS)


/datum/game_mode/hunter_games/proc/hunter_games_announce()
	to_world("<B>The current game mode is - HUNTER GAMES!</B>")
	to_world("You have been dropped off on a frontier colony overrun with alien hunters who have turned it into a game preserve.")
	to_world("And you are both the hunter and the hunted!")
	to_world("Be the <B>last survivor</b> and <B>win glory</B>! Fight in any way you can! Team up or be a loner, it's up to you.")
	to_world("Be warned though - if someone hasn't died in 3 minutes, the watching hunters get irritated!")
	sound_to(world, 'sound/effects/siren.ogg')

/datum/game_mode/hunter_games/proc/hunter_games_announce_yautja()
	set waitfor = FALSE
	for(var/mob/living/carbon/human/yautja/yautja as anything in GLOB.yautja_mob_list)
		to_chat(yautja, "You are an honorable Yautja Hunter.")
		to_chat(yautja, "You and your huntmates have taken this human colony over.")
		to_chat(yautja, "Your objective, on this new game preserve, is to find the strongest prey from this batch of lowly humans.")
		to_chat(yautja, "To this end, you force them to fight to the death. With whatever means are available to them, one thing remains true.")
		to_chat(yautja, "There can only be one.")
		to_chat(yautja, "Ultimately, you are an observer of the games, and they are for your amusement.")
		to_chat(yautja, "Light interference in the interest of a more interesting battle is permitted, but hunting the contestants is not.")


///////////////////
///// PROCESS /////
///////////////////

/datum/game_mode/hunter_games/process()
	. = ..() // parent just returns false, so effectively . = FALSE

	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if((++round_checkwin >= 10) && GLOB.round_should_check_for_win) //Only check win conditions every 10 cycles, skip if round end checks disabled.
		check_win()
		round_checkwin = 0


//////////////////////////////////////////
//Checks to see who, if anyone has won. //
//////////////////////////////////////////

/datum/game_mode/hunter_games/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	if(ROUND_TIME < 2 MINUTES)
		return

	var/list/counted_players = count_participants()
	var/contestant_count = counted_players[1]
	var/yautja_count = counted_players[2]
//  var/xeno_count = counted_players[3]

	if(contestant_count < last_tally)
		var/delta_contestant = (last_tally - contestant_count)
		if(delta_contestant == 1)
			to_world(SPAN_ROUNDBODY("A contestant has died! There are now [contestant_count] contestants remaining!"))
			sound_to(world, 'sound/effects/explosionfar.ogg')
		else
			to_world(SPAN_ROUNDBODY("Multiple contestants have died! [delta_contestant] in fact. [contestant_count] are left!"))
			sound_to(world, 'sound/effects/explosionfar.ogg')

	last_tally = contestant_count

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_HUNTER_GAMES_ELSE // Nobody wins, because of some external reason
		return

	if(last_tally <= 0)
		round_finished = MODE_HUNTER_GAMES_NO_WINNER
		return

	if(last_tally == 1)
		round_finished = MODE_HUNTER_GAMES_LAST_STANDING
		return

	else if(yautja_count <= 0 && length(GLOB.yautja_mob_list) >= 4) // yautja_count only includes living yautja, yautja_mob_list includes all. If >3 yautja join and all die, this triggers.
		round_finished = MODE_HUNTER_GAMES_YAUTJA_DEATH // The contestants managed to kill their yautja capturers and earn their freedom, truly.
		return
// would like to figure out an intelligent way to make the above check not include cryoed, not sure yet.

/datum/game_mode/hunter_games/proc/count_participants()
	var/human_count = 0
	var/yautja_count = 0
	var/xeno_count = 0
	var/list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)) // Which levels are valid for contestants are filtered by trait.

	for(var/mob/living/carbon/potential_contestant in GLOB.alive_mob_list)
		if(!potential_contestant.stat == CONSCIOUS)
			continue

		if(!(potential_contestant.z in z_levels))
			continue

		if(should_block_game_interaction(potential_contestant))
			continue

		if(isxeno(potential_contestant))
			xeno_count++
			continue

		if(!ishuman_strict(potential_contestant)) // Preds counted separately.
			if(isyautja(potential_contestant))
				yautja_count++
			continue

		human_count++ //Add them to the amount of people who're alive.

	return list(human_count, yautja_count, xeno_count)


/datum/game_mode/hunter_games/announce_bioscans()
	return // Scan what?


/datum/game_mode/hunter_games/get_escape_menu()
	return "Trying to be the last one standing on..."


/datum/game_mode/hunter_games/check_finished()
	if(round_finished)
		return TRUE


//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////

/datum/game_mode/hunter_games/declare_completion()
	. = ..()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_HUNTER_GAMES_ELSE)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "hunting_draw"

		if(MODE_HUNTER_GAMES_NO_WINNER)
			musical_track = 'sound/theme/sad_loss1.ogg'
			end_icon = "hunting_draw"

		if(MODE_HUNTER_GAMES_LAST_STANDING)
			musical_track = 'sound/theme/neutral_hopeful1.ogg'
			end_icon = "hunting_minor"

		if(MODE_HUNTER_GAMES_YAUTJA_DEATH)
			musical_track = 'sound/theme/winning_triumph1.ogg'
			end_icon = "hunting_major"

		else
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			end_icon = "draw"

	var/sound/theme = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	theme.status = SOUND_STREAM
	sound_to(world, theme)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)

		GLOB.round_statistics.log_round_statistics()

	calculate_end_statistics()
	show_end_statistics(end_icon)

	addtimer(CALLBACK(src, PROC_REF(declare_completion_announce_predators)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(declare_fun_facts)), 2 SECONDS)

	GLOB.round_statistics?.save()

	return TRUE


// for the toolbox
/datum/game_mode/hunter_games/end_round_message()
	switch(round_finished)
		if(MODE_HUNTER_GAMES_ELSE)
			return "Round has ended. The games ended prematurely."
		if(MODE_HUNTER_GAMES_NO_WINNER)
			return "Round has ended. There was no last man standing."
		if(MODE_HUNTER_GAMES_LAST_STANDING)
			return "Round has ended. There could only be one."
		if(MODE_HUNTER_GAMES_YAUTJA_DEATH)
			return "Round has ended. The yautja were eliminated."
	return "Round has ended in a strange way."


/datum/game_mode/hunter_games/announce_ending()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("| Round Complete: [round_finished] |"))
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDBODY("Thus ends the story of the brave survivors on [SSmapping.configs[GROUND_MAP].map_name].\nThe game-mode was: [GLOB.master_mode]!\n[CONFIG_GET(string/endofroundblurb)]"))


/datum/game_mode/hunter_games/declare_completion_announce_predators()
	set waitfor = 0
	if(length(predators))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("<br>The Predators were:")
		for(var/entry in predators)
			dat += "<br>[entry] was [predators[entry]["Name"]] [SPAN_BOLDNOTICE("([predators[entry]["Status"]])")]"
		to_world("[dat]")


/datum/game_mode/hunter_games/declare_fun_facts() // no need for xeno facts
	set waitfor = 0
	to_chat_spaced(world, margin_bottom = 0, html = SPAN_ROLE_BODY("|______________________|"))
	to_world(SPAN_ROLE_HEADER("FUN FACTS"))
	var/list/fact_types = subtypesof(/datum/random_fact)
	for(var/fact_type as anything in fact_types)
		var/datum/random_fact/fact_human = new fact_type(set_check_human = TRUE, set_check_xeno = FALSE)
		fact_human.announce()
	to_chat_spaced(world, margin_top = 0, html = SPAN_ROLE_BODY("|______________________|"))
