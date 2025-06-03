//*******************************************************************************************************
//Provost Enforcer Team
/datum/emergency_call/provost_enforcer
	name = "USCM Provost Enforcers"
	mob_max = 5
	mob_min = 5
	probability = 0

/datum/emergency_call/provost_enforcer/New()
	objectives = "Отправляйтесь на корабль [MAIN_SHIP_NAME] и обеспечьте исполнение закона."
	return ..()

/datum/emergency_call/provost_enforcer/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))    //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/tml, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the leader of a Provost Enforcer Team!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command!"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to Marine Law and the Provost Marshal!"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a member of a Provost Enforcer Team!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command or your Team Leader!"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to your superior, Marine Law and High Command!"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/provost_enforcer/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)
