#define is_hive_living(hive) (!hive.hardcore || hive.living_xeno_queen)

/datum/game_mode/xenovs
    name = "Hive Wars"
    config_tag = "Hive Wars"
    required_players = 4 //Need at least 4 players
    xeno_required_num = 4 //Need at least four xenos.
    monkey_amount = 0.2 // Amount of monkeys per player
    flags_round_type = MODE_NO_SPAWN|MODE_NO_LATEJOIN|MODE_XVX

    var/list/structures_to_delete = list(/obj/effect/alien/weeds, /turf/closed/wall/resin, /obj/structure/mineral_door/resin, /obj/structure/bed/nest, /obj/item, /obj/structure/tunnel, /obj/structure/machinery/computer/shuttle_control)
    var/list/hives = list()
    var/list/hive_cores = list()

    var/sudden_death = FALSE
    var/time_until_sd = HOURS_1 + MINUTES_30

    var/list/current_hives = list()

    var/hive_larva_interval_gain = MINUTES_5

    var/round_time_larva_interval = 0
    var/round_time_sd = 0
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////


/datum/game_mode/xenovs/proc/setup_mapdata(map)
    switch(map)
        if(MAP_LV_624)
            monkey_types = list(/mob/living/carbon/human/farwa, /mob/living/carbon/human/monkey, /mob/living/carbon/human/neaera, /mob/living/carbon/human/stok)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO)

            if(readied_players > 70)
                hives += XENO_HIVE_CHARLIE

        if(MAP_ICE_COLONY)
            monkey_types = list(/mob/living/carbon/human/yiren)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE, XENO_HIVE_DELTA)

        if(MAP_BIG_RED)
            monkey_types = list(/mob/living/carbon/human/neaera)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE)
            if(readied_players > 100)
                hives += XENO_HIVE_DELTA

        if(MAP_PRISON_STATION)
            monkey_types = list(/mob/living/carbon/human/monkey)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE)
            structures_to_delete += /obj/structure/machinery/defenses/sentry/premade

        if(MAP_DESERT_DAM)
            monkey_types = list(/mob/living/carbon/human/stok)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE)
            if(readied_players > 100)
                hives += XENO_HIVE_DELTA

        if(MAP_SOROKYNE_STRATA)
            monkey_types = list(/mob/living/carbon/human/yiren)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO)
            if(readied_players > 70)
                hives += XENO_HIVE_CHARLIE

        if(MAP_CORSAT)
            monkey_types = list(/mob/living/carbon/human/yiren, /mob/living/carbon/human/farwa, /mob/living/carbon/human/monkey, /mob/living/carbon/human/neaera, /mob/living/carbon/human/stok)
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE, XENO_HIVE_DELTA)

        else
            monkey_types = list(/mob/living/carbon/human/monkey) //make sure we always have a monkey type
            hives = list(XENO_HIVE_ALPHA, XENO_HIVE_BRAVO)


/* Pre-pre-startup */
/datum/game_mode/xenovs/can_start()
    setup_mapdata(map_tag)
    xeno_starting_num = readied_players
    if(!initialize_starting_xenomorph_list(hives, TRUE))
        return
    return TRUE

/datum/game_mode/xenovs/announce()
    to_world("<span class='round_header'>The current map is - [map_tag]!</span>")

/* Pre-setup */
/datum/game_mode/xenovs/pre_setup()
    if(monkey_amount)
        if(monkey_types.len)
            for(var/i = min(round(monkey_amount*GLOB.clients.len), GLOB.monkey_spawns.len), i > 0, i--)

                var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
                var/monkey_to_spawn = pick(monkey_types)
                new monkey_to_spawn(T)


    for(var/atom/A in world)
        for(var/type in structures_to_delete)
            if(istype(A, type))
                if(istype(A, /turf))
                    var/turf/T = A
                    T.ScrapeAway()
                else
                    qdel(A)

    round_time_sd = (time_until_sd + world.time)

    update_controllers()

    ..()
    return TRUE

/datum/game_mode/xenovs/proc/update_controllers()
    //Update controllers while we're on this mode
    if(SSitem_cleanup)
        //Cleaning stuff more aggresively
        SSitem_cleanup.start_processing_time = 0
        SSitem_cleanup.percentage_of_garbage_to_delete = 1.0
        SSitem_cleanup.wait = MINUTES_1
        SSitem_cleanup.next_fire = MINUTES_1
        spawn(0)
            //Deleting Almayer, for performance!
            SSitem_cleanup.delete_almayer()
    if(SSdefcon)
        //Don't need DEFCON
        SSdefcon.wait = MINUTES_30
    if(SSxenocon)
        //Don't need XENOCON
        SSxenocon.wait = MINUTES_30

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/xenovs/post_setup()
    initialize_post_xenomorph_list(GLOB.xeno_hive_spawns)

    round_time_lobby = world.time
    for(var/area/A in all_areas)
        if(!(A.is_resin_allowed))
            A.is_resin_allowed = TRUE

    open_podlocks("map_lockdown")

    ..()

