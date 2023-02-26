/obj/structure/machinery/recharge_station
	name = "robot recharge station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	desc = "A recharge and repair station for robots and synthetics. Simply put the synthetic in need of repair in here and they will be fixed up in no time!"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	active_power_usage = 50
	var/mob/living/occupant = null
	var/max_internal_charge = 15000 // Two charged borgs in a row with default cell
	var/current_internal_charge = 15000 // Starts charged, to prevent power surges on round start
	var/charging_cap_active = 25000 // Active Cap - When cyborg is inside
	var/charging_cap_passive = 2500 // Passive Cap - Recharging internal capacitor when no cyborg is inside
	var/icon_update_tick = 0 // Used to update icon only once every 10 ticks
	can_buckle = TRUE

/obj/structure/machinery/recharge_station/Initialize(mapload, ...)
	. = ..()
	update_icon()
	flags_atom |= USES_HEARING

/obj/structure/machinery/recharge_station/Destroy()
	if(occupant)
		to_chat(occupant, SPAN_NOTICE(" <B>Critical failure of [name]. Unit ejected.</B>"))
		go_out()
	return ..()

/obj/structure/machinery/recharge_station/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/recharge_station/process()
	if(max_internal_charge < current_internal_charge)
		current_internal_charge = max_internal_charge// Safety check if varedit adminbus or something screws up
	if(current_internal_charge < 0)
		current_internal_charge = 0// Safety check if varedit adminbus or something screws up

	if(stat & (BROKEN))
		return

	if(current_internal_charge <= 0)
		if(occupant)
			to_chat(occupant, SPAN_NOTICE(" <B>The [name] is currently out of power. Please come back later!</B>"))
			go_out()

	var/chargemode = 0
	if(src.occupant)
		process_occupant()
		chargemode = 1
	else if (current_internal_charge < max_internal_charge)
		chargemode = 1

	// Power Stuff
	if(stat & NOPOWER)
		current_internal_charge = max(0, (current_internal_charge - (50 * CELLRATE))) // Internal Circuitry, 50W load. No power - Runs from internal cell
		return // No external power = No charging

	// Calculating amount of power to draw
	var/charge_diff = max_internal_charge - current_internal_charge // OK we have charge differences
	charge_diff = charge_diff / CELLRATE // Deconvert from Charge to Joules
	if(chargemode) // Decide if use passive or active power
		charge_diff = between(0, charge_diff, charging_cap_active) // Trim the values to limits
	else // We should have load for this tick in Watts
		charge_diff = between(0, charge_diff, charging_cap_passive)

	charge_diff += 50 // 50W for circuitry

	if(idle_power_usage != charge_diff) // Force update, but only when our power usage changed this tick.
		idle_power_usage = charge_diff
		update_use_power(USE_POWER_IDLE)

	current_internal_charge = min((current_internal_charge + ((charge_diff - 50) * CELLRATE)), max_internal_charge)

	if(icon_update_tick >= 10)
		update_icon()
		icon_update_tick = 0
	else
		icon_update_tick++

	//only stop processing the recharge station once it's fully recharged and there is nobody inside
	if(current_internal_charge == max_internal_charge && !occupant)
		stop_processing()

	return 1

/obj/structure/machinery/recharge_station/stop_processing()
	update_icon()
	..()

/obj/structure/machinery/recharge_station/allow_drop()
	return 0

/obj/structure/machinery/recharge_station/get_examine_text(mob/user)
	. = ..()
	. += "The charge meter reads: [round(chargepercentage())]%"

/obj/structure/machinery/recharge_station/proc/chargepercentage()
	return ((current_internal_charge / max_internal_charge) * 100)

/obj/structure/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/structure/machinery/recharge_station/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	if(occupant)
		occupant.emp_act(severity)
		go_out()
	..(severity)

/obj/structure/machinery/recharge_station/update_icon()
	..()
	if(!inoperable())
		if(src.occupant)
			icon_state = "borgcharger1"
		else
			icon_state = "borgcharger0"
	else
		icon_state = "borgcharger0"
	overlays.Cut()
	switch(round(chargepercentage()))
		if(1 to 20)
			overlays += image('icons/obj/objects.dmi', "statn_c0")
		if(21 to 40)
			overlays += image('icons/obj/objects.dmi', "statn_c20")
		if(41 to 60)
			overlays += image('icons/obj/objects.dmi', "statn_c40")
		if(61 to 80)
			overlays += image('icons/obj/objects.dmi', "statn_c60")
		if(81 to 98)
			overlays += image('icons/obj/objects.dmi', "statn_c80")
		if(99 to 110)
			overlays += image('icons/obj/objects.dmi', "statn_c100")

