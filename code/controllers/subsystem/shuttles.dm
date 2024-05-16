#define MAX_TRANSIT_REQUEST_RETRIES 10
/// How many turfs to allow before we stop blocking transit requests
#define MAX_TRANSIT_TILE_COUNT (150 ** 2)
/// How many turfs to allow before we start freeing up existing "soft reserved" transit docks
/// If we're under load we want to allow for cycling, but if not we want to preserve already generated docks for use
#define SOFT_TRANSIT_RESERVATION_THRESHOLD (100 ** 2)
/// Give a shuttle 10 "fires" (~10 seconds) to spawn before it can be cleaned up.
#define SHUTTLE_SPAWN_BUFFER SSshuttle.wait * 10

SUBSYSTEM_DEF(shuttle)
	name = "Shuttle"
	wait = 1 SECONDS
	init_order = SS_INIT_SHUTTLE
	flags = SS_KEEP_TIMING

	/// A list of all the mobile docking ports.
	var/list/mobile = list()
	/// A list of all the stationary docking ports.
	var/list/stationary = list()
	/// A list of all the transit docking ports.
	var/list/transit = list()

	/// Now it's only for ID generation in /obj/docking_port/mobile/register()
	var/list/assoc_mobile = list()
	/// Now it's only for ID generation in /obj/docking_port/stationary/register()
	var/list/assoc_stationary = list()

	/// A list of all the mobile docking ports currently requesting a spot in hyperspace.
	var/list/transit_requesters = list()
	/// An associative list of the mobile docking ports that have failed a transit request, with the amount of times they've actually failed that transit request, up to MAX_TRANSIT_REQUEST_RETRIES
	var/list/transit_request_failures = list()
	/// How many turfs our shuttles are currently utilizing in reservation space
	var/transit_utilized = 0

	var/obj/docking_port/mobile/vehicle_elevator/vehicle_elevator

	var/list/hidden_shuttle_turfs = list() //all turfs hidden from navigation computers associated with a list containing the image hiding them and the type of the turf they are pretending to be
	var/list/hidden_shuttle_turf_images = list() //only the images from the above list

	/// Disallow transit after nuke goes off
	var/lockdown = FALSE

	/// The currently selected shuttle map_template in the shuttle manipulator's template viewer.
	var/datum/map_template/shuttle/selected

	/// The existing shuttle associated with the selected shuttle map_template.
	var/obj/docking_port/mobile/existing_shuttle

	/// The shuttle map_template of the shuttle we want to preview.
	var/datum/map_template/shuttle/preview_template
	/// The docking port associated to the preview_template that's currently being previewed.
	var/obj/docking_port/mobile/preview_shuttle

	/// The turf reservation for the current previewed shuttle.
	var/datum/turf_reservation/preview_reservation

	/// Are we currently in the process of loading a shuttle? Useful to ensure we don't load more than one at once, to avoid weird inconsistencies and possible runtimes.
	var/loading_shuttle = FALSE

/datum/controller/subsystem/shuttle/Initialize(timeofday)
	initial_load()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/shuttle/proc/initial_load()
	for(var/obj/docking_port/stationary/port as anything in stationary)
		port.load_roundstart()
		CHECK_TICK

