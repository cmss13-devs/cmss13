//------------ADAPTIVE ANTAG CLOSET---------------
//Spawn one of these bad boys and you will have a proper automated closet for CLF/UPP players (for now, more can be always added later)

/obj/structure/machinery/cm_vending/clothing/antag
	name = "\improper Suspicious Automated Equipment Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various equipment."
	icon_state = "antag_clothing"
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	listed_products = list()

/obj/structure/machinery/cm_vending/clothing/antag/get_listed_products(var/mob/user)
	if(!user)
		var/list/all_equipment = list()
		var/list/presets = typesof(/datum/equipment_preset)
		for(var/i in presets)
			var/datum/equipment_preset/eq = new i
			var/list/equipment = eq.get_antag_clothing_equipment()
			if(LAZYLEN(equipment))
				all_equipment += equipment
			qdel(eq)
		return all_equipment

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/list/products_sets = list()
	if(H.assigned_equipment_preset)
		if(!(H.assigned_equipment_preset.type in listed_products))
			listed_products[H.assigned_equipment_preset.type] = H.assigned_equipment_preset.get_antag_clothing_equipment()
		products_sets = listed_products[H.assigned_equipment_preset.type]
	else
		if(!(/datum/equipment_preset/clf in listed_products))
			listed_products[/datum/equipment_preset/clf] = GLOB.gear_path_presets_list[/datum/equipment_preset/clf].get_antag_clothing_equipment()
		products_sets = listed_products[/datum/equipment_preset/clf]
	return products_sets

/obj/structure/machinery/cm_vending/clothing/antag/ui_static_data(mob/user)
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

//--------------RANDOM EQUIPMENT AND GEAR------------------------

/obj/effect/essentials_set/random/clf_shoes
	spawned_gear_list = list(
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/combat,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/shoes/swat
					)

/obj/effect/essentials_set/random/clf_armor
	spawned_gear_list = list(
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/storage/militia/brace,
					/obj/item/clothing/suit/storage/militia,
					/obj/item/clothing/suit/storage/militia/partial,
					/obj/item/clothing/suit/storage/militia/vest
					)

/obj/effect/essentials_set/random/clf_gloves
	spawned_gear_list = list(
					/obj/item/clothing/gloves/black,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/gloves/combat,
					/obj/item/clothing/gloves/swat
					)

/obj/effect/essentials_set/random/clf_head
	spawned_gear_list = list(
					/obj/item/clothing/head/militia,
					/obj/item/clothing/head/militia/bucket,
					/obj/item/clothing/head/helmet/skullcap,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/bandana,
					/obj/item/clothing/head/headband/red,
					/obj/item/clothing/head/headband/rambo,
					/obj/item/clothing/head/headband/rebel,
					/obj/item/clothing/head/helmet/swat
					)

/obj/effect/essentials_set/random/clf_belt
	spawned_gear_list = list(
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/gun/flaregun/full,
					/obj/item/storage/belt/gun/flaregun/full,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/belt/knifepouch,
					/obj/item/storage/large_holster/katana/full,
					/obj/item/storage/large_holster/machete/full
					)
