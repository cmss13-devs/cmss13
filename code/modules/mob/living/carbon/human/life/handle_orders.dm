/mob/living/carbon/human/proc/handle_orders()

	var/aura_center = null
	if(current_aura)
		aura_center = src

	if((src.job == JOB_SQUAD_LEADER || HAS_TRAIT(src, TRAIT_SOURCE_SQUAD_LEADER)) && src.assigned_squad && src.assigned_squad.num_tl) //If the guy giving orders is leading a squad with FTLs we need them to act as beacons
		for(var/mob/living/carbon/human/marine in src.assigned_squad.ftl_list)
			marine.handle_ftl_orders(marine)

	if(aura_strength > 0)
		for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
			if(H.faction != faction || H.z != z || get_dist(aura_center, H) > COMMAND_ORDER_RANGE)
				continue
			H.affected_by_orders(current_aura, aura_strength)

	if(mobility_aura != mobility_aura_new || protection_aura != protection_aura_new || marksman_aura != marksman_aura_new)
		mobility_aura = mobility_aura_new
		protection_aura = protection_aura_new
		marksman_aura = marksman_aura_new
		hud_set_order()

	mobility_aura_new = 0
	protection_aura_new = 0
	marksman_aura_new = 0

/mob/living/carbon/human/proc/affected_by_orders(order, strength)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			if(strength > mobility_aura_new)
				mobility_aura_new = Clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			if(strength > protection_aura_new)
				protection_aura_new = Clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
				pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			if(strength > marksman_aura_new)
				marksman_aura_new = Clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)
