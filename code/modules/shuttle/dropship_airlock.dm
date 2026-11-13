/* Note on new/custom dropship airlocks:
All you really need to spawn in on strongdmm is the inner dock port, the outer dock port, the floodlights, and the frame tiles. you can also spawn in the dropship_airlock *pod*doors and door_controls
if you like. It is encouraged you do not make them instances. Bear in mind you will have to change the dropship_airlock_id s (in the case of dockports) and linked_inner_dock_port_id s (in the case
of floodlights, poddoors and door_controls) to all be the same if you want them to a part of the same 'airlock'. Please make sure the frame tiles are in the correct order. If you are unsure what
that order is, refer to already-made airlocks.
*/

GLOBAL_LIST_EMPTY(dropship_airlock_docking_ports)

/*#############################################################################
Docking Port Definitions
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner
	/// The id that links the inner airlock to the outer airlock and other objects.
	var/dropship_airlock_id = "generic"

	// variables changed during the process of using the airlock, changed once its related proc is complete.
	var/playing_airlock_alarm = FALSE
	var/open_inner_airlock = FALSE
	var/lowered_dropship = FALSE
	var/open_outer_airlock = FALSE
	var/disengaged_clamps = FALSE

	// more special variables that are reliant upon special things
	/// Mainly a way to warn admins before they input another command to the airlock.
	var/undergoing_admin_command = FALSE
	/// Mostly for hijack, needs var/processing to be TRUE to do anything, virtually disables player manual input when FALSE.
	var/allow_processing_to_end = TRUE
	/// TRUE whilst the user interface procs and timer-induced procs of the airlock are running
	var/processing = FALSE

	/// The other, mostly normal, dock port. needs to be spawned manually and given the same dropship_airlock_id
	var/obj/docking_port/stationary/marine_dropship/airlock/outer/linked_outer
	/// The actual effect itself, contains the icon_state for the inner airlock, generated on late initialize
	// var/obj/effect/dropship_airlock/inner/inner_airlock_effect
	var/list/inner_airlock_effects

	/// All height masks that may need to be deleted/changed with the altitude of the dropship, generated on inner on_arrival()
	var/list/dropship_height_masks = null
	/// Self-explanatory, the list are populated on get_inner_airlock_turf_lists()
	var/list/inner_airlock_turf_lists = null

	// All /dropship_airlock/ objects with the dropship_airlock_id for its linked_inner_dropship_airlock_id, need to be spawned manually and given the correct id.
	var/list/floodlights = null
	var/list/door_controls = null
	var/list/poddoors = null
	var/list/railings = null

	/// NOT A REGULARLY UPDATED VARIABLE.
	var/obj/docking_port/mobile/marine_dropship/docked_mobile = null

	// For use in the autopilot system (see automatic_process)
	var/automatic_process_stage_change = 0
	var/automatic_process_stage = FALSE
	COOLDOWN_DECLARE(dropship_airlock_cooldown)

	// for use in airlock transition and living_mobs_precarity()
	var/list/precarious_living_mobs

	auto_open = TRUE // for dropship doors

/obj/docking_port/stationary/marine_dropship/airlock/inner/almayer_one
	name = "Almayer Hangar Airlock 1 Inner"
	id = ALMAYER_A1_INNER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_ONE
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/airlock/inner/almayer_two
	name = "Almayer Hangar Airlock 2 Inner"
	id = ALMAYER_A2_INNER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO
	roundstart_template = /datum/map_template/shuttle/normandy

/obj/docking_port/stationary/marine_dropship/airlock/outer
	name = "Hangar Airlock Outer"
	id = GENERIC_A_O
	var/obj/docking_port/stationary/marine_dropship/airlock/inner/linked_inner
	/// The id that links outer airlock to inner airlock (must be the same as inner's dropship_airlock_id)
	var/dropship_airlock_id = "generic"

	/// The actual effect itself, contains the icon_state for the outer airlock, generated on late initialize
	// var/obj/effect/dropship_airlock/outer/outer_airlock_effect
	var/list/outer_airlock_effects

	/// Self-explanatory, the lists are populated on get_outer_airlock_turf_lists()
	var/list/outer_airlock_turf_lists = null

/obj/docking_port/stationary/marine_dropship/airlock/outer/almayer_one
	name = "Almayer Hangar Airlock 1 Outer"
	id = ALMAYER_A1_OUTER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_ONE

/obj/docking_port/stationary/marine_dropship/airlock/outer/almayer_two
	name = "Almayer Hangar Airlock 2 Outer"
	id = ALMAYER_A2_OUTER
	dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO

/*#############################################################################
Stage Procs (ordered on things called to exit, see New Backend Procs for exceptions)
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
	if(!inner_airlock_turf_lists)
		get_inner_airlock_turf_lists()
	if(!linked_outer.outer_airlock_turf_lists)
		linked_outer.get_outer_airlock_turf_lists()
	var/obj/structure/machinery/floodlight/landing/dropship_airlock/floodlight
	var/floodlight_increment = 1
	for(floodlight as anything in floodlights)
		addtimer(CALLBACK(floodlight, TYPE_PROC_REF(/obj/structure/machinery/floodlight/landing/dropship_airlock, toggle_rotating)), DROPSHIP_AIRLOCK_FLOODLIGHT_TRANSITION * floodlight_increment)
		floodlight_increment += 1
	addtimer(CALLBACK(src, PROC_REF(delayed_airlock_alarm)), DROPSHIP_AIRLOCK_FLOODLIGHT_TRANSITION * floodlight_increment)
	.["to_chat"] = play ? "Beginning rotation of airlock caution lights." : "Ending rotation of airlock caution lights."
	playing_airlock_alarm = play
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_airlock_alarm()
	docked_mobile = get_docked()
	docked_mobile?.door_control?.control_doors(playing_airlock_alarm ? "lock" : "unlock", "all") // the only time you want it controlling doors is when there is a dropship docked on the inner port. This is a neat-ish way of doing that.

	var/obj/structure/machinery/door/poddoor/railing/airlock_railing
	if(playing_airlock_alarm)
		for(airlock_railing as anything in railings)
			airlock_railing.close(TRUE)
	else
		for(airlock_railing as anything in railings)
			airlock_railing.open(TRUE)
	end_of_interaction()

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
	if(!inner_airlock_turf_lists)
		get_inner_airlock_turf_lists()
	if(open)
		linked_outer.handle_obscuring_shuttle_turfs()
		omnibus_airlock_transition("inner", TRUE, inner_airlock_turf_lists, inner_airlock_effects, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		.["to_chat"] = "Opening inner airlock."
	else
		omnibus_airlock_transition("inner", FALSE, inner_airlock_turf_lists, inner_airlock_effects, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		.["to_chat"] = "Closing inner airlock."
	open_inner_airlock = open
	.["successful"] = TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/omnibus_airlock_transition(airlock_type, open, airlock_turf_lists, airlock_effects, end_decisecond)
	var/list/door_types = list()
	omnibus_sound_play('sound/machines/centrifuge.ogg')

	for(var/obj/effect/dropship_airlock/door/airlock_effect as anything in airlock_effects)
		if(open)
			animate(airlock_effect, end_decisecond, pixel_x = (airlock_effect.pixel_x + airlock_effect.x_transition_range), pixel_y = (airlock_effect.pixel_y + airlock_effect.y_transition_range))
		else
			animate(airlock_effect, end_decisecond, pixel_x = (airlock_effect.pixel_x - airlock_effect.x_transition_range), pixel_y = (airlock_effect.pixel_y - airlock_effect.y_transition_range))

		var/is_redundant = FALSE
		for(var/door_type in door_types)
			if(door_type == airlock_effect.transition_type)
				is_redundant = TRUE
		if(!is_redundant)
			door_types["[airlock_effect.transition_type]"] = max(abs(airlock_effect.x_transition_range), abs(airlock_effect.y_transition_range))

	COOLDOWN_START(src, dropship_airlock_cooldown, end_decisecond)
	INVOKE_NEXT_TICK(src, PROC_REF(delayed_airlock_transition), airlock_type, open, airlock_turf_lists, airlock_effects, end_decisecond, door_types)
	if(!precarious_living_mobs)
		precarious_living_mobs = list()

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_airlock_transition(airlock_type, open, airlock_turf_lists, airlock_effects, end_decisecond, door_types)
	if(COOLDOWN_FINISHED(src, dropship_airlock_cooldown))
		living_mobs_ticking_precarity(TRUE)
		end_of_interaction()
		return
	living_mobs_ticking_precarity()

	var/decisecond = end_decisecond - COOLDOWN_TIMELEFT(src, dropship_airlock_cooldown)
	var/max_pixel_threshold
	var/pixel_coefficient
	var/decisecond_pixel_ceiling
	var/increment_pixel_threshold
	var/turf/open/floor/dropship_airlock/airlock_turf
	var/atom/movable/contents_atom

	for(var/door_type in door_types)
		max_pixel_threshold = door_types[door_type]
		pixel_coefficient = max_pixel_threshold / end_decisecond
		decisecond_pixel_ceiling = decisecond * pixel_coefficient
		for(increment_pixel_threshold = round(decisecond_pixel_ceiling - pixel_coefficient + DROPSHIP_AIRLOCK_BTU / 2, DROPSHIP_AIRLOCK_BTU) , increment_pixel_threshold <= decisecond_pixel_ceiling, increment_pixel_threshold += DROPSHIP_AIRLOCK_BTU)
			if(open)
				for(airlock_turf in airlock_turf_lists[door_type]["[increment_pixel_threshold]"]) // due to dropship turf swapping shenaningans this cannot be as anything
					airlock_turf.open = TRUE
					for(contents_atom in airlock_turf.contents)
						if(contents_atom.anchored)
							continue
						if(isliving(contents_atom))
							precarious_living_mobs[contents_atom] = list(airlock_turf, pixel_coefficient, 1) // simple lists because ass lists may be too expensive (4th is iteration)
							continue
						airlock_turf.Entered(contents_atom)
					airlock_turf.clean_cleanables()
					airlock_turf.can_bloody = FALSE
					airlock_turf.update_vis_contents()

			else
				for(airlock_turf in airlock_turf_lists[door_type]["[max_pixel_threshold - increment_pixel_threshold]"])
					airlock_turf.open = FALSE
					airlock_turf.can_bloody = TRUE
					airlock_turf.update_vis_contents()

	INVOKE_NEXT_TICK(src, PROC_REF(delayed_airlock_transition), airlock_type, open, airlock_turf_lists, airlock_effects, end_decisecond, door_types)

// randomises the tick in which you will fall in an opening turf to prevent player danger baiting and give leeway for harshness of the min-bound pixel_thresholds
/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/living_mobs_ticking_precarity(self_sustain = FALSE)
	for(var/mob/living/living_mob as anything in precarious_living_mobs)
		var/turf/open/floor/dropship_airlock/precarious_turf = precarious_living_mobs[living_mob][1]

		if(living_mob.loc != precarious_turf)
			precarious_living_mobs.Remove(living_mob)
			continue

		if(!prob(25) || precarious_living_mobs[living_mob][3] > 15 )
			precarious_living_mobs[living_mob][3]++
			continue

		precarious_turf.Entered(living_mob)
		precarious_living_mobs.Remove(living_mob)

	if(!self_sustain)
		return

	if(precarious_living_mobs.len == 0)
		return

	INVOKE_NEXT_TICK(src, PROC_REF(living_mobs_ticking_precarity), TRUE)

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
	if(!inner_airlock_turf_lists)
		get_inner_airlock_turf_lists()
	if(!linked_outer.outer_airlock_turf_lists)
		linked_outer.get_outer_airlock_turf_lists()

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

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_height_decrease()
	if(COOLDOWN_FINISHED(src, dropship_airlock_cooldown))
		docked_mobile.initiate_docking(linked_outer)
		for(var/obj/effect/dropship_airlock/height_mask/dropship/qdeling_height_mask in dropship_height_masks)
			var/turf/open/floor/dropship_airlock/above_dropship_turf = locate(qdeling_height_mask.x, qdeling_height_mask.y, z) //z is dockport inner
			dropship_height_masks -= qdeling_height_mask
			qdel(qdeling_height_mask)
			above_dropship_turf.open = TRUE
			above_dropship_turf.update_vis_contents()
		var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = docked_mobile.getControlConsole()
		if(root_console)
			root_console.visible_message(message = SPAN_WARNING("DROPSHIP AUTOMATIC EXIT PROCEDURE ACTIVATED. The shuttle will automatically exit in [DROPSHIP_AIRLOCK_OUTER_AIRLOCK_ACCESS_GRACE_PERIOD * 0.1] seconds if still in a lowered position."), max_distance = 3)
		addtimer(CALLBACK(src, PROC_REF(end_outer_airlock_access), TRUE), DROPSHIP_AIRLOCK_OUTER_AIRLOCK_ACCESS_GRACE_PERIOD)
		end_of_interaction()
		return

	var/alpha_reiteration = (DROPSHIP_AIRLOCK_HEIGHT_TRANSITION - COOLDOWN_TIMELEFT(src, dropship_airlock_cooldown)) * 2
	for(var/obj/effect/dropship_airlock/height_mask/dropship/transitioning_height_mask as anything in dropship_height_masks)
		transitioning_height_mask.alpha = alpha_reiteration
	INVOKE_NEXT_TICK(src, PROC_REF(delayed_height_decrease))

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_height_increase()
	docked_mobile.initiate_docking(src)
	end_of_interaction()

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
	if(!linked_outer.outer_airlock_turf_lists)
		linked_outer.get_outer_airlock_turf_lists()
	if(open)
		for(var/obj/structure/machinery/door/poddoor/almayer/airlock/poddoor as anything in poddoors)
			poddoor.close()
		omnibus_airlock_transition("outer", TRUE, linked_outer.outer_airlock_turf_lists, linked_outer.outer_airlock_effects, DROPSHIP_AIRLOCK_DOOR_PERIOD)
		.["to_chat"] = "Opening outer airlock."
	else
		omnibus_airlock_transition("outer", FALSE, linked_outer.outer_airlock_turf_lists, linked_outer.outer_airlock_effects, DROPSHIP_AIRLOCK_DOOR_PERIOD)
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

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/delayed_disengage_clamps()
	if(!docked_mobile.assigned_transit)
		SSshuttle.generate_transit_dock(docked_mobile)
	docked_mobile.set_mode(SHUTTLE_IDLE)
	docked_mobile.initiate_docking(docked_mobile.assigned_transit)
	if(!registered)
		linked_outer.register(TRUE)
	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = docked_mobile.getControlConsole()
	root_console.update_static_data_for_all_viewers()
	INVOKE_NEXT_TICK(docked_mobile, TYPE_PROC_REF(/obj/docking_port/mobile/marine_dropship, dropship_freefall))
	end_of_interaction()

/*#############################################################################
New Backend Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/construct_airlock()
	if(!inner_airlock_effects)
		inner_airlock_effects = list()
	if(!linked_outer.outer_airlock_effects)
		linked_outer.outer_airlock_effects = list()
	var/list/column_of_effects_tiles = list()
	column_of_effects_tiles["-1"] = locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECTS_TILE, z - 1)
	column_of_effects_tiles["0"] = locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECTS_TILE, z)
	new /obj/effect/dropship_airlock/outline(column_of_effects_tiles["0"])
	inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/vertical/north(column_of_effects_tiles["0"])
	inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/horizontal/west(column_of_effects_tiles["0"])
	inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/horizontal/east(column_of_effects_tiles["0"])
	inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/vertical/south(column_of_effects_tiles["0"])
	linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/west(column_of_effects_tiles["0"], OPEN_SPACE_PLANE_FIRST)
	linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/east(column_of_effects_tiles["0"], OPEN_SPACE_PLANE_FIRST)
	linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/west(column_of_effects_tiles["-1"])
	linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/east(column_of_effects_tiles["-1"])

	var/continue_upward = TRUE
	for(var/increment_z = 1, continue_upward, increment_z++) // necessary due to poor propogation of large icons across multi-z
		continue_upward = FALSE
		for(var/turf/turf_above_airlock in block(locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECTS_TILE, z + increment_z), locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_NE_BOUND, z + increment_z)))
			if(!istype(turf_above_airlock, /turf/open_space) && !istype(turf_above_airlock, /turf/solid_open_space))
				continue
			column_of_effects_tiles["[increment_z]"] = locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECTS_TILE, z + increment_z)
			new /obj/effect/dropship_airlock/outline(column_of_effects_tiles["[increment_z]"], (OPENSPACE_BACKDROP_PLANE - increment_z))
			inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/vertical/north(column_of_effects_tiles["[increment_z]"], (OPENSPACE_BACKDROP_PLANE - increment_z))
			inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/horizontal/west(column_of_effects_tiles["[increment_z]"], (OPENSPACE_BACKDROP_PLANE - increment_z))
			inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/horizontal/east(column_of_effects_tiles["[increment_z]"], (OPENSPACE_BACKDROP_PLANE - increment_z))
			inner_airlock_effects += new /obj/effect/dropship_airlock/door/inner/vertical/south(column_of_effects_tiles["[increment_z]"], (OPENSPACE_BACKDROP_PLANE - increment_z))
			linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/west(column_of_effects_tiles["[increment_z]"], (OPEN_SPACE_PLANE_START - increment_z))
			linked_outer.outer_airlock_effects += new /obj/effect/dropship_airlock/door/outer/east(column_of_effects_tiles["[increment_z]"], (OPEN_SPACE_PLANE_START - increment_z))
			continue_upward = TRUE
			break

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/get_inner_airlock_turf_lists()
	inner_airlock_turf_lists = list()
	if(!inner_airlock_effects)
		inner_airlock_effects = list()
	for(var/turf/turf as anything in block(DROPSHIP_AIRLOCK_BOUNDS))
		if(istype(turf, /turf/open/floor/dropship_airlock/inner))
			var/turf/open/floor/dropship_airlock/airlock_turf = turf
			if(!inner_airlock_turf_lists[airlock_turf.door_type])
				inner_airlock_turf_lists[airlock_turf.door_type] = list()
			if(!inner_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"])
				inner_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"] = list()
			inner_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"] += airlock_turf

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/omnibus_sound_play(sound_effect)
	playsound(src, sound_effect, 100, vol_cat = VOLUME_AMB)
	playsound(linked_outer, sound_effect, 100, vol_cat = VOLUME_AMB)

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/end_of_interaction()
	COOLDOWN_RESET(src, dropship_airlock_cooldown)
	if(automatic_process_stage_change)
		addtimer(CALLBACK(src, PROC_REF(automatic_process)), DROPSHIP_AIRLOCK_AUTOMATIC_DELAY)
		return
	if(allow_processing_to_end)
		processing = FALSE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/end_outer_airlock_access(go_down = TRUE) // intended to be called exclusively by delayed_height_decrease & outer on_arrival
	if(automatic_process_stage) // it is already an automated system, no need to force it.
		return
	if(!test_conditions(null, null, TRUE, null, FALSE))
		return

	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = docked_mobile?.getControlConsole()
	if(root_console)
		root_console.visible_message(message = go_down ? SPAN_WARNING("MANUAL PROCEDURE TIMEOUT. The dropship is beginning to automatically depart. Please prepare for freefall.") : SPAN_WARNING("MANUAL PROCEDURE TIMEOUT. The dropship is beginning to be automatically raised up."), max_distance = 3)
	allow_processing_to_end = FALSE
	force_process(go_down ? DROPSHIP_AIRLOCK_GO_DOWN : DROPSHIP_AIRLOCK_GO_UP)

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/test_conditions(test_playing_alarm = null, test_open_inner = null, test_lowered_dropship = null, test_open_outer = null, test_disengaged_clamps = null)
	if(test_playing_alarm != null && test_playing_alarm != playing_airlock_alarm)
		return FALSE
	if(test_open_inner != null && test_open_inner != open_inner_airlock)
		return FALSE
	if(test_lowered_dropship != null && test_lowered_dropship != lowered_dropship)
		return FALSE
	if(test_open_outer != null && test_open_outer != open_outer_airlock)
		return FALSE
	if(test_disengaged_clamps != null && test_disengaged_clamps != disengaged_clamps)
		return FALSE
	return TRUE

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/automatic_process(command = FALSE) // exclusively for autopilot (for a generally callable proc see force_process)
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

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/force_process(command = FALSE) //a more generally-callable proc than autopilot, not alarmed, returns time till completion
	for(var/qdel_timer in active_timers)
		qdel(qdel_timer)

	var/number_to_call = 1
	switch(command)
		if(DROPSHIP_AIRLOCK_GO_UP)
			if(!lowered_dropship)
				return 0
			if(open_outer_airlock)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_outer_airlock), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
			if(!playing_airlock_alarm)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_airlock_alarm), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
			if(!open_inner_airlock)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_inner_airlock), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
			if(lowered_dropship)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_dropship_height), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_inner_airlock), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
			addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_airlock_alarm), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)

		if(DROPSHIP_AIRLOCK_GO_DOWN)
			if(lowered_dropship)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_inner_airlock), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
			else
				if(open_outer_airlock)
					addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_outer_airlock), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
					number_to_call += 1
				if(!playing_airlock_alarm)
					addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_airlock_alarm), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
					number_to_call += 1
				if(!open_inner_airlock)
					addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_inner_airlock), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
					number_to_call += 1
				if(!lowered_dropship)
					addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_dropship_height), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
					number_to_call += 1
					addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_inner_airlock), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
					number_to_call += 1
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_airlock_alarm), FALSE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_outer_airlock), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)
				number_to_call += 1
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_clamps), TRUE, TRUE), number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)

	return number_to_call * DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD

/obj/docking_port/stationary/marine_dropship/airlock/inner/proc/end_of_admin_command()
	undergoing_admin_command = FALSE
	allow_processing_to_end = TRUE
	processing = FALSE

/obj/docking_port/stationary/marine_dropship/airlock/outer/proc/handle_obscuring_shuttle_turfs()
	for(var/turf/open/shuttle/shuttle_turf in block(DROPSHIP_AIRLOCK_BOUNDS))
		var/turf/open/above_turf = locate(shuttle_turf.x, shuttle_turf.y, shuttle_turf.z + 1)
		if(linked_inner.lowered_dropship)
			above_turf?.icon_state = "full_black"
		if(!linked_inner.lowered_dropship)
			above_turf?.icon_state = "transparent"

/obj/docking_port/stationary/marine_dropship/airlock/outer/proc/get_outer_airlock_turf_lists()
	outer_airlock_turf_lists = list()
	if(!outer_airlock_effects)
		outer_airlock_effects = list()
	for(var/obj/effect/dropship_airlock/door/airlock_effect as anything in outer_airlock_effects)
		if(!outer_airlock_turf_lists["[airlock_effect.transition_type]"])
			outer_airlock_turf_lists["[airlock_effect.transition_type]"] = list()
	for(var/turf/turf as anything in block(DROPSHIP_AIRLOCK_BOUNDS))
		if(istype(turf, /turf/open/floor/dropship_airlock))
			var/turf/open/floor/dropship_airlock/airlock_turf = turf
			if(!outer_airlock_turf_lists[airlock_turf.door_type])
				outer_airlock_turf_lists[airlock_turf.door_type] = list()
			if(!outer_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"])
				outer_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"] = list()
			outer_airlock_turf_lists[airlock_turf.door_type]["[airlock_turf.pixel_threshold]"] += airlock_turf

/*#############################################################################
. = ..() Backend Procs
#############################################################################*/

