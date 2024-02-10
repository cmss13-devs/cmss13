/obj/item/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "handcuff"
	flags_atom = FPRINT|CONDUCT
	throwforce = 0
	w_class = SIZE_MEDIUM

	var/breakouttime = 1 MINUTES
	/// how many deciseconds it takes to cuff someone
	var/cuff_delay = 4 SECONDS
	/// If can be applied to people manually
	var/manual = TRUE

/obj/item/legcuffs/attack(mob/living/carbon/C, mob/user)
	if(!istype(C) || !manual)
		return ..()
	if (!istype(user, /mob/living/carbon/human))
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	if(!C.legcuffed)
		apply_legcuffs(C, user)

/obj/item/legcuffs/proc/apply_legcuffs(mob/living/carbon/target, mob/user)
	playsound(src.loc, 'sound/weapons/handcuffs.ogg', 25, 1, 4)

	if(user.action_busy)
		return FALSE

	if (ishuman(target))
		var/mob/living/carbon/human/H = target

		if (!H.has_limb_for_slot(WEAR_LEGCUFFS))
			to_chat(user, SPAN_DANGER("\The [H] needs two ankles before you can cuff them together!"))
			return FALSE

		H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been legcuffed (attempt) by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to legcuff [key_name(H)]</font>")
		msg_admin_attack("[key_name(user)] attempted to legcuff [key_name(H)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [H]."))
		if(do_after(user, cuff_delay, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, H, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !H.legcuffed && Adjacent(user))
				if(iscarbon(H))
					if(istype(H.buckled, /obj/structure/bed/roller))
						to_chat(user, SPAN_DANGER("You cannot legcuff someone who is buckled onto a roller bed."))
						return FALSE
				if(H.has_limb_for_slot(WEAR_LEGCUFFS))
					user.drop_inv_item_on_ground(src)
					H.equip_to_slot_if_possible(src, WEAR_LEGCUFFS, 1, 0, 1, 1)
					user.count_niche_stat(STATISTICS_NICHE_HANDCUFF)

	else if (ismonkey(target))
		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [target]."))
		if(do_after(user, 30, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !target.legcuffed && Adjacent(user))
				user.drop_inv_item_on_ground(src)
				target.equip_to_slot_if_possible(src, WEAR_LEGCUFFS, 1, 0, 1, 1)
	return TRUE

/obj/item/legcuffs/beartrap
	name = "bear trap"
	throw_speed = SPEED_FAST
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	breakouttime = 20 SECONDS
	var/armed = FALSE
	manual = FALSE

/obj/item/legcuffs/beartrap/apply_legcuffs(mob/living/carbon/target, mob/user)
	return FALSE

/obj/item/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]"))

/obj/item/legcuffs/beartrap/Crossed(atom/movable/AM)
	if(armed)
		if(ismob(AM))
			var/mob/M = AM
			if(!M.buckled)
				if(ishuman(AM))
					if(isturf(src.loc))
						var/mob/living/carbon/H = AM
						if(!H.legcuffed)
							H.legcuffed = src
							forceMove(H)
							H.legcuff_update()
						armed = 0
						icon_state = "beartrap0"
						playsound(loc, 'sound/effects/snap.ogg', 25, 1)
						to_chat(H, SPAN_DANGER("<B>You step on \the [src]!</B>"))
						for(var/mob/O in viewers(H, null))
							if(O == H)
								continue
							O.show_message(SPAN_DANGER("<B>[H] steps on \the [src].</B>"), SHOW_MESSAGE_VISIBLE)
				if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot))
					armed = 0
					var/mob/living/simple_animal/SA = AM
					SA.health -= 20
	..()