/datum/controller/subsystem/shuttle/fire(resumed = FALSE)
	for(var/thing in mobile)
		if(!thing)
			mobile.Remove(thing)
			continue
		var/obj/docking_port/mobile/port = thing
		port.check()
	for(var/thing in transit)
		var/obj/docking_port/stationary/transit/T = thing
		if(!T.owner)
			qdel(T, force=TRUE)
		// This next one removes transit docks/zones that aren't
		// immediately being used. This will mean that the zone creation
		// code will be running a lot.

		// If we're below the soft reservation threshold, don't clear the old space
		// We're better off holding onto it for now
		if(transit_utilized < SOFT_TRANSIT_RESERVATION_THRESHOLD)
			continue
		var/obj/docking_port/mobile/owner = T.owner
		if(owner && (world.time > T.spawn_time + SHUTTLE_SPAWN_BUFFER))
			var/idle = owner.mode == SHUTTLE_IDLE
			var/not_centcom_evac = owner.launch_status == NOLAUNCH
			var/not_in_use = (!T.get_docked())
			if(idle && not_centcom_evac && not_in_use)
				qdel(T, force=TRUE)

	if(!SSmapping.clearing_reserved_turfs)
		while(transit_requesters.len)
			var/requester = popleft(transit_requesters)
			var/success = null
			// Do not try and generate any transit if we're using more then our max already
			if(transit_utilized < MAX_TRANSIT_TILE_COUNT)
				success = generate_transit_dock(requester)
			if(!success) // BACK OF THE QUEUE
				transit_request_failures[requester]++
				if(transit_request_failures[requester] < MAX_TRANSIT_REQUEST_RETRIES)
					transit_requesters += requester
				else
					var/obj/docking_port/mobile/M = requester
					M.transit_failure()
					log_debug("[M.id] failed to get a transit zone")
			if(MC_TICK_CHECK)
				break

/datum/controller/subsystem/shuttle/proc/getShuttle(id, warn = TRUE)
	for(var/obj/docking_port/mobile/shuttle in mobile)
		if(shuttle.id == id)
			return shuttle
	if(!warn)
		return null
	WARNING("couldn't find shuttle with id: [id]")

/// Tries to get a shuttle based on its original template id (rather than one that may have an additional identifier)
/datum/controller/subsystem/shuttle/proc/get_template_shuttle(id, warn = TRUE)
	for(var/obj/docking_port/mobile/shuttle in mobile)
		if(shuttle.template_id == id)
			return shuttle
	if(!warn)
		return null
	WARNING("couldn't find template shuttle with id: [id]")

/datum/controller/subsystem/shuttle/proc/getDock(id)
	for(var/obj/docking_port/stationary/S in stationary)
		if(S.id == id)
			return S
	WARNING("couldn't find dock with id: [id]")

//try to move/request to dock_home if possible, otherwise dock_away. Mainly used for admin buttons
/datum/controller/subsystem/shuttle/proc/toggleShuttle(id, dock_home, dock_away, timed)
	var/obj/docking_port/mobile/shuttle_port = getShuttle(id)
	if(!shuttle_port)
		return DOCKING_BLOCKED
	var/obj/docking_port/stationary/docked_at = shuttle_port.get_docked()
	var/destination = dock_home
	if(docked_at && docked_at.id == dock_home)
		destination = dock_away
	if(timed)
		if(shuttle_port.request(getDock(destination)))
			return DOCKING_IMMOBILIZED
	else
		if(shuttle_port.initiate_docking(getDock(destination)) != DOCKING_SUCCESS)
			return DOCKING_IMMOBILIZED
	return DOCKING_SUCCESS //dock successful

/**
 * Moves a shuttle to a new location
 *
 * Arguments:
 * * id - The ID of the shuttle (mobile docking port) to move
 * * dock_id - The ID of the destination (stationary docking port) to move to
 * * timed - If true, have the shuttle follow normal spool-up, jump, dock process. If false, immediately move to the new location.
 */
/datum/controller/subsystem/shuttle/proc/moveShuttle(id, dock_id, timed)
	var/obj/docking_port/mobile/shuttle_port = getShuttle(id)
	var/obj/docking_port/stationary/docking_target = getDock(dock_id)

	return moveShuttleToDock(shuttle_port, docking_target, timed)

/datum/controller/subsystem/shuttle/proc/moveShuttleToDock(obj/docking_port/mobile/shuttle_port, obj/docking_port/stationary/docking_target, timed)
	if(!shuttle_port)
		return DOCKING_NULL_SOURCE
	if(timed)
		if(shuttle_port.request(docking_target))
			return DOCKING_IMMOBILIZED
	else
		if(shuttle_port.initiate_docking(docking_target) != DOCKING_SUCCESS)
			return DOCKING_IMMOBILIZED
	return DOCKING_SUCCESS //dock successful

/datum/controller/subsystem/shuttle/proc/request_transit_dock(obj/docking_port/mobile/M)
	if(!istype(M))
		CRASH("[M] is not a mobile docking port")

	if(M.assigned_transit)
		return
	else
		if(!(M in transit_requesters))
			transit_requesters += M