/obj/docking_port/stationary/marine_dropship/airlock/inner/Initialize(mapload)
	. = ..()
	GLOB.dropship_airlock_docking_ports.Add(src)
	if(!linked_outer)
		for(var/obj/docking_port/stationary/marine_dropship/airlock/outer/outer_port in GLOB.dropship_airlock_docking_ports)
			if(outer_port.dropship_airlock_id == dropship_airlock_id)
				linked_outer = outer_port
				linked_outer.linked_inner = src
	dropship_height_masks = list()
	floodlights = list()
	door_controls = list()
	poddoors = list()
	railings = list()
	get_inner_airlock_turf_lists()
	if(!roundstart_template)
		unregister()
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, construct_airlock))

/obj/docking_port/stationary/marine_dropship/airlock/inner/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(registered)
		unregister()
	auto_open = FALSE // when the dropship that is originally loaded is auto_opened, any further landing dropships will have people onboard to decide to whether or not they want the doors open (which stops people charging out the opened doors when the airlock is open)
	var/list/dropship_turfs = arriving_shuttle.return_turfs()
	for(var/turf/dropship_turf as anything in dropship_turfs)
		if(istype(dropship_turf, /turf/open/shuttle) || istype(dropship_turf, /turf/closed/shuttle))
			var/obj/effect/dropship_airlock/height_mask/dropship/dropship_height_mask = new /obj/effect/dropship_airlock/height_mask/dropship(dropship_turf)
			dropship_height_masks += dropship_height_mask
			continue
		if(istype(dropship_turf, /turf/open/floor/dropship_airlock/inner))
			var/obj/structure/shuttle/part/dropship_part = locate(/obj/structure/shuttle/part) in dropship_turf.contents
			if(!dropship_part)
				continue
			var/obj/effect/dropship_airlock/height_mask/dropship/dropship_part_height_mask = new /obj/effect/dropship_airlock/height_mask/dropship(dropship_turf)
			dropship_part_height_mask.icon = dropship_part.icon
			dropship_part_height_mask.icon_state = dropship_part.icon_state
			dropship_part_height_mask.color = "#000000"
			dropship_height_masks += dropship_part_height_mask

