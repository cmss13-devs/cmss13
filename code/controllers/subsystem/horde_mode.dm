SUBSYSTEM_DEF(horde_mode)
	name  = "Horde Mode"
	wait  = 5 SECONDS
	flags = SS_KEEP_TIMING
	init_order = SS_INIT_HORDE_MODE

	var/list/mob/living/carbon/human/current_players = list()
	var/list/obj/effect/landmark/horde_mode/marinespawn/marine_spawns = list()
	var/list/obj/effect/landmark/horde_mode/xenospawn/xeno_spawns = list()
	var/list/obj/structure/prop/horde_mode/vent_spawn/vent_spawns = list()
	var/list/mob/living/simple_animal/hostile/alien/horde_mode/current_xenos = list()
	var/list/spawnable_xenos = list(
		/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone
	)
	var/list/spawnable_specialists = list()
	var/list/spawnable_bosses = list()
	var/list/corrupted_xenos = list()
	var/list/area/horde_mode/map_areas = list()
	var/list/player_clients = list()

	///How many xenos can be alive before we stop spawning them.
	var/spawn_max = 2
	///How many xenos will we spawn in total across the entire round.
	var/amount_to_spawn = 5
	///How many bosses to spawn.
	var/bosses_to_spawn = 0
	//Specialists are a semi-rare type of xeno which have unique attributes which make them unfit to being spawn in a large amount.
	///This var is used to SAVE the amount of specialists being spawned across multiple rounds.
	var/max_specialists = 0
	///How many specialits to spawn this round.
	var/specialists_to_spawn = 0

	///How many xenos to spawn per subsystem process.
	var/spawn_wave = 2

	var/round = 1
	var/round_ended = FALSE
	var/intro_played = FALSE

	var/xeno_health_mod = 0.35
	var/xeno_damage_mod = 0.5 // DOES NOT AFFECT RANGED ATTACKS


	var/max_sentries = 2
	var/sentries_active = 0
	var/list/new_round_sound = list('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg', 'sound/voice/4_xeno_roars.ogg')
	COOLDOWN_DECLARE(round_cooldown)

/datum/controller/subsystem/horde_mode/Initialize()
	. = ..()
	for(var/area/areas in GLOB.all_areas)
		if(istype(areas, /area/horde_mode))
			map_areas += areas

	if(length(map_areas))
		return SS_INIT_SUCCESS
	else
		return SS_INIT_FAILURE

/datum/controller/subsystem/horde_mode/fire(resumed = FALSE)
	if(!length(current_players) || !COOLDOWN_FINISHED(src, round_cooldown))
		return

	if(round == 1 && !intro_played)
		intro_played = TRUE
		sleep(4 SECONDS)
		send_player_message(SPAN_HIGHDANGER("You feel like there are a thousand eyes upon you."))
		sleep(6 SECONDS)
		send_player_message(SPAN_HIGHDANGER("A gust of wind passes by, the sound being interrupted by a distant roar. Soon enough it is followed up by a chorus of screeches and howls."))
		sleep(6 SECONDS)
		send_player_message(SPAN_HIGHDANGER("To your disdain, the sounds seem to be getting closer and closer..."))
		sleep(8 SECONDS)
		send_player_message(SPAN_HIGHDANGER("You know nothing good can come out of this. You steel yourself for what's about to come."))
		sleep(8 SECONDS)
		send_player_message(SPAN_HIGHDANGER("A cacophany of horrific screeches echo in the distance. They're here!"))
		playsound_z(SSmapping.levels_by_any_trait(ZTRAIT_HORDE_MODE), new_round_sound, volume = 75)

	if(!amount_to_spawn && !length(current_xenos) && !round_ended)
		COOLDOWN_START(src, round_cooldown, (20 + round) SECONDS)
		round_ended = TRUE
		for(var/list/player_in_list as anything in current_players)
			var/mob/living/player_mob = player_in_list["mob"]
			player_mob.rejuvenate()
		send_player_message(SPAN_HIGHDANGER("Seems like the horde has died down... Take a breather and ready yourself for the next one."))

	if(!amount_to_spawn && !length(current_xenos) && COOLDOWN_FINISHED(src, round_cooldown))
		increment_round()
		send_player_message(SPAN_HIGHDANGER("A cacophany of horrific screeches echo in the distance. They're here!"))
		playsound_z(SSmapping.levels_by_any_trait(ZTRAIT_HORDE_MODE), new_round_sound, volume = 75)

	if(bosses_to_spawn > 0)
		spawn_xeno(spawnable_bosses)
		bosses_to_spawn--

	for(spawn_wave, spawn_wave > 0, spawn_wave--)
		if(length(current_xenos) < spawn_max && amount_to_spawn > 0)
			spawn_xeno(spawnable_xenos)
			amount_to_spawn--
		if(specialists_to_spawn > 0 && prob(33))
			spawn_xeno(spawnable_specialists)
			specialists_to_spawn--

	spawn_wave = clamp(round, 1, 6)

