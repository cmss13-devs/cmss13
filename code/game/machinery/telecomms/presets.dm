// ### Preset machines  ###

//Relay
/obj/structure/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/structure/machinery/telecomms/relay/preset/station
	id = "Station Relay"
	listening_level = TELECOMM_GROUND_Z
	autolinkers = list("s_relay")

/obj/structure/machinery/telecomms/relay/preset/station/prison
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/telecomms/relay/preset/ice_colony
	icon = 'icons/obj/structures/machinery/comm_tower.dmi'
	icon_state = "comm_tower"
	id = "Station Relay"
	listening_level = TELECOMM_GROUND_Z
	autolinkers = list("s_relay")
	unslashable = TRUE
	unacidable = TRUE

	//We dont want anyone to mess with it
/obj/structure/machinery/telecomms/relay/preset/ice_colony/attackby()
	return

GLOBAL_LIST_EMPTY(all_static_telecomms_towers)

/obj/structure/machinery/telecomms/relay/preset/tower
	name = "TC-4T telecommunications tower"
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "comm_tower"
	desc = "A portable compact TC-4T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations."
	id = "Station Relay"
	listening_level = TELECOMM_GROUND_Z
	autolinkers = list("s_relay")
	layer = ABOVE_FLY_LAYER
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	unslashable = FALSE
	unacidable = TRUE
	health = 450
	tcomms_machine = TRUE
	freq_listening = DEPT_FREQS

/obj/structure/machinery/telecomms/relay/preset/tower/Initialize()
	GLOB.all_static_telecomms_towers += src
	. = ..()
	if(z)
		SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "supply")

/obj/structure/machinery/telecomms/relay/preset/tower/Destroy()
	GLOB.all_static_telecomms_towers -= src
	. = ..()

// doesn't need power, instead uses health
/obj/structure/machinery/telecomms/relay/preset/tower/inoperable(additional_flags)
	if(stat & (additional_flags|BROKEN))
		return TRUE
	if(health <= 0)
		return TRUE
	return FALSE

/obj/structure/machinery/telecomms/relay/preset/tower/update_state()
	. = ..()
	if(on)
		playsound(src, 'sound/machines/tcomms_on.ogg', vol = 80, vary = FALSE, sound_range = 16, falloff = 0.5)
		msg_admin_niche("Portable communication relay started for Z-Level [src.z] [ADMIN_JMP(src)]")

		if(SSobjectives && SSobjectives.comms)
			// This is the first time colony comms have been established.
			if (SSobjectives.comms.state != OBJECTIVE_COMPLETE && is_ground_level(loc.z) && operable())
				SSobjectives.comms.complete()

/obj/structure/machinery/telecomms/relay/preset/tower/tcomms_shutdown()
	. = ..()
	if(!on)
		msg_admin_niche("Portable communication relay shut down for Z-Level [src.z] [ADMIN_JMP(src)]")

/obj/structure/machinery/telecomms/relay/preset/tower/bullet_act(obj/projectile/P)
	..()
	if(istype(P.ammo, /datum/ammo/xeno/boiler_gas))
		update_health(50)

	else if(P.ammo.flags_ammo_behavior & AMMO_ANTISTRUCT)
		update_health(P.damage*ANTISTRUCT_DMG_MULT_BARRICADES)

	update_health(floor(P.damage/2))
	return TRUE

/obj/structure/machinery/telecomms/relay/preset/tower/update_health(damage = 0)
	if(!damage)
		return
	if(damage > 0 && health <= 0)
		return // Leave the poor thing alone

	health -= damage
	health = clamp(health, 0, initial(health))

	if(health <= 0)
		toggled = FALSE // requires flipping on again once repaired
	if(health < initial(health))
		desc = "[initial(desc)] [SPAN_WARNING(" It is damaged and needs a welder for repairs!")]"
	else
		desc = initial(desc)
	update_state()

/obj/structure/machinery/telecomms/relay/preset/tower/toggle_state(mob/user)
	if(!toggled && (inoperable() || (health <= initial(health) / 2)))
		to_chat(user, SPAN_WARNING("\The [src.name] needs repairs to be turned back on!"))
		return
	..()

