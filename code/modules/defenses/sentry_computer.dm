/**
 * Sentry gun computer which links to defensive structures.
 */
/obj/item/device/sentry_computer
	name = "\improper Sentry Gun Network Laptop"
	desc = "A laptop loaded with sentry control software."
	icon = 'icons/obj/structures/props/sentrycomp.dmi'
	icon_state = "sentrycomp_cl"
	w_class = SIZE_SMALL
	has_special_table_placement = TRUE

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
	var/camera_map_name

/obj/item/device/sentry_computer/Initialize(mapload)
	. = ..()
	if(cell_type)
		cell = new cell_type()
		cell.charge = cell.maxcharge

	RegisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED, PROC_REF(camera_mapname_update))

	AddComponent(/datum/component/camera_manager)
	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

	faction_group = FACTION_LIST_MARINE
	transceiver.forceMove(src)
	transceiver.set_frequency(SENTRY_FREQ)
	transceiver.config(list(RADIO_CHANNEL_SENTRY=1))
	transceiver.subspace_transmission = TRUE
	voice.name = "[name]:[serial_number]"
	voice.forceMove(src)

/obj/item/device/sentry_computer/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED)
	QDEL_NULL(cell)
	QDEL_NULL(transceiver)
	QDEL_NULL(voice)
	last_camera_turf = null
	current = null
	registered_tools = null
	for(var/obj/structure/machinery/defenses/sentry/sentrygun as anything in paired_sentry)
		unpair_sentry(sentrygun)
	paired_sentry = null

/obj/item/device/sentry_computer/proc/camera_mapname_update(source, value)
	camera_map_name = value

/obj/item/device/sentry_computer/Move(NewLoc, direct)
	..()
	if(table_setup || open || on)
		teardown()

/**
 * Called to reset the state of the laptop to closed and inactive.
 */
/obj/item/device/sentry_computer/teardown()
	. = ..()
	open = FALSE
	on = FALSE
	icon_state = "sentrycomp_cl"
	STOP_PROCESSING(SSobj, src)
	playsound(src,  'sound/machines/terminal_off.ogg', 25, FALSE)

/obj/item/device/sentry_computer/emp_act(severity)
	. = ..()
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
		transceiver.talk_into(voice, "[message]", RADIO_CHANNEL_SENTRY, tts_heard_list = list(list(), list(), list()))
		voice.say(message)

/obj/item/device/sentry_computer/attack_hand(mob/user)
	if(!table_setup)
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

	if(table_setup)
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
						key_object?.registered_tools -= id
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
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

/obj/item/device/sentry_computer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!on)
		return UI_CLOSE
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		return UI_UPDATE


/obj/item/device/sentry_computer/ui_close(mob/user)
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)


/obj/item/device/sentry_computer/ui_static_data(mob/user)
	. = list()
	.["sentry_static"] = list()
	.["mapRef"] = camera_map_name
	var/index = 1
	for(var/obj/structure/machinery/defenses/sentry/sentrygun as anything in paired_sentry)
		var/list/sentry_holder = list()
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
	if (!ui)
		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)
		ui = new(user, src, "SentryGunUI", name)
		ui.open()

/obj/item/device/sentry_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
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
					var/obj/structure/machinery/defenses/sentry/defense = sentry
					if (defense.has_camera)
						defense.set_range()
						SEND_SIGNAL(src, COMSIG_CAMERA_SET_AREA, defense.range_bounds, defense.loc.z)

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
			SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
			return TRUE
		if("ui-interact")
			playsound(src, get_sfx("terminal_button"), 25, FALSE)
			return FALSE
