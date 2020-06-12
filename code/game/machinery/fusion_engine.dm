//Experimental engine for the Almayer.  Should be fancier.  I expect I'll eventually make it totally seperate from the Geothermal as I don't like the procs... - Apop


#define FUSION_ENGINE_MAX_POWER_GEN	50000 //Full capacity

#define FUSION_ENGINE_FAIL_CHECK_TICKS	100 //Check for failure every this many ticks

/obj/structure/machinery/power/fusion_engine
	name = "\improper S-52 fusion reactor"
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "off-0"
	desc = "A Westingland S-52 Fusion Reactor.  Takes fuels cells and converts them to power for the ship.  Also produces a large amount of heat."
	directwired = 0     //Requires a cable directly underneath
	unslashable = TRUE
	unacidable = TRUE      //NOPE.jpg
	anchored = 1
	density = 1

	var/power_gen_percent = 0 //50,000W at full capacity
	var/buildstate = 0 //What state of building it are we on, 0-3, 1 is "broken", the default
	var/is_on = TRUE  //Is this damn thing on or what?
	var/fail_rate = FALSE //% chance of failure each fail_tick check
	var/cur_tick = 0 //Tick updater

	var/obj/item/fuelCell/fusion_cell = new //Starts with a fuel cell loaded in.  Maybe replace with the plasma tanks in the future and have it consume plasma?  Possibly remove this later if it's irrelevent...
	var/fuel_rate = 0.00 //Rate at which fuel is used.  Based mostly on how long the generator has been running.
	power_machine = TRUE

/obj/structure/machinery/power/fusion_engine/New()
	fusion_cell.fuel_amount = 100
	update_icon()
	connect_to_network() //Should start with a cable piece underneath, if it doesn't, something's messed up in mapping
	..()
	start_processing()

/obj/structure/machinery/power/fusion_engine/power_change()
	return

/obj/structure/machinery/power/fusion_engine/process()
	if(!is_on || buildstate || !anchored || !powernet || !fusion_cell) //Default logic checking
		if(is_on)
			is_on = FALSE
			power_gen_percent = 0
			update_icon()
			stop_processing()
		return 0
	if (fusion_cell.fuel_amount <= 0)
		visible_message("[htmlicon(src, viewers(src))] <b>[src]</b> flashes that the fuel cell is empty as the engine seizes.")
		fuel_rate = 0
		buildstate = 2  //No fuel really fucks it.
		is_on = 0
		power_gen_percent = 0
		fail_rate+=2 //Each time the engine is allowed to seize up it's fail rate for the future increases because reasons.
		update_icon()
		stop_processing()
		return FALSE

	if(!check_failure())

		if(power_gen_percent < 100) power_gen_percent++

		switch(power_gen_percent) //Flavor text!
			if(10)
				visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> begins to whirr as it powers up.")]")
				fuel_rate = 0.025
			if(50)
				visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> begins to hum loudly as it reaches half capacity.")]")
				fuel_rate = 0.05
			if(99)
				visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> rumbles loudly as the combustion and thermal chambers reach full strength.")]")
				fuel_rate = 0.1

		add_avail(FUSION_ENGINE_MAX_POWER_GEN * (power_gen_percent / 100) ) //Nope, all good, just add the power
		
		update_icon()


/obj/structure/machinery/power/fusion_engine/attack_hand(mob/user)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You have no idea how to use that.")) //No ayylamos
		return FALSE
	add_fingerprint(user)
	switch(buildstate)
		if(1)
			to_chat(user, SPAN_INFO("Use a blowtorch, then wirecutters, then wrench to repair it."))
			return FALSE
		if(2)
			to_chat(user, SPAN_NOTICE("Use a wirecutters, then wrench to repair it."))
			return FALSE
		if(3)
			to_chat(user, SPAN_NOTICE("Use a wrench to repair it."))
			return FALSE
	if(is_on)
		visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> beeps softly and the humming stops as [usr] shuts off the generator.")]")
		is_on = 0
		power_gen_percent = 0
		cur_tick = 0
		update_icon()
		stop_processing()
		return TRUE

	if(!fusion_cell)
		to_chat(user, SPAN_NOTICE("The reactor requires a fuel cell before you can turn it on."))
		return FALSE

	if(!powernet)
		if(!connect_to_network())
			to_chat(user, SPAN_WARNING("Power network not found, make sure the engine is connected to a cable."))
			return FALSE

	if(fusion_cell.fuel_amount <= 10)
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("<b>[src]</b>: Fuel levels critically low.")]")
	visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> beeps loudly as [user] turns the generator on and begins the process of fusion...")]")
	fuel_rate = 0.01
	is_on = 1
	cur_tick = 0
	update_icon()
	start_processing()
	return TRUE


