
//Digging through this is a pain. I'm leaving it mostly alone until a full rework takes place.
// that day may well be today.

///datum/game_mode/huntergames
//	name = "Hunter Games"
//	config_tag = "Hunter Games"
//	required_players = 1
//	flags_round_type = MODE_NO_LATEJOIN|MODE_PREDATOR
//	latejoin_larva_drop = 0 //You never know

	var/checkwin_counter = 0
	var/finished = 0
	var/dropoff_timer = 800 //10 minutes.
	var/last_drop = 0
	var/last_tally
	var/contestants[]
	var/supply_votes[]

	var/ticks_passed = 0
	var/drops_disabled = 0

	var/waiting_for_drop_votes = FALSE

//	votable = FALSE // borkeds
//	taskbar_icon = 'icons/taskbar/gml_hgames.png'

/datum/game_mode/huntergames/pre_setup()
	supply_votes = list()

	for(var/mob/new_player/player in GLOB.new_player_list)
		if(player && player.ready)
			if(player.mind)
				player.job = "ROLE"
			else
				if(player.client)
					player.mind = new(player.key)
					player.mind_initialize()
	return ..()

/datum/game_mode/huntergames/post_setup()
	contestants = list()
	for(var/i in GLOB.human_mob_list)
		var/mob/M = i
		if(M.client)
			contestants += M
			spawn_contestant(M)

	CONFIG_SET(flag/remove_gun_restrictions, TRUE) //This will allow anyone to use cool guns.

	addtimer(CALLBACK(src, PROC_REF(hunter_games_announce)), 10 SECONDS)
	spawn(10)
		to_world("<B>The current game mode is - HUNTER GAMES!</B>")
		to_world("You have been dropped off on a Weyland-Yutani colony overrun with alien Predators who have turned it into a game preserve.")
		to_world("And you are both the hunter and the hunted!")
		to_world("Be the <B>last survivor</b> and <B>win glory</B>! Fight in any way you can! Team up or be a loner, it's up to you.")
		to_world("Be warned though - if someone hasn't died in 3 minutes, the watching Predators get irritated!")
		world << sound('sound/effects/siren.ogg')

	spawn(1000)
		loop_package()

	return ..()

/datum/game_mode/huntergames/proc/hunter_games_announce()
	to_world("<b>The current game mode is - HUNTER GAMES!</b>")


/datum/game_mode/huntergames/proc/spawn_contestant(mob/M)

	var/mob/living/carbon/human/H
	var/turf/picked

	if(length(GLOB.hunter_primaries))
		picked = get_turf(pick_n_take(GLOB.hunter_primaries))
	else if(length(GLOB.hunter_secondaries))
		picked = get_turf(pick_n_take(GLOB.hunter_secondaries))
	else if(length(GLOB.survivor_spawns_by_priority))
		picked = get_turf(pick_n_take(GLOB.survivor_spawns_by_priority))
	else
		message_admins("There were no spawn points available for a contestant.")

	if(QDELETED(picked)) //???
		message_admins("Warning, null picked spawn in spawn_contestant")
		return 0

	if(istype(M,/mob/living/carbon/human)) //somehow?
		H = M
		if(length(H.contents))
			for(var/obj/item/I in H.contents)
				qdel(I)
		H.forceMove(picked)
	else
		H = new(picked)

	H.key = M.key
	if(H.client)
		H.client.change_view(GLOB.world_view_size)

	if(!H.mind)
		H.mind = new(H.key)
		H.mind_initialize()

//	H.name = H.real_name

	var/jobs = list(
	/datum/equipment_preset/survivor/civilian/hunter_games,
	)

	arm_equipment(H, pick(jobs), FALSE, TRUE)

	H.nutrition = NUTRITION_MAX

	//Give them some information
	spawn(4)
		to_chat(H, "<h2>There can be only one!!</h2>")
	return 1

/datum/game_mode/huntergames/proc/loop_package()
	while(finished == 0)
		if(!drops_disabled)
			to_world(SPAN_ROUNDBODY("Your Predator capturers have decided it is time to bestow a gift upon the scurrying humans."))
			to_world(SPAN_ROUNDBODY("One lucky contestant should prepare for a supply drop in 60 seconds."))
			for(var/mob/dead/D in GLOB.dead_mob_list)
				to_chat(D, SPAN_ROUNDBODY("Now is your chance to vote for a supply drop beneficiary! Go to Ghost tab, Spectator Vote!"))
			world << sound('sound/effects/alert.ogg')
			last_drop = world.time
			waiting_for_drop_votes = 1
			sleep(600)
			if(!length(supply_votes))
				to_world(SPAN_ROUNDBODY("Nobody got anything! .. weird."))
				waiting_for_drop_votes = 0
				supply_votes = list()
			else
				var/mob/living/carbon/human/winner = pick(supply_votes) //Way it works is, more votes = more odds of winning. But not guaranteed.
				if(istype(winner) && !winner.stat)
					to_world(SPAN_ROUNDBODY("The spectator and Predator votes have been tallied, and the supply drop recipient is <B>[winner.real_name]</B>! Congrats!"))
					world << sound('sound/effects/alert.ogg')
					to_world(SPAN_ROUNDBODY("The package will shortly be dropped off at: [get_area(winner.loc)]."))
					var/turf/drop_zone = locate(winner.x + rand(-2,2),winner.y + rand(-2,2),winner.z)
					if(istype(drop_zone))
						playsound(drop_zone,'sound/effects/bamf.ogg', 50, 1)
						place_drop(drop_zone,"god", 1)
				else
					to_world(SPAN_ROUNDBODY("The spectator and Predator votes have been talled, and the supply drop recipient is dead or dying<B>. Bummer.</b>"))
					world << sound('sound/misc/sadtrombone.ogg')
				supply_votes = list()
				waiting_for_drop_votes = 0
		sleep(5000)

