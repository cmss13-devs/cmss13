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
	new_order.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	new_order.object = supply_controller.supply_packs["Encrypted Operational Nuke"]
	new_order.orderedby = MAIN_AI_SYSTEM
	new_order.approvedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += new_order

/datum/tech/nuke/can_unlock(mob/unlocking_mob)
	. = ..()

	if(!.)
		return

	if(ROUND_TIME < NUKE_UNLOCK_TIME)
		to_chat(unlocking_mob, SPAN_WARNING("You cannot purchase this node before [Ceiling((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))] minutes into the operation."))
		return FALSE

	return TRUE

/datum/tech/nuke/proc/handle_description()
	desc = "Purchase a nuclear device. Only purchasable [Ceiling((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))] minutes into the operation. It's the only way to be sure."
