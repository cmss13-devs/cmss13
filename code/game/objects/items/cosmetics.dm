/obj/item/facepaint
	gender = PLURAL
	name = "facepaint"
	desc = "Paint, for your face. Who woulda thought?. Wipe it off your face with some paper if you need to."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "camo"
	var/colour = "green"
	w_class = SIZE_TINY
	var/uses = 10

/obj/item/facepaint/green
	name = "green facepaint"
	desc = "Paint, for your face. This green facepaint is perfect for drawing menacing stripes across your face. Wipe it off your face with some paper if you need to."
	colour = "green"
	icon_state = "green_cammo"

/obj/item/facepaint/brown
	name = "brown facepaint"
	desc = "Paint, for your face. This brown facepaint is perfect for drawing menacing stripes across your face. Wipe it off your face with some paper if you need to."
	colour = "brown"
	icon_state = "brown_cammo"

/obj/item/facepaint/black
	name = "black facepaint"
	desc = "Paint, for your face. This black facepaint is perfect for your very own eye black. Wipe it off your face with some paper if you need to."
	colour = "black"
	icon_state = "black_cammo"

/obj/item/facepaint/sniper
	name = "fullbody paint"
	desc = "Paint, for your face. This facepaint is meant to help you blend in with the foilage, but studies on this are at best inconclusive. Wipe it off your face with some paper if you need to."
	colour = "full"
	icon_state = "full_cammo"

/obj/item/facepaint/skull
	name = "skull paint"
	desc = "Paint, for your face. Make your enemies need a change of underwear from the sheer terror a goddamn skull on your face will bring to them. WARNING: DOES NOT MIX WELL WITH BEARDS."
	colour = "skull"
	icon_state = "skull_cammo"

/obj/item/facepaint/attack(mob/M as mob, mob/user as mob)
	if(!ismob(M)) return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, SPAN_WARNING("You need to wipe the old paint off with paper first!"))
			return
		if(H == user)
			paint_face(H, user)
			return 1
		else
			to_chat(user, SPAN_NOTICE("You attempt to apply [src] on [H]..."))
			to_chat(H, SPAN_NOTICE("[user] is trying to apply [src] on your face..."))
			if(alert(H,"Will you allow [user] to paint your face?",,"Sure","No") == "Sure")
				if( user && loc == user && (user in range(1,H)) ) //Have to be close and hold the thing.
					paint_face(H, user)
					return 1

	to_chat(user, SPAN_WARNING("Foiled!"))


/obj/item/facepaint/proc/paint_face(var/mob/living/carbon/human/H, var/mob/user)
	if(!H || !user) return //In case they're passed as null.
	user.visible_message(SPAN_NOTICE("[user] carefully applies [src] on [H]'s face."), \
						 SPAN_NOTICE("You apply [src]."))
	H.lip_style = colour
	H.update_body()
	uses--
	if(!uses)
		user.temp_drop_inv_item(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		qdel(src)

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()