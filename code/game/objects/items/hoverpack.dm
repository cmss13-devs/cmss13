//most code (and the sound) stolen from https://github.com/tgstation/TerraGov-Marine-Corps/pull/5811, thank you BraveMole
/obj/item/hoverpack
	name = "experimental hoverpack"
	desc = "This prototype hoverpack allows marines to quickly jump over to strategic locations on the battlefield, at the cost of their backpack."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "hoverpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	actions_types = list(/datum/action/item_action/hover)
	var/total_uses = 20
	var/max_uses = 20
	var/hover_cooldown = 10 SECONDS
	 /// If you can use it, used for cooldowns.
	var/can_hover = TRUE
	 /// Last time you hovered, used for cooldown time checks.
	var/last_hover

	// These vars change in attackby().
	var/fuel_usage = 1
	 ///How quick you will fly
	var/speed = 5
	 ///How many tiles you can leap to at once.
	var/max_distance = 4

/obj/item/hoverpack/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/hoverpack/update_icon()
	overlays.Cut()
	. = ..()
	if(!can_hover || total_uses < fuel_usage)
		return
	var/image/I = image(icon, "+[icon_state]_charged")
	overlays += I

/obj/item/hoverpack/attackby(obj/item/W, mob/user)
	. = ..()
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		var/input = tgui_input_list(usr, "Change the gas tank's pressure?", "Select an intensity level", list("Strong (Dash)", "Normal (Jump)", "Weak (Leap)"))
		if(!input)
			return
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
		switch(input)
			if("Strong (Dash)")
				speed = 6
				max_distance = 2
				fuel_usage = 1
				hover_cooldown = 5 SECONDS
			if("Normal (Jump)")
				speed = 5
				max_distance = 4
				fuel_usage = 1
				hover_cooldown = 10 SECONDS
			if("Weak (Leap)")
				speed = 4.5
				max_distance = 7
				fuel_usage = 0.5
				hover_cooldown = 5 SECONDS

		to_chat(user, SPAN_NOTICE("You set the hoverpack's pressure output to [input]."))

/obj/item/hoverpack/examine(mob/user)
	. = ..()
	if(total_uses == 0)
		to_chat(user, SPAN_WARNING("The gas gauge meter indicates it has no gas left."))
	else
		to_chat(user, SPAN_NOTICE("The gas gauge meter indicates it has [total_uses/max_uses * 100]% gas left. You see on a readout:"))
	to_chat(user, SPAN_BOLDNOTICE(" DISTANCE: [max_distance] METERS <br/> SPEED: [speed] METERS PER SECOND <br/> USAGE: [fuel_usage * 100]% GAS USAGE <br/> COOLDOWN: [hover_cooldown SECONDS] SECONDS"))

/obj/item/hoverpack/proc/hover(var/mob/living/carbon/human/user, atom/A)
	if(!can_use_hoverpack(user))
		return

	can_hover = FALSE
	last_hover = world.time
	update_icon()
	playsound(user, 'sound/items/jetpack_sound.ogg', 45, FALSE)
	total_uses = total_uses - fuel_usage
	user.update_inv_back()
	var/turf/t_turf = get_turf(A)
	var/obj/effect/warning/warning = new(t_turf)
	warning.color = "#D4AE1E"
	calculate_warning_turf(warning, user, t_turf)
	to_chat(user, SPAN_BOLDNOTICE(" GAS EXPENDED: [fuel_usage/max_uses * 100]% <br> GAS REMAINING: [total_uses/max_uses * 100]%"))
	//has sleep
	user.throw_atom(t_turf, max_distance, speed, launch_type = HIGH_LAUNCH)
	qdel(warning)
	addtimer(CALLBACK(src, .proc/end_cooldown, user), hover_cooldown)

/obj/item/hoverpack/proc/end_cooldown(var/mob/living/carbon/human/user)
	can_hover = TRUE
	update_icon()
	playsound(user, 'sound/items/jetpack_beep.ogg', 45, TRUE)
	to_chat(user, SPAN_BOLDNOTICE("You can use \the [src] again."))

/obj/item/hoverpack/proc/calculate_warning_turf(var/obj/effect/warning/warning, var/mob/living/user, var/turf/t_turf)
	var/t_dist = get_dist(user, t_turf)
	if(!(t_dist > max_distance))
		return
	var/list/turf/path = getline2(user, t_turf, FALSE)
	warning.forceMove(path[max_distance])

/obj/item/hoverpack/proc/can_use_hoverpack(mob/living/carbon/human/user)
	if(!can_hover)
		to_chat(user, SPAN_WARNING("You cannot use the hoverpack yet!"))
		return FALSE

	if(total_uses <= fuel_usage)
		to_chat(user, SPAN_WARNING("The hoverpack ran out of gas!"))
		return FALSE
	return TRUE

/datum/action/item_action/hover/New(var/mob/living/user, var/obj/item/holder)
	..()
	name = "Use Hoverpack"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack_charged")
	button.overlays += IMG

/datum/action/item_action/hover/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(!H.is_mob_incapacitated() && !H.lying && holder_item == H.back)
		return TRUE

/datum/action/item_action/hover/action_activate()
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		H.selected_ability = null
	else
		to_chat(H, "You will now use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.selected_ability = null
		button.icon_state = "template_on"
		H.selected_ability = src

/datum/action/item_action/hover/update_button_icon()
	var/obj/item/hoverpack/HP = holder_item
	button.overlays.Cut()
	var/image/IMG
	if(!HP.can_hover)
		button.color = rgb(120,120,120,200)
		IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack")
	else
		button.color = rgb(255,255,255,255)
		IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack_charged")
	button.overlays += IMG

/datum/action/item_action/hover/proc/use_ability(atom/A)
	var/mob/living/carbon/human/H = owner
	var/obj/item/hoverpack/HP = holder_item
	HP.hover(H, A)
	update_button_icon()
	addtimer(CALLBACK(src, .proc/update_button_icon), HP.hover_cooldown)
