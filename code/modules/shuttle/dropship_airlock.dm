/* Note on new/custom dropship airlocks:
All you really need to spawn in on strongdmm is the inner dock port, the outer dock port, the floodlights, and the frame tiles. you can also spawn in the dropship_airlock poddoors and door_controls
if you like. It is encouraged you do not make them instances. Bear in mind you will have to change the dropship_airlock_id s (in the case of dockports) and linked_inner_dock_port_id s (in the case
of floodlights, poddoors and door_controls) to all be the same if you want them to a part of the same 'airlock'. Please make sure the frame tiles are in the correct order. If you are unsure what
that order is, refer to already-made airlocks.
*/

GLOBAL_LIST_EMPTY(dropship_airlock_docking_ports)

/*#############################################################################
Docking Port Definitions
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner
	var/dropship_airlock_id = "generic" // id that links it to outer, and objs.

	// variables changed during the process of using the airlock, changed once its related proc is complete.
	var/disable_manual_input = FALSE // mostly for hijack
	var/processing = FALSE // TRUE whilst the user interface procs and timer-induced procs are running
	var/playing_airlock_alarm = FALSE
	var/open_inner_airlock = FALSE
	var/lowered_dropship = FALSE
	var/open_outer_airlock = FALSE
	var/disengaged_clamps = FALSE

	var/obj/docking_port/stationary/marine_dropship/airlock/outer/linked_outer // the other, mostly normal, dock port. needs to be spawned manually and given the same dropship_airlock_id
	var/obj/effect/hangar_airlock/inner/inner_airlock_effect // the actual effect itself, contains the icon_state for the inner airlock, generated on late initialize
	var/obj/effect/hangar_airlock/outer/outer_airlock_effect // the actual effect itself, contains the icon_state for the outer airlock, generated on late initialize

	var/list/dropship_height_masks = null // all height masks that may need to be deleted/changed with the altitude of the dropship, generated on inner on_arrival()
	var/list/inner_airlock_turfs = null // self-explanatory, the list is populated on get_inner_airlock_turfs()
	var/list/outer_airlock_turfs = null // self-explanatory, the list is populated on get_outer_airlock_turfs()

	// all /dropship_airlock/ objects with the dropship_airlock_id for its linked_inner_dropship_airlock_id, need to be spawned manually and given the correct id.
	var/list/floodlights = null
	var/list/door_controls = null
	var/list/poddoors = null

	var/obj/docking_port/mobile/marine_dropship/docked_mobile = null // not a regularly updated variable
	var/automatic_process_stage_change = 0
	var/automatic_process_stage = FALSE
	COOLDOWN_DECLARE(dropship_airlock_cooldown)
	auto_open = TRUE // for dropship doors

/obj/docking_port/stationary/marine_dropship/airlock/inner/almayer_one
	name = "Almayer Hangar Airlock 1 Inner"
	id = ALMAYER_A1_INNER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_ONE
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/airlock/inner/almayer__two
	name = "Almayer Hangar Airlock 2 Inner"
	id = ALMAYER_A2_INNER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO
	roundstart_template = /datum/map_template/shuttle/normandy

/obj/docking_port/stationary/marine_dropship/airlock/outer
	name = "Hangar Airlock Outer"
	id = GENERIC_A_O
	var/obj/docking_port/stationary/marine_dropship/airlock/inner/linked_inner
	var/dropship_airlock_id = "generic"

/obj/docking_port/stationary/marine_dropship/airlock/outer/almayer_one
	name = "Almayer Hangar Airlock 1 Outer"
	id = ALMAYER_A1_OUTER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO

/obj/docking_port/stationary/marine_dropship/airlock/outer/almayer_two
	name = "Almayer Hangar Airlock 2 Outer"
	id = ALMAYER_A2_OUTER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO

/*#############################################################################
Player Interactablility Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/update_airlock_alarm(play = playing_airlock_alarm, forced = FALSE)
	. = list("successful" = FALSE, "to_chat" = "ERROR. DROPSHIP AIRLOCK ALARM NOT FUNCTIONING. FILE A BUG REPORT.")
	if(play == playing_airlock_alarm)
		end_of_interaction()
		.["successful"] = TRUE
		return
	if(!forced)
		if(processing && !automatic_process_stage_change)
			.["to_chat"] = "The computer is already processing a command to the airlock."
			return
		if(open_outer_airlock)
			.["to_chat"] = "The airlock alarm cannot be engaged while the outer airlock is open."
			return
		if(open_inner_airlock)
			.["to_chat"] = "The airlock alarm cannot be engaged while the inner airlock is open."
			return

	processing = TRUE
	if(!inner_airlock_turfs)
		get_inner_airlock_turfs()
	if(!outer_airlock_turfs)
		linked_outer.get_outer_airlock_turfs()
	var/obj/structure/machinery/floodlight/landing/dropship_airlock/floodlight
	var/floodlight_increment = 1
	for(floodlight as anything in floodlights)
		addtimer(CALLBACK(floodlight, TYPE_PROC_REF(/obj/structure/machinery/floodlight/landing/dropship_airlock, toggle_rotating)), DROPSHIP_AIRLOCK_FLOODLIGHT_TRANSITION * floodlight_increment)
		floodlight_increment += 1
	addtimer(CALLBACK(src, PROC_REF(delayed_airlock_alarm)), DROPSHIP_AIRLOCK_FLOODLIGHT_TRANSITION * floodlight_increment)
	.["to_chat"] = play ? "Beginning rotation of airlock caution lights." : "Ending rotation of airlock caution lights."
	playing_airlock_alarm = play
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/update_inner_airlock(open = open_inner_airlock, forced = FALSE)
	. = list("successful" = FALSE, "to_chat" = "ERROR. DROPSHIP AIRLOCK INNER NOT FUNCTIONING. FILE A BUG REPORT.")
	if(open == open_inner_airlock)
		end_of_interaction()
		.["successful"] = TRUE
		return
	if(!forced)
		if(processing && !automatic_process_stage_change)
			.["to_chat"] = "The computer is already processing a command to the airlock."
			return
		if(open_outer_airlock)
			.["to_chat"] = "The inner airlock cannot be engaged while the outer airlock is open."
			return
		if(!playing_airlock_alarm)
			.["to_chat"] = "The inner airlock can only be engaged when the airlock alarm is playing."
			return

	processing = TRUE
	if(!inner_airlock_turfs)
		get_inner_airlock_turfs()
	if(open)
		SSfz_transitions.toggle_selective_update(open, dropship_airlock_id) // start updating the projectors
		linked_outer.handle_obscuring_shuttle_turfs()
		omnibus_airlock_transition("inner", TRUE, inner_airlock_turfs, inner_airlock_effect, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		.["to_chat"] = "Opening inner airlock."
	else
		omnibus_airlock_transition("inner", FALSE, inner_airlock_turfs, inner_airlock_effect, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		addtimer(CALLBACK(SSfz_transitions, TYPE_PROC_REF(/datum/controller/subsystem/fz_transitions, toggle_selective_update), open, dropship_airlock_id), DROPSHIP_AIRLOCK_DOOR_PERIOD)
		SSfz_transitions.toggle_selective_update(!open_inner_airlock, dropship_airlock_id) // stop updating the projectors
		.["to_chat"] = "Closing inner airlock."
	open_inner_airlock = open
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/update_dropship_height(lower = lowered_dropship, forced = FALSE)
	. = list("successful" = FALSE, "to_chat" = "ERROR. DROPSHIP AIRLOCK HEIGHT CHANGE NOT FUNCTIONING. FILE A BUG REPORT.")
	if(lower == lowered_dropship)
		end_of_interaction()
		.["successful"] = TRUE
		return
	if(!forced)
		if(processing && !automatic_process_stage_change)
			.["to_chat"] = "The computer is already processing a command to the airlock."
			return
		if(!open_inner_airlock)
			.["to_chat"] = "The inner airlock must be open for the mechanism to change the dropship altitude."
			return

	if(lower)
		docked_mobile = get_docked()
		if(linked_outer.get_docked())
			.["to_chat"] = "Cannot lower the dropship while there is another dropship in the airlock."
			return
	else
		docked_mobile = linked_outer.get_docked()
		if(get_docked())
			.["to_chat"] = "Cannot raise the dropship while there is another dropship ontop of the airlock."
			return
	if(!docked_mobile)
		.["to_chat"] = "ERROR. UNEXPECTED ATTEMPT TO CHANGE DROPSHIP AIRLOCK HEIGHT. FILE A BUG REPORT."
		return
	if(!inner_airlock_turfs)
		get_inner_airlock_turfs()
	if(!outer_airlock_turfs)
		linked_outer.get_outer_airlock_turfs()

	processing = TRUE
	omnibus_sound_play(lowered_dropship ? 'sound/machines/asrs_lowering.ogg' : 'sound/machines/asrs_raising.ogg')
	if(lower)
		COOLDOWN_START(src, dropship_airlock_cooldown, DROPSHIP_AIRLOCK_HEIGHT_TRANSITION)
		delayed_height_decrease()
		.["to_chat"] = "Lowering dropship into the airlock."
	else
		addtimer(CALLBACK(src, PROC_REF(delayed_height_increase)), DROPSHIP_AIRLOCK_HEIGHT_TRANSITION)
		.["to_chat"] = "Raising dropship from the airlock."
	lowered_dropship = lower
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/update_outer_airlock(open = open_outer_airlock, forced = FALSE)
	. = list("successful" = FALSE, "to_chat" = "ERROR. DROPSHIP AIRLOCK OUTER NOT FUNCTIONING. FILE A BUG REPORT.")
	if(open == open_outer_airlock)
		end_of_interaction()
		.["successful"] = TRUE
		return
	if(!forced)
		if(processing && !automatic_process_stage_change)
			.["to_chat"] = "The computer is already processing a command to the airlock."
			return
		if(open_inner_airlock)
			.["to_chat"] = "Cannot engage the outer airlock while the inner airlock is open."
			return
		if(playing_airlock_alarm)
			.["to_chat"] = "Cannot engage the outer airlock while the airlock alarm is playing."
			return
		if(disengaged_clamps)
			.["to_chat"] = "Cannot engage the outer airlock without the dropship resting securely on its clamps."
			return

	processing = TRUE
	if(!outer_airlock_turfs)
		linked_outer.get_outer_airlock_turfs()
	if(open)
		for(var/obj/structure/machinery/door/poddoor/almayer/airlock/poddoor as anything in poddoors)
			poddoor.close()
		omnibus_airlock_transition("outer", TRUE, outer_airlock_turfs, outer_airlock_effect, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		if(!registered)
			linked_outer.register(TRUE)
		.["to_chat"] = "Opening outer airlock."
	else
		omnibus_airlock_transition("outer", FALSE, outer_airlock_turfs, outer_airlock_effect, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		if(registered)
			linked_outer.unregister()
		.["to_chat"] = "Closing outer airlock."
	open_outer_airlock = open
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/update_clamps(disengage = disengaged_clamps, forced = FALSE)
	. = list("successful" = FALSE, "to_chat" = "ERROR. DROPSHIP AIRLOCK CLAMPS NOT FUNCTIONING. FILE A BUG REPORT.")
	docked_mobile = linked_outer.get_docked()
	if(disengage == disengaged_clamps)
		end_of_interaction()
		.["successful"] = TRUE
		return
	if(!docked_mobile)
		.["to_chat"] = "No dropship for the clamps to disengage with."
		return
	if(!forced)
		if(processing && !automatic_process_stage_change)
			.["to_chat"] = "The computer is already processing a command to the airlock."
			return
		if(!open_outer_airlock)
			.["to_chat"] = "The clamps can only be disengaged when the outer airlock is open."
			return
		if(!lowered_dropship)
			.["to_chat"] = "The clamps can only be disengaged when the dropship is lowered."
			return
		if(docked_mobile.mode == SHUTTLE_RECHARGING)
			.["to_chat"] = "The dropship is still recharging. It would be suicide to have it fly into a grav well without proper engine control."
			return

	processing = TRUE
	if(disengage)
		playsound(docked_mobile.return_center_turf(), 'sound/effects/dropship_flight_airlocked_start.ogg', 100, sound_range = docked_mobile.dheight, vol_cat = VOLUME_SFX, channel = SOUND_CHANNEL_DROPSHIP)
		addtimer(CALLBACK(src, PROC_REF(delayed_disengage_clamps), docked_mobile), DROPSHIP_AIRLOCK_DECLAMP_PERIOD)
		.["to_chat"] = "Disengaging clamps."
	else
		.["to_chat"] = "Engaging clamps."
	disengaged_clamps = disengage
	.["successful"] = TRUE

/*#############################################################################
Backend Timer Delayed/Looping Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_airlock_alarm()
	docked_mobile = get_docked()
	if(docked_mobile)
		docked_mobile.door_control.control_doors(playing_airlock_alarm ? "lock" : "unlock", "all")
	end_of_interaction()

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_airlock_transition(airlock_type, open, airlock_turfs, obj/effect/hangar_airlock/airlock, end_decisecond, transition)
	if(COOLDOWN_FINISHED(src, dropship_airlock_cooldown))
		airlock.icon_state = "[transition]"
		end_of_interaction()
		return
	var/decisecond = (end_decisecond - COOLDOWN_TIMELEFT(src, dropship_airlock_cooldown))
	if(!(decisecond % 10))
		if(decisecond != end_decisecond)
			airlock.icon_state = "[transition]_[decisecond * 0.1]s"
	for(var/turf/open/floor/hangar_airlock/T in airlock_turfs)
		if(decisecond == T.frame_threshold)
			T.open = open
			for(var/atom/movable/AM in T.contents)
				if(!AM.anchored)
					T.Entered(AM)
			T.clean_cleanables()
			T.can_bloody = !open
	INVOKE_NEXT_TICK(src, PROC_REF(delayed_airlock_transition), airlock_type, open, airlock_turfs, airlock, end_decisecond, transition)

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_height_decrease()
	if(COOLDOWN_FINISHED(src, dropship_airlock_cooldown))
		docked_mobile.initiate_docking(linked_outer)
		for(var/obj/effect/hangar_airlock/height_mask/qdeling_height_mask as anything in dropship_height_masks)
			dropship_height_masks -= qdeling_height_mask
			qdel(qdeling_height_mask)
		end_of_interaction()
		return
	var/alpha_reiteration = (DROPSHIP_AIRLOCK_HEIGHT_TRANSITION - COOLDOWN_TIMELEFT(src, dropship_airlock_cooldown)) * 2
	for(var/obj/effect/hangar_airlock/height_mask/dropship/transitioning_height_mask as anything in dropship_height_masks)
		transitioning_height_mask.alpha = alpha_reiteration
	INVOKE_NEXT_TICK(src, PROC_REF(delayed_height_decrease))

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_height_increase()
	docked_mobile.initiate_docking(src)
	end_of_interaction()

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_disengage_clamps()
	if(!docked_mobile.assigned_transit)
		SSshuttle.generate_transit_dock(docked_mobile)
	docked_mobile.set_mode(SHUTTLE_IDLE)
	docked_mobile.initiate_docking(docked_mobile.assigned_transit)
	INVOKE_NEXT_TICK(docked_mobile, TYPE_PROC_REF(/obj/docking_port/mobile/marine_dropship, dropship_freefall))
	end_of_interaction()

/*#############################################################################
New Backend Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/get_inner_airlock_turfs()
	inner_airlock_turfs = list()
	for(var/turf/turf as anything in block(DROPSHIP_AIRLOCK_BOUNDS))
		if(!istype(turf, /turf/open/floor/hangar_airlock/inner) && !istype(turf, /turf/open/shuttle) && !istype(turf, /turf/closed/shuttle))
			continue
		new /obj/effect/hangar_airlock/height_mask(turf)
		inner_airlock_turfs += turf

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/omnibus_airlock_transition(airlock_type, open, airlock_turfs, obj/effect/hangar_airlock/airlock, end_decisecond)
	var/transition = open ? "open" : "close"
	airlock.icon_state = "[transition]_0s"

	omnibus_sound_play('sound/machines/centrifuge.ogg')

	COOLDOWN_START(src, dropship_airlock_cooldown, end_decisecond)
	INVOKE_NEXT_TICK(src, PROC_REF(delayed_airlock_transition), airlock_type, open, airlock_turfs, airlock, end_decisecond, transition)

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/omnibus_sound_play(sound_effect)
	playsound(src, sound_effect, 100, vol_cat = VOLUME_AMB)
	playsound(linked_outer, sound_effect, 100, vol_cat = VOLUME_AMB)

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/end_of_interaction()
	COOLDOWN_RESET(src, dropship_airlock_cooldown)
	if(automatic_process_stage_change)
		addtimer(CALLBACK(src, PROC_REF(automatic_process)), DROPSHIP_AIRLOCK_AUTOMATIC_DELAY)
		return
	if(!disable_manual_input)
		processing = FALSE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/test_conditions(test_alarm = null, test_inner = null, test_height = null, test_outer = null, test_clamps = null)
	if(test_alarm != null && test_alarm != playing_airlock_alarm)
		return FALSE
	if(test_inner != null && test_inner != open_inner_airlock)
		return FALSE
	if(test_height != null && test_height != lowered_dropship)
		return FALSE
	if(test_outer != null && test_outer != open_outer_airlock)
		return FALSE
	if(test_clamps != null && test_clamps != disengaged_clamps)
		return FALSE
	return TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/automatic_process(command = FALSE)
	if(automatic_process_stage_change && command)
		return list("successful" = FALSE, "to_chat" = "A second command has been sent before the first one was resolved.")
	switch(command)
		if(DROPSHIP_AIRLOCK_GO_UP)
			automatic_process_stage = 2
			automatic_process_stage_change = 1
		if(DROPSHIP_AIRLOCK_GO_DOWN)
			automatic_process_stage = 8
			automatic_process_stage_change = -1
	var/list/return_list
	switch(automatic_process_stage)
		if(9) // going up cleanup
			automatic_process_stage_change = 0
			automatic_process_stage = 0
			processing = FALSE
		if(8)
			return_list = update_outer_airlock(FALSE)
		if(7)
			return_list = update_airlock_alarm(playing_airlock_alarm ? FALSE : TRUE)
		if(6)
			return_list = update_inner_airlock(open_inner_airlock ? FALSE : TRUE)
		if(5)
			return_list = update_dropship_height(lowered_dropship ? FALSE : TRUE)
		if(4)
			return_list = update_inner_airlock(open_inner_airlock ? FALSE : TRUE)
		if(3)
			return_list = update_airlock_alarm(playing_airlock_alarm ? FALSE : TRUE)
		if(2)
			return_list = update_outer_airlock(open_outer_airlock ? FALSE : TRUE)
		if(1) // going down cleanup
			automatic_process_stage_change = 0
			automatic_process_stage = 0
			processing = FALSE
			return_list = update_clamps(TRUE)
		if(0) // no command
			return
	if(return_list)
		. = return_list
		if(!return_list["successful"])
			log_ares_flight("Automatic","Automatic processing of \the [name] has been interrupted because [lowertext(return_list["to_chat"])]")
			ai_silent_announcement("Automatic processing on \the [name] has been interrupted because [lowertext(return_list["to_chat"])]")
			automatic_process_stage_change = 0
			automatic_process_stage = 0
			processing = FALSE
			return
	automatic_process_stage += automatic_process_stage_change

/obj/docking_port/stationary/marine_dropship/airlock/outer/proc/handle_obscuring_shuttle_turfs()
	for(var/turf/open/shuttle/shuttle_turf in block(DROPSHIP_AIRLOCK_BOUNDS))
		if(shuttle_turf.clone)
			shuttle_turf.clone.layer = 1.93
			shuttle_turf.clone.color = "#000000"

/obj/docking_port/stationary/marine_dropship/airlock/outer/proc/get_outer_airlock_turfs()
	linked_inner.outer_airlock_turfs = list()
	var/list/offset_to_inner_coordinates = list("x" = (linked_inner.x - src.x), "y" = (linked_inner.y - src.y), "z" = (linked_inner.z - src.z))
	for(var/turf/turf as anything in block(DROPSHIP_AIRLOCK_BOUNDS))
		if(!istype(turf, /turf/open/floor/hangar_airlock/outer) && !istype(turf, /turf/open/shuttle) && !istype(turf, /turf/closed/shuttle))
			continue
		linked_inner.outer_airlock_turfs += turf
		if(locate(/obj/effect/projector/airlock) in turf.contents)
			continue
		var/obj/effect/projector/airlock/new_projector = new /obj/effect/projector/airlock(turf)
		new_projector.firing_id = dropship_airlock_id
		new_projector.vector_x = offset_to_inner_coordinates["x"]
		new_projector.vector_y = offset_to_inner_coordinates["y"]

/*#############################################################################
. = ..() Backend Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/Initialize(mapload)
	. = ..()
	GLOB.dropship_airlock_docking_ports.Add(src)
	dropship_height_masks = list()
	floodlights = list()
	door_controls = list()
	poddoors = list()
	inner_airlock_effect = new /obj/effect/hangar_airlock/inner(locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECT))
	new /obj/effect/hangar_airlock/outline(locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECT))
	if(!roundstart_template)
		unregister()

/obj/docking_port/stationary/marine_dropship/airlock/inner/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(registered)
		unregister()
	auto_open = FALSE // when the dropship that is originally loaded is auto_opened, any further landing dropships will have people onboard to decide to whether or not they want the doors open (which stops people charging out the opened doors when the airlock is open)
	var/list/dropship_turfs = arriving_shuttle.return_turfs()
	for(var/turf/dropship_turf as anything in dropship_turfs)
		if(istype(dropship_turf, /turf/open/shuttle) || istype(dropship_turf, /turf/closed/shuttle))
			var/obj/effect/hangar_airlock/height_mask/dropship/dropship_height_mask = new /obj/effect/hangar_airlock/height_mask/dropship(dropship_turf)
			dropship_height_masks += dropship_height_mask
			continue
		if(istype(dropship_turf, /turf/open/floor/hangar_airlock/inner))
			var/obj/structure/shuttle/part/dropship_part = locate(/obj/structure/shuttle/part) in dropship_turf.contents
			if(!dropship_part)
				continue
			var/obj/effect/hangar_airlock/height_mask/dropship/dropship_part_height_mask = new /obj/effect/hangar_airlock/height_mask/dropship(dropship_turf)
			dropship_part_height_mask.icon = dropship_part.icon
			dropship_part_height_mask.icon_state = dropship_part.icon_state
			dropship_part_height_mask.color = "#000000"
			dropship_height_masks += dropship_part_height_mask

/obj/docking_port/stationary/marine_dropship/airlock/outer/Initialize(mapload)
	. = ..()
	GLOB.dropship_airlock_docking_ports.Add(src)
	return INITIALIZE_HINT_LATELOAD

/obj/docking_port/stationary/marine_dropship/airlock/outer/LateInitialize()
	. = ..()
	for(var/obj/docking_port/stationary/marine_dropship/airlock/inner/inner_port in GLOB.dropship_airlock_docking_ports)
		if(inner_port.dropship_airlock_id == dropship_airlock_id)
			linked_inner = inner_port
	if(!linked_inner)
		WARNING("[name] could not link to its inner counterpart. THE AIRLOCK WILL NOT WORK.")
		return
	linked_inner.linked_outer = src
	var/turf/airlock_effect_turf = locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECT)
	linked_inner.outer_airlock_effect = new /obj/effect/hangar_airlock/outer(airlock_effect_turf)
	var/obj/effect/projector/airlock/new_projector = new /obj/effect/projector/airlock(airlock_effect_turf)
	new_projector.firing_id = dropship_airlock_id
	new_projector.vector_x = linked_inner.x - src.x
	new_projector.vector_y = linked_inner.y - src.y
	if(linked_inner.roundstart_template)
		unregister()
	else
		INVOKE_NEXT_TICK(linked_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_outer_airlock), TRUE)

/obj/docking_port/stationary/marine_dropship/airlock/outer/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(registered)
		unregister()
	linked_inner.disengaged_clamps = FALSE
	linked_inner.lowered_dropship = TRUE
	SSfz_transitions.fire()
	handle_obscuring_shuttle_turfs()
	if(!istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		return
	var/obj/docking_port/mobile/marine_dropship/arriving_dropship = arriving_shuttle
	if((src == arriving_dropship.automated_hangar || src == arriving_dropship.automated_lz) && arriving_dropship.automated_delay && !linked_inner.processing)
		linked_inner.automatic_process(DROPSHIP_AIRLOCK_GO_UP)

/*#############################################################################
Airlock Appearance Effects
#############################################################################*/

