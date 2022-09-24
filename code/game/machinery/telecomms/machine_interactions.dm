//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*

	All telecommunications interactions:

*/

#define TELECOMM_GROUND_Z "station_z"

/obj/structure/machinery/telecomms
	var/temp = "" // output message
	var/construct_op = 0
	var/deconstructable = FALSE


/obj/structure/machinery/telecomms/attackby(obj/item/P as obj, mob/user as mob)

	// Using a multitool lets you access the receiver's interface
	if(istype(P, /obj/item/device/multitool))
		attack_hand(user)

	else
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You stare at \the [src] cluelessly..."))
			return 0

	switch(construct_op)
		if(0)
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER) && deconstructable)
				to_chat(user, "You unfasten the bolts.")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				construct_op ++
		if(1)
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER))
				to_chat(user, "You fasten the bolts.")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				construct_op --
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				to_chat(user, "You dislodge the external plating.")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				construct_op ++
		if(2)
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				to_chat(user, "You secure the external plating.")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				construct_op --
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, "You remove the cables.")
				construct_op ++
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
				A.amount = 5
				stat |= BROKEN // the machine's been borked!
		if(3)
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/A = P
				if (A.use(5))
					to_chat(user, SPAN_NOTICE("You insert the cables."))
					construct_op--
					stat &= ~BROKEN // the machine's not borked anymore!
				else
					to_chat(user, SPAN_WARNING("You need five coils of wire for this."))
			if(istype(P, /obj/item/tool/crowbar))
				to_chat(user, "You begin prying out the circuit board other components...")
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, "You finish prying out the components.")

					// Drop all the component stuff
					if(contents.len > 0)
						for(var/obj/x in src)
							x.forceMove(user.loc)
					else

						// If the machine wasn't made during runtime, probably doesn't have components:
						// manually find the components and drop them!
						var/newpath = circuitboard
						var/obj/item/circuitboard/machine/C = new newpath
						for(var/I in C.req_components)
							for(var/i = 1, i <= C.req_components[I], i++)
								newpath = I
								var/obj/item/s = new newpath
								s.forceMove(user.loc)
								if(istype(P, /obj/item/stack/cable_coil))
									var/obj/item/stack/cable_coil/A = P
									A.amount = 1

						// Drop a circuit board too
						C.forceMove(user.loc)

					// Create a machine frame and delete the current machine
					var/obj/structure/machinery/constructable_frame/F = new
					F.forceMove(src.loc)
					qdel(src)


/obj/structure/machinery/telecomms/attack_remote(var/mob/user as mob)
	attack_hand(user)

