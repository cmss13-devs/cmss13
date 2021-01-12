/obj/structure/machinery/power/geothermal
	name = "\improper G-11 geothermal generator"
	icon = 'icons/obj/structures/machinery/geothermal.dmi'
	icon_state = "weld"
	desc = "A thermoelectric generator sitting atop a plasma-filled borehole. This one is heavily damaged. Use a blowtorch, wirecutters, then wrench to repair it."
	anchored = 1
	density = 1
	directwired = 0     //Requires a cable directly underneath
	unslashable = TRUE
	unacidable = TRUE      //NOPE.jpg
	var/power_gen_percent = 0 //100,000W at full capacity
	var/power_generation_max = 100000 //Full capacity
	var/powernet_connection_failed = 0 //Logic checking for powernets
	var/buildstate = 1 //What state of building it are we on, 0-3, 1 is "broken", the default
	var/is_on = 0  //Is this damn thing on or what?
	var/fail_rate = 10 //% chance of failure each fail_tick check
	var/fail_check_ticks = 100 //Check for failure every this many ticks
	var/cur_tick = 0 //Tick updater
	power_machine = TRUE

//We don't want to cut/update the power overlays every single proc. Just when it actually changes. This should save on CPU cycles. Efficiency!
/obj/structure/machinery/power/geothermal/update_icon()
	..()
	if(!buildstate && is_on)
		desc = "A thermoelectric generator sitting atop a borehole dug deep in the planet's surface. It generates energy by boiling the plasma steam that rises from the well.\nIt is old technology and has a large failure rate, and must be repaired frequently.\nIt is currently on, and beeping randomly amid faint hisses of steam."
		switch(power_gen_percent)
			if(25) icon_state = "on[power_gen_percent]"
			if(50) icon_state = "on[power_gen_percent]"
			if(75) icon_state = "on[power_gen_percent]"
			if(100) icon_state = "on[power_gen_percent]"


	else if (!buildstate && !is_on)
		icon_state = "off"
		desc = "A thermoelectric generator sitting atop a borehole dug deep in the planet's surface. It generates energy by boiling the plasma steam that rises from the well.\nIt is old technology and has a large failure rate, and must be repaired frequently.\nIt is currently turned off and silent."
	else
		if(buildstate == 1)
			icon_state = "weld"
			desc = "A thermoelectric generator sitting atop a plasma-filled borehole. This one is heavily damaged. Use a blowtorch, wirecutters, then wrench to repair it."
		else if(buildstate == 2)
			icon_state = "wire"
			desc = "A thermoelectric generator sitting atop a plasma-filled borehole. This one is damaged. Use a wirecutters, then wrench to repair it."
		else
			icon_state = "wrench"
			desc = "A thermoelectric generator sitting atop a plasma-filled borehole. This one is lightly damaged. Use a wrench to repair it."

/obj/structure/machinery/power/geothermal/Initialize(mapload, ...)
	. = ..()
	if(!connect_to_network()) //Should start with a cable piece underneath, if it doesn't, something's messed up in mapping
		powernet_connection_failed = 1

/obj/structure/machinery/power/geothermal/power_change()
	return

/obj/structure/machinery/power/geothermal/process()
	if(!is_on || buildstate || !anchored) //Default logic checking
		return 0

	if(!powernet && !powernet_connection_failed) //Powernet checking, make sure there's valid cables & powernets
		if(!connect_to_network())
			powernet_connection_failed = 1 //God damn it, where'd our network go
			is_on = 0
			stop_processing()
			// Error! Check again in 15 seconds. Someone could have blown/acided or snipped a cable
			addtimer(VARSET_CALLBACK(src, powernet_connection_failed, FALSE), 15 SECONDS)
	else if(powernet) //All good! Let's fire it up!
		if(!check_failure()) //Wait! Check to see if it breaks during processing
			update_icon()
			if(power_gen_percent < 100) power_gen_percent++
			switch(power_gen_percent)
				if(10) visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> begins to whirr as it powers up.")]")
				if(50) visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> begins to hum loudly as it reaches half capacity.")]")
				if(99) visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> rumbles loudly as the combustion and thermal chambers reach full strength.")]")
			add_avail(power_generation_max * (power_gen_percent / 100) ) //Nope, all good, just add the power

/obj/structure/machinery/power/geothermal/proc/check_failure()
	cur_tick++
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		return 0
	else if(cur_tick > fail_check_ticks) //Went past with no fail, reset the timer
		cur_tick = 0
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(rand(0,3) == 0)
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and a fuse blows! Use wirecutters, then a wrench to repair it.")]")
			buildstate = 2
			icon_state = "wire"
		else
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and sprays random pieces everywhere! Use a wrench to repair it.")]")
			buildstate = 3
			icon_state = "wrench"
		is_on = 0
		power_gen_percent = 0
		update_icon()
		cur_tick = 0
		stop_processing()
		return 1
	return 0 //Nope, all fine