/datum/controller/subsystem/shuttle/proc/generate_transit_dock(obj/docking_port/mobile/M)
	// First, determine the size of the needed zone
	// Because of shuttle rotation, the "width" of the shuttle is not
	// always x.
	//var/travel_dir = M.preferred_direction
	// Remember, the direction is the direction we appear to be
	// coming from
	var/dock_angle = dir2angle(M.preferred_direction) + dir2angle(M.port_direction) + 180
	var/dock_dir = angle2dir(dock_angle)

	var/transit_width = SHUTTLE_TRANSIT_BORDER * 2
	var/transit_height = SHUTTLE_TRANSIT_BORDER * 2

	// Shuttles travelling on their side have their dimensions swapped
	// from our perspective
	switch(dock_dir)
		if(NORTH, SOUTH)
			transit_width += M.width
			transit_height += M.height
		if(EAST, WEST)
			transit_width += M.height
			transit_height += M.width

/*
	to_chat(world, "The attempted transit dock will be [transit_width] width, and \)
		[transit_height] in height. The travel dir is [travel_dir]."
*/

	var/transit_path = M.get_transit_path_type()

	var/datum/turf_reservation/proposal = SSmapping.request_turf_block_reservation(
		transit_width,
		transit_height,
		z_size = 1, //if this is changed the turf uncontain code below has to be updated to support multiple zs
		reservation_type = /datum/turf_reservation/transit,
		turf_type_override = transit_path,
	)

	if(!istype(proposal))
		log_debug("generate_transit_dock() failed to get a block reservation from mapping system")
		return FALSE

	var/turf/bottomleft = proposal.bottom_left_turfs[1]
	// Then create a transit docking port in the middle
	var/coords = M.return_coords(0, 0, dock_dir)
	/*  0------2
	*   |      |
	*   |      |
	*   |  x   |
	*   3------1
	*/

	var/x0 = coords[1]
	var/y0 = coords[2]
	var/x1 = coords[3]
	var/y1 = coords[4]
	// Then we want the point closest to -infinity,-infinity
	var/xmin = min(x0, x1)
	var/ymin = min(y0, y1)

	// Then invert the numbers
	var/transit_x = bottomleft.x + SHUTTLE_TRANSIT_BORDER + abs(xmin)
	var/transit_y = bottomleft.y + SHUTTLE_TRANSIT_BORDER + abs(ymin)

	var/turf/midpoint = locate(transit_x, transit_y, bottomleft.z)
	if(!midpoint)
		log_mapping("generate_transit_dock() failed to get a midpoint")
		return FALSE
	var/area/shuttle/transit/new_area = new()
	//new_area.parallax_movedir = travel_dir
	new_area.contents = proposal.reserved_turfs
	var/obj/docking_port/stationary/transit/new_transit_dock = new(midpoint)
	new_transit_dock.reserved_area = proposal
	new_transit_dock.name = "Transit for [M.id]/[M.name]"
	new_transit_dock.owner = M
	new_transit_dock.assigned_area = new_area

	// Add 180, because ports point inwards, rather than outwards
	new_transit_dock.setDir(angle2dir(dock_angle))

	// Proposals use 2 extra hidden tiles of space, from the cordons that surround them
	transit_utilized += (proposal.width + 2) * (proposal.height + 2)
	M.assigned_transit = new_transit_dock
	RegisterSignal(proposal, COMSIG_PARENT_QDELETING, PROC_REF(transit_space_clearing))

	return new_transit_dock

/// Gotta manage our space brother
/datum/controller/subsystem/shuttle/proc/transit_space_clearing(datum/turf_reservation/source)
	SIGNAL_HANDLER
	transit_utilized -= (source.width + 2) * (source.height + 2)

