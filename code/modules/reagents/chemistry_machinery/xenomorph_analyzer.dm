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
	var/obj/item/organ/xeno/organ = null
	var/busy = FALSE
	var/caste_of_organ = null
	var/list/different_upgrades = list()// used for items that are not research_upgrades. eg ammo

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
	if(!istype(W, /obj/item/organ/xeno))
		return
	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("You were interupted!"))
		return
	if(!user.drop_inv_item_to_loc(W, src))
		return
	to_chat(user, SPAN_NOTICE("You fed organ in the machine."))
	organ = W
	caste_of_organ = organ.caste_origin

/obj/structure/machinery/xenoanalyzer/ui_data(mob/user)
	var/list/data = list()
	data["points"] = biomass_points

	if(organ)
		data["organ"] = TRUE
		data["caste"] = caste_of_organ
		data["value"] = organ.research_value
	else
		data["organ"] = FALSE
	return data

/obj/structure/machinery/xenoanalyzer/ui_static_data(mob/user)
	to_world("Oof")
	var/list/static_data = list()
	static_data["upgrades"] = list()
	for(var/upgrade_type in subtypesof(/obj/item/research_upgrades))
		to_world("Ayo")
		var/obj/item/research_upgrades/upgrade = new upgrade_type //cant call procs without creating it. doing so crashes the game.
		var/upgrade_variations = upgrade.value
		for(var/iteration in 1 to upgrade_variations)
			if(upgrade.value)
				to_world(upgrade)
				var/upgrade_price = upgrade.price[iteration]
				var/upgrade_name = (capitalize_first_letters(upgrade.name) + capitalize_first_letters(upgrade.get_upgrade_desc(iteration, TRUE) ))
				var/upgrade_desc = (initial(upgrade.desc) + upgrade.get_upgrade_desc(iteration, FALSE))
				to_world(upgrade_name)
				static_data["upgrades"] += list(list(
						"name" = upgrade_name,
						"desc" = upgrade_desc,
						"vari" = iteration,
						"cost" = upgrade_price,
						"path" = upgrade_type
				))
	for(var/item in different_upgrades)

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
		if("produce")
			var/produce = text2path(params["paths"])
			var/cost = text2num(params["cost"])
			var/vari = text2num(params["varia"])
			if(cost)
				start_print_upgrade(produce, cost, usr, vari)

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass()
	if(isnull(organ))
		return
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ()
	if(isnull(organ))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
	biomass_points += organ.research_value * 1000 //inflatizng values less goo
	QDEL_NULL(organ)

/obj/structure/machinery/xenoanalyzer/proc/start_print_upgrade(produce_path, cost, mob/user, variation)
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"
	if(cost > biomass_points)
		to_chat(user, SPAN_WARNING("[src] makes a worrying beep and flashes red, theres not enough data processed to build the requested upgrade!"))
		return
	else
		icon_state = "mixer1b"
		busy = TRUE
		biomass_points -= cost
		addtimer(CALLBACK(src, PROC_REF(print_upgrade), produce_path, variation), 5 SECONDS)


/obj/structure/machinery/xenoanalyzer/proc/print_upgrade(produce_path, variation)
	busy = FALSE
	icon_state = "mixer0b"
	var/obj/item/research_upgrades/upgrade = new produce_path(get_turf(src))
	upgrade.value = variation