/obj/structure/machinery/power/geothermal/attack_hand(mob/user as mob)
	if(!anchored) return 0 //Shouldn't actually be possible
	if(user.is_mob_incapacitated()) return 0
	if(!ishuman(user))
		to_chat(user, SPAN_DANGER("You have no idea how to use that.")) //No xenos or mankeys
		return 0

	add_fingerprint(user)

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You have no clue how this thing works..."))
		return 0

	if(buildstate == 1)
		to_chat(usr, SPAN_INFO("Use a blowtorch, then wirecutters, then wrench to repair it."))
		return 0
	else if (buildstate == 2)
		to_chat(usr, SPAN_INFO("Use a wirecutters, then wrench to repair it."))
		return 0
	else if (buildstate == 3)
		to_chat(usr, SPAN_INFO("Use a wrench to repair it."))
		return 0
	if(is_on)
		visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> beeps softly and the humming stops as [usr] shuts off the turbines.")]")
		is_on = 0
		power_gen_percent = 0
		cur_tick = 0
		icon_state = "off"
		stop_processing()
		return 1
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> beeps loudly as [usr] turns on the turbines and the generator begins spinning up.")]")
	icon_state = "on10"
	is_on = 1
	cur_tick = 0
	start_processing()
	return 1

/obj/structure/machinery/power/geothermal/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(iswelder(O))
		if(buildstate == 1 && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return 0
			var/obj/item/tool/weldingtool/WT = O
			if(WT.remove_fuel(1, user))

				playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
				user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s internal damage."),
				SPAN_NOTICE("You start welding [src]'s internal damage."))
				if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
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
				return
	else if(iswirecutter(O))
		if(buildstate == 2 && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return 0
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts securing [src]'s wiring."),
			SPAN_NOTICE("You start securing [src]'s wiring."))
			if(do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 12))
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
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return 0
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts repairing [src]'s tubing and plating."),
			SPAN_NOTICE("You start repairing [src]'s tubing and plating."))
			if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(buildstate != 3 || is_on)
					return FALSE
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				buildstate = 0
				user.count_niche_stat(STATISTICS_NICHE_REPAIR_GENERATOR)
				user.visible_message(SPAN_NOTICE("[user] repairs [src]'s tubing and plating."),
				SPAN_NOTICE("You repair [src]'s tubing and plating."))
				update_icon()
				return TRUE
	else
		return ..() //Deal with everything else, like hitting with stuff

//Putting these here since it's power-related
/obj/structure/machinery/colony_floodlight_switch
	name = "Colony Floodlight Switch"
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the floodlights surrounding the archaeology complex. It only functions when there is power."
	density = 0
	anchored = 1
	var/ispowered = 0
	var/turned_on = 0 //has to be toggled in engineering
	use_power = 1
	unslashable = TRUE
	unacidable = TRUE
	var/list/floodlist = list() // This will save our list of floodlights on the map
	power_machine = TRUE

/obj/structure/machinery/colony_floodlight_switch/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/machinery/colony_floodlight/F in machines)
		floodlist += F
		F.fswitch = src
	start_processing()

/obj/structure/machinery/colony_floodlight_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(turned_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_floodlight_switch/process()
	var/lightpower = 0
	for(var/obj/structure/machinery/colony_floodlight/C in floodlist)
		if(!C.is_lit)
			continue
		lightpower += C.power_tick
	use_power(lightpower)

/obj/structure/machinery/colony_floodlight_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && turned_on)
			toggle_lights()
		ispowered = 0
		turned_on = 0
		update_icon()
	else
		ispowered = 1
		update_icon()

/obj/structure/machinery/colony_floodlight_switch/proc/toggle_lights()
	for(var/obj/structure/machinery/colony_floodlight/F in floodlist)
		spawn(rand(0,50))
			F.is_lit = !F.is_lit
			if(!F.damaged)
				if(F.is_lit) //Shut it down
					F.SetLuminosity(F.lum_value)
				else
					F.SetLuminosity(0)
			F.update_icon()
	return 0

/obj/structure/machinery/colony_floodlight_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "Nice try.")
		return 0
	if(!ispowered)
		to_chat(user, "Nothing happens.")
		return 0
	playsound(src,'sound/machines/click.ogg', 15, 1)
	use_power(5)
	toggle_lights()
	turned_on = !(src.turned_on)
	update_icon()
	return 1


#define FLOODLIGHT_REPAIR_UNSCREW 	0
#define FLOODLIGHT_REPAIR_CROWBAR 	1
#define FLOODLIGHT_REPAIR_WELD 		2
#define FLOODLIGHT_REPAIR_CABLE 	3
#define FLOODLIGHT_REPAIR_SCREW 	4

/obj/structure/machinery/colony_floodlight
	name = "Colony Floodlight"
	icon = 'icons/obj/structures/machinery/big_floodlight.dmi'
	icon_state = "flood_s_off"
	density = 1
	anchored = 1
	layer = WINDOW_LAYER
	var/damaged = 0 //Can be smashed by xenos
	var/is_lit = 0 //whether the floodlight is switched to on or off. Does not necessarily mean it emits light.
	unslashable = TRUE
	unacidable = TRUE
	var/power_tick = 50 // power each floodlight takes up per process
	use_power = 0 //It's the switch that uses the actual power, not the lights
	var/obj/structure/machinery/colony_floodlight_switch/fswitch = null //Reverse lookup for power grabbing in area
	var/lum_value = 7
	var/repair_state = 0
	health = 150

