// the SMES
// stores power

#define SMESMAXCHARGELEVEL 250000
#define SMESMAXOUTPUT 250000

/obj/structure/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_NONE
	directwired = 0

	var/loaddemand = 0 //For use in restore()
	var/capacity = 5e6 //Maximum amount of power it can hold
	var/charge = 0 //Current amount of power it holds
	var/last_charge = 0

	var/inputting = 0 //1 if it's actually inputting, 0 if not //used to be var/charging
	var/input_attempt = 0 //1 if it's trying to charge, 0 if not. //used to be var/chargemode
	var/input_level = 0 //Amount of power it tries to charge from powernet //used to be var/chargelevel
	var/input_level_max = 200000
	var/input_available = 0 //how much power it can get

	var/outputting = 1 //1 if it's outputting power, 0 if not. //used to be var/online
	var/output_level = 50000 //Amount of power it tries to output //used to be var/output
	var/output_level_max = 200000
	var/output_used = 0 //Amount of power it actually outputs to the powernet //used to be var/lastout
	var/last_outputting = 0
	var/last_output = 0

	var/name_tag = null
	//Holders for powerout event.

	var/open_hatch = 0
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/should_be_mapped = 0 // If this is set to 0 it will send out warning on New()
	power_machine = TRUE
	var/explosion_proof = TRUE

/obj/structure/machinery/power/smes/Initialize()
	. = ..()

	dir_loop:
		for(var/d in GLOB.cardinals)
			var/turf/T = get_step(src, d)
			for(var/obj/structure/machinery/power/terminal/term in T)
				if(term && term.dir == turn(d, 180))
					terminal = term
					break dir_loop
	if(!terminal)
		stat |= BROKEN
		return
	terminal.master = src
	updateicon()
	start_processing()

	if(!should_be_mapped)
		warning("Non-buildable or Non-magical SMES at [src.x]X [src.y]Y [src.z]Z")

	return INITIALIZE_HINT_ROUNDSTART

/obj/structure/machinery/power/smes/ex_act(severity)
	if(explosion_proof)
		return
	else
		.=..()

/obj/structure/machinery/power/smes/LateInitialize()
	. = ..()

	if(QDELETED(src))
		return

	if(!powernet && !connect_to_network())
		CRASH("[src] has failed to connect to a power network. Check that it has been mapped correctly.")
	if(terminal && !terminal.powernet)
		terminal.connect_to_network()

/obj/structure/machinery/power/smes/proc/updateicon()
	overlays.Cut()
	if(stat & BROKEN)
		return

	overlays += image('icons/obj/structures/machinery/power.dmi', "smes_op[outputting]")

	if(inputting == 2)
		overlays += image('icons/obj/structures/machinery/power.dmi', "smes_oc2")
	else if (inputting == 1)
		overlays += image('icons/obj/structures/machinery/power.dmi', "smes_oc1")
	else
		if(input_attempt)
			overlays += image('icons/obj/structures/machinery/power.dmi', "smes_oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('icons/obj/structures/machinery/power.dmi', "smes_og[clevel]")
	return


/obj/structure/machinery/power/smes/proc/chargedisplay()
	return floor(5.5*charge/(capacity ? capacity : 5e6))

#define SMESRATE 0.05 // rate of internal charge to external power


/obj/structure/machinery/power/smes/process()
	if(stat & BROKEN)
		return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = outputting

	if(terminal)
		//If chargemod is set, try to charge
		//Use inputting to let the player know whether we were able to obtain our target load.
		//TODO: Add a meter to tell players how much charge we are actually getting, and only set inputting to 0 when we are unable to get any charge at all.
		if(input_attempt)
			var/target_load = min((capacity-charge)/SMESRATE, input_level) // charge at set rate, limited to spare capacity
			var/actual_load = add_load(target_load) // add the load to the terminal side network
			charge += actual_load * SMESRATE // increase the charge
			input_available = actual_load

			if (actual_load >= target_load) // Did we charge at full rate?
				inputting = 2
			else if (actual_load) // If not, did we charge at least partially?
				inputting = 1
			else // Or not at all?
				inputting = 0

	if(outputting) // if outputting
		output_used = min( charge/SMESRATE, output_level) //limit output to that stored
		charge -= output_used*SMESRATE // reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used) // add output to powernet (smes side)
		if(charge < 0.0001)
			outputting = 0 // stop output if charge falls to zero

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		updateicon()

	return

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/structure/machinery/power/smes/proc/restore()
	if(stat & BROKEN)
		return

	if(!outputting)
		loaddemand = 0
		return

	var/excess = powernet.netexcess // this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(output_used, excess) // clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity-charge)/SMESRATE, excess) // for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess * SMESRATE
	powernet.netexcess -= excess // remove the excess from the powernet, so later SMESes don't try to use it

	loaddemand = output_used-excess

	if(clev != chargedisplay() )
		updateicon()
	return

//Will return 1 on failure
/obj/structure/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, SPAN_WARNING("You must not be on the same tile as \the [src]."))
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, NORTHWEST)
			tempDir = NORTH
		if (SOUTHEAST, SOUTHWEST)
			tempDir = SOUTH
	var/turf/tempLoc = get_step(user, user.dir)
	if(user.dir == tempDir)
		tempLoc = user.loc
	if (istype(tempLoc, /turf/open/space))
		to_chat(user, SPAN_WARNING("You can't build a terminal on space."))
		return 1
	else if (istype(tempLoc))
		if(tempLoc.intact_tile)
			to_chat(user, SPAN_WARNING("You must remove the floor plating first."))
			return 1
	to_chat(user, SPAN_NOTICE("You start adding cable to \the [src]."))
	if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		terminal = new /obj/structure/machinery/power/terminal(tempLoc)
		terminal.setDir(tempDir)
		terminal.master = src
		start_processing()
		return 0
	return 1


