/datum/action/human_action/update_button_icon()
	if(action_cooldown_check())
		button.color = rgb(120,120,120,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/proc/action_cooldown_check()
	return FALSE


/datum/action/human_action/issue_order
	name = "Issue Order"
	action_icon_state = "order"
	var/order_type = "help"

/datum/action/human_action/issue_order/give_action(var/mob/living/L)
	..()
	if(!ishuman(L))
		return
	cooldown = COMMAND_ORDER_COOLDOWN

/datum/action/human_action/issue_order/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.issue_order(order_type)

/datum/action/human_action/issue_order/action_cooldown_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	return !H.command_aura_available

/datum/action/human_action/issue_order/move
	name = "Issue Order - Move"
	action_icon_state = "order_move"
	order_type = COMMAND_ORDER_MOVE

/datum/action/human_action/issue_order/hold
	name = "Issue Order - Hold"
	action_icon_state = "order_hold"
	order_type = COMMAND_ORDER_HOLD

/datum/action/human_action/issue_order/focus
	name = "Issue Order - Focus"
	action_icon_state = "order_focus"
	order_type = COMMAND_ORDER_FOCUS


/datum/action/human_action/smartpack/action_cooldown_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		return cooldown_check(S)
	else
		return FALSE

/datum/action/human_action/smartpack/action_activate()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = owner
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		form_call(S, H)

/datum/action/human_action/smartpack/give_action(var/mob/living/L)
	..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		cooldown = set_cooldown(S)
	else
		return

/datum/action/human_action/smartpack/proc/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	return

/datum/action/human_action/smartpack/proc/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return

/datum/action/human_action/smartpack/proc/cooldown_check(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.activated_form


/datum/action/human_action/smartpack/protective_form
	name = "Protective Form"
	action_icon_state = "smartpack_protect"

/datum/action/human_action/smartpack/protective_form/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.protective_form_cooldown

/datum/action/human_action/smartpack/protective_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.protective_form(H)

/datum/action/human_action/smartpack/immobile_form
	name = "Immobile Form"
	action_icon_state = "smartpack_immobile"

/datum/action/human_action/smartpack/immobile_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.immobile_form(H)

/datum/action/human_action/smartpack/repair_form
	name = "Repair Form"
	action_icon_state = "smartpack_repair"

/datum/action/human_action/smartpack/repair_form/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.repair_form_cooldown

/datum/action/human_action/smartpack/repair_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.repair_form(H)

/datum/action/human_action/smartpack/repair_form/cooldown_check(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.repairing
