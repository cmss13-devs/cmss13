
/datum/action
	var/name = "Generic Action"
	var/icon_file = 'icons/mob/hud/actions.dmi'
	var/action_icon_state
	var/button_icon_state
	var/obj/target = null
	var/atom/movable/screen/action_button/button = null
	var/mob/owner
	var/cooldown = 0 // By default an action has no cooldown
	/// The time when this ability can be used again
	var/ability_used_time = 0
	var/cost = 0 // By default an action has no cost -> will be utilized by skill actions/xeno actions
	var/action_flags = 0 // Check out __game.dm for flags
	/// Whether the action is hidden from its owner
	var/hidden = FALSE //Preserve action state while preventing mob from using action
	///Hide the action from the owner without preventing them from using it (incase of keybind listen_signal)
	var/player_hidden = FALSE
	var/unique = TRUE
	/// A signal on the mob that will cause the action to activate
	var/listen_signal

/datum/action/New(Target, override_icon_state)
	target = Target
	button = new
	if(target && isatom(target))
		var/image/IMG = image(target.icon, button, target.icon_state)
		IMG.pixel_x = 0
		IMG.pixel_y = 0
		button.overlays += IMG
	button.source_action = src
	button.name = name
	if(button_icon_state)
		button.icon_state = button_icon_state
	button.overlays += image(icon_file, button, override_icon_state || action_icon_state)

/datum/action/Destroy()
	if(owner)
		remove_from(owner)
	QDEL_NULL(button)
	target = null
	return ..()

/datum/action/proc/update_button_icon()
	if(!action_cooldown_check())
		button.color = rgb(120,120,120,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/proc/action_activate()
	SHOULD_CALL_PARENT(TRUE)

	if(cooldown)
		enter_cooldown()

	SEND_SIGNAL(src, COMSIG_ACTION_ACTIVATED)

/// handler for when a keybind signal is received by the action, calls the action_activate proc asynchronous
/datum/action/proc/keybind_activation()
	SIGNAL_HANDLER
	if(can_use_action())
		INVOKE_ASYNC(src, PROC_REF(action_activate))

/datum/action/proc/can_use_action()
	if(hidden)
		return FALSE
	if(!owner)
		return FALSE

	return action_cooldown_check()

/// Returns TRUE if cooldown is over
/datum/action/proc/action_cooldown_check()
	return ability_used_time <= world.time

/datum/action/proc/enter_cooldown(amount = cooldown)
	ability_used_time = world.time + amount

	update_button_icon()

	addtimer(CALLBACK(src, PROC_REF(update_button_icon)), amount)

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
	L.handle_add_action(src)
	if(listen_signal)
		RegisterSignal(L, listen_signal, PROC_REF(keybind_activation))
	owner = L

/mob/proc/handle_add_action(datum/action/action)
	LAZYADD(actions, action)
	if(client)
		client.add_to_screen(action.button)
	update_action_buttons()

/proc/remove_action(mob/L, action_path)
	for(var/a in L.actions)
		var/datum/action/A = a
		if(A.type == action_path)
			A.remove_from(L)
			return A

/datum/action/proc/remove_from(mob/L)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ACTION_REMOVED, L)
	if(listen_signal)
		UnregisterSignal(L, listen_signal)
	L.handle_remove_action(src)
	owner = null

/mob/proc/handle_remove_action(datum/action/action)
	actions?.Remove(action)
	if(client)
		client.remove_from_screen(action.button)
	update_action_buttons()

/mob/living/carbon/human/handle_remove_action(datum/action/action)
	if(selected_ability == action)
		action.action_activate()
	return ..()

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

/proc/get_action(mob/action_mob, action_path)
	for(var/datum/action/action in action_mob.actions)
		if(istype(action, action_path))
			return action

/datum/action/item_action
	name = "Use item"
	var/obj/item/holder_item //the item that has this action in its list of actions. Is not necessarily the target
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

	update_button_icon()

/datum/action/item_action/Destroy()
	LAZYREMOVE(holder_item.actions, src)
	holder_item = null
	return ..()

/datum/action/item_action/can_use_action()
	if(ishuman(owner) && !owner.is_mob_incapacitated())
		var/mob/living/carbon/human/human = owner
		if(human.body_position == STANDING_UP)
			return TRUE
	if((HAS_TRAIT(owner, TRAIT_OPPOSABLE_THUMBS)) && !owner.is_mob_incapacitated())
		return TRUE

