GLOBAL_VAR_INIT(river_activated, FALSE)

/obj/structure/machinery/filtration/console
	name = "console"
	desc = "A console."
	icon = 'icons/obj/structures/machinery/filtration.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_NONE
	//idle_power_usage = 1000
	var/id = null
	var/damaged = 0

/obj/structure/machinery/filtration/console/update_icon()
	..()
	if(damaged)
		icon_state = "[initial(icon_state)]-d"
	else if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]-off"
	else
		icon_state = initial(icon_state)
	return

/obj/structure/machinery/filtration/console/ex_act(severity)
	switch(severity)
		if(1.0)
			get_broken()
			return
		if(2.0)
			if (prob(40))
				get_broken()
				return
		if(3.0)
			if (prob(10))
				get_broken()
				return

/obj/structure/machinery/filtration/console/proc/get_broken()
	if(damaged)
		return //We're already broken
	damaged = !damaged
	visible_message(SPAN_WARNING("[src]'s screen cracks, and it bellows out smoke!"))
	playsound(src, 'sound/effects/metal_crash.ogg', 35)
	update_icon()
	return

/obj/structure/machinery/filtration/console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FiltrationControl", "[src.name]")
		ui.open()

/obj/structure/machinery/filtration/console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/filtration/console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/filtration/console/ui_data(mob/user)
	var/list/data = list()

	data["filt_on"] = GLOB.river_activated

	return data

/obj/structure/machinery/filtration/console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate_filt")
			GLOB.river_activated = TRUE

/obj/structure/machinery/filtration/console/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)