/obj/docking_port/stationary/marine_dropship/airlock/inner/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	for(var/list/airlock_turf_types as anything in inner_airlock_turf_lists)
		for(var/list/airlock_turfs as anything in airlock_turf_types)
			for(var/turf/open/floor/dropship_airlock/airlock_turf in airlock_turfs)
				if(airlock_turf.open)
					airlock_turf.open = TRUE
					airlock_turf.update_vis_contents()

/obj/docking_port/stationary/marine_dropship/airlock/outer/Initialize(mapload)
	. = ..()
	GLOB.dropship_airlock_docking_ports.Add(src)
	get_outer_airlock_turf_lists()
	return INITIALIZE_HINT_LATELOAD

/obj/docking_port/stationary/marine_dropship/airlock/outer/LateInitialize()
	. = ..()
	if(!linked_inner)
		for(var/obj/docking_port/stationary/marine_dropship/airlock/inner/inner_port in GLOB.dropship_airlock_docking_ports)
			if(inner_port.dropship_airlock_id == dropship_airlock_id)
				linked_inner = inner_port
				linked_inner.linked_outer = src
	if(linked_inner.roundstart_template)
		unregister()
	else
		INVOKE_NEXT_TICK(linked_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, update_outer_airlock), TRUE)

/obj/docking_port/stationary/marine_dropship/airlock/outer/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(registered)
		unregister()
	if(!istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		return
	var/obj/docking_port/mobile/marine_dropship/arriving_dropship = arriving_shuttle
	if((src == arriving_dropship.automated_hangar || src == arriving_dropship.automated_lz) && arriving_dropship.automated_delay && !linked_inner.processing)
		linked_inner.automatic_process(DROPSHIP_AIRLOCK_GO_UP)
	else
		if(linked_inner.lowered_dropship)
			var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = arriving_dropship.getControlConsole()
			if(root_console)
				root_console.visible_message(message = SPAN_WARNING("DROPSHIP AUTOMATIC RETURN PROCEDURE ACTIVATED. The shuttle will automatically return to the top of the airlock in [DROPSHIP_AIRLOCK_OUTER_AIRLOCK_ACCESS_GRACE_PERIOD * 0.1] seconds if still in a lowered position."), max_distance = 3)
			addtimer(CALLBACK(linked_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, end_outer_airlock_access), FALSE), DROPSHIP_AIRLOCK_OUTER_AIRLOCK_ACCESS_GRACE_PERIOD)
	linked_inner.disengaged_clamps = FALSE
	linked_inner.lowered_dropship = TRUE
	handle_obscuring_shuttle_turfs()