/datum/action/item_action/update_button_icon()
	button.overlays.Cut()
	var/mutable_appearance/item_appearance = mutable_appearance(target.icon, target.icon_state, plane = ABOVE_TACMAP_PLANE)
	for(var/overlay in target.overlays)
		item_appearance.overlays += overlay
	button.overlays += item_appearance

/datum/action/item_action/toggle/New(Target)
	..()
	name = "Toggle [target]"
	button.name = name

/datum/action/item_action/toggle/action_activate()
	. = ..()
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, holder_item)

/datum/action/item_action/toggle/use/New(target)
	. = ..()
	name = "Use [target]"
	button.name = name

/datum/action/item_action/toggle/use/whistle/New(target)
	. = ..()
	action_icon_state = "whistle"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/stock/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/stock/update_button_icon()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/stock/S = G.attachments["stock"]
	if(!S.stock_activated)
		action_icon_state = "extend_stock"
	else
		action_icon_state = "extend_stock_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/scope/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/scope/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/scope/update_button_icon()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/scope/S = G.attachments["rail"]
	if(!S.using_scope)
		action_icon_state = "zoom_scope"
	else
		action_icon_state = "unzoom_scope"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/vulture_scope/update_button_icon()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/vulture_scope/scope = G.attachments["rail"]
	if(!scope.scoping)
		action_icon_state = "zoom_scope"
	else
		action_icon_state = "unzoom_scope"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/vulture_scope/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/vulture_scope/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/motion_detector/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/motion_detector/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/motion_detector/update_button_icon()
	if(!holder_item)
		return
	var/obj/item/device/motiondetector/detector = holder_item
	if(!detector.active)
		if(istype(detector, /obj/item/device/motiondetector/intel))
			action_icon_state = "data_detector"
		else
			action_icon_state = "motion_detector"
	else
		if(istype(detector, /obj/item/device/motiondetector/intel))
			action_icon_state = "data_detector_on"
		else
			action_icon_state = "motion_detector_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/lamp/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/lamp/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/lamp/update_button_icon()
	var/obj/item/clothing/suit/storage/marine/G = holder_item
	if(!G.light_on)
		action_icon_state = "armor_light"
	else
		action_icon_state = "armor_light_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/m56goggles/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/m56goggles/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/m56goggles/update_button_icon()
	var/obj/item/clothing/glasses/night = holder_item
	if(!night.deactive_state || night.active)
		action_icon_state = "sg_nv_off"
	else
		action_icon_state = "sg_nv"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/hudgoggles/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/hudgoggles/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/hudgoggles/update_button_icon()
	var/obj/item/clothing/glasses/hud_goggles = holder_item
	var/base_icon
	var/deactivate_state = "degoggles"

	if(istype(hud_goggles, /obj/item/clothing/glasses/hud/health))
		base_icon = "healthhud"
	else if(istype(hud_goggles, /obj/item/clothing/glasses/hud/security))
		base_icon = "securityhud"
	else if(istypestrict(hud_goggles, /obj/item/clothing/glasses/meson))
		base_icon = "meson"
	else if(istypestrict(hud_goggles, /obj/item/clothing/glasses/meson/refurbished))
		base_icon = "refurb_meson"
	else if(istype(hud_goggles, /obj/item/clothing/glasses/science))
		base_icon = "purple"
		deactivate_state = "purple_off"
	else
		base_icon = "healthhud"

	if(!hud_goggles.deactive_state || hud_goggles.active)
		action_icon_state = base_icon
	else
		action_icon_state = deactivate_state
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/flashlight/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/flashlight/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/flashlight/update_button_icon()
	var/obj/item/device/flashlight/light = holder_item
	var/action_icon_file = 'icons/mob/hud/actions.dmi'
	if(!light.light_on)
		if(istype(light, /obj/item/device/flashlight/lantern))
			action_icon_state = "lantern_on"
			if(istype(light, /obj/item/device/flashlight/lantern/yautja))
				action_icon_file = 'icons/mob/hud/actions_yautja.dmi'
				button.icon_state = "pred_template"
		else
			action_icon_state = "flashlight"
	else
		if(istype(light, /obj/item/device/flashlight/lantern))
			action_icon_state = "lantern_off"
			if(istype(light, /obj/item/device/flashlight/lantern/yautja))
				action_icon_file = 'icons/mob/hud/actions_yautja.dmi'
				button.icon_state = "pred_template"
		else
			action_icon_state = "flashlight_off"
	button.overlays.Cut()
	button.overlays += image(action_icon_file, button, action_icon_state)