/obj/structure/machinery/telecomms/relay/preset/tower/update_icon()
	if(health <= 0)
		icon_state = "[initial(icon_state)]_broken"
	else if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/structure/machinery/telecomms/relay/preset/tower/attackby(obj/item/I, mob/user)
	if(iswelder(I))
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
			return
		var/obj/item/tool/weldingtool/WT = I

		if(health >= initial(health))
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
			SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
				SPAN_NOTICE("You repair [src]."))
				update_health(-150)
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		return

	else if(HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL))
		return
	else
		return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/attack_hand(mob/user)
	if(isSilicon(user))
		return ..()
	if(on)
		to_chat(user, SPAN_WARNING("\The [src.name] blinks and beeps incomprehensibly as it operates, better not touch this..."))
		return
	toggle_state(user) // just flip dat switch

/obj/structure/machinery/telecomms/relay/preset/tower/all
	freq_listening = list(UNIVERSAL_FREQ)

/obj/structure/machinery/telecomms/relay/preset/tower/faction
	name = "UPP telecommunications relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away. This one is intercepting and rebroadcasting UPP frequencies."
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "relay"
	id = "UPP Relay"
	hide = TRUE
	freq_listening = UPP_FREQS
	var/faction_shorthand = "UPP"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/Initialize(mapload, ...)
	if(faction_shorthand)
		name = replacetext(name, "UPP", faction_shorthand)
		desc = replacetext(desc, "UPP", faction_shorthand)
		id = replacetext(id, "UPP", faction_shorthand)
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/faction/clf
	freq_listening = CLF_FREQS
	faction_shorthand = "CLF"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/pmc
	freq_listening = PMC_FREQS
	faction_shorthand = "PMC"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/colony
	freq_listening = list(COLONY_FREQ)
	faction_shorthand = "colony"

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms
	name = "TC-3T static telecommunications tower"
	desc = "A static heavy-duty TC-3T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations. Will need to have extra communication frequencies programmed into it by multitool."
	use_power = USE_POWER_NONE
	idle_power_usage = 10000
	icon = 'icons/obj/structures/machinery/comm_tower3.dmi'
	icon_state = "static1"
	toggled = FALSE
	bound_height = 64
	bound_width = 64
	freq_listening = list(COLONY_FREQ)
	var/toggle_cooldown = 0

	/// Tower has been taken over by xenos, is not usable
	var/corrupted = FALSE

	/// Held image for the current overlay on the tower from xeno corruption
	var/image/corruption_image

	/// Holds the delay for when a cluster can recorrupt the comms tower after a pylon has been destroyed
	COOLDOWN_DECLARE(corruption_delay)

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(register_with_turf))
	register_with_turf()

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) && !COOLDOWN_FINISHED(src, corruption_delay))
		. += SPAN_XENO("Corruption cooldown: [(COOLDOWN_TIMELEFT(src, corruption_delay) / (1 SECONDS))] seconds.")

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/attack_hand(mob/user)
	if(user.action_busy)
		return
	if(toggle_cooldown > world.time) //cooldown only to prevent spam toggling
		to_chat(user, SPAN_WARNING("\The [src]'s processors are still cooling! Wait before trying to flip the switch again."))
		return
	if(corrupted)
		to_chat(user, SPAN_WARNING("[src] is entangled in resin. Impossible to interact with."))
		return
	var/current_state = on
	if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
		return
	if(current_state != on)
		to_chat(user, SPAN_NOTICE("\The [src] is already turned [on ? "on" : "off"]!"))
		return
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] makes a small plaintful beep, and nothing happens. It seems to be out of power."))
		return FALSE
	if(toggle_cooldown > world.time) //cooldown only to prevent spam toggling
		to_chat(user, SPAN_WARNING("\The [src]'s processors are still cooling! Wait before trying to flip the switch again."))
		return
	toggle_state(user) // just flip dat switch
	var/turf/commloc = get_turf(src)
	var/area/commarea = get_area(src)
	if(on) //now, if it went on it now uses power
		use_power = USE_POWER_IDLE
		message_admins("[key_name(user)] turned \the [src] in [commarea] ON. [ADMIN_JMP(commloc.loc)]")
	else
		use_power = USE_POWER_NONE
		message_admins("[key_name(user)] turned \the [src] in [commarea] OFF. [ADMIN_JMP(commloc.loc)]")
	toggle_cooldown = world.time + 40

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL))
		if(inoperable() || (health <= initial(health) * 0.5))
			to_chat(user, SPAN_WARNING("\The [src.name] needs repairs to have frequencies added to its software!"))
			return
		var/choice = tgui_input_list(user, "What do you wish to do?", "TC-3T comms tower", list("Wipe communication frequencies", "Add your faction's frequencies"))
		if(choice == "Wipe communication frequencies")
			freq_listening.Cut()
			to_chat(user, SPAN_NOTICE("You wipe the preexisting frequencies from \the [src]."))
			return
		else if(choice == "Add your faction's frequencies")
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return
			switch(user.faction)
				if(FACTION_SURVIVOR)
					freq_listening |= COLONY_FREQ
					if(FACTION_MARINE in user.faction_group) //FORECON survivors
						freq_listening |= SOF_FREQ
				if(FACTION_CLF)
					freq_listening |= CLF_FREQS
				if(FACTION_UPP)
					freq_listening |= UPP_FREQS
				if(FACTION_WY,FACTION_PMC)
					freq_listening |= PMC_FREQS
				if(FACTION_TWE)
					freq_listening |= RMC_FREQ
				if(FACTION_YAUTJA)
					to_chat(user, SPAN_WARNING("You decide to leave the human machine alone."))
					return
				else
					freq_listening |= DEPT_FREQS
			to_chat(user, SPAN_NOTICE("You add your faction's communication frequencies to \the [src]'s comm list."))
			return
	. = ..()

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/power_change()
	..()
	if((stat & NOPOWER))
		if(on)
			toggle_state()
			on = FALSE
			update_icon()

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/update_state()
	..()
	if(inoperable())
		handle_xeno_acquisition(get_turf(src))

