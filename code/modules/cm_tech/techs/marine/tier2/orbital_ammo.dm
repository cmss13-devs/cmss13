/datum/tech/repeatable/ob
	name = "OB Ammo"
	desc = "Purchase orbital bombardment ammo."

	required_points = 5
	increase_per_purchase = 2

	tier = /datum/tier/two

	var/type_to_give

/datum/tech/repeatable/ob/on_unlock()
	. = ..()
	if(!type_to_give)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs[type_to_give]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/tech/repeatable/ob/he
	name = "Additional OB projectiles - HE"
	desc = "Highly explosive bombardment ammo, to be loaded into the orbital cannon."
	icon_state = "ob_he"

	announce_name = "Additional OB projectiles - HE"
	announce_message = "Additional Orbital Bombardment ordnance (HE) have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "OB HE Crate"

/datum/tech/repeatable/ob/cluster
	name = "Additional OB projectiles - Cluster"
	desc = "Highly explosive bombardment ammo that fragments, to be loaded into the orbital cannon."
	icon_state = "ob_cluster"

	announce_name = "Additional OB projectiles - Cluster"
	announce_message = "Additional Orbital Bombardment ordnance (Cluster) have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "OB Cluster Crate"

/datum/tech/repeatable/ob/incend
	name = "Additional OB projectiles - Incendiary"
	desc = "Highly flammable bombardment ammo, to be loaded into the orbital cannon"
	icon_state = "ob_incend"

	announce_name = "Additional OB projectiles - Incendiary"
	announce_message = "Additional Orbital Bombardment ordnance (Incendiary) have been delivered to Requisitions' ASRS."

	flags = TREE_FLAG_MARINE

	type_to_give = "OB Incendiary Crate"
