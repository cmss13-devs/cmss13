/obj/item/restraint/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "handcuff"
	flags_atom = FPRINT|CONDUCT
	throwforce = 0
	w_class = SIZE_MEDIUM

	target_zone = SLOT_LEGS

/obj/item/restraint/proc/apply_legcuffs(mob/living/carbon/target, mob/user)
	playsound(loc, 'sound/weapons/handcuffs.ogg', 25, 1, 4)

	if(user.action_busy)
		return FALSE

	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target

		if (!human_target.has_limb_for_slot(WEAR_LEGCUFFS))
			to_chat(user, SPAN_DANGER("\The [human_target] needs two ankles before you can cuff them together!"))
			return FALSE

		human_target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been legcuffed (attempt) by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to legcuff [key_name(human_target)]</font>")
		msg_admin_attack("[key_name(user)] attempted to legcuff [key_name(human_target)] in [get_area(src)] ([loc.x],[loc.y],[loc.z]).", loc.x, loc.y, loc.z)

		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [human_target]."))
		if(do_after(user, cuff_delay, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, human_target, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !human_target.legcuffed && Adjacent(user))
				if(iscarbon(human_target))
					if(istype(human_target.buckled, /obj/structure/bed/roller))
						to_chat(user, SPAN_DANGER("You cannot legcuff someone who is buckled onto a roller bed."))
						return FALSE
				if(human_target.has_limb_for_slot(WEAR_LEGCUFFS))
					user.drop_inv_item_on_ground(src)
					human_target.equip_to_slot_if_possible(src, WEAR_LEGCUFFS, 1, 0, 1, 1)
					user.count_niche_stat(STATISTICS_NICHE_HANDCUFF)

	else if (ismonkey(target))
		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [target]."))
		if(do_after(user, 30, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !target.legcuffed && Adjacent(user))
				user.drop_inv_item_on_ground(src)
				target.equip_to_slot_if_possible(src, WEAR_LEGCUFFS, 1, 0, 1, 1)
	return TRUE

/obj/item/restraint/legcuffs/beartrap
	name = "bear trap"
	throw_speed = SPEED_FAST
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	breakouttime = 20 SECONDS
	var/armed = FALSE
	manual = FALSE

/obj/item/restraint/legcuffs/beartrap/apply_legcuffs(mob/living/carbon/target, mob/user)
	return FALSE

/obj/item/restraint/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]"))

/obj/item/restraint/legcuffs/beartrap/Crossed(atom/movable/crossed_by)
	var/mob/mob_crossed_by = crossed_by
	var/mob/living/simple_animal/animal_crossed_by = crossed_by
	var/mob/living/carbon/human/human_crossed_by = crossed_by
	if(armed && ismob(mob_crossed_by) && !mob_crossed_by.buckled)
		if(ishuman(human_crossed_by) && isturf(src.loc))
			if(!human_crossed_by.legcuffed)
				human_crossed_by.legcuffed = src
				forceMove(human_crossed_by)
				human_crossed_by.legcuff_update()
			armed = 0
			icon_state = "beartrap0"
			playsound(loc, 'sound/effects/snap.ogg', 25, 1)
			to_chat(human_crossed_by, SPAN_DANGER("<B>You step on \the [src]!</B>"))
			for(var/mob/observer in viewers(human_crossed_by, null))
				if(observer == human_crossed_by)
					continue
				observer.show_message(SPAN_DANGER("<B>[human_crossed_by] steps on \the [src].</B>"), SHOW_MESSAGE_VISIBLE)
		if(isanimal(animal_crossed_by) && !istype(animal_crossed_by, /mob/living/simple_animal/parrot))
			armed = 0
			animal_crossed_by.health -= 20
	..()
