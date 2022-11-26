//everything to reequip a specialist if needed.

//SG

/datum/supply_packs/Smartgunner_kit
	name = "M56B Smartgun System armor powerpack googles crate"
	contains = list(
					/obj/item/storage/box/m56_system,
					/obj/item/smartgun_powerpack,
					/obj/item/clothing/glasses/night/m56_goggles,
					/obj/item/clothing/suit/storage/marine/smartgunner
					)
	cost = 50
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper Smartgunner_kit crate"
	group = "Specialist Equipment"

//SL

/datum/supply_packs/armor_leader
	name = "B12 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine/leader,
					/obj/item/clothing/suit/storage/marine/leader
					)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "B12 pattern marine armor crate"
	group = "Specialist Equipment"

//RTO

/datum/supply_packs/armor_rto
	name = "M4 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine/rto,
					/obj/item/clothing/suit/storage/marine/rto
					)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "M4 pattern marine armor crate"
	group = "Specialist Equipment"

//contreband

/datum/supply_packs/clothing/merc
	contains = list()
	name = "black market clothing crate(x1)"
	cost = 30
	contraband = 1
	containertype = /obj/structure/largecrate/merc/clothing
	containername = "\improper black market clothing crate"
	group = "Specialist Equipment"

//non buyable

/datum/supply_packs/spec_kits
	name = "Weapons Specialist Kits"
	contains = list(
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "weapons specialist kits crate"
	buyable = 0
	group = "Specialist Equipment"
	iteration_needed = null
