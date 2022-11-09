// ### Preset machines  ###


//var/list/freq_listening = list()  USE THIS FOR NEW RELAY STUFF WHEN I GET THIS - APOPHIS

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

/obj/structure/machinery/telecomms/relay/preset/tower
	name = "TC-4T telecommunications tower"
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "comm_tower"
	desc = "A portable compact TC-4T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations."
	id = "Station Relay"
	listening_level = TELECOMM_GROUND_Z
	autolinkers = list("s_relay")
	layer = ABOVE_FLY_LAYER
	use_power = 0
	idle_power_usage = 0
	unslashable = FALSE
	unacidable = TRUE
	health = 450
	tcomms_machine = TRUE
	freq_listening = DEPT_FREQS

// doesn't need power, instead uses health
/obj/structure/machinery/telecomms/relay/preset/tower/inoperable(additional_flags)
	if(stat & (additional_flags|BROKEN))
		return TRUE
	if(health <= 0)
		return TRUE
	return FALSE

/obj/structure/machinery/telecomms/relay/preset/tower/tcomms_startup()
	. = ..()
	if(on)
		playsound(src, 'sound/machines/tcomms_on.ogg', vol = 80, vary = FALSE, sound_range = 16, falloff = 0.5)
		msg_admin_niche("Portable communication relay started for Z-Level [src.z] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

		// This is the first time colony comms have been established.
		if (SSobjectives.comms.state != OBJECTIVE_COMPLETE && is_ground_level(loc.z) && operable())
			SSobjectives.comms.complete()

/obj/structure/machinery/telecomms/relay/preset/tower/tcomms_shutdown()
	. = ..()
	if(!on)
		msg_admin_niche("Portable communication relay shut down for Z-Level [src.z] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

/obj/structure/machinery/telecomms/relay/preset/tower/bullet_act(var/obj/item/projectile/P)
	..()
	if(istype(P.ammo, /datum/ammo/xeno/boiler_gas))
		update_health(50)

	else if(P.ammo.flags_ammo_behavior & AMMO_ANTISTRUCT)
		update_health(P.damage*ANTISTRUCT_DMG_MULT_BARRICADES)

	update_health(round(P.damage/2))
	return TRUE

/obj/structure/machinery/telecomms/relay/preset/tower/update_health(damage = 0)
	if(!damage)
		return
	if(damage > 0 && health <= 0)
		return // Leave the poor thing alone

	health -= damage
	health = Clamp(health, 0, initial(health))

	if(health <= 0)
		toggled = FALSE		// requires flipping on again once repaired
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
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
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
	else return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/attack_hand(mob/user)
	if(ishighersilicon(user))
		return ..()
	if(on)
		to_chat(user, SPAN_WARNING("\The [src.name] blinks and beeps incomprehensibly as it operates, better not touch this..."))
		return
	toggle_state(user) // just flip dat switch

/obj/structure/machinery/telecomms/relay/preset/tower/all
	freq_listening = list()

/obj/structure/machinery/telecomms/relay/preset/tower/faction
	name = "UPP telecommunications relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away. This one is intercepting and rebroadcasting UPP frequencies."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "relay"
	id = "UPP Relay"
	hide = TRUE
	freq_listening = list(RUS_FREQ, CCT_FREQ)
	var/faction_shorthand = "UPP"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/Initialize(mapload, ...)
	if(faction_shorthand)
		name = replacetext(name, "UPP", faction_shorthand)
		desc = replacetext(desc, "UPP", faction_shorthand)
		id = replacetext(id, "UPP", faction_shorthand)
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/faction/clf
	freq_listening = list(CLF_FREQ, CCT_FREQ)
	faction_shorthand = "CLF"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/pmc
	freq_listening = list(PMC_FREQ, CCT_FREQ)
	faction_shorthand = "PMC"

/obj/structure/machinery/telecomms/relay/preset/tower/faction/colony
	freq_listening = list(COLONY_FREQ)
	faction_shorthand = "colony"

GLOBAL_LIST_EMPTY(all_static_telecomms_towers)

/obj/structure/machinery/telecomms/relay/preset/tower/Initialize()
	GLOB.all_static_telecomms_towers += src
	. = ..()

/obj/structure/machinery/telecomms/relay/preset/tower/Destroy()
	GLOB.all_static_telecomms_towers -= src
	. = ..()

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms
	name = "TC-3T static telecommunications tower"
	desc = "A static heavy-duty TC-3T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations. Will need to have extra communication frequencies programmed into it by multitool."
	use_power = 0
	idle_power_usage = 10000
	icon = 'icons/obj/structures/machinery/comm_tower3.dmi'
	icon_state = "static1"
	toggled = FALSE
	bound_height = 64
	bound_width = 64
	freq_listening = list(COLONY_FREQ)
	var/toggle_cooldown = 0

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/attack_hand(mob/user)
	if(user.action_busy)
		return
	if(toggle_cooldown > world.time) //cooldown only to prevent spam toggling
		to_chat(user, SPAN_WARNING("\The [src]'s processors are still cooling! Wait before trying to flip the switch again."))
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
		use_power = 1
		message_admins("[key_name(user)] turned \the [src] in [commarea] ON. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[commloc.loc.x];Y=[commloc.loc.y];Z=[commloc.loc.z]'>JMP</a>)")
	else
		use_power = 0
		message_admins("[key_name(user)] turned \the [src] in [commarea] OFF. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[commloc.loc.x];Y=[commloc.loc.y];Z=[commloc.loc.z]'>JMP</a>)")
	toggle_cooldown = world.time + 40

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL))
		if(inoperable() || (health <= initial(health) * 0.5))
			to_chat(user, SPAN_WARNING("\The [src.name] needs repairs to have frequencies added to its software!"))
			return
		var/choice = tgui_input_list(user, "What do you wish to do?", "TC-3T comms tower", list("Wipe communication frequencies", "Add your faction's frequencies"))
		if(choice == "Wipe frequencies")
			freq_listening = null
			to_chat(user, SPAN_NOTICE("You wipe the preexisting frequencies from \the [src]."))
			return
		else if(choice == "Add your faction's frequencies")
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return
			switch(user.faction)
				if(FACTION_SURVIVOR)
					freq_listening |= COLONY_FREQ
				if(FACTION_CLF)
					freq_listening |= list(CLF_FREQ, CCT_FREQ)
				if(FACTION_UPP)
					freq_listening |= list(RUS_FREQ, CCT_FREQ)
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
		on = 0
		update_icon()
	else
		update_icon()

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
	use_power = 0
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
	freq_listening = list(COMM_FREQ, ENG_FREQ, SEC_FREQ, MED_FREQ, SUP_FREQ, ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ)

	//Common and other radio frequencies for people to freely use
