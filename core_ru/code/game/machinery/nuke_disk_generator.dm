// -- Print disk computer

/obj/structure/machinery/computer/nuke_disk_generator
	name = "nuke disk generator"
	desc = "Used to generate the correct auth discs for the nuke."
	icon = 'core_ru/icons/obj/structures/machinery/computer.dmi'
	icon_state = "nuke_red"

	density = TRUE
	unacidable = TRUE
	anchored = TRUE
	explo_proof = TRUE

	var/disk_type

	var/time_required_to_unlock = 2 MINUTES
	var/time_in = 0
	var/started_time = 0
	var/total_segments = 5
	var/working = FALSE
	var/security_protocol = TRUE
	var/list/messages_in_total  = list(
		"Booting up terminal-  -Terminal running",
		"Establishing link to offsite mainframe- Link established",
		"WARNING, DIRECTORY CORRUPTED, running search algorithms- nuke_fission_timing.exe found",
		"Invalid credentials, upgrading permissions through CM military override- Permissions upgraded, nuke_fission_timing.exe available",
		"Downloading nuke_fission_timing.exe to removable storage- nuke_fission_timing.exe downloaded to floppy disk, have a nice day"
	)
	var/last_action_time = 0

/obj/structure/machinery/computer/nuke_disk_generator/Initialize()
	. = ..()

	update_minimap_icon()

	if(!disk_type)
		return INITIALIZE_HINT_QDEL

	GLOB.nuke_disk_generators += src
	addtimer(CALLBACK(src, PROC_REF(check_mode)), 300 SECONDS)

/obj/structure/machinery/computer/nuke_disk_generator/proc/update_minimap_icon()
	if(!is_ground_level(z))
		return

	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "nuke_off", 'icons/ui_icons/map_blips_large.dmi')

/obj/structure/machinery/computer/nuke_disk_generator/proc/check_mode()
	if(!check_crash())
		qdel(src)

/obj/structure/machinery/computer/nuke_disk_generator/Destroy()
	GLOB.nuke_disk_generators -= src
	. = ..()

/obj/structure/machinery/computer/nuke_disk_generator/ex_act(severity)
	return

/obj/structure/machinery/computer/nuke_disk_generator/attack_hand(mob/user)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] is not working"))
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied!"))
		return

	if(!isRemoteControlling(user))
		user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/nuke_disk_generator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NukeDiskGen", "Security System")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/machinery/computer/nuke_disk_generator/ui_data(mob/user)
	. = list()
	if(security_protocol)
		.["security_protocol"] = list()
		.["security_protocol"]["messages"] = list()
		if(started_time)
			for(var/i = 1 to floor((world.time - started_time + time_in) / (time_required_to_unlock / total_segments)))
				.["security_protocol"]["messages"] += list(list(messages_in_total[i]))
		else
			for(var/i = 1 to floor(time_in / (time_required_to_unlock / total_segments)))
				.["security_protocol"]["messages"] += list(list(messages_in_total[i]))

	.["timer"] = list()
	.["timer"]["running"] = working
	if(started_time)
		.["timer"]["current_progress"] = clamp((world.time - started_time + time_in) / time_required_to_unlock * 100, 0, 100)
	else
		.["timer"]["current_progress"] = time_in ? clamp(time_in / time_required_to_unlock * 100, 0, 100) : 0
	.["interaction_time_lock"] = last_action_time > world.time

/obj/structure/machinery/computer/nuke_disk_generator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(last_action_time > world.time)
		return

	last_action_time = world.time + 1 MINUTES
	switch(action)
		if("security")
			if(working || !security_protocol)
				return

			working = TRUE
			ui.user.visible_message("[ui.user] starting a program to generate a nuclear disk code.", "You starting a program to generate a nuclear disk code.")
			started_time = world.time
			var/time_percent = do_after(ui.user, time_required_to_unlock - time_in, INTERRUPT_ALL, BUSY_ICON_BUILD, src, show_remaining_time = TRUE)
			if(!working)
				return

			if(!time_percent)
				security_protocol = FALSE
				time_in = 0

			time_in = time_percent ? time_required_to_unlock - time_percent * time_required_to_unlock : time_required_to_unlock
			started_time = 0
			working = FALSE

		if("print")
			if(working || security_protocol)
				return

			working = TRUE
			ui.user.visible_message("[ui.user] starting a program to generate a nuclear disk.", "You starting a program to generate a nuclear disk.")
			started_time = world.time
			var/time_percent = do_after(ui.user, time_required_to_unlock - time_in, INTERRUPT_ALL, BUSY_ICON_BUILD, src, show_remaining_time = TRUE)
			if(!working)
				return

			if(!time_percent)
				new disk_type(loc)
				visible_message(SPAN_NOTICE("[src] beeps as it finishes printing the disc."))
				time_in = 0

			time_in = time_percent ? time_required_to_unlock - time_percent * time_required_to_unlock : time_required_to_unlock
			started_time = 0
			working = FALSE

	return

/obj/structure/machinery/computer/nuke_disk_generator/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/nuke_disk_generator/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/nuke_disk_generator/power_change()
	. = ..()
	if(inoperable() && working)
		time_in += world.time - started_time
		if(time_in >= time_required_to_unlock)// Edge case, lets be it here
			security_protocol = FALSE
			time_in = 0
		started_time = 0
		working = FALSE
		playsound(src, 'sound/machines/ping.ogg', 25, 1)
		visible_message(SPAN_NOTICE("[src] beeps as it loses power."))

/obj/structure/machinery/computer/nuke_disk_generator/red
	name = "red nuke disk generator"
	disk_type = /obj/item/disk/nuclear/red

/obj/structure/machinery/computer/nuke_disk_generator/green
	name = "green nuke disk generator"
	icon_state = "nuke_green"
	disk_type = /obj/item/disk/nuclear/green

/obj/structure/machinery/computer/nuke_disk_generator/blue
	name = "blue nuke disk generator"
	icon_state = "nuke_blue"
	disk_type = /obj/item/disk/nuclear/blue

/obj/item/disk/nuclear/red
	name = "red nuclear authentication disk"
	icon_state = "disk_8"

/obj/item/disk/nuclear/green
	name = "green nuclear authentication disk"
	icon_state = "disk_6"

/obj/item/disk/nuclear/blue
	name = "blue nuclear authentication disk"
	icon_state = "disk_13"
