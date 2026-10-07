#define HORSEMAN_EARLIEST_SPAWN (1 MINUTES)
#define HORSEMAN_DELAY_MIN (0 MINUTES)
#define HORSEMAN_DELAY_MAX (1 MINUTES)
#define HORSEMAN_POLL_TIMEOUT (20 SECONDS)
#define HORSEMAN_RETRY_DELAY (1 MINUTES)
#define HORSEMAN_SPAWN_RANGE_MIN 5
#define HORSEMAN_SPAWN_RANGE_MAX 7
#define HORSEMAN_WALL_BURST_RADIUS 2

GLOBAL_DATUM(horseman_event, /datum/game_decorator/halloween/horseman)

/datum/game_decorator/halloween/horseman
	var/spawn_time
	var/turf/fallback_turf
	var/spawned = FALSE
	var/polling = FALSE

/datum/game_decorator/halloween/horseman/New()
	. = ..()
	GLOB.horseman_event = src

/datum/game_decorator/halloween/horseman/decorate()
	if(!istype(SSticker.mode, /datum/game_mode/colonialmarines))
		return
	message_admins("Horseman will spawn[duration2text(spawn_time)] round time, if it doesnt feel free to spawn one from the admin event tab.")

/datum/game_decorator/halloween/horseman/proc/try_start()
	if(spawned || SSticker.current_state != GAME_STATE_PLAYING)
		return
	var/deploy_time = SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK
	if(world.time < deploy_time)
		addtimer(CALLBACK(src, PROC_REF(try_start)), deploy_time - world.time)
		return
	if(polling)
		addtimer(CALLBACK(src, PROC_REF(try_start)), HORSEMAN_RETRY_DELAY)
		return
	fallback_turf = find_spawn_turf()
	if(!fallback_turf)
		addtimer(CALLBACK(src, PROC_REF(try_start)), HORSEMAN_RETRY_DELAY)
		return
	INVOKE_ASYNC(src, PROC_REF(offer_to_ghosts))

/datum/game_decorator/halloween/horseman/proc/force_start(turf/forced_turf)
	if(polling)
		return FALSE
	fallback_turf = forced_turf || find_spawn_turf()
	if(!fallback_turf)
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(offer_to_ghosts), forced_turf)
	return TRUE

/datum/game_decorator/halloween/horseman/proc/offer_to_ghosts(turf/forced_turf)
	polling = TRUE
	var/list/candidates = get_alien_candidates(GLOB.hive_datum[XENO_HIVE_HORSEMAN], sorted = FALSE)
	while(length(candidates))
		var/mob/dead/observer/candidate = pick(candidates)
		candidates -= candidate
		if(QDELETED(candidate) || !candidate.client)
			continue
		var/choice = tgui_alert(candidate, "Do you want to play as the Headless Horseless Horseman?", "Halloween", list("Yes", "No"), HORSEMAN_POLL_TIMEOUT)
		if(choice != "Yes" || QDELETED(candidate) || !candidate.client || !isobserver(candidate))
			continue
		polling = FALSE
		if(SSticker.current_state == GAME_STATE_PLAYING)
			spawn_horseman(candidate, forced_turf)
		return
	polling = FALSE

/datum/game_decorator/halloween/horseman/proc/spawn_horseman(mob/dead/observer/candidate, turf/forced_turf)
	spawned = TRUE
	var/turf/spawn_turf = forced_turf || find_spawn_turf() || fallback_turf
	burst_walls(spawn_turf)

	var/mob/living/carbon/xenomorph/horseman/horseman = new(spawn_turf, null, XENO_HIVE_HORSEMAN)
	if(candidate.mind)
		candidate.mind.transfer_to(horseman, TRUE)
	else
		horseman.key = candidate.key
	qdel(candidate)

	to_chat(horseman, SPAN_XENOANNOUNCE("HAUNT THE UNEXPECTING POOR SOULS OF THIS LAND.."))
	to_chat(horseman, SPAN_XENOANNOUNCE("Please be aware that you are an event character, and are expected to atleast be a bit more upholding of the games life. Please do not try to focus one side, or side with any side. You are a third party meant to make the round fun for both sides equally, You can be an equalizer but do not break the balance of the round too much, obviously you are free to kill everyone, just dont rush the hive and claim you killed the xenos. You shouldn't be running around minmaxxing either, just have fun kill people and make it fun for people."))

/datum/game_decorator/halloween/horseman/proc/find_spawn_turf()
	var/list/turf/marine_turfs = list()
	for(var/mob/living/carbon/human/marine as anything in GLOB.alive_human_list)
		if(marine.stat == DEAD || !marine.client || !ishuman_strict(marine) || marine.faction != FACTION_MARINE)
			continue
		var/turf/marine_turf = get_turf(marine)
		if(marine_turf && is_ground_level(marine_turf.z))
			marine_turfs += marine_turf

	while(length(marine_turfs))
		var/turf/marine_turf = pick(marine_turfs)
		marine_turfs -= marine_turf
		var/list/turf/options = list()
		for(var/turf/open/option in RANGE_TURFS(HORSEMAN_SPAWN_RANGE_MAX, marine_turf))
			if(istype(option, /turf/open/space) || istype(option, /turf/open/void))
				continue
			if(get_dist(option, marine_turf) < HORSEMAN_SPAWN_RANGE_MIN || is_blocked_turf(option))
				continue
			options += option
		if(length(options))
			return pick(options)

/datum/game_decorator/halloween/horseman/proc/burst_walls(turf/center)
	for(var/turf/closed/wall/wall in RANGE_TURFS(HORSEMAN_WALL_BURST_RADIUS, center))
		wall.dismantle_wall(TRUE)

/client/proc/force_horseman_event()
	set name = "Force Headless Horseless Horseman"
	set category = "Admin.Events"

	if(!check_rights(R_EVENT))
		return
	var/datum/game_decorator/halloween/horseman/event = GLOB.horseman_event
	if(!event)
		to_chat(src, SPAN_WARNING("wait for initialize."))
		return
	if(event.polling)
		to_chat(src, SPAN_WARNING("theres already a vote"))
		return
	var/choice = tgui_alert(src, "Where to spawn?", "Headless Horseless Horseman", list("My location", "Near a marine", "Cancel"))
	if(!choice || choice == "Cancel")
		return
	var/turf/forced_turf
	if(choice == "My location")
		forced_turf = get_turf(mob)
		if(!forced_turf)
			to_chat(src, SPAN_WARNING("You need to be in the game world to use your location."))
			return
	if(event.polling)
		to_chat(src, SPAN_WARNING("theres already a vote going on"))
		return
	if(!event.force_start(forced_turf))
		to_chat(src, SPAN_WARNING("marines need to exist grounddside."))
		return
	message_admins("[key_name_admin(src)] forced the Horseman event.")
	log_admin("[key_name(src)] forced Horseman event.")

#undef HORSEMAN_EARLIEST_SPAWN
#undef HORSEMAN_DELAY_MIN
#undef HORSEMAN_DELAY_MAX
#undef HORSEMAN_POLL_TIMEOUT
#undef HORSEMAN_RETRY_DELAY
#undef HORSEMAN_SPAWN_RANGE_MIN
#undef HORSEMAN_SPAWN_RANGE_MAX
#undef HORSEMAN_WALL_BURST_RADIUS
