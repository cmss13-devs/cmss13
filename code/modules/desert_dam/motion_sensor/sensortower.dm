//sensor tower for deser dam. It is there to add the xeno's to the tactical map for marines.


/obj/machinery/sensortower
	name = "\improper experimental sensor tower"
	icon = 'icons/obj/machines/motion_sensor_v2.dmi'
	icon_state = "sensor_broken"
	desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a blowtorch, wirecutters, then a wrench to repair it."
	anchored = 1
	density = 1
	unacidable = 1	  //NOPE.jpg
	use_power = 1
	idle_power_usage = 1000
	var/buildstate = 1 //What state of building it are we on, 0-3, 1 is "broken", the default
	var/is_on = 0  //Is this damn thing on or what?
	var/fail_rate = 15 //% chance of failure each fail_tick check
	var/fail_check_ticks = 50 //Check for failure every this many ticks
	//The sensor tower fails more often since it is experimental.
	var/cur_tick = 0 //Tick updater


/obj/machinery/sensortower/update_icon()
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

/obj/machinery/sensortower/process()
	if(!is_on || buildstate || !anchored) //Default logic checking
		return 0
	if(stat & (BROKEN|NOPOWER))
		return 0
	checkfailure()

/obj/machinery/sensortower/proc/checkfailure()
	cur_tick++
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		return 0
	else if(cur_tick > fail_check_ticks) //Went past with no fail, reset the timer
		cur_tick = 0
		return 0
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(rand(0,3) == 0)
			visible_message("\icon[src] <span class='notice'><b>[src]</b> beeps wildly and a fuse blows! Use wirecutters, then a wrench to repair it.")
			buildstate = 2
		else
			visible_message("\icon[src] <span class='notice'><b>[src]</b> beeps wildly and sprays random pieces everywhere! Use a wrench to repair it.")
			buildstate = 3
		is_on = 0
		update_icon()
		cur_tick = 0
		stop_processing()
		return 1
	return 0

/obj/machinery/sensortower/attack_hand(mob/user as mob)
	if(!anchored) return 0 //Shouldn't actually be possible
	if(user.is_mob_incapacitated()) return 0
	if(!ishuman(user))
		user << "\red You have no idea how to use that." //No xenos or mankeys
		return 0

	add_fingerprint(user)

	if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_ENGI)
		user << "<span class='warning'>You have no clue how this thing works...</span>"
		return 0

	if(buildstate == 1)
		usr << "<span class='info'>Use a blowtorch, then wirecutters, then wrench to repair it."
		return 0
	else if (buildstate == 2)
		usr << "<span class='info'>Use a wirecutters, then wrench to repair it."
		return 0
	else if (buildstate == 3)
		usr << "<span class='info'>Use a wrench to repair it."
		return 0
	if(is_on)
		visible_message("\icon[src] <span class='warning'><b>[src]</b> goes dark as [usr] shuts the power off.")
		is_on = 0
		cur_tick = 0
		update_icon()
		stop_processing()
		return 1
	visible_message("\icon[src] <span class='warning'><b>[src]</b> lights up as [usr] turns the power on.")
	is_on = 1
	cur_tick = 0
	update_icon()
	start_processing()
	return 1

/obj/machinery/sensortower/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(iswelder(O))
		if(buildstate == 1 && !is_on)
			if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_ENGI)
				user << "<span class='warning'>You have no clue how to repair this thing.</span>"
				return 0
			var/obj/item/tool/weldingtool/WT = O
			if(WT.remove_fuel(1, user))

				playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
				user.visible_message("<span class='notice'>[user] starts welding [src]'s internal damage.</span>",
				"<span class='notice'>You start welding [src]'s internal damage.</span>")
				if(do_after(user, 200, TRUE, 5, BUSY_ICON_BUILD))
					if(buildstate != 1 || is_on || !WT.isOn()) r_FAL
					playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
					buildstate = 2
					user.visible_message("<span class='notice'>[user] welds [src]'s internal damage.</span>",
					"<span class='notice'>You weld [src]'s internal damage.</span>")
					update_icon()
					r_TRU
			else
				user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
				return
	else if(iswirecutter(O))
		if(buildstate == 2 && !is_on)
			if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_ENGI)
				user << "<span class='warning'>You have no clue how to repair this thing.</span>"
				return 0
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message("<span class='notice'>[user] starts securing [src]'s wiring.</span>",
			"<span class='notice'>You start securing [src]'s wiring.</span>")
			if(do_after(user, 120, TRUE, 12, BUSY_ICON_BUILD))
				if(buildstate != 2 || is_on) r_FAL
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				buildstate = 3
				user.visible_message("<span class='notice'>[user] secures [src]'s wiring.</span>",
				"<span class='notice'>You secure [src]'s wiring.</span>")
				update_icon()
				r_TRU
	else if(iswrench(O))
		if(buildstate == 3 && !is_on)
			if(user.mind && user.mind.cm_skills && user.mind.cm_skills.engineer < SKILL_ENGINEER_ENGI)
				user << "<span class='warning'>You have no clue how to repair this thing.</span>"
				return 0
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("<span class='notice'>[user] starts repairing [src]'s tubing and plating.</span>",
			"<span class='notice'>You start repairing [src]'s tubing and plating.</span>")
			if(do_after(user, 150, TRUE, 15, BUSY_ICON_BUILD))
				if(buildstate != 3 || is_on) r_FAL
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				buildstate = 0
				user.visible_message("<span class='notice'>[user] repairs [src]'s tubing and plating.</span>",
				"<span class='notice'>You repair [src]'s tubing and plating.</span>")
				update_icon()
				r_TRU
	else
		return ..() //Deal with everything else, like hitting with stuff


/obj/machinery/sensortower/stop_processing()
	ticker.toweractive = 0
	..()

/obj/machinery/sensortower/start_processing()
	ticker.toweractive = 1
	..()

/obj/machinery/sensortower/power_change()
	..()
	update_icon()