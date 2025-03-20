//sensor tower for deser dam. It is there to add the xeno's to the tactical map for marines.

#define SENSORTOWER_BUILDSTATE_WORKING 0
#define SENSORTOWER_BUILDSTATE_BLOWTORCH 1
#define SENSORTOWER_BUILDSTATE_WIRECUTTERS 2
#define SENSORTOWER_BUILDSTATE_WRENCH 3

/obj/structure/machinery/sensortower
	name = "\improper experimental sensor tower"
	icon = 'icons/obj/structures/machinery/motion_sensor_v2.dmi'
	icon_state = "sensor_broken"
	desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a blowtorch, wirecutters, then a wrench to repair it."
	anchored = TRUE
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE   //NOPE.jpg
	needs_power = FALSE
	idle_power_usage = 1000
	is_on = FALSE  //Is this damn thing on or what?
	var/buildstate = SENSORTOWER_BUILDSTATE_BLOWTORCH //What state of building it are we on, 0-3, 1 is "broken", the default
	var/fail_rate = 15 //% chance of failure each fail_tick check
	var/fail_check_ticks = 50 //Check for failure every this many ticks
	//The sensor tower fails more often since it is experimental.
	var/cur_tick = 0 //Tick updater

	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()

/obj/structure/machinery/sensortower/Initialize(mapload, ...)
	. = ..()
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "sensor_tower")


/obj/structure/machinery/sensortower/update_icon()
	..()
	if(!buildstate && is_on)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. It looks like it is online."
		icon_state = "sensor_"
	else if (!buildstate && !is_on)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. It looks like it is offline."
		icon_state = "sensor_off"
	else if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a blowtorch, wirecutters, then a wrench to repair it."
		icon_state = "sensor_broken"
	else if(buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use wirecutters, then a wrench to repair it."
		icon_state = "sensor_broken"
	else if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		desc = "A tower with a lot of delicate sensors made to track weather conditions. This one has been adjusted to track biosignatures. This one is heavily damaged. Use a wrench to repair it."
		icon_state = "sensor_broken"

/obj/structure/machinery/sensortower/process()
	if(!is_on || buildstate || !anchored) //Default logic checking
		remove_xenos_from_minimap()
		return FALSE
	if(inoperable())
		remove_xenos_from_minimap()
		return FALSE
	checkfailure()
	add_xenos_to_minimap()

/obj/structure/machinery/sensortower/proc/remove_xenos_from_minimap()
	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker()
			minimap_added -= WEAKREF(current_xeno)

/obj/structure/machinery/sensortower/proc/add_xenos_to_minimap()
	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			continue

		SSminimaps.remove_marker(current_xeno)
		current_xeno.add_minimap_marker(MINIMAP_FLAG_USCM|get_minimap_flag_for_faction(current_xeno.hivenumber))
		minimap_added += WEAKREF(current_xeno)

/obj/structure/machinery/sensortower/proc/checkfailure()
	cur_tick++
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		return FALSE
	else if(cur_tick > fail_check_ticks) //Went past with no fail, reset the timer
		cur_tick = 0
		return FALSE
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(prob(25))
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>\The [src]</b> beeps wildly and a fuse blows! Use wirecutters, then a wrench to repair it.")]")
			buildstate = SENSORTOWER_BUILDSTATE_WIRECUTTERS
		else
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>\The [src]</b> beeps wildly and sprays random pieces everywhere! Use a wrench to repair it.")]")
			buildstate = SENSORTOWER_BUILDSTATE_WRENCH
		is_on = FALSE
		update_icon()
		cur_tick = 0
		stop_processing()
		return TRUE
	return FALSE

/obj/structure/machinery/sensortower/attack_hand(mob/user as mob)
	if(!anchored)
		return FALSE //Shouldn't actually be possible
	if(user.is_mob_incapacitated())
		return FALSE
	if(!ishuman(user))
		to_chat(user, SPAN_DANGER("You have no idea how to use that.")) //No xenos or mankeys
		return FALSE

	add_fingerprint(user)

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You have no clue how this thing works..."))
		return FALSE

	if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		to_chat(usr, SPAN_INFO("Use a blowtorch, then wirecutters, then wrench to repair it."))
		return FALSE
	else if (buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS)
		to_chat(usr, SPAN_INFO("Use some wirecutters, then wrench to repair it."))
		return FALSE
	else if (buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		to_chat(usr, SPAN_INFO("Use a wrench to repair it."))
		return FALSE
	if(is_on)
		visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("<b>\The [src]</b> goes dark as [usr] shuts the power off.")]")
		is_on = FALSE
		cur_tick = 0
		update_icon()
		STOP_PROCESSING(SSslowobj, src)
		remove_xenos_from_minimap()
		return TRUE
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("<b>\The [src]</b> lights up as [usr] turns the power on.")]")
	is_on = TRUE
	cur_tick = 0
	update_icon()
	START_PROCESSING(SSslowobj, src)
	return TRUE

