#define FORWARD_BASE_FOG_DURATION (18 MINUTES) // From roundstart. 00:23 if the pre-game length wasnt changed
#define FORWARD_BASE_FOG_WARNING (1 MINUTES) // How many minutes before FORWARD_BASE_FOG_DURATION. 00:24 if the pre-game length wasnt changed
#define FORWARD_BASE_COMMS_FAILURE (2 MINUTES) // How many minutes after FORWARD_BASE_FOG_DURATION. 00:25 if the pre-game length wasnt changed
#define FORWARD_BASE_TURRET_BATTERY_DURATION (30 MINUTES) // From roundstart. 00:35 if the pre-game length wasnt changed

/datum/game_mode/colonialmarines/forward_base
	name = GAMEMODE_FORWARD_BASE
	config_tag = GAMEMODE_FORWARD_BASE
	votable = FALSE

/datum/game_mode/colonialmarines/forward_base/get_roles_list()
	return ..() - list(JOB_DROPSHIP_PILOT, JOB_FIELD_DOCTOR)

/datum/game_mode/colonialmarines/forward_base/map_announcement()
	marine_announcement("Bad timing, marines. The CLF hit the regional military communications network and demolished the nearest long-range relay station. We've got this emergency channel to you, but that's about it. I can't coordinate another unit into your area, meaning, I can't get you the reinforcements you requested. You have a fortified position and enough ammunition to finish the job. You're on your own. Cameron out.", "BRIGADIER GENERAL CAMERON - CHINOOK 91 GSO STATION", 'sound/AI/commandreport.ogg')
	xeno_announcement("A hive of armed tallhosts have fortified themselves in a nest at the edge of our territory. The dense mist conceals them from you, but it is beginning to fade. Be patient. Soon, the way to the hosts will be clear.", "everything", QUEEN_MOTHER_ANNOUNCE)

/datum/game_mode/colonialmarines/forward_base/ares_conclude()
	marine_announcement("Well, marines, the regional relay is finally back online. I was halfway through getting your reinforcements moving when your all-clear came through. Seems you didn't need them after all. Saves me the trouble. Count your dead and send me the casualty reports. Cameron out.", "BRIGADIER GENERAL CAMERON - CHINOOK 91 GSO STATION", 'sound/AI/commandreport.ogg')

/datum/game_mode/colonialmarines/forward_base/pre_setup()
	. = ..()
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/console in GLOB.machines)
		if(console.linked_lz && istype(get_area(console), /area/forward_base))
			active_lz = console
			break
	for(var/area/forward_base/bunker_area in GLOB.all_areas)
		bunker_area.flags_area |= AREA_NOBURROW
	for(var/obj/effect/landmark/lv624/fog_blocker/fog in GLOB.landmarks_list)
		fog.time_to_dispel = FORWARD_BASE_FOG_DURATION

/datum/game_mode/colonialmarines/forward_base/post_setup()
	. = ..()
	if(GLOB.almayer_orbital_cannon)
		COOLDOWN_START(GLOB.almayer_orbital_cannon, ob_firing_cooldown, FORWARD_BASE_FOG_DURATION - ROUND_TIME)
	addtimer(CALLBACK(src, PROC_REF(allow_base_burrowing)), FORWARD_BASE_FOG_DURATION - ROUND_TIME)
	addtimer(CALLBACK(src, PROC_REF(disable_base_comms)), FORWARD_BASE_FOG_DURATION + FORWARD_BASE_COMMS_FAILURE - ROUND_TIME)
	addtimer(CALLBACK(src, PROC_REF(warn_resin_clear)), FORWARD_BASE_FOG_DURATION - ROUND_TIME)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "The mist is almost gone. In one minute, the tallhosts will be exposed. Gather yourselves and prepare to tear their nest apart.", "everything", QUEEN_MOTHER_ANNOUNCE), FORWARD_BASE_FOG_DURATION - FORWARD_BASE_FOG_WARNING - ROUND_TIME)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(marine_announcement), "WARNING. HOSTILE CONTACT IMMINENT. Atmospheric obscuration is rapidly dissipating and will be lost within sixty seconds. ALL COMBAT PERSONNEL, assume defensive positions immediately.", "BASE PERIMETER ALERT", 'sound/effects/siren.ogg'), FORWARD_BASE_FOG_DURATION - FORWARD_BASE_FOG_WARNING - ROUND_TIME)
	var/obj/docking_port/stationary/marine_dropship/landing_zone = SSshuttle.getDock(active_lz.linked_lz)
	SSshuttle.action_load(SSmapping.all_shuttle_templates[/datum/map_template/shuttle/normandy], landing_zone)
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/console in GLOB.machines)
		console.time_lock = FORWARD_BASE_FOG_DURATION

