/datum/round_event_control/cryopod_malfunction
	name = "Cryopod Malfunction"
	typepath = /datum/round_event/cryopod_malfunction
	weight = 20 // probably could use some defines in the future - EVENT_UNLIKELY, EVENT_COMMON, etc.
	earliest_start = 5 MINUTES
	min_players = 1
	max_occurrences = 1 // we can increase the number once there's more random events around - 3 is a good number
	alert_observers = FALSE
	gamemode_blacklist = list(GAMEMODE_WHISKEY_OUTPOST, GAMEMODE_HIVE_WARS)

/datum/round_event/cryopod_malfunction
	announce_when = 5
	startWhen = 1
	endWhen = 5
	/// The mob typepath for spawning.
	var/spawn_type = /mob/living/simple_animal/cat
	/// If it's a pet, hostile, wildlife.
	var/spawn_group_type
	/// The pod the mob will spawn from.
	var/obj/structure/machinery/cryopod/cryogenic_pod

#define SPAWN_PET "domestic animal"
#define SPAWN_WILDLIFE "wild animal"

/datum/round_event/cryopod_malfunction/setup()
	. = ..()
	var/rng = rand(100)
	switch(rng)
		if(1 to 50)
			spawn_group_type = SPAWN_PET
			spawn_type = list(/mob/living/simple_animal/lizard, /mob/living/simple_animal/crab/Coffee) + typesof(/mob/living/simple_animal/bunny) + typesof(/mob/living/simple_animal/corgi) + typesof(/mob/living/simple_animal/parrot) + typesof(/mob/living/simple_animal/cat)
			spawn_type = pick(spawn_type)
		else
			spawn_group_type = SPAWN_WILDLIFE
			spawn_type = list(/mob/living/simple_animal/crab, /mob/living/simple_animal/cow, /mob/living/simple_animal/hostile/retaliate/goat, /mob/living/simple_animal/chick, /mob/living/simple_animal/chicken, /mob/living/simple_animal/bat, /mob/living/simple_animal/alien_slug) + subtypesof(/mob/living/simple_animal/mouse) + typesof(/mob/living/simple_animal/hostile/bear)
			spawn_type = pick(spawn_type)

/datum/round_event/cryopod_malfunction/announce()
	if(!cryogenic_pod) // wtf
		return
	shipwide_ai_announcement("A cryogenic malfunction has ejected a [spawn_group_type] in [get_area(cryogenic_pod)] area. Please secure it for hypersleep re-integration after the operation.")

/datum/round_event/cryopod_malfunction/start()
	var/list/cryopod_list
	for(var/obj/structure/machinery/cryopod/possible_cryopod as anything in GLOB.total_cryo_pods)
		if(!is_mainship_level(possible_cryopod.z) || istype(possible_cryopod, /obj/structure/machinery/cryopod/evacuation) || possible_cryopod.occupant)
			continue

		var/area/cryoarea = get_area(possible_cryopod)

		if(cryoarea.flags_area & AREA_CRYO_OR_PREP && spawn_group_type = SPAWN_WILDLIFE) // no spawncamping
			continue

		LAZYADD(cryopod_list, possible_cryopod)

	cryogenic_pod = pick(cryopod_list)

	if(!cryogenic_pod) // wtf
		return

	addtimer(CALLBACK(src, PROC_REF(pop_out), cryogenic_pod), 5 SECONDS)
	cryogenic_pod.balloon_alert_to_viewers("*rumble*")
	cryogenic_pod.sway_jitter(times = 5, steps = 10)
	cryogenic_pod.icon_state = "body_scanner_closed"
	cryogenic_pod.visible_message(SPAN_HIGHDANGER("[cryogenic_pod] starts rumbling violently!"))

/datum/round_event/cryopod_malfunction/proc/pop_out(obj/structure/machinery/cryopod/cryogenic_pod)
	new spawn_type(get_turf(cryogenic_pod))
	cryogenic_pod.balloon_alert_to_viewers("*pop!*")
	cryogenic_pod.icon_state = "body_scanner_open"
	cryogenic_pod.visible_message(SPAN_HIGHDANGER("You see something jump out of [cryogenic_pod]!"))

#undef SPAWN_PET
#undef SPAWN_WILDLIFE