/obj/structure/machinery/sensortower/attackby(obj/item/O as obj, mob/user as mob)
	if(iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return FALSE
			var/obj/item/tool/weldingtool/WT = O
			if(WT.remove_fuel(1, user))

				playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
				user.visible_message(SPAN_NOTICE("[user] starts welding \the [src]'s internal damage."),
				SPAN_NOTICE("You start welding \the [src]'s internal damage."))
				if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(buildstate != SENSORTOWER_BUILDSTATE_BLOWTORCH || is_on || !WT.isOn())
						return FALSE
					playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
					buildstate = SENSORTOWER_BUILDSTATE_WIRECUTTERS
					user.visible_message(SPAN_NOTICE("[user] welds \the [src]'s internal damage."),
					SPAN_NOTICE("You weld \the [src]'s internal damage."))
					update_icon()
					return TRUE
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
				return

	else if(HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		if(buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return FALSE
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts securing \the [src]'s wiring."),
			SPAN_NOTICE("You start securing \the [src]'s wiring."))
			if(do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 12))
				if(buildstate != SENSORTOWER_BUILDSTATE_WIRECUTTERS || is_on)
					return FALSE
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				buildstate = SENSORTOWER_BUILDSTATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] secures \the [src]'s wiring."),
				SPAN_NOTICE("You secure \the [src]'s wiring."))
				update_icon()
				return TRUE
	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair this thing."))
				return FALSE
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts repairing \the [src]'s tubing and plating."),
			SPAN_NOTICE("You start repairing \the [src]'s tubing and plating."))
			if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(buildstate != SENSORTOWER_BUILDSTATE_WRENCH || is_on)
					return FALSE
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				buildstate = SENSORTOWER_BUILDSTATE_WORKING
				user.visible_message(SPAN_NOTICE("[user] repairs \the [src]'s tubing and plating."),
				SPAN_NOTICE("You repair \the [src]'s tubing and plating."))
				update_icon()
				return TRUE
	else
		return ..() //Deal with everything else, like hitting with stuff

/obj/structure/machinery/sensortower/attack_alien(mob/living/carbon/xenomorph/M)
	if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		to_chat(M, SPAN_WARNING("You stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	if(M.action_busy)
		return XENO_NO_DELAY_ACTION

	var/turf/cur_loc = M.loc

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)
	M.visible_message(SPAN_DANGER("[M] starts wrenching apart \the [src]'s panels and reaching inside it!"),
	SPAN_DANGER("You start wrenching apart \the [src]'s panels and reaching inside it!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(M)
	if(do_after(M, 40, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(M.is_mob_incapacitated())
			return XENO_NO_DELAY_ACTION
		if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
			return XENO_NO_DELAY_ACTION
		buildstate = SENSORTOWER_BUILDSTATE_BLOWTORCH
		if(is_on)
			is_on = FALSE
			cur_tick = 0
			stop_processing()
		update_icon()
		M.visible_message(SPAN_DANGER("[M] pulls apart \the [src]'s panels and breaks all its internal wiring and tubing!"),
		SPAN_DANGER("You pull apart \the [src]'s panels and break all its internal wiring and tubing!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
	else
		M.visible_message(SPAN_DANGER("[M] stops destroying \the [src]'s internal machinery!"),
		SPAN_DANGER("You stop destroying \the [src]'s internal machinery!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/* Decreases the buildstate of the sensor tower and switches it off if affected by any explosion.
Higher severity explosion will damage the sensor tower more
*/
/obj/structure/machinery/sensortower/ex_act(severity)
	if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			buildstate += 1
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			buildstate = clamp(buildstate + 2, SENSORTOWER_BUILDSTATE_WORKING, SENSORTOWER_BUILDSTATE_WRENCH)
		if(EXPLOSION_THRESHOLD_HIGH to INFINITY)
			buildstate = 3
	if(is_on)
		is_on = FALSE
		cur_tick = 0
		stop_processing()
	update_icon()

#undef SENSORTOWER_BUILDSTATE_WORKING
#undef SENSORTOWER_BUILDSTATE_BLOWTORCH
#undef SENSORTOWER_BUILDSTATE_WIRECUTTERS
#undef SENSORTOWER_BUILDSTATE_WRENCH