/// Handles xenos corrupting the tower when weeds touch the turf it is located on
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/proc/handle_xeno_acquisition(turf/weeded_turf)
	SIGNAL_HANDLER

	if(corrupted)
		return

	if(!weeded_turf.weeds)
		return

	if(weeded_turf.weeds.weed_strength < WEED_LEVEL_HIVE)
		return

	if(!weeded_turf.weeds.parent)
		return

	if(!istype(weeded_turf.weeds.parent, /obj/effect/alien/weeds/node/pylon/cluster))
		return

	if(SSticker.mode.is_in_endgame)
		return

	if(operable())
		return

	if(ROUND_TIME < XENO_COMM_ACQUISITION_TIME)
		addtimer(CALLBACK(src, PROC_REF(handle_xeno_acquisition), weeded_turf), (XENO_COMM_ACQUISITION_TIME - ROUND_TIME), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
		return

	if(!COOLDOWN_FINISHED(src, corruption_delay))
		addtimer(CALLBACK(src, PROC_REF(handle_xeno_acquisition), weeded_turf), (COOLDOWN_TIMELEFT(src, corruption_delay)), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
		return

	var/obj/effect/alien/weeds/node/pylon/cluster/parent_node = weeded_turf.weeds.parent

	var/obj/effect/alien/resin/special/cluster/cluster_parent = parent_node.resin_parent

	var/list/held_children_weeds = parent_node.children
	var/cluster_loc = cluster_parent.loc
	var/linked_hive = cluster_parent.linked_hive

	parent_node.children = list()

	qdel(cluster_parent)

	var/obj/effect/alien/resin/special/pylon/endgame/new_pylon = new(cluster_loc, linked_hive)
	new_pylon.node.children = held_children_weeds

	for(var/obj/effect/alien/weeds/weed in new_pylon.node.children)
		weed.parent = new_pylon.node
		weed.spread_on_semiweedable = TRUE
		weed.weed_expand()

	RegisterSignal(new_pylon, COMSIG_PARENT_QDELETING, PROC_REF(uncorrupt))

	corrupted = TRUE

	corruption_image = image(icon, icon_state = "resin_growing")

	flick_overlay(src, corruption_image, (2 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(switch_to_idle_corruption)), (2 SECONDS))

	new_pylon.comms_relay_connection()

/// Handles removing corruption effects from the comms relay
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/proc/uncorrupt(datum/deleting_datum)
	SIGNAL_HANDLER

	corrupted = FALSE

	overlays -= corruption_image

	COOLDOWN_START(src, corruption_delay, XENO_PYLON_DESTRUCTION_DELAY)

/// Handles moving the overlay from growing to idle
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/proc/switch_to_idle_corruption()
	if(!corrupted)
		return

	corruption_image = image(icon, icon_state = "resin_idle")

	overlays += corruption_image

/// Handles re-registering signals on new turfs if changed
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/proc/register_with_turf()
	SIGNAL_HANDLER

	RegisterSignal(get_turf(src), COMSIG_WEEDNODE_GROWTH, PROC_REF(handle_xeno_acquisition))

/obj/structure/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/structure/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/structure/machinery/telecomms/relay/preset/centcom
	id = "Centcom Relay"
	hide = 1
	toggled = 1
	use_power = USE_POWER_NONE
	autolinkers = list("c_relay")

//HUB

/obj/structure/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "s_relay", "medical",
		"common", "command", "engineering", "squads", "security",
		"receiverA", "receiverB",  "broadcasterA", "broadcasterB")

/obj/structure/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	autolinkers = list("hub_cent", "relay", "c_relay", "s_relay", "centcomm", "receiverCent", "broadcasterCent")

//Receivers

//--PRESET LEFT--//


/obj/structure/machinery/telecomms/receiver/preset_left
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ)

