/mob/living/Initialize()
	. = ..()
	flags_atom |= BUMP_ATTACKABLE

/obj/vehicle/Initialize()
	. = ..()
	flags_atom |= BUMP_ATTACKABLE

///Used to enable/disable an item's bump attack. Grouped in a proc to make sure the signal or flags aren't missed
/obj/item/proc/toggle_item_bump_attack(mob/user, enable_bump_attack)
	SEND_SIGNAL(user, COMSIG_ITEM_TOGGLE_BUMP_ATTACK, enable_bump_attack)
	if(flags_item & CAN_BUMP_ATTACK && enable_bump_attack)
		return
	if(enable_bump_attack)
		flags_item |= CAN_BUMP_ATTACK
		return
	flags_item &= ~CAN_BUMP_ATTACK
