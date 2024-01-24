/obj/structure/machinery/xenoanalyzer
	name = "Biomass Analyzer"
	desc = "todo"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "mixer0b" //for the time while no sprites
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	var/biomass_points = 0 //most important thing in this
	var/obj/item/organ/heart/xeno/organ = null

/obj/structure/machinery/xenoanalyzer/attackby(obj/item/W, mob/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(!istype(W, /obj/item/organ/heart/xeno))
		return
	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("You were interupted!"))
		return
	if(!user.drop_inv_item_to_loc(W, src))
		return
	to_chat(user, SPAN_NOTICE("You fed organ in the machine."))
	organ = W

/obj/structure/machinery/xenoanalyzer/ui_data(mob/user)
	var/list/data = list()

	data["points"] = biomass_points

	if(organ)
		data["organ"] = TRUE
	else
		data["organ"] = FALSE
	return data


/obj/structure/machinery/xenoanalyzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_organ")
			eject_biomass()
			. = TRUE

		if("process_organ")
			process_organ()
			. = TRUE

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass()
	if(isnull(organ))
		return
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ()
	if(isnull(organ))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
	biomass_points += organ.research_value * 1000 //inflating values less goo
	qdel(organ)
	organ = null











