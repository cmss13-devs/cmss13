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
	var/list/unlocked_tech = list()

/obj/structure/machinery/xenoanalyzer/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/structure/machinery/xenoanalyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenomorphExtractor", name)
		ui.open()

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

/obj/structure/machinery/xenoanalyzer/ui_static_data(mob/user)
	to_world("Oof")
	var/list/static_data = list()
	static_data["upgrades"] = list()
	for(var/upgrade_type in typesof(/obj/item/research_upgrades))
		var/obj/item/research_upgrades/upgrade = upgrade_type
		var/upgrade_name = initial(upgrade.name)
		var/upgrade_variations = initial(upgrade.value)
		var/upgrade_price = initial(upgrade.price)
		for(var/iteration in 1 to upgrade_variations)
			to_world("loor")
			to_world(upgrade_name)
			to_world(iteration)
			if(upgrade.value)
				static_data["upgrades"] += list(list(
						"name" = (capitalize_first_letters(upgrade_name) + " ([iteration])"),
						"desc" = (upgrade.desc + upgrade.get_upgrade_desc(iteration)),
						"vari" = iteration,
						"cost" = upgrade_price
				))
	return static_data

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











