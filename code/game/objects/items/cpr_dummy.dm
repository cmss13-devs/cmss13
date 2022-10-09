/obj/item/cpr_dummy
	name = "\improper CPR dummy"
	desc = "A CPR dummy, for training all those privates how to save a life! Does not accurately emulate battle wounds, does not simulate rib breaking, plastic toxic to touch, please contact a doctor if skin irritation persists for more than two hours."
	icon = 'icons/obj/items/cpr_dummy.dmi'
	icon_state = "cpr_dummy"
	var/successful_cprs = 0
	var/failed_cprs = 0
	var/cpr_cooldown = 0

/obj/item/cpr_dummy/get_examine_text(mob/user)
	. = ..()
	. += "Successful CPRs: [SPAN_GREEN(successful_cprs)]."
	. += "Failed CPRs: [SPAN_RED(failed_cprs)]."

/obj/item/cpr_dummy/update_icon()
	if(anchored)
		icon_state = "[initial(icon_state)]_deployed"
	else
		icon_state = initial(icon_state)
	return ..()

/obj/item/cpr_dummy/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[user] sets up \the [src] for use!"), SPAN_NOTICE("You set up \the [src] for use."))
	user.drop_inv_item_on_ground(src)
	anchored = TRUE
	update_icon()

/obj/item/cpr_dummy/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src) && !usr.is_mob_restrained())
		var/success = FALSE
		if(usr == over_object && usr.put_in_hands(src))
			success = TRUE
		else
			switch(over_object.name)
				if("r_hand")
					if(src.loc != usr || usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
						success = TRUE
				if("l_hand")
					if(src.loc != usr || usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)
						success = TRUE
		if(success)
			if(anchored)
				anchored = FALSE
				update_icon()
			add_fingerprint(usr)

/obj/item/cpr_dummy/attack_hand(mob/living/carbon/human/H)
	if(!anchored || !istype(H))
		return ..()
	if(H.action_busy)
		return FALSE
	if(H.a_intent != INTENT_HELP)
		to_chat(H, SPAN_WARNING("You need to be on help intent to do CPR!"))
		return
	if((H.head && (H.head.flags_inventory & COVERMOUTH)) || (H.wear_mask && (H.wear_mask.flags_inventory & COVERMOUTH) && !(H.wear_mask.flags_inventory & ALLOWCPR)))
		to_chat(H, SPAN_BOLDNOTICE("Remove your mask!"))
		return FALSE
	H.visible_message(SPAN_NOTICE("<b>[H]</b> starts performing <b>CPR</b> on <b>[src]</b>."), SPAN_HELPFUL("You start <b>performing CPR</b> on <b>[src]</b>."))
	if(!do_after(H, HUMAN_STRIP_DELAY * H.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	if(cpr_cooldown < world.time)
		H.visible_message(SPAN_NOTICE("<b>[H]</b> performs <b>CPR</b> on <b>[src]</b>."), SPAN_HELPFUL("You perform <b>CPR</b> on <b>[src]</b>."))
		successful_cprs++
	else
		H.visible_message(SPAN_NOTICE("<b>[H]</b> fails to perform CPR on <b>[src]</b>."), SPAN_HELPFUL("You <b>fail</b> to perform <b>CPR</b> on <b>[src]</b>. Incorrect rhythm. Do it <b>slower</b>."))
		failed_cprs++
	cpr_cooldown = world.time + 7 SECONDS

/obj/item/cpr_dummy/verb/reset_counter()
	set name = "Reset CPR Counter"
	set category = "Object"
	set src in oview(1)

	if(!isSEA(usr))
		to_chat(usr, SPAN_WARNING("Only Senior Enlisted Advisors can reset the counter on this dummy!"))
		return
	successful_cprs = 0
	failed_cprs = 0
	to_chat(usr, SPAN_NOTICE("You reset the counter on \the [src]."))
