/mob/living/carbon/verb/give()
	set category = "IC"
	set name = "Give"
	set src in oview(1)
	if(stat == DEAD || usr.stat == DEAD || client == null)
		return
	if(src == usr)
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		to_chat(usr, SPAN_WARNING("You don't have anything in your right hand to give to [name]."))
		return
	if(usr.hand && usr.l_hand == null)
		to_chat(usr, SPAN_WARNING("You don't have anything in your left hand to give to [name]."))
		return
	if(!ishuman(src) || !ishuman(usr))
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!istype(I) || (I.flags_item & (DELONDROP|NODROP)))
		return
	if(r_hand == null || l_hand == null)
		switch(alert(src,"[usr] wants to give you \a [I]?",,"Yes","No"))
			if("Yes")
				if(!I || !usr || !istype(I))
					return
				if(!Adjacent(usr))
					to_chat(usr, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
					to_chat(src, SPAN_WARNING("[usr] moved too far away."))
					return
				if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
					to_chat(usr, SPAN_WARNING("You need to keep the item in your active hand."))
					to_chat(src, SPAN_WARNING("[usr] seem to have given up on giving [I] to you."))
					return
				if(r_hand != null && l_hand != null)
					to_chat(src, SPAN_WARNING("Your hands are full."))
					to_chat(usr, SPAN_WARNING("[src]'s hands are full."))
					return
				else
					if(usr.drop_held_item())
						if(put_in_hands(I))
							usr.visible_message(SPAN_NOTICE("[usr] hands [I] to [src]."),
							SPAN_NOTICE("You hand [I] to [src]."), null, 4)
			if("No")
				return
	else
		to_chat(usr, SPAN_WARNING("[src]'s hands are full."))
