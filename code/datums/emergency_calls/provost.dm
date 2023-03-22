//*******************************************************************************************************
//Provost Enforcer Team
/datum/emergency_call/provost_enforcer
	name = "USCM Provost Enforcers"
	mob_max = 5
	mob_min = 5
	objectives = "Deploy to the USS Almayer and enforce Marine Law."
	probability = 0


/datum/emergency_call/provost_enforcer/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/current_turf = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(current_turf))
		return FALSE

	var/mob/living/carbon/human/human = new(current_turf)
	M.transfer_to(human, TRUE)

	if(!leader && HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))    //First one spawned is always the leader.
		leader = human
		arm_equipment(human, /datum/equipment_preset/uscm_event/provost/tml, TRUE, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are the leader of a Provost Enforcer Team!"))
		to_chat(human, SPAN_ROLE_BODY("Follow any orders directly from High Command!"))
		to_chat(human, SPAN_ROLE_BODY("You only answer to Marine Law and the Provost Marshal!"))
	else
		arm_equipment(human, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a member of a Provost Enforcer Team!"))
		to_chat(human, SPAN_ROLE_BODY("Follow any orders directly from High Command or your Team Leader!"))
		to_chat(human, SPAN_ROLE_BODY("You only answer to your superior, Marine Law and High Command!"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/provost_enforcer/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)
