/**
 * Sentry gun computer which links to defensive structures.
 */
/obj/item/device/sentry_computer
	name = "\improper Sentry Gun Network Laptop"
	desc = "A laptop loaded with sentry control software."
	icon = 'icons/obj/structures/props/sentrycomp.dmi'
	icon_state = "sentrycomp_cl"
	w_class = SIZE_SMALL

	/// if the laptop has been placed on a table
	var/setup = FALSE

	/// if the laptop has been opened (the model not tgui)
	var/open = FALSE

	/// if the laptop is turned on and powered
	var/on = FALSE

	/// list of paired defences
	var/list/paired_sentry = list()

	/// defensive structure which has the camera active
	var/obj/structure/machinery/defenses/sentry/current
	var/cell_type = /obj/item/cell/high

	/// battery in the laptop
	var/obj/item/cell/cell

	/// multiplier for how much power to drain per linked device
	var/power_consumption = 1
	var/list/registered_tools = list()

	/// if the laptop should announce events on radio, for live server testing
	var/silent = FALSE

	var/can_identify_target = FALSE // if the laptop should broadcast what it is shooting at

	var/list/faction_group
	var/screen_state = 0 // controls the 'loading' animation

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf

	// radio which broadcasts updates
	var/obj/item/device/radio/marine/transceiver = new /obj/item/device/radio/marine
	// the hidden mob which voices updates
	var/mob/living/voice = new /mob/living/silicon

	// Stuff needed to render the map

	/// asset name for the game map
	var/map_name

	/// camera screen which renders the world
	var/atom/movable/screen/map_view/cam_screen

	/// camera screen which shows a blank error
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
	transceiver.config(list(RADIO_CHANNEL_SENTRY=1))
	transceiver.subspace_transmission = TRUE
	voice.name = "[name]:[serial_number]"
	voice.forceMove(src)

/obj/item/device/sentry_computer/Destroy()
	. = ..()
	QDEL_NULL(cell)
	QDEL_NULL(cam_background)
	QDEL_NULL(cam_screen)
	QDEL_NULL(transceiver)
	QDEL_NULL(voice)
	last_camera_turf = null
	current = null
	registered_tools = null
	paired_sentry = null

/obj/item/device/sentry_computer/Move(NewLoc, direct)
	..()
	if(setup || open || on)
		teardown()

/**
 * Set the laptop up on a table.
 * @param target: table which is being used to host the laptop.
 */
