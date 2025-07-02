/obj/effect/landmark
	name = "landmark"
	icon = 'icons/landmarks.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE

	var/invisibility_value = INVISIBILITY_MAXIMUM

/obj/effect/landmark/New()
	tag = "landmark*[name]"
	invisibility = invisibility_value
	return ..()

/obj/effect/landmark/Initialize(mapload, ...)
	. = ..()
	GLOB.landmarks_list += src
	invisibility = invisibility_value

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/newplayer_start
	name = "New player start"
	icon_state = "new_player"

/obj/effect/landmark/newplayer_start/New() // this must be New()
	. = ..()
	GLOB.newplayer_start += src

/obj/effect/landmark/newplayer_start/Destroy()
	GLOB.newplayer_start -= src
	return ..()

/obj/effect/landmark/sim_target
	name = "simulator_target"
	icon_state = "sim_target"

/obj/effect/landmark/sim_target/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_targets += src

/obj/effect/landmark/sim_target/Destroy()
	GLOB.simulator_targets -= src
	return ..()

/obj/effect/landmark/sim_camera
	name = "simulator_camera"
	icon_state = "sim_cam"

/obj/effect/landmark/sim_camera/Initialize(mapload, ...)
	. = ..()
	GLOB.simulator_cameras += src

/obj/effect/landmark/sim_camera/Destroy()
	GLOB.simulator_cameras -= src
	return ..()

/obj/effect/landmark/observer_start
	name = "Observer Landmark"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost1"

/obj/effect/landmark/observer_start/Initialize()
	. = ..()
	GLOB.observer_starts += src
	new /obj/effect/landmark/spycam_start(loc)

/obj/effect/landmark/observer_start/Destroy()
	GLOB.observer_starts -= src
	return ..()

/obj/effect/landmark/ert_spawns/Initialize(mapload, ...)
	. = ..()
	LAZYADD(GLOB.ert_spawns[type], src)

/obj/effect/landmark/ert_spawns/Destroy()
	LAZYREMOVE(GLOB.ert_spawns[type], src)
	return ..()

// Nightmare insert locations
/obj/effect/landmark/nightmare
	name = "Nightmare Insert"
	icon_state = "nightmare_insert"
	var/insert_tag // Identifier for global mapping
	var/replace = FALSE    // Replace another existing landmark mapping of same name
	var/autoremove = TRUE  // Delete mapped turf when landmark is deleted, such as by an insert in replace mode
/obj/effect/landmark/nightmare/Initialize(mapload, ...)
	. = ..()
	if(!insert_tag)
		return
	if(!replace && GLOB.nightmare_landmarks[insert_tag])
		return
	GLOB.nightmare_landmarks[insert_tag] = get_turf(src)
/obj/effect/landmark/nightmare/Destroy()
	if(insert_tag)
		var/turf/turf = get_turf(src)
		if(autoremove && GLOB.nightmare_landmarks[insert_tag] == turf)
			GLOB.nightmare_landmarks.Remove(insert_tag)
		GLOB.nightmare_landmark_tags_removed += insert_tag
	return ..()

/obj/effect/landmark/ert_spawns/distress
	name = "Distress"
	icon_state = "spawn_distress_wo"

/obj/effect/landmark/ert_spawns/distress/item
	name = "DistressItem"
	icon_state = "distress_item"

/obj/effect/landmark/ert_spawns/distress_wo
	name = "distress_wo"
	icon_state = "spawn_distress_wo"

/obj/effect/landmark/ert_spawns/groundside_xeno
	name = "distress_groundside_xeno"
	icon_state = "spawn_distress_xeno"

/obj/effect/landmark/monkey_spawn
	name = "monkey_spawn"
	icon_state = "monkey_spawn"

///hunting grounds

/obj/effect/landmark/ert_spawns/distress/hunt_spawner
	name = "hunt spawner"

/obj/effect/landmark/ert_spawns/distress/hunt_spawner/xeno
	name = "hunt spawner xeno"
	icon_state = "spawn_distress_xeno"