/datum/controller/subsystem/shuttle/Recover()
	if (istype(SSshuttle.mobile))
		mobile = SSshuttle.mobile
	if (istype(SSshuttle.stationary))
		stationary = SSshuttle.stationary
	if (istype(SSshuttle.transit))
		transit = SSshuttle.transit
	if (istype(SSshuttle.transit_requesters))
		transit_requesters = SSshuttle.transit_requesters
	if (istype(SSshuttle.transit_request_failures))
		transit_request_failures = SSshuttle.transit_request_failures

	lockdown = SSshuttle.lockdown

	selected = SSshuttle.selected

	existing_shuttle = SSshuttle.existing_shuttle

	preview_shuttle = SSshuttle.preview_shuttle
	preview_template = SSshuttle.preview_template

	preview_reservation = SSshuttle.preview_reservation

/datum/controller/subsystem/shuttle/proc/is_in_shuttle_bounds(atom/A)
	var/area/current = get_area(A)
	if(istype(current, /area/shuttle) && !istype(current, /area/shuttle/transit))
		return TRUE
	for(var/obj/docking_port/mobile/M in mobile)
		if(M.is_in_shuttle_bounds(A))
			return TRUE

/datum/controller/subsystem/shuttle/proc/get_containing_shuttle(atom/A)
	var/list/mobile_cache = mobile
	for(var/i in 1 to mobile_cache.len)
		var/obj/docking_port/port = mobile_cache[i]
		if(port.is_in_shuttle_bounds(A))
			return port

/datum/controller/subsystem/shuttle/proc/get_containing_dock(atom/A)
	. = list()
	var/list/stationary_cache = stationary
	for(var/i in 1 to stationary_cache.len)
		var/obj/docking_port/port = stationary_cache[i]
		if(port.is_in_shuttle_bounds(A))
			. += port

/datum/controller/subsystem/shuttle/proc/get_dock_overlap(x0, y0, x1, y1, z)
	. = list()
	var/list/stationary_cache = stationary
	for(var/i in 1 to stationary_cache.len)
		var/obj/docking_port/port = stationary_cache[i]
		if(!port || port.z != z)
			continue
		var/list/bounds = port.return_coords()
		var/list/overlap = get_overlap(x0, y0, x1, y1, bounds[1], bounds[2], bounds[3], bounds[4])
		var/list/xs = overlap[1]
		var/list/ys = overlap[2]
		if(xs.len && ys.len)
			.[port] = overlap

/datum/controller/subsystem/shuttle/proc/update_hidden_docking_ports(list/remove_turfs, list/add_turfs)
	var/list/remove_images = list()
	var/list/add_images = list()

	if(remove_turfs)
		for(var/T in remove_turfs)
			var/list/L = hidden_shuttle_turfs[T]
			if(L)
				remove_images += L[1]
		hidden_shuttle_turfs -= remove_turfs

	if(add_turfs)
		for(var/V in add_turfs)
			var/turf/T = V
			var/image/I
			if(remove_images.len)
				//we can just reuse any images we are about to delete instead of making new ones
				I = remove_images[1]
				remove_images.Cut(1, 2)
				I.loc = T
			else
				I = image(loc = T)
				add_images += I
			I.appearance = T.appearance
			I.override = TRUE
			hidden_shuttle_turfs[T] = list(I, T.type)

	hidden_shuttle_turf_images -= remove_images
	hidden_shuttle_turf_images += add_images

	QDEL_LIST(remove_images)


/datum/controller/subsystem/shuttle/proc/load_template_to_transit(datum/map_template/shuttle/template)
	UNTIL(!loading_shuttle)
	loading_shuttle = TRUE

	var/obj/docking_port/mobile/shuttle = action_load(template)

	if(!istype(shuttle))
		message_admins("Shuttle loading: [name] couldn't load a shuttle template")
		loading_shuttle = FALSE
		CRASH("Shuttle loading: ert shuttle failed to load")

	if(!shuttle.assigned_transit)
		generate_transit_dock(shuttle)

	if(!shuttle.assigned_transit)
		message_admins("Shuttle loading: shuttle failed to get an assigned transit dock.")
		shuttle.intoTheSunset()
		loading_shuttle = FALSE
		CRASH("Shuttle loading: ert shuttle failed to get an assigned transit dock")

	shuttle.initiate_docking(shuttle.assigned_transit)

	loading_shuttle = FALSE

	if(!shuttle.assigned_transit)
		message_admins("Shuttle loading: shuttle no longer has an assigned transit, trying to get it a new one")
		generate_transit_dock(shuttle)
		if(!shuttle.assigned_transit)
			message_admins("Shuttle loading: shuttle possibly failed because it no longer has an assigned transit, deleting it.")
			shuttle.intoTheSunset()
			CRASH("Shuttle loading: shuttle possibly failed because it no longer has an assigned transit, deleting it.")

	return shuttle