/obj/structure/machinery/recharge_station/proc/process_occupant()
	if(src.occupant)
		var/doing_stuff = FALSE
		if (isrobot(occupant))
			var/mob/living/silicon/robot/R = occupant
			if(R.module)
				R.module.respawn_consumable(R)
			if(!R.cell)
				return
			if(!R.cell.fully_charged())
				var/diff = min(R.cell.maxcharge - R.cell.charge, 500) // 500 charge / tick is about 2% every 3 seconds
				diff = min(diff, current_internal_charge) // No over-discharging
				R.cell.give(diff)
				current_internal_charge = max(current_internal_charge - diff, 0)
				to_chat(occupant, "Recharging...")
				doing_stuff = TRUE
			else
				update_use_power(USE_POWER_IDLE)
		if (isrobot(occupant) || issynth(occupant))
			if(occupant.getBruteLoss() > 0 || occupant.getFireLoss() > 0 || occupant.getBrainLoss() > 0)
				occupant.heal_overall_damage(10, 10, TRUE)
				occupant.apply_damage(-10, BRAIN)
				current_internal_charge = max(current_internal_charge - 500, 0)
				to_chat(occupant, "Repairing...")
				doing_stuff = TRUE
				occupant.pain.recalculate_pain()
			if(!doing_stuff && occupant.blood_volume < initial(occupant.blood_volume))
				occupant.blood_volume = min(occupant.blood_volume + 10, initial(occupant.blood_volume))
				to_chat(occupant, "Refreshing liquids...")
				doing_stuff = TRUE

		if(!doing_stuff)
			to_chat(occupant, "Maintenance complete! Have a nice day!")
			go_out()


/obj/structure/machinery/recharge_station/proc/go_out()
	if(!( src.occupant ))
		return
	//for(var/obj/O in src)
	// O.forceMove(src.loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(loc)
	src.occupant = null
	update_icon()
	update_use_power(USE_POWER_IDLE)
	return

/obj/structure/machinery/recharge_station/verb/move_eject()
	set category = "Object"
	set name = "Eject"

	set src in oview(1)
	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/structure/machinery/recharge_station/do_buckle(mob/target, mob/user)
	return move_mob_inside(target)

/obj/structure/machinery/recharge_station/verb/move_mob_inside(mob/living/M)
	if (!isrobot(M) && !issynth(M))
		return FALSE
	if (occupant)
		return FALSE
	if (isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(QDELETED(R.cell))
			return FALSE
	M.stop_pulling()
	if(M && M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	src.occupant = M
	start_processing()
	src.add_fingerprint(usr)
	update_icon()
	update_use_power(USE_POWER_IDLE)
	return TRUE

/obj/structure/machinery/recharge_station/verb/move_inside()
	set category = "Object"
	set name = "Move Inside"

	set src in oview(1)
	if (usr.stat == 2)
		//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
		return
	if (!isrobot(usr) && !issynth(usr))
		to_chat(usr, SPAN_NOTICE(" <B>Only non-organics may enter the recharge and repair station!</B>"))
		return
	if (src.occupant)
		to_chat(usr, SPAN_NOTICE(" <B>The cell is already occupied!</B>"))
		return
	if (isrobot(usr))
		var/mob/living/silicon/robot/R = usr
		if(QDELETED(R.cell))
			to_chat(usr, SPAN_NOTICE("Without a powercell, you can't be recharged."))
			//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
			return
	move_mob_inside(usr)
	return

/obj/structure/machinery/recharge_station/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = W
		if(!ismob(G.grabbed_thing))
			return
		if(!issynth(G.grabbed_thing) && !isrobot(G.grabbed_thing))
			return

		if(occupant)
			to_chat(user, SPAN_NOTICE("The [name] is already occupied!"))
			return

		visible_message(SPAN_NOTICE("[user] starts putting [G.grabbed_thing] into the sleeper."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(occupant)
				to_chat(user, SPAN_NOTICE("The sleeper is already occupied!"))
				return
			if(!G || !G.grabbed_thing) return
			var/mob/M = G.grabbed_thing
			user.stop_pulling()
			move_mob_inside(M)
			add_fingerprint(user)

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/recharge_station/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH
