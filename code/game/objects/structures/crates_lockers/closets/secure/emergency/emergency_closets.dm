/obj/structure/closet/secure_closet/emergency
	name = "emergency closet"
	desc = "It's an immobile card-locked storage unit that uses evacuation protocols to determine its opening, closing, locking, and unlocking behavior."
	icon_state = "secure1"

/obj/structure/closet/secure_closet/emergency/togglelock(mob/living/user)
	switch(SShijack.evac_status)
		if(EVACUATION_STATUS_NOT_INITIATED)
			to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
			return
		if(EVACUATION_STATUS_INITIATED)
			to_chat(user, SPAN_NOTICE("This locker must remain unlocked and open during evacuation procedures."))
			return

/obj/structure/closet/secure_closet/emergency/attackby(obj/item/W, mob/living/user)
	switch(SShijack.evac_status)
		if(EVACUATION_STATUS_NOT_INITIATED)
			to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
			return
		if(EVACUATION_STATUS_INITIATED)
			to_chat(user, SPAN_NOTICE("This locker must remain unlocked and open during evacuation procedures."))
			return

/obj/structure/closet/secure_closet/emergency/attack_hand(mob/living/user)
	switch(SShijack.evac_status)
		if(EVACUATION_STATUS_NOT_INITIATED)
			to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
			return
		if(EVACUATION_STATUS_INITIATED)
			to_chat(user, SPAN_NOTICE("This locker must remain unlocked and open during evacuation procedures."))
			return

/obj/structure/closet/secure_closet/emergency/verb_toggleopen(mob/living/user)
	switch(SShijack.evac_status)
		if(EVACUATION_STATUS_NOT_INITIATED)
			to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
			return
		if(EVACUATION_STATUS_INITIATED)
			to_chat(user, SPAN_NOTICE("This locker must remain unlocked and open during evacuation procedures."))
			return

/obj/structure/closet/secure_closet/AIShiftClick()
	return


