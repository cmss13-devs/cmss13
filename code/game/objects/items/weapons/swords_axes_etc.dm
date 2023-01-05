/* Weapons
 * Contains:
 *		Banhammer
 *		Classic Baton
 *		Energy Shield
 */

/*
 * Banhammer
 */
/obj/item/weapon/melee/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>")
	to_chat(user, "<font color='red'> You have <b>BANNED</b> [M]</font>")


/*
 * Classic Baton
 */
/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_WEAK

/obj/item/weapon/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if(!..())
		return

	if(M.stuttering < 8)
		M.stuttering = 8

	user.visible_message(SPAN_DANGER("<B>[M] has been beaten with \the [src] by [user]!</B>"), SPAN_DANGER("You hear someone fall"))

//Telescopic baton
/obj/item/weapon/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded. It will knock down humans when not on harm intent."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	force = MELEE_FORCE_WEAK
	var/on = 0
	var/stunforce = 60

/obj/item/weapon/melee/telebaton/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target) || !on)
		return ..()
	if(user.a_intent == INTENT_HARM || isSpeciesYautja(target) || user == target)
		return ..()
	else
		stun(target, user)

/obj/item/weapon/melee/telebaton/attack_self(mob/user as mob)
	..()

	on = !on
	if(on)
		user.visible_message(SPAN_DANGER("With a flick of the wrist, [user] extends \his [src]."),\
		SPAN_DANGER("You extend \the [src]."),\
		"You hear an ominous click.")
		icon_state = "telebaton_1"
		item_state = "telebaton_1"
		w_class = SIZE_MEDIUM
		force = MELEE_FORCE_VERY_STRONG
		attack_verb = list("smacked", "struck", "slapped", "beat")
	else
		user.visible_message(SPAN_NOTICE("Using a smooth, practiced movement, [user] collapses \his [src]."),\
		SPAN_NOTICE("You collapse \the [src]."),\
		"You hear a click.")
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
		w_class = SIZE_SMALL
		force = MELEE_FORCE_WEAK//not so robust now
		attack_verb = list("hit", "punched")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	playsound(user, 'sound/weapons/gun_empty.ogg', 25, sound_range = 5)
	add_fingerprint(user)

	if(blood_overlay && blood_color)
		overlays.Cut()
		add_blood(blood_color)
	return

/obj/item/weapon/melee/telebaton/proc/stun(mob/living/carbon/human/target, mob/living/user)
	if(target.check_shields(src, 0, "[user]'s [name]"))
		return FALSE
	// Visuals and sound
	playsound(target, 'sound/weapons/baton.ogg', 50, TRUE, 7)
	user.animation_attack_on(target)
	user.flick_attack_overlay(target, "punch")
	log_interact(user, target, "[key_name(user)] stunned [key_name(target)] with \the [src]")
	// Hit 'em
	var/target_zone = check_zone(user.zone_selected)
	target.apply_stamina_damage(stunforce, target_zone, ARMOR_MELEE)
	if(target.stamina.current_stamina <= 0)
		user.visible_message(SPAN_DANGER("[user] knocks down [target] with \the [src]!"),\
							SPAN_WARNING("You knock down [target] with \the [src]!"))
	else
		user.visible_message(SPAN_DANGER("[user] thwacks [target] with \the [src]!"),\
							SPAN_WARNING("You beat [target] with \the [src]!"))
	return TRUE

/*
 * Energy Shield
 */
/obj/item/weapon/shield/energy/IsShield()
	return active

/obj/item/weapon/shield/energy/attack_self(mob/living/user)
	..()

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