/**
 * Loads a shuttle template and sends it to a given destination port, optionally replacing the existing shuttle
 *
 * Arguments:
 * * loading_template - The shuttle template to load
 * * destination_port - The station docking port to send the shuttle to once loaded
 * * to_replace - A shuttle to replace, otherwise we create a new one
*/
/datum/controller/subsystem/shuttle/proc/action_load(datum/map_template/shuttle/loading_template, obj/docking_port/stationary/destination_port, obj/docking_port/mobile/to_replace)
	// Check for an existing preview
	if(preview_shuttle && (loading_template != preview_template))
		preview_shuttle.jumpToNullSpace()
		preview_shuttle = null
		preview_template = null
		QDEL_NULL(preview_reservation)

	if(!preview_shuttle)
		load_template(loading_template)
		preview_template = loading_template

	// get the existing shuttle information, if any
	var/timer = 0
	var/mode = SHUTTLE_IDLE
	var/obj/docking_port/stationary/dest_dock

	if(istype(destination_port))
		dest_dock = destination_port
	else if(to_replace)
		timer = to_replace.timer
		mode = to_replace.mode
		dest_dock = to_replace.get_docked()

	if(!dest_dock)
		dest_dock = generate_transit_dock(preview_shuttle)

	if(!dest_dock)
		CRASH("No dock found for preview shuttle ([preview_template.name]), aborting.")

	var/result = preview_shuttle.canDock(dest_dock)
	// truthy value means that it cannot dock for some reason
	// but we can ignore the someone else docked error because we'll
	// be moving into their place shortly
	if((result != SHUTTLE_CAN_DOCK) && (result != SHUTTLE_SOMEONE_ELSE_DOCKED))
		WARNING("Template shuttle [preview_shuttle] cannot dock at [dest_dock] ([result]).")
		return

	if(to_replace)
		to_replace.jumpToNullSpace()

	for(var/area/cur_area as anything in preview_shuttle.shuttle_areas)
		for(var/turf/cur_turf as anything in cur_area)
			// update underlays
			if(istype(cur_turf, /turf/closed/shuttle))
				var/dx = cur_turf.x - preview_shuttle.x
				var/dy = cur_turf.y - preview_shuttle.y
				var/turf/target_lz = locate(dest_dock.x + dx, dest_dock.y + dy, dest_dock.z)
				cur_turf.underlays.Cut()
				cur_turf.underlays += mutable_appearance(target_lz.icon, target_lz.icon_state, TURF_LAYER, FLOOR_PLANE)

	preview_shuttle.register(to_replace != null)
	var/list/force_memory = preview_shuttle.movement_force
	preview_shuttle.movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	preview_shuttle.mode = SHUTTLE_PREARRIVAL//No idle shuttle moving. Transit dock get removed if shuttle moves too long.
	preview_shuttle.initiate_docking(dest_dock)
	preview_shuttle.movement_force = force_memory

	. = preview_shuttle

	// Shuttle state involves a mode and a timer based on world.time, so
	// plugging the existing shuttles old values in works fine.
	preview_shuttle.timer = timer
	preview_shuttle.mode = mode

	preview_shuttle.postregister(to_replace != null)

	// TODO indicate to the user that success happened, rather than just
	// blanking the modification tab
	preview_shuttle = null
	preview_template = null
	existing_shuttle = null
	selected = null
	QDEL_NULL(preview_reservation)

/**
 * Loads a shuttle template into the transit Z level, usually referred to elsewhere in the code as a shuttle preview.
 * Does not register the shuttle so it can't be used yet, that's handled in action_load()
 *
 * Arguments:
 * * loading_template - The shuttle template to load
 */
