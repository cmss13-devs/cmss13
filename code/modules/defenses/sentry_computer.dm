#define DEFAULT_MAP_SIZE 15
// can we refactor out the camera information to a datum? It would be really cool.
/datum/camera_holder
	// Stuff needed to render the map
	var/map_name
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf

	/// All turfs within range of the currently active camera
	var/list/range_turfs = list()

/datum/camera_holder/proc/Setup(var/mapName)
	map_name = mapName
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

/datum/camera_holder/Destroy(force, ...)
	. = ..(force)
	qdel(cam_background)
	qdel(cam_screen)

/obj/item/device/sentry_computer
	name = "Sentry Computer"
	desc = "A laptop loaded with sentry control software."
	icon = 'icons/obj/structures/props/sentrycomp.dmi'
	icon_state = "sentrycomp_cl"
	var/setup = FALSE
	var/open = FALSE
	var/on = FALSE
	var/obj/structure/machinery/defenses/sentry/paired_sentry = list()
	var/obj/structure/machinery/defenses/sentry/current
	var/cell_type = /obj/item/cell/high
	var/obj/item/cell/cell
	var/power_consumption = 1
	w_class = SIZE_SMALL
	var/state = 0
	var/screen_state = 0
	var/list/registered_tools = list()
	var/list/faction_group

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf

	var/obj/item/device/radio/transceiver = new /obj/item/device/radio
	var/mob/living/voice = new /mob/living/silicon

	// Stuff needed to render the map
	var/map_name
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background

	/// All turfs within range of the currently active camera
	var/list/range_turfs = list()

/obj/item/device/sentry_computer/Initialize(mapload)
	. = ..()
	if(cell_type)
		cell = new cell_type()
		cell.charge = cell.maxcharge
	// set up cameras
	map_name = "sentry_computer_[REF(src)]_map"
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

	faction_group = FACTION_LIST_MARINE
	transceiver.forceMove(src)
	transceiver.set_frequency(SENTRY_FREQ)
	transceiver.config(list(RADIO_CHANNEL_SENTY=1))
	voice.name = "Laptop [serial_number]"
	voice.forceMove(src)

	RegisterSignal(src, COMSIG_SENTRY_ENGAGED_ALERT, .proc/handle_engaged)

/obj/item/device/sentry_computer/Destroy()
	. = ..()
	QDEL_NULL(cell)
	qdel(cam_background)
	qdel(cam_screen)
	qdel(transceiver)
	qdel(voice)

/obj/item/device/sentry_computer/proc/has_los(var/atom/watcher, var/atom/target)
	var/list/turf/path = getline2(watcher, target, include_from_atom = FALSE)
	for(var/turf/point in path)
		if(point.opacity)
			return FALSE
	return TRUE

