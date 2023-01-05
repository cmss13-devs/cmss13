	/*##################################################################
	Much improved now. Leaving the overall item procs here since they're
	easier to find that way. Theoretically any item may be twohanded,
	but only these items and guns benefit from it. ~N
	####################################################################*/

/obj/item/weapon/melee/twohanded
	var/force_wielded 	= 0
	var/wieldsound 		= null
	var/unwieldsound 	= null
	force = MELEE_FORCE_NORMAL
	force_wielded = MELEE_FORCE_VERY_STRONG
	flags_item = TWOHANDED

/obj/item/weapon/melee/twohanded/update_icon()
	return

/obj/item/weapon/melee/twohanded/mob_can_equip(mob/user)
	unwield(user)
	return ..()

/obj/item/weapon/melee/twohanded/dropped(mob/user)
	..()
	unwield(user)

/obj/item/proc/wield(var/mob/user)
	if( !(flags_item & TWOHANDED) || flags_item & WIELDED ) return

	var/obj/item/I = user.get_inactive_hand()
	if(I)
		user.drop_inv_item_on_ground(I)

	if(ishuman(user))
		var/check_hand = user.r_hand == src ? "l_hand" : "r_hand"
		var/mob/living/carbon/human/wielder = user
		var/obj/limb/hand = wielder.get_limb(check_hand)
		if( !istype(hand) || !hand.is_usable() )
			to_chat(user, SPAN_WARNING("Your other hand can't hold [src]!"))
			return

	flags_item 	   ^= WIELDED
	name 	   += " (Wielded)"
	item_state += "_w"
	place_offhand(user,initial(name))
	return 1

/obj/item/proc/unwield(mob/user)
	if( (flags_item|TWOHANDED|WIELDED) != flags_item)
		return FALSE//Have to be actually a twohander and wielded.
	flags_item ^= WIELDED
	SEND_SIGNAL(src, COMSIG_ITEM_UNWIELD, user)
	name 	    = copytext(name,1,-10)
	item_state  = copytext(item_state,1,-2)
	remove_offhand(user)
	return TRUE

/obj/item/proc/place_offhand(var/mob/user,item_name)
	to_chat(user, SPAN_NOTICE("You grab [item_name] with both hands."))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/melee/twohanded/offhand/offhand = new /obj/item/weapon/melee/twohanded/offhand(user)
	offhand.name = "[item_name] - offhand"
	offhand.desc = "Your second grip on the [item_name]."
	offhand.flags_item |= WIELDED
	user.put_in_inactive_hand(offhand)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/proc/remove_offhand(var/mob/user)
	to_chat(user, SPAN_NOTICE("You are now carrying [name] with one hand."))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/melee/twohanded/offhand/offhand = user.get_inactive_hand()
	if(istype(offhand)) offhand.unwield(user)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/weapon/melee/twohanded/wield(mob/user)
	. = ..()
	if(!.) return
	user.recalculate_move_delay = TRUE
	if(wieldsound) playsound(user, wieldsound, 15, 1)
	force 		= force_wielded

/obj/item/weapon/melee/twohanded/unwield(mob/user)
	. = ..()
	if(!.) return
	user.recalculate_move_delay = TRUE
	if(unwieldsound) playsound(user, unwieldsound, 15, 1)
	force 	 	= initial(force)

/obj/item/weapon/melee/twohanded/attack_self(mob/user)
	..()
	if(ismonkey(user))
		to_chat(user, SPAN_WARNING("It's too heavy for you to wield fully!"))
		return

	if(flags_item & WIELDED) unwield(user)
	else 				wield(user)

///////////OFFHAND///////////////
/obj/item/weapon/melee/twohanded/offhand
	w_class = SIZE_HUGE
	icon_state = "offhand"
	name = "offhand"
	flags_item = DELONDROP|TWOHANDED|WIELDED

/obj/item/weapon/melee/twohanded/offhand/unwield(var/mob/user)
	if(flags_item & WIELDED)
		flags_item &= ~WIELDED
		user.temp_drop_inv_item(src)
		qdel(src)

/obj/item/weapon/melee/twohanded/offhand/wield()
	qdel(src) //This shouldn't even happen.

/obj/item/weapon/melee/twohanded/offhand/dropped(mob/user)
	..()
	//This hand should be holding the main weapon. If everything worked correctly, it should not be wielded.
	//If it is, looks like we got our hand torn off or something.
	if(!QDESTROYING(src))
		var/obj/item/main_hand = user.get_active_hand()
		if(main_hand) main_hand.unwield(user)

/*
 * Fireaxe
 */
/obj/item/weapon/melee/twohanded/fireaxe
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon_state = "fireaxe"
	item_state = "fireaxe"
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = FPRINT|CONDUCT
	flags_item = TWOHANDED
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")

/obj/item/weapon/melee/twohanded/fireaxe/wield(mob/user)
	. = ..()
	if(!.) return
	pry_capable = IS_PRY_CAPABLE_SIMPLE

/obj/item/weapon/melee/twohanded/fireaxe/unwield(mob/user)
	. = ..()
	if(!.) return
	pry_capable = 0

/obj/item/weapon/melee/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && (flags_item & WIELDED) && istype(A,/obj/structure/grille)) //destroys grilles in one hit
		qdel(A)

