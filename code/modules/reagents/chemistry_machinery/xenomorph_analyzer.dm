/obj/structure/machinery/xenoanalyzer
	name = "Biomass Analyzer"
	desc = "Analyzer of biological material which processes valuable matter into even more valueble data."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "xeno_analyzer" //for the time while no sprites
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	bound_x = 32
	///assoc list containing the path to every upgrade followed by a number representing times this tech was bought. used by price inflation mechanic to increase/decrease price depending on the amount of times you bought it.
	var/list/technology_purchased = list()
	var/biomass_points = 0 //most important thing in this
	var/obj/item/organ/xeno/organ = null
	///normal list of typepaths containing a printing queue.
	var/list/print_queue = list()
	var/busy = FALSE
	var/queue_proccessing = FALSE
	var/caste_of_organ = null

/obj/structure/machinery/xenoanalyzer/Initialize(mapload, ...)
	. = ..()
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY)
			continue
		if(upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		technology_purchased[upgrade_type] = 0

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

/obj/structure/machinery/xenoanalyzer/attackby(obj/item/attacked_item, mob/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(attacked_item, /obj/item/organ/xeno))
		if(busy)
			to_chat(user, SPAN_WARNING("The [src] is currently busy!"))
		if(organ)
			to_chat(user, SPAN_WARNING("Organ slot is already full!"))
			return
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interupted!"))
			return
		if(!user.drop_inv_item_to_loc(attacked_item, src))
			return
		to_chat(user, SPAN_NOTICE("You place the organ in the machine"))
		organ = attacked_item
		icon_state = "xeno_analyzer_organ_on"
		caste_of_organ = organ.caste_origin
		playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	if(istype(attacked_item, /obj/item/clothing/accessory/health/research_plate))
		var/obj/item/clothing/accessory/health/research_plate/plate = attacked_item
		if(plate.recyclable_value == 0 && !plate.can_recycle(user))
			to_chat(user, SPAN_WARNING("You cannot recycle this type of plate"))
			return
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interupted!"))
			return
		to_chat(user, SPAN_NOTICE("You recycle [attacked_item]"))
		biomass_points += plate.recyclable_value
		qdel(attacked_item)
		playsound(loc, 'sound/machines/fax.ogg', 15, 1)

/obj/structure/machinery/xenoanalyzer/ui_data(mob/user)
	var/list/data = list()
	data["points"] = biomass_points
	data["current_clearance"] = GLOB.chemical_data.clearance_level
	data["is_x_level"] = GLOB.chemical_data.reached_x_access // why just why
	data["is_processing"] = queue_proccessing
	if(organ)
		data["organ"] = TRUE
		data["caste"] = caste_of_organ
		data["value"] = organ.research_value
	else
		data["organ"] = FALSE
	data["upgrades"] = list()
	data["categories"] = list()
	data["print_queue"] = list()
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))// moved this here since prices are dynamic now
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY)
			data["categories"] += upgrade.name
			continue
		if(upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		var/price_adjustment = clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[upgrade_type], upgrade.minimum_price, upgrade.maximum_price)
		data["upgrades"] += list(list(
			"name" = capitalize_first_letters(upgrade.name),
			"desc" = upgrade.desc,
			"cost" = price_adjustment,
			"ref" = upgrade_type,
			"category" = upgrade.upgrade_type,
			"clearance" = upgrade.clearance_req,
			"price_change" = upgrade.change_purchase,
		))
	for(var/upgrade_path in print_queue)
		var/datum/research_upgrades/upgrade = upgrade_path
		data["print_queue"] += list(list(
			"name" = capitalize_first_letters(upgrade.name),
			"id" = upgrade_path,
		))
	if(!length(data["print_queue"]))
		data["print_queue"] = null



	return data

