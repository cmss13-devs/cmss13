/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21

	dwidth = 5
	dheight = 10

	landing_sound = 'sound/effects/dropship_flight_end.ogg'
	ignition_sound = 'sound/effects/dropship_flight_start.ogg'
	ambience_flight = 'sound/effects/dropship_flight_recurr.ogg'

	preferred_direction = SOUTH
	callTime = DROPSHIP_TRANSIT_DURATION
	rechargeTime = SHUTTLE_RECHARGE
	ignitionTime = DROPSHIP_WARMUP_TIME
	prearrivalTime = DROPSHIP_WARMUP_TIME
	var/datum/door_controller/aggregate/door_control

	// Door control has been overridden
	var/door_override = FALSE

	// Is in gun-run mode
	var/in_flyby = FALSE

	// Is hijacked by opfor
	var/is_hijacked = FALSE
	var/datum/dropship_hijack/almayer/hijack
	// CAS gear
	var/list/obj/structure/dropship_equipment/equipments = list()

	// dropship automated target
	var/automated_target
	var/obj/docking_port/stationary/automated_hangar
	var/obj/docking_port/stationary/automated_lz
	var/automated_delay
	var/automated_timer
	var/flags_automated_airlock_presence = NO_FLAGS

	var/datum/cas_signal/paradrop_signal
	var/turbulence = TRUE //do you want turbulence?
	var/faction = FACTION_MARINE

/obj/docking_port/mobile/marine_dropship/Initialize(mapload)
	. = ..()
	door_control = new()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			switch(air.id)
				if("starboard_door")
					door_control.add_door(air, "starboard")
				if("port_door")
					door_control.add_door(air, "port")
				if("aft_door")
					door_control.add_door(air, "aft")

			var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/hatch = air
			if(istype(hatch))
				hatch.linked_dropship = src

	RegisterSignal(src, COMSIG_DROPSHIP_ADD_EQUIPMENT, PROC_REF(add_equipment))
	RegisterSignal(src, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, PROC_REF(remove_equipment))
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)
	UnregisterSignal(src, COMSIG_DROPSHIP_ADD_EQUIPMENT)
	UnregisterSignal(src, COMSIG_DROPSHIP_REMOVE_EQUIPMENT)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/obj/docking_port/mobile/marine_dropship/proc/send_for_flyby()
	in_flyby = TRUE
	var/obj/docking_port/stationary/docked_at = get_docked()
	SSshuttle.moveShuttle(src.id, docked_at.id, TRUE)

/obj/docking_port/mobile/marine_dropship/proc/add_equipment(obj/docking_port/mobile/marine_dropship/dropship, obj/structure/dropship_equipment/equipment)
	SIGNAL_HANDLER
	equipments += equipment

/obj/docking_port/mobile/marine_dropship/proc/remove_equipment(obj/docking_port/mobile/marine_dropship/dropship, obj/structure/dropship_equipment/equipment)
	SIGNAL_HANDLER
	equipments -= equipment

/obj/docking_port/mobile/marine_dropship/proc/get_door_data()
	return door_control.get_data()

/obj/docking_port/mobile/marine_dropship/proc/control_doors(action, direction, force, asynchronous = TRUE)
	// its been locked down by the queen
	if(door_override)
		return
	door_control.control_doors(action, direction, force, asynchronous)

/obj/docking_port/mobile/marine_dropship/proc/is_door_locked(direction)
	return door_control.is_door_locked(direction)

/obj/docking_port/mobile/marine_dropship/enterTransit()
	. = ..()
	if(SSticker?.mode && !(SSticker.mode.flags_round_type & MODE_DS_LANDED) && !in_flyby && is_ground_level(destination?.z)) //Launching on first drop.
		SSticker.mode.ds_first_drop(src)
	if(turbulence)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/mobile/marine_dropship, turbulence)), DROPSHIP_TURBULENCE_START_PERIOD)

/obj/docking_port/mobile/marine_dropship/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	control_doors("force-lock-launch", "all", force=TRUE, asynchronous = FALSE)

	if(is_hijacked)
		return

	for(var/area/checked_area in shuttle_areas)
		for(var/mob/living/carbon/xenomorph/checked_xeno in checked_area)
			if(checked_xeno.stat == DEAD || (FACTION_MARINE in checked_xeno.iff_tag?.faction_groups))
				continue
			var/name = "Unidentified Lifesigns"
			var/input = "Unidentified lifesigns detected onboard. Recommendation: lockdown of exterior access ports, including ducting and ventilation."
			shipwide_ai_announcement(input, name, 'sound/AI/unidentified_lifesigns.ogg', ares_logging = ARES_LOG_SECURITY)
			set_security_level(SEC_LEVEL_RED)
			return

