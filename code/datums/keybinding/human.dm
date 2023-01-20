#define QUICK_EQUIP_PRIMARY 1
#define QUICK_EQUIP_SECONDARY 2
#define QUICK_EQUIP_TERTIARY 3
#define QUICK_EQUIP_QUATERNARY 4

/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/quick_equip
	hotkey_keys = list("E")
	classic_keys = list("E")
	name = "quick_equip"
	full_name = "Unholster"
	description = "Take out an available weapon"
	keybind_signal = COMSIG_KB_HUMAN_QUICKEQUIP_DOWN

/datum/keybinding/human/quick_equip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb(QUICK_EQUIP_PRIMARY)
	return TRUE

/datum/keybinding/human/quick_equip_secondary
	hotkey_keys = list("Shift+E")
	classic_keys = list("Shift+E")
	name = "quick_equip_secondary"
	full_name = "Unholster secondary"
	description = "Take out your secondary weapon"
	keybind_signal = COMSIG_KB_HUMAN_SECONDARY_DOWN

/datum/keybinding/human/quick_equip_secondary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb(QUICK_EQUIP_SECONDARY)
	return TRUE

/datum/keybinding/human/quick_equip_tertiary
	hotkey_keys = list("Ctrl+E", "Alt+E")
	classic_keys = list("Ctrl+E", "Alt+E")
	name = "quick_equip_tertiary"
	full_name = "Unholster tertiary"
	description = "Take out your tertiary item."
	keybind_signal = COMSIG_KB_HUMAN_TERTIARY_DOWN

/datum/keybinding/human/quick_equip_tertiary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb(QUICK_EQUIP_TERTIARY)
	return TRUE

/datum/keybinding/human/quick_equip_quaternary
	hotkey_keys = list()
	classic_keys = list()
	name = "quick_equip_quaternary"
	full_name = "Unholster quaternary"
	description = "Take out your quaternary item."
	keybind_signal = COMSIG_KB_HUMAN_QUATERNARY_DOWN

/datum/keybinding/human/quick_equip_quaternary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb(QUICK_EQUIP_QUATERNARY)
	return TRUE

/datum/keybinding/human/quick_equip_inventory
	hotkey_keys = list()
	classic_keys = list()
	name = "quick_equip_inventory"
	full_name = "Quick equip inventory"
	description = "Quickly puts an item in the best slot available"
	keybind_signal = COMSIG_KB_HUMAN_QUICK_EQUIP_DOWN

/datum/keybinding/human/quick_equip_inventory/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE

/datum/keybinding/human/issue_order
	hotkey_keys = list()
	classic_keys = list()
	name = "issue_order"
	full_name = "Issue Order"
	description = "Select an order to issue."
	keybind_signal = COMSIG_KB_HUMAN_ISSUE_ORDER
	var/order

/datum/keybinding/human/issue_order/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.issue_order(order)
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
	hotkey_keys = list()
	classic_keys = list()
	name = "specialist_activation_one"
	full_name = "Specialist Activation One"
	keybind_signal = COMSIG_KB_HUMAN_SPECIALIST_ACTIVATION_ONE

/datum/keybinding/human/specialist_one/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.spec_activation_one()
	return TRUE

/datum/keybinding/human/specialist_two
	hotkey_keys = list()
	classic_keys = list()
	name = "specialist_activation_two"
	full_name = "Specialist Activation Two"
	keybind_signal = COMSIG_KB_HUMAN_SPECIALIST_ACTIVATION_TWO

/datum/keybinding/human/specialist_two/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.spec_activation_two()
	return TRUE

/datum/keybinding/human/pick_up
	hotkey_keys = list("F")
	classic_keys = list()
	name = "pick_up"
	full_name = "Pick Up Dropped Items"
	keybind_signal = COMSIG_KG_HUMAN_PICK_UP

/datum/keybinding/human/pick_up/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human_user = user.mob
	human_user.pickup_recent()
	return TRUE

#undef QUICK_EQUIP_PRIMARY
#undef QUICK_EQUIP_SECONDARY
#undef QUICK_EQUIP_TERTIARY
#undef QUICK_EQUIP_QUATERNARY
