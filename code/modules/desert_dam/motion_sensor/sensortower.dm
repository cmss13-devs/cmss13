//sensor tower for deser dam. It is there to add the xeno's to the tactical map for marines.


/obj/structure/machinery/sensortower
	name = "\improper experimental sensor tower"
	icon = 'icons/obj/structures/machinery/motion_sensor_v2.dmi'
	icon_state = "sensor_broken"
	desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a blowtorch, wirecutters, then a wrench to repair it."
	anchored = 1
	density = 1
	unslashable = TRUE
	unacidable = TRUE	  //NOPE.jpg
	use_power = 1
	idle_power_usage = 1000
	var/buildstate = 1 //What state of building it are we on, 0-3, 1 is "broken", the default
	var/is_on = 0  //Is this damn thing on or what?
	var/fail_rate = 15 //% chance of failure each fail_tick check
	var/fail_check_ticks = 50 //Check for failure every this many ticks
	//The sensor tower fails more often since it is experimental.
	var/cur_tick = 0 //Tick updater


/obj/structure/machinery/sensortower/update_icon()
	..()
	if(!buildstate && is_on)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. It looks like it is online."
		icon_state = "sensor_"
	else if (!buildstate && !is_on)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. It looks like it is offline."
		icon_state = "sensor_off"
	else if(buildstate == 1)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a blowtorch, wirecutters, then a wrench to repair it."
		icon_state = "sensor_broken"
	else if(buildstate == 2)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use wirecutters, then a wrench to repair it."
		icon_state = "sensor_broken"
	else if(buildstate == 3)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a wrench to repair it."
		icon_state = "sensor_broken"

/obj/structure/machinery/sensortower/process()
	if(!is_on || buildstate || !anchored) //Default logic checking
		return 0
	if(inoperable())
		return 0
	checkfailure()

/obj/structure/machinery/sensortower/proc/checkfailure()
	cur_tick++
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		return 0
	else if(cur_tick > fail_check_ticks) //Went past with no fail, reset the timer
		cur_tick = 0
		return 0
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(rand(0,3) == 0)
			visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and a fuse blows! Use wirecutters, then a wrench to repair it.")]")
			buildstate = 2
		else
			visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("<b>[src]</b> beeps wildly and sprays random pieces everywhere! Use a wrench to repair it.")]")
			buildstate = 3
		is_on = 0
		update_icon()
		cur_tick = 0
		stop_processing()
		return 1
	return 0

/obj/structure/machinery/sensortower/attack_hand(mob/user as mob)
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
		visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> goes dark as [usr] shuts the power off.")]")
		is_on = 0
		cur_tick = 0
		update_icon()
		stop_processing()
		return 1
	visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("<b>[src]</b> lights up as [usr] turns the power on.")]")
	is_on = 1
	cur_tick = 0
	update_icon()
	start_processing()
	return 1

/obj/structure/machinery/sensortower/attackby(var/obj/item/O as obj, var/mob/user as mob)
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
				user.visible_message(SPAN_NOTICE("[user] repairs [src]'s tubing and plating."),
				SPAN_NOTICE("You repair [src]'s tubing and plating."))
				update_icon()
				return TRUE
	else
		return ..() //Deal with everything else, like hitting with stuff


/obj/structure/machinery/sensortower/stop_processing()
	ticker.toweractive = FALSE
	..()

/obj/structure/machinery/sensortower/start_processing()
	ticker.toweractive = TRUE
	..()

/obj/structure/machinery/sensortower/power_change()
	..()
	update_icon()