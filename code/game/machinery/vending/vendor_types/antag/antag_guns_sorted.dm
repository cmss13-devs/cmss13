//------------ADAPTIVE ANTAG SORTED GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons."
	icon_state = "antag_guns"
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null
	listed_products = list()
	use_points = FALSE
	use_snowflake_points = FALSE

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/Initialize()
	. = ..()
	vend_flags |= VEND_FACTION_THEMES

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/get_listed_products(mob/user)
	var/list/factions = GLOB.faction_datums
	if(!user)
		var/list/all_equipment = list()
		for (var/i in 1 to length(factions))
			var/datum/faction/F = get_faction(factions[i])
			var/list/equipment = F.get_antag_guns_sorted_equipment()
			if(LAZYLEN(equipment))
				all_equipment += equipment
		return all_equipment

	var/mob/living/carbon/human/H = user
	var/faction = H.faction ? H.faction : FACTION_CLF
	if(!(faction in listed_products))
		var/datum/faction/F = get_faction(H.faction)
		listed_products[faction] = F.get_antag_guns_sorted_equipment()

	return listed_products[faction]
