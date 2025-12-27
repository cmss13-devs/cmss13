//#########################################################################
//#########################################################################
//#########################################################################
#define STAGE_GROWING 1
#define STAGE_HALFWAY 2
#define STAGE_VOTE 3
#define STAGE_PICK 4
#define STAGE_BEFORE_HATCH 5
#define STAGE_HATCH 6

/obj/effect/alien/resin/matriarch_cocoon
	name = PATHOGEN_STRUCTURE_COCOON_BIG
	desc = "A huge pulsating cocoon."
	icon = 'icons/mob/pathogen/MatriarchHatchery.dmi'
	icon_state = "static"
	health = 4000
	pixel_x = -48
	pixel_y = -64
	density = TRUE
	plane = FLOOR_PLANE

	/// The mob picked as a candidate to be the Matriarch
	var/client/chosen_candidate
	/// The hive associated with this cocoon
	hivenumber = XENO_HIVE_PATHOGEN
	/// Whether the cocoon has hatched
	var/hatched = FALSE
	/// Is currently rolling candidates
	var/rolling_candidates = FALSE
	/// Voting for Matriarch
	var/list/mob/living/carbon/xenomorph/votes = list()
	/// Candidates
	var/list/mob/living/carbon/xenomorph/candidates = list()
	/// Time to hatch
	var/time_to_hatch = 15 MINUTES
	var/remaining_time_to_hatch = 15 MINUTES
	var/resurrection_delay = 20 MINUTES
	/// Stage of hatching
	var/stage = 0

