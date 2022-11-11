//------------ADAPTIVE ANTAG GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/antag
	name = "\improper Suspicious Automated Gear Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various gear."
	icon_state = "gear"

	req_access = list(ACCESS_ILLEGAL_PIRATE)
	listed_products = list()

/obj/structure/machinery/cm_vending/gear/antag/get_listed_products(var/mob/user)
	. = list()
	if(!user)
		var/list/all_equipment = list()
		var/list/presets = typesof(/datum/equipment_preset)
		for(var/i in presets)
			var/datum/equipment_preset/eq = new i
			var/list/equipment = eq.get_antag_gear_equipment()
			if(LAZYLEN(equipment))
				all_equipment += equipment
			qdel(eq)
		return all_equipment
	var/mob/living/carbon/human/human = user
	if(human.assigned_equipment_preset)
		var/list/gear = human.assigned_equipment_preset.get_antag_gear_equipment()
		return gear
	else
		var/datum/equipment_preset/default = new /datum/equipment_preset/clf
		return default.get_antag_gear_equipment()

/obj/structure/machinery/cm_vending/gear/antag/ui_static_data(mob/user)
	. = ..()
	.["theme"] = VENDOR_THEME_COMPANY	//for potential future PMC version
	var/mob/living/carbon/human/human = user
	switch(human.faction)
		if(FACTION_UPP)
			.["theme"] = VENDOR_THEME_UPP
		if(FACTION_CLF)
			.["theme"] = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/gear/antag/vend_succesfully(var/list/L, var/mob/living/carbon/human/H)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))

		var/prod_type = L[3]
		var/obj/item/O
		if(ispath(prod_type, /obj/effect/essentials_set/random))
			new prod_type(src)
			for(var/obj/item/IT in contents)
				O = IT
				O.forceMove(get_appropriate_vend_turf())
		else
			if(ispath(prod_type, /obj/item/weapon/gun))
				O = new prod_type(get_appropriate_vend_turf(), TRUE)
			else
				O = new prod_type(get_appropriate_vend_turf())
		O.add_fingerprint(usr)

	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		overlays += image(icon, "[icon_state]_deny")
		sleep(5)
	stat &= ~IN_USE
	update_icon()
	return

//--------------ESSENTIALS------------------------

/obj/effect/essentials_set/medic/upp
	spawned_gear_list = list(
		/obj/item/bodybag/cryobag,
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/roller,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft
	)

/obj/effect/essentials_set/upp_heavy
	spawned_gear_list = list(
		/obj/item/weapon/gun/minigun/upp,
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/minigun
	)

/obj/effect/essentials_set/leader/upp
	spawned_gear_list = list(
		/obj/item/explosive/plastic,
		/obj/item/device/binoculars/range,
		/obj/item/map/current_map,
		/obj/item/storage/box/zipcuffs
	)

/obj/effect/essentials_set/kit/svd
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd
	)

/obj/effect/essentials_set/kit/custom_shotgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/shotgun/merc,
		/obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/ammo_magazine/shotgun,
		/obj/item/ammo_magazine/shotgun/flechette
	)

/obj/effect/essentials_set/kit/m60
	spawned_gear_list = list(
		/obj/item/weapon/gun/m60,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/m60
	)

/obj/effect/essentials_set/random/clf_bonus_item
	spawned_gear_list = list(
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/tool/hatchet,
					/obj/item/tool/hatchet,
					/obj/item/weapon/melee/twohanded/spear,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/ld50_syringe/choral,
					/obj/item/storage/bible,
					/obj/item/clothing/mask/gas/PMC,
					/obj/item/clothing/accessory/storage/holster,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/explosive/grenade/smokebomb,
					)