/datum/controller/subsystem/horde_mode/proc/spawn_xeno(xeno_type)
	if(prob(50))
		INVOKE_ASYNC(src, PROC_REF(spawn_in_vent), xeno_type)
		return

	var/spawn_loc = SAFEPICK(xeno_spawns)
	var/mob_type = pick(xeno_type)
	if(isnull(spawn_loc))
		return
	new mob_type(spawn_loc)

/datum/controller/subsystem/horde_mode/proc/spawn_in_vent(xeno_type)
	for(var/area/horde_mode/picked_area in map_areas)
		if(picked_area.unlocked)
			var/obj/structure/prop/horde_mode/vent_spawn/picked_vent = SAFEPICK(picked_area.vents_in_area)
			if(picked_vent.is_spawning)
				sleep(3 SECONDS)

			var/spawn_loc = picked_vent.loc
			picked_vent.animate_vent()
			picked_vent.balloon_alert_to_viewers(UNLINT("something starts crawling out..."))
			picked_vent.is_spawning = TRUE
			sleep(3 SECONDS)
			var/mob_type = pick(xeno_type)
			new mob_type(spawn_loc)
			picked_vent.is_spawning = FALSE
			return

/datum/controller/subsystem/horde_mode/proc/increment_round(times = 1)
	for(times, times > 0, times--)
		round++
		handle_new_xenos()
		xeno_health_mod += 0.025
		xeno_damage_mod += 0.025
		amount_to_spawn = 3*round+2
		specialists_to_spawn = max_specialists
		if(spawn_max <= 5)
			spawn_max = clamp(2 + floor(round / 3), 2, 5)
		round_ended = FALSE
		for(var/area/all_areas in map_areas)
			all_areas.base_lighting_alpha += 7

