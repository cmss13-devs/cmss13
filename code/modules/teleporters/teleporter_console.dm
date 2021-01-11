/obj/structure/machinery/computer/teleporter_console
    name = "teleporter console"
    desc = "A console used for controlling teleporters."
    icon_state = "teleport"
    unacidable = TRUE
    var/datum/teleporter/linked_teleporter
    var/teleporter_id // Set the teleporter ID to link to here

    var/selected_source             // Populated w/ the nanoUI-selected source location
    var/selected_destination        // selected destination location

/obj/structure/machinery/computer/teleporter_console/Destroy()
	linked_teleporter = null
	. = ..()

/obj/structure/machinery/computer/teleporter_console/attack_hand(var/mob/user)
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

    user.set_interaction(src)

    ui_interact(user)

/obj/structure/machinery/computer/teleporter_console/attack_alien(var/mob/living/carbon/Xenomorph/X)
    if(!isXenoQueen(X))
        return
    return attack_hand(X)

// Try to find and add a teleporter from the globals.
/obj/structure/machinery/computer/teleporter_console/proc/attempt_teleporter_link()
    if(linked_teleporter) // Maybe should debug log this because it's indicative of bad logic, but I'll leave it out for the sake of (potential) spam
        return 1

    if(SSteleporter)

        var/datum/teleporter/found_teleporter = SSteleporter.teleporters_by_id[teleporter_id]
        if(found_teleporter)
            linked_teleporter = found_teleporter
            linked_teleporter.linked_consoles += src
        else
            log_debug("Couldn't find teleporter matching ID [linked_teleporter]. Code: TELEPORTER_CONSOLE_2")
            log_admin("Couldn't find teleporter matching ID [linked_teleporter]. Tell the devs. Code: TELEPORTER_CONSOLE_2")
            return 0
    else
        log_debug("Couldn't find teleporter SS to pull teleporter from. Code: TELEPORTER_CONSOLE_3")
        log_admin("Couldn't find teleporter SS to pull teleporter from. Tell the devs. Code: TELEPORTER_CONSOLE_3")
        return 0

    return 1

/obj/structure/machinery/computer/teleporter_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
    var/data[0]
    var/teleporter_status_message

    if(!linked_teleporter)
        if(!attempt_teleporter_link(teleporter_id))
            to_chat(user, SPAN_WARNING("Something has gone very, very wrong. Tell the devs. Code: TELEPORTER_CONSOLE_5"))
            log_debug("Couldn't find teleporter matching ID [teleporter_id]. Code: TELEPORTER_CONSOLE_5")
            log_admin("Couldn't find teleporter matching ID [teleporter_id]. Tell the devs. Code: TELEPORTER_CONSOLE_5")
            return

    if(linked_teleporter.check_teleport_cooldown())
        teleporter_status_message = "READY"
    else
        teleporter_status_message = "COOLING DOWN"

    // NanoUI template items
    data = list(
        "teleporter_status" = teleporter_status_message,                                                                // Pretty messages
        "can_fire" = linked_teleporter.check_teleport_cooldown(),                                                       // Just whether or not we can fire
        "time_to_ready" = round((linked_teleporter.time_last_used + linked_teleporter.cooldown - world.time)/10),       // How long until we can fire
        "curr_time" = world.time,                                                                                       // Current time
        "last_fire_time" = linked_teleporter.time_last_used,                                                            // Time we teleported last
        "ready_time" = linked_teleporter.time_last_used + linked_teleporter.cooldown,                                   // When we will be ready
        "cooldown" = linked_teleporter.cooldown,                                                                        // Our total cooldown time
        "avail_locations" = linked_teleporter.locations,                                                                // Available locations
        "selected_source" = selected_source,                                                                            // Selected source
        "selected_destination" = selected_destination,                                                                  // Selected destination
        "name" = linked_teleporter.name,                                                                                // Name
    )

    ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

    if(!ui)
        ui = new(user, src, ui_key, "teleporter_control_console.tmpl","Teleporter Control", 550, 500)
        ui.set_initial_data(data)
        ui.open()
        ui.set_auto_update(1)

/obj/structure/machinery/computer/teleporter_console/Topic(href, href_list)
    if(..())
        return

    add_fingerprint(usr)

    if(href_list["select_source"])
        var/new_source = tgui_input_list(usr, "Select source location","Source Location", linked_teleporter.locations)
        if (selected_source && !new_source)
            return
        else
            selected_source = new_source

    if(href_list["select_dest"])
        var/new_dest = tgui_input_list(usr, "Select destination location","Destination Location", linked_teleporter.locations)
        if(selected_destination && !new_dest)
            return
        else
            selected_destination = new_dest

    if(href_list["teleport"])
        if(!selected_source || !selected_destination)
            visible_message("<b>[src]</b> beeps, \"You must select a valid source and destination for teleportation.\"")
            return

        if(selected_source == selected_destination)
            visible_message("<b>[src]</b> beeps, \"You must select a different source and destination for teleportation to succeed.\"")
            return

        if(!linked_teleporter.safety_check_destination(selected_destination))
            visible_message("<b>[src]</b> beeps, \"The destination is unsafe. Please clear it of any dangerous or dense objects.\"")
            return

        if(!linked_teleporter.safety_check_source(selected_source))
            visible_message("<b>[src]</b> beeps, \"The source location is unsafe. Any large objects must be completely inside the teleporter.\"")
            return

        if(!linked_teleporter.check_teleport_cooldown())
            visible_message("<b>[src]</b> beeps, \"The [linked_teleporter.name] is on cooldown. Please wait.\"")
            return

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

        if(!linked_teleporter.safety_check_source(selected_source) || !linked_teleporter.safety_check_destination(selected_destination) || !linked_teleporter.check_teleport_cooldown())
            visible_message("<b>[src]</b> beeps, \"TELEPORTATION ERROR; ABORTING....\"")
            return

        linked_teleporter.teleport(selected_source, selected_destination)



/obj/structure/machinery/computer/teleporter_console/ex_act(severity)
    if(unacidable)
        return
    else
        ..()


/obj/structure/machinery/computer/teleporter_console/bullet_act(var/obj/item/projectile/P)
    visible_message("[P] doesn't even scratch [src]!")
    return 0

// Please only add things with teleporter_id set or it will not work and you'll spam the shit out of admin logs
/obj/structure/machinery/computer/teleporter_console/corsat
    name = "\improper CORSAT Teleporter Console"
    desc = "A console used for interfacing with the CORSAT experimental teleporter."
    teleporter_id = "Corsat_Teleporter"
