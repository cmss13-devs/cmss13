//------------ADAPTIVE ANTAG SORTED GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons."
	icon_state = "antag_guns"
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	listed_products = list()


/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/Initialize()
	. = ..()
	var/list/factions = GLOB.faction_datums
	for (var/i in 1 to length(factions))
		var/datum/faction/F = get_faction(factions[i])
		var/list/equipment = F.get_antag_guns_sorted_equipment()
		if(LAZYLEN(equipment))
			build_icons(equipment)

	preload_assets()
	listed_products = list()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/get_listed_products(var/mob/user)
	var/mob/living/carbon/human/H = user

	var/faction = H.faction ? H.faction : FACTION_CLF
	if(!(faction in listed_products))
		var/datum/faction/F = get_faction(H.faction)
		listed_products[faction] = F.get_antag_guns_sorted_equipment()

	var/list/products_sets = listed_products[faction]
	return products_sets

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/ui_data(mob/user)
	var/list/data = ..()
	var/mob/living/carbon/human/H = user
	var/adaptive_vendor_theme = VENDOR_THEME_COMPANY	//for potential future PMC version
	switch(H.faction)
		if(FACTION_UPP)
			adaptive_vendor_theme = VENDOR_THEME_UPP
		if(FACTION_CLF)
			adaptive_vendor_theme = VENDOR_THEME_CLF
	data["theme"] = adaptive_vendor_theme
	return data
