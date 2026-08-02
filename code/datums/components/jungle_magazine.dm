//TODO: WIP

/*
Extra signals that should be accounted for:
- When the mag is put into any storage (For balance purpose, to stop jungle style from going into belts and armor like normal)

Items for initiating the construct should handle all the necessary stuffs themselves
AKA the code here shouldn't worrying about setting up the construct I guess

When adding magazine whatever signal is also registered for that magazine
And when mag is switched the magazine item in hand literally switches

Alternatively TakeComponent() looks promising //TODO: test this out at some point, preferably after a working version is achieved

The two flags:
- JUNGLE_STYLE_ABLE [conflict.dm]
- JUNGLE_MAG_BINDER [equipment.dm]

okay okay here it goes:
- Dont give a crap about prime magazine or not.
- Use in hand to eject magazine
- If there is more than one (aka an attaching magazine exists) eject that
- If there is only the parent eject both parent and binding object, remove the component
Down side is that if you used up prime mag you have to detach everything, annoying.
Good thing is that the whole process would be simple and intuative, you just slap the binding object on the new mag and make it pretty quickly!
*/

/datum/component/jungle_magazine
	var/obj/item/binding_item //The item that initiated the jungle mag construct
	var/contained_mags = list(0, 0) //A list referencing the actual magazine objects, parent shouldd always be in [1]
	var/active_slot = FALSE //It's two slots, 0 and 1
	// var/is_completed = FALSE //If the jungle mag construct is completed

/datum/component/jungle_magazine/Initialize(mob/user, obj/item/trigger_item)
	if(!istype(parent, /obj/item/ammo_magazine))
		return COMPONENT_INCOMPATIBLE
	binding_item = trigger_item
	contained_mags[1] = parent
	if(user)
		user.drop_inv_item_to_loc(binding_item, parent)
	else
		binding_item.forceMove(parent)


/datum/component/jungle_magazine/RegisterWithParent()
	signal_reg(parent)

/datum/component/jungle_magazine/UnregisterFromParent()
	signal_unreg(parent)

//* Trigger procs
/datum/component/jungle_magazine/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user) //! This crap is never triggered
	SIGNAL_HANDLER

	//Check if the incoming item is a magazine -> attempt to add the magazine
	if(istype(attacking_item, /obj/item/ammo_magazine))
		add_magazine(user, attacking_item)
		return COMPONENT_CANCEL_ITEM_ATTACK //? I think this is how it works?d

/datum/component/jungle_magazine/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += get_examine_text()

/datum/component/jungle_magazine/proc/on_unique_action(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

	switch_active_magazine(user)

/datum/component/jungle_magazine/proc/on_attack_self(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

	// switch_active_magazine(user)
	remove_magazine(user)

//* Custom procs
/datum/component/jungle_magazine/proc/update_sprite() //TODO: This one might need a bit more work, perhaps I'd need to merge the new icons beforehand

/datum/component/jungle_magazine/proc/switch_active_magazine(mob/user)
	//Swaps magazine locations
	var/obj/item/ammo_magazine/old_mag = active_magazine()
	active_slot = !active_slot
	var/obj/item/ammo_magazine/new_mag = active_magazine()
	if(new_mag)
		if(user) //TODO: Get help to think up a better way to handel switching mag entities
			user.drop_inv_item_on_ground(old_mag)
			user.put_in_hands(new_mag)
			old_mag.forceMove(new_mag)
			to_chat(user, SPAN_BLUE("You switched the magazine slot to slot [active_slot+1]"))
		else
			var/old_loc = old_mag.loc
			old_mag.forceMove(get_turf(new_mag))
			new_mag.forceMove(old_loc)
			old_mag.forceMove(new_mag)
		//TODO: Update icon here
	else
		active_slot = !active_slot
		if(user)
			to_chat(user, SPAN_WARNING("There is no magazine to switch to!"))

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
		if(contained_mags[2] == 0)
			if (user)
				user.drop_inv_item_to_loc(M, parent)
			else //? Honestly don't know in what case would one add a magazine without an user; pending for remove if uneeded
				M.forceMove(parent)
			contained_mags[2] = M
			signal_reg(M)
			// update_icon() //TODO: yeah update the godamn icon
			return TRUE
		else
			to_chat(user, SPAN_WARNING("A magazine is already attached to the jungle magazine!"))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("[src] only accepts magazines!"))
		return FALSE
	// else
	// 	to_chat(user,SPAN_WARNING("[src] can not have its magazine changed!"))
	// 	return FALSE

/datum/component/jungle_magazine/proc/remove_magazine(mob/user)
	//* Two Cases: 1) Remove parent magazine - Ejects everything and removes component
	//*            2) Remove attached magazine - Ejects attached magazine, allowing for fresh mags
	//Doing this with if statement since there's only two magazines max
	var/obj/item/ammo_magazine/target_magazine
	if(contained_mags[2] != 0) //Case #2
		target_magazine = contained_mags[2]
		if (user)
			user.put_in_hands(target_magazine)
		else
			target_magazine.forceMove(get_turf(parent))
		contained_mags[2] = 0
		signal_unreg(target_magazine)
	else //Case #1
		target_magazine = parent
		if(user)
			user.put_in_hands(binding_item)
			// user.put_in_hands(target_magazine) //Yea idk man the magazine is PROBABLY being HELD IN HAND
		else
			var/target_turf = get_turf(parent)
			binding_item.forceMove(target_turf)
			target_magazine.forceMove(target_turf)
		src.Destroy() //Removes the component completely

	return TRUE

/datum/component/jungle_magazine/proc/get_examine_text()
	. += "Use special action or alt-click to switch active slot, use in hand or click with an empty hand to remove magazine."
	for(var/i in 1 to length(contained_mags))
		if (contained_mags[i] == 0)
			. += "Slot [i] is empty."
		else
			var/obj/item/ammo_magazine/target_mag = contained_mags[i]
			. += "Slot [i] is occupied: [target_mag] has [target_mag.current_rounds] out of [target_mag.max_rounds]."
	. += "The active slot is slot [active_slot+1]."

/datum/component/jungle_magazine/proc/signal_reg(obj/item/ammo_magazine/target_magazine) //? Only expecting magazines here
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACKED, PROC_REF(on_attackby))
	RegisterSignal(target_magazine, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION, PROC_REF(on_unique_action))

/datum/component/jungle_magazine/proc/signal_unreg(obj/item/ammo_magazine/target_magazine)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACKED)
	UnregisterSignal(target_magazine, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION)