/obj/docking_port/stationary/marine_dropship/airlock/outer/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	for(var/list/airlock_turf_types as anything in outer_airlock_turf_lists)
		for(var/list/airlock_turfs as anything in airlock_turf_types)
			for(var/turf/open/floor/dropship_airlock/airlock_turf in airlock_turfs)
				airlock_turf.open = linked_inner.open_outer_airlock
	linked_inner.disengaged_clamps = TRUE
	linked_inner.lowered_dropship = FALSE
	handle_obscuring_shuttle_turfs()

/*#############################################################################
Airlock Appearance Effects
#############################################################################*/
/obj/effect/dropship_airlock
	layer = ABOVE_TURF_LAYER
	plane = FLOOR_PLANE
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/obj/effect/dropship_airlock/Initialize(mapload, depth_plane = plane, ...)
	. = ..()
	plane = depth_plane

// we typically don't want them moving
/obj/effect/dropship_airlock/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!anchored)
		. = ..()
	return TRUE

/obj/effect/dropship_airlock/door
	var/transition_type = null
	var/x_transition_range = 0 //TRANSITION RANGES MUST BE
	var/y_transition_range = 0 // A MULTIPLE OF 8
	layer = 1.95

/obj/effect/dropship_airlock/door/inner
	name = "hangar inner airlock"