/obj/effect/alien/resin/matriarch_cocoon/Destroy()
	if(!hatched)
		marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP IN [uppertext(get_area_name(loc))] HAS BEEN STOPPED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
		elder_overseer_message("The Pathogen Matriarch's cocoon was destroyed.")
		var/datum/hive_status/hive
		for(var/cur_hive_num in GLOB.hive_datum)
			hive = GLOB.hive_datum[cur_hive_num]
			if(!length(hive.totalXenos))
				continue
			if(cur_hive_num == hivenumber)
				xeno_announcement(SPAN_XENOANNOUNCE("THE MATRIARCH'S COCOON WAS DESTROYED! VENGEANCE!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
				hive.has_hatchery = FALSE
			else
				xeno_announcement(SPAN_XENOANNOUNCE("THE STRANGE COCOON WAS DESTROYED!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

	votes = null
	chosen_candidate = null
	candidates = null
	QDEL_LIST(blockers)

	. = ..()

/obj/effect/alien/resin/matriarch_cocoon/Initialize(mapload)
	. = ..()

	var/datum/hive_status/hatchery_hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	hatchery_hive.has_hatchery = TRUE

	for(var/x_offset in -1 to 1)
		for(var/y_offset in -1 to 1)
			var/turf/turf_to_block = locate(x + x_offset, y + y_offset, z)
			var/obj/effect/build_blocker/blocker = new(turf_to_block, src)
			blockers += blocker

	START_PROCESSING(SSobj, src)

	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - [time_to_hatch / 600] MINUTES.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	elder_overseer_message("A Pathogen Matriarch is now growing at [get_area_name(loc)].")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch is growing at [get_area_name(loc)]. Protect it, at all costs!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual is growing at [get_area_name(loc)]."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/obj/effect/alien/resin/matriarch_cocoon/process(delta_time)
	if(hatched)
		STOP_PROCESSING(SSobj, src)
		return

	var/groundside_humans = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue

		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans += 1

			if(groundside_humans > 12)
				break

	if(groundside_humans < 12)
		// Too few marines are now groundside, hatch immediately
		start_vote()
		addtimer(CALLBACK(src, PROC_REF(roll_candidates)), 20 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(start_hatching), TRUE), 25 SECONDS)
		STOP_PROCESSING(SSobj, src)
		return

	remaining_time_to_hatch -= delta_time SECONDS

	if(!stage && remaining_time_to_hatch < time_to_hatch)
		icon_state = "growing"
		stage = STAGE_GROWING
	else if (stage == STAGE_GROWING && remaining_time_to_hatch <= (time_to_hatch / 2))
		announce_halfway()
		stage = STAGE_HALFWAY
	else if (stage == STAGE_HALFWAY && remaining_time_to_hatch <= 1 MINUTES)
		start_vote()
		stage = STAGE_VOTE
	else if (stage == STAGE_VOTE && remaining_time_to_hatch <= 40 SECONDS)
		roll_candidates()
		stage = STAGE_PICK
	else if (stage == STAGE_PICK && remaining_time_to_hatch <= 20 SECONDS)
		start_hatching()
		stage = STAGE_BEFORE_HATCH
	else if (stage == STAGE_BEFORE_HATCH && remaining_time_to_hatch <= 0)
		animate_hatch()
		STOP_PROCESSING(SSobj, src)

/// Causes the halfway announcements and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/announce_halfway()
	var/halftime = ((time_to_hatch / 600) / 2)
	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - [halftime] MINUTES. RECOMMEND TERMINATION OF MYCELIAL STRUCTURE AT THIS LOCATION.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	elder_overseer_message("A Pathogen Matriarch will hatch in [halftime] minutes.")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch will hatch in approximately [halftime] minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual is growing... it will hatch in approximately [halftime] minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

#define PATH_MAT_PLAYTIME_HOURS (50 HOURS)

/**
 * Returns TRUE is the candidate passed is valid: Returns TRUE is the candidate passed is valid: Has client, not facehugger, not lesser drone, not banished, and conditionally on playtime.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to check
 * * playtime_restricted: Determines whether being below PATH_MAT_PLAYTIME_HOURS makes the candidate invalid
 * * skip_playtime: Determines whether being above PATH_MAT_PLAYTIME_HOURS makes the candidate invalid (does nothing unless playtime_restricted is FALSE)
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/is_candidate_valid(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE, skip_playtime = TRUE)
	if(!candidate?.client)
		return FALSE
	if(isfacehugger(candidate) || islesserdrone(candidate) || ispopper(candidate))
		return FALSE
	if(playtime_restricted)
		if(candidate.client.get_total_xeno_playtime() < PATH_MAT_PLAYTIME_HOURS)
			return FALSE
	else if(candidate.client.get_total_xeno_playtime() >= PATH_MAT_PLAYTIME_HOURS && skip_playtime)
		return FALSE // We do this under the assumption we tried it the other way already so don't ask twice
	for(var/mob_name in hive.banished_ckeys)
		if(hive.banished_ckeys[mob_name] == candidate.ckey)
			return FALSE
	return TRUE

/**
 * Returns TRUE if a valid candidate accepts a TGUI alert asking them to be Matriarch.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to ask
 * * playtime_restricted: Determines whether being below PATH_MAT_PLAYTIME_HOURS makes the candidate invalid (otherwise above)
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/try_roll_candidate(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE)
	if(!is_candidate_valid(hive, candidate, playtime_restricted))
		return FALSE

	if(!candidate.client)
		return FALSE

	return candidate.client.prefs.be_special & BE_KING

#undef PATH_MAT_PLAYTIME_HOURS

/**
 * Tallies up votes by asking the passed candidate who they wish to vote for Matriarch.
 *
 * Arguments:
 * * candidate: The mob that was want to ask
 * * voting_candidates: A list of xenomorph mobs that are candidates
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/cast_vote(mob/candidate, list/mob/living/carbon/xenomorph/voting_candidates)
	var/mob/living/carbon/xenomorph/choice = tgui_input_list(candidate, "Vote for a sister you wish to become the Matriarch.", "Choose a creature", voting_candidates , 20 SECONDS)

	if(votes[choice])
		votes[choice] += 1
	else
		votes[choice] = 1

/// Initiates a vote that will end in 20 seconds to vote for the Matriarch. Hatching will then begin in 1 minute unless expedited.
/obj/effect/alien/resin/matriarch_cocoon/proc/start_vote()
	rolling_candidates = TRUE
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	var/list/mob/living/carbon/xenomorph/voting_candidates = hive.totalXenos.Copy() - hive.living_xeno_queen

	for(var/mob/living/carbon/xenomorph/voting_candidate in voting_candidates)
		if(!is_candidate_valid(hive, voting_candidate))
			voting_candidates -= voting_candidate

	for(var/mob/living/carbon/xenomorph/candidate in hive.totalXenos)
		if(is_candidate_valid(hive, candidate, playtime_restricted = FALSE, skip_playtime = FALSE))
			INVOKE_ASYNC(src, PROC_REF(cast_vote), candidate, voting_candidates)

	candidates = voting_candidates


/**
 * Finalizes the vote for Matriarch opting to use a series of fallbacks in case a candidate declines.
 *
 * First is a vote where the first and or second top picked is asked.
 * Then all other living xenos meeting the playtime requirement are asked.
 * Then all xeno observer candidates meeting the playtime requirement are asked.
 * Then all other living xenos not meeting the playtime requirement are asked.
 * Then all other xeno observer candidates not meeting the playtime requirement are asked.
 * Then finally if after all that, the search is given up and will ultimately result in a freed Matriarch mob.
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/roll_candidates()
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	var/primary_votes = 0
	var/mob/living/carbon/xenomorph/primary_candidate
	var/secondary_votes = 0
	var/mob/living/carbon/xenomorph/secondary_candidate

	for(var/mob/living/carbon/xenomorph/candidate in votes)
		if(votes[candidate] > primary_votes)
			primary_votes = votes[candidate]
			primary_candidate = candidate
		else if(votes[candidate] > secondary_votes)
			secondary_votes = votes[candidate]
			secondary_candidate = candidate

	votes.Cut()

	if(prob(50) && try_roll_candidate(hive, primary_candidate, playtime_restricted = TRUE))
		chosen_candidate = primary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= primary_candidate


	if(try_roll_candidate(hive, secondary_candidate, playtime_restricted = TRUE))
		chosen_candidate = secondary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= secondary_candidate

	// Otherwise ask all the living xenos (minus the player(s) who got voted on earlier)
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(candidates))
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Then observers
	var/list/observer_list_copy = shuffle(get_alien_candidates(hive))

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Lastly all of the above again, without playtime requirements
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(hive.totalXenos.Copy() - hive.living_xeno_queen))
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return
	message_admins("Failed to find a client for the Matriarch, releasing as freed mob.")


/// Starts the hatching in twenty seconds, otherwise immediately if expedited
/obj/effect/alien/resin/matriarch_cocoon/proc/start_hatching(expedite = FALSE)
	votes = null
	candidates = null
	if(expedite)
		animate_hatch()
		return

	elder_overseer_message("A Pathogen Matriarch will hatch in twenty seconds.")
	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [get_area_name(loc)].\n\nESTIMATED TIME UNTIL COMPLETION - 20 SECONDS. RECOMMEND TERMINATION OF MYCELIAL STRUCTURE AT THIS LOCATION.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/// Causes the cocoon to change visually for hatching and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/animate_hatch()
	flick("hatching", src)
	addtimer(CALLBACK(src, PROC_REF(hatch)), 2 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

	elder_overseer_message("A Pathogen Matriarch has hatched; I advise extreme caution.")
	marine_announcement("ALERT.\n\nEXTREME ENERGY INFLUX DETECTED IN [get_area_name(loc)].\n\nCAUTION IS ADVISED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("All hail the Matriarch."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("The unusual entity has hatched!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)


/// Actually hatches the Matriarch transferring the candidate into the spawned mob and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/hatch()
	icon_state = "hatched"
	hatched = TRUE

	QDEL_LIST(blockers)

	var/mob/living/carbon/xenomorph/matriarch/matriarch = new(get_turf(src), null, hivenumber)
	if(chosen_candidate?.mob)
		var/mob/old_mob = chosen_candidate.mob
		old_mob.mind.transfer_to(matriarch)

		if(isliving(old_mob) && old_mob.stat != DEAD)
			old_mob.free_for_ghosts(TRUE)
	else
		matriarch.free_for_ghosts(TRUE)
	playsound(src, 'sound/pathogen_creatures/pathogen_matriarch_birth.ogg', 75, 0)

	chosen_candidate = null

/obj/effect/alien/resin/matriarch_cocoon/proc/resurrect()
	time_to_hatch = resurrection_delay
	remaining_time_to_hatch = resurrection_delay
	stage = 0
	hatched = FALSE

	for(var/x_offset in -1 to 1)
		for(var/y_offset in -1 to 1)
			var/turf/turf_to_block = locate(x + x_offset, y + y_offset, z)
			var/obj/effect/build_blocker/blocker = new(turf_to_block, src)
			blockers += blocker

	START_PROCESSING(SSobj, src)

	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - [time_to_hatch / 600] MINUTES.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	elder_overseer_message("A Pathogen Matriarch is now re-growing at [get_area_name(loc)].")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch is being revived at [get_area_name(loc)]. Protect the cocoon at all costs!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("The Pathogen Matriarch is being revived at [get_area_name(loc)]!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)


/obj/effect/alien/resin/matriarch_cocoon/attackby(obj/item/O as obj, mob/user as mob)
	if(is_pathogen_creature(user) && istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(ismatriarch(G.grabbed_thing))
			var/mob/living/carbon/xenomorph/matriarch/corpse = G.grabbed_thing
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && (corpse.stat == DEAD))
				qdel(corpse)
				resurrect()
			else
				. = ..()
	else
		. = ..()



#undef STAGE_GROWING
#undef STAGE_HALFWAY
#undef STAGE_VOTE
#undef STAGE_PICK
#undef STAGE_BEFORE_HATCH
#undef STAGE_HATCH
