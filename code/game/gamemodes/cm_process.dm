

/*
Like with cm_initialize.dm, these procs exist to quickly populate classic CM game modes.
Specifically for processing, announcing completion, and so on. Simply plug in these procs
in to the appropriate slots, like the in the example game modes, and you're good to go.
This is meant for infestation type game modes for right now (marines vs. aliens, with a chance
of predators), but can be added to include variant game modes (like humans vs. humans).
*/

//If the queen is dead after a period of time, this will end the game.
/datum/game_mode/proc/check_queen_status()
	return

//===================================================\\

				//ANNOUNCE COMPLETION\\

//===================================================\\

/datum/game_mode/proc/declare_completion_announce_fallen_soldiers()
	set waitfor = 0
	sleep(2 SECONDS)
	GLOB.fallen_list += GLOB.fallen_list_cross
	if(length(GLOB.fallen_list))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("In Flanders fields...<br>")
		dat += SPAN_CENTERBOLD("In memoriam of our fallen soldiers: <br>")
		for(var/i = 1 to length(GLOB.fallen_list))
			if(i != length(GLOB.fallen_list))
				dat += "[GLOB.fallen_list[i]], "
			else
				dat += "[GLOB.fallen_list[i]].<br>"
		to_world("[dat]")


/datum/game_mode/proc/declare_completion_announce_xenomorphs()
	set waitfor = 0
	sleep(2 SECONDS)
	if(LAZYLEN(xenomorphs) || LAZYLEN(dead_queens))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("<br>The xenomorph Queen(s) were:")
		var/mob/living/carbon/xenomorph/xeno_mob
		for (var/msg in dead_queens)
			dat += msg
		for(var/datum/mind/xeno_mind in xenomorphs)
			if(!istype(xeno_mind))
				continue

			xeno_mob = xeno_mind.current
			if(!xeno_mob || !xeno_mob.loc)
				xeno_mob = xeno_mind.original
			if(xeno_mob && xeno_mob.loc && isqueen(xeno_mob) && xeno_mob.stat != DEAD) // Dead queens handled separately
				dat += "<br>[xeno_mob.full_designation] was [xeno_mob] [SPAN_BOLDNOTICE("(SURVIVED)")]"

		to_world("[dat]")

/datum/game_mode/proc/declare_completion_announce_predators()
	set waitfor = 0
	sleep(2 SECONDS)
	if(length(predators))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("<br>The Predators were:")
		for(var/entry in predators)
			dat += "<br>[entry] was [predators[entry]["Name"]] [SPAN_BOLDNOTICE("([predators[entry]["Status"]])")]"
		to_world("[dat]")


/datum/game_mode/proc/declare_completion_announce_medal_awards()
	set waitfor = 0
	sleep(2 SECONDS)
	if(length(GLOB.medal_awards))
		var/dat = "<br>"
		dat +=  SPAN_ROUNDBODY("<br>Medal Awards:")
		for(var/recipient in GLOB.medal_awards)
			var/datum/recipient_awards/recipient_award = GLOB.medal_awards[recipient]
			for(var/i in 1 to length(recipient_award.medal_names))
				dat += "<br><b>[recipient_award.recipient_rank] [recipient]</b> is awarded [recipient_award.posthumous[i] ? "posthumously " : ""]the <span class='boldnotice'>[recipient_award.medal_names[i]]</span>: \'<i>[recipient_award.medal_citations[i]]</i>\'."
		to_world(dat)
	if(length(GLOB.jelly_awards))
		var/dat = "<br>"
		dat +=  SPAN_ROUNDBODY("<br>Royal Jelly Awards:")
		for(var/recipient in GLOB.jelly_awards)
			var/datum/recipient_awards/recipient_award = GLOB.jelly_awards[recipient]
			for(var/i in 1 to length(recipient_award.medal_names))
				dat += "<br><b>[recipient]</b> is awarded [recipient_award.posthumous[i] ? "posthumously " : ""]a <span class='boldnotice'>[recipient_award.medal_names[i]]</span>: \'<i>[recipient_award.medal_citations[i]]</i>\'[recipient_award.giver_rank[i] ? " by [recipient_award.giver_rank[i]]" : ""][recipient_award.giver_name[i] ? " ([recipient_award.giver_name[i]])" : ""]."
		to_world(dat)

/datum/game_mode/proc/declare_fun_facts()
	set waitfor = 0
	sleep(2 SECONDS)
	to_chat_spaced(world, margin_bottom = 0, html = SPAN_ROLE_BODY("|______________________|"))
	to_world(SPAN_ROLE_HEADER("FUN FACTS"))
	var/list/fact_types = subtypesof(/datum/random_fact)
	for(var/fact_type as anything in fact_types)
		var/datum/random_fact/fact_human = new fact_type(set_check_human = TRUE, set_check_xeno = FALSE)
		fact_human.announce()
	for(var/fact_type as anything in fact_types)
		var/datum/random_fact/fact_xeno = new fact_type(set_check_human = FALSE, set_check_xeno = TRUE)
		fact_xeno.announce()
	to_chat_spaced(world, margin_top = 0, html = SPAN_ROLE_BODY("|______________________|"))

//===================================================\\

					//HELPER PROCS\\

//===================================================\\

//Spawns a larva in an appropriate location
/datum/game_mode/proc/spawn_latejoin_larva()
	var/mob/living/carbon/xenomorph/larva/new_xeno = new /mob/living/carbon/xenomorph/larva(get_turf(pick(GLOB.xeno_spawns)))
	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of the ground!"),
	SPAN_XENODANGER("You burrow out of the ground and awaken from your slumber. For the Hive!"))
	new_xeno << sound('sound/effects/xeno_newlarva.ogg')

// Open podlocks with the given ID if they aren't already opened.
// DO NOT USE THIS WITH ID's CORRESPONDING TO SHUTTLES OR THEY WILL BREAK!
/datum/game_mode/proc/open_podlocks(podlock_id)
	for(var/obj/structure/machinery/door/poddoor/M in GLOB.machines)
		if(M.id == podlock_id && M.density)
			M.open()

// Variables for the below function that we need to keep throught the round
GLOBAL_VAR_INIT(peak_humans, 1)
GLOBAL_VAR_INIT(peak_xenos, 1)

// 30 minutes in (we will add to that!)
GLOBAL_VAR_INIT(last_xeno_bioscan, 30 MINUTES)
// 30 minutes in (we will add to that!)
GLOBAL_VAR_INIT(last_human_bioscan, 30 MINUTES)
// 5 minutes in
GLOBAL_VAR_INIT(next_predator_bioscan, 5 MINUTES)
// 30 minutes in
GLOBAL_VAR_INIT(next_admin_bioscan, 30 MINUTES)

/datum/game_mode/proc/select_lz(obj/structure/machinery/computer/shuttle/dropship/flight/lz1/console)
	if(active_lz)
		return
	active_lz = console
	// The announcement to all Humans.
	var/name = "[MAIN_AI_SYSTEM] Operation Staging Order"
	var/input = "Command Order Issued.\n\n[active_lz.loc.loc] has been designated as the primary landing zone."
	marine_announcement(input, name)

/datum/game_mode/proc/announce_bioscans()
	//Depending on how either side is doing, we speed up the bioscans
	//Formula is - last bioscan time, plus 30 minutes multiplied by ratio of current pop divided by highest pop
	//So if you have peak 30 xenos, if you still have 30 xenos, humans will have to wait 30 minutes between bioscans
	//But if you fall down to 15 xenos, humans will get them every 15 minutes
	//But never more often than 5 minutes apart
	var/nextXenoBioscan = GLOB.last_xeno_bioscan + max(30 MINUTES * length(GLOB.alive_human_list) / GLOB.peak_humans, 5 MINUTES)
	var/nextHumanBioscan = GLOB.last_human_bioscan + max(30 MINUTES * length(GLOB.living_xeno_list) / GLOB.peak_xenos, 5 MINUTES)
	GLOB.bioscan_data.get_scan_data()
	if(world.time > GLOB.next_predator_bioscan)
		GLOB.bioscan_data.yautja_bioscan()//Also does ghosts
		GLOB.next_predator_bioscan += 5 MINUTES//5 minutes, straight

	if(world.time > nextXenoBioscan)
		GLOB.last_xeno_bioscan = world.time
		GLOB.bioscan_data.qm_bioscan()

	if(world.time > nextHumanBioscan)
		GLOB.last_human_bioscan = world.time
		GLOB.bioscan_data.ares_bioscan(FALSE)


/datum/game_mode/proc/count_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_xenos = 0
	for(var/i in GLOB.living_xeno_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space) && !istype(M.loc, /area/adminlevel/ert_station/fax_response_station)) //If they have a z var, they are on a turf.
			num_xenos++
	return num_xenos

/datum/game_mode/proc/count_humans_and_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_humans = 0
	var/num_xenos = 0

	for(var/mob/M in GLOB.player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space) && !istype(M.loc, /area/adminlevel/ert_station/fax_response_station)) //If they have a z var, they are on a turf.
			if(ishuman(M) && !isyautja(M) && !(M.status_flags & XENO_HOST) && !iszombie(M))
				var/mob/living/carbon/human/H = M
				if(((H.species && H.species.name == "Human") || (H.is_important)) && !H.hivenumber) //only real humans count, or those we have set to also be included
					num_humans++
			else
				var/area/A = get_area(M)
				if(isxeno(M))
					var/mob/living/carbon/xenomorph/xeno = M
					if(!xeno.counts_for_roundend)
						continue
					var/datum/hive_status/xeno_hive = GLOB.hive_datum[xeno.hivenumber]
					if(!xeno_hive || (xeno_hive.need_round_end_check && !xeno_hive.can_delay_round_end(xeno)))
						continue
					if (A.flags_area & AREA_AVOID_BIOSCAN)
						continue
					num_xenos++
				else if(iszombie(M))
					if (A.flags_area & AREA_AVOID_BIOSCAN)
						continue
					num_xenos++

	return list(num_humans,num_xenos)

/datum/game_mode/proc/count_marines_and_pmcs(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_marines = 0
	var/num_pmcs = 0

	for(var/i in GLOB.alive_human_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space) && !istype(M.loc, /area/adminlevel/ert_station/fax_response_station))
			if(M.faction in FACTION_LIST_WY)
				num_pmcs++
			else if(M.faction == FACTION_MARINE)
				num_marines++

	return list(num_marines,num_pmcs)

/datum/game_mode/proc/count_marines(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_marines = 0

	for(var/i in GLOB.alive_human_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space) && !istype(M.loc, /area/adminlevel/ert_station/fax_response_station))
			if(M.faction == FACTION_MARINE)
				num_marines++

	return num_marines

/datum/game_mode/proc/count_per_faction(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_marines = 0
	var/num_WY = 0
	var/num_UPP = 0
	var/num_CLF = 0
	var/num_headcount = 0

	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(current_human.z && (current_human.z in z_levels) && !istype(current_human.loc, /turf/open/space) && !istype(current_human.loc, /area/adminlevel/ert_station/fax_response_station)))
			continue
		if(current_human.faction in FACTION_LIST_WY)
			num_WY++
			num_headcount++
			continue
		if(current_human.faction == FACTION_UPP)
			num_UPP++
			num_headcount++
			continue
		if(current_human.faction == FACTION_CLF)
			num_CLF++
			num_headcount++
			continue
		if(current_human.faction == FACTION_MARINE)
			num_marines++
			num_headcount++
			continue
		num_headcount++
	return list("marine_headcount" = num_marines,"WY_headcount" = num_WY,"UPP_headcount" = num_UPP,"CLF_headcount" = num_CLF,"total_headcount" = num_headcount)

/*
#undef QUEEN_DEATH_COUNTDOWN
#undef MODE_INFESTATION_X_MAJOR
#undef MODE_INFESTATION_M_MAJOR
#undef MODE_INFESTATION_X_MINOR
#undef MODE_INFESTATION_M_MINOR
#undef MODE_INFESTATION_DRAW_DEATH
#undef MODE_BATTLEFIELD_W_MAJOR
#undef MODE_BATTLEFIELD_M_MAJOR
#undef MODE_BATTLEFIELD_W_MINOR
#undef MODE_BATTLEFIELD_M_MINOR
#undef MODE_BATTLEFIELD_DRAW_STALEMATE
#undef MODE_BATTLEFIELD_DRAW_DEATH
#undef MODE_GENERIC_DRAW_NUKE*/
