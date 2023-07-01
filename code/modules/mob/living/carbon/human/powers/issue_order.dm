/mob/living/carbon/human/proc/issue_order(order)
	if(!HAS_TRAIT(src, TRAIT_LEADERSHIP))
		to_chat(src, SPAN_WARNING("You are not qualified to issue orders!"))
		return

	if(stat)
		to_chat(src, SPAN_WARNING("You cannot give an order in your current state."))
		return

	if(!skills)
		return FALSE
	var/order_level = skills.get_skill_level(SKILL_LEADERSHIP)
	if(!order_level)
		order_level = SKILL_LEAD_TRAINED

	if(!order)
		if(current_aura)
			deactivate_order_buff(current_aura)
			current_aura = null
			visible_message(SPAN_WARNING("\The [src] stops issueing orders."), \
			SPAN_WARNING("You stop issueing orders."), null, 5)
			return
		else
			order = tgui_input_list(src, "Choose an order", "Order to send", list(COMMAND_ORDER_MOVE, COMMAND_ORDER_HOLD, COMMAND_ORDER_FOCUS, "help", "cancel"))
			if(order == "help")
				to_chat(src, SPAN_NOTICE("<br>Orders give a buff to nearby soldiers for a short period of time, followed by a cooldown, as follows:<br><B>Move</B> - Increased mobility and chance to dodge projectiles.<br><B>Hold</B> - Increased resistance to pain and combat wounds.<br><B>Focus</B> - Increased gun accuracy and effective range.<br>"))
				return
			if(order == "cancel")
				return

	if(order)
		if(current_aura == order)
			visible_message(SPAN_BOLDNOTICE("[src] whitdraws their order to [order]!"), SPAN_BOLDNOTICE("You withdraw your order to [order]!"))
			deactivate_order_buff(current_aura)
			current_aura = null
			order = null
		else
			deactivate_order_buff(current_aura)
			visible_message(SPAN_BOLDNOTICE("[src] gives an order to [order]!"), SPAN_BOLDNOTICE("You give an order to [order]!"))
			aura_strength = order_level
			current_aura = order

	handle_orders(current_aura, aura_strength)

	/*if((src.job == JOB_SQUAD_LEADER || HAS_TRAIT(src, TRAIT_SOURCE_SQUAD_LEADER)) && src.assigned_squad && src.assigned_squad.num_tl)
		for(var/mob/living/carbon/human/marine in src.assigned_squad.ftl_list)
			marine.handle_ftl_orders(marine)*/

	/*var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in range(COMMAND_ORDER_RANGE, T))
		if(H.stat == DEAD)
			continue
		H.activate_order_buff(order, aura_strength)

	if(loc != T) //if we were inside something, the range() missed us.
		activate_order_buff(order, aura_strength)

	for(var/datum/action/A in actions)
		A.update_button_icon()*/



/mob/living/carbon/human/proc/handle_ftl_orders()
	if(!assigned_squad)
		return
	/*if(current_aura)
		deactivate_order_buff(current_aura)*/

	var/mob/living/carbon/human/squad_lead = assigned_squad.squad_leader
	if(!squad_lead || !squad_lead.current_aura || squad_lead.loc.z != loc.z)
		if(current_aura && !squad_lead.current_aura)
			to_chat(src, SPAN_WARNING("Your radio goes quiet. The Squad Leader is no longer giving orders."))
		aura_strength = 0
		current_aura = null
	else
		if(current_aura != squad_lead.current_aura)
			to_chat(src, SPAN_WARNING("Your orders have changed. The Squad Leader has other plans."))
		aura_strength = squad_lead.aura_strength
		current_aura = squad_lead.current_aura
		handle_orders(current_aura, aura_strength)
	hud_set_order()

/mob/living/carbon/human/verb/issue_order_verb()
	set name = "Issue Order"
	set desc = "Issue an order to nearby humans, using your authority to strengthen their resolve."
	set category = "IC"

	issue_order()

/*mob/living/carbon/human/proc/activate_order_buff(order, strength)
	if(!order || !strength)
		return

	switch(order)
		if(COMMAND_ORDER_MOVE)
			//mobility_aura_count++
			mobility_aura = Clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			//protection_aura_count++
			protection_aura = Clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
			pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			//marksman_aura_count++
			marksman_aura = Clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)

	hud_set_order()*/


/mob/living/carbon/human/proc/deactivate_order_buff(order)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			/*if(mobility_aura_count > 1)
				mobility_aura_count--
			else
				mobility_aura_count = 0*/
			mobility_aura_new = 0
		if(COMMAND_ORDER_HOLD)
			/*if(protection_aura_count > 1)
				protection_aura_count--
			else
				pain.reset_pain_reduction()
				protection_aura_count = 0*/
			protection_aura_new = 0
		if(COMMAND_ORDER_FOCUS)
			/*if(marksman_aura_count > 1)
				marksman_aura_count--
			else
				marksman_aura_count = 0*/
			marksman_aura_new = 0

	hud_set_order()
