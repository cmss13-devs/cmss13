
/datum/action
	var/name = "Generic Action"
	var/action_icon_state
	var/obj/target = null
	var/obj/screen/action_button/button = null
	var/mob/living/owner
	var/cooldown = 0 // By default an action has no cooldown
	var/cost = 0 // By default an action has no cost -> will be utilized by skill actions/xeno actions
	var/action_flags = 0 // Check out __game.dm for flags

/datum/action/New(Target)
	target = Target
	button = new
	if(target)
		var/image/IMG = image(target.icon, button, target.icon_state)
		IMG.pixel_x = 0
		IMG.pixel_y = 0
		button.overlays += IMG
	button.source_action = src
	button.name = name

	if(action_icon_state)
		button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/Destroy()
	if(owner)
		remove_action(owner)
	qdel(button)
	button = null
	target = null
	return ..()

/datum/action/proc/update_button_icon()
	return

/datum/action/proc/action_activate()
	return

/datum/action/proc/can_use_action()
	if(owner) return TRUE

/datum/action/proc/give_action(mob/living/L)
	if(!L)
		return
	if(!L.actions)
		L.actions = list()
	if(owner)
		if(owner == L)
			return
		remove_action(owner)
	owner = L
	L.actions.Add(src)
	if(L.client)
		L.client.screen += button
	L.update_action_buttons()

/datum/action/proc/remove_action(mob/living/L)
	if(L.client)
		L.client.screen -= button
	L.actions.Remove(src)
	L.update_action_buttons()
	owner = null



/datum/action/item_action
	name = "Use item"
	var/obj/item/holder_item	//the item that has this action in its list of actions. Is not necessarily the target
								//e.g. gun attachment action: target = attachment, holder = gun.

/datum/action/item_action/New(Target, obj/item/holder)
	..()
	if(!holder)
		holder = target
	holder_item = holder
	holder_item.actions += src
	name = "Use [target]"
	button.name = name

/datum/action/item_action/Destroy()
	holder_item.actions -= src
	holder_item = null
	..()

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
	return

/mob/living/update_action_buttons(reload_screen)
	if(!hud_used || !client)
		return

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
			button_number++
			var/obj/screen/action_button/B = A.button
			B.screen_loc = B.get_button_screen_loc(button_number)
			if(reload_screen)
				client.screen += B

		if(!button_number)
			hud_used.hide_actions_toggle.screen_loc = null
			if(reload_screen)
				client.screen += hud_used.hide_actions_toggle
			return

	hud_used.hide_actions_toggle.screen_loc = hud_used.hide_actions_toggle.get_button_screen_loc(button_number+1)

	if(reload_screen)
		client.screen += hud_used.hide_actions_toggle