/obj/docking_port/mobile/marine_dropship/on_prearrival()
	if(destination)
		destination.on_prearrival(src)
	return

/obj/docking_port/mobile/marine_dropship/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			air.handle_multidoor(old_dir, new_dir)

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"
	id = DROPSHIP_ALAMO
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/alamo/get_transit_path_type()
	return /turf/open/space/transit/dropship/alamo

/obj/docking_port/mobile/marine_dropship/normandy
	name = "Normandy"
	id = DROPSHIP_NORMANDY
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/normandy/get_transit_path_type()
	return /turf/open/space/transit/dropship/normandy

/obj/docking_port/mobile/marine_dropship/saipan
	name = "Saipan"
	id = DROPSHIP_SAIPAN
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/saipan/get_transit_path_type()
	return /turf/open/space/transit/dropship/saipan

/obj/docking_port/mobile/marine_dropship/morana
	name = "Morana"
	id = DROPSHIP_MORANA
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well
	faction = FACTION_UPP

/obj/docking_port/mobile/marine_dropship/morana/get_transit_path_type()
	return /turf/open/space/transit/dropship/morana

/obj/docking_port/mobile/marine_dropship/devana
	name = "Devana"
	id = DROPSHIP_DEVANA
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well
	faction = FACTION_UPP

/obj/docking_port/mobile/marine_dropship/devana/get_transit_path_type()
	return /turf/open/space/transit/dropship/devana


/obj/docking_port/mobile/marine_dropship/check()
	. = ..()

	if(mode == SHUTTLE_CRASHED)
		return

	if(mode == SHUTTLE_PREARRIVAL && istype(destination, /obj/docking_port/stationary/marine_dropship))
		var/obj/docking_port/stationary/marine_dropship/dropzone = destination
		if(!dropzone.landing_lights_on)
			dropzone.turn_on_landing_lights()
			playsound(dropzone.return_center_turf(), landing_sound, channel = SOUND_CHANNEL_DROPSHIP, vol_cat = VOLUME_SFX)
			playsound(return_center_turf(), landing_sound, channel = SOUND_CHANNEL_DROPSHIP, vol_cat = VOLUME_SFX)

	automated_check()

	hijack?.check()

/obj/docking_port/mobile/marine_dropship/proc/automated_check()
	if(!automated_hangar || !automated_lz || !automated_delay)
		return

	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = getControlConsole()
	if(!root_console || root_console.dropship_control_lost)
		automated_hangar = null
		automated_lz = null
		automated_delay = null
		return

	if(flags_automated_airlock_presence)
		var/is_lz_dock_ready = TRUE // if they aren't airlocks, this value won't be changed, so they are 'ready' for automated transport
		var/is_hangar_dock_ready = TRUE
		var/obj/docking_port/stationary/marine_dropship/airlock/outer/outer_airlock_dock
		if(flags_automated_airlock_presence & DROPSHIP_HANGAR_DOCK_IS_AIRLOCK)
			outer_airlock_dock = automated_hangar
			if(outer_airlock_dock?.linked_inner?.processing)
				return
			if(outer_airlock_dock?.linked_inner?.test_conditions(test_open_outer = FALSE) && !istype(get_docked(), /obj/docking_port/stationary/marine_dropship/airlock/inner))
				is_hangar_dock_ready = FALSE
		if(flags_automated_airlock_presence & DROPSHIP_LZ_DOCK_IS_AIRLOCK)
			outer_airlock_dock = automated_lz
			if(outer_airlock_dock?.linked_inner?.processing)
				return
			if(outer_airlock_dock?.linked_inner?.test_conditions(test_open_outer = FALSE) && !istype(get_docked(), /obj/docking_port/stationary/marine_dropship/airlock/inner))
				is_lz_dock_ready = FALSE
		if(!is_lz_dock_ready || !is_hangar_dock_ready)
			log_ares_flight("Automatic","Automatic dropship flight on [name] has been disabled due to a lack of response from a dropship airlock.")
			ai_silent_announcement("Automatic dropship flight on [name] has been disabled due to a lack of response from a dropship airlock.")
			automated_hangar = null
			automated_lz = null
			automated_delay = null
			return

	if(mode == SHUTTLE_IDLE && !automated_timer)
		var/obj/docking_port/stationary/marine_dropship/docked_at = get_docked()
		if(faction == FACTION_MARINE)
			ai_silent_announcement("The [name] will automatically depart from [docked_at.name] in [automated_delay * 0.1] seconds.")

		automated_timer = addtimer(CALLBACK(src, PROC_REF(automated_fly)), automated_delay, TIMER_STOPPABLE)

