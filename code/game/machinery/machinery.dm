/*
Overview:
	Used to create objects that need a per step proc call.  Default definition of 'New()'
	stores a reference to src machine in global 'machines list'.  Default definition
	of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
	use_power (num)
		current state of auto power use.
		Possible Values:
			USE_POWER_NONE: 0 -- no auto power use
			USE_POWER_IDLE: 1 -- machine is using power at its idle power level
			USE_POWER_ACTIVE: 2 -- machine is using power at its active power level

	needs_power (num)
	is this thing affected by an area being unpowered
	Possible Values:
		FALSE -- machine will process as if though in a powered area
		TRUE -- machine will function normally

	active_power_usage (num)
		Value for the amount of power to use when in active power mode

	idle_power_usage (num)
		Value for the amount of power to use when in idle power mode

	power_channel (num)
		What channel to draw from when drawing power for power mode
		Possible Values:
			EQUIP:0 -- Equipment Channel
			LIGHT:2 -- Lighting Channel
			ENVIRON:3 -- Environment Channel

	component_parts (list)
		A list of component parts of machine used by frame based machines.

	uid (num)
		Unique id of machine across all machines.

	stat (bitflag)
		Machine status bit flags.
		Possible bit flags:
			BROKEN:1 -- Machine is broken
			NOPOWER:2 -- No power is being supplied to machine.
			POWEROFF:4 -- tbd
			MAINT:8 -- machine is currently under going maintenance.
			EMPED:16 -- temporary broken by EMP pulse

	manual (num)
		Currently unused.

Class Procs:
	New()  'game/machinery/machine.dm'

	Dispose()  'game/machinery/machine.dm'

		Default definition uses 'use_power', 'power_channel', 'active_power_usage',
		'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

	powered(chan = EQUIP)  'modules/power/power.dm'
		Checks to see if area that contains the object has power available for power
		channel given in 'chan'.

	use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
		Deducts 'amount' from the power channel 'chan' of the area that contains the object.
		If it's autocalled then everything is normal, if something else calls use_power we are going to
		need to recalculate the power two ticks in a row.

	power_change()    'modules/power/power.dm'
		Called by the area that contains the object when ever that area under goes a
		power state change (area runs out of power, or area channel is turned off).

	RefreshParts()    'game/machinery/machine.dm'
		Called to refresh the variables in the machine that are contributed to by parts
		contained in the component_parts list. (example: glass and material amounts for
		the autolathe)

		Default definition does nothing.

	assign_uid()    'game/machinery/machine.dm'
		Called by machine to assign a value to the uid variable.

	process()   'game/machinery/machine.dm'
		Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

//  NONE -- no auto power use
//  IDLE -- machine is using power at its idle power level
//  ACTIVE -- machine is using power at its active power level

/obj/structure/machinery
	name = "machinery"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	var/stat = 0
	var/use_power = USE_POWER_IDLE
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/needs_power = TRUE
	var/power_channel = POWER_CHANNEL_EQUIP
	var/mob/living/carbon/human/operator = null //Had no idea where to put this so I put this here. Used for operating machines with RELAY_CLICK
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts //list of all the parts used to build it, if made from certain kinds of frames.
	layer = OBJ_LAYER
	var/machine_processing = 0 // whether the machine is busy and requires process() calls in scheduler. // Please replace this by DF_ISPROCESSING in another refactor --fira
	throwpass = TRUE
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM
	var/power_machine = FALSE //Whether the machine should process on power, or normal processor
	/// Reverse lookup for a breaker_switch that if specified is controlling us
	var/obj/structure/machinery/colony_floodlight_switch/breaker_switch
	/// Whether this is toggled on
	var/is_on = TRUE

/obj/structure/machinery/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "-----MACHINERY-----")
	VV_DROPDOWN_OPTION(VV_HK_TOGGLEPOWER, "Toggle Needs Power")

/obj/structure/machinery/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_TOGGLEPOWER])
		if(!check_rights(R_VAREDIT))
			return

		needs_power = !needs_power
		power_change()
		message_admins("[key_name(src, TRUE)] has toggled needs_power to [needs_power] on [src] in [get_area(src)] ([x],[y],[z]).", x, y, z)


/obj/structure/machinery/Initialize(mapload, ...)
	. = ..()
	GLOB.machines += src
	var/area/A = get_area(src)
	if(A)
		A.add_machine(src) //takes care of adding machine's power usage

/obj/structure/machinery/Destroy()
	GLOB.machines -= src
	GLOB.processing_machines -= src
	GLOB.power_machines -= src
	var/area/A = get_area(src)
	if(A)
		A.remove_machine(src) //takes care of removing machine from power usage
	if(breaker_switch)
		breaker_switch.machinery_list -= src
		breaker_switch = null
	. = ..()

/obj/structure/machinery/initialize_pass_flags(datum/pass_flags_container/PF)
	if(PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM // Previously microwave.dm mistakenly gave everything PASS_OVER_THROW_ITEM

/obj/structure/machinery/proc/start_processing()
	if(!machine_processing)
		machine_processing = 1
		if(power_machine)
			addToListNoDupe(GLOB.power_machines, src)
		else
			addToListNoDupe(GLOB.processing_machines, src)

/obj/structure/machinery/proc/stop_processing()
	if(machine_processing)
		machine_processing = 0
		GLOB.processing_machines -= src
		GLOB.power_machines -= src

/obj/structure/machinery/process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/structure/machinery/get_examine_text(mob/user)
	. = ..()
	if(!stat)
		return

	. += "It does not appear to be working."
	var/msg = get_repair_move_text(FALSE)
	if(msg && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		. += SPAN_WARNING("[msg]")

/obj/structure/machinery/emp_act(severity)
	. = ..()
	if(use_power && stat == 0)
		use_power(7500/severity)
	new /obj/effect/overlay/temp/emp_sparks (loc)


/obj/structure/machinery/ex_act(severity)
	if(explo_proof)
		return

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
	return

//sets the use_power var and then forces an area power update
/obj/structure/machinery/proc/update_use_power(new_use_power)
	if (new_use_power == use_power)
		return //don't need to do anything

	var/delta_power = 0 //figuring how much our power delta is
	delta_power -= calculate_current_power_usage() //current usage
	use_power = new_use_power
	delta_power += calculate_current_power_usage() //updated usage

	//we're updating our power over time amount, not just using one-off power usage, hence why we're passing the channel
	use_power(delta_power, power_channel)

/obj/structure/machinery/proc/calculate_current_power_usage()
	switch(use_power)
		if(USE_POWER_IDLE)
			return idle_power_usage
		if(USE_POWER_ACTIVE)
			return idle_power_usage + active_power_usage
	return 0

/obj/structure/machinery/proc/operable(additional_flags = 0)
	return !inoperable(additional_flags)

/obj/structure/machinery/proc/inoperable(additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/structure/machinery/Topic(href, href_list)
	. = ..()
	if(.)
		return TRUE
	if(inoperable())
		return 1
	if(isliving(usr))
		var/mob/living/living = usr
		if(living.body_position == LYING_DOWN) // legacy. if you too find it doesn't make sense, consider removing it
			return TRUE
	if(usr.is_mob_restrained())
		return 1
	if(!is_valid_user(usr))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return 1

	src.add_fingerprint(usr)

	return 0

/obj/structure/machinery/proc/is_valid_user(mob/user)
	return (user.IsAdvancedToolUser(user) || isRemoteControlling(user))

/obj/structure/machinery/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/attack_hand(mob/living/user as mob)
	if(inoperable(MAINT))
		return TRUE
	if(user.is_mob_incapacitated())
		return TRUE
	if(!(istype(user, /mob/living/carbon/human) || isRemoteControlling(user) || istype(user, /mob/living/carbon/xenomorph)))
		if(!HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
			to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
			return TRUE
	if(!is_valid_user(user))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return TRUE
/*
	//distance checks are made by atom/proc/clicked()
	if ((get_dist(src, user) > 1 || !istype(src.loc, /turf)) && !isRemoteControlling(user))
		return 1
*/
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			visible_message(SPAN_DANGER("[H] stares cluelessly at [src] and drools."))
			return TRUE
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_DANGER("You momentarily forget how to use [src]."))
			return TRUE

	src.add_fingerprint(user)

	return FALSE

