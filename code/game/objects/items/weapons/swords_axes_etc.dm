/* Weapons
 * Contains:
 *		Banhammer
 *		Classic Baton
 *		Energy Shield
 */

/*
 * Banhammer
 */
/obj/item/weapon/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>")
	to_chat(user, "<font color='red'> You have <b>BANNED</b> [M]</font>")


/*
 * Classic Baton
 */
/obj/item/weapon/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags_equip_slot = SLOT_WAIST
	force = 10

/obj/item/weapon/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("You club yourself over the head."))
		user.KnockDown(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, "head")
		else
			user.take_limb_damage(2*force)
		return
/*this is already called in ..()
	src.add_fingerprint(user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")
*/

	if(!..()) return
	//playsound(src.loc, "swing_hit", 25, 1, -1)
	if (M.stuttering < 8 && (!(HULK in M.mutations))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
		M.stuttering = 8
	for(var/mob/O in viewers(M))
		if (O.client)	O.show_message(SPAN_DANGER("<B>[M] has been beaten with \the [src] by [user]!</B>"), 1, SPAN_DANGER("You hear someone fall"), 2)

//Telescopic baton
/obj/item/weapon/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	force = 3
	var/on = 0


/obj/item/weapon/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(SPAN_DANGER("With a flick of their wrist, [user] extends their telescopic baton."),\
		SPAN_DANGER("You extend the baton."),\
		"You hear an ominous click.")
		icon_state = "telebaton_1"
		item_state = "telebaton_1"
		w_class = SIZE_MEDIUM
		force = 40
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message(SPAN_NOTICE("[user] collapses their telescopic baton."),\
		SPAN_NOTICE("You collapse the baton."),\
		"You hear a click.")
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
		w_class = SIZE_SMALL
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	playsound(src.loc, 'sound/weapons/gun_empty.ogg', 15, 1)
	add_fingerprint(user)

	if(blood_overlay && blood_DNA && (blood_DNA.len >= 1))
		overlays.Cut()
		add_blood(blood_DNA)
	return

/obj/item/weapon/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		if ((CLUMSY in user.mutations) && prob(50))
			to_chat(user, SPAN_DANGER("You club yourself over the head."))
			user.KnockDown(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, "head")
			else
				user.take_limb_damage(2*force)
			return
		if(..())
			//playsound(src.loc, "swing_hit", 25, 1, 6)
			return
	else
		return ..()



/*
 * Energy Shield
 */
/obj/item/weapon/shield/energy/IsShield()
	if(active)
		return 1
	else
		return 0

/obj/item/weapon/shield/energy/attack_self(mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("You beat yourself in the head with [src]."))
		user.take_limb_damage(5)
	active = !active
	if (active)
		force = 10
		icon_state = "eshield[active]"
		w_class = SIZE_LARGE
		playsound(user, 'sound/weapons/saberon.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE(" [src] is now active."))

	else
		force = 3
		icon_state = "eshield[active]"
		w_class = SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE(" [src] can now be concealed."))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)
	return
