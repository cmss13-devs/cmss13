
/datum/tech/cryomarine
	name = "Wake Up Additional Troops"
	desc = "Wakes up additional troops to fight against any threats."
	icon_state = "cryotroops"

	announce_message = "Contingency squad Foxtrot are being taken out of cryo to assist the operation."

	required_points = 10

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/three

/datum/tech/cryomarine/on_unlock()
	. = ..()
	SSticker.mode.get_specific_call(/datum/emergency_call/cryo_squad/tech, TRUE, FALSE) // "Marine Cryo Reinforcements (Tech)"
