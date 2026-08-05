/*
The two flags:
- JUNGLE_STYLE_ABLE [conflict.dm]
- JUNGLE_MAG_BINDER [equipment.dm]

Current Expected Characteristics:
- Apply binding item to a magazine to initiate this component on the magazine (from now one referenced as prime mag)
- Apply another magazine to prime magazine to add into the jungle mag
- Unique action to switch slots, which switches the magazine item in user's hand
- Use magazines in hand to dettach: if there is an attached mag, it would be ejected; if there is only prime mag, it would eject binding item and destroy the component
- Active magazine is represented graphcially as the top-left mag on the icon
- The jungle mag behaves like a normal mag does, except hanfuls can not be extracted from it while magazines are still attached, allowing the user to change which hand to hold the jungle mag

Current Problems:
- The ammo band on magazine does not heed to throwing animation or changing hand animation (does not rotate and does not fade in)
- Add SFX when switching "sound/weapons/handling/gun_underbarrel_deactivate.ogg"
- Add ways to manipulate magazine offset through arguments (just add more arguments for generating the overlay in general)
- " -make it so the jungle styled mag attacking another magazine also attaches it rather than being attacked"
- Improve the jungle mag sprite
*/

/datum/component/jungle_magazine
	///The item that initiated the jungle mag construct
	var/obj/item/binding_item
	var/is_attached_magazine_active = FALSE //It's two slots, 0 and 1
	///Default to zero for no attached mag
	var/attached_magazine = 0
	///Used to identify if the update_icon is called by the component (viz. the reseting sprite proc)
	var/is_reseting_sprite = FALSE

	//* Default overlay settings
	var/list/overlay_inactive_mag_offsets = list(5, 0)
	var/overlay_is_blend_inset = FALSE
	var/overlay_icon = 'icons/obj/items/weapons/guns/jungle_style_bind.dmi'
	var/overlay_icon_state = "zipper_band_b"

	//* Storage lists
	///Storage black lists
	var/list/generic_storage_black_list = list( //* Includes all the magazine belts and internal storages (armors, webbings)
		/obj/item/storage/belt,
		/obj/item/storage/internal,
	)

	///Storage white lists, higher precedence than black lists
	var/list/generic_storage_white_list = list(
		/obj/item/storage/internal/accessory/drop_pouch,
	) //? Could add specific belt to be whitelisted as well, like the dutch's belt or anything mentions jungle, it'd be funny

/datum/component/jungle_magazine/Initialize(mob/user, obj/item/trigger_item)
	if(!istype(parent, /obj/item/ammo_magazine))
		return COMPONENT_INCOMPATIBLE
	binding_item = trigger_item
	if(user)
		user.drop_inv_item_to_loc(binding_item, parent)
	else
		binding_item.forceMove(parent)

	if(istype(binding_item, /obj/item/jungle_mag_binders))
		var/obj/item/jungle_mag_binders/target = binding_item

		//Check if the binding item has unique overlay settings
		if(target.jungle_mag_overlay_inactive_mag_offsets)
			overlay_inactive_mag_offsets = target.jungle_mag_overlay_inactive_mag_offsets
		if(target.jungle_mag_overlay_is_blend_inset)
			overlay_is_blend_inset = target.jungle_mag_overlay_is_blend_inset
		if(target.jungle_mag_overlay_icon)
			overlay_icon = target.jungle_mag_overlay_icon
		if(target.jungle_mag_overlay_icon_state)
			overlay_icon_state = target.jungle_mag_overlay_icon_state

	add_overlay(parent, overlay_inactive_mag_offsets, overlay_is_blend_inset, overlay_icon, overlay_icon_state)

/datum/component/jungle_magazine/RegisterWithParent()
	signal_reg(parent)

/datum/component/jungle_magazine/UnregisterFromParent()
	signal_unreg(parent)


