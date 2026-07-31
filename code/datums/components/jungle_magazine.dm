//TODO: WIP

/*
*Run down of how the component should work:
- Player use a tape on a magazine -> performs necessary checks and attach component
- Click with another magazine to complete the construct
- The icon now shows the original mag and the taped on mag
- Listen for special action for switching active slot
- For interaction involving magazines the construct would reference the magazine that is in the active slot
- When examined the construct would add information regarding jungle mags to it; the name of the item should show that it is a jungle mag
- Listen for use in hand to signal the dismantle of the construct


Ways a normal magazine is interacted with:
- Examined
- Attacked with hand
- Attacked by other items

Extra signals that should be accounted for:
- When the mag is put into any storage

Items for initiating the construct should handle all the necessary stuffs themselves
AKA the code here shouldn't worrying about setting up the construct I guess
*/

/datum/component/jungle_magazine
	var/contained_mags = list(0, 0) //A list referencing the actual magazine objects
	var/active_slot = FALSE //It's two slots, 0 and 1
	var/is_completed = FALSE //If the jungle mag construct is completed

/datum/component/jungle_magazine/Initialize()
	if(istype(parent, /obj/item/ammo_magazine))
		return COMPONENT_INCOMPATIBLE
	contained_mags[1] = parent


/datum/component/jungle_magazine/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(parent, COMSIG_ITEM_UNIQUE_ACTION, PROC_REF(on_unique_action))

/datum/component/jungle_magazine/UnregisterFromParent()
	UnregisterFromParent(parent, COMSIG_ITEM_ATTACK)
	UnregisterFromParent(parent, COMSIG_PARENT_EXAMINE)
	UnregisterFromParent(parent, COMSIG_ITEM_ATTACK_SELF)
	UnregisterFromParent(parent, COMSIG_ITEM_UNIQUE_ACTION)

//* Trigger procs
/datum/component/jungle_magazine/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER

	//Check if the incoming item is a magazine -> attempt to add the magazine
	if(istype(attacking_item, /obj/item/ammo_magazine) && !is_completed)
		add_magazine(user, attacking_item)
		return COMPONENT_CANCEL_ITEM_ATTACK //? I think this is how it works?d

	//Check if the incoming item is something idk //TODO: Add other checks if needed, like idk screwdriver and welding tools

	//Everything else is pass to magazine's attackby proc //TODO:
	var/obj/item/ammo_magazine/target_magazine = active_magazine()
	target_magazine.attackby(attacking_item, user)
	return COMPONENT_CANCEL_ITEM_ATTACK

/datum/component/jungle_magazine/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += get_examine_text()

/datum/component/jungle_magazine/proc/on_unique_action(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

	switch_active_slot(user)

/datum/component/jungle_magazine/proc/on_attack_self(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

//* Custom procs
/datum/component/jungle_magazine/proc/update_sprite() //TODO: This one might need a bit more work, perhaps I'd need to merge the new icons beforehand

/datum/component/jungle_magazine/proc/switch_active_slot(mob/user)
	active_slot= !active_slot
	if(user)
		to_chat(user, SPAN_BLUE("You switched the magazine slot to slot [active_slot+1]"))

/datum/component/jungle_magazine/proc/active_magazine()
	return contained_mags[active_slot+1]

/datum/component/jungle_magazine/proc/add_magazine(mob/user, obj/item/ammo_magazine/M) //? Used in construction phase
	// if(!is_integrated) //TODO: Implement a flag for is_integrated
	if(istype(M)) //Checks if incoming item is a magazine
		// if(compatible_magazines) //TODO: Implement a flag for this as well?
		// 	var/is_compatible = FALSE
		// 	for(var/I in compatible_magazines)
		// 		if(istype(M, I))
		// 			is_compatible = TRUE
		// 	if(!is_compatible)
		// 		to_chat(user, SPAN_WARNING("This magazine is not compatible!"))
		// 		return FALSE
		if (src.active_magazine() == 0)
			if (user)
				user.drop_inv_item_to_loc(M, src)
			else
				M.forceMove(get_turf(src))
			contained_mags[active_slot+1] = M
			// update_icon() //TODO: yeah update the godamn icon
			return TRUE
		else
			to_chat(user, SPAN_WARNING("The active slot already has a magazine in it!"))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("[src] only accepts magazines!"))
		return FALSE
	// else
	// 	to_chat(user,SPAN_WARNING("[src] can not have its magazine changed!"))
	// 	return FALSE

/datum/component/jungle_magazine/proc/remove_magazine(mob/user)
	// if(!is_integrated) //TODO: Implement a flag for is_integrated
	var/obj/item/ammo_magazine/target_magazine = active_magazine()
	if (!target_magazine)
		to_chat(user, SPAN_WARNING("The active slot doesn't have any magazines in it!"))
		return FALSE
	if (user)
		user.put_in_hands(target_magazine)
	else
		target_magazine.forceMove(get_turf(src))
	contained_mags[active_slot+1] = 0
	// update_icon() //TODO: yeah update the godamn icon
	return TRUE
	// else
	// 	to_chat(user, SPAN_WARNING("[src] can not have its magazine removed!"))
	// 	return FALSE

/datum/component/jungle_magazine/proc/init_construct()

/datum/component/jungle_magazine/proc/complete_construct() //? Send component to functioning phase

/datum/component/jungle_magazine/proc/break_down_construct() //? Send component back to construction phase

/datum/component/jungle_magazine/proc/remove_construct() //TODO: Pay special attention to this, make sure everything works as intended
	//TODO: Reset the sprite
	RemoveComponent()

/datum/component/jungle_magazine/proc/get_examine_text()
	. += "Use special action or alt-click to switch active slot, use in hand or click with an empty hand to remove magazine."
	for(var/i in 1 to length(contained_mags))
		if (contained_mags[i] == 0)
			. += "Slot [i] is empty."
		else
			var/obj/item/ammo_magazine/target_mag = contained_mags[i]
			. += "Slot [i] is occupied: [target_mag] has [target_mag.current_rounds] out of [target_mag.max_rounds]."
	. += "The active slot is slot [active_slot+1]."

// /datum/component/jungle_magazine/proc/insert_magazine(mob/user, obj/item/ammo_magazine/M)

// /datum/component/jungle_magazine/proc/remove_magazine()