/obj/structure/machinery/telecomms/receiver/preset/Initialize(mapload, ...)
	. = ..()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i

/obj/structure/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	autolinkers = list("receiverCent")
	freq_listening = list(ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, SOF_FREQ)


//Buses

/obj/structure/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(MED_FREQ, ENG_FREQ, SUP_FREQ)
	autolinkers = list("processor1", "medical", "engineering", "cargo")

/obj/structure/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ, ECHO_FREQ, CRYO_FREQ)
	autolinkers = list("processor2","squads")

/obj/structure/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ, ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ, SOF_FREQ)
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
	freq_listening = list(ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, SOF_FREQ)
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
	freq_listening = list(SUP_FREQ)
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
	freq_listening = list(COMM_FREQ, ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ, HC_FREQ, SOF_FREQ)
	autolinkers = list("command")

/obj/structure/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ, SUP_FREQ)
	autolinkers = list("engineering", "cargo")

/obj/structure/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	autolinkers = list("security")

/obj/structure/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(ERT_FREQ, DTH_FREQ, PMC_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, SOF_FREQ)
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
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommunications processing."
	density = 1
	anchored = 1
	use_power = 0
	idle_power_usage = 0
	machinetype = 6
	unslashable = TRUE
	unacidable = TRUE
	var/intercept = 0 // if nonzero, broadcasts all messages to syndicate channel

/obj/structure/machinery/telecomms/allinone/interceptor
	name = "Message Intercept Mainframe"
	intercept = 1
	freq_listening = list(RUS_FREQ)