/obj/structure/machinery/power/smes/add_load(amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/structure/machinery/power/smes/power_change()
	return

/obj/structure/machinery/power/smes/attack_remote(mob/user)
	add_fingerprint(user)
	tgui_interact(user)


/obj/structure/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)


/obj/structure/machinery/power/smes/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!open_hatch)
			open_hatch = 1
			to_chat(user, SPAN_NOTICE("You open the maintenance hatch of [src]."))
			return 0
		else
			open_hatch = 0
			to_chat(user, SPAN_NOTICE("You close the maintenance hatch of [src]."))
			return 0

	if (!open_hatch)
		to_chat(user, SPAN_WARNING("You need to open access hatch on [src] first!"))
		return 0

	if(istype(W, /obj/item/stack/cable_coil) && !terminal && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = W
		if (CC.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You need more cables."))
			building_terminal = 0
			return 0
		if (make_terminal(user))
			building_terminal = 0
			return 0
		building_terminal = 0
		CC.use(10)
		user.visible_message(
				SPAN_NOTICE("[user.name] has added cables to \the [src]."),
				SPAN_NOTICE("You added cables to \the [src]."))
		terminal.connect_to_network()
		stat = 0
		return 0

	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && terminal && !building_terminal)
		building_terminal = 1
		var/turf/tempTDir = terminal.loc
		if (istype(tempTDir))
			if(tempTDir.intact_tile)
				to_chat(user, SPAN_WARNING("You must remove the floor plating first."))
			else
				to_chat(user, SPAN_NOTICE("You begin to cut the cables..."))
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 25, 1)
				if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
						var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						building_terminal = 0
						return 0
					new /obj/item/stack/cable_coil(loc,10)
					user.visible_message(
						SPAN_NOTICE("[user.name] cut the cables and dismantled the power terminal."),
						SPAN_NOTICE("You cut the cables and dismantle the power terminal."))
					qdel(terminal)
					terminal = null
		building_terminal = 0
		return 0
	return 1

// TGUI STUFF \\

/obj/structure/machinery/power/smes/ui_status(mob/user)
	. = ..()
	if(stat & BROKEN)
		return UI_CLOSE
	if(open_hatch)
		return UI_DISABLED

/obj/structure/machinery/power/smes/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/power/smes/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Smes", name)
		ui.open()

/obj/structure/machinery/power/smes/ui_data()
	var/list/data = list(
		"capacity" = capacity,
		"capacityPercent" = round(100*charge/capacity, 0.1),
		"charge" = charge,
		"inputAttempt" = input_attempt,
		"inputting" = inputting,
		"inputLevel" = input_level,
		"inputLevel_text" = display_power(input_level),
		"inputLevelMax" = input_level_max,
		"inputAvailable" = input_available,
		"outputAttempt" = outputting,
		"outputting" = outputting,
		"outputLevel" = output_level,
		"outputLevel_text" = display_power(output_level),
		"outputLevelMax" = output_level_max,
		"outputUsed" = output_used,
	)

	return data

/obj/structure/machinery/power/smes/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("tryinput")
			input_attempt = !input_attempt
			msg_admin_niche("[key_name(usr)] toggled \the [src]'s input [input_attempt ? "On" : "Off"].")
			update_icon()
			. = TRUE
		if("tryoutput")
			outputting = !outputting
			msg_admin_niche("[key_name(usr)] toggled \the [src]'s output [outputting ? "On" : "Off"].")
			update_icon()
			. = TRUE
		if("input")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = input_level_max
				. = TRUE
			else if(adjust)
				target = input_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				input_level = clamp(target, 0, input_level_max)
			msg_admin_niche("[key_name(usr)] set [src]'s input level to [input_level].")
		if("output")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = output_level_max
				. = TRUE
			else if(adjust)
				target = output_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				output_level = clamp(target, 0, output_level_max)
				msg_admin_niche("[key_name(usr)] set [src]'s output level to [input_level].")

/obj/structure/machinery/power/smes/proc/ion_act()
	if(is_ground_level(z))
		if(prob(1)) //explosion
			for(var/mob/M as anything in viewers(src))
				M.show_message(SPAN_DANGER("\The [src.name] is making strange noises!"), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("You hear sizzling electronics."), SHOW_MESSAGE_AUDIBLE)
			sleep(10*pick(4,5,6,7,10,14))
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(1, 0, src.loc)
			smoke.attach(src)
			smoke.start()
			explosion(src.loc, -1, 0, 1, 3, 1, 0)
			qdel(src)
			return
		if(prob(15)) //Power drain
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)
		if(prob(5)) //smoke only
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(1, 0, src.loc)
			smoke.attach(src)
			smoke.start()


/obj/structure/machinery/power/smes/emp_act(severity)
	. = ..()
	outputting = 0
	inputting = 0
	output_level = 0
	charge -= 1e6/severity
	if (charge < 0)
		charge = 0
	spawn(100)
		output_level = initial(output_level)
		inputting = initial(inputting)
		outputting = initial(outputting)



/obj/structure/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. Magically produces power."
	capacity = 9000000
	output_level = 250000
	should_be_mapped = 1

/obj/structure/machinery/power/smes/magical/process()
	charge = 5000000
	..()

/proc/rate_control(S, V, C, Min=1, Max=5, Limit=null)
	var/href = "<A href='byond://?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit)
		return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate

/obj/structure/machinery/power/smes/magical/yautja
	name = "Yautja Energy Core"
	desc = "A highly advanced power source of Yautja design, utilizing unknown technology to generate and distribute energy efficiently throughout the vessel."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'

#undef SMESRATE
