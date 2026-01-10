/obj/item/facepaint
	gender = PLURAL
	name = "facepaint"
	desc = "Paint, for your face. Wipe it off your face with some paper if you need to. This one is a deep, forest green."
	icon = 'icons/obj/items/paint.dmi'
	icon_state = "camo"
	var/paint_type = "green"
	w_class = SIZE_TINY
	var/uses = 10
	/// for lipstick
	var/open = TRUE
	/// Last world.time someone attempted to apply the makeup, for anti-spam.
	var/last_apply_time
	/// How long the anti-spam cooldown on applying the makeup is.
	var/apply_delay_length = 5 SECONDS
	/// the cooldown for applying makeup.
	COOLDOWN_DECLARE(apply_delay)

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
	desc = "Paint, for your face. This facepaint is meant to help you blend in with the foliage, but studies on this are at best inconclusive. Wipe it off your face with some paper if you need to."
	paint_type = "full_camo"
	icon_state = "full_camo"

/obj/item/facepaint/sniper/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	if(flags_atom & MAP_COLOR_INDEX)
		return
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			paint_type = "full_camo_jungle"
			icon_state = "full_camo_jungle"
		if("classic")
			paint_type = "full_camo"
			icon_state = "full_camo"
		if("desert")
			paint_type = "full_camo_desert"
			icon_state = "full_camo_desert"
		if("snow")
			paint_type = "full_camo_snow"
			icon_state = "full_camo_snow"
		if("urban")
			paint_type = "full_camo_urban"
			icon_state = "full_camo_urban"

/obj/item/facepaint/sniper/Initialize()
	. = ..()
	select_gamemode_skin(type)

/obj/item/facepaint/sniper/snow
	name = "fullbody paint snow"
	paint_type = "full_camo_snow"
	icon_state = "full_camo_snow"

/obj/item/facepaint/sniper/desert
	name = "fullbody paint desert"
	paint_type = "full_camo_desert"
	icon_state = "full_camo_desert"

/obj/item/facepaint/sniper/jungle
	name = "fullbody paint jungle"
	paint_type = "full_camo_jungle"
	icon_state = "full_camo_jungle"

/obj/item/facepaint/sniper/urban
	name = "fullbody paint urban"
	paint_type = "full_camo_urban"
	icon_state = "full_camo_urban"

/obj/item/facepaint/skull
	name = "skull paint"
	desc = "Paint, for your face. Make your enemies need a change of underwear from the sheer terror a goddamn skull on your face will bring to them. WARNING: DOES NOT MIX WELL WITH BEARDS."
	paint_type = "skull_camo"
	icon_state = "skull_camo"

/obj/item/facepaint/clown
	name = "clown makeup paint"
	desc = "Paint, for your face. Used for entertainers and alike, or maybe you just feel that way."
	paint_type = "clown_camo"
	icon_state = "clown_camo"

/obj/item/facepaint/clown/alt

	paint_type = "clown_camo_alt"
	icon_state = "clown_camo_alt"

/obj/item/facepaint/sunscreen_stick
	name= "\improper USCM issue sunscreen"
	desc = "A stick of SPF 50 sunscreen, issued to you by the good brass of the Corps. Whereas the previously issued sunscreen was toxic upon ingestion, this batch improves upon that by only containing excessive amounts of cadmium."
	paint_type = "sunscreen_stick"
	icon_state = "sunscreen_stick"

/obj/item/facepaint/attack(mob/target, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(!ismob(target))
		return FALSE

	if(!COOLDOWN_FINISHED(src, apply_delay)) // Stops players from spamming each other with popups.
		to_chat(user, SPAN_WARNING("You just attempted to apply some makeup, slow down!"))
		return FALSE

	COOLDOWN_START(src, apply_delay, apply_delay_length)

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/mob/living/carbon/human/human_user = user
		human_user.animation_attack_on(human_target)
		if(!open)
			to_chat(user, SPAN_WARNING("The lid is on!"))
			return FALSE

		if(human_target.lip_style) //if they already have lipstick on
			to_chat(user, SPAN_WARNING("You need to wipe the old makeup off with paper first!"))
			return

		if(human_target == user)
			paint_face(human_target, user)
			return TRUE

		else
			to_chat(user, SPAN_NOTICE("You attempt to apply [src] on [human_target]..."))
			to_chat(human_target, SPAN_NOTICE("[user] is trying to apply [src] on your face..."))
			if(alert(human_target,"Will you allow [user] to apply makeup to your face?",,"Sure","No") == "Sure")
				if( user && loc == user && (user in range(1,human_target)) ) //Have to be close and hold the thing.
					paint_face(human_target, user)
					return TRUE

	to_chat(user, SPAN_WARNING("Foiled!"))


/obj/item/facepaint/proc/paint_face(mob/living/carbon/human/H, mob/user)
	if(!H || !user)
		return //In case they're passed as null.
	user.visible_message(SPAN_NOTICE("[user] carefully applies [src] on [H]'s face."),
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
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paint_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paint_righthand.dmi'
	)
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
	paint_type = "purp_lipstick"
	icon_state_open = "lipstick_purple"

/obj/item/facepaint/lipstick/maroon
	name = "maroon lipstick"
	paint_type = "marn_lipstick"
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

/obj/item/k9_name_changer
	name = "K9 name implanter"
	desc = "Syncs the implanted W-Y Serial Chip to the unit's preferred name."
	icon = 'icons/obj/items/economy.dmi'
	icon_state = "efundcard"
	w_class = SIZE_TINY

/obj/item/k9_name_changer/attack_self(mob/user)
	. = ..()
	var/newname = capitalize(tgui_input_text(user, "What do you wish to be named", "Name:", encode = FALSE))
	if(!newname)
		return

	var/verify = tgui_input_list(user, "Are you SURE you wish to be named: [newname]?", "Confirm", list("Yes", "No"))
	if(verify != "Yes")
		return

	user.change_real_name(user, newname)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/altered_human = user
		var/obj/item/card/id/ID = altered_human.get_idcard()
		if(ID)
			ID.name = "[altered_human.real_name]'s [ID.id_type]"
			ID.registered_name = "[altered_human.real_name]"
			if(ID.assignment)
				ID.name += " ([ID.assignment])"

	var/genderswap = tgui_input_list(user, "Which Gender?", "Gender", list("Male", "Female"))
	if(!genderswap)
		return
	user.gender = lowertext(genderswap)
	qdel(src)
