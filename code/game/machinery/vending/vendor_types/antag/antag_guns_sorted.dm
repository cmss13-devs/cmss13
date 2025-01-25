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
	if(!user)
		var/list/all_equipment = list()
		for(var/faction_to_get in GLOB.faction_datums)
			var/datum/faction/faction = GLOB.faction_datums[faction_to_get]
			var/list/equipment = faction.get_antag_guns_sorted_equipment()
			if(length(equipment))
				all_equipment += equipment
		return all_equipment

	var/mob/living/carbon/human/human = user
	var/datum/faction/faction = human.faction ? human.faction : GLOB.faction_datums[FACTION_CLF]
	if(!(faction.code_identificator in listed_products))
		listed_products[faction.code_identificator] = faction.get_antag_guns_sorted_equipment()

	return listed_products[faction]
