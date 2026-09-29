/datum/game_mode/colonialmarines/forward_base
	name = GAMEMODE_FORWARD_BASE
	config_tag = GAMEMODE_FORWARD_BASE

/datum/game_mode/colonialmarines/forward_base/map_announcement()
	marine_announcement("Bad timing, marines. The CLF demolished the regional military communications relay before you arrived. We've got this emergency channel to you, but that's about it. I can't coordinate another unit into your area, meaning, I can't get you the reinforcements you requested. You have a fortified position and enough ammunition to finish the job. You're on your own. Cameron out.", "TRANSMISSION - BRIGADIER GENERAL CAMERON - CHINOOK 91 GSO STATION")
/datum/game_mode/colonialmarines/forward_base/pre_setup()
	. = ..()
	active_lz = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1)

/datum/game_mode/colonialmarines/forward_base/post_setup()
	. = ..()
	var/obj/docking_port/stationary/marine_dropship/lz1/landing_zone = locate() in SSshuttle.stationary
	SSshuttle.action_load(SSmapping.all_shuttle_templates[/datum/map_template/shuttle/normandy], landing_zone)
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/console in GLOB.machines)
		console.skip_time_lock = TRUE

/datum/game_mode/colonialmarines/forward_base/spawn_lz_sentry(turf/target, list/structures_to_break)
	var/obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone/forward_base/turret = new(target)
	QDEL_IN(turret, 35 MINUTES - ROUND_TIME)

/datum/game_mode/colonialmarines/forward_base/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING || round_started > 0 || round_finished)
		return
	if(!count_marines(SSmapping.levels_by_trait(ZTRAIT_GROUND)))
		round_finished = MODE_INFESTATION_X_MAJOR
		return
	return ..()

/obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone/forward_base
	battery_duration = 35 MINUTES