/obj/structure/machinery/telecomms/attack_hand(var/mob/user as mob)

	// You need a multitool to use this, or be silicon
	if(!ishighersilicon(user))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You stare at \the [src] cluelessly..."))
			return
		// istype returns false if the value is null
		var/obj/item/held_item = user.get_active_hand()
		if(!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
			return

	if(inoperable())
		return

	user.set_interaction(src)
	var/dat
	dat = "<font face = \"Courier\">"
	dat += "<br>[temp]<br>"
	dat += "<br>Power Status: <a href='?src=\ref[src];input=toggle'>[src.toggled ? "On" : "Off"]</a>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='?src=\ref[src];input=id'>[id]</a>"
		else
			dat += "<br>Identification String: <a href='?src=\ref[src];input=id'>NULL</a>"
		dat += "<br>Network: <a href='?src=\ref[src];input=network'>[network]</a>"
		dat += "<br>Prefabrication: [autolinkers.len ? "TRUE" : "FALSE"]"
		if(hide) dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain machines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for(var/obj/structure/machinery/telecomms/T in links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref[T] [T.name] ([T.id])  <a href='?src=\ref[src];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "<br>Filtering Frequencies: "

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='?src=\ref[src];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='?src=\ref[src];delete=[x]'>\[X\]</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='?src=\ref[src];input=freq'>\[Add Filter\]</a>"
		dat += "<hr>"

	dat += "</font>"
	temp = ""
	show_browser(user, dat, "[src] Access", "tcommachine", "size=520x500;can_resize=0")
	onclose(user, "dormitory")


// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)


/obj/structure/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_level == TELECOMM_GROUND_Z) // equals the station
		src.listening_level = position.z
		return 1
	else if(is_admin_level(position.z))
		src.listening_level = TELECOMM_GROUND_Z
		return 1
	return 0

// Returns a multitool from a user depending on their mobtype.

/obj/structure/machinery/telecomms/proc/get_multitool(mob/user as mob)

	var/obj/item/device/multitool/P = null
	// Let's double check
	var/obj/item/held_item = user.get_active_hand()
	if(!ishighersilicon(user) && held_item && HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isborg(user) && in_range(user, src))
		var/obj/item/borg_held_item = user.get_active_hand()
		if(held_item && HAS_TRAIT(borg_held_item, TRAIT_TOOL_MULTITOOL))
			P = user.get_active_hand()
	return P

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/structure/machinery/telecomms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/structure/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/structure/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

/*
/obj/structure/machinery/telecomms/processor/Options_Topic(href, href_list)

	if(href_list["process"])
		temp = "<font color = #666633>-% Processing mode changed. %-</font color>"
		src.process_mode = !src.process_mode
*/

// RELAY

/obj/structure/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
	if(is_admin_level(z))
		dat += "<br>Signal Locked to Station: <A href='?src=\ref[src];change_listening=1'>[listening_level == TELECOMM_GROUND_Z ? "TRUE" : "FALSE"]</a>"
	dat += "<br>Broadcasting: <A href='?src=\ref[src];broadcast=1'>[broadcasting ? "YES" : "NO"]</a>"
	dat += "<br>Receiving:    <A href='?src=\ref[src];receive=1'>[receiving ? "YES" : "NO"]</a>"
	return dat

/obj/structure/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving mode changed. %-</font color>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting mode changed. %-</font color>"
	if(href_list["change_listening"])
		//Lock to the station OR lock to the current position!
		//You need at least two receivers and two broadcasters for this to work, this includes the machine.
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% [src]'s signal has been successfully changed.</font color>"
		else
			temp = "<font color = #666633>-% [src] could not lock it's signal onto the station. Two broadcasters or receivers required.</font color>"

// BUS

/obj/structure/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>Change Signal Frequency: <A href='?src=\ref[src];change_freq=1'>[change_frequency ? "YES ([change_frequency])" : "NO"]</a>"
	return dat

/obj/structure/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list["change_freq"])

		var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = "<font color = #666633>-% New frequency to change to assigned: \"[newfreq] GHz\" %-</font color>"
			else
				change_frequency = 0
				temp = "<font color = #666633>-% Frequency changing deactivated %-</font color>"


/obj/structure/machinery/telecomms/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishighersilicon(usr))
		var/obj/item/held_item = usr.get_held_item()
		if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
			return

	if(inoperable())
		return

	if(href_list["input"])
		switch(href_list["input"])

			if("toggle")
				src.toggled = !src.toggled
				temp = "<font color = #666633>-% [src] has been [src.toggled ? "activated" : "deactivated"].</font color>"
				toggle_state(usr)

			/*
			if("hide")
				src.hide = !hide
				temp = "<font color = #666633>-% Shadow Link has been [src.hide ? "activated" : "deactivated"].</font color>"
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% New ID assigned: \"[id]\" %-</font color>"

			if("network")
				var/newnet = stripped_input(usr, "Specify the new network for this machine. This will break all current links.", src, network)
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = "<font color = #666633>-% Too many characters in new network tag %-</font color>"

					else
						for(var/obj/structure/machinery/telecomms/T in links)
							T.links.Remove(src)

						network = newnet
						links = list()
						temp = "<font color = #666633>-% New network tag assigned: \"[network]\" %-</font color>"


			if("freq")
				var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(!(newfreq in freq_listening) && newfreq < 10000)
						freq_listening.Add(newfreq)
						temp = "<font color = #666633>-% New frequency filter assigned: \"[newfreq] GHz\" %-</font color>"

	if(href_list["delete"])

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list["delete"])
		temp = "<font color = #666633>-% Removed frequency filter [x] %-</font color>"
		freq_listening.Remove(x)

	if(href_list["unlink"])

		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/structure/machinery/telecomms/T = links[text2num(href_list["unlink"])]
			if(istype(T))
				temp = "<font color = #666633>-% Removed \ref[T] [T.name] from linked entities. %-</font color>"

				// Remove link entries from both T and src.

				if(src in T.links)
					T.links.Remove(src)
				links.Remove(T)

	src.Options_Topic(href, href_list)

	usr.set_interaction(src)
	src.add_fingerprint(usr)

	updateUsrDialog()

/obj/structure/machinery/telecomms/proc/canAccess(var/mob/user)
	if(isRemoteControlling(user) || in_range(user, src))
		return 1
	return 0