/datum/controller/subsystem/shuttle/proc/load_template(datum/map_template/shuttle/loading_template)
	. = FALSE
	// Load shuttle template to a fresh block reservation.
	preview_reservation = SSmapping.request_turf_block_reservation(
		loading_template.width,
		loading_template.height,
		1,
		reservation_type = /datum/turf_reservation/transit,
	)
	if(!preview_reservation)
		CRASH("failed to reserve an area for shuttle template loading")
	var/turf/bottom_left = preview_reservation.bottom_left_turfs[1]
	loading_template.load(bottom_left, centered = FALSE, register = FALSE)

	var/affected = loading_template.get_affected_turfs(bottom_left, centered=FALSE)

	var/found = 0
	// Search the turfs for docking ports
	// - We need to find the mobile docking port because that is the heart of
	//   the shuttle.
	// - We need to check that no additional ports have slipped in from the
	//   template, because that causes unintended behaviour.
	for(var/affected_turfs in affected)
		for(var/obj/docking_port/port in affected_turfs)
			if(istype(port, /obj/docking_port/mobile))
				found++
				if(found > 1)
					qdel(port, force=TRUE)
					log_mapping("Shuttle Template [loading_template.mappath] has multiple mobile docking ports.")
				else
					preview_shuttle = port
			if(istype(port, /obj/docking_port/stationary))
				log_mapping("Shuttle Template [loading_template.mappath] has a stationary docking port.")
	if(!found)
		var/msg = "load_template(): Shuttle Template [loading_template.mappath] has no mobile docking port. Aborting import."
		for(var/affected_turfs in affected)
			var/turf/T0 = affected_turfs
			T0.empty()

		message_admins(msg)
		WARNING(msg)
		return
	//Everything fine
	loading_template.post_load(preview_shuttle)
	return TRUE

/**
 * Removes the preview_shuttle from the transit Z-level
 */
/datum/controller/subsystem/shuttle/proc/unload_preview()
	if(preview_shuttle)
		preview_shuttle.jumpToNullSpace()
	preview_shuttle = null
	if(preview_reservation)
		QDEL_NULL(preview_reservation)

/datum/controller/subsystem/shuttle/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/controller/subsystem/shuttle/ui_state(mob/user)
	return GLOB.admin_state

/datum/controller/subsystem/shuttle/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShuttleManipulator", name, 900, 600)
		ui.open()