/datum/action/item_action/toggle/flashlight_grip/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/flashlight_grip/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/flashlight_grip/update_button_icon()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/scope/S = G.attachments["under"]
	if(G.flags_gun_features & GUN_FLASHLIGHT_ON)
		if(istype(S, /obj/item/attachable/flashlight/grip))
			action_icon_state = "flash_grip_off"
		else
			action_icon_state = "combo_flash_off"
	else
		if(istype(S, /obj/item/attachable/flashlight/grip))
			action_icon_state = "flash_grip"
		else
			action_icon_state = "combo_flash"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/rail_flashlight/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/rail_flashlight/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/rail_flashlight/update_button_icon()
	if(holder_item.light_on)
		action_icon_state = "flashlight_off"
	else
		action_icon_state = "flashlight"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/bipod/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/bipod/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/bipod/bipods = firearm.attachments["under"]
	if(bipods.bipod_deployed)
		action_icon_state = "bipod_off"
	else
		action_icon_state = "bipod"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/nozzle/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/nozzle/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/attached_gun/flamer_nozzle/flamer = firearm.attachments["under"]
	if(firearm.active_attachable == flamer)
		action_icon_state = "nozzle_ball"
	else
		action_icon_state = "nozzle_spray"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/ubs/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/ubs/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/attached_gun/shotgun/shotty = firearm.attachments["under"]
	if(firearm.active_attachable == shotty)
		action_icon_state = "undershot_off"
	else
		action_icon_state = "undershot"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/ext/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/ext/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/attached_gun/extinguisher/foamer = firearm.attachments["under"]
	if(firearm.active_attachable == foamer)
		action_icon_state = "underext_off"
	else
		action_icon_state = "underext"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/flamer/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/flamer/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/attached_gun/flamer/burner = firearm.attachments["under"]
	if(firearm.active_attachable == burner)
		if(burner.intense_mode)
			action_icon_state = "underflamer_turbo_off"
		else
			action_icon_state = "underflamer_off"
	else
		if(burner.intense_mode)
			action_icon_state = "underflamer_turbo"
		else
			action_icon_state = "underflamer"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/ugl/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/ugl/update_button_icon()
	var/obj/item/weapon/gun/firearm = holder_item
	var/obj/item/attachable/attached_gun/grenade/bomber = firearm.attachments["under"]
	if(firearm.active_attachable == bomber)
		if(bomber.breech_open)
			action_icon_state = "undergl_breech"
		else
			action_icon_state = "undergl_off"
	else
		action_icon_state = "undergl"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/adjust_mask/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/adjust_mask/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/adjust_mask/update_button_icon()
	var/obj/item/clothing/mask/rebreather/scarf/coif = holder_item
	if(coif.pulled)
		if(istype(coif, /obj/item/clothing/mask/rebreather/scarf/tacticalmask))
			action_icon_state = "scarf_off"
		else
			action_icon_state = "coif_off"
	else
		if(istype(coif, /obj/item/clothing/mask/rebreather/scarf/tacticalmask))
			action_icon_state = "scarf"
		else
			action_icon_state = "coif"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/neckerchief/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/neckerchief/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/neckerchief/update_button_icon()
	var/obj/item/clothing/mask/neckerchief/chief = holder_item
	if(chief.adjust)
		action_icon_state = "neckerchief_off"
	else
		action_icon_state = "neckerchief"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle/helmet_nvg/New()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/helmet_nvg/action_activate()
	. = ..()
	update_button_icon()

/datum/action/item_action/toggle/helmet_nvg/update_button_icon()
	button.overlays.Cut()
	action_icon_state = "nvg"
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

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
				client.add_to_screen(A.button)
	else
		for(var/datum/action/A in actions)
			var/atom/movable/screen/action_button/B = A.button
			if(reload_screen)
				client.add_to_screen(B)
			if(A.hidden || A.player_hidden)
				B.screen_loc = null
				continue
			button_number++
			B.screen_loc = B.get_button_screen_loc(button_number)

		if(!button_number)
			hud_used.hide_actions_toggle.screen_loc = null
			if(reload_screen)
				client.add_to_screen(hud_used.hide_actions_toggle)
			return

	hud_used.hide_actions_toggle.screen_loc = hud_used.hide_actions_toggle.get_button_screen_loc(button_number+1)

	if(reload_screen)
		client.add_to_screen(hud_used.hide_actions_toggle)

