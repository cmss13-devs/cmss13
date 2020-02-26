/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	matter = list("metal" = 100, "waste" = 10)
	
	var/armed = 0

/obj/item/device/assembly/mousetrap/attackby()
	return

/obj/item/device/assembly/mousetrap/examine(mob/user)
	..()
	if(armed)
		to_chat(user, "It looks like it's armed.")

/obj/item/device/assembly/mousetrap/update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(mob/target as mob, var/type = "feet")
	if(!armed)
		return
	var/obj/limb/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_limb(pick("l_leg", "r_leg"))
					H.KnockDown(3)
			if("l_hand", "r_hand")
				if(!H.gloves)
					affecting = H.get_limb(type)
					H.Stun(3)
		if(affecting)
			if(affecting.take_damage(1, 0))
				H.UpdateDamageIcon()
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message(SPAN_DANGER("<b>SPLAT!</b>"))
		M.splat()
	if(!target) return
	playsound(target.loc, 'sound/effects/snap.ogg', 25, 1)
	layer = MOB_LAYER - 0.2
	armed = 0
	update_icon()
	pulse(0)


/obj/item/device/assembly/mousetrap/attack_self(mob/living/user as mob)
	if(!armed)
		to_chat(user, SPAN_NOTICE("You arm [src]."))
	else
		if((user.getBrainLoss() >= 60) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message(SPAN_WARNING("[user] accidentally sets off [src], breaking their fingers."), SPAN_WARNING("You accidentally trigger [src]!"))
			return
		to_chat(user, SPAN_NOTICE("You disarm [src]."))
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 25, 1, 6)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user as mob)
	if(armed)
		if((user.getBrainLoss() >= 60) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message(SPAN_WARNING("[user] accidentally sets off [src], breaking their fingers."),SPAN_WARNING("You accidentally trigger [src]!"))
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(atom/movable/AM)
	if(armed)
		if(ishuman(AM))
			var/mob/living/carbon/H = AM
			if(H.m_intent == MOVE_INTENT_RUN)
				triggered(H)
				H.visible_message(SPAN_WARNING("[H] accidentally steps on [src]."),SPAN_WARNING("You accidentally step on [src]"))
		if(ismouse(AM))
			triggered(AM)
	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder as mob)
	if(armed)
		finder.visible_message(SPAN_WARNING("[finder] accidentally sets off [src], breaking their fingers."),SPAN_WARNING("You accidentally trigger [src]!"))
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
		return 1	//end the search!
	return 0


/obj/item/device/assembly/mousetrap/hitby(atom/movable/AM)
	if(!armed)
		return ..()
	visible_message(SPAN_WARNING("[src] is triggered by [AM]."))
	triggered(null)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1


/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	layer = TURF_LAYER+0.2
	to_chat(usr, SPAN_NOTICE("You hide [src]."))
