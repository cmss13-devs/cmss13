/obj/item/storage/briefcase
	name = "brown briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon = 'icons/obj/items/storage/briefcases.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/briefcases_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/briefcases_righthand.dmi',
	)
	icon_state = "briefcase"
	item_state = "briefcase"
	flags_atom = FPRINT|CONDUCT|NO_GAMEMODE_SKIN
	force = 8
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	max_storage_space = 16
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/storage/briefcase/attack(mob/living/M as mob, mob/living/user as mob)
	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - M.getarmor(affecting, ARMOR_MELEE)

	if(affecting == "head" && istype(M, /mob/living/carbon/) && !isxeno(M))
		for(var/mob/O in viewers(user, null))
			if(M != user)
				O.show_message(text(SPAN_DANGER("<B>[M] has been hit over the head with a [name] by [user]!</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[M] hit \himself with a [name] on the head!</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			M.apply_effect(min(drowsy_threshold, 10) , DROWSY)

		M.apply_damage(force, BRUTE, affecting, sharp=0) //log and damage the custom hit
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYPE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by  [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYPE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYPE: [uppertext(damtype)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	else //Regular attack text
		. = ..()

	return

/obj/item/storage/briefcase/stowaway
	name = "suitcase"
	desc = "An old suitcase suited for when you want to travel. This one sure has seen better days."
	icon_state = "suitcase"
	item_state = "suitcase"
	force = 8

/obj/item/storage/briefcase/black
	name = "black briefcase"
	icon_state = "briefcase_b"
	item_state = "briefcase_b"

/obj/item/storage/briefcase/maroon
	name = "maroon briefcase"
	icon_state = "briefcase_c"
	item_state = "briefcase_c"

/obj/item/storage/briefcase/flap
	name = "flap-closure brown briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional. This one is less rigid, made with a flap and softer leather."
	icon_state = "briefcase_d"
	item_state = "briefcase_d"

/obj/item/storage/briefcase/flap/black
	name = "flap-closure black briefcase"
	icon_state = "briefcase_e"
	item_state = "briefcase_e"

/obj/item/storage/briefcase/flap/maroon
	name = "flap-closure maroon briefcase"
	icon_state = "briefcase_f"
	item_state = "briefcase_f"



