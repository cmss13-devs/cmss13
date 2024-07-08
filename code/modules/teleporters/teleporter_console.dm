/obj/structure/machinery/computer/teleporter_console
	name = "teleporter console"
	desc = "A console used for controlling teleporters."
	icon_state = "teleport"
	unacidable = TRUE
	var/datum/teleporter/linked_teleporter
	var/teleporter_id // Set the teleporter ID to link to here
	var/selected_source  // Populated w/ the TGUI-selected source location
	var/selected_destination // selected destination location
	var/teleporting = FALSE // is it currently doing le telepórt

/obj/structure/machinery/computer/teleporter_console/Destroy()
	linked_teleporter = null
	. = ..()

/obj/structure/machinery/computer/teleporter_console/attack_hand(mob/user)
	if(..(user))
		return

	if(ishuman(user) && !skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You can't figure out how to use [src]."))
		return

	if(!linked_teleporter && !attempt_teleporter_link(teleporter_id))
		to_chat(user, SPAN_WARNING("Something has gone very, very wrong. Tell the devs. Code: TELEPORTER_CONSOLE_4"))
		log_debug("Couldn't find teleporter matching ID [teleporter_id]. Code: TELEPORTER_CONSOLE_4")
		log_admin("Couldn't find teleporter matching ID [teleporter_id]. Tell the devs. Code: TELEPORTER_CONSOLE_4")
		return

	tgui_interact(user)

/obj/structure/machinery/computer/teleporter_console/attack_alien(mob/living/carbon/xenomorph/X)
	if(!isqueen(X))
		return FALSE
	attack_hand(X)
	return XENO_ATTACK_ACTION

// Try to find and add a teleporter from the globals.
/obj/structure/machinery/computer/teleporter_console/proc/attempt_teleporter_link()
	if(linked_teleporter) // Maybe should debug log this because it's indicative of bad logic, but I'll leave it out for the sake of (potential) spam
		return TRUE

	var/datum/teleporter/found_teleporter = GLOB.teleporters_by_id[teleporter_id]
	if(found_teleporter)
		linked_teleporter = found_teleporter
		linked_teleporter.linked_consoles += src
	else
		log_debug("Couldn't find teleporter matching ID [linked_teleporter]. Code: TELEPORTER_CONSOLE_2")
		log_admin("Couldn't find teleporter matching ID [linked_teleporter]. Tell the devs. Code: TELEPORTER_CONSOLE_2")
		return FALSE

	return TRUE

/obj/structure/machinery/computer/teleporter_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TeleporterConsole", name)
		ui.open()

/obj/structure/machinery/computer/teleporter_console/ui_data(mob/user)
	var/list/data = list()

	if(!linked_teleporter)
		if(!attempt_teleporter_link(teleporter_id))
			to_chat(user, SPAN_WARNING("Something has gone very, very wrong. Tell the devs. Code: TELEPORTER_CONSOLE_5"))
			log_debug("Couldn't find teleporter matching ID [teleporter_id]. Code: TELEPORTER_CONSOLE_5")
			log_admin("Couldn't find teleporter matching ID [teleporter_id]. Tell the devs. Code: TELEPORTER_CONSOLE_5")
			return

	data["worldtime"] = world.time
	data["next_teleport_time"] = linked_teleporter.next_teleport_time
	data["cooldown_length"] = linked_teleporter.cooldown
	data["teleporting"] = teleporting

	data["locations"] = linked_teleporter.locations
	data["source"] = selected_source
	data["destination"] = selected_destination
	data["name"] = linked_teleporter.name

	return data

/obj/structure/machinery/computer/teleporter_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	switch(action)
		if("set_source")
			selected_source = params["location"]
			. = TRUE

		if("set_dest")
			selected_destination = params["location"]
			. = TRUE

		if("teleport")
			carry_out_teleport()
			. = TRUE

/obj/structure/machinery/computer/teleporter_console/proc/carry_out_teleport()
	if(!linked_teleporter.safety_check_destination(selected_destination))
		visible_message("<b>[src]</b> beeps, \"The destination is unsafe. Please clear it of any dangerous or dense objects.\"")
		return

	if(!linked_teleporter.safety_check_source(selected_source))
		visible_message("<b>[src]</b> beeps, \"The source location is unsafe. Any large objects must be completely inside the teleporter.\"")
		return

	teleporting = TRUE
	SStgui.update_uis(src)

	var/list/turf_keys = linked_teleporter.get_turfs_by_location(selected_source)
	var/turf/sound_turf = turf_keys[pick(turf_keys)]
	playsound(sound_turf, 'sound/effects/corsat_teleporter.ogg', 80, 0, 20)

	spawn(0)
		linked_teleporter.apply_vfx(selected_source, 30)

	visible_message("<b>[src]</b> beeps, \"Initiating Teleportation in 5 seconds....\"")

	sleep(10)

	visible_message("<b>[src]</b> beeps, \"Initiating Teleportation in 4 seconds....\"")

	sleep(10)

	visible_message("<b>[src]</b> beeps, \"Initiating Teleportation in 3 seconds....\"")

	sleep(10)

	visible_message("<b>[src]</b> beeps, \"Initiating Teleportation in 2 seconds....\"")

	sleep(10)

	visible_message("<b>[src]</b> beeps, \"Initiating Teleportation in 1 second....\"")

	for(var/turf_key in turf_keys)
		var/turf/T = turf_keys[turf_key]
		flick("corsat_teleporter_dynamic", T)

	sleep(10)

	visible_message("<b>[src]</b> beeps, \"INITIATING TELEPORTATION....\"")

	teleporting = FALSE
	SStgui.update_uis(src)

	if(!linked_teleporter.safety_check_source(selected_source) || !linked_teleporter.safety_check_destination(selected_destination) || !linked_teleporter.check_teleport_cooldown())
		visible_message("<b>[src]</b> beeps, \"TELEPORTATION ERROR; ABORTING....\"")
		return

	linked_teleporter.teleport(selected_source, selected_destination)

/obj/structure/machinery/computer/teleporter_console/ex_act(severity)
	if(unacidable)
		return
	else
		..()


/obj/structure/machinery/computer/teleporter_console/bullet_act(obj/projectile/P)
	visible_message("[P] doesn't even scratch [src]!")
	return FALSE

// Please only add things with teleporter_id set or it will not work and you'll spam the shit out of admin logs
/obj/structure/machinery/computer/teleporter_console/corsat
	name = "\improper CORSAT Teleporter Console"
	desc = "A console used for interfacing with the CORSAT experimental teleporter."
	teleporter_id = "Corsat_Teleporter"

/obj/structure/machinery/computer/teleporter_console/corsat/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].map_name != MAP_CORSAT) // Bad style, but I'm leaving it here for now until someone wants to add a teleporter to another map
		return

	if(length(GLOB.teleporters)) // already made the damn thing
		return

	var/datum/teleporter/corsat/teleporter = new
	GLOB.teleporters_by_id[teleporter.id] = teleporter
	GLOB.teleporters += teleporter
