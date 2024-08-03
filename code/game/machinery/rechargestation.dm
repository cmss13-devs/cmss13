/obj/structure/machinery/recharge_station
	name = "synthetic maintenance station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	desc = "A Synthetic Maintenance Station designed to recharge, repair and maintain various sizes of artificial people. Simply place the synthetic or android in need of repair in here and they will be fixed up in no time!"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	active_power_usage = 50
	can_buckle = TRUE
	/// the borg inside
	var/mob/living/occupant = null
	/// Two charged borgs in a row with default cell
	var/max_internal_charge = 15000
	/// Starts charged, to prevent power surges on round start
	var/current_internal_charge = 15000
	/// Active Cap - When cyborg is inside
	var/charging_cap_active = 25000
	/// Passive Cap - Recharging internal capacitor when no cyborg is inside
	var/charging_cap_passive = 2500
	/// Used to update icon only once every 10 ticks
	var/icon_update_tick = 0
	/// implants to not remove
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
	///stun time upon exiting, if at all
	var/exit_stun = 2


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
		charge_diff = clamp(charge_diff, 0, charging_cap_active) // Trim the values to limits
	else // We should have load for this tick in Watts
		charge_diff = clamp(charge_diff, 0, charging_cap_passive)

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
	. += "The charge meter reads: [floor(chargepercentage())]%"

/obj/structure/machinery/recharge_station/proc/chargepercentage()
	return ((current_internal_charge / max_internal_charge) * 100)

/obj/structure/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/structure/machinery/recharge_station/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	if(occupant)
		occupant.emp_act(severity)
		go_out()

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
	switch(floor(chargepercentage()))
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
		if (issynth(occupant))
			var/mob/living/carbon/human/humanoid_occupant = occupant //for special synth surgeries
			if(occupant.getBruteLoss() > 0 || occupant.getFireLoss() > 0 || occupant.getBrainLoss() > 0)
				occupant.heal_overall_damage(10, 10, TRUE)
				occupant.apply_damage(-10, BRAIN)
				current_internal_charge = max(current_internal_charge - 500, 0)
				to_chat(occupant, "Structural damage detected. Repairing...")
				doing_stuff = TRUE
				occupant.pain.recalculate_pain()
			if(!doing_stuff && occupant.blood_volume < initial(occupant.blood_volume))
				occupant.blood_volume = min(occupant.blood_volume + 10, initial(occupant.blood_volume))
				to_chat(occupant, "Fluid volume low. Refreshing liquids...")
				doing_stuff = TRUE
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if(length(current_limb.implants))
						doing_stuff = TRUE
						to_chat(occupant, "Foreign material detected. Beginning removal process...")
						for(var/obj/item/current_implant in current_limb.implants)
							if(!is_type_in_list(current_implant,known_implants))
								sleep(REMOVE_OBJECT_MAX_DURATION)
								current_limb.implants -= current_implant
								humanoid_occupant.embedded_items -= current_implant
								qdel(current_implant)
								to_chat(occupant, "Foreign object removed.")
				for(var/datum/internal_organ/current_organ in humanoid_occupant.internal_organs)
					if(current_organ.robotic == ORGAN_ASSISTED||current_organ.robotic == ORGAN_ROBOT) //this time the machine can *only* fix robotic organs
						if(current_organ.damage > 0)
							to_chat(occupant, "Damaged internal component detected. Beginning repair process.")
							doing_stuff = TRUE
							sleep(FIX_ORGAN_MAX_DURATION)
							current_organ.rejuvenate()
							to_chat(occupant, "Internal component repaired.")

		if(!doing_stuff)
			to_chat(occupant, "Maintenance cycle completed. All systems nominal.")
			go_out()


/obj/structure/machinery/recharge_station/proc/go_out()
	if(!occupant)
		return
	var/mob/living/synth = occupant

	if(synth.client)
		synth.client.eye = synth.client.mob
		synth.client.perspective = MOB_PERSPECTIVE

	synth.forceMove(loc)
	if(exit_stun)
		synth.Stun(exit_stun) //Action delay when going out of a closet
	if(synth.mobility_flags & MOBILITY_MOVE)
		synth.visible_message(SPAN_WARNING("[synth] suddenly gets out of [src]!"), SPAN_WARNING("You get out of [src] and get your bearings!"))

	occupant = null
	update_icon()
	update_use_power(USE_POWER_IDLE)

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
	if (!issynth(M))
		return FALSE
	if (occupant)
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
	if (!issynth(usr))
		to_chat(usr, SPAN_NOTICE(" <B>Only non-organics may enter the recharge and repair station!</B>"))
		return
	if (src.occupant)
		to_chat(usr, SPAN_NOTICE(" <B>The cell is already occupied!</B>"))
		return
	move_mob_inside(usr)
	return

/obj/structure/machinery/recharge_station/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = W
		if(!ismob(G.grabbed_thing))
			return
		if(!issynth(G.grabbed_thing))
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
