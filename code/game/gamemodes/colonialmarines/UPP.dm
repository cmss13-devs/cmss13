GLOBAL_LIST_EMPTY(upp_leaders)
GLOBAL_LIST_EMPTY(upp_officers)

/// What percent do we consider a 'majority?' to win
#define MAJORITY 0.5
/// UPP Chain of command
#define UPP_COMMAND_ROLES list(JOB_UPP_CO_OFFICER, JOB_UPP_KPT_OFFICER, JOB_UPP_SRLT_OFFICER, JOB_UPP_LT_OFFICER, JOB_UPP_PILOT, JOB_UPP_LT_DOKTOR, JOB_UPP_COMMISSAR)

/datum/game_mode/colonialmarines/upp
	name = "UPP Distress Signal"
	config_tag = "UPP Distress Signal"
	human_major = MODE_FACTION_CLASH_UPP_MAJOR
	human_minor = MODE_FACTION_CLASH_UPP_MINOR
	//vote_cycle = 3 // Uncomment after testing is done.

/datum/game_mode/colonialmarines/upp/get_roles_list()
	return UPP_JOB_LIST + GLOB.ROLES_GROUND

///Spawns a droppod with a temporary defense sentry at the given turf
/datum/game_mode/colonialmarines/upp/spawn_lz_sentry(turf/target, list/structures_to_break)
	var/obj/structure/droppod/equipment/sentry_holder/droppod = new(target, /obj/structure/machinery/sentry_holder/landing_zone/upp)
	droppod.special_structures_to_damage = structures_to_break
	droppod.special_structure_damage = 500
	droppod.drop_time = 0
	droppod.launch(target)

/datum/game_mode/colonialmarines/upp/ares_command_check(mob/living/carbon/human/commander = null, force = FALSE)
	/// Job of the person being auto-promoted.
	var/role_in_charge
	/// human being auto-promoted.
	var/mob/living/carbon/human/person_in_charge
	/// Extra info to add to the ARES announcement announcing the promotion.
	var/announce_addendum

	//Basically this follows the list of command staff in order of CoC,
	//then if the role lacks senior command access it gives the person that access

	if(SSticker.mode.acting_commander && !force) // If there's already an aCO; don't set a new one, unless forced.
		return

	if((GLOB.upp_leaders[JOB_UPP_CO_OFFICER] || GLOB.upp_leaders[JOB_UPP_KPT_OFFICER]) && !force)
		return
	//If we have a CO or XO, we're good no need to announce anything.

	for(var/job_by_chain in UPP_COMMAND_ROLES)
		role_in_charge = job_by_chain

		if(job_by_chain == JOB_UPP_SRLT_OFFICER && GLOB.upp_leaders[JOB_UPP_SRLT_OFFICER])
			person_in_charge = pick(GLOB.upp_leaders[JOB_UPP_SRLT_OFFICER])
			break
		if(job_by_chain == JOB_UPP_LT_OFFICER && GLOB.upp_leaders[JOB_UPP_LT_OFFICER])
			person_in_charge = pick(GLOB.upp_leaders[JOB_UPP_LT_OFFICER])
			break
		if(job_by_chain == JOB_UPP_LT_DOKTOR && GLOB.upp_officers[JOB_UPP_LT_DOKTOR])
			person_in_charge = pick(GLOB.upp_officers[JOB_UPP_LT_DOKTOR])
			break
		if(job_by_chain == JOB_UPP_PILOT && GLOB.upp_officers[JOB_UPP_PILOT])
			person_in_charge = pick(GLOB.upp_officers[JOB_UPP_COMMISSAR])
			break
		if(job_by_chain == JOB_UPP_COMMISSAR && GLOB.upp_officers[JOB_UPP_COMMISSAR])
			person_in_charge = pick(GLOB.upp_officers[JOB_UPP_COMMISSAR])
			break

		//If the job is a list we have to stop here
		if(person_in_charge)
			break

//		var/datum/job/job_datum = GLOB.RoleAuthority.roles_for_mode[job_by_chain]	//How might I make a UPP version of this?
//		person_in_charge = job_datum?.get_active_player_on_job()
//		if(!isnull(person_in_charge))
//			break

	if(commander) // pre-provided commander overrides the automatic selection.
		person_in_charge = commander
		role_in_charge = person_in_charge.job

	if(!person_in_charge)
		return log_admin("No valid commander found for automatic promotion.")

	SSticker.mode.acting_commander = person_in_charge // Prevents double-dipping.

	var/obj/item/card/id/card = person_in_charge.get_idcard()
	if(card)
		var/static/to_add = list(ACCESS_UPP_SENIOR_LEAD)
		var/new_access = card.access | to_add
		if(card.access ~! new_access)
			card.access = new_access
			announce_addendum += "\nSenior Command access added to ID."

	announce_addendum += "\nA Command headset is available in the Command Tablet cabinet."

	//does an announcement to the crew about the commander & alerts admins to that change for logs.
	shipwide_ai_announcement("Acting Commander authority has been transferred to: [role_in_charge] [person_in_charge], who will assume command until further notice. Please direct all inquiries and follow instructions accordingly. [announce_addendum]", MAIN_AI_SYSTEM, 'sound/misc/interference.ogg')
	message_admins("[key_name(person_in_charge, TRUE)] [ADMIN_JMP_USER(person_in_charge)] has been designated the operation commander.")
	return