/obj/structure/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/structure/machinery/proc/state(msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("[icon2html(src, O)] [SPAN_NOTICE("[msg]")]", SHOW_MESSAGE_AUDIBLE)

/obj/structure/machinery/proc/ping(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 25, 0)

/obj/structure/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/structure/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
	var/obj/structure/machinery/constructable_frame/M = new /obj/structure/machinery/constructable_frame(loc)
	M.state = CONSTRUCTION_STATE_PROGRESS
	M.update_icon()
	for(var/obj/I in component_parts)
		if(I.reliability != 100 && crit_fail)
			I.crit_fail = 1
		I.forceMove(loc)
	qdel(src)
	return 1

/obj/structure/machinery/proc/get_repair_move_text(include_name = TRUE)
	return

/obj/structure/machinery/proc/set_is_on(is_on)
	src.is_on = is_on
	update_icon()

/obj/structure/machinery/proc/toggle_is_on()
	set_is_on(!is_on)
	return is_on

// UI related procs \\

/obj/structure/machinery/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

//made into "prop" from an old destilery project abandon 9 year ago.

/obj/structure/machinery/mill
	name = "\improper Mill"
	desc = "It is a machine that grinds produce."
	icon_state = "autolathe"
	icon = 'icons/obj/structures/machinery/autolathe.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/machinery/fermenter
	name = "\improper Fermenter"
	desc = "It is a machine that ferments produce into alcoholic drinks."
	icon_state = "autolathe"
	icon = 'icons/obj/structures/machinery/autolathe.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/machinery/still
	name = "\improper Still"
	desc = "It is a machine that produces hard liquor from alcoholic drinks."
	icon_state = "autolathe"
	icon = 'icons/obj/structures/machinery/autolathe.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/machinery/squeezer
	name = "\improper Squeezer"
	desc = "It is a machine that squeezes extracts from produce."
	icon_state = "autolathe"
	icon = 'icons/obj/structures/machinery/autolathe.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/machinery/fuelpump
	name = "\improper Fuel Pump"
	layer = ABOVE_MOB_LAYER
	desc = "It is a machine that pumps fuel around the ship."
	icon = 'icons/obj/structures/machinery/fuelpump.dmi'
	icon_state = "fuelpump_off"
	health = null
	explo_proof = TRUE
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	wrenchable = FALSE

/obj/structure/machinery/fuelpump/ex_act(severity)
	return

/obj/structure/machinery/fuelpump/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_FUEL_PUMP_UPDATE, PROC_REF(on_pump_update))

