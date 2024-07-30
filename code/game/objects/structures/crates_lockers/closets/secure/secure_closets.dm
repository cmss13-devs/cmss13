/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon_state = "secure1"
	density = TRUE
	opened = 0
	var/locked = 1
	var/broken = 0
	var/large = 1
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	health = 100
	var/slotlocked = 0
	var/slotlocktype = null

/obj/structure/closet/secure_closet/can_open()
	if(src.locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = src.icon_off
		return 1
	else
		return 0

/obj/structure/closet/secure_closet/emp_act(severity)
	. = ..()
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_access(ACCESS_LIST_MARINE_MAIN))

/obj/structure/closet/secure_closet/proc/togglelock(mob/living/user)
	if(opened)
		to_chat(user, SPAN_NOTICE("Close the locker first."))
		return
	if(broken)
		to_chat(user, SPAN_WARNING("The locker appears to be broken."))
		return
	if(user.loc == src)
		to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
		return
	if(allowed(user))
		if(slotlocked && ishuman(user))
			var/mob/living/carbon/human/human = user
			var/obj/item/card/id/card = human.get_idcard()
			if(card)
				if(card.claimedgear)
					return
				switch(slotlocktype)
					if("engi")
						if(human.job != "Squad Combat Technician")
							return // stop people giving medics engineer prep access or IDs somehow
					if("medic")
						if(human.job != "Squad Hospital Corpsman")
							return // same here
				card.claimedgear = TRUE // you only get one locker, all other roles have this set 1 by default
				slotlocked = FALSE // now permanently unlockable
			else
				return // they have no ID on, fuck them.
		locked = !locked
		for(var/mob/mob in viewers(user, 3))
			if((mob.client && !( mob.blinded )))
				to_chat(mob, SPAN_NOTICE("The locker has been [locked ? null : "un"]locked by [user]."))
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/secure_closet/attackby(obj/item/W, mob/living/user)
	if(src.opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if(G.grabbed_thing)
				if(src.large)
					src.MouseDrop_T(G.grabbed_thing, user) //act like they were dragged onto the closet
				else
					to_chat(user, SPAN_NOTICE("The locker is too small to stuff [W:affecting] into!"))
			return
		if(iszombie(user))
			return
		user.drop_inv_item_to_loc(W, loc)
	else if(istype(W, /obj/item/packageWrap) || istype(W, /obj/item/explosive/plastic))
		return
	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		return ..(W,user)
	else
		if(isxeno(user))
			var/mob/living/carbon/xenomorph/opener = user
			src.attack_alien(opener)
			return
		togglelock(user)

/obj/structure/closet/secure_closet/attack_hand(mob/living/user)
	src.add_fingerprint(user)
	if(src.locked)
		src.togglelock(user)
	else
		if(opened && isxeno(user))
			return // stop xeno closing them
		src.toggle(user)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(usr.is_mob_incapacitated()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/secure_closet/AIShiftClick()
	locked = !locked
	update_icon()

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays -= "welded"
	if(!opened)
		if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			overlays += "welded"
	else
		icon_state = icon_opened

/obj/structure/closet/secure_closet/break_open()
	broken = TRUE
	locked = FALSE
	..()