/obj/effect/dropship_airlock/door/inner/horizontal
	transition_type = "horizontal"
	icon = 'icons/effects/airlock_inner_horizontal.dmi'

/obj/effect/dropship_airlock/door/inner/horizontal/west
	icon_state = "west"
	pixel_x = 32
	pixel_y = 128
	layer = 1.96
	x_transition_range = -280

/obj/effect/dropship_airlock/door/inner/horizontal/east
	icon_state = "east"
	pixel_x = 288
	pixel_y = 128
	layer = 1.97
	x_transition_range = 280

/obj/effect/dropship_airlock/door/inner/vertical
	transition_type = "vertical"
	icon = 'icons/effects/airlock_inner_vertical.dmi'

/obj/effect/dropship_airlock/door/inner/vertical/north
	icon_state = "north"
	pixel_x = 32
	pixel_y = 704
	y_transition_range = 200

/obj/effect/dropship_airlock/door/inner/vertical/south
	icon_state = "south"
	pixel_x = 32
	pixel_y = 32
	y_transition_range = -200
	layer = 1.98

/obj/effect/dropship_airlock/door/outer
	name = "hangar outer airlock"
	transition_type = "horizontal"
	icon = 'icons/effects/airlock_outer.dmi'

/obj/effect/dropship_airlock/door/outer/west
	icon_state = "west"
	pixel_x = 32
	pixel_y = 32
	x_transition_range = -272