/obj/effect/hangar_airlock
	layer = ABOVE_TURF_LAYER
	plane = FLOOR_PLANE
	unacidable = TRUE
	mouse_opacity = FALSE
	anchored = TRUE

// we typically don't want them moving
/obj/effect/hangar_airlock/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!anchored)
		. = ..()
	return TRUE

/obj/effect/hangar_airlock/inner
	name = "hangar inner airlock"
	icon = 'icons/effects/airlock_inner.dmi'
	icon_state = "close"
	layer = 1.95

/obj/effect/hangar_airlock/outer
	name = "hangar outer airlock"
	icon = 'icons/effects/airlock_outer.dmi'
	icon_state = "close"
	layer = 1.95

/obj/effect/hangar_airlock/outline
	icon = 'icons/effects/airlock_outline.dmi'
	icon_state = "outline"

/obj/effect/hangar_airlock/half_tile
	icon = 'icons/effects/airlock_32x32.dmi'
	icon_state = "half_tile"

/obj/effect/hangar_airlock/height_mask
	icon = 'icons/effects/airlock_32x32.dmi'
	icon_state = "height_mask"
	layer = 1.94
	alpha = 135
	plane = -7

/obj/effect/hangar_airlock/height_mask/dropship
	layer = 5.01
	alpha = 0
	plane = -6

