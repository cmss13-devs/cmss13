/obj/item/facepaint
	gender = PLURAL
	name = "facepaint"
	desc = "Paint, for your face. Who woulda thought?. Wipe it off your face with some paper if you need to."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "camo"
	var/paint_type = "green"
	w_class = SIZE_TINY
	var/uses = 10
	var/open = TRUE //for lipstick

//FACEPAINT
/obj/item/facepaint/green
	name = "green facepaint"
	desc = "Paint, for your face. This green facepaint is perfect for drawing menacing stripes across your face. Wipe it off your face with some paper if you need to."
	paint_type = "green_camo"
	icon_state = "green_camo"

/obj/item/facepaint/brown
	name = "brown facepaint"
	desc = "Paint, for your face. This brown facepaint is perfect for drawing menacing stripes across your face. Wipe it off your face with some paper if you need to."
	paint_type = "brown_camo"
	icon_state = "brown_camo"

/obj/item/facepaint/black
	name = "black facepaint"
	desc = "Paint, for your face. This black facepaint is perfect for your very own eye black. Wipe it off your face with some paper if you need to."
	paint_type = "black_camo"
	icon_state = "black_camo"

/obj/item/facepaint/sniper
	name = "fullbody paint"
	desc = "Paint, for your face. This facepaint is meant to help you blend in with the foilage, but studies on this are at best inconclusive. Wipe it off your face with some paper if you need to."
	paint_type = "full_camo"
	icon_state = "full_camo"

/obj/item/facepaint/skull
	name = "skull paint"
	desc = "Paint, for your face. Make your enemies need a change of underwear from the sheer terror a goddamn skull on your face will bring to them. WARNING: DOES NOT MIX WELL WITH BEARDS."
	paint_type = "skull_camo"
	icon_state = "skull_camo"

/obj/item/facepaint/attack(mob/M, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(!ismob(M))
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/mob/living/carbon/human/Huser = user
		Huser.animation_attack_on(H)
		if(!open)
			to_chat(user, SPAN_WARNING("The lid is on!"))
			return FALSE

		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, SPAN_WARNING("You need to wipe the old makeup off with paper first!"))
			return

		if(H == user)
			paint_face(H, user)
			return TRUE

		else
			to_chat(user, SPAN_NOTICE("You attempt to apply [src] on [H]..."))
			to_chat(H, SPAN_NOTICE("[user] is trying to apply [src] on your face..."))
			if(alert(H,"Will you allow [user] to apply makeup to your face?",,"Sure","No") == "Sure")
				if( user && loc == user && (user in range(1,H)) ) //Have to be close and hold the thing.
					paint_face(H, user)
					return TRUE

	to_chat(user, SPAN_WARNING("Foiled!"))


/obj/item/facepaint/proc/paint_face(var/mob/living/carbon/human/H, var/mob/user)
	if(!H || !user)
		return //In case they're passed as null.
	user.visible_message(SPAN_NOTICE("[user] carefully applies [src] on [H]'s face."), \
						 SPAN_NOTICE("You apply [src]."))
	H.lip_style = paint_type
	H.update_body()
	uses--
	if(!uses)
		user.temp_drop_inv_item(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		qdel(src)

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()

//LIPSTICK
/obj/item/facepaint/lipstick
	name = "red lipstick"
	desc = "Lipstick. A stick, for your lips."
	paint_type = "red_lipstick"
	icon_state = "lipstick"
	item_state = "lipstick"
	var/icon_state_open = "lipstick_red"
	var/icon_state_closed = "lipstick"
	open = FALSE

/obj/item/facepaint/lipstick/attack_self(mob/user)
	. = ..()
	if(open)
		open = FALSE
		to_chat(user, SPAN_NOTICE("You put the lipstick's lid back on."))
		icon_state = icon_state_closed
	else
		open = TRUE
		to_chat(user, SPAN_NOTICE("You take the lid off."))
		icon_state = icon_state_open
		playsound(src, "pillbottle", 25, TRUE)

/obj/item/facepaint/lipstick/purple
	name = "purple lipstick"
	paint_type = "purp_lipstick" //not 'purple' because dream maker farts if the name is too long
	icon_state_open = "lipstick_purple"

/obj/item/facepaint/lipstick/maroon
	name = "maroon lipstick"
	paint_type = "marn_lipstick" //not 'maroon' because dream maker farts if the name is too long
	icon_state_open = "lipstick_maroon"

/obj/item/facepaint/lipstick/jade
	name = "jade lipstick"
	desc = "Lipstick. A stick, for your lips. This one looks sharp for some reason. Why would something you put on your mouth be sharp??"
	paint_type = "jade_lipstick"
	icon_state_open = "lipstick_jade"

/obj/item/facepaint/lipstick/jade/attack_self(mob/user) //this is a reference :)
	. = ..()
	if(open)
		sharp = IS_SHARP_ITEM_ACCURATE
		edge = TRUE
		force = MELEE_FORCE_NORMAL
	else
		sharp = FALSE
		edge = FALSE
		force = 0
