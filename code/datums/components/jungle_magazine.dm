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
	var/is_attached_magazine_active = FALSE //It's two slots, 0 and 1
	var/attached_magazine = 0
	var/is_reseting_sprite = FALSE

/datum/component/jungle_magazine/Initialize(mob/user, obj/item/trigger_item)
	if(!istype(parent, /obj/item/ammo_magazine))
		return COMPONENT_INCOMPATIBLE
	binding_item = trigger_item
	if(user)
		user.drop_inv_item_to_loc(binding_item, parent)
	else
		binding_item.forceMove(parent)
	add_overlay(parent)


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

	examine_list += get_examine_text(user)

/datum/component/jungle_magazine/proc/on_unique_action(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

	switch_active_magazine(user)

/datum/component/jungle_magazine/proc/on_attack_self(datum/source, mob/user) //TODO: Actally add the arguments in SEND_SIGNAL
	SIGNAL_HANDLER

	remove_magazine(user)

//Allow you to switch which hand is holding the jungle mag
/datum/component/jungle_magazine/proc/on_attempt_withdraw_handful(datum/source, mob/user)
	SIGNAL_HANDLER

	return COMPONENT_MAGAZINE_CANCEL_ATTEMPT_WITHDRAW_HANDFUL

/datum/component/jungle_magazine/proc/on_finish_update_magazine_icon(obj/item/ammo_magazine/source)
	SIGNAL_HANDLER

	if(!is_reseting_sprite)
		reset_magazine_sprite(source)
		add_overlay(source)

//* Custom procs
/datum/component/jungle_magazine/proc/add_overlay(obj/item/target) //TODO: This one might need a bit more work, perhaps I'd need to merge the new icons beforehand
	//! Current problem: when magazine is empty the sprite isn't updated; magazines with color bands cut their overlays when updating their icon - not cool man
	if(attached_magazine != 0) //Only necessary if there's a magazine attached
		//* Add the inactive magazine icon
		var/obj/item/ammo_magazine/inactive_mag = inactive_magazine()
		var/image/inactive_mag_image = image(inactive_mag.icon, target, inactive_mag.icon_state)
		inactive_mag_image.overlays += inactive_mag.overlays
		inactive_mag_image.pixel_x = 4
		inactive_mag_image.pixel_y = -1
		var/image/target_copy_image = image(target.icon, target, target.icon_state) //? I tried underlays, setting layers, vis content; this is the most painless one
		target_copy_image.overlays += target.overlays

		target.overlays += inactive_mag_image
		target.overlays += target_copy_image
	//* Add the velcro/zipper band
	var/image/magazine_bind = image('icons/obj/items/weapons/guns/jungle_style_bind.dmi', "zipper_band_b")
	magazine_bind.blend_mode = BLEND_INSET_OVERLAY
	target.overlays += magazine_bind

/datum/component/jungle_magazine/proc/reset_magazine_sprite(obj/item/ammo_magazine/target)
	is_reseting_sprite = TRUE
	// target.vis_contents.Cut()
	// target.vis_flags = 0
	// target.pixel_x = 0
	// target.pixel_y = 0
	target.overlays.Cut()
	target.underlays.Cut()
	target.update_icon()
	is_reseting_sprite = FALSE

/datum/component/jungle_magazine/proc/switch_active_magazine(mob/user, be_silent = FALSE)
	//Swaps magazine locations
	var/obj/item/ammo_magazine/old_mag = active_magazine()
	is_attached_magazine_active = !is_attached_magazine_active
	var/obj/item/ammo_magazine/new_mag = active_magazine()
	if(new_mag)
		if(user) //! This part sometimes breaks magically. Get help to think up a better way to handel switching mag entities
			user.drop_inv_item_on_ground(old_mag)
			user.put_in_hands(new_mag)
			old_mag.forceMove(new_mag)
			if(!be_silent)
				to_chat(user, SPAN_BLUE("You switched to use [new_mag]."))
		else //For when there's no user, if that is to happen
			var/old_loc = old_mag.loc
			old_mag.forceMove(get_turf(new_mag))
			new_mag.forceMove(old_loc)
			old_mag.forceMove(new_mag)
		//TODO: Update icon here
		reset_magazine_sprite(old_mag)
		reset_magazine_sprite(new_mag)
		add_overlay(new_mag)
	else
		is_attached_magazine_active = !is_attached_magazine_active
		if(user)
			to_chat(user, SPAN_WARNING("There is no magazine to switch to!"))

/datum/component/jungle_magazine/proc/active_magazine()
	if(is_attached_magazine_active)
		return attached_magazine
	return parent

/datum/component/jungle_magazine/proc/inactive_magazine()
	if(!is_attached_magazine_active)
		return attached_magazine
	return parent

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
		if(attached_magazine == 0)
			if (user)
				user.drop_inv_item_to_loc(M, parent)
			else //? Honestly don't know in what case would one add a magazine without an user; pending for remove if uneeded
				M.forceMove(parent)
			attached_magazine = M
			signal_reg(M)
			reset_magazine_sprite(M)
			reset_magazine_sprite(parent)
			add_overlay(parent) //TODO: yeah update the godamn icon
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
	//* Three Cases: 1) Remove parent magazine - Ejects everything and removes component
	//*              2) Remove attached magazine - Ejects attached magazine, allowing for fresh mags
	//*				 3) Remove attached magazine (attached is active) - Ditto, however magazine would be switched first / that or a special case idk
	//Doing this with if statement since there's only two magazines max
	var/obj/item/ammo_magazine/target_magazine
	if(attached_magazine != 0) //Case #2
		if(is_attached_magazine_active) //Case #3, so afterwards we know the prime mag is being seen as active mag
			switch_active_magazine(user, TRUE)
		target_magazine = attached_magazine
		if (user)
			user.put_in_hands(target_magazine)
		else
			target_magazine.forceMove(get_turf(parent))
		attached_magazine = 0
		signal_unreg(target_magazine)
		reset_magazine_sprite(target_magazine)
		reset_magazine_sprite(parent)
		add_overlay(parent)
	else //Case #1
		target_magazine = parent
		if(user)
			user.put_in_hands(binding_item)
			// user.put_in_hands(target_magazine) //Yea idk man the magazine is PROBABLY being HELD IN HAND
		else
			var/target_turf = get_turf(parent)
			binding_item.forceMove(target_turf)
			target_magazine.forceMove(target_turf)
		reset_magazine_sprite(target_magazine)
		src.Destroy() //Removes the component completely
	return TRUE

/datum/component/jungle_magazine/proc/get_examine_text(mob/user) //TODO: Clean up examine, make it easier to get the status of the other magazine
	. += "\n"
	. += SPAN_INFO("Use special action switch between magazines, use in hand eject magazines.")
	. += "\n"
	if (attached_magazine == 0) //If there's no attached magazine there really shouldn't be a need for description of the other mag, user WILL have parent as active
		. += "No magazine is attached at this moment."
	else
		var/obj/item/ammo_magazine/target_mag = inactive_magazine()
		. += SPAN_BLUE("Inactive Magazine: [icon2html(target_mag, user)] \a [target_mag] has [target_mag.current_rounds] out of [target_mag.max_rounds].")

/datum/component/jungle_magazine/proc/signal_reg(obj/item/ammo_magazine/target_magazine) //? Only expecting magazines here
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACKED, PROC_REF(on_attackby))
	RegisterSignal(target_magazine, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION, PROC_REF(on_unique_action))
	RegisterSignal(target_magazine, COMSIG_MAGAZINE_ATTEMPT_WITHDRAW_HANDFUL, PROC_REF(on_attempt_withdraw_handful))
	RegisterSignal(target_magazine, COMSIG_MAGAZINE_FINISH_UPDATE_ICON, PROC_REF(on_finish_update_magazine_icon))

/datum/component/jungle_magazine/proc/signal_unreg(obj/item/ammo_magazine/target_magazine)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACKED)
	UnregisterSignal(target_magazine, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION)
	UnregisterSignal(target_magazine, COMSIG_MAGAZINE_ATTEMPT_WITHDRAW_HANDFUL)
	UnregisterSignal(target_magazine, COMSIG_MAGAZINE_FINISH_UPDATE_ICON)