/obj/item/device/sentry_computer/proc/setup(var/obj/structure/surface/target)
	if (do_after(usr, 2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		setup = TRUE
		usr.drop_inv_item_to_loc(src, target.loc)
	else
		to_chat(usr, SPAN_WARNING("You fail to setup the laptop"))

/obj/item/device/sentry_computer/MouseDrop(atom/dropping, mob/user)
	setup = FALSE
	open = FALSE
	on = FALSE
	icon_state = "sentrycomp_cl"
	STOP_PROCESSING(SSobj, src)
	usr.put_in_any_hand_if_possible(src, disable_warning = TRUE)

/obj/item/device/sentry_computer/proc/handle_engaged(var/laptop, var/obj/structure/machinery/defenses/sentry/sentrygun)
	var/displayname = sentrygun.name
	if(length(sentrygun.nickname) > 0)
		displayname = sentrygun.nickname
	var/areaname = get_area(sentrygun)
	var/message = "[displayname]:[areaname] Engaged"
	INVOKE_ASYNC(src, .proc/send_message, message)

/obj/item/device/sentry_computer/proc/send_message(var/message)
	if(transceiver)
		transceiver.talk_into(voice, "[message]", RADIO_CHANNEL_SENTY)

/obj/item/device/sentry_computer/attack_hand(mob/user)
	if(setup)
		if(!on)
			icon_state = "sentrycomp_on"
			on = TRUE
			START_PROCESSING(SSobj, src)
		else
			tgui_interact(user)
	else
		..()

/obj/item/device/sentry_computer/get_examine_text()
	. = ..()
	if(cell)
		. += "A [cell.name] is loaded. It has [cell.charge]/[cell.maxcharge] charge remaining."
	else
		. += "It has no battery inserted."

/obj/item/device/sentry_computer/process()
	if(on)
		if(cell)
			var/energy_cost = length(paired_sentry) * power_consumption * CELLRATE
			if(cell.charge >= (energy_cost))
				cell.use(energy_cost)
			else
				icon_state = "sentrycomp_op"
				on = FALSE

/obj/item/device/sentry_computer/attackby(var/obj/item/object, mob/user)
	if(istype(object, /obj/item/cell))
		var/obj/item/cell/new_cell = object
		to_chat(user, SPAN_NOTICE("The new cell contains: [new_cell.charge] power."))
		cell.forceMove(get_turf(user))
		cell = new_cell
		user.drop_inv_item_to_loc(new_cell, src)
		playsound(src,'sound/machines/click.ogg', 25, 1)
	else if(istype(object, /obj/item/device/multitool))
		var/obj/item/device/multitool/tool = object
		var/id = tool.serial_number
		playsound(src, get_sfx("terminal_type"), 25, FALSE)
		if (do_after(usr, 2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(tool.remove_encryption_key(serial_number))
				to_chat(user, SPAN_NOTICE("You unload the encryption key to the [tool]."))
				registered_tools -= list(id)
			else
				to_chat(user, SPAN_NOTICE("You load an encryption key to the [tool]."))
				registered_tools += list(id)
				tool.load_encryption_key(serial_number, src)
	else
		..()

/obj/item/device/sentry_computer/proc/register(var/tool, mob/user, var/sentry_gun)
	if (do_after(user, 2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		var/obj/structure/machinery/defenses/sentry/sentry = sentry_gun
		pair_sentry(sentry)
		to_chat(user, SPAN_NOTICE("\The [sentry] has been encrypted."))
		var/message = "[sentry] added to [src]"
		INVOKE_ASYNC(src, .proc/send_message, message)

/obj/item/device/sentry_computer/proc/unregister(var/tool, mob/user, var/sentry_gun)
	var/obj/structure/machinery/defenses/sentry/sentry = sentry_gun
	if(sentry.linked_laptop == src)
		if (do_after(user, 2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			unpair_sentry(sentry)
			to_chat(user, SPAN_NOTICE("\The [sentry] has been decrypted."))
			var/message = "[sentry] removed from from [src]"
			INVOKE_ASYNC(src, .proc/send_message, message)
	else
		to_chat(user, SPAN_WARNING("\The [sentry] is already encrypted by laptop [sentry.linked_laptop.serial_number]."))

/obj/item/device/sentry_computer/proc/pair_sentry(var/obj/structure/machinery/defenses/sentry/target)
	target.linked_laptop = src
	paired_sentry +=list(target)
	update_static_data_for_all_viewers()

/obj/item/device/sentry_computer/proc/unpair_sentry(var/obj/structure/machinery/defenses/sentry/target)
	target.linked_laptop = null
	paired_sentry -=list(target)
	update_static_data_for_all_viewers()

/obj/item/device/sentry_computer/proc/attempted_link(mob/linker)
	playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)

/obj/item/device/sentry_computer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!on)
		return UI_CLOSE
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		return UI_UPDATE


/obj/item/device/sentry_computer/ui_close(mob/user)

	// Unregister map objects
	user.client.clear_map(map_name)


/obj/item/device/sentry_computer/ui_static_data(mob/user)
	. = list()
	.["sentry_static"] = list()
	.["mapRef"] = map_name
	var/index = 1
	for(var/sentry in paired_sentry)
		var/list/sentry_holder = list()
		var/obj/structure/machinery/defenses/sentry/sentrygun = sentry
		sentry_holder["selection_menu"] = list()
		sentry_holder["index"] = index
		sentry_holder["name"] = sentrygun.name
		index += 1

		for(var/i in sentrygun.choice_categories)
			sentry_holder["selection_menu"] += list(list("[i]", sentrygun.choice_categories[i]))
		.["sentry_static"] += list(sentry_holder)

/obj/item/device/sentry_computer/ui_data(mob/user)
	. = list()
	.["sentry"] = list()
	.["electrical"] = list("charge" = 0, "max_charge" = 0)
	if(cell)
		.["electrical"]["charge"] = cell.charge
		.["electrical"]["max_charge"] = cell.maxcharge
	// if screen animation has played
	.["screen_state"] = screen_state
	.["camera_target"] = null

	var/index = 1

	for(var/sentry in paired_sentry)
		var/list/sentry_holder = list()
		var/obj/structure/machinery/defenses/defence = sentry
		if(current == defence)
			.["camera_target"] = index
		index += 1

		sentry_holder["area"] = get_area(defence)
		sentry_holder["active"] = defence.turned_on
		sentry_holder["nickname"] = defence.nickname
		sentry_holder["camera_available"] = defence.has_camera && defence.placed
		sentry_holder["selection_state"] = list()
		sentry_holder["kills"] = defence.kills
		sentry_holder["iff_status"] = defence.faction_group
		for(var/i in defence.selected_categories)
			sentry_holder["selection_state"] += list(list("[i]", defence.selected_categories[i]))
		if(istype(defence, /obj/structure/machinery/defenses/sentry))
			var/obj/structure/machinery/defenses/sentry/sentrygun = sentry
			sentry_holder["rounds"] = sentrygun.ammo.current_rounds
			sentry_holder["engaged"] = length(sentrygun.targets)

		.["sentry"] += list(sentry_holder)

/obj/item/device/sentry_computer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	update_active_camera()
	if (!ui)
		// Register map objects
		user.client.register_map_obj(cam_background)
		user.client.register_map_obj(cam_screen)
		ui = new(user, src, "SentryGunUI", name)
		ui.open()

/obj/item/device/sentry_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(usr, SPAN_WARNING("You are not authorised to configure the sentry."))
		return
	if(params["index"])
		// the action represents a sentry
		var/sentry_index = params["index"]
		if(paired_sentry[sentry_index])
			var/result = paired_sentry[sentry_index].update_choice(usr, action, params["selection"])
			if(result)
				playsound(src, get_sfx("terminal_type"), 25, FALSE)
				return TRUE
			switch(action)
				if("set-camera")
					current = paired_sentry[sentry_index]
					if(current.placed)
						playsound(src, get_sfx("terminal_type"), 25, FALSE)
						update_active_camera()
						return TRUE
				if("clear-camera")
					current = null
					playsound(src, get_sfx("terminal_type"), 25, FALSE)
					update_active_camera()
					return TRUE
				if("ping")
					paired_sentry[sentry_index].identify()
					return FALSE

	switch(action)
		if("screen-state")
			screen_state = params["state"]
			return FALSE
		if("clear-camera")
			current = null
			playsound(src, get_sfx("terminal_type"), 25, FALSE)
			update_active_camera()
			return TRUE


/obj/item/device/sentry_computer/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)


/obj/item/device/sentry_computer/proc/update_active_camera()
	// Show static if can't use the camera
	if(current == null || !(current?.has_camera == TRUE) || !(current?.placed == 1))
		show_camera_static()
		return

	// Is this camera located in or attached to a living thing, Vehicle or helmet? If so, assume the camera's loc is the living (or non) thing.
	var/cam_location = current
	if(isliving(current.loc) || isVehicle(current.loc))
		cam_location = current.loc
	else if(istype(current.loc, /obj/item/clothing/head/helmet/marine))
		var/obj/item/clothing/head/helmet/marine/helmet = current.loc
		cam_location = helmet.loc
	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	var/newturf = get_turf(cam_location)
	if(last_camera_turf == newturf)
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = get_turf(cam_location)
	current.set_range()
	var/datum/shape/rectangle/current_bb = current.range_bounds
	var/x_size = current_bb.width
	var/y_size = current_bb.height
	var/target = locate(current_bb.center_x, current_bb.center_y, current.loc.z)
	var/list/guncamera_zone = range("[x_size]x[y_size]", target)

	var/list/visible_turfs = list()
	range_turfs.Cut()

	for(var/turf/visible_turf in guncamera_zone)
		range_turfs += visible_turf
		if(!visible_turf.loc.lighting_use_dynamic || visible_turf.lighting_lumcount >= 1)
			visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

	// non sentry related stuff


