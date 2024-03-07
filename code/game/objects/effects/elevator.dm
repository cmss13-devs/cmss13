/obj/effect/elevator
	name = "\proper empty space"
	desc = "There seems to be an awful lot of machinery down below..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "supply_elevator_lowered"
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_TURF_LAYER
	appearance_flags = KEEP_TOGETHER

/obj/effect/elevator/ex_act(severity)
	return

/obj/effect/elevator/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()

// Don't move with the elevator.
/obj/effect/elevator/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	return
/obj/effect/elevator/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	return
/obj/effect/elevator/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	return

/obj/effect/elevator/animation_overlay
	blend_mode = BLEND_INSET_OVERLAY
	appearance_flags = KEEP_TOGETHER

/obj/effect/elevator/vehicle
	icon_state = "vehicle_elevator_lowered"
