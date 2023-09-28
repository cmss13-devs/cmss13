/datum/tech/cryomarine
	name = "Wake Up Additional Specialist"
	desc = "Wakes up an additional specialist to fight against any threats."
	icon_state = "overshield"

	announce_name = "ALMAYER SPECIAL ASSETS AUTHORIZED"
	announce_message = "An additional specialist is being taken out of cryo."

	required_points = 8

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/three

/datum/tech/cryomarine/can_unlock(mob/user)
	. = ..()
	if(!.)
		return
	if(!SSticker.mode)
		to_chat(user, SPAN_WARNING("You can't do this right now!"))
		return

/datum/tech/cryomarine/on_unlock()
	. = ..()
	SSticker.mode.get_specific_call("Marine Cryo Reinforcement (Spec)", TRUE, FALSE, FALSE, announce_dispatch_message = FALSE)
