/datum/action/human_action/issue_order
	name = "Issue Order"
	action_icon_state = "order"
	var/order_type = "help"

/datum/action/human_action/issue_order/give_action(var/mob/living/L)
	..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	cooldown = H.command_aura_cooldown

/datum/action/human_action/issue_order/action_activate()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = owner
	H.issue_order(order_type)

/datum/action/human_action/issue_order/move
	name = "Issue Order - Move"
	action_icon_state = "order_move"
	order_type = "move"

/datum/action/human_action/issue_order/hold
	name = "Issue Order - Hold"
	action_icon_state = "order_hold"
	order_type = "hold"

/datum/action/human_action/issue_order/focus
	name = "Issue Order - Focus"
	action_icon_state = "order_focus"
	order_type = "focus"