//* Signal Handlers***************************************************************************************
/datum/component/jungle_magazine/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER

	//Check if the incoming item is a magazine -> attempt to add the magazine
	if(istype(attacking_item, /obj/item/ammo_magazine))
		add_magazine(user, attacking_item)
		return COMPONENT_CANCEL_ITEM_ATTACK

/datum/component/jungle_magazine/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += get_examine_text(user)

/datum/component/jungle_magazine/proc/on_unique_action(datum/source, mob/user)
	SIGNAL_HANDLER

	switch_active_magazine(user)

/datum/component/jungle_magazine/proc/on_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER

	remove_magazine(user)

///Allow you to switch which hand is holding the jungle mag
/datum/component/jungle_magazine/proc/on_attempt_withdraw_handful(datum/source, mob/user)
	SIGNAL_HANDLER

	return COMPONENT_MAGAZINE_CANCEL_ATTEMPT_WITHDRAW_HANDFUL

///Update the overlay to have jungle mag after an update_icon is called on magazine
/datum/component/jungle_magazine/proc/on_finish_update_magazine_icon(obj/item/ammo_magazine/source)
	SIGNAL_HANDLER

	if(!is_reseting_sprite)
		reset_magazine_sprite(source)
		add_overlay(source, overlay_inactive_mag_offsets, overlay_is_blend_inset, overlay_icon, overlay_icon_state)


///Check against blacklists to stop jungle mag from going into certain storages
/datum/component/jungle_magazine/proc/on_attempt_insert_into_storage(obj/item/source, obj/item/storage/storage, prevent_warning, mob/user)
	SIGNAL_HANDLER

	for(var/whitelisted_type in generic_storage_white_list)
		if(istype(storage, whitelisted_type))
			return

	for(var/blacklisted_type in generic_storage_black_list)
		if(istype(storage, blacklisted_type))
			if(user && !prevent_warning)
				to_chat(user, SPAN_NOTICE("[storage] cannot hold [source]"))
			return COMPONENT_ITEM_CANCEL_INSERTION_INTO_STORAGE


//* Custom procs***************************************************************************************
///Creates an overlay for jungle mag
/datum/component/jungle_magazine/proc/add_overlay(obj/item/target, list/inactive_mag_offsets, is_blend_inset, band_icon, band_icon_state)
	if(attached_magazine != 0) //Only necessary if there's a magazine attached
		//* Add the inactive magazine icon
		var/obj/item/ammo_magazine/inactive_mag = inactive_magazine()
		var/image/inactive_mag_image = image(inactive_mag.icon, target, inactive_mag.icon_state)
		inactive_mag_image.overlays += inactive_mag.overlays
		inactive_mag_image.pixel_x = inactive_mag_offsets[1]
		inactive_mag_image.pixel_y = inactive_mag_offsets[2]
		var/image/target_copy_image = image(target.icon, target, target.icon_state)
		target_copy_image.overlays += target.overlays

		target.overlays += inactive_mag_image
		target.overlays += target_copy_image
	//* Add the velcro/zipper band
	var/image/magazine_bind = image(band_icon, band_icon_state)
	if(is_blend_inset)
		magazine_bind.blend_mode = BLEND_INSET_OVERLAY
	target.overlays += magazine_bind

///Cleans the magazine icon in conjuncture with the jungle mag overlay
/datum/component/jungle_magazine/proc/reset_magazine_sprite(obj/item/ammo_magazine/target)
	is_reseting_sprite = TRUE
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
		if(user) //Switch the old mag to new mag
			user.drop_inv_item_on_ground(old_mag)
			user.put_in_hands(new_mag)
			old_mag.forceMove(new_mag)
			if(!be_silent) //For internal use
				to_chat(user, SPAN_NOTICE("You switched to use [new_mag]."))
				playsound(user, 'sound/weapons/handling/gun_underbarrel_deactivate.ogg', 80)
		else //For when there's no user, if that is to happen
			var/old_loc = old_mag.loc
			old_mag.forceMove(get_turf(new_mag))
			new_mag.forceMove(old_loc)
			old_mag.forceMove(new_mag)
		//Updating icons after finish
		reset_magazine_sprite(old_mag)
		reset_magazine_sprite(new_mag)
		add_overlay(new_mag, overlay_inactive_mag_offsets, overlay_is_blend_inset, overlay_icon, overlay_icon_state)
	else
		is_attached_magazine_active = !is_attached_magazine_active //Revert the change, as no switch happened
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