/obj/structure/machinery/fuelpump/proc/on_pump_update()
	SIGNAL_HANDLER
	playsound(src, 'sound/machines/resource_node/node_idle.ogg', 60, TRUE)
	update_icon()

/obj/structure/machinery/fuelpump/update_icon()
	if(stat & NOPOWER)
		icon_state = "fuelpump_off"
		return
	if(SShijack.hijack_status < HIJACK_OBJECTIVES_STARTED)
		icon_state = "fuelpump_on"
		return
	switch(SShijack.current_progress)
		if(-INFINITY to 24)
			icon_state = "fuelpump_0"
		if(25 to 49)
			icon_state = "fuelpump_25"
		if(50 to 74)
			icon_state = "fuelpump_50"
		if(75 to 99)
			icon_state = "fuelpump_75"
		if(100 to INFINITY)
			icon_state = "fuelpump_100"
		else
			icon_state = "fuelpump_on" // Never should happen

/obj/structure/machinery/fuelpump/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(inoperable())
		return
	if(SShijack.hijack_status < HIJACK_OBJECTIVES_STARTED)
		return
	switch(SShijack.current_progress)
		if(-INFINITY to 24)
			. += SPAN_NOTICE("It looks like it barely has any fuel yet.")
		if(25 to 49)
			. += SPAN_NOTICE("It looks like it has accumulated some fuel.")
		if(50 to 74)
			. += SPAN_NOTICE("It looks like the fuel tank is a little over half full.")
		if(75 to 99)
			. += SPAN_NOTICE("It looks like the fuel tank is almost full.")
		if(100 to INFINITY)
			. += SPAN_NOTICE("It looks like the fuel tank is full.")
		else
			. += SPAN_NOTICE("It looks like something is wrong!") // Never should happen