/datum/controller/subsystem/horde_mode/proc/handle_new_xenos()
	if(round == 2)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode)
	if(round == 3)
		send_player_message(Gibberish("Alpha Squad, this is Lieutenant Miller from the USS Thunderhawk. Do you read me? Over.", 40), TRUE)
		sleep(5 SECONDS)
	if(round == 4)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/runner)
		send_player_message(SPAN_XENOHIGHDANGER("You catch a glimpse of something red in the distance... it's moving so fast!"))
	if(round == 5)
		send_player_message(Gibberish("We are detecting multiple marine life signatures. Come in, Alpha Squad. Over.", 30), TRUE)
		sleep(5 SECONDS)
	if(round == 6)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/lurker)
		spawnable_xenos.Remove(/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone)
		send_player_message(SPAN_XENOHIGHDANGER("The air seems to shimmer around you... or is it just your imagination?"))
	if(round == 7)
		spawnable_specialists.Add(/mob/living/simple_animal/hostile/alien/horde_mode/ranged/sentinel)
		max_specialists = 3
		send_player_message(SPAN_XENOHIGHDANGER("A dizzying vapour overcomes you..."))
	if(round == 8)
		send_player_message(Gibberish("The USS Thunderhawk is coming in to assist. I say again, the...", 20), TRUE)
		sleep(5 SECONDS)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/defender)
		send_player_message(SPAN_XENOHIGHDANGER("You start hearing loud thumps in the distance..."))
	if(round == 10)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/ranged/spitter)
		max_specialists = 4
		send_player_message(SPAN_XENOHIGHDANGER("Noxious fumes begin to assault your senses..."))
	if(round == 12)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/warrior)
		max_specialists = 5
		send_player_message(SPAN_XENOHIGHDANGER("You start hearing bloodcurdling roars in the distance..."))
	if(round == 14)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/burrower)
		max_specialists = 6
		send_player_message(SPAN_XENOHIGHDANGER("You hear something digging under you..."))
	if(round == 16)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/drone/healer)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/drone/gardener)
		max_specialists = 7
		send_player_message(SPAN_XENOHIGHDANGER("Something has changed..."))
	if(round == 18)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/runner/acid)
		max_specialists = 8
		send_player_message(SPAN_XENOHIGHDANGER("You hear the sizzling of something melting..."))
	if(round == 20)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/defender/steelcrest)
		max_specialists = 9
		send_player_message(SPAN_XENOHIGHDANGER("A bulwark is roaming..."))
	if(round == 22)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/lurker/vampire)
		max_specialists = 10
		send_player_message(SPAN_XENOHIGHDANGER("You see something hungry for blood..."))
	if(round == 24)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/hivelord)
		send_player_message(SPAN_XENOHIGHDANGER("Stronger weeds start appearing..."))
	if(round == 28)
		spawnable_bosses.Add(/mob/living/simple_animal/hostile/alien/horde_mode/ravager)
		bosses_to_spawn++
		send_player_message(SPAN_XENOHIGHDANGER("A killer is loose..."))
	if(round == 29)
		spawnable_bosses.Add(/mob/living/simple_animal/hostile/alien/horde_mode/boss)
		bosses_to_spawn++
		send_player_message(SPAN_XENOHIGHDANGER("The USS Thunderhawk is in orbit. We are sending in gunships to recon the area. Hang tight, it's almost over."), TRUE)
		sleep(5 SECONDS)
	if(round == 30)
		send_player_message(SPAN_XENOHIGHDANGER("Signal flares will be dropped at center point in T-10 seconds. Utilize them for CAS until our transport ship can get closer."), TRUE)
		sleep(5 SECONDS)

/datum/controller/subsystem/horde_mode/proc/update_points(mob/living/player_mob, point_amount)
	for(var/list/player as anything in current_players)
		if(player["mob"] == player_mob)
			player["points"] += point_amount

/datum/controller/subsystem/horde_mode/proc/send_player_message(message, radio_message = FALSE)
	for(var/list/player_in_list as anything in current_players)
		var/mob/player_mob = player_in_list["mob"]
		if(radio_message)
			playsound_client(player_mob.client, 'sound/effects/radiostatic.ogg', player_mob.loc, 50, FALSE)
			player_mob.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Incoming Transmission:</u></span><br>" + "[message]", /atom/movable/screen/text/screen_text/command_order, LIGHT_COLOR_BLUE)
			return

		to_chat(player_mob, message)

/datum/controller/subsystem/horde_mode/proc/return_random_player()
	var/list/all_players
	for(var/list/player_in_list as anything in current_players)
		var/mob/living/player_mob = player_in_list["mob"]
		if(player_mob.stat != DEAD)
			all_players += player_mob
	return pick(all_players)

/datum/controller/subsystem/horde_mode/proc/return_random_xeno()
	var/list/all_xenos = list()
	for(var/list/xenos_in_list as anything in current_xenos)
		var/mob/living/xeno_mob = xenos_in_list
		if(xeno_mob.stat != DEAD && xeno_mob.hivenumber != XENO_HIVE_CORRUPTED)
			all_xenos += xeno_mob
	return pick(all_xenos)

/datum/controller/subsystem/horde_mode/proc/handle_purchase(mob/living/player_mob, cost)
	for(var/list/player as anything in current_players)
		if(player["mob"] == player_mob)
			if(player["points"] >= cost)
				player["points"] -= cost
				return TRUE
			else
				playsound(player_mob.loc, 'sound/effects/horde_mode/purchase_denied.ogg')
				to_chat(player_mob, SPAN_WARNING("You don't have enough points to buy this!"))
				return FALSE

	to_chat(player_mob, SPAN_WARNING("This doesn't seem to be for you..."))
