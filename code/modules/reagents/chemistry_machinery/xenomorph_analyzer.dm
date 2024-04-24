/obj/structure/machinery/xenoanalyzer
	name = "Biomass Analyzer"
	desc = "Analyzer of biological material which processes valuable matter into even more valueble data."
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

/obj/structure/machinery/xenoanalyzer/attack_hand(mob/user as mob)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
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
	to_chat(user, SPAN_NOTICE("You place the organ in the machine"))
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
	var/list/static_data = list()
	static_data["upgrades"] = list()
	static_data["categories"] = list()
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior == UPGRADE_CATEGORY)
			static_data["categories"] += upgrade.name
			continue
		if(upgrade.behavior == UPGRADE_EXCLUDE_BUY)
			continue
		static_data["upgrades"] += list(list(
			"name" = capitalize_first_letters(upgrade.name),
			"desc" = capitalize_first_letters(upgrade.desc),
			"vari" = upgrade.behavior,
			"cost" = upgrade.value_upgrade,
			"ref" = initial(upgrade.item_reference),
			"category" = initial(upgrade.upgrade_type)
		))
		to_world(initial(upgrade.upgrade_type))
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
			var/cost = text2num(params["cost"])
			var/vari = text2num(params["varia"])
			if(cost && !busy)
				start_print_upgrade(params["ref"], cost, usr, vari)

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass()
	if(isnull(organ))
		return
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ()
	if(isnull(organ))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
	biomass_points += organ.research_value
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
	if(isnull(produce_path))
		to_world("uhohhh")
	to_world(produce_path)
	icon_state = "mixer0b"
	var/obj/item/research_upgrades/upgrade = new produce_path(get_turf(src))
	upgrade.value = variation