/*#############################################################################
Airlock Turfs Definitions
#############################################################################*/

/turf/open/floor/hangar_airlock
	hull_floor = TRUE
	breakable_tile = FALSE
	burnable_tile = FALSE
	tool_flags = null
	layer = 1.5
	var/frame_threshold = null // to tie the turf opening and the airlock animation together, the frame on which a tile can be considered 'open' or 'closed' has to be done manually.
	var/open = FALSE // ^

/turf/open/floor/hangar_airlock/outer
	name = "Hangar Outer Airlock"
	icon = 'icons/turf/floors/dev/dev_airlock.dmi'
	icon_state = "0"

/turf/open/floor/hangar_airlock/outer/Initialize(mapload, ...)
	. = ..()
	icon = 'icons/turf/floors/space.dmi'
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/open/floor/hangar_airlock/inner
	name = "Hangar Inner Airlock"
	icon = 'icons/turf/floors/dev/dev_airlock.dmi'
	icon_state = "plate"

/turf/open/floor/hangar_airlock/inner/Initialize(mapload, ...)
	. = ..()
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plate"

/*#############################################################################
Airlock Turf Interactability Procs
#############################################################################*/

/turf/open/floor/hangar_airlock/Entered(atom/movable/AM)
	if(open)
		if(!isobserver(AM) && !istype(AM, /obj/docking_port) && !istype(AM, /atom/movable/clone) && !istype(AM, /obj/effect/hangar_airlock))
			enter_depths(AM)

