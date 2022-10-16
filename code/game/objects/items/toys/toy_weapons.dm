/*
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
*/



/*
 * Toy gun: Why isnt this an /obj/item/weapon/gun?
 */
/obj/item/toy/gun
	name = "cap gun"
	desc = "There are 0 caps left. Looks almost like the real thing! Ages 8 and up. Please recycle in an autolathe when you're out of caps!"
	icon_state = "capgun"
	item_state = "gun"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM

	matter = list("glass" = 10,"metal" = 10)

	attack_verb = list("struck", "pistol whipped", "hit", "bashed")
	var/bullets = 7.0

/obj/item/toy/gun/get_examine_text(mob/user)
	desc = "There are [bullets] caps\s left. Looks almost like the real thing! Ages 8 and up."
	return ..()

/obj/item/toy/gun/attackby(obj/item/toy/gun_ammo/A as obj, mob/user as mob)
	if (istype(A, /obj/item/toy/gun_ammo))
		if (src.bullets >= 7)
			to_chat(user, SPAN_NOTICE(" It's already fully loaded!"))
			return 1
		if (A.amount_left <= 0)
			to_chat(user, SPAN_DANGER("There is no more caps!"))
			return 1
		if (A.amount_left < (7 - bullets))
			src.bullets += A.amount_left
			to_chat(user, SPAN_DANGER("You reload [A.amount_left] caps\s!"))
			A.amount_left = 0
		else
			to_chat(user, SPAN_DANGER("You reload [7 - bullets] caps\s!"))
			A.amount_left -= 7 - bullets
			bullets = 7
		A.update_icon()
		A.desc = "There are [A.amount_left] caps\s left! Make sure to recycle the box in an autolathe when it gets empty."
		return 1

/obj/item/toy/gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || SSticker) && SSticker.mode.name != "monkey")
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message(SPAN_DANGER("*click* *click*"), 2)
		playsound(user, 'sound/weapons/gun_empty.ogg', 15, 1)
		return
	playsound(user, 'sound/weapons/Gunshot.ogg', 15, 1)
	src.bullets--
	for(var/mob/O in viewers(user, null))
		O.show_message(SPAN_DANGER("<B>[user] fires a cap gun at [target]!</B>"), 1, SPAN_DANGER("You hear a gunshot"), 2)

/obj/item/toy/gun_ammo
	name = "ammo-caps"
	desc = "There are 7 caps left! Make sure to recycle the box in an autolathe when it gets empty."
	icon_state = "cap_ammo"
	w_class = SIZE_TINY

	matter = list("metal" = 10,"glass" = 10)

	var/amount_left = 7

	update_icon()
		if(amount_left)
			icon_state = "cap_ammo"
		else
			icon_state = "cap_ammo_e"


/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon_state = "foamcrossbow"
	item_state = "crossbow"
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 5

	examine(mob/user)
		..()
		if (bullets)
			to_chat(user, SPAN_NOTICE(" It is loaded with [bullets] foam darts!"))

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/toy/crossbow_ammo))
			if(bullets <= 4)
				if(user.drop_held_item())
					qdel(I)
					bullets++
					to_chat(user, SPAN_NOTICE(" You load the foam dart into the crossbow."))
			else
				to_chat(usr, SPAN_DANGER("It's already fully loaded."))


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if(!isturf(target.loc) || target == user) return
		if(flag) return

		if (locate (/obj/structure/surface/table, src.loc))
			return
		else if (bullets)
			var/turf/trg = get_turf(target)
			var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
			bullets--
			D.icon_state = "foamdart"
			D.name = "foam dart"
			playsound(user.loc, 'sound/items/syringeproj.ogg', 15, 1)

			for(var/i=0, i<6, i++)
				if (D)
					if(D.loc == trg) break
					step_towards(D,trg)

					for(var/mob/living/M in D.loc)
						if(!istype(M,/mob/living)) continue
						if(M == user) continue
						for(var/mob/O in viewers(world_view_size, D))
							O.show_message(SPAN_DANGER("[M] was hit by the foam dart!"), 1)
						new /obj/item/toy/crossbow_ammo(M.loc)
						qdel(D)
						return

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							new /obj/item/toy/crossbow_ammo(A.loc)
							qdel(D)

				sleep(1)

			spawn(10)
				if(D)
					new /obj/item/toy/crossbow_ammo(D.loc)
					qdel(D)

			return
		else if (bullets == 0)
			user.KnockDown(5)
			for(var/mob/O in viewers(world_view_size, user))
				O.show_message(SPAN_DANGER("[user] realized they were out of ammo and starting scrounging for some!"), 1)


	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

// ******* Check

		if (src.bullets > 0 && M.lying)

			for(var/mob/O in viewers(M, null))
				if(O.client)
					O.show_message(SPAN_DANGER("<B>[user] casually lines up a shot with [M]'s head and pulls the trigger!</B>"), 1, SPAN_DANGER("You hear the sound of foam against skull"), 2)
					O.show_message(SPAN_DANGER("[M] was hit in the head by the foam dart!"), 1)

			playsound(user.loc, 'sound/items/syringeproj.ogg', 15, 1)
			new /obj/item/toy/crossbow_ammo(M.loc)
			src.bullets--
		else if (M.lying && src.bullets == 0)
			for(var/mob/O in viewers(M, null))
				if (O.client)
					O.show_message(SPAN_DANGER("<B>[user] casually lines up a shot with [M]'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!</B>"), 1, SPAN_DANGER("You hear someone fall"), 2)
			user.KnockDown(5)
		return

/obj/item/toy/crossbow_ammo
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "foamdart"
	w_class = SIZE_TINY

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "null"
	anchored = 1
	density = 0


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	var/active = 0.0
	w_class = SIZE_SMALL
	flags_item = NOSHIELD
	attack_verb = list("attacked", "struck", "hit")

/obj/item/toy/sword/attack_self(mob/user)
	..()

	active = !active
	if (active)
		to_chat(user, SPAN_NOTICE(" You extend the plastic blade with a quick flick of your wrist."))
		playsound(user, 'sound/weapons/saberon.ogg', 15, 1)
		icon_state = "swordblue"
		item_state = "swordblue"
		w_class = SIZE_LARGE
	else
		to_chat(user, SPAN_NOTICE(" You push the plastic blade back down into the handle."))
		playsound(user, 'sound/weapons/saberoff.ogg', 15, 1)
		icon_state = "sword0"
		item_state = "sword0"
		w_class = SIZE_SMALL

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "katana"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOSHIELD
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

