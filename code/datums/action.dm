
/datum/action
	var/name = "Generic Action"
	var/action_icon_state
	var/obj/target = null
	var/obj/screen/action_button/button = null
	var/mob/owner
	var/cooldown = 0 // By default an action has no cooldown
	var/cost = 0 // By default an action has no cost -> will be utilized by skill actions/xeno actions
	var/action_flags = 0 // Check out __game.dm for flags
	/// Whether the action is hidden from its owner
	/// Useful for when you want to preserve action state while preventing
	/// a mob from using said action
	var/hidden = FALSE
	var/unique = TRUE

/datum/action/New(Target, override_icon_state)
	target = Target
	button = new
	if(target)
		var/image/IMG = image(target.icon, button, target.icon_state)
		IMG.pixel_x = 0
		IMG.pixel_y = 0
		button.overlays += IMG
	button.source_action = src
	button.name = name

	if(override_icon_state)
		button.overlays += image('icons/mob/hud/actions.dmi', button, override_icon_state)
	else if(action_icon_state)
		button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/Destroy()
	if(owner)
		remove_from(owner)
	QDEL_NULL(button)
	target = null
	return ..()

/datum/action/proc/update_button_icon()
	return

/datum/action/proc/action_activate()
	return

/datum/action/proc/can_use_action()
	if(hidden)
		return FALSE

	if(owner)
		return TRUE

/datum/action/proc/set_name(new_name)
	name = new_name
	button.name = new_name

/**
 * Gives an action to a mob and returns it
 *
 * If mob already has the action, unhide it if it's hidden
 *
 * Can pass additional initialization args
 */
/proc/give_action(mob/L, action_path, ...)
	for(var/a in L.actions)
		var/datum/action/A = a
		if(A.unique && A.type == action_path)
			if(A.hidden)
				A.hidden = FALSE
				L.update_action_buttons()
			return A

	var/datum/action/action
	/// Cannot use arglist for both cases because of
	/// unique BYOND handling of args in New
	if(length(args) > 2)
		action = new action_path(arglist(args.Copy(3)))
	else
		action = new action_path()
	action.give_to(L)
	return action

/datum/action/proc/give_to(mob/L)
	SHOULD_CALL_PARENT(TRUE)
	if(owner)
		if(owner == L)
			return
		remove_from(owner)
	SEND_SIGNAL(src, COMSIG_ACTION_GIVEN, L)
	owner = L
	LAZYADD(L.actions, src)
	if(L.client)
		L.client.screen += button
	L.update_action_buttons()

/proc/remove_action(mob/L, action_path)
	for(var/a in L.actions)
		var/datum/action/A = a
		if(A.type == action_path)
			A.remove_from(L)
			return A

/datum/action/proc/remove_from(mob/L)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ACTION_REMOVED, L)
	L.actions.Remove(src)
	if(L.client)
		L.client.screen -= button
	owner = null
	L.update_action_buttons()

/proc/hide_action(mob/L, action_path)
	for(var/a in L.actions)
		var/datum/action/A = a
		if(A.type == action_path)
			A.hidden = TRUE
			L.update_action_buttons()
			return A

/datum/action/proc/hide_from(mob/L)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ACTION_HIDDEN, L)
	hidden = TRUE
	L.update_action_buttons()

/proc/unhide_action(mob/L, action_path)
	for(var/a in L.actions)
		var/datum/action/A = a
		if(A.type == action_path)
			A.hidden = FALSE
			L.update_action_buttons()
			return A

/datum/action/proc/unhide_from(mob/L)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ACTION_UNHIDDEN, L)
	hidden = FALSE
	L.update_action_buttons()


/datum/action/item_action
	name = "Use item"
	var/obj/item/holder_item	//the item that has this action in its list of actions. Is not necessarily the target
								//e.g. gun attachment action: target = attachment, holder = gun.
	unique = FALSE

/datum/action/item_action/New(Target, obj/item/holder)
	..()
	if(!holder)
		holder = target
	holder_item = holder
	LAZYADD(holder_item.actions, src)
	name = "Use [target]"
	button.name = name

/datum/action/item_action/Destroy()
	LAZYREMOVE(holder_item.actions, src)
	holder_item = null
	return ..()

/datum/action/item_action/action_activate()
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, holder_item)

/datum/action/item_action/can_use_action()
	if(ishuman(owner) && !owner.is_mob_incapacitated() && !owner.lying)
		return TRUE

/datum/action/item_action/update_button_icon()
	button.overlays.Cut()
	var/obj/item/I = target
	var/old = I.layer
	I.layer = FLOAT_LAYER
	button.overlays += I
	I.layer = old

/datum/action/item_action/toggle/New(Target)
	..()
	name = "Toggle [target]"
	button.name = name

//This is the proc used to update all the action buttons.
/mob/proc/update_action_buttons(reload_screen)
	if(!client)
		return

	if(!hud_used)
		create_hud()

	if(hud_used.hud_version == HUD_STYLE_NOHUD)
		return

	var/button_number = 0

	if(hud_used.action_buttons_hidden)
		for(var/datum/action/A in actions)
			A.button.screen_loc = null
			if(reload_screen)
				client.screen += A.button
	else
		for(var/datum/action/A in actions)
			var/obj/screen/action_button/B = A.button
			if(reload_screen)
				client.screen += B
			if(A.hidden)
				B.screen_loc = null
				continue
			button_number++
			B.screen_loc = B.get_button_screen_loc(button_number)

		if(!button_number)
			hud_used.hide_actions_toggle.screen_loc = null
			if(reload_screen)
				client.screen += hud_used.hide_actions_toggle
			return

	hud_used.hide_actions_toggle.screen_loc = hud_used.hide_actions_toggle.get_button_screen_loc(button_number+1)

	if(reload_screen)
		client.screen += hud_used.hide_actions_toggle