/obj/effect/dropship_airlock/door/outer/east
	icon_state = "east"
	pixel_x = 288
	pixel_y = 32
	x_transition_range = 272
	layer = 1.96

/obj/effect/dropship_airlock/outline
	icon = 'icons/effects/airlock_outline.dmi'
	icon_state = "outline"
	layer = 2.05

/obj/effect/dropship_airlock/outline/Initialize(mapload, depth_plane, ...)
	. = ..()
	set_light(1, 0.7, LIGHT_COLOR_BLUE,/atom/movable/lighting_mask/dropship_airlock)

/obj/effect/dropship_airlock/half_tile
	icon = 'icons/effects/airlock_32x32.dmi'
	icon_state = "half_tile"
	layer = ABOVE_TURF_LAYER

/obj/effect/dropship_airlock/height_mask
	icon = 'icons/effects/airlock_32x32.dmi'
	icon_state = "height_mask"
	layer = 1.94
	alpha = 135
	plane = FLOOR_PLANE

/obj/effect/dropship_airlock/height_mask/dropship
	name = "transitionary alpha height mask"
	layer = 5.01
	alpha = 0
	plane = GAME_PLANE

/*#############################################################################
Airlock Turfs Definitions
#############################################################################*/

/turf/open/floor/dropship_airlock
	name = "closed dropship airlock"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "transparent"
	mouse_opacity = TRUE
	plane = OPEN_SPACE_PLANE_START
	layer = 1.9
	is_weedable = NOT_WEEDABLE
	var/door_type = FALSE
	var/open = FALSE

	//WHEN CREATING NEW TURFS PIXEL_THRESHOLD SHOULD BE THE RELATED EFFECT DOOR'S HIGHEST TRANSITION RANGE TYPE (X OR Y)
	var/pixel_threshold = null // to tie the turf opening and the airlock animation together, the pixel_[x/y] threshold on which a tile transitions 'open' or 'closed' (the lowest bound where below will be visible) has to be set manually in this variable.