/turf/open/floor/hangar_airlock/proc/enter_depths(/atom/movable/AM)
	return

/turf/open/floor/hangar_airlock/inner/enter_depths(atom/movable/AM)
	if(AM.throwing == 0)
		AM.visible_message(SPAN_WARNING("[AM] falls into the depths!"), SPAN_WARNING("You fall into the depths!"))
		for(var/A in src.contents)
			if(istype(A, /atom/movable/clone))
				var/atom/movable/clone/C = A
				// why not just use .loc? well, because of /atom/movable/clone facsimile 'turfs', it is potentially the case that we'd locate an area (from the mstr turf of the facsimile) when we just want the exact turf.
				if(istype(get_turf(AM), /turf/open/floor/hangar_airlock))
					AM.forceMove(locate(C.mstr.x, C.mstr.y, C.mstr.z))
					break

				var/obj/structure/shuttle/part/dropship_part_to_locate
				dropship_part_to_locate = locate(/obj/structure/shuttle/part) in orange(8)
				if(dropship_part_to_locate) // presumably, shuttle parts are on the outside skin of a dropship.
					AM.forceMove(dropship_part_to_locate.loc)
					AM.visible_message(SPAN_WARNING("[AM] slides off the roof of the dropship!"), SPAN_WARNING("You slide off the roof of the dropship!"))
					break

				AM.visible_message(SPAN_WARNING("[AM] falls onto the engines of the dropship, burning into ash!"), SPAN_WARNING("You fall onto the engines of the dropship, burning into ash!"))
				qdel(AM)
				break

		if(!isliving(AM))
			return
		var/mob/living/fallen_living = AM
		shake_camera(fallen_living, 20, 1)
		fallen_living.apply_effect(3, WEAKEN)
		fallen_living.apply_damage(75, BRUTE, pick("r_leg", "l_leg", "r_arm", "l_arm", "chest", "head"))

