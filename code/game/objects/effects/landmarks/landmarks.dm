/obj/effect/landmark
	name = "landmark"
	icon = 'icons/landmarks.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = TRUE

	var/invisibility_value = INVISIBILITY_MAXIMUM

/obj/effect/landmark/New()
	..()
	tag = "landmark*[name]"
	invisibility = invisibility_value
	return 1

/obj/effect/landmark/Initialize(mapload, ...)
	. = ..()
	invisibility = invisibility_value

/obj/effect/landmark/newplayer_start
	name = "New player start"

/obj/effect/landmark/newplayer_start/New() // this must be New()
	. = ..()
	GLOB.newplayer_start += src

/obj/effect/landmark/newplayer_start/Destroy()
	GLOB.newplayer_start -= src
	return ..()

/obj/effect/landmark/observer_start
	name = "Observer Landmark"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost1"

/obj/effect/landmark/observer_start/Initialize()
	. = ..()
	GLOB.observer_starts += src

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
	var/insert_tag            // Identifier for global mapping
	var/replace = FALSE       // Replace another existing landmark mapping of same name
	var/autoremove = TRUE     // Delete mapped turf when landmark is deleted, such as by an insert in replace mode
/obj/effect/landmark/nightmare/Initialize(mapload, ...)
	. = ..()
	if(!insert_tag) return
	if(!replace && GLOB.nightmare_landmarks[insert_tag])
		return
	GLOB.nightmare_landmarks[insert_tag] = get_turf(src)
/obj/effect/landmark/nightmare/Destroy()
	if(insert_tag && autoremove \
	   && GLOB.nightmare_landmarks[insert_tag] == get_turf(src))
		GLOB.nightmare_landmarks.Remove(insert_tag)
	return ..()

/obj/effect/landmark/ert_spawns/distress
	name = "Distress"

/obj/effect/landmark/ert_spawns/distress/item
	name = "DistressItem"

/obj/effect/landmark/ert_spawns/distress_wo
	name = "distress_wo"

/obj/effect/landmark/monkey_spawn
	name = "monkey_spawn"
	icon_state = "monkey_spawn"

/obj/effect/landmark/monkey_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.monkey_spawns += src

/obj/effect/landmark/monkey_spawn/Destroy()
	GLOB.monkey_spawns -= src
	return ..()

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

/obj/effect/landmark/thunderdome/one/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_one += src

/obj/effect/landmark/thunderdome/one/Destroy()
	GLOB.thunderdome_one -= src
	return ..()

/obj/effect/landmark/thunderdome/two
	name = "Thunderdome Team 2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_two += src

/obj/effect/landmark/thunderdome/two/Destroy()
	GLOB.thunderdome_two-= src
	return ..()

/obj/effect/landmark/thunderdome/admin
	name = "Thunderdome Admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_admin += src

/obj/effect/landmark/thunderdome/admin/Destroy()
	GLOB.thunderdome_admin -= src
	return ..()

/obj/effect/landmark/thunderdome/observer
	name = "Thunderdome Observer"

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
	GLOB.queen_spawns += src

/obj/effect/landmark/queen_spawn/Destroy()
	GLOB.queen_spawns -= src
	return ..()

/obj/effect/landmark/xeno_spawn
	name = "xeno spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_spawns += src

/obj/effect/landmark/xeno_spawn/Destroy()
	GLOB.xeno_spawns -= src
	return ..()

/obj/effect/landmark/xeno_hive_spawn
	name = "xeno hive spawn"
	icon_state = "hive_spawn"

/obj/effect/landmark/xeno_hive_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_hive_spawns += src

/obj/effect/landmark/xeno_hive_spawn/Destroy()
	GLOB.xeno_hive_spawns -= src
	return ..()

/obj/effect/landmark/yautja_teleport
	name = "yautja_teleport"

/obj/effect/landmark/yautja_teleport/Initialize(mapload, ...)
	. = ..()
	var/turf/T = get_turf(src)
	if(is_mainship_level(z))
		GLOB.mainship_yautja_teleports += src
		GLOB.mainship_yautja_desc[T.loc.name + T.loc_to_string()] = src
	else
		GLOB.yautja_teleports += src
		GLOB.yautja_teleport_descs[T.loc.name + T.loc_to_string()] = src

/obj/effect/landmark/yautja_teleport/Destroy()
	var/turf/T = get_turf(src)
	GLOB.mainship_yautja_teleports -= src
	GLOB.yautja_teleports -= src
	GLOB.mainship_yautja_desc -= T.loc.name + T.loc_to_string()
	GLOB.yautja_teleport_descs -= T.loc.name + T.loc_to_string()
	return ..()



/obj/effect/landmark/start
	name = "start"
	icon_state = "x"
	anchored = TRUE
	var/job
	var/squad

