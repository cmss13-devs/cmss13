/mob/living/carbon/human/proc/handle_orders()

	var/aura_center = src
	if(aura_strength > 0)
		for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
			if(H.faction != faction || H.z != z || get_dist(aura_center, H) > COMMAND_ORDER_RANGE)
				continue
			H.affected_by_orders(current_aura, aura_strength)
	/*var/datum/shape/rectangle/range_bounds
	var/turf/cur_turf = get_turf(src)
	range_bounds.center_x = cur_turf.x
	range_bounds.center_y = cur_turf.y
	range_bounds.width = COMMAND_ORDER_RANGE * 2
	range_bounds.height = COMMAND_ORDER_RANGE * 2

	var/list/targets = SSquadtree.players_in_range(range_bounds, cur_turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.get_target_lock(src.faction)))
			continue
		H.affected_by_orders(current_aura, aura_strength)
		if(mob == loc) continue   Note: Might not need this as the leader is also affected by his own orders*/

	if(mobility_aura != mobility_aura_new || protection_aura != protection_aura_new || marksman_aura != marksman_aura_new)
		mobility_aura = mobility_aura_new
		protection_aura = protection_aura_new
		marksman_aura = marksman_aura_new
		hud_set_order()

	mobility_aura = 0
	protection_aura = 0
	marksman_aura = 0

/mob/living/carbon/human/proc/affected_by_orders(order, strength)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			if(strength > mobility_aura_new)
				mobility_aura = Clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			if(strength > protection_aura_new)
				protection_aura = Clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
				pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			if(strength > marksman_aura_new)
				marksman_aura = Clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)
