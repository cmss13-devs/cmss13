//------------ADAPTIVE ANTAG SORTED GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons."
	icon_state = "antag_guns"
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	listed_products = list()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/Initialize()
	. = ..()
	vend_flags |= VEND_FACTION_THEMES

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/get_listed_products(mob/user)
	var/list/factions = GLOB.faction_datums
	if(!user)
		var/list/all_equipment = list()
		for (var/i in 1 to length(factions))
			var/datum/faction/current_faction = get_faction(factions[i])
			var/list/equipment = current_faction.get_antag_guns_sorted_equipment()
			if(LAZYLEN(equipment))
				all_equipment += equipment
		return all_equipment

	var/mob/living/carbon/human/human = user
	var/faction = human.faction ? human.faction : FACTION_CLF
	if(!(faction in listed_products))
		var/datum/faction/current_faction = get_faction(human.faction)
		listed_products[faction] = current_faction.get_antag_guns_sorted_equipment()

	return listed_products[faction]