/obj/effect/landmark/start/Initialize(mapload, ...)
	. = ..()
	if(job)
		if(squad)
			LAZYINITLIST(GLOB.spawns_by_squad_and_job[squad])
			LAZYADD(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYADD(GLOB.spawns_by_job[job], src)

/obj/effect/landmark/start/Destroy()
	if(job)
		if(squad)
			LAZYREMOVE(GLOB.spawns_by_squad_and_job[squad][job], src)
		else
			LAZYREMOVE(GLOB.spawns_by_job[job], src)
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

/obj/effect/landmark/start/whiskey/rto
	icon_state = "rto_spawn"
	job = /datum/job/marine/rto //Need to create a WO variant in the future

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
	job = /datum/job/logistics/requisition/whiskey

/obj/effect/landmark/start/whiskey/cargo
	job = /datum/job/logistics/cargo/whiskey

/obj/effect/landmark/start/whiskey/engineering
	job = /datum/job/logistics/engineering/whiskey

/obj/effect/landmark/start/whiskey/maint
	job = /datum/job/logistics/tech/maint/whiskey

/obj/effect/landmark/start/whiskey/tech
	job = /datum/job/logistics/tech //Need to create a WO variant in the future

//****************************************** MILITARY POLICE- HONOR-GUARD ************************************************/
/obj/effect/landmark/start/whiskey/warrant
	job = /datum/job/command/warrant/whiskey

/obj/effect/landmark/start/whiskey/police
	job = /datum/job/command/police/whiskey

/obj/effect/landmark/start/whiskey/warden
	job = /datum/job/command/warden //Need to create a WO variant in the future

//****************************************** CIC - COMMAND ************************************************/

/obj/effect/landmark/start/whiskey/commander
	job = /datum/job/command/commander/whiskey

/obj/effect/landmark/start/whiskey/executive
	job = /datum/job/command/executive/whiskey

/obj/effect/landmark/start/whiskey/bridge
	job = /datum/job/command/bridge/whiskey

//****************************************** AUXILIARY - SUPPORT ************************************************/
/obj/effect/landmark/start/whiskey/synthetic
	job = /datum/job/civilian/synthetic/whiskey

/obj/effect/landmark/start/whiskey/senior
	job = /datum/job/command/senior  //Need to create a WO variant in the future

/obj/effect/landmark/start/whiskey/pilot
	job = /datum/job/command/pilot/whiskey

/obj/effect/landmark/start/whiskey/tank_crew
	job = /datum/job/command/tank_crew/whiskey

/obj/effect/landmark/start/whiskey/intel
	job = /datum/job/command/warden //Need to create a WO variant in the future,  IO's dont exist in code anymore?

/obj/effect/landmark/start/whiskey/chef
	job = /datum/job/civilian/chef //Need to create a WO variant in the future

//****************************************** CIVILLIANS & MEDBAY ************************************************/

/obj/effect/landmark/start/whiskey/liaison
	job = /datum/job/civilian/liaison/whiskey

/obj/effect/landmark/start/whiskey/cmo
	job = /datum/job/civilian/professor/whiskey

/obj/effect/landmark/start/whiskey/researcher
	job = /datum/job/civilian/researcher/whiskey

/obj/effect/landmark/start/whiskey/doctor
	job = /datum/job/civilian/doctor/whiskey

/obj/effect/landmark/start/whiskey/nurse
	job = /datum/job/civilian/nurse //Need to create a WO variant in the future

//****************************************** LATE JOIN ************************************************/

/obj/effect/landmark/late_join
	name = "late join"
	icon_state = "x2"
	var/squad

/obj/effect/landmark/late_join/alpha
	name = "alpha late join"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/late_join/bravo
	name = "bravo late join"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/late_join/charlie
	name = "charlie late join"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/late_join/delta
	name = "delta late join"
	squad = SQUAD_MARINE_4


/obj/effect/landmark/late_join/Initialize(mapload, ...)
	. = ..()
	if(squad)
		LAZYADD(GLOB.latejoin_by_squad[squad], src)
	else
		GLOB.latejoin += src

/obj/effect/landmark/late_join/Destroy()
	if(squad)
		LAZYREMOVE(GLOB.latejoin_by_squad[squad], src)
	else
		GLOB.latejoin -= src
	return ..()

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

/obj/effect/landmark/zombie/proc/spawn_zombie(var/mob/dead/observer/observer)
	if(!infinite_spawns)
		spawns_left--
	if(spawns_left <= 0)
		GLOB.zombie_landmarks -= src
	anim(loc, loc, 'icons/mob/mob.dmi', null, "zombie_rise", 12, SOUTH)
	observer.see_invisible = SEE_INVISIBLE_LIVING
	observer.client.eye = src // gives the player a second to orient themselves to the spawn zone
	addtimer(CALLBACK(src, .proc/handle_zombie_spawn, observer), 1 SECONDS)

/obj/effect/landmark/zombie/proc/handle_zombie_spawn(var/mob/dead/observer/observer)
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