/turf/open/floor/hangar_airlock/outer/enter_depths(atom/movable/AM)
	if(AM.throwing == 0 && istype(get_turf(AM), /turf/open/floor/hangar_airlock))
		AM.visible_message(SPAN_WARNING("There is an onrush of air. [AM] falls into space!"), SPAN_WARNING("There is an onrush of air. You fall into space!"))
		qdel(AM)

/*#############################################################################
Turf Definitions From Instances
#############################################################################*/

/turf/open/floor/almayer/plate/hangar_1
	icon_state = "hangar_1"
	name = "Hangar Airlock One"

/turf/open/floor/almayer/plate/hangar_2
	icon_state = "hangar_2"
	name = "Hangar Airlock Two"

/turf/open/floor/hangar_airlock/inner/frame5
	frame_threshold = 5
	icon_state = "5" // for strongdmm

/turf/open/floor/hangar_airlock/inner/frame9
	frame_threshold = 9
	icon_state = "9"

/turf/open/floor/hangar_airlock/inner/frame11
	frame_threshold = 11
	icon_state = "11"

/turf/open/floor/hangar_airlock/inner/frame13
	frame_threshold = 13
	icon_state = "13"

/turf/open/floor/hangar_airlock/inner/frame17
	frame_threshold = 17
	icon_state = "17"

