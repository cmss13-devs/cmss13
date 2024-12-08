//------------ADAPTIVE ANTAG GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/antag
	name = "\improper Suspicious Automated Gear Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various gear."
	icon_state = "gear"

	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null
	listed_products = list()

/obj/structure/machinery/cm_vending/gear/antag/Initialize()
	. = ..()
	vend_flags |= VEND_FACTION_THEMES

/obj/structure/machinery/cm_vending/gear/antag/get_listed_products(mob/user)
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
		return human.assigned_equipment_preset.get_antag_gear_equipment()
	else
		var/datum/equipment_preset/default = new /datum/equipment_preset/clf
		var/list/gear = default.get_antag_gear_equipment()
		qdel(default)
		return gear

//--------------ESSENTIALS------------------------

/obj/effect/essentials_set/medic/upp
	spawned_gear_list = list(
		/obj/item/bodybag/cryobag,
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/roller,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/structure/bed/medevac_stretcher/upp,
		/obj/item/storage/surgical_case/regular,
		/obj/item/reagent_container/blood/OMinus,
		/obj/item/reagent_container/blood/OMinus,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/accessory/stethoscope,
	)

/obj/effect/essentials_set/leader/upp
	spawned_gear_list = list(
		/obj/item/explosive/plastic,
		/obj/item/device/binoculars/range,
		/obj/item/map/current_map,
		/obj/item/storage/box/zipcuffs,
	)

/obj/effect/essentials_set/kit/svd
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
	)

/obj/effect/essentials_set/kit/custom_shotgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/shotgun/merc,
		/obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/ammo_magazine/shotgun,
		/obj/item/ammo_magazine/shotgun/flechette,
	)

/obj/effect/essentials_set/kit/m60
	spawned_gear_list = list(
		/obj/item/weapon/gun/m60,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/m60,
	)

/obj/effect/essentials_set/random/clf_bonus_item
	spawned_gear_list = list(
		/obj/item/storage/pill_bottle/tramadol/skillless,
		/obj/item/storage/pill_bottle/tramadol/skillless,
		/obj/item/storage/pill_bottle/tramadol/skillless,
		/obj/item/tool/hatchet,
		/obj/item/tool/hatchet,
		/obj/item/weapon/twohanded/spear,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/reagent_container/ld50_syringe/choral,
		/obj/item/storage/bible,
		/obj/item/clothing/mask/gas/pmc,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/explosive/grenade/smokebomb,
	)
