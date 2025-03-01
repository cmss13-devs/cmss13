/obj/item/weapon/chloroform
	name = "cloth"
	desc = "A piece of cloth. It smells funny"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "rag"

	var/uses = 8
	var/knockout_strength = 25

	var/obj/item/clothing/mask/cloth/mask_item

/obj/item/weapon/chloroform/get_examine_text(mob/user)
	. = ..()

	if(skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		. += SPAN_BLUE("It has [uses] use\s left.")

/obj/item/weapon/chloroform/attack(mob/living/M, mob/living/user)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		return . = ..()

	if(!ishuman_strict(M) || !(user.a_intent & INTENT_DISARM) || M == user)
		return . = ..()

	if(M.stat != CONSCIOUS)
		return . = ..()

	if(M.dir != user.dir || M.loc != get_step(user, user.dir))
		to_chat(user, SPAN_WARNING("You must be behind your target!"))
		return

	user.visible_message(SPAN_DANGER("[user] grabs [M] and smothers their face with [src]."), SPAN_DANGER("You cover [M]'s face with [src]."))
	to_chat(M, SPAN_HIGHDANGER("[user] grabs you and smothers [src] onto your face."))

	grab_stun(M, user)

	if(!do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, M, INTERRUPT_OUT_OF_RANGE, BUSY_ICON_HOSTILE))
		remove_stun(M)
		return

	to_chat(M, SPAN_HIGHDANGER("[user] knocks you out!"))
	M.apply_effect(knockout_strength, PARALYZE)

	remove_stun(M)

	uses--

	return (ATTACKBY_HINT_NO_AFTERATTACK|ATTACKBY_HINT_UPDATE_NEXT_MOVE)

/obj/item/weapon/chloroform/proc/grab_stun(mob/living/M, mob/living/user)
	M.anchored = TRUE
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, CHLOROFORM_TRAIT)
	ADD_TRAIT(M, TRAIT_UNDENSE, CHLOROFORM_TRAIT)
	M.able_to_speak = FALSE

	M.drop_inv_item_on_ground(M.wear_mask, force = TRUE)

	mask_item = new(M)
	M.equip_to_slot_or_del(mask_item, WEAR_FACE)

	playsound(get_turf(loc), 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	// neat effect below
	var/target_x = 0
	var/target_y = 0

	switch(M.dir)
		if(NORTH)
			target_y = -24
			M.layer = ABOVE_LYING_MOB_LAYER
		if(SOUTH)
			target_y = 24
		if(EAST)
			target_x = -24
		if(WEST)
			target_x = 24


	animate(M, pixel_x = target_x, pixel_y = target_y, time = 0.2 SECONDS, easing = QUAD_EASING)

/obj/item/weapon/chloroform/proc/remove_stun(mob/living/M)
	animate(M, pixel_x = 0, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
	M.anchored = FALSE
	M.able_to_speak = TRUE
	M.layer = MOB_LAYER
	REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, CHLOROFORM_TRAIT)
	REMOVE_TRAIT(M, TRAIT_UNDENSE, CHLOROFORM_TRAIT)

	QDEL_NULL(mask_item)

/obj/item/clothing/mask/cloth
	name = "cloth"
	icon_state = "sterile2"
	item_state_slots = list(
		WEAR_FACE = "sterile"
	)

	flags_inventory = CANTSTRIP
	flags_item = NODROP|DELONDROP
