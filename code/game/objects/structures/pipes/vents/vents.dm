/obj/structure/pipes/vents
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_vent"
	desc = "Has a valve and pump attached to it"
	valid_directions = list(NORTH, SOUTH, EAST, WEST)

	var/area/initial_loc = null
	var/id_tag = null
	var/welded = FALSE
	var/area_uid = null
	var/global/gl_uid = 1
	var/uid

	var/vent_icon = "vent"
	var/datum/effect_system/smoke_spread/gas_holder

/obj/structure/pipes/vents/Initialize()
	. = ..()

	initial_loc = get_area(loc)
	area_uid = initial_loc.uid
	if(!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/structure/pipes/vents/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/structure/pipes/vents/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) <= 1)
		. += SPAN_INFO("A small gauge in the corner reads 0.1 L/s; 0W.")
	else
		. += SPAN_INFO("You are too far away to read the gauge.")
	if(welded)
		. += SPAN_INFO("It seems welded shut.")

/obj/structure/pipes/vents/update_icon(safety = 0)
	if(!check_icon_cache())
		return
	overlays.Cut()

	vent_icon = initial(vent_icon)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(T.intact_tile)
		vent_icon += "h"

	if(welded)
		vent_icon += "welded"
	else if(length(connected_to))
		vent_icon += "on"
	else
		vent_icon += "off"

	overlays += icon_manager.get_atmos_icon("device", null, null, vent_icon)

/obj/structure/pipes/vents/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T) || T.intact_tile)
			return

		add_underlay(T, dir)

/obj/structure/pipes/vents/hide()
	update_underlays()

/obj/structure/pipes/vents/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/weldtime = 50
		if(HAS_TRAIT(W, TRAIT_TOOL_SIMPLE_BLOWTORCH))
			weldtime = 60
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message(SPAN_NOTICE("[user] starts welding \the [src] with \the [WT]."),
			SPAN_NOTICE("You start welding \the [src] with \the [WT]."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, weldtime * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src || !WT.isOn())
					return 0
				playsound(get_turf(src), 'sound/items/Welder2.ogg', 25, 1)
				if(!welded)
					user.visible_message(SPAN_NOTICE("[user] welds \the [src] shut."),
					SPAN_NOTICE("You weld \the [src] shut."))
					welded = 1
					update_icon()
					msg_admin_niche("[key_name(user)] welded a vent pump.")
					return 1
				else
					user.visible_message(SPAN_NOTICE("[user] welds \the [src] open."),
					SPAN_NOTICE("You weld \the [src] open."))
					welded = 0
					msg_admin_niche("[key_name(user)] un-welded a vent pump.")
					update_icon()
					return 1
			else
				to_chat(user, SPAN_WARNING("\The [W] needs to be on to start this task."))
				return 0
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return 1

	if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		return ..()
	var/turf/T = src.loc
	if(isturf(T) && T.intact_tile)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."),
	SPAN_NOTICE("You begin unfastening [src]."))
	if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe(loc, null, null, src)
		qdel(src)

/obj/structure/pipes/vents/Destroy()
	qdel(gas_holder)
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	. = ..()

/obj/structure/pipes/vents/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_GAS, "Release Gas")

/obj/structure/pipes/vents/vv_do_topic(list/href_list)
	. = ..()
	var/mob/user = usr
	if(href_list[VV_HK_GAS] && check_rights(R_EVENT))
		if(welded)
			to_chat(usr, SPAN_WARNING("You cannot release gas from a welded vent."))
			return FALSE
		var/list/options = list(VENT_GAS_SMOKE, VENT_GAS_CN20, VENT_GAS_CN20_XENO)
		var/gas_choice = tgui_input_list(user, "What gas do you wish to use?", "Gas Choice", options, 20 SECONDS)
		if(!gas_choice)
			return FALSE
		var/radius_choice = tgui_input_number(user, "What radius do you wish to use?", "Gas Radius", 4, 10, 1, 20 SECONDS)
		var/warn_choice = tgui_input_number(user, "How many seconds warning do you wish to give?", "Release Warning", 5, 30, 1, 20 SECONDS)
		warn_choice = warn_choice SECONDS

		var/confirm = alert(user, "Confirm gas setup. \n\nGas: '[gas_choice]'\nRadius: '[radius_choice]'\nWarn Time: '[warn_choice / 10] seconds' \n\n Is this correct?", "Confirmation", "Yes", "No")
		if(confirm != "Yes")
			return FALSE
		log_admin("[key_name(user)] released gas (Gas: [gas_choice], Radius: [radius_choice], Delay: [warn_choice]) from [name] at X[x], Y[y], Z[z].")
		create_gas(gas_choice, radius_choice, warn_choice)
		return TRUE

/obj/structure/pipes/vents/proc/create_gas(gas_type = VENT_GAS_SMOKE, radius = 4, warning_time = 5 SECONDS)
	if(welded)
		to_chat(usr, SPAN_WARNING("You cannot release gas from a welded vent."))
		return FALSE
	var/datum/effect_system/smoke_spread/spreader
	switch(gas_type)
		if(VENT_GAS_SMOKE)
			spreader = new /datum/effect_system/smoke_spread/bad
		if(VENT_GAS_CN20)
			spreader = new /datum/effect_system/smoke_spread/cn20
		if(VENT_GAS_CN20_XENO)
			spreader = new /datum/effect_system/smoke_spread/cn20/xeno
	if(!spreader)
		return FALSE
	gas_holder = spreader
	spreader.attach(src)

	new /obj/effect/warning/explosive/gas(loc, warning_time)
	visible_message(SPAN_HIGHDANGER("[src] begins to hiss as gas builds up within it."), SPAN_HIGHDANGER("You hear a hissing."), radius)
	addtimer(CALLBACK(src, PROC_REF(release_gas), radius), warning_time)

/obj/structure/pipes/vents/proc/release_gas(radius = 4)
	radius = clamp(radius, 1, 10)
	if(!gas_holder || welded)
		return FALSE
	playsound(loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	gas_holder.set_up(radius, 0, get_turf(src), null, 10)
	gas_holder.start()