/datum/game_mode/huntergames/process()
	. = ..()
	checkwin_counter++
	ticks_passed++
	if(prob(2))
		dropoff_timer += ticks_passed //Increase the timer the longer the round goes on.

	if(round_started > 0) //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.
		round_started--

	if(checkwin_counter >= 10) //Only check win conditions every 5 ticks.
		if(!finished)
			check_win()
		checkwin_counter = 0
	return 0

/datum/game_mode/huntergames/check_win()
	var/C = count_humans()
	if(C < last_tally)
		if(last_tally - C == 1)
			to_world(SPAN_ROUNDBODY("A contestant has died! There are now [C] contestants remaining!"))
			world << sound('sound/effects/explosionfar.ogg')
		else
			var/diff = last_tally - C
			to_world(SPAN_ROUNDBODY("Multiple contestants have died! [diff] in fact. [C] are left!"))
			spawn(7) world << sound('sound/effects/explosionfar.ogg')

	last_tally = C
	if(last_tally == 1 || ismob(last_tally))
		finished = 1
	else if (last_tally < 1)
		finished = 2
	else
		finished = 0

/datum/game_mode/huntergames/proc/count_humans()
	var/human_count = 0

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(istype(H) && H.stat == 0 && !istype(get_area(H.loc),/area/centcom) && !istype(get_area(H.loc),/area/tdome))
			if(H.species != "Yautja") // Preds don't count in round end.
				human_count += 1 //Add them to the amount of people who're alive.

	return human_count

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/huntergames/check_finished()
	if(finished != 0)
		return 1

	return 0


//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/huntergames/declare_completion()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	var/mob/living/carbon/winner = null

	for(var/mob/living/carbon/human/Q in GLOB.alive_mob_list)
		if(istype(Q) && Q.stat == 0 && !isyautja(Q) && !istype(get_area(Q.loc),/area/centcom) && !istype(get_area(Q.loc),/area/tdome))
			winner = Q
			break

	if(finished == 1 && !QDELETED(winner) && istype(winner))
		to_world(SPAN_DANGER("<FONT size = 4><B>We have a winner! >> [winner.real_name] ([winner.key]) << defeated all enemies!</B></FONT>"))
		to_world("<FONT size = 3><B>Well done, your tale of survival will live on in legend!</B></FONT>")

	else if(finished == 2)
		to_world(SPAN_DANGER("<FONT size = 4><B>NOBODY WON!?</B></FONT>"))
		to_world("<FONT size = 3><B>'Somehow you stupid humans managed to even fuck up killing yourselves. Well done.'</B></FONT>")
		world << 'sound/misc/sadtrombone.ogg'
	else
		to_world(SPAN_DANGER("<FONT size = 4><B>NOBODY WON!</B></FONT>"))
		to_world("<FONT size = 3><B>There was a winner, but they died before they could receive the prize!! Bummer.</B></FONT>")
		world << 'sound/misc/sadtrombone.ogg'

	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = count_humans()

		GLOB.round_statistics.log_round_statistics()
		GLOB.round_statistics.save()

	return 1

/datum/game_mode/proc/auto_declare_completion_huntergames()
	return

/datum/game_mode/huntergames/proc/place_drop(turf/T, OT = "crap", in_crate)
	if(!istype(T))
		return FALSE

	if(OT == "good" && !in_crate && prob(15))
		in_crate = 1 //Place some good drops in crates.

	var/obj_type //Object path.
	var/atom/location = in_crate ? new /obj/structure/closet/crate(T) : T //Where it's going to be placed.

	switch(OT)
		if("god")
			var/L[] = HUNTER_BEST_ITEM
			for(obj_type in L)
				new obj_type(location)
		if("good")
			obj_type = HUNTER_GOOD_ITEM
			new obj_type(location)
		else
			obj_type = HUNTER_OKAY_ITEM
			new obj_type(location)