/datum/game_mode/colonialmarines/forward_base/proc/allow_base_burrowing()
	for(var/area/forward_base/bunker_area in GLOB.all_areas)
		if(!(initial(bunker_area.flags_area) & AREA_NOBURROW))
			bunker_area.flags_area &= ~AREA_NOBURROW

/datum/game_mode/colonialmarines/forward_base/proc/disable_base_comms()
	marine_announcement("WARNING. BASE RELAY BACKUP BATTERY DEPLETED. Military radio coverage is offline. Recommended action: hijack a civilian communications tower and reestablish contact through the colony network.", "BASE COMMUNICATIONS ALERT", 'sound/AI/commandreport.ogg')
	for(var/obj/structure/machinery/telecomms/relay/preset/tower/all/relay in GLOB.telecomms_list)
		if(istype(get_area(relay), /area/forward_base))
			relay.toggled = FALSE
			relay.update_state()

/datum/game_mode/colonialmarines/forward_base/warn_resin_clear(obj/docking_port/mobile/marine_dropship)
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
		return
	clear_proximity_resin()
	marine_announcement("WARNING. PERIMETER DECONTAMINATION ACTIVE. C10-W weedkiller is being dispersed around the base perimiter.", "BASE PERIMETER ALERT", 'sound/effects/rocketpod_fire.ogg')

/datum/game_mode/colonialmarines/forward_base/spawn_lz_sentry(turf/target, list/structures_to_break)
	new /obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone/forward_base(target)

/datum/game_mode/colonialmarines/forward_base/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING || round_started > 0 || round_finished)
		return
	if(!count_marines(SSmapping.levels_by_trait(ZTRAIT_GROUND)))
		round_finished = MODE_INFESTATION_X_MAJOR
		return
	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(!main_hive.see_humans_on_tacmap)
		var/groundside_humans = 0
		for(var/mob/living/carbon/human/human as anything in GLOB.alive_human_list)
			var/turf/human_turf = get_turf(human)
			if(is_ground_level(human_turf?.z))
				groundside_humans++
		if(groundside_humans < main_hive.get_real_total_xeno_count() * HIJACK_RATIO_FOR_TACMAP)
			main_hive.see_humans_on_tacmap = TRUE
			main_hive.tacmap_requires_queen_ovi = FALSE
			SEND_SIGNAL(main_hive, COMSIG_XENO_REVEAL_TACMAP)
			xeno_announcement("There is only a handful of tallhosts left, they are now visible on our hive mind map.", XENO_HIVE_NORMAL, SPAN_ANNOUNCEMENT_HEADER_BLUE("[QUEEN_MOTHER_ANNOUNCE]"))
	return ..()

/obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone/forward_base
	battery_duration = FORWARD_BASE_TURRET_BATTERY_DURATION

#undef FORWARD_BASE_FOG_DURATION
#undef FORWARD_BASE_FOG_WARNING
#undef FORWARD_BASE_COMMS_FAILURE
#undef FORWARD_BASE_TURRET_BATTERY_DURATION
