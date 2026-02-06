/datum/tech/repeatable/dropship
	name = "Dropship Ammo"
	desc = "Purchase dropship ammunition."

	required_points = 5
	increase_per_purchase = 2

	tier = /datum/tier/two

	var/type_to_give

/datum/tech/repeatable/dropship/on_unlock()
	. = ..()
	if(!type_to_give)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = GLOB.supply_controller.ordernum++
	var/actual_type = GLOB.supply_packs_types[type_to_give]
	O.objects = list(GLOB.supply_packs_datums[actual_type])
	O.orderedby = MAIN_AI_SYSTEM

	GLOB.supply_controller.shoppinglist += O

/datum/tech/repeatable/dropship/bunkerbuster
	name = "AGM-98 'MOP' Bunker Buster Bombs"
	desc = "Highly penetrative dropship ammo, to be loaded into the LAB-107 Bomb Bay. Capable of piercing through caves."
	icon_state = "ds_bunker"

	announce_message = "AGM-98 'MOP' Bunker Buster bombs have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "AGM-98 'MOP' Bunker Buster Crate"

/datum/tech/repeatable/dropship/fatty
	name = "SM-17 'Fatty' Cluster Rockets"
	desc = "Highly explosive dropship ammo that fragments, to be loaded into the LAU-444 Guided Missile Launcher."
	icon_state = "ds_fatty"

	announce_message = "SM-17 'Fatty' cluster rockets have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "SM-17 'Fatty' Crate"

/datum/tech/repeatable/dropship/hellhound
	name = "ATM-230D 'HELLHOUND IV' Missiles"
	desc = "Highly penetrative dropship ammo that explodes into shrapnel, to be loaded into the Mk.14 Missile Silo. Capable of piercing through caves."
	icon_state = "ds_hellhound"

	announce_message = "ATM-230D 'HELLHOUND IV' missiles have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "ATM-230D 'HELLHOUND IV' Crate"