/obj/effect/landmark/ert_spawns/distress/hunt_spawner/pred
	name = "bloding spawner"
	icon_state = "spawn_distress_pred"

/obj/effect/landmark/monkey_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.monkey_spawns += src

/obj/effect/landmark/monkey_spawn/Destroy()
	GLOB.monkey_spawns -= src
	return ..()

#define MAXIMUM_LIZARD_AMOUNT 4

/obj/effect/landmark/lizard_spawn
	name = "lizard spawn"
	icon_state = "lizard_spawn"

/obj/effect/landmark/lizard_spawn/Initialize(mapload, ...)
	. = ..()
	if(prob(66))
		new /mob/living/simple_animal/hostile/retaliate/giant_lizard(loc)
		addtimer(CALLBACK(src, PROC_REF(latespawn_lizard)), rand(35 MINUTES, 50 MINUTES))

/obj/effect/landmark/lizard_spawn/proc/latespawn_lizard()
	//if there's already a ton of lizards alive, try again later
	if(length(GLOB.giant_lizards_alive) > MAXIMUM_LIZARD_AMOUNT)
		addtimer(CALLBACK(src, PROC_REF(latespawn_lizard)), rand(15 MINUTES, 25 MINUTES))
		return
	//if there's a living mob that can witness the spawn then try again later
	for(var/mob/living/living_mob in range(7, src))
		if(living_mob.stat != DEAD || living_mob.client)
			continue
		addtimer(CALLBACK(src, PROC_REF(latespawn_lizard)), 1 MINUTES)
		return
	new /mob/living/simple_animal/hostile/retaliate/giant_lizard(loc)

#undef MAXIMUM_LIZARD_AMOUNT

/obj/effect/landmark/latewhiskey
	name = "Whiskey Outpost Late join"

/obj/effect/landmark/latewhiskey/Initialize(mapload, ...)
	. = ..()
	GLOB.latewhiskey += src

/obj/effect/landmark/latewhiskey/Destroy()
	GLOB.latewhiskey -= src
	return ..()

/obj/effect/landmark/thunderdome/one
	name = "Thunderdome Team 1"
	icon_state = "thunderdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_one += src

/obj/effect/landmark/thunderdome/one/Destroy()
	GLOB.thunderdome_one -= src
	return ..()

/obj/effect/landmark/thunderdome/two
	name = "Thunderdome Team 2"
	icon_state = "thunderdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_two += src

/obj/effect/landmark/thunderdome/two/Destroy()
	GLOB.thunderdome_two-= src
	return ..()

/obj/effect/landmark/thunderdome/admin
	name = "Thunderdome Admin"
	icon_state = "thunderdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_admin += src

/obj/effect/landmark/thunderdome/admin/Destroy()
	GLOB.thunderdome_admin -= src
	return ..()

/obj/effect/landmark/thunderdome/observer
	name = "Thunderdome Observer"
	icon_state = "thunderdome_observer"

/obj/effect/landmark/thunderdome/observer/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_observer += src

/obj/effect/landmark/thunderdome/observer/Destroy()
	GLOB.thunderdome_observer -= src
	return ..()

/obj/effect/landmark/queen_spawn
	name = "queen spawn"
	icon_state = "queen_spawn"

/obj/effect/landmark/queen_spawn/Initialize(mapload, ...)
	. = ..()

	var/area/area = get_area(src)
	area.unoviable_timer = FALSE

	GLOB.queen_spawns += src

/obj/effect/landmark/queen_spawn/Destroy()
	GLOB.queen_spawns -= src
	return ..()

/obj/effect/landmark/xeno_spawn
	name = "xeno spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_spawns += src

/obj/effect/landmark/xeno_spawn/Destroy()
	GLOB.xeno_spawns -= src
	return ..()

/obj/effect/landmark/xeno_hive_spawn
	name = "xeno vs xeno hive spawn"
	icon_state = "hive_spawn"

/obj/effect/landmark/xeno_hive_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_hive_spawns += src

