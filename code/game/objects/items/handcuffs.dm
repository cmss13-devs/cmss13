/obj/item/restraint
	icon = 'icons/obj/items/security.dmi'
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/tools.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/security_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/security_righthand.dmi'
	)
	/// SLOT_HANDS or SLOT_LEGS, for handcuffs or legcuffs
	var/target_zone = SLOT_HANDS
	/// How long to break out
	var/breakouttime = 1 MINUTES
	/// determines if handcuffs will be deleted on removal
	var/single_use = 0
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	/// how many deciseconds it takes to cuff someone
	var/cuff_delay = 4 SECONDS
	/// If can be applied to people manually
	var/manual = TRUE

/obj/item/restraint/attack(mob/living/carbon/attacked_carbon, mob/user)
	if(!istype(attacked_carbon) || !manual)
		return ..()
	if (!ishuman(user))
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	switch(target_zone)
		if(SLOT_HANDS)
			if(!attacked_carbon.handcuffed)
				place_handcuffs(attacked_carbon, user)
		if(SLOT_LEGS)
			if(!attacked_carbon.legcuffed)
				apply_legcuffs(attacked_carbon, user)
	return ATTACKBY_HINT_UPDATE_NEXT_MOVE

/obj/item/restraint/proc/place_handcuffs(mob/living/carbon/target, mob/user)
	playsound(src.loc, cuff_sound, 25, 1, 4)

	if(user.action_busy)
		return

	if(ishuman(target))
		var/mob/living/carbon/human/human_mob = target

		if(!human_mob.has_limb_for_slot(WEAR_HANDCUFFS))
			to_chat(user, SPAN_DANGER("\The [human_mob] needs at least two wrists before you can cuff them together!"))
			return

		human_mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [key_name(human_mob)]</font>")
		msg_admin_attack("[key_name(user)] attempted to handcuff [key_name(human_mob)] in [get_area(src)] ([loc.x],[loc.y],[loc.z]).", loc.x, loc.y, loc.z)

		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [human_mob]."))
		if(do_after(user, cuff_delay, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, human_mob, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !human_mob.handcuffed && Adjacent(user))
				if(iscarbon(human_mob))
					if(istype(human_mob.buckled, /obj/structure/bed/roller))
						to_chat(user, SPAN_DANGER("You cannot handcuff someone who is buckled onto a roller bed."))
						return
				if(human_mob.has_limb_for_slot(WEAR_HANDCUFFS))
					user.drop_inv_item_on_ground(src)
					human_mob.equip_to_slot_if_possible(src, WEAR_HANDCUFFS, 1, 0, 1, 1)
					user.count_niche_stat(STATISTICS_NICHE_HANDCUFF)

	else if(ismonkey(target))
		user.visible_message(SPAN_NOTICE("[user] tries to put [src] on [target]."))
		if(do_after(user, 30, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(src == user.get_active_hand() && !target.handcuffed && Adjacent(user))
				user.drop_inv_item_on_ground(src)
				target.equip_to_slot_if_possible(src, WEAR_HANDCUFFS, 1, 0, 1, 1)

/obj/item/restraint/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon_state = "handcuff"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 5
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 5
	matter = list("metal" = 500)

/obj/item/restraint/handcuffs/get_mob_overlay(mob/user_mob, slot, default_bodytype = "Default")
	var/image/ret = ..()

	if(slot == WEAR_HANDCUFFS)
		var/image/handcuffs = overlay_image('icons/mob/humans/onmob/cuffs.dmi', "handcuff1", color, RESET_COLOR)
		ret.overlays += handcuffs

	return ret

/obj/item/restraint/handcuffs/zip
	name = "zip cuffs"
	desc = "Single-use plastic zip tie handcuffs."
	w_class = SIZE_TINY
	icon_state = "cuff_zip"
	breakouttime = 60 SECONDS
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_delay = 20

/obj/item/restraint/handcuffs/zip/place_handcuffs(mob/living/carbon/target, mob/user)
	..()
	flags_item |= DELONDROP

/obj/item/restraint/adjustable/verb/adjust_restraints()
	set category = "Object"
	set name = "Adjust Restraints"
	set desc = "Adjust the restraint size for wrists or ankles."
	set src = usr.contents

	if(!ishuman(usr))
		return FALSE

	if(usr.is_mob_incapacitated())
		to_chat(usr, "Not right now.")
		return FALSE

	switch(target_zone)
		if(SLOT_HANDS)
			target_zone = SLOT_LEGS
			to_chat(usr, SPAN_NOTICE("[src] has been adjusted to tie around a subject's ankles."))
		if(SLOT_LEGS)
			target_zone = SLOT_HANDS
			to_chat(usr, SPAN_NOTICE("[src] has been adjusted to tie around a subject's wrists."))

/obj/item/restraint/adjustable/get_examine_text(mob/user)
	. = ..()
	switch(target_zone)
		if(SLOT_HANDS)
			. += SPAN_RED("Sized for human hands.")
		if(SLOT_LEGS)
			. += SPAN_RED("Sized for human ankles.")

/obj/item/restraint/adjustable/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 30 SECONDS
	cuff_sound = 'sound/weapons/cablecuff.ogg'

/obj/item/restraint/adjustable/cable/red
	color = "#DD0000"

/obj/item/restraint/adjustable/cable/yellow
	color = "#DDDD00"

/obj/item/restraint/adjustable/cable/blue
	color = "#0000DD"

/obj/item/restraint/adjustable/cable/green
	color = "#00DD00"

/obj/item/restraint/adjustable/cable/pink
	color = "#DD00DD"

/obj/item/restraint/adjustable/cable/orange
	color = "#DD8800"

/obj/item/restraint/adjustable/cable/cyan
	color = "#00DDDD"

/obj/item/restraint/adjustable/cable/white
	color = "#FFFFFF"

/obj/item/restraint/adjustable/cable/attackby(obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod

			user.put_in_hands(W)
			to_chat(user, SPAN_NOTICE("You wrap the cable restraint around the top of the rod."))
			qdel(src)
			update_icon(user)

/obj/item/restraint/handcuffs/cyborg/attack(mob/living/carbon/carbon_mob as mob, mob/user as mob)
	if(!carbon_mob.handcuffed)
		var/turf/p_loc = user.loc
		var/turf/p_loc_m = carbon_mob.loc
		playsound(loc, cuff_sound, 25, 1, 4)
		user.visible_message(SPAN_DANGER("<B>[user] is trying to put handcuffs on [carbon_mob]!</B>"))

		if(ishuman(carbon_mob))
			var/mob/living/carbon/human/human_mob = carbon_mob
			if (!human_mob.has_limb_for_slot(WEAR_HANDCUFFS))
				to_chat(user, SPAN_DANGER("\The [human_mob] needs at least two wrists before you can cuff them together!"))
				return

		spawn(30)
			if(!carbon_mob)
				return
			if(p_loc == user.loc && p_loc_m == carbon_mob.loc)
				carbon_mob.handcuffed = new /obj/item/restraint/handcuffs(carbon_mob)
				carbon_mob.handcuff_update()