/datum/game_mode/colonialmarines/upp/ds_first_drop(obj/docking_port/mobile/marine_dropship)
	if(!active_lz)
		var/dest_id = marine_dropship.destination?.id
		if(dest_id == DROPSHIP_LZ1)
			select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
		else if (dest_id == DROPSHIP_LZ2)
			select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb_uscm), ZTRAIT_GROUND,"4th Fleet","SSV Rostock"), DROPSHIP_DROP_MSG_DELAY) //I wish I knew how to change MAIN_SHIP_NAME, and what battalion to use?
	addtimer(CALLBACK(src, PROC_REF(warn_resin_clear), marine_dropship), DROPSHIP_DROP_FIRE_DELAY)
	DB_ENTITY(/datum/entity/survivor_survival) // Record surv survival right now
	addtimer(CALLBACK(SSentity_manager, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, select), /datum/entity/survivor_survival), 7 MINUTES) // And 7 minutes after drop. By then, marines will have found them, most likely

	add_current_round_status_to_end_results("First Drop")
	clear_lz_hazards()

/**
 * Announces the end of the game with all relevant information stated
 */
/datum/game_mode/colonialmarines/upp/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
		//	if(GLOB.round_statistics && GLOB.round_statistics.current_map)
		//		GLOB.round_statistics.current_map.total_xeno_victories++
		//		GLOB.round_statistics.current_map.total_xeno_majors++
		if(MODE_FACTION_CLASH_UPP_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg','sound/theme/winning_triumph3.ogg')
			end_icon = "upp_major"
		//	if(GLOB.round_statistics && GLOB.round_statistics.current_map)
		//		GLOB.round_statistics.current_map.total_marine_victories++
		//		GLOB.round_statistics.current_map.total_marine_majors++
		if(MODE_INFESTATION_X_MINOR)
			var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
			end_icon = "xeno_minor"
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				var/headcount = count_per_faction()
				var/living = headcount["total_headcount"]
				if ((headcount["WY_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_wy.ogg')
					end_icon = "wy_major"
					log_game("3rd party victory: Weyland-Yutani")
					message_admins("3rd party victory: Weyland-Yutani")
				else if ((headcount["UPP_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_upp.ogg')
					end_icon = "upp_major"
					log_game("3rd party victory: Union of Progressive Peoples")
					message_admins("3rd party victory: Union of Progressive Peoples")
				else if ((headcount["CLF_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_clf.ogg')
					end_icon = "upp_major"
					log_game("3rd party victory: Colonial Liberation Front")
					message_admins("3rd party victory: Colonial Liberation Front")
				else if ((headcount["marine_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/neutral_melancholy2.ogg') //This is the theme song for Colonial Marines the game, fitting
			else
				musical_track = pick('sound/theme/neutral_melancholy1.ogg')
		//	if(GLOB.round_statistics && GLOB.round_statistics.current_map)
		//		GLOB.round_statistics.current_map.total_xeno_victories++
		if(MODE_FACTION_CLASH_UPP_MAJOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "upp_minor"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_marine_victories++
		if(MODE_INFESTATION_DRAW_DEATH)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_draws++
		else
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
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

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_fun_facts()


	add_current_round_status_to_end_results("Round End")
	handle_round_results_statistics_output()

	GLOB.round_statistics?.save()

	return 1

// for the toolbox
/datum/game_mode/colonialmarines/upp/end_round_message()
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			return "Round has ended. Xeno Major Victory."
		if(MODE_FACTION_CLASH_UPP_MAJOR)
			return "Round has ended. UPP Major Victory."
		if(MODE_INFESTATION_X_MINOR)
			return "Round has ended. Xeno Minor Victory."
		if(MODE_FACTION_CLASH_UPP_MINOR)
			return "Round has ended. UPP Minor Victory."
		if(MODE_INFESTATION_DRAW_DEATH)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."

#undef MAJORITY
#undef UPP_COMMAND_ROLES