/obj/effect/landmark/xeno_hive_spawn/Destroy()
	GLOB.xeno_hive_spawns -= src
	return ..()

/obj/effect/landmark/yautja_teleport
	name = "yautja_teleport"
	icon_state = "hunter_teleport"
	/// The index we registered as in mainship_yautja_desc or yautja_teleport_descs
	var/desc_index

/obj/effect/landmark/yautja_teleport/Initialize(mapload, ...)
	. = ..()
	var/turf/turf = get_turf(src)
	desc_index = turf.loc.name + turf.loc_to_string()
	if(is_mainship_level(z))
		GLOB.mainship_yautja_teleports += src
		GLOB.mainship_yautja_desc[desc_index] = src
	else
		GLOB.yautja_teleports += src
		GLOB.yautja_teleport_descs[desc_index] = src

/obj/effect/landmark/yautja_teleport/Destroy()
	GLOB.mainship_yautja_teleports -= src
	GLOB.yautja_teleports -= src
	GLOB.mainship_yautja_desc -= desc_index
	GLOB.yautja_teleport_descs -= desc_index
	return ..()

/obj/effect/landmark/yautja_young_teleport
	name = "yautja_teleport_youngblood"
	icon_state= "hunter_teleport"
	var/desc_index

/obj/effect/landmark/yautja_young_teleport/Initialize(mapload, ...)
	. = ..()
	var/turf/turf = get_turf(src)
	desc_index = turf.loc.name + turf.loc_to_string()
	GLOB.yautja_young_teleports += src
	GLOB.yautja_young_descs[desc_index] = src

/obj/effect/landmark/yautja_young_teleport/Destroy()
	GLOB.yautja_young_teleports -= src
	GLOB.yautja_young_descs -= desc_index
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon_state = "x"
	anchored = TRUE
	var/job
	var/squad
	var/job_list

