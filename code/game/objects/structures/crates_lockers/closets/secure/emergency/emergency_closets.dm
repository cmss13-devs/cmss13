/obj/structure/closet/secure_closet/emergency
	name = "emergency closet"
	desc = "It's an immobile card-locked storage unit that uses evacuation protocols to determine its opening, closing, locking, and unlocking behavior."
	icon_state = "secure1"
	var/hijack = FALSE
	store_mobs = FALSE

/obj/structure/closet/secure_closet/emergency/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_INBOUND, PROC_REF(open_up))
	return

/obj/structure/closet/secure_closet/emergency/togglelock(mob/living/user)
	if(hijack == FALSE)
		to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
	else
		return ..()

/obj/structure/closet/secure_closet/emergency/attackby(obj/item/W, mob/living/user)
	if(hijack == FALSE)
		to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
	else
		return ..()

/obj/structure/closet/secure_closet/emergency/attack_hand(mob/living/user)
	if(hijack == FALSE)
		to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
	else
		return ..()

/obj/structure/closet/secure_closet/emergency/verb_toggleopen(mob/living/user)
	if(hijack == FALSE)
		to_chat(user, SPAN_WARNING("This locker will unlock and open itself during evacuation procedures."))
	else
		return ..()

/obj/structure/closet/secure_closet/emergency/AIShiftClick()
	return

/obj/structure/closet/secure_closet/emergency/proc/open_up() //A DROPSHIP HAS BEEN HIJACKED! OPEN DIS BITCH UP!
	hijack = TRUE
	unlock()
	open()
	req_access = list(ACCESS_MARINE_MEDBAY) //ALL Y'ALL FOB MEDICS NOW!
