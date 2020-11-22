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
		// Found a backpack, storage
		if(isstorage(I))
			for(var/obj/item/backpackI in I)
				if(istypestrict(backpackI, item_to_steal_type))
					return TRUE
		// Check the pockets in the armour
		if(istype(I, /obj/item/clothing/suit/storage))
			var/obj/item/clothing/suit/storage/S = I
			if(S.pockets)//not all suits have pockits
				var/obj/item/storage/internal/Int = S.pockets
				for(var/obj/item/backpackI in Int)
					if(istypestrict(backpackI, item_to_steal_type))
						return TRUE
		// Check the webbing/uniform storage
		if(istype(I, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = I
			for(var/obj/item/clothing/accessory/storage/T in U.accessories)
				var/obj/item/storage/internal/Int = T.hold
				for(var/obj/item/backpackI in Int)
					if(istypestrict(backpackI, item_to_steal_type))
						return TRUE

		if(istypestrict(I, item_to_steal_type))
			return TRUE

	return FALSE

/datum/agent_objective/steal/earmuffs
	item_to_steal_type = /obj/item/clothing/ears/earmuffs

/datum/agent_objective/steal/autopsy
	item_to_steal_type = /obj/item/device/autopsy_scanner

/datum/agent_objective/steal/ob_manual
	item_to_steal_type = /obj/item/book/manual/orbital_cannon_manual

/datum/agent_objective/steal/health_analyzer
	item_to_steal_type = /obj/item/device/healthanalyzer/golden

/datum/agent_objective/steal/golden_cup
	item_to_steal_type = /obj/item/golden_cup

/datum/agent_objective/steal/golden_coin
	item_to_steal_type = /obj/item/coin/gold

/datum/agent_objective/steal/tally_book
	item_to_steal_type = /obj/item/tally_book

/datum/agent_objective/steal/folded_medical_sheet
	item_to_steal_type = /obj/item/folded_medical_sheet

// CMO item
/obj/item/device/healthanalyzer/golden
	name = "golden HF2 health analyzer"
	desc = "A special health analyzer with a golden front place. Property of the Chief Medical Officer."
	icon_state = "golden_health"
	item_state = "analyzer"

/obj/item/device/healthanalyzer/golden/New()
	. = ..()
	
	LAZYADD(objects_of_interest, src)

/obj/item/device/healthanalyzer/golden/Destroy()
	. = ..()
	
	LAZYREMOVE(objects_of_interest, src)

// Medbay item
/obj/item/folded_medical_sheet
	name = "folded medical sheet"
	desc = "A folded medical sheet, it is neatly packed."
	icon_state = "folded_sheet_medical"
	item_state = "folded_sheet_medical"

/obj/item/folded_medical_sheet/New()
	. = ..()
	
	LAZYADD(objects_of_interest, src)

/obj/item/folded_medical_sheet/Destroy()
	. = ..()
	
	LAZYREMOVE(objects_of_interest, src)

// Req tally book
/obj/item/tally_book
	name = "tally book"
	desc = "Property of the Requisitions Officer, this is the holy book of Requisition. It keeps count of all the money spent on supplies."
	icon = 'icons/obj/items/books.dmi'
	icon_state ="book"

/obj/item/tally_book/New()
	. = ..()
	
	LAZYADD(objects_of_interest, src)

/obj/item/tally_book/Destroy()
	. = ..()
	
	LAZYREMOVE(objects_of_interest, src)

// CIC item
/obj/item/golden_cup
	name = "golden cup"
	desc = "A sign of vanity for the coffee addict. What idiot decided this was a good idea? Belongs to CiC staff."
	icon_state = "golden_cup"
	item_state = "golden_cup"

/obj/item/golden_cup/New()
	. = ..()
	
	LAZYADD(objects_of_interest, src)
	
/obj/item/golden_cup/Destroy()
	. = ..()
	
	LAZYREMOVE(objects_of_interest, src)