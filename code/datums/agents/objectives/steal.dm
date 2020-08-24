/datum/agent_objective/steal
	description = ""
	var/item_to_steal_type = /obj/item/holder/Jones
	var/messages
	var/picked_message = "Create confusion and distrust, by"

/datum/agent_objective/steal/New(datum/agent/A)
	messages = list("Drain the [MAIN_SHIP_NAME] supplies by", "Create confusion and distrust by", "Make a department get in trouble by")

	. = ..()

/datum/agent_objective/steal/generate_objective_body_message()
	picked_message = pick(messages)

	var/obj/item = item_to_steal_type
	return "[picked_message] [SPAN_BOLD("[SPAN_BLUE("stealing")]")] a [SPAN_BOLD("[SPAN_RED("[initial(item.name)]")]")]."

/datum/agent_objective/steal/generate_description()
	var/obj/item = item_to_steal_type
	description = "[picked_message] stealing a [initial(item.name)]."

/datum/agent_objective/steal/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	for(var/obj/item/I in belonging_to_agent.source_human)
		if(istype(I, /obj/item/storage))
			for(var/obj/item/backpackI in I)
				if(istypestrict(backpackI, item_to_steal_type))
					return TRUE

		if(istypestrict(I, item_to_steal_type))
			return TRUE

	return FALSE


/datum/agent_objective/steal/jones
	item_to_steal_type = /obj/item/holder/Jones

/datum/agent_objective/steal/camera
	item_to_steal_type = /obj/item/device/camera

/datum/agent_objective/steal/earmuffs
	item_to_steal_type = /obj/item/clothing/ears/earmuffs

/datum/agent_objective/steal/autopsy
	item_to_steal_type = /obj/item/device/autopsy_scanner

/datum/agent_objective/steal/ob_manual
	item_to_steal_type = /obj/item/book/manual/orbital_cannon_manual

/datum/agent_objective/steal/marine_law_manual
	item_to_steal_type = /obj/item/book/manual/marine_law

/datum/agent_objective/steal/fuel_cell
	item_to_steal_type = /obj/item/fuelCell

/datum/agent_objective/steal/wet_floor
	item_to_steal_type = /obj/item/tool/wet_sign

/datum/agent_objective/steal/bible
	item_to_steal_type = /obj/item/storage/bible

/datum/agent_objective/steal/powercell
	item_to_steal_type = /obj/item/cell/high

/datum/agent_objective/steal/cigars
	item_to_steal_type = /obj/item/storage/fancy/cigar