/obj/structure/machinery/xenoanalyzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_organ")
			eject_biomass(ui.user)
			. = TRUE

		if("process_organ")
			if(!busy)
				busy = TRUE
				addtimer(CALLBACK(src, PROC_REF(process_organ), organ.research_value), 3 SECONDS)
				flick("xeno_analyzer_on_moving", src)
				playsound(loc, 'sound/machines/blender.ogg', 25, TRUE)
				QDEL_NULL(organ)
				. = TRUE
		if("produce")
			if(!busy)
				for(var/i in 1 to text2num(params["amount"]))
					if(!add_to_queue_upgrade(text2path(params["ref"]), ui.user))
						return
		if("toggle_processing")
			if(queue_proccessing)
				queue_proccessing = FALSE
			else
				attempt_process_queue()
		if("remove_from_queue")
			LAZYREMOVE(print_queue, params["upgrade_id"])
	playsound(src, 'sound/machines/keyboard2.ogg', 25, TRUE)

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass(mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("[src] is currently busy!"))
		return
	if(isnull(organ))
		return
	icon_state = "xeno_analyzer"
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ(biomass_points_to_add)
	biomass_points += biomass_points_to_add
	icon_state = "xeno_analyzer"
	busy = FALSE

/obj/structure/machinery/xenoanalyzer/proc/attempt_process_queue(mob/user)
	if(stat & NOPOWER)
		icon_state = "xeno_analyzer_off"
		return
	if(!length(print_queue))
		return
	queue_proccessing = TRUE
	var/datum/research_upgrades/upgrade = print_queue[length(print_queue)]
	if(clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[upgrade], upgrade.minimum_price, upgrade.maximum_price) > biomass_points)
		to_chat(user, SPAN_WARNING("[src] makes a worrying beep and flashes red, theres not enough data processed to build the requested upgrade!"))
		queue_proccessing = FALSE
		return
	flick("xeno_analyzer_printing", src)
	biomass_points -= clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[upgrade], upgrade.minimum_price, upgrade.maximum_price)
	technology_purchased[upgrade] += 1
	playsound(loc, 'sound/machines/print.ogg', 25)
	if(length(print_queue) >= 1)
		addtimer(CALLBACK(src, PROC_REF(print_upgrade), upgrade, user), 2.5 SECONDS)
	else
		queue_proccessing = FALSE



/obj/structure/machinery/xenoanalyzer/proc/add_to_queue_upgrade(produce_path, mob/user)
	if(stat & NOPOWER)
		icon_state = "xeno_analyzer_off"
		return FALSE
	if(busy)//double check for me here
		to_chat(user, SPAN_WARNING("[src] makes a annoying hum and flashes red - its currently busy!"))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
		return FALSE
	var/path_exists = FALSE
	var/datum/research_upgrades/upgrade
	var/datum_upgrades
	for(datum_upgrades in subtypesof(/datum/research_upgrades))
		upgrade = datum_upgrades
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY || upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		if(produce_path == datum_upgrades)
			path_exists = TRUE
			break
	if(!path_exists)
		to_chat(user, SPAN_WARNING("[src] makes a suspicious wail before powering down."))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
		return FALSE
	if((upgrade.clearance_req > GLOB.chemical_data.clearance_level && upgrade.clearance_req != 6) || (upgrade.clearance_req == 6 && !GLOB.chemical_data.reached_x_access))
		to_chat(user, SPAN_WARNING("[src] makes a annoying hum and flashes red - you don't have access to this upgrade!"))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
		return FALSE
	if(clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[datum_upgrades], upgrade.minimum_price, upgrade.maximum_price) > biomass_points)
		to_chat(user, SPAN_WARNING("[src] makes a worrying beep and flashes red, theres not enough data processed to build the requested upgrade!"))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
		return FALSE
	if(length(print_queue) == 10)
		to_chat(user, SPAN_WARNING("[src] internal memory buffer is full!"))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
		return FALSE
	LAZYADD(print_queue, upgrade)
	if(!queue_proccessing)
		attempt_process_queue(user)
	return TRUE

/obj/structure/machinery/xenoanalyzer/proc/print_upgrade(produce_path, mob/user)
	busy = FALSE
	var/datum/research_upgrades/item = new produce_path()
	item.on_purchase(get_turf(src))
	LAZYREMOVE(print_queue, produce_path)
	if(!isnull(print_queue) && queue_proccessing)
		attempt_process_queue(user)
	else
		queue_proccessing = FALSE

