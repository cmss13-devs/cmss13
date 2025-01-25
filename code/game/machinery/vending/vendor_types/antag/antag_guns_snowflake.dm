//------------ADAPTIVE ANTAG GUNS VENDOR THAT USES SNOWFLAKE POINTS---------------

/obj/structure/machinery/cm_vending/gear/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons, ammunition and explosives."
	icon_state = "antag_guns"
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null

	use_snowflake_points = TRUE

	listed_products = list()

/obj/structure/machinery/cm_vending/gear/antag_guns/Initialize()
	. = ..()
	vend_flags |= VEND_FACTION_THEMES

/obj/structure/machinery/cm_vending/gear/antag_guns/get_listed_products(mob/user)
	if(!user)
		var/list/all_equipment = list()
		for(var/faction_to_get in GLOB.faction_datums)
			var/datum/faction/faction = GLOB.faction_datums[faction_to_get]
			var/list/equipment = faction.get_antag_guns_snowflake_equipment()
			if(length(equipment))
				all_equipment += equipment
		return all_equipment

	var/mob/living/carbon/human/human = user
	var/datum/faction/faction = human.faction ? human.faction : GLOB.faction_datums[FACTION_CLF]
	if(!(faction.code_identificator in listed_products))
		listed_products[faction.code_identificator] = faction.get_antag_guns_snowflake_equipment()

	return listed_products[faction]

//--------------ESSENTIALS------------------------


/obj/effect/essentials_set/upp_heavy
	spawned_gear_list = list(
		/obj/item/weapon/gun/minigun/upp,
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/minigun,
	)

/obj/effect/essentials_set/upp_heavy_pkp
	spawned_gear_list = list(
		/obj/item/weapon/gun/pkp,
		/obj/item/ammo_magazine/pkp,
		/obj/item/ammo_magazine/pkp,
		/obj/item/ammo_magazine/pkp,
		/obj/item/ammo_magazine/pkp,
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
		/obj/item/ammo_magazine/m60,
	)

/obj/effect/essentials_set/random/clf_melee
	spawned_gear_list = list(
		/obj/item/tool/hatchet,
		/obj/item/tool/hatchet,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/weapon/twohanded/spear,
		/obj/item/weapon/twohanded/spear,
		/obj/item/weapon/twohanded/fireaxe,
	)