/obj/item/device/sentry_computer/proc/setup(obj/structure/surface/target)
	if (do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		setup = TRUE
		usr.drop_inv_item_to_loc(src, target.loc)
	else
		to_chat(usr, SPAN_WARNING("You fail to setup the laptop"))

/**
 * Called to reset the state of the laptop to closed and inactive.
 */
/obj/item/device/sentry_computer/proc/teardown()
	setup = FALSE
	open = FALSE
	on = FALSE
	icon_state = "sentrycomp_cl"
	STOP_PROCESSING(SSobj, src)
	playsound(src,  'sound/machines/terminal_off.ogg', 25, FALSE)

/obj/item/device/sentry_computer/MouseDrop(over_object)
	if(over_object == usr && Adjacent(usr))
		teardown()
		usr.put_in_any_hand_if_possible(src, disable_warning = TRUE)

/obj/item/device/sentry_computer/emp_act(severity)
	return TRUE

/**
 * Handler for when a linked sentry gun engages a target.
 * @param sentrygun: gun which has fired.
 */
/obj/item/device/sentry_computer/proc/handle_engaged(obj/structure/machinery/defenses/sentry/sentrygun)
	var/displayname = sentrygun.name
	if(length(sentrygun.nickname))
		displayname = sentrygun.nickname
	var/message = "[displayname]:[get_area(sentrygun)] Engaged"
	if(can_identify_target)
		message += " [sentrygun.target]"
	INVOKE_ASYNC(src, PROC_REF(send_message), message)

/**
 * Handler for when a linked sentry has low ammo.
 * @param sentrygun: gun which is low on ammo.
 */
/obj/item/device/sentry_computer/proc/handle_low_ammo(obj/structure/machinery/defenses/sentry/sentrygun)
	if(!sentrygun.ammo)
		return
	var/displayname = sentrygun.name
	if(length(sentrygun.nickname))
		displayname = sentrygun.nickname
	var/areaname = get_area(sentrygun)
	var/message = "[displayname]:[areaname] Low ammo [sentrygun.ammo.current_rounds]/[sentrygun.ammo.max_rounds]."
	INVOKE_ASYNC(src, PROC_REF(send_message), message)

/**
 * Handler for when a linked sentry has no ammo.
 * @param sentrygun: sentry gun which has ran out of ammo.
 */
/obj/item/device/sentry_computer/proc/handle_empty_ammo(obj/structure/machinery/defenses/sentry/sentrygun)
	var/displayname = sentrygun.name
	if(length(sentrygun.nickname))
		displayname = sentrygun.nickname
	var/areaname = get_area(sentrygun)
	var/message = "[displayname]:[areaname] out of ammo."
	INVOKE_ASYNC(src, PROC_REF(send_message), message)

/**
 * Broadcast a message to those nearby and on sentry radio.
 * @param message: message to broadcast.
 */
/obj/item/device/sentry_computer/proc/send_message(message)
	if(!silent && transceiver)
		transceiver.talk_into(voice, "[message]", RADIO_CHANNEL_SENTRY)
		voice.say(message)

/obj/item/device/sentry_computer/attack_hand(mob/user)
	if(!setup)
		return ..()
	if(!on)
		icon_state = "sentrycomp_on"
		on = TRUE
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
	else
		tgui_interact(user)

/obj/item/device/sentry_computer/get_examine_text()
	. = ..()
	if(cell)
		. += "A [cell.name] is loaded. It has [cell.charge]/[cell.maxcharge] charge remaining."
	else
		. += "It has no battery inserted."

	if(setup)
		. += "The laptop can be dragged towards you to pick it up."
	else
		. += "The laptop must be placed on a table to be used."

/obj/item/device/sentry_computer/process()
	if(!on || !cell)
		return

	var/energy_cost = length(paired_sentry) * power_consumption * CELLRATE
	if(cell.charge >= (energy_cost))
		cell.use(energy_cost)
	else
		icon_state = "sentrycomp_op"
		on = FALSE
		playsound(src,  'sound/machines/terminal_off.ogg', 25, FALSE)

/obj/item/device/sentry_computer/attackby(obj/item/object, mob/user)
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
		playsound(src, 'sound/machines/keyboard2.ogg', 25, FALSE)

		if(tool.remove_encryption_key(serial_number))
			to_chat(user, SPAN_NOTICE("You begin unloading the encryption key from \the [tool]."))
			if (do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
				to_chat(user, SPAN_NOTICE("You unload the encryption key from \the [tool]."))
				registered_tools -= list(id)
		else
			if(length(tool.encryption_keys))
				to_chat(user, SPAN_NOTICE("Removing existing encryption keys."))
				if (do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
					for(var/key_id in tool.encryption_keys)
						var/datum/weakref/ref = tool.encryption_keys[key_id]
						var/obj/item/device/sentry_computer/key_object = ref.resolve()
						key_object.registered_tools -= id
					tool.encryption_keys = list()
				to_chat(user, SPAN_NOTICE("Existing encryption keys cleared."))
			to_chat(usr, SPAN_NOTICE("You begin encryption key to \the [tool]."))
			if (do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
				to_chat(user, SPAN_NOTICE("You load an encryption key to \the [tool]."))
				registered_tools += list(id)
				tool.load_encryption_key(serial_number, src)
	else
		..()

/**
 * Run checks and register a sentry gun to this sentry computer.
 * @param tool: tool which was used to link.
 * @param user: mob which initiated the link.
 * @param defensive_structure: defensive structure which is to be linked.
 */
/obj/item/device/sentry_computer/proc/register(tool, mob/user, defensive_structure)
	if (!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	var/obj/structure/machinery/defenses/defense = defensive_structure
	pair_sentry(defense)
	to_chat(user, SPAN_NOTICE("[defense] has been encrypted."))
	var/message = "[defense] added to [src]"
	INVOKE_ASYNC(src, PROC_REF(send_message), message)

/**
 * Run checks and unregister a sentry gun from this sentry computer.
 * @param tool: tool which was used to unlink.
 * @param user: mob which initiated the unlink.
 * @param defensive_structure: defensive structure which is to be unlinked.
 */
/obj/item/device/sentry_computer/proc/unregister(tool, mob/user, sentry_gun)
	var/obj/structure/machinery/defenses/sentry/sentry = sentry_gun
	if(sentry.linked_laptop != src)
		to_chat(user, SPAN_WARNING("[sentry] is already encrypted by laptop [sentry.linked_laptop.serial_number]."))
		return

	if (do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		unpair_sentry(sentry)
		to_chat(user, SPAN_NOTICE("[sentry] has been decrypted."))
		var/message = "[sentry] removed from from [src]"
		INVOKE_ASYNC(src, PROC_REF(send_message), message)

/**
 * Handler for when a linked sentry gun is destroyed.
 * @param sentry_gun: sentry gun which is currently being destroyed.
 */
/obj/item/device/sentry_computer/proc/sentry_destroyed(sentry_gun)
	var/obj/structure/machinery/defenses/sentry/sentry = sentry_gun
	if(sentry.linked_laptop == src)
		unpair_sentry(sentry)
	var/displayname = sentry.name
	if(length(sentry.nickname))
		displayname = sentry.nickname
	var/areaname = get_area(sentry)
	var/message = "[displayname]:[areaname] lost contact."
	INVOKE_ASYNC(src, PROC_REF(send_message), message)
	playsound(src,  'sound/machines/buzz-two.ogg', 25, FALSE)

/**
 * Links the target sentry gun to this laptop, linking signals and storing data.
 * @params target: defensive structure to link.
 */
/obj/item/device/sentry_computer/proc/pair_sentry(obj/structure/machinery/defenses/target)
	target.linked_laptop = src
	paired_sentry += list(target)
	update_static_data_for_all_viewers()
	RegisterSignal(target, COMSIG_SENTRY_ENGAGED_ALERT, PROC_REF(handle_engaged))
	RegisterSignal(target, COMSIG_SENTRY_LOW_AMMO_ALERT, PROC_REF(handle_low_ammo))
	RegisterSignal(target, COMSIG_SENTRY_EMPTY_AMMO_ALERT, PROC_REF(handle_empty_ammo))
	RegisterSignal(target, COMSIG_SENTRY_DESTROYED_ALERT, PROC_REF(sentry_destroyed))

/**
 * Unlinks the target sentry gun from this laptop, unlinking signals and removing from internal storage lists.
 * @params target: defensive structure to unlink
 */
/obj/item/device/sentry_computer/proc/unpair_sentry(obj/structure/machinery/defenses/target)
	target.linked_laptop = null
	paired_sentry -= list(target)
	update_static_data_for_all_viewers()
	UnregisterSignal(target, COMSIG_SENTRY_ENGAGED_ALERT)
	UnregisterSignal(target, COMSIG_SENTRY_LOW_AMMO_ALERT)
	UnregisterSignal(target, COMSIG_SENTRY_EMPTY_AMMO_ALERT)
	UnregisterSignal(target, COMSIG_SENTRY_DESTROYED_ALERT)

	if(current == target)
		current = null
		update_active_camera()

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
		sentry_holder["health_max"] = sentrygun.health_max
		index++

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

	for(var/obj/structure/machinery/defenses/defense as anything in paired_sentry)
		var/list/sentry_holder = list()
		if(current == defense)
			.["camera_target"] = index
		index++

		sentry_holder["area"] = get_area(defense)
		sentry_holder["active"] = defense.turned_on
		sentry_holder["nickname"] = defense.nickname
		sentry_holder["camera_available"] = defense.has_camera && defense.placed
		sentry_holder["selection_state"] = list()
		sentry_holder["kills"] = defense.kills
		sentry_holder["iff_status"] = defense.faction_group
		sentry_holder["health"] = defense.health

		for(var/category in defense.selected_categories)
			sentry_holder["selection_state"] += list(list("[category]", defense.selected_categories[category]))

		if(istype(defense, /obj/structure/machinery/defenses/sentry))
			var/obj/structure/machinery/defenses/sentry/sentrygun = defense
			sentry_holder["rounds"] = sentrygun.ammo.current_rounds
			sentry_holder["max_rounds"] = sentrygun.ammo.max_rounds
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
			var/obj/structure/machinery/defenses/sentry = paired_sentry[sentry_index]
			var/result = sentry.update_choice(usr, action, params["selection"])
			if(result)
				playsound(src, get_sfx("terminal_button"), 25, FALSE)
				return TRUE
			switch(action)
				if("set-camera")
					current = sentry
					playsound(src, get_sfx("terminal_button"), 25, FALSE)
					update_active_camera()
					return TRUE
				if("ping")
					playsound(sentry, 'sound/machines/twobeep.ogg', 50, 1)
					return FALSE

	switch(action)
		if("screen-state")
			screen_state = params["state"]
			return FALSE
		if("clear-camera")
			current = null
			playsound(src, get_sfx("terminal_button"), 25, FALSE)
			update_active_camera()
			return TRUE
		if("ui-interact")
			playsound(src, get_sfx("terminal_button"), 25, FALSE)
			return FALSE

/**
 * Set the displayed camera to the static not-connected.
 */
/obj/item/device/sentry_computer/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	last_camera_turf = null
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, 15, 15)

/**
 * Update camera settings and redraw camera on the current variable.
 */
/obj/item/device/sentry_computer/proc/update_active_camera()
	// Show static if can't use the camera
	if(isnull(current) || !current.has_camera || current.placed != 1)
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
	if(last_camera_turf == get_turf(cam_location))
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
		var/area/visible_area = visible_turf.loc
		if(!visible_area.lighting_use_dynamic || visible_turf.lighting_lumcount >= 1)
			visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1
	cam_screen.icon = null
	cam_screen.icon_state = "clear"
	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)