/obj/effect/landmark/start/Initialize(mapload, ...)
	. = ..()
	if(job)
		if(squad)
			LAZYINITLIST(GLOB.spawns_by_squad_and_job[squad])
			LAZYADD(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYADD(GLOB.spawns_by_job[job], src)
	if(job_list)
		for(var/job_from_list in job_list)
			if(squad)
				LAZYINITLIST(GLOB.spawns_by_squad_and_job[squad])
				LAZYADD(GLOB.spawns_by_squad_and_job[squad][job_from_list], src)
			else
				LAZYADD(GLOB.spawns_by_job[job_from_list], src)
	else
		return

/obj/effect/landmark/start/Destroy()
	if(job)
		if(squad)
			LAZYREMOVE(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYREMOVE(GLOB.spawns_by_job[job], src)
	if(job_list)
		for(var/job_from_list in job_list)
			if(squad)
				LAZYREMOVE(GLOB.spawns_by_squad_and_job[squad][job_from_list], src)
				LAZYREMOVE(GLOB.latejoin_by_squad[squad][job_from_list], src)
			else
				LAZYREMOVE(GLOB.spawns_by_job[job_from_list], src)
				LAZYREMOVE(GLOB.latejoin_by_job[job_from_list], src)
	return ..()

/obj/effect/landmark/start/AISloc
	name = "AI"


//****************************************** MARINE ROLES ************************************************/
/obj/effect/landmark/start/whiskey //category moment, indeed

/obj/effect/landmark/start/whiskey/marine
	icon_state = "marine_spawn"
	job = /datum/job/marine/standard/whiskey

/obj/effect/landmark/start/whiskey/leader
	icon_state = "leader_spawn"
	job = /datum/job/marine/leader/whiskey

/obj/effect/landmark/start/whiskey/tl
	icon_state = "tl_spawn"
	job = /datum/job/marine/tl //Need to create a WO variant in the future

/obj/effect/landmark/start/whiskey/spec
	icon_state = "spec_spawn"
	job = /datum/job/marine/specialist/whiskey

/obj/effect/landmark/start/whiskey/smartgunner
	icon_state = "smartgunner_spawn"
	job = /datum/job/marine/smartgunner/whiskey

/obj/effect/landmark/start/whiskey/medic
	icon_state = "medic_spawn"
	job = /datum/job/marine/medic/whiskey

/obj/effect/landmark/start/whiskey/engineer
	icon_state = "engi_spawn"
	job = /datum/job/marine/engineer/whiskey

//****************************************** LOGISTICAL ROLES ************************************************/

/obj/effect/landmark/start/whiskey/requisition
	icon_state = "ro_spawn"
	job = /datum/job/logistics/requisition/whiskey

/obj/effect/landmark/start/whiskey/cargo
	icon_state = "ct_spawn"
	job = /datum/job/logistics/cargo/whiskey

/obj/effect/landmark/start/whiskey/engineering
	icon_state = "ce_spawn"
	job = /datum/job/logistics/engineering/whiskey

/obj/effect/landmark/start/whiskey/maint
	icon_state = "mt_spawn"
	job = /datum/job/logistics/maint/whiskey

/obj/effect/landmark/start/whiskey/tech
	icon_state = "ot_spawn"
	job = /datum/job/logistics/otech //Need to create a WO variant in the future

//****************************************** MILITARY POLICE- HONOR-GUARD ************************************************/
/obj/effect/landmark/start/whiskey/warrant
	icon_state = "leader_hg_spawn"
	job = /datum/job/command/warrant/whiskey

/obj/effect/landmark/start/whiskey/police
	icon_state = "hg_spawn"
	job = /datum/job/command/police/whiskey

/obj/effect/landmark/start/whiskey/warden
	icon_state = "mw_spawn"

	job = /datum/job/command/warden //Need to create a WO variant in the future

//****************************************** CIC - COMMAND ************************************************/

/obj/effect/landmark/start/whiskey/commander
	icon_state = "wco_spawn"
	job = /datum/job/command/commander/whiskey

/obj/effect/landmark/start/whiskey/executive
	icon_state = "wxo_spawn"
	job = /datum/job/command/executive/whiskey

/obj/effect/landmark/start/whiskey/bridge
	icon_state = "vet_hg_spawn"
	job = /datum/job/command/bridge/whiskey

//****************************************** AUXILIARY - SUPPORT ************************************************/
/obj/effect/landmark/start/whiskey/synthetic
	icon_state = "syn_spawn"
	job = /datum/job/civilian/synthetic/whiskey

/obj/effect/landmark/start/whiskey/senior
	icon_state = "sea_spawn"
	job = /datum/job/command/senior  //Need to create a WO variant in the future

/obj/effect/landmark/start/whiskey/pilot
	icon_state = "mo_spawn"
	job = /datum/job/command/pilot/whiskey

/obj/effect/landmark/start/whiskey/tank_crew
	icon_state = "spec_hg_spawn"
	job = /datum/job/command/tank_crew/whiskey

/obj/effect/landmark/start/whiskey/intel
	icon_state = "io_spawn"
	job = /datum/job/command/warden //Need to create a WO variant in the future,  IO's dont exist in code anymore?

/obj/effect/landmark/start/whiskey/chef
	icon_state = "chef_spawn"
	job = /datum/job/civilian/chef //Need to create a WO variant in the future

//****************************************** CIVILLIANS & MEDBAY ************************************************/

/obj/effect/landmark/start/whiskey/liaison
	icon_state = "cc_spawn"
	job = /datum/job/civilian/liaison/whiskey

/obj/effect/landmark/start/whiskey/cmo
	icon_state = "cmo_spawn"
	job = /datum/job/civilian/professor/whiskey

/obj/effect/landmark/start/whiskey/researcher
	icon_state = "chem_spawn"
	job = /datum/job/civilian/researcher/whiskey

/obj/effect/landmark/start/whiskey/doctor
	icon_state = "field_doc_spawn"
	job = /datum/job/civilian/doctor/whiskey

/obj/effect/landmark/start/whiskey/nurse
	icon_state = "nur_spawn"
	job = /datum/job/civilian/nurse //Need to create a WO variant in the future

//****************************************** LATE JOIN ************************************************/

/obj/effect/landmark/late_join
	name = "late join"
	icon_state = "late_join"
	var/squad
	/// What job should latejoin on this landmark
	var/job
	var/job_list

/obj/effect/landmark/late_join/alpha
	name = "alpha late join"
	icon_state = "late_join_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/late_join/bravo
	name = "bravo late join"
	icon_state = "late_join_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/late_join/charlie
	name = "charlie late join"
	icon_state = "late_join_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/late_join/delta
	name = "delta late join"
	icon_state = "late_join_delta"
	squad = SQUAD_MARINE_4

/obj/effect/landmark/late_join/working_joe
	name = "working joe late join"
	icon_state = "late_join_misc"
	job = JOB_WORKING_JOE

/obj/effect/landmark/late_join/dzho_automaton
	name = "dzho automaton late join"
	icon_state = "late_join_upp"
	job = JOB_UPP_JOE

/obj/effect/landmark/late_join/cmo
	name = "Chief Medical Officer late join"
	icon_state = "late_join_medical"
	job = JOB_CMO

/obj/effect/landmark/late_join/researcher
	name = "Researcher late join"
	icon_state = "late_join_medical"
	job = JOB_RESEARCHER

/obj/effect/landmark/late_join/doctor
	name = "Doctor late join"
	icon_state = "late_join_medical"
	job = JOB_DOCTOR

/obj/effect/landmark/late_join/field_doctor
	name = "Field Doctor late join"
	icon_state = "late_join_medical"
	job = JOB_FIELD_DOCTOR

/obj/effect/landmark/late_join/nurse
	name = "Nurse late join"
	icon_state = "late_join_medical"
	job = JOB_NURSE

/obj/effect/landmark/late_join/intel
	name = "Intelligence Officer late join"
	icon_state = "late_join_command"
	job = JOB_INTEL

/obj/effect/landmark/late_join/police
	name = "Military Police late join"
	icon_state = "late_join_police"
	job = JOB_POLICE

/obj/effect/landmark/late_join/warden
	name = "Military Warden late join"
	icon_state = "late_join_police"
	job = JOB_WARDEN

/obj/effect/landmark/late_join/chief_police
	name = "Chief Military Police late join"
	icon_state = "late_join_police"
	job = JOB_CHIEF_POLICE


/obj/effect/landmark/late_join/Initialize(mapload, ...)
	. = ..()
	if(squad)
		LAZYADD(GLOB.latejoin_by_squad[squad], src)
	else if(job)
		LAZYADD(GLOB.latejoin_by_job[job], src)
	else if(job_list)
		for(var/job_to_add in job_list)
			LAZYADD(GLOB.latejoin_by_job[job_to_add], src)

	else
		GLOB.latejoin += src

/obj/effect/landmark/late_join/Destroy()
	if(squad)
		LAZYREMOVE(GLOB.latejoin_by_squad[squad], src)
	else if(job)
		LAZYREMOVE(GLOB.latejoin_by_job[job], src)
	else if(job_list)
		for(var/job_to_add in job_list)
			LAZYREMOVE(GLOB.latejoin_by_job[job_to_add], src)
	else
		GLOB.latejoin -= src
	return ..()


/obj/effect/landmark/late_join/responder/uscm
	name = "USCM HC Fax Responder late join"
	job = JOB_FAX_RESPONDER_USCM_HC

/obj/effect/landmark/late_join/responder/uscm/provost
	name = "USCM Provost Fax Responder late join"
	job = JOB_FAX_RESPONDER_USCM_PVST

/obj/effect/landmark/late_join/responder/wey_yu
	name = "W-Y Fax Responder late join"
	job = JOB_FAX_RESPONDER_WY

/obj/effect/landmark/late_join/responder/upp
	name = "UPP Fax Responder late join"
	job = JOB_FAX_RESPONDER_UPP

/obj/effect/landmark/late_join/responder/twe
	name = "TWE Fax Responder late join"
	job = JOB_FAX_RESPONDER_TWE

/obj/effect/landmark/late_join/responder/clf
	name = "CLF Fax Responder late join"
	job = JOB_FAX_RESPONDER_CLF

/obj/effect/landmark/late_join/responder/cmb
	name = "CMB Fax Responder late join"
	job = JOB_FAX_RESPONDER_CMB

/obj/effect/landmark/late_join/responder/press
	name = "Press Fax Responder late join"
	job = JOB_FAX_RESPONDER_PRESS

//****************************************** STATIC COMMS ************************************************//
/obj/effect/landmark/static_comms
	name = "static comms"
	icon = 'icons/obj/structures/machinery/comm_tower3.dmi'
	icon_state = "comms_landmark"
	var/broken_on_spawn = FALSE

/obj/effect/landmark/static_comms/proc/spawn_tower()
	var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/commstower = new /obj/structure/machinery/telecomms/relay/preset/tower/mapcomms(loc)
	if(broken_on_spawn)
		commstower.update_health(damage = health) //fuck it up
	qdel(src)

/obj/effect/landmark/static_comms/net_one
	icon_state = "comms_landmark_1"

/obj/effect/landmark/static_comms/net_one/Initialize(mapload, ...)
	. = ..()
	GLOB.comm_tower_landmarks_net_one += src

/obj/effect/landmark/static_comms/net_one/Destroy()
	GLOB.comm_tower_landmarks_net_one -= src
	return ..()

/obj/effect/landmark/static_comms/net_two
	icon_state = "comms_landmark_2"

/obj/effect/landmark/static_comms/net_two/Initialize(mapload, ...)
	. = ..()
	GLOB.comm_tower_landmarks_net_two += src

/obj/effect/landmark/static_comms/net_two/Destroy()
	GLOB.comm_tower_landmarks_net_two -= src
	return ..()


// zombie spawn
/obj/effect/landmark/zombie
	name = "zombie spawnpoint"
	desc = "The spot a zombie spawns in. Players in-game can't see this."
	icon_state = "corpse_spawner"
	invisibility_value = INVISIBILITY_OBSERVER
	var/spawns_left = 1
	var/infinite_spawns = FALSE

/obj/effect/landmark/zombie/Initialize(mapload, ...)
	. = ..()
	GLOB.zombie_landmarks += src

/obj/effect/landmark/zombie/Destroy()
	GLOB.zombie_landmarks -= src
	return ..()

/obj/effect/landmark/zombie/proc/spawn_zombie(mob/dead/observer/observer)
	if(!infinite_spawns)
		spawns_left--
	if(spawns_left <= 0)
		GLOB.zombie_landmarks -= src
	anim(loc, loc, 'icons/mob/mob.dmi', null, "zombie_rise", 12, SOUTH)
	observer.see_invisible = SEE_INVISIBLE_LIVING
	observer.client.eye = src // gives the player a second to orient themselves to the spawn zone
	addtimer(CALLBACK(src, PROC_REF(handle_zombie_spawn), observer), 1 SECONDS)

/obj/effect/landmark/zombie/proc/handle_zombie_spawn(mob/dead/observer/observer)
	var/mob/living/carbon/human/zombie = new /mob/living/carbon/human(loc)
	if(!zombie.hud_used)
		zombie.create_hud()
	arm_equipment(zombie, /datum/equipment_preset/other/zombie, randomise = TRUE, count_participant = TRUE, mob_client = observer.client, show_job_gear = TRUE)
	observer.client.eye = zombie
	observer.mind.transfer_to(zombie)
	if(spawns_left <= 0)
		qdel(src)

/obj/effect/landmark/zombie/three
	spawns_left = 3

/obj/effect/landmark/zombie/infinite
	infinite_spawns = TRUE

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"

/// Marks the bottom left of the tutorial zone.
/obj/effect/landmark/tutorial_bottom_left
	name = "tutorial bottom left"
	icon_state = "new_player"