/obj/item/weapon/melee/twohanded/sledgehammer
	name = "sledgehammer"
	desc = "a large block of metal on the end of a pole. Smashing!"
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	sharp = null
	edge = 0
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = FPRINT|CONDUCT
	flags_item = TWOHANDED
	attack_verb = list("smashed", "beaten", "slammed", "struck", "smashed", "battered", "cracked")

//The following is copypasta and not the sledge being a child of the fireaxe due to the fire axe being able to crowbar airlocks
/obj/item/weapon/melee/twohanded/sledgehammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && (flags_item & WIELDED) && istype(A,/obj/structure/grille)) //destroys grilles in one hit
		qdel(A)

/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/weapon/melee/twohanded/dualsaber
	name = "double-bladed energy sword"
	desc = "Handle with care."
	icon_state = "dualsaber"
	item_state = "dualsaber"
	force = 3
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	force_wielded = 75
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	flags_atom = FPRINT|NOBLOODY
	flags_item = NOSHIELD|TWOHANDED

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1

/obj/item/weapon/melee/twohanded/dualsaber/attack(target as mob, mob/living/user as mob)
	..()
	if((flags_item & WIELDED) && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.setDir(i)
				sleep(1)

/obj/item/weapon/melee/twohanded/dualsaber/IsShield()
	if(flags_item & WIELDED) return 1

/obj/item/weapon/melee/twohanded/dualsaber/wield(mob/user)
	. = ..()
	if(!.) return
	icon_state += "_w"

/obj/item/weapon/melee/twohanded/dualsaber/unwield(mob/user)
	. = ..()
	if(!.) return
	icon_state 	= copytext(icon_state,1,-2)

/obj/item/weapon/melee/twohanded/spear
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	icon_state = "spearglass"
	item_state = "spearglass"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	throwforce = 35
	throw_speed = SPEED_VERY_FAST
	edge = 1
	sharp = IS_SHARP_ITEM_SIMPLE
	flags_item = NOSHIELD|TWOHANDED
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "stabbed", "jabbed", "torn", "gored")

/obj/item/weapon/melee/twohanded/lungemine
	name = "lunge mine"
	icon_state = "lungemine"
	item_state = "lungemine"
	desc = "A crude but intimidatingly bulky shaped explosive charge, fixed to the end of a pole. To use it, one must grasp it firmly in both hands, and thrust the prongs of the shaped charge into the target. That the resulting explosion occurs directly in front of the user's face was not an apparent concern of the designer. A true hero's weapon."
	force = MELEE_FORCE_WEAK
	force_wielded = 1
	attack_verb = list("whacked")
	hitsound = "swing_hit"

	var/detonating = FALSE
	var/wielded_attack_verb = list("charged")
	var/wielded_hitsound = null
	var/unwielded_attack_verb = list("whacked")
	var/unwielded_hitsound = "swing_hit"

/obj/item/weapon/melee/twohanded/lungemine/wield(mob/user)
	. = ..()
	if(!.) return
	attack_verb = wielded_attack_verb
	hitsound = wielded_hitsound

/obj/item/weapon/melee/twohanded/lungemine/unwield(mob/user)
	. = ..()
	if(!.) return
	attack_verb = unwielded_attack_verb
	hitsound = unwielded_hitsound

/obj/item/weapon/melee/twohanded/lungemine/attack(mob/living/M, mob/living/user)
	. = ..()
	detonate_check(M, user)

/obj/item/weapon/melee/twohanded/lungemine/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		detonate_check(target, user)

/obj/item/weapon/melee/twohanded/lungemine/proc/detonate_check(atom/target, mob/user)
	if(detonating) //don't detonate twice
		return

	if(!(flags_item & WIELDED)) //must be wielded to detonate
		return

	if(!istype(target))
		return

	if(!target.density && !istype(target, /mob))
		return

	if(target == user)
		return

	detonating = TRUE
	playsound(user, 'sound/items/Wirecutter.ogg', 50, 1)

	sleep(3)

	var/turf/epicenter = get_turf(target)
	target.ex_act(400, null, src, user, 100)
	cell_explosion(epicenter, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), user))
	qdel(src)


/obj/item/weapon/melee/twohanded/breacher
	name = "\improper B5 Breaching Hammer"
	desc = "This 100-pound monstrosity of a sledgehammer is made of solid tungsten carbide, and packs enough force in its swing to take down walls with ease. It can punch through steel and concrete, hit like a truck, and is utterly unusable by anyone who isn't superhuman."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "breacher"
	item_state = "breacher"
	force = MELEE_FORCE_NORMAL
	force_wielded = MELEE_FORCE_VERY_STRONG
	w_class = SIZE_LARGE
	flags_item = TWOHANDED
	flags_equip_slot = SLOT_BACK

	attack_verb = list("pulverized", "smashed", "thwacked", "crushed", "hammered", "wrecked")

/obj/item/weapon/melee/twohanded/breacher/pickup(mob/user)
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("You barely manage to lift \the [src] above your knees. This thing will probably be useless to you."))
		return
	..()

/obj/item/weapon/melee/twohanded/breacher/attack(target as mob, mob/living/user as mob)
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("\The [src] is too heavy for you to use as a weapon!"))
		return
	..()
