#define NUKE_UNLOCK_TIME (115 MINUTES)

/datum/tech/nuke
	name = "Nuclear Device"
	desc = "Purchase a nuclear device. It's the only way to be sure."
	icon_state = "nuke"

	required_points = 5

	tier = /datum/tier/four

	announce_name = "NUCLEAR ARSENAL ACQUIRED"
	announce_message = "A nuclear device has been authorized and will be delivered to requisitions via ASRS."

	flags = TREE_FLAG_MARINE

/datum/tech/nuke/New()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(handle_description)))

/datum/tech/nuke/on_unlock()
	. = ..()

	var/datum/supply_order/new_order = new()
	new_order.ordernum = GLOB.supply_controller.ordernum++
	var/actual_type = GLOB.supply_packs_types["Encrypted Operational Nuke"]
	new_order.object = GLOB.supply_packs_datums[actual_type]
	new_order.orderedby = MAIN_AI_SYSTEM
	new_order.approvedby = MAIN_AI_SYSTEM

	GLOB.supply_controller.shoppinglist += new_order

/datum/tech/nuke/can_unlock(mob/unlocking_mob)
	. = ..()

	if(!.)
		return

	if(ROUND_TIME < NUKE_UNLOCK_TIME)
		to_chat(unlocking_mob, SPAN_WARNING("You cannot purchase this node before [ceil((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))] minutes into the operation."))
		return FALSE

	return TRUE

/datum/tech/nuke/proc/handle_description()
	desc = "Purchase a nuclear device. Only purchasable [ceil((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))] minutes into the operation. It's the only way to be sure."