/obj/docking_port/mobile/marine_dropship/proc/automated_fly()
	automated_timer = null
	if(!automated_hangar || !automated_lz || !automated_delay)
		return
	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = getControlConsole()
	if(root_console.dropship_control_lost)
		return
	if(mode != SHUTTLE_IDLE)
		return
	var/obj/docking_port/stationary/dockedAt = get_docked()
	if(!automated_target)
		if(dockedAt.id == automated_hangar.id)
			automated_target = automated_lz.id
		else if (dockedAt.id == automated_lz.id)
			automated_target = automated_hangar.id
	if(flags_automated_airlock_presence && istype(dockedAt, /obj/docking_port/stationary/marine_dropship/airlock))
		var/list/return_list = null
		var/obj/docking_port/stationary/marine_dropship/airlock/inner/dockedAt_airlock_inner
		var/obj/docking_port/stationary/marine_dropship/airlock/outer/dockedAt_airlock_outer
		if(istype(dockedAt, /obj/docking_port/stationary/marine_dropship/airlock/inner))
			dockedAt_airlock_inner = dockedAt
		if(istype(dockedAt, /obj/docking_port/stationary/marine_dropship/airlock/outer))
			dockedAt_airlock_outer = dockedAt
			dockedAt_airlock_inner = dockedAt_airlock_outer.linked_inner
		if(dockedAt_airlock_inner.processing)
			return
		if(dockedAt_airlock_inner.linked_outer.id == automated_hangar.id)
			automated_target = automated_lz.id
		else if(dockedAt_airlock_inner.linked_outer.id == automated_lz.id)
			automated_target = automated_hangar.id
		if(!dockedAt_airlock_outer) // is the dockedAt inner
			return_list = dockedAt_airlock_inner.automatic_process(DROPSHIP_AIRLOCK_GO_DOWN)
		if(return_list)
			if(!return_list["successful"])
				log_ares_flight("Automatic","Automatic dropship flight on \the [name] has been disabled because [lowertext(return_list["to_chat"])]")
				ai_silent_announcement("Automatic dropship flight on \the [name] has been disabled because [lowertext(return_list["to_chat"])]")
				automated_hangar = null
				automated_lz = null
				automated_delay = null
			return
	if(automated_target)
		SSshuttle.moveShuttle(id, automated_target, TRUE)
		automated_target = null
		ai_silent_announcement("Dropship '[name]' departing.")

/obj/docking_port/mobile/marine_dropship/proc/dropship_freefall()
	var/list/affected_list = turbulence_sort_affected()

	for(var/mob/living/affected_mob as anything in affected_list["mobs"])
		to_chat(affected_mob, SPAN_DANGER("The dropship jolts violently as it enters freefall!"))
		shake_camera(affected_mob, DROPSHIP_TURBULENCE_FREEFALL_PERIOD / 2, 1)
		if(!affected_mob.buckled)
			affected_mob.KnockDown(DROPSHIP_TURBULENCE_FREEFALL_PERIOD * 0.1)
			affected_mob.throw_random_direction(2, spin = TRUE)
			affected_mob.apply_armoured_damage(40, ARMOR_MELEE, BRUTE, rand_zone())
			affected_mob.visible_message(SPAN_DANGER("[affected_mob] loses their grip on the floor, flying violenty upwards!"), SPAN_DANGER("You lose your grip on the floor, flying violenty upwards!"))
			if(prob(DROPSHIP_TURBULENCE_BONEBREAK_PROBABILITY * 2) && istype(affected_mob, /mob/living/carbon/human) && affected_mob.body_position == STANDING_UP)
				var/mob/living/carbon/human/affected_human = affected_mob
				var/obj/limb/fracturing_limb = affected_human.get_limb(pick(EXTREMITY_LIMBS))
				fracturing_limb.fracture(100)

	turbulence_item_handle(affected_list["items"])