/obj/structure/machinery/colony_floodlight/Destroy()
	SetLuminosity(0)
	if(fswitch)
		fswitch.floodlist -= src
		fswitch = null
	. = ..()

/obj/structure/machinery/colony_floodlight/update_icon()
	if(damaged)
		icon_state = "flood_s_dmg"
	else if(is_lit)
		icon_state = "flood_s_on"
	else
		icon_state = "flood_s_off"

/obj/structure/machinery/colony_floodlight/attackby(obj/item/I, mob/user)
	if(damaged)
		if(isscrewdriver(I))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts unscrewing [src]'s maintenance hatch."), \
				SPAN_NOTICE("You start unscrewing [src]'s maintenance hatch."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_UNSCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_CROWBAR
					user.visible_message(SPAN_NOTICE("[user] unscrews [src]'s maintenance hatch."), \
					SPAN_NOTICE("You unscrew [src]'s maintenance hatch."))

			else if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts screwing [src]'s maintenance hatch closed."), \
				SPAN_NOTICE("You start screwing [src]'s maintenance hatch closed."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_SCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					damaged = 0
					repair_state = FLOODLIGHT_REPAIR_UNSCREW
					health = initial(health)
					user.visible_message(SPAN_NOTICE("[user] screws [src]'s maintenance hatch closed."), \
					SPAN_NOTICE("You screw [src]'s maintenance hatch closed."))
					if(is_lit)
						SetLuminosity(lum_value)
					update_icon()
			return TRUE

		else if(iscrowbar(I))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_CROWBAR)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts prying [src]'s maintenance hatch open."),\
				SPAN_NOTICE("You start prying [src]'s maintenance hatch open."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CROWBAR)
						return
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_WELD
					user.visible_message(SPAN_NOTICE("[user] pries [src]'s maintenance hatch open."),\
					SPAN_NOTICE("You pry [src]'s maintenance hatch open."))
			return TRUE

		else if(iswelder(I))
			var/obj/item/tool/weldingtool/WT = I

			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_WELD)
				if(WT.remove_fuel(1, user))
					playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
					user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s damage."),
					SPAN_NOTICE("You start welding [src]'s damage."))
					if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(QDELETED(src) || !WT.isOn() || repair_state != FLOODLIGHT_REPAIR_WELD)
							return
						playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_CABLE
						user.visible_message(SPAN_NOTICE("[user] welds [src]'s damage."),
						SPAN_NOTICE("You weld [src]'s damage."))
						return 1
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return TRUE

		else if(iscoil(I))
			var/obj/item/stack/cable_coil/C = I
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_CABLE)
				if(C.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two coils of wire to replace the damaged cables."))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts replacing [src]'s damaged cables."),\
				SPAN_NOTICE("You start replacing [src]'s damaged cables."))
				if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CABLE)
						return
					if(C.use(2))
						playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_SCREW
						user.visible_message(SPAN_NOTICE("[user] starts replaces [src]'s damaged cables."),\
						SPAN_NOTICE("You replace [src]'s damaged cables."))
			return TRUE


	..()
	return 0

/obj/structure/machinery/colony_floodlight/attack_hand(mob/user)
	if(ishuman(user))
		if(damaged)
			to_chat(user, SPAN_WARNING("[src] is damaged."))
		else if(!is_lit)
			to_chat(user, SPAN_WARNING("Nothing happens. Looks like it's powered elsewhere."))
		return 0
	..()

/obj/structure/machinery/colony_floodlight/examine(mob/user)
	..()
	if(ishuman(user))
		if(damaged)
			to_chat(user, SPAN_WARNING("It is damaged."))
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				switch(repair_state)
					if(FLOODLIGHT_REPAIR_UNSCREW) to_chat(user, SPAN_INFO("You must first unscrew its maintenance hatch."))
					if(FLOODLIGHT_REPAIR_CROWBAR) to_chat(user, SPAN_INFO("You must crowbar its maintenance hatch open."))
					if(FLOODLIGHT_REPAIR_WELD) to_chat(user, SPAN_INFO("You must weld the damage to it."))
					if(FLOODLIGHT_REPAIR_CABLE) to_chat(user, SPAN_INFO("You must replace its damaged cables."))
					if(FLOODLIGHT_REPAIR_SCREW) to_chat(user, SPAN_INFO("You must screw its maintenance hatch closed."))
		else if(!is_lit)
			to_chat(user, SPAN_INFO("It doesn't seem powered."))

#undef FLOODLIGHT_REPAIR_UNSCREW
#undef FLOODLIGHT_REPAIR_CROWBAR
#undef FLOODLIGHT_REPAIR_WELD
#undef FLOODLIGHT_REPAIR_CABLE
#undef FLOODLIGHT_REPAIR_SCREW
