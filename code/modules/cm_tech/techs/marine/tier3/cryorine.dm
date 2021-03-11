/datum/tech/repeatable/cryomarine
	name = "Wake up additional troops"
	desc = "Wakes up additional troops to fight against any threats."

	announce_name = "Wake up additional troops"
	announce_message = "Additional troops are being taken out of cryo."

	required_points = 10
	increase_per_purchase = 10

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/three

/datum/tech/repeatable/cryomarine/can_unlock(mob/M)
	. = ..()
	if(!.)
		return
	if(!SSticker.mode)
		to_chat(M, SPAN_WARNING("You can't do this right now!"))
		return

/datum/tech/repeatable/cryomarine/on_unlock()
	. = ..()
	SSticker.mode.get_specific_call("Marine Cryo Reinforcements (Squad)", FALSE, FALSE)