/obj/docking_port/mobile/marine_dropship/proc/turbulence()
	if(!in_flight())
		return
	var/flight_time_left = timeLeft(1)
	if(flight_time_left >= DROPSHIP_TURBULENCE_PERIOD*2 && !(flight_time_left == INFINITY))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/mobile/marine_dropship, turbulence)), (rand(DROPSHIP_TURBULENCE_PERIOD, max((flight_time_left/2), DROPSHIP_TURBULENCE_PERIOD))))
	if(!prob(DROPSHIP_TURBULENCE_PROBABILITY))
		return

	var/list/affected_list = turbulence_sort_affected()

	for(var/mob/living/affected_mob as anything in affected_list["mobs"])
		to_chat(affected_mob, SPAN_DANGER("The dropship jolts violently!"))
		shake_camera(affected_mob, DROPSHIP_TURBULENCE_PERIOD / 3, 1)
		if(!affected_mob.buckled && affected_mob.body_position == STANDING_UP && affected_mob.m_intent == MOVE_INTENT_RUN)
			if(!prob(DROPSHIP_TURBULENCE_GRIPLOSS_PROBABILITY))
				continue
			to_chat(affected_mob, SPAN_DANGER("You lose your grip!"))
			affected_mob.apply_armoured_damage(50, ARMOR_MELEE, BRUTE, rand_zone())
			affected_mob.KnockDown(DROPSHIP_TURBULENCE_PERIOD * 0.1)
			if(prob(DROPSHIP_TURBULENCE_BONEBREAK_PROBABILITY) && istype(affected_mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/affected_human = affected_mob
				var/obj/limb/fracturing_limb = affected_human.get_limb(pick(ALL_LIMBS))
				fracturing_limb.fracture(100)

	turbulence_item_handle(affected_list["items"])

/obj/docking_port/mobile/marine_dropship/proc/turbulence_item_handle(affected_items) // the logic for turbulence and freefall, when handling items, is equivelant
	for(var/obj/item/affected_item as anything in affected_items)
		if(affected_item.anchored)
			continue
		affected_item.visible_message(SPAN_DANGER("[affected_item] goes flying upwards!"))
		affected_item.throwforce *= DROPSHIP_TURBULENCE_THROWFORCE_MULTIPLIER
		affected_item.throw_random_direction(2, spin = TRUE)
		affected_item.throwforce /= DROPSHIP_TURBULENCE_THROWFORCE_MULTIPLIER

/obj/docking_port/mobile/marine_dropship/proc/turbulence_sort_affected()
	// this prevents atoms from being called more than once as the proc works it way through the turfs (some may be thrown onto a turf that hasn't been called yet)
	var/list/affected_turfs = list()
	var/list/affected_mobs = list()
	var/list/affected_items = list()

	for(var/area/listed_area as anything in shuttle_areas)
		for(var/turf/affected_turf in listed_area)
			affected_turfs += affected_turf
	for(var/obj/vehicle/multitile/multitile_vehicle as anything in GLOB.all_multi_vehicles) // don't know if this is necessarily the best idea, if you spawn 100 bajillion vehicles, but in my mind it is better than asking it to search each turf for a vehicle.
		if(!multitile_vehicle.interior)
			continue
		if(!locate(multitile_vehicle.loc.loc) in shuttle_areas)
			continue
		var/list/bounds = multitile_vehicle.interior.get_bound_turfs()
		for(var/turf/affected_turf as anything in block(bounds[1], bounds[2]))
			affected_turfs += affected_turf

	for(var/turf/affected_turf as anything in affected_turfs)
		for(var/mob/living/M in affected_turf)
			affected_mobs += M
		for(var/obj/item/I in affected_turf)
			affected_items += I
	return list("mobs" = affected_mobs, "items" = affected_items)

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	dwidth = 5
	dheight = 10

	var/list/landing_lights = list()
	var/auto_open = FALSE
	var/landing_lights_on = FALSE
	var/xeno_announce = FALSE
	var/faction = FACTION_MARINE

/obj/docking_port/stationary/marine_dropship/Initialize(mapload)
	. = ..()
	link_landing_lights()

/obj/docking_port/stationary/marine_dropship/Destroy()
	. = ..()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.linked_port = null
	if(landing_lights)
		landing_lights.Cut()
	landing_lights = null // We didn't make them, so lets leave them
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/flight_console in GLOB.machines)
		flight_console.compatible_landing_zones -= src

/obj/docking_port/stationary/marine_dropship/proc/link_landing_lights()
	var/list/coords = return_coords()
	var/scan_range = 5
	var/x0 = coords[1] - scan_range
	var/y0 = coords[2] - scan_range
	var/x1 = coords[3] + scan_range
	var/y1 = coords[4] + scan_range

	for(var/xscan = x0; xscan < x1; xscan++)
		for(var/yscan = y0; yscan < y1; yscan++)
			var/turf/searchspot = locate(xscan, yscan, src.z)
			for(var/obj/structure/machinery/landinglight/light in searchspot)
				landing_lights += light
				light.linked_port = src

/obj/docking_port/stationary/marine_dropship/proc/turn_on_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_on()
	landing_lights_on = TRUE

/obj/docking_port/stationary/marine_dropship/proc/turn_off_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_off()
	landing_lights_on = FALSE

/obj/docking_port/stationary/marine_dropship/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_off_landing_lights()
	var/obj/docking_port/mobile/marine_dropship/dropship = arriving_shuttle

	if(auto_open && istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		dropship.in_flyby = FALSE
		dropship.control_doors("unlock", "all", force=FALSE)
		var/obj/structure/machinery/computer/shuttle/dropship/flight/console = dropship.getControlConsole()
		console?.update_equipment()
	if(is_ground_level(z) && !SSobjectives.first_drop_complete)
		SSticker.mode.ds_first_landed(src)
		SSticker.mode.flags_round_type |= MODE_DS_LANDED

	if(xeno_announce)
		xeno_announcement(SPAN_XENOANNOUNCE("The dropship has landed."), "everything")
		xeno_announce = FALSE

	for(var/obj/structure/dropship_equipment/eq as anything in dropship.equipments)
		eq.on_arrival()

/obj/docking_port/stationary/marine_dropship/on_dock_ignition(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_off_landing_lights()
	var/obj/docking_port/mobile/marine_dropship/dropship = departing_shuttle
	for(var/obj/structure/dropship_equipment/eq as anything in dropship.equipments)
		eq.on_launch()

/obj/docking_port/stationary/marine_dropship/lz1
	name = "LZ1 Landing Zone"
	id = DROPSHIP_LZ1
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/lz2
	name = "LZ2 Landing Zone"
	id = DROPSHIP_LZ2
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/almayer_hangar_1
	name = "Almayer Hangar bay 1"
	id = ALMAYER_DROPSHIP_LZ1
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/almayer_hangar_2
	name = "Almayer Hangar bay 2"
	id = ALMAYER_DROPSHIP_LZ2
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/normandy

/obj/docking_port/stationary/marine_dropship/upp/hangar_1
	name = "Rostock Hangar bay 1"
	id = UPP_DROPSHIP_LZ1
	faction = "UPP"
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/morana

/obj/docking_port/stationary/marine_dropship/upp/hangar_2
	name = "Rostock Hangar bay 2"
	id = UPP_DROPSHIP_LZ2
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/devana

/obj/docking_port/stationary/marine_dropship/crash_site
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/crash_site/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/ds = arriving_shuttle
		ds.hijack.crash_landing()

/obj/docking_port/stationary/marine_dropship/crash_site/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	arriving_shuttle.set_mode(SHUTTLE_CRASHED)
	for(var/mob/living/carbon/affected_mob in (GLOB.alive_human_list + GLOB.living_xeno_list)) //knock down mobs
		if(affected_mob.z != z)
			continue
		if(affected_mob.buckled)
			to_chat(affected_mob, SPAN_WARNING("You are jolted against [affected_mob.buckled]!"))
			// shake_camera(affected_mob, 3, 1)
		else
			to_chat(affected_mob, SPAN_WARNING("The floor jolts under your feet!"))
			// shake_camera(affected_mob, 10, 1)
			affected_mob.apply_effect(3, WEAKEN)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HIJACK_LANDED)

/obj/docking_port/stationary/marine_dropship/upp
	faction = FACTION_UPP

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = DROPSHIP_ALAMO

/datum/map_template/shuttle/normandy
	name = "Normandy"
	shuttle_id = DROPSHIP_NORMANDY

/datum/map_template/shuttle/saipan
	name = "Saipan"
	shuttle_id = DROPSHIP_SAIPAN

/datum/map_template/shuttle/morana
	name = "Morana"
	shuttle_id = DROPSHIP_MORANA

/datum/map_template/shuttle/devana
	name = "Devana"
	shuttle_id = DROPSHIP_DEVANA


