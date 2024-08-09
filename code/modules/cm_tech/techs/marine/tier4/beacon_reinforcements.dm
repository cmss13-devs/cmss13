
/datum/tech/beacon
	name = "Call For Reinforcements"
	desc = "Activate the long range transmitters to call for reinforcements."
	icon_state = "beacon"

	announce_message = "ARES is activating its long range transmitters to call for reinforcements. Standby..."

	required_points = 10

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/four

/datum/tech/beacon/on_unlock()
	. = ..()
	var/pick_reinforcements = rand(1,4)
	switch(pick_reinforcements)
		if(1)
			SSticker.mode.get_specific_call(/datum/emergency_call/freelancer/beacon, TRUE, TRUE)
		if(2)
			SSticker.mode.get_specific_call(/datum/emergency_call/rmc/beacon, TRUE, TRUE)
		if(3)
			SSticker.mode.get_specific_call(/datum/emergency_call/upp/beacon, TRUE, TRUE)
		if(4)
			SSticker.mode.get_specific_call(/datum/emergency_call/vaipo/beacon, TRUE, TRUE)