/turf/open/floor/hangar_airlock/inner/frame21
	frame_threshold = 21
	icon_state = "21"

/turf/open/floor/hangar_airlock/inner/frame25
	frame_threshold = 25
	icon_state = "25"

/turf/open/floor/hangar_airlock/inner/frame30
	frame_threshold = 30
	icon_state = "30"

/turf/open/floor/hangar_airlock/inner/frame33
	frame_threshold = 33
	icon_state = "33"

/turf/open/floor/hangar_airlock/inner/frame35
	frame_threshold = 35
	icon_state = "35"

/turf/open/floor/hangar_airlock/inner/frame40
	frame_threshold = 40
	icon_state = "40"

/turf/open/floor/hangar_airlock/inner/frame49
	frame_threshold = 49
	icon_state = "49"

/turf/open/floor/hangar_airlock/outer/frame4
	frame_threshold = 4
	icon_state = "_4"

/turf/open/floor/hangar_airlock/outer/frame11
	frame_threshold = 11
	icon_state = "_11"

/turf/open/floor/hangar_airlock/outer/frame19
	frame_threshold = 19
	icon_state = "_19"

/turf/open/floor/hangar_airlock/outer/frame27
	frame_threshold = 27
	icon_state = "_27"

/turf/open/floor/hangar_airlock/outer/frame35
	frame_threshold = 35
	icon_state = "_35"

/turf/open/floor/hangar_airlock/outer/frame43
	frame_threshold = 43
	icon_state = "_43"

/turf/open/floor/hangar_airlock/outer/frame49
	frame_threshold = 49
	icon_state = "_49"