/datum/game_mode/xenovs/initialize_post_xenomorph_list(var/list/hive_spawns = GLOB.xeno_spawns)
    var/list/hive_spots = list()
    for(var/hive in hives)
        var/turf/spot = get_turf(pick(hive_spawns))
        hive_spots[hive_datum[hive]] = spot
        hive_spawns -= spot

        current_hives += hive_datum[hive].name

    for(var/datum/hive_status/hive in xenomorphs) //Build and move the xenos.
        for(var/datum/mind/ghost_mind in xenomorphs[hive])
            transform_xeno(ghost_mind, hive_spots[hive], hive.hivenumber, FALSE)
            ghost_mind.current.close_spawn_windows()

    // Have to spawn the queen last or the mind will be added to xenomorphs and double spawned
    for(var/datum/hive_status/hive in picked_queens)
        transform_queen(picked_queens[hive], hive_spots[hive], hive.hivenumber)
        picked_queens[hive].current.close_spawn_windows()

    for(var/datum/hive_status/hive in hive_spots)
        new/obj/effect/alien/resin/special/pool(hive_spots[hive], hive) // Spawn a hive pool so they all get fair xenos
        var/obj/effect/alien/resin/special/pylon/core/C = new(hive_spots[hive], hive)
        C.hardcore = TRUE // This'll make losing the hive core more detrimental than losing a Queen
        hive_cores += C

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

// Queen delay timer. No more instant evolves
/datum/game_mode/xenovs/check_queen_status(var/queen_time, var/hivenumber)
	var/datum/hive_status/hive = hive_datum[hivenumber]

	if(hive)
		hive.xeno_queen_timer = world.time + 5 MINUTES

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/xenovs/process()
    . = ..()
    if(--round_started > 0)
        return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.



    if(!round_finished)
        if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
            if(world.time > round_time_larva_interval)
                for(var/hive in hives)
                    hive_datum[hive].stored_larva += 1
                    hive_datum[hive].hive_ui.update_pooled_larva()

                round_time_larva_interval = world.time + hive_larva_interval_gain

            if(!sudden_death && world.time > round_time_sd)
                sudden_death = TRUE
                xeno_announcement("The hives have entered sudden death mode. No more respawns, no more Queens", "everything", HIGHER_FORCE_ANNOUNCE)
                for(var/obj/effect/alien/resin/special/pylon/core/C in hive_cores)
                    qdel(C)
                hive_cores = list()

            if(round_should_check_for_win)
                check_win()
            round_checkwin = 0


/datum/game_mode/xenovs/proc/get_xenos_hive(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBITT, ZTRAIT_MARINE_MAIN_SHIP)))
    var/list/list/hivenumbers = list()
    for(var/datum/hive_status/H in hive_datum)
        hivenumbers += list(H.name = list())

    for(var/mob/M in GLOB.player_list)
        if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
            var/mob/living/carbon/Xenomorph/X = M
            var/datum/hive_status/hive = hive_datum[X.hivenumber]
            if(!hive)
                continue

            if(istype(X) && is_hive_living(hive))
                hivenumbers[hive.name].Add(X)


    return hivenumbers

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/xenovs/check_win()
    if(SSticker.current_state != GAME_STATE_PLAYING)
        return

    var/list/living_player_list = get_xenos_hive()

    var/last_living_hive
    var/living_hives = 0

    for(var/H in living_player_list)
        if(length(living_player_list[H]) > 0)
            living_hives++
            last_living_hive = H
        else if (H in current_hives)
            xeno_announcement("\The [H] has been eliminated from the world", "everything", HIGHER_FORCE_ANNOUNCE)
            current_hives -= H


    if(!living_hives)
        round_finished = "No one has won."
    else if (living_hives == 1)
        round_finished = "The [last_living_hive] has won."


///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/xenovs/check_finished()
    if(round_finished)
        return TRUE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/xenovs/declare_completion()
    announce_ending()
    var/musical_track
    musical_track = pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')

    var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
    S.status = SOUND_STREAM
    sound_to(world, S)
    if(round_statistics)
        round_statistics.game_mode = name
        round_statistics.round_length = world.time
        round_statistics.end_round_player_population = GLOB.clients.len

        round_statistics.log_round_statistics()

    declare_completion_announce_xenomorphs()
    calculate_end_statistics()
    declare_random_fact()

    return TRUE

/datum/game_mode/xenovs/announce_ending()
    if(round_statistics)
        round_statistics.track_round_end()
    log_game("Round end result: [round_finished]")
    to_world("<span class='round_header'>|Round Complete|</span>")

    to_world(SPAN_ROUNDBODY("Thus ends the story of the battling hives on [map_tag]. [round_finished]"))
    to_world(SPAN_ROUNDBODY("The game-mode was: [master_mode]!"))
    to_world(SPAN_ROUNDBODY("End of Round Grief (EORG) is an IMMEDIATE 3 hour ban with no warnings, see rule #3 for more details."))

// for the toolbox
/datum/game_mode/xenovs/end_round_message()
    if(round_finished)
        return "Hive Wars Round has ended. [round_finished]"
    return "Hive Wars Round has ended. No one has won"
