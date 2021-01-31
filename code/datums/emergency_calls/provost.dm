//Provost Inspection Team
/datum/emergency_call/provost_inspection
	name = "USCM Provost Inspection"
	mob_max = 5
	mob_min = 5
	objectives = "Inspect the USS Almayer and ensure Marine Law is being upheld by the Military Police team."
	probability = 0


/datum/emergency_call/provost_inspection/create_member(datum/mind/M)
	var/turf/T = get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Provost Inspector (PvI)", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are the leader of a Provost Inspection Team!</font>")
		to_chat(H, "<B> Follow any orders directly from High Command!</b>")
		to_chat(H, "<B> You only answer to Marine Law and High Command!</b>")
	else
		arm_equipment(H, "Provost Officer (PvO)", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are a member of a Provost Inspection Team!</font>")
		to_chat(H, "<B> Follow any orders directly from High Command or your Inspector!</b>")
		to_chat(H, "<B> You only answer to your superior, Marine Law and High Command!</b>")

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, "<B>Objectives:</b> [objectives]"), 1 SECONDS)


/datum/emergency_call/provost_inspection/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(1)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

//*******************************************************************************************************
//Provost Enforcer Team
/datum/emergency_call/provost_enforcer
	name = "USCM Provost Enforcers"
	mob_max = 5
	mob_min = 5
	objectives = "Deploy to the USS Almayer and enforce Marine Law."
	probability = 0


/datum/emergency_call/provost_enforcer/create_member(datum/mind/M)
	var/turf/T = get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Provost Team Leader (PvTML)", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are the leader of a Provost Enforcer Team!</font>")
		to_chat(H, "<B> Follow any orders directly from High Command!</b>")
		to_chat(H, "<B> You only answer to Marine Law and the Provost Marshall!</b>")
	else
		arm_equipment(H, "Provost Enforcer (PvE)", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are a member of a Provost Enforcer Team!</font>")
		to_chat(H, "<B> Follow any orders directly from High Command or your Team Leader!</b>")
		to_chat(H, "<B> You only answer to your superior, Marine Law and High Command!</b>")

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, "<B>Objectives:</b> [objectives]"), 1 SECONDS)


/datum/emergency_call/provost_enforcer/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(1)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)