/turf/open/floor/dropship_airlock/inner/vertical
	door_type = "vertical"

/turf/open/floor/dropship_airlock/inner/horizontal
	door_type = "horizontal"

/turf/open/floor/dropship_airlock/outer
	name = "Hangar Outer Airlock"
	icon = 'icons/turf/floors/dev/dev_airlock.dmi'
	icon_state = "first"
	door_type = "horizontal"

/turf/open/floor/dropship_airlock/inner
	name = "Hangar Inner Airlock"
	icon = 'icons/turf/floors/dev/dev_airlock.dmi'
	icon_state = "first"

/turf/open/floor/almayer/plate/hangar_1
	icon_state = "hangar_1"
	name = "Hangar Airlock One"

/turf/open/floor/almayer/plate/hangar_2
	icon_state = "hangar_2"
	name = "Hangar Airlock Two"

/*#############################################################################
Airlock Turf Procs
#############################################################################*/

/turf/open/floor/dropship_airlock/update_vis_contents()
	vis_contents.Cut()
	for(var/obj/vis_contents_holder/holder in src)
		qdel(holder)

	if(open)
		var/turf/below = SSmapping.get_turf_below(src)
		new /obj/vis_contents_holder(src, below, 1, FALSE)

/turf/open/floor/dropship_airlock/Entered(atom/movable/entered_atom)
	. = ..()

	if(!open)
		return

	if(entered_atom.flags_atom & NO_ZFALL)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING)
		return

	if(entered_atom.loc != src && length(entered_atom.locs) > 1)
		return // Ignore multiloc things unless their primary loc is here

	enter_depths(entered_atom)

/turf/open/floor/dropship_airlock/proc/enter_depths(/atom/movable/entered_atom)
	return

/turf/open/floor/dropship_airlock/inner/enter_depths(atom/movable/entered_atom)
	if(HAS_TRAIT(entered_atom, TRAIT_LAUNCHED))
		return

	entered_atom.visible_message(SPAN_BOLDWARNING("[entered_atom] falls into the open airlock!"), SPAN_DANGER("You fall into the open airlock!"))
	var/turf/below = SSmapping.get_turf_below(src)
	if(istype(below, /turf/open/floor/dropship_airlock))
		entered_atom.forceMove(below)
		entered_atom.onZImpact(below, 1)
		if(isliving(entered_atom))
			INVOKE_ASYNC(src, PROC_REF(depths_damage), entered_atom)
		return

	if(istype(below, /turf/closed/wall))
		entered_atom.forceMove(locate(below.x, below.y - 1, below.z))
		entered_atom.onZImpact(below, 1)
		entered_atom.visible_message(SPAN_WARNING("[entered_atom] slides off the wall"), SPAN_DANGER("You slide off the wall onto the floor!"))
		if(isliving(entered_atom))
			INVOKE_ASYNC(src, PROC_REF(depths_damage), entered_atom)
		return

	var/obj/structure/shuttle/part/dropship_part_to_locate = locate(/obj/structure/shuttle/part) in range(4, below)
	if(dropship_part_to_locate) // presumably, shuttle parts are on the outside skin of a dropship.
		entered_atom.forceMove(dropship_part_to_locate.loc)
		entered_atom.onZImpact(below, 1)
		entered_atom.visible_message(SPAN_WARNING("[entered_atom] slides off the roof of the dropship!"), SPAN_DANGER("You slide off the roof of the dropship!"))
		if(isliving(entered_atom))
			INVOKE_ASYNC(src, PROC_REF(depths_damage), entered_atom)
		return

	entered_atom.visible_message(SPAN_BOLDWARNING("[entered_atom] falls onto the engines of the dropship and is eviscerated!"), SPAN_HIGHDANGER("You fall onto the engines of the dropship and are eviscerated!"))
	qdel(entered_atom)

// mainly copied from open_space
/turf/open/floor/dropship_airlock/inner/Initialize(mapload, ...)
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "minimal_alpha"
	vis_contents += GLOB.openspace_backdrop_one_for_all
	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)

	pass_flags = GLOB.pass_flags_cache[type]

	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/dropship_airlock/inner/proc/depths_damage(mob/living/fallen_living)
	fallen_living.visible_message(SPAN_BOLDWARNING("[fallen_living] splatters onto the ground with a thud!"), SPAN_DANGER("You splatter onto the ground with a thud!"))
	fallen_living.KnockDown(5)
	fallen_living.apply_damage(100)
	if(ishuman(fallen_living))
		var/mob/living/carbon/fallen_human = fallen_living
		var/obj/limb/breaking_limb = fallen_human.get_limb()
		breaking_limb.fracture()
	else
		fallen_living.apply_damage(50)

