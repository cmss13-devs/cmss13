/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	var/obj/item/implant/imp = null

/obj/item/implanter/proc/update()


/obj/item/implanter/update()
	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return


/obj/item/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon/human))
		return
	if(isYautja(M))
		return
	if (user && src.imp)
		user.visible_message(SPAN_WARNING("[user] is attemping to implant [M]."), SPAN_NOTICE("You're attemping to implant [M]."))

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50, INTERRUPT_ALL, BUSY_ICON_GENERIC)))
			if(user && M && (get_turf(M) == T1) && src && src.imp)
				if(src.imp.implanted(M, user))
					M.visible_message(SPAN_WARNING("[M] has been implanted by [user]."))

					M.attack_log += text("\[[time_stamp()]\] <font color='orange'> Implanted with [src.name] ([src.imp.name]) by [key_name(user)]</font>")
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] ([src.imp.name]) to implant [key_name(M)]</font>")
					msg_admin_attack("[key_name(user)] implanted [key_name(M)] with [src.name] (INTENT: [uppertext(user.a_intent)]) in [get_area(user)] ([user.loc.x], [user.loc.y], [user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

					src.imp.loc = M
					src.imp.imp_in = M
					src.imp.implanted = 1
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						var/obj/limb/affected = H.get_limb(user.zone_selected)
						affected.implants += src.imp
						imp.part = affected

						M.sec_hud_set_implants()

					src.imp = null
					update()
				else
					to_chat(user, SPAN_NOTICE(" You failed to implant [M]."))

	return



/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/New()
	src.imp = new /obj/item/implant/loyalty( src )
	..()
	update()
	return

/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/New()
	src.imp = new /obj/item/implant/explosive( src )
	..()
	update()
	return

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/New()
	src.imp = new /obj/item/implant/adrenalin(src)
	..()
	update()
	return

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/New()
	imp = new /obj/item/implant/compressed( src )
	..()
	update()
	return

/obj/item/implanter/compressed/update()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/implant/compressed/c = imp
		if (c.scanned)
			to_chat(user, SPAN_DANGER("Something is already scanned inside the implant!"))
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.drop_inv_item_on_ground(A)
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		update()
