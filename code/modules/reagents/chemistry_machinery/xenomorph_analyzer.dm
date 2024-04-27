/obj/structure/machinery/xenoanalyzer
	name = "Biomass Analyzer"
	desc = "Analyzer of biological material which processes valuable matter into even more valueble data."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "xeno_analyzer_off" //for the time while no sprites
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	var/biomass_points = 0 //most important thing in this
	var/obj/item/organ/xeno/organ = null
	var/busy = FALSE
	var/caste_of_organ = null
	bound_x = 32

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
	if(istype(W, /obj/item/organ/xeno))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interupted!"))
			return
		if(!user.drop_inv_item_to_loc(W, src))
			return
		to_chat(user, SPAN_NOTICE("You place the organ in the machine"))
		organ = W
		icon_state = "xeno_analyzer_organ_on"
		caste_of_organ = organ.caste_origin
	if(istype(W, /obj/item/clothing/accessory/health/research_plate))
		var/obj/item/clothing/accessory/health/research_plate/plate = W
		if(plate.recyclable_value == 0 && !plate.can_recycle(user))
			to_chat(user, SPAN_WARNING("You cannot recycle this type of plate"))
			return
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interupted!"))
			return
		to_chat(user, SPAN_NOTICE("You recycle the plate"))
		biomass_points += plate.recyclable_value
		qdel(W)

/obj/structure/machinery/xenoanalyzer/ui_data(mob/user)
	var/list/data = list()
	data["points"] = biomass_points
	data["current_clearance"] = GLOB.chemical_data.clearance_level
	data["is_x_level"] = GLOB.chemical_data.reached_x_access // why just why

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
			"desc" = upgrade.desc,
			"vari" = upgrade.behavior,
			"cost" = upgrade.value_upgrade,
			"ref" = upgrade.item_reference,
			"category" = upgrade.upgrade_type,
			"clearance" = upgrade.clearance_req,
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
			addtimer(CALLBACK(src, PROC_REF(process_organ)), 5 SECONDS)
			icon_state = "xeno_analyzer_on_moving"
			playsound(src.loc, 'sound/machines/blender.ogg', 25, TRUE)
			. = TRUE
		if("produce")
			var/cost = text2num(params["cost"])
			var/vari = text2num(params["varia"])
			var/clearance_req = text2num(params["clearreq"])
			if(cost && !busy)
				start_print_upgrade(params["ref"], cost, usr, vari, clearance_req)

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass()
	if(isnull(organ))
		return
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ()
	if(isnull(organ))
		return
	biomass_points += organ.research_value
	icon_state = "xeno_analyzer_off"
	QDEL_NULL(organ)

/obj/structure/machinery/xenoanalyzer/proc/start_print_upgrade(produce_path, cost, mob/user, variation, clearance_requirment)
	if (stat & NOPOWER)
		return
	if(cost > biomass_points)
		to_chat(user, SPAN_WARNING("[src] makes a worrying beep and flashes red, theres not enough data processed to build the requested upgrade!"))
		return
	if(clearance_requirment > GLOB.chemical_data.clearance_level || clearance_requirment == 6 && !GLOB.chemical_data.reached_x_access)
		to_chat(user, SPAN_WARNING("[src] makes a annoying hum and flashes red, You dont have the legal access to the upgrade!"))
		return
	else
		icon_state = "xeno_analyzer_printing"
		busy = TRUE
		biomass_points -= cost
		addtimer(CALLBACK(src, PROC_REF(print_upgrade), produce_path, variation), 5 SECONDS)

/obj/structure/machinery/xenoanalyzer/proc/print_upgrade(produce_path, variation)
	busy = FALSE
	icon_state = "xeno_analyzer_off"
	var/obj/item/research_upgrades/upgrade = new produce_path(get_turf(src))
	upgrade.value = variation










