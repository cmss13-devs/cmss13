/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/issue_order
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "issue_order"
	full_name = "Issue Order"
	description = "Select an order to issue."
	keybind_signal = COMSIG_KB_HUMAN_ISSUE_ORDER
	var/order

/datum/keybinding/human/issue_order/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.issue_order(order)
	return TRUE

/datum/keybinding/human/issue_order/move
	name = "issue_order_move"
	full_name = "Issue Move order"
	description = "Increased mobility and chance to dodge projectiles."
	keybind_signal = COMSIG_KB_HUMAN_ISSUE_ORDER_MOVE
	order = COMMAND_ORDER_MOVE

/datum/keybinding/human/issue_order/hold
	name = "issue_order_hold"
	full_name = "Issue Hold order"
	description = "Increased resistance to pain and combat wounds."
	keybind_signal = COMSIG_KB_HUMAN_ISSUE_ORDER_HOLD
	order = COMMAND_ORDER_HOLD

/datum/keybinding/human/issue_order/focus
	name = "issue_order_focus"
	full_name = "Issue Focus order"
	description = "Increased gun accuracy and effective range."
	keybind_signal = COMSIG_KB_HUMAN_ISSUE_ORDER_FOCUS
	order = COMMAND_ORDER_FOCUS

/datum/keybinding/human/specialist_one
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "specialist_activation_one"
	full_name = "Specialist Activation One"
	keybind_signal = COMSIG_KB_HUMAN_SPECIALIST_ACTIVATION_ONE

/datum/keybinding/human/specialist_one/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.spec_activation_one()
	return TRUE

/datum/keybinding/human/specialist_two
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "specialist_activation_two"
	full_name = "Specialist Activation Two"
	keybind_signal = COMSIG_KB_HUMAN_SPECIALIST_ACTIVATION_TWO

/datum/keybinding/human/specialist_two/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.spec_activation_two()
	return TRUE

/datum/keybinding/human/rotate_chair
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "rotate_chair"
	full_name = "Rotate Chair"
	description = "Rotate a nearby chair"
	keybind_signal = COMSIG_KB_HUMAN_ROTATE_CHAIR

/datum/keybinding/human/rotate_chair/down(client/user)
	. = ..()
	if(.)
		return

	var/obj/structure/bed/chair/chair = locate(/obj/structure/bed/chair) in range(1, user)
	if(chair?.can_rotate)
		chair.human_rotate()

/datum/keybinding/human/show_held_item
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "show_held_item"
	full_name = "Show Held Item"
	keybind_signal = COMSIG_KB_HUMAN_SHOW_HELD_ITEM

/datum/keybinding/human/show_held_item/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human_user = user.mob
	var/obj/item/shown_item = human_user.get_active_hand()
	if(shown_item && !(shown_item.flags_item & ITEM_ABSTRACT))
		shown_item.showoff(human_user)
	return TRUE

/datum/keybinding/human/cycle_helmet_hud
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "cycle_helmet_hud"
	full_name = "Cycle Helmet HUD"
	keybind_signal = COMSIG_KB_HUMAN_CYCLE_HELMET_HUD

/datum/keybinding/human/cycle_helmet_hud/down(client/user)
	. = ..()
	if(.)
		return

	// Get the user's marine helmet (if they're wearing one)
	var/mob/living/carbon/human/human_user = user.mob
	var/obj/item/clothing/head/helmet/marine/marine_helmet = human_user.head
	if(!istype(marine_helmet))
		// If their hat isn't a marine helmet, or is null, return.
		return

	// Cycle the HUD on the helmet.
	var/cycled_hud = marine_helmet.cycle_huds(human_user)

	// Update the helmet's 'cycle hud' action button
	var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in marine_helmet.actions
	cycle_action?.set_action_overlay(cycled_hud)

	return TRUE
