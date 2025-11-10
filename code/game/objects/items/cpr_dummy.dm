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
	. += SPAN_GREEN("Успешные СЛР: [successful_cprs].") // SS220 EDIT ADDICTION
	. += SPAN_RED("Проваленные СЛР: [failed_cprs].") // SS220 EDIT ADDICTION

/obj/item/cpr_dummy/update_icon()
	if(anchored)
		icon_state = "[initial(icon_state)]_deployed"
	else
		icon_state = initial(icon_state)
	return ..()

/obj/item/cpr_dummy/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[capitalize(user.declent_ru(NOMINATIVE))] устанавливает [declent_ru(ACCUSATIVE)]!"), SPAN_NOTICE("Вы устанавливаете [declent_ru(ACCUSATIVE)].")) // SS220 EDIT ADDICTION
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
		to_chat(H, SPAN_WARNING("Вам нужно быть в ЗЕЛЁНОМ интенте, чтобы начать СЛР!"))
		return
	if((H.head && (H.head.flags_inventory & COVERMOUTH)) || (H.wear_mask && (H.wear_mask.flags_inventory & COVERMOUTH) && !(H.wear_mask.flags_inventory & ALLOWCPR)))
		to_chat(H, SPAN_BOLDNOTICE("Снимите свою маску!"))
		return FALSE
	var/is_male = H.gender == MALE ? "" : "а" // SS220 EDUT ADDICTION
	var/ru_name = declent_ru(PREPOSITIONAL)
	H.visible_message(SPAN_NOTICE("<b>[H]</b> начал[is_male] проводить <b>СЛР</b> на <b>[ru_name]</b>."), SPAN_HELPFUL("Вы начали проводить <b>СЛР</b> на <b>[ru_name]</b>.")) // SS220 EDIT ADDICTION
	if(!do_after(H, HUMAN_STRIP_DELAY * H.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	if(cpr_cooldown < world.time)
		H.visible_message(SPAN_NOTICE("<b>[H]</b> выполнил[is_male] проведение <b>СЛР</b> на <b>[ru_name]</b>."), SPAN_HELPFUL("Вы выполнили проведение <b>СЛР</b> на <b>[ru_name]</b>.")) // SS220 EDIT ADDICTION
		successful_cprs++
	else
		H.visible_message(SPAN_NOTICE("<b>[H]</b> провалил[is_male] проведение <b>СЛР</b> на <b>[ru_name]</b>."), SPAN_WARNING("Вы провалили проведение <b>СЛР</b> на <b>[ru_name]</b>. Не проводите <b>СЛР</b> слишком часто. Подождите перед следующей попыткой.")) // SS220 EDIT ADDICTION
		failed_cprs++
	cpr_cooldown = world.time + 7 SECONDS

/obj/item/cpr_dummy/verb/reset_counter()
	set name = "Reset CPR Counter"
	set category = "Object"
	set src in oview(1)

	if(!isSEA(usr))
		to_chat(usr, SPAN_WARNING("Только старший инструктор может сбросить статистику этого тренажёра!"))
		return
	successful_cprs = 0
	failed_cprs = 0
	to_chat(usr, SPAN_NOTICE("Вы сбросили статистику [declent_ru(GENITIVE)].")) // SS220 EDIT ADDICTION