/datum/component/jungle_magazine/proc/add_magazine(mob/user, obj/item/ammo_magazine/incoming_magazine) //? Used in construction phase
	if(istype(incoming_magazine)) //Checks if incoming item is a magazine
		if(attached_magazine == 0)
			if (user)
				user.drop_inv_item_to_loc(incoming_magazine, parent)
			else //In case there's no user
				incoming_magazine.forceMove(parent)
			attached_magazine = incoming_magazine
			signal_reg(incoming_magazine)
			reset_magazine_sprite(incoming_magazine)
			reset_magazine_sprite(parent)
			add_overlay(parent, overlay_inactive_mag_offsets, overlay_is_blend_inset, overlay_icon, overlay_icon_state)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("A magazine is already attached to the jungle magazine!"))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("[src] only accepts magazines!"))
		return FALSE

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
		add_overlay(parent, overlay_inactive_mag_offsets, overlay_is_blend_inset, overlay_icon, overlay_icon_state)
	else //Case #1
		target_magazine = parent
		if(user)
			user.put_in_hands(binding_item)
		else
			var/target_turf = get_turf(parent)
			binding_item.forceMove(target_turf)
			target_magazine.forceMove(target_turf)
		reset_magazine_sprite(target_magazine)
		src.Destroy() //Removes the component completely
	return TRUE

/datum/component/jungle_magazine/proc/get_examine_text(mob/user)
	. += SPAN_INFO("Use special action switch between magazines, use in hand eject magazines.")
	. += "\n"
	if (attached_magazine == 0) //If there's no attached magazine there really shouldn't be a need for description of the other mag, user WILL have parent as active
		. += "No magazine is attached at this moment."
	else
		var/obj/item/ammo_magazine/target_mag = inactive_magazine()
		. += SPAN_NOTICE("Inactive Magazine: [icon2html(target_mag, user)] \a [target_mag] has [target_mag.current_rounds] out of [target_mag.max_rounds].")

/datum/component/jungle_magazine/proc/signal_reg(obj/item/ammo_magazine/target_magazine) //? Only expecting magazines here
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACKED, PROC_REF(on_attackby))
	RegisterSignal(target_magazine, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION, PROC_REF(on_unique_action))
	RegisterSignal(target_magazine, COMSIG_MAGAZINE_ATTEMPT_WITHDRAW_HANDFUL, PROC_REF(on_attempt_withdraw_handful))
	RegisterSignal(target_magazine, COMSIG_MAGAZINE_FINISH_UPDATE_ICON, PROC_REF(on_finish_update_magazine_icon))
	RegisterSignal(target_magazine, COMSIG_ITEM_ATTEMPT_INSERTION_INTO_STORAGE, PROC_REF(on_attempt_insert_into_storage))

/datum/component/jungle_magazine/proc/signal_unreg(obj/item/ammo_magazine/target_magazine)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACKED)
	UnregisterSignal(target_magazine, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(target_magazine, COMSIG_ITEM_UNIQUE_ACTION)
	UnregisterSignal(target_magazine, COMSIG_MAGAZINE_ATTEMPT_WITHDRAW_HANDFUL)
	UnregisterSignal(target_magazine, COMSIG_MAGAZINE_FINISH_UPDATE_ICON)
	UnregisterSignal(target_magazine, COMSIG_ITEM_ATTEMPT_INSERTION_INTO_STORAGE)
