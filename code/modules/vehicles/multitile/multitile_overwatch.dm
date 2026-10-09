/// Dedicated overwatch camera, +2 tiles of view range over a standard marine's helmet camera.
/obj/structure/machinery/camera/overwatch/vehicle
	name = "vehicle overwatch camera"
	view_range = 9

/**
 * Creates and wires up this vehicle's dedicated CIC overwatch camera.
 *
 * Opt-in: call this from a vehicle's own Initialize() to enable overwatch for it.
 */
/obj/vehicle/multitile/proc/setup_overwatch_camera()
	overwatch_camera = new /obj/structure/machinery/camera/overwatch/vehicle(src)
	overwatch_camera.c_tag = name
	overwatch_camera.status = FALSE
	overwatch_camera.AddComponent(/datum/component/overwatch_console_control)
	refresh_overwatch_camera_state()

/// Returns this vehicle's dedicated overwatch camera, if any. Null for a vehicle that never set one up.
/obj/vehicle/multitile/proc/get_camera()
	return overwatch_camera

/**
 * Called on every real IFF online/offline transition, letting a vehicle keep its IFF-gated systems
 * in sync. check_eye() already disconnects any console mid-watch once offline, so no extra cleanup is
 * needed. No-op if this vehicle never set up an overwatch camera.
 */
/obj/vehicle/multitile/proc/refresh_overwatch_camera_state()
	if(!overwatch_camera)
		return
	var/obj/item/hardpoint/iff_module/iff = locate() in get_hardpoints_copy()
	overwatch_camera.status = !!(iff && iff.is_functional())

/**
 * Moves this vehicle's overwatch to a different squad. Sticky by design: leaving the driver's seat
 * doesn't clear the assignment, only a new crewmember from a different squad reassigns it.
 *
 * Also force-releases any console currently watching this vehicle's camera, so an officer can't get
 * stuck staring at a feed with no way to back out.
 *
 * Arguments:
 * * new_squad = Squad to assign this vehicle's overwatch to. Null is a no-op.
 */
/obj/vehicle/multitile/proc/update_overwatch_squad(datum/squad/new_squad)
	if(!new_squad || new_squad == overwatch_squad)
		return
	overwatch_squad?.remove_overwatch_vehicle(src)
	overwatch_squad = new_squad
	overwatch_squad.add_overwatch_vehicle(src)

	var/obj/structure/machinery/camera/own_cam = get_camera()
	for(var/obj/structure/machinery/computer/overwatch/console as anything in GLOB.active_overwatch_consoles)
		console.force_release_if_watching(own_cam)