//--PRESET RIGHT--//

/obj/structure/machinery/telecomms/receiver/preset
	id = "Receiver B"
	network = "tcommsat"
	autolinkers = list("receiverB") // link to relay
	freq_listening = list(COMM_FREQ, ENG_FREQ, SEC_FREQ, MED_FREQ, REQ_FREQ, SENTRY_FREQ, WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ)

	//Common and other radio frequencies for people to freely use
/obj/structure/machinery/telecomms/receiver/preset/Initialize(mapload, ...)
	. = ..()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i

/obj/structure/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	autolinkers = list("receiverCent")
	freq_listening = list(WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ, CBRN_FREQ, FORECON_FREQ)

//Buses

/obj/structure/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(MED_FREQ, ENG_FREQ, REQ_FREQ)
	autolinkers = list("processor1", "medical", "engineering", "cargo")

/obj/structure/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ, ECHO_FREQ, CRYO_FREQ)
	autolinkers = list("processor2","squads")

/obj/structure/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ, WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ, CBRN_FREQ)
	autolinkers = list("processor3", "security", "command", "JTAC")

/obj/structure/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	autolinkers = list("processor4", "common")

/obj/structure/machinery/telecomms/bus/preset_four/Initialize(mapload, ...)
	. = ..()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i

/obj/structure/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ, CBRN_FREQ)
	autolinkers = list("processorCent", "centcomm")

//Processors

/obj/structure/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/structure/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/structure/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/structure/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/structure/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	autolinkers = list("processorCent")

//Servers

/obj/structure/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/structure/machinery/telecomms/server/presets/squads
	id = "Squad Server"
	freq_listening = list(ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ)
	autolinkers = list("squads")

/obj/structure/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	autolinkers = list("medical")
/*
/obj/structure/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(REQ_FREQ)
	autolinkers = list("supply")
*/
/obj/structure/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common")

	//Common and other radio frequencies for people to freely use
	// 1441 to 1489
/obj/structure/machinery/telecomms/server/presets/common/Initialize(mapload, ...)
	. = ..()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i

/obj/structure/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ, WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ, CBRN_FREQ)
	autolinkers = list("command")

/obj/structure/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ, REQ_FREQ)
	autolinkers = list("engineering", "cargo")

/obj/structure/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	autolinkers = list("security")

/obj/structure/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(WY_WO_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, PVST_FREQ, SOF_FREQ, CBRN_FREQ)
	autolinkers = list("centcomm")

//Broadcasters

//--PRESET LEFT--//

/obj/structure/machinery/telecomms/broadcaster/preset_left
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

//--PRESET RIGHT--//

/obj/structure/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster B"
	network = "tcommsat"
	autolinkers = list("broadcasterB")

/obj/structure/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	autolinkers = list("broadcasterCent")

/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/structure/machinery/telecomms/allinone
	name = "Telecommunications Mainframe"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommunications processing."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	machinetype = 6
	unslashable = TRUE
	unacidable = TRUE
	var/intercept = 0 // if nonzero, broadcasts all messages to syndicate channel

/obj/structure/machinery/telecomms/allinone/interceptor
	name = "Message Intercept Mainframe"
	intercept = 1
	freq_listening = list(UPP_FREQ)