/datum/controller/subsystem/shuttle/ui_data(mob/user)
	var/list/data = list()

	// Templates panel
	data["templates"] = list()
	var/list/templates = data["templates"]
	//data["templates_tabs"] = list()
	data["selected"] = null

	for(var/id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/S = SSmapping.shuttle_templates[id]

		if(!templates[S.port_id])
			//data["templates_tabs"] += S.port_id
			templates[S.port_id] = list(
				"port_id" = S.port_id,
				"templates" = list())

		var/list/L = list()
		L["name"] = S.name
		L["id"] = S.shuttle_id
		L["port_id"] = S.port_id
		L["description"] = S.description
		L["admin_notes"] = S.admin_notes

		if(selected == S)
			data["selected"] = L

		templates[S.port_id]["templates"] += list(L)

	//data["templates_tabs"] = sort_list(data["templates_tabs"])

	data["existing_shuttle"] = null

	// Status panel
	data["shuttles"] = list()
	for(var/i in mobile)
		var/obj/docking_port/mobile/M = i
		var/timeleft = M.timeLeft(1)
		var/list/L = list()
		L["name"] = M.name
		L["id"] = M.id
		L["timer"] = M.timer
		L["timeleft"] = M.getTimerStr()
		if (timeleft > 1 HOURS)
			L["timeleft"] = "Infinity"
		L["can_fast_travel"] = M.timer && timeleft >= 50
		L["can_fly"] = TRUE

		var/obj/structure/machinery/computer/shuttle/console = M.getControlConsole()
		L["has_disable"] = FALSE
		if(console)
			L["has_disable"] = TRUE
			L["is_disabled"] = console.is_disabled()

		if(!M.destination)
			L["can_fast_travel"] = FALSE
		if (M.mode != SHUTTLE_IDLE)
			L["mode"] = capitalize(M.mode)
		L["status"] = M.getDbgStatusText()
		if(M == existing_shuttle)
			data["existing_shuttle"] = L

		data["shuttles"] += list(L)

	return data

/datum/controller/subsystem/shuttle/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	// Preload some common parameters
	var/id = params["id"]
	var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[id]
	var/obj/docking_port/mobile/shuttle = getShuttle(id, warn = FALSE)

	switch(action)
		if("select_template")
			if(template)
				existing_shuttle = shuttle
				selected = template
				if(!existing_shuttle)
					existing_shuttle = get_template_shuttle(template.shuttle_id)
				. = TRUE

		if("jump_to")
			if(shuttle)
				user.client?.jump_to_object(shuttle)
				. = TRUE

		if("lock")
			if(shuttle)
				. = TRUE
				var/obj/structure/machinery/computer/shuttle/console = shuttle.getControlConsole()
				console.disable()
				message_admins("[key_name_admin(user)] set [id]'s disabled to TRUE.")

		if("unlock")
			if(shuttle)
				. = TRUE
				var/obj/structure/machinery/computer/shuttle/console = shuttle.getControlConsole()
				console.enable()
				message_admins("[key_name_admin(user)] set [id]'s disabled to FALSE.")

		if("fly")
			if(shuttle)
				. = TRUE
				shuttle.admin_fly_shuttle(user)

		if("fast_travel")
			if(shuttle && shuttle.timer && shuttle.timeLeft(1) >= 50)
				shuttle.setTimer(5 SECONDS)
				. = TRUE
				message_admins("[key_name_admin(user)] fast travelled [shuttle]")

		if("load")
			if(template)
				if(loading_shuttle)
					to_chat(user, SPAN_WARNING("Busy! Please wait..."))
					return
				. = TRUE
				loading_shuttle = TRUE
				// If successful, returns the mobile docking port
				var/obj/docking_port/mobile/mdp = action_load(template)
				if(mdp)
					user.client?.jump_to_object(mdp)
					message_admins("[key_name_admin(user)] loaded [mdp] with the shuttle manipulator.")
				else
					to_chat(user, SPAN_WARNING("Something went wrong. Check logs/STUI for more details."))
				loading_shuttle = FALSE

		if("preview")
			if(template)
				if(loading_shuttle)
					to_chat(user, SPAN_WARNING("Busy! Please wait..."))
					return
				. = TRUE
				loading_shuttle = TRUE
				unload_preview()
				load_template(template)
				if(preview_shuttle)
					preview_template = template
					user.client?.jump_to_object(preview_shuttle)
				loading_shuttle = FALSE

		if("replace")
			if(template)
				if(loading_shuttle)
					to_chat(user, SPAN_WARNING("Busy! Please wait..."))
					return
				. = TRUE
				loading_shuttle = TRUE
				var/to_replace = existing_shuttle
				if(!existing_shuttle || tgui_alert(user, "Replace existing shuttle '[existing_shuttle.name]'?", "Replace shuttle?", list("Yes", "No")) != "Yes")
					var/list/options = list()
					for(var/obj/docking_port/mobile/option in mobile)
						options["[option.name] ([option.id])"] = option
					var/selection = tgui_input_list(user, "Replace some other shuttle instead?", "Replace shuttle?", options)
					if(!selection)
						loading_shuttle = FALSE
						return
					to_replace = options[selection]
				// If successful, returns the mobile docking port
				var/obj/docking_port/mobile/mdp = action_load(template, to_replace = to_replace)
				if(mdp)
					user.client?.jump_to_object(mdp)
					message_admins("[key_name_admin(user)] replaced [to_replace] with [mdp] with the shuttle manipulator.")
				else
					to_chat(user, SPAN_WARNING("Something went wrong. Check logs/STUI for more details."))
				loading_shuttle = FALSE

#undef MAX_TRANSIT_REQUEST_RETRIES
#undef MAX_TRANSIT_TILE_COUNT
#undef SOFT_TRANSIT_RESERVATION_THRESHOLD