/obj/structure/machinery/power/fusion_engine/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/fuelCell))
		if(is_on)
			to_chat(user, SPAN_WARNING("The [src] needs to be turned off first."))
			return TRUE
		if(!fusion_cell)
			if(user.drop_inv_item_to_loc(O, src))
				fusion_cell = O
				update_icon()
				to_chat(user, SPAN_NOTICE("You load the [src] with the [O]."))
			return TRUE
		else
			to_chat(user, SPAN_WARNING("You need to remove the fuel cell from [src] first."))
			return TRUE
		return TRUE
	else if(iswelder(O))
		if(buildstate == 1)
			var/obj/item/tool/weldingtool/WT = O
			if(WT.remove_fuel(1, user))
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
					user.visible_message(SPAN_NOTICE("[user] fumbles around figuring out [src]'s internals."),
					SPAN_NOTICE("You fumble around figuring out [src]'s internals."))
					var/fumbling_time = 100 - 20 * user.skills.get_skill_level(SKILL_ENGINEER)
					if(!do_after(user, fumbling_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) return
				playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
				user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s internal damage."),
				SPAN_NOTICE("You start welding [src]'s internal damage."))
				if(do_after(user, 200, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(buildstate != 1 || is_on || !WT.isOn()) 
						return FALSE
					playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
					buildstate = 2
					user.visible_message(SPAN_NOTICE("[user] welds [src]'s internal damage."),
					SPAN_NOTICE("You weld [src]'s internal damage."))
					update_icon()
					return TRUE
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
				return FALSE
	else if(istype(O,/obj/item/tool/wirecutters))
		if(buildstate == 2 && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				user.visible_message(SPAN_NOTICE("[user] fumbles around figuring out [src]'s wiring."),
				SPAN_NOTICE("You fumble around figuring out [src]'s wiring."))
				var/fumbling_time = 100 - 20 * user.skills.get_skill_level(SKILL_ENGINEER)
				if(!do_after(user, fumbling_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) return
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts securing [src]'s wiring."),
			SPAN_NOTICE("You start securing [src]'s wiring."))
			if(do_after(user, 120, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 12))
				if(buildstate != 2 || is_on) 
					return FALSE
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				buildstate = 3
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s wiring."),
				SPAN_NOTICE("You secure [src]'s wiring."))
				update_icon()
				return TRUE
	else if(iswrench(O))
		if(buildstate == 3 && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				user.visible_message(SPAN_NOTICE("[user] fumbles around figuring out [src]'s tubing and plating."),
				SPAN_NOTICE("You fumble around figuring out [src]'s tubing and plating."))
				var/fumbling_time = 100 - 20 * user.skills.get_skill_level(SKILL_ENGINEER)
				if(!do_after(user, fumbling_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) return
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts repairing [src]'s tubing and plating."),
			SPAN_NOTICE("You start repairing [src]'s tubing and plating."))
			if(do_after(user, 150, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(buildstate != 3 || is_on) 
					return FALSE
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				buildstate = 0
				user.count_niche_stat(STATISTICS_NICHE_REPAIR_GENERATOR)
				user.visible_message(SPAN_NOTICE("[user] repairs [src]'s tubing and plating."),
				SPAN_NOTICE("You repair [src]'s tubing and plating."))
				update_icon()
				return TRUE
	else if(iscrowbar(O))
		if(buildstate)
			to_chat(user, SPAN_WARNING("You must repair the generator before working with its fuel cell."))
			return
		if(is_on)
			to_chat(user, SPAN_WARNING("You must turn off the generator before working with its fuel cell."))
			return
		if(!fusion_cell)
			to_chat(user, SPAN_WARNING("There is no cell to remove."))
		else
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				user.visible_message(SPAN_WARNING("[user] fumbles around figuring out [src]'s fuel receptacle."),
				SPAN_WARNING("You fumble around figuring out [src]'s fuel receptacle."))
				var/fumbling_time = 100 - 20 * user.skills.get_skill_level(SKILL_ENGINEER)
				if(!do_after(user, fumbling_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) return
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts prying [src]'s fuel receptacle open."),
			SPAN_NOTICE("You start prying [src]'s fuel receptacle open."))
			if(do_after(user, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(buildstate != 0 || is_on || !fusion_cell) 
					return FALSE
				user.visible_message(SPAN_NOTICE("[user] pries [src]'s fuel receptacle open and removes the cell."),
				SPAN_NOTICE("You pry [src]'s fuel receptacle open and remove the cell.."))
				fusion_cell.update_icon()
				user.put_in_hands(fusion_cell)
				fusion_cell = null
				update_icon()
				return TRUE
	else
		return ..()

/obj/structure/machinery/power/fusion_engine/examine(mob/user)
	..()
	if(ishuman(user))
		if(buildstate)
			to_chat(user, SPAN_INFO("It's broken."))
			switch(buildstate)
				if(1)
					to_chat(user, SPAN_INFO("Use a blowtorch, then wirecutters, then wrench to repair it."))
				if(2)
					to_chat(user, SPAN_INFO("Use a wirecutters, then wrench to repair it."))
				if(3)
					to_chat(user, SPAN_INFO("Use a wrench to repair it."))
			return FALSE

		if(!is_on)
			to_chat(user, SPAN_INFO("It looks offline."))
		else
			to_chat(user, SPAN_INFO("The power gauge reads: [power_gen_percent]%"))
		if(fusion_cell)
			to_chat(user, SPAN_INFO("You can see a fuel cell in the receptacle."))
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_OT))
				switch(fusion_cell.get_fuel_percent())
					if(0 to 10)
						to_chat(user, SPAN_DANGER("The fuel cell is critically low."))
					if(10 to 25)
						to_chat(user, SPAN_WARNING("The fuel cell is running low."))
					if(25 to 50)
						to_chat(user, SPAN_INFO("The fuel cell is a little under halfway."))
					if(50 to 75)
						to_chat(user, SPAN_INFO("The fuel cell is a little above halfway."))
					if(75 to INFINITY)
						to_chat(user, SPAN_INFO("The fuel cell is nearly full."))
		else
			to_chat(user, SPAN_INFO("There is no fuel cell in the receptacle."))

/obj/structure/machinery/power/fusion_engine/update_icon()
	switch(buildstate)
		if(0)
			if(fusion_cell)
				var/pstatus = is_on ? "on" : "off"
				switch(fusion_cell.get_fuel_percent())
					if(0 to 10)
						icon_state = "[pstatus]-10"
					if(10 to 25)
						icon_state = "[pstatus]-25"
					if(25 to 50)
						icon_state = "[pstatus]-50"
					if(50 to 75)
						icon_state = "[pstatus]-75"
					if(75 to INFINITY)
						icon_state = "[pstatus]-100"
			else
				icon_state = "off"

		if(1)
			icon_state = "weld"
		if(2)
			icon_state = "wire"
		if(3)
			icon_state = "wrench"


/obj/structure/machinery/power/fusion_engine/proc/check_failure()
	if(cur_tick < FUSION_ENGINE_FAIL_CHECK_TICKS) //Nope, not time for it yet
		cur_tick++
		return 0
	cur_tick = 0 //reset the timer
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(prob(25))
			visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and a fuse blows! Use wirecutters, then a wrench to repair it.")]")
			buildstate = 2
		else
			visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and sprays random pieces everywhere! Use a wrench to repair it.")]")
			buildstate = 3
		is_on = 0
		power_gen_percent = 0
		update_icon()
		stop_processing()
		return 1
	else
		return 0







//FUEL CELL
/obj/item/fuelCell
	name = "\improper WL-6 universal fuel cell"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "cell-full"
	desc = "A rechargable fuel cell designed to work as a power source for the Cheyenne-Class transport or for Westingland S-52 Reactors."
	var/fuel_amount = 100.0
	var/max_fuel_amount = 100.0

/obj/item/fuelCell/update_icon()
	switch(get_fuel_percent())
		if(-INFINITY to 0)
			icon_state = "cell-empty"
		if(0 to 25)
			icon_state = "cell-low"
		if(25 to 75)
			icon_state = "cell-medium"
		if(75 to 99)
			icon_state = "cell-high"
		else
			icon_state = "cell-full"

/obj/item/fuelCell/examine(mob/user)
	..()
	if(ishuman(user))
		to_chat(user, "The fuel indicator reads: [get_fuel_percent()]%")

/obj/item/fuelCell/proc/get_fuel_percent()
	return round(100*fuel_amount/max_fuel_amount)

/obj/item/fuelCell/proc/is_regenerated()
	return (fuel_amount == max_fuel_amount)

/obj/item/fuelCell/proc/give(amount)
	fuel_amount += amount
	if(fuel_amount > max_fuel_amount)
		fuel_amount = max_fuel_amount