/turf/open/floor/dropship_airlock/outer/Initialize(mapload, ...)
	. = ..()
	icon = 'icons/turf/floors/space.dmi'
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/open/floor/dropship_airlock/outer/enter_depths(atom/movable/entered_atom)
	entered_atom.visible_message(SPAN_BOLDWARNING("There is an onrush of air. [entered_atom] is flung into space!"), SPAN_HIGHDANGER("There is an onrush of air. You are flung into space!"))
	qdel(entered_atom)

/*#############################################################################
Airlock Turf Threshold Definitions
#############################################################################*/
// ALL PIXEL THRESHOLDS MUST BE MULTIPLES OF 8 TO WORK. MUST ALSO BE WITHIN THE TRANSITION_RANGE OF ITS DOOR_TYPE AIRLOCK EFFECT (AND LESSER THAN 8)

/turf/open/floor/dropship_airlock/inner/horizontal/first
	pixel_threshold = 8
	icon_state = "first"

/turf/open/floor/dropship_airlock/inner/horizontal/second
	pixel_threshold = 16
	icon_state = "second"

/turf/open/floor/dropship_airlock/inner/horizontal/second_half
	pixel_threshold = 8
	icon_state = "second_half"

/turf/open/floor/dropship_airlock/inner/horizontal/third
	pixel_threshold = 48
	icon_state = "third"

/turf/open/floor/dropship_airlock/inner/horizontal/third_half
	pixel_threshold = 32
	icon_state = "third_half"

/turf/open/floor/dropship_airlock/inner/horizontal/fourth
	pixel_threshold = 80
	icon_state = "fourth"

/turf/open/floor/dropship_airlock/inner/horizontal/fourth_half
	pixel_threshold = 64
	icon_state = "fourth_half"

/turf/open/floor/dropship_airlock/inner/horizontal/fifth
	pixel_threshold = 112
	icon_state = "fifth"

/turf/open/floor/dropship_airlock/inner/horizontal/fifth_half
	pixel_threshold = 96
	icon_state = "fifth_half"

/turf/open/floor/dropship_airlock/inner/horizontal/sixth
	pixel_threshold = 144
	icon_state = "sixth"

/turf/open/floor/dropship_airlock/inner/horizontal/sixth_half
	pixel_threshold = 128
	icon_state = "sixth_half"

/turf/open/floor/dropship_airlock/inner/horizontal/seventh
	pixel_threshold = 176
	icon_state = "seventh"

/turf/open/floor/dropship_airlock/inner/horizontal/eighth
	pixel_threshold = 208
	icon_state = "eighth"

/turf/open/floor/dropship_airlock/inner/horizontal/ninth
	pixel_threshold = 240
	icon_state = "ninth"

/turf/open/floor/dropship_airlock/inner/vertical/first
	pixel_threshold = 8
	icon_state = "first_v"

/turf/open/floor/dropship_airlock/inner/vertical/second
	pixel_threshold = 32
	icon_state = "second_v"

/turf/open/floor/dropship_airlock/inner/vertical/second_half
	pixel_threshold = 16
	icon_state = "second_half_v"

/turf/open/floor/dropship_airlock/inner/vertical/third
	pixel_threshold = 64
	icon_state = "third_v"

/turf/open/floor/dropship_airlock/inner/vertical/third_half
	pixel_threshold = 48
	icon_state = "third_half_v"

/turf/open/floor/dropship_airlock/inner/vertical/fourth
	pixel_threshold = 96
	icon_state = "fourth_v"

/turf/open/floor/dropship_airlock/inner/vertical/fourth_half
	pixel_threshold = 80
	icon_state = "fourth_half_v"

/turf/open/floor/dropship_airlock/inner/vertical/fifth
	pixel_threshold = 128
	icon_state = "fifth_v"

/turf/open/floor/dropship_airlock/inner/vertical/fifth_half
	pixel_threshold = 112
	icon_state = "fifth_half_v"

/turf/open/floor/dropship_airlock/inner/vertical/sixth
	pixel_threshold = 152
	icon_state = "sixth_v"

/turf/open/floor/dropship_airlock/inner/vertical/sixth_half
	pixel_threshold = 136
	icon_state = "sixth_half_v"

/turf/open/floor/dropship_airlock/outer/first
	pixel_threshold = 8
	icon_state = "first"

/turf/open/floor/dropship_airlock/outer/second
	pixel_threshold = 16
	icon_state = "second"

/turf/open/floor/dropship_airlock/outer/third
	pixel_threshold = 48
	icon_state = "third"

/turf/open/floor/dropship_airlock/outer/fourth
	pixel_threshold = 80
	icon_state = "fourth"

/turf/open/floor/dropship_airlock/outer/fifth
	pixel_threshold = 112
	icon_state = "fifth"

/turf/open/floor/dropship_airlock/outer/sixth
	pixel_threshold = 144
	icon_state = "sixth"

/turf/open/floor/dropship_airlock/outer/seventh
	pixel_threshold = 176
	icon_state = "seventh"

/turf/open/floor/dropship_airlock/outer/eighth
	pixel_threshold = 208
	icon_state = "eighth"

/turf/open/floor/dropship_airlock/outer/ninth
	pixel_threshold = 240
	icon_state = "ninth"
