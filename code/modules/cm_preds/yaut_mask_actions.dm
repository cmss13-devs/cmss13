/obj/item/clothing/mask/gas/yautja/var/aimed_shot_cooldown_delay = 4 SECONDS
/obj/item/clothing/mask/gas/yautja/var/aimed_shot_cooldown = 0
/obj/item/clothing/mask/gas/yautja/var/aiming_time = 1.5 SECONDS

// Aimed shot ability, but yautja
/datum/action/item_action/specialist/yautja_aimed_shot
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/yautja_aimed_shot/New(mob/living/user, obj/item/holder)
	..()
	name = "Aimed Shot"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/effects/Targeted.dmi', button, "locked-y")
	button.overlays += IMG

/*
		ACTIONS YAUTJA CAN TAKE
*/
/datum/action/item_action/specialist/yautja_aimed_shot/action_activate()
	if(!ishuman(owner))
		return
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

/datum/action/item_action/specialist/yautja_aimed_shot/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.lying && holder_item)
		return TRUE

/datum/action/item_action/specialist/yautja_aimed_shot/proc/use_ability(atom/A)
	var/mob/living/carbon/human/yautja = owner
	var/mob/living/target = locate() in get_turf(A)
	if (!target)
		return

	if(target.stat == DEAD)
		return

	var/obj/item/clothing/mask/gas/yautja/mask = holder_item
	if(world.time < mask.aimed_shot_cooldown)
		return

	if(!check_can_use(target))
		return

	mask.aimed_shot_cooldown = world.time + mask.aimed_shot_cooldown_delay

	yautja.face_atom(target)

	var/x_offset =  -target.pixel_x + target.base_pixel_x
	var/y_offset = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y

	var/image/locking_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locking-y")

	locking_icon.pixel_x = x_offset
	locking_icon.pixel_y = y_offset
	target.overlays += locking_icon

	if (yautja.client)
		playsound_client(yautja.client, 'sound/effects/nightvision.ogg', yautja, 25)
	playsound(target, 'sound/effects/nightvision.ogg', 25, FALSE, 5, falloff = 0.4)

	if(!do_after(yautja, 1 SECONDS, INTERRUPT_NONE, BUSY_ICON_HOSTILE))
		target.overlays -= locking_icon
		return

	target.overlays -= locking_icon

	var/image/locked_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locked-y")

	locked_icon.pixel_x = x_offset
	locked_icon.pixel_y = y_offset
	target.overlays += locked_icon

	if(!do_after(yautja, mask.aiming_time, INTERRUPT_NONE, BUSY_ICON_HOSTILE))
		target.overlays -= locked_icon
		return

	if(check_can_use(target, TRUE))
		yautja.face_atom(target)

		var/obj/item/weapon/gun/plasma_caster = yautja?:gloves?:caster
		plasma_caster.Fire(target, yautja)

	if(!do_after(yautja, 1 SECONDS, INTERRUPT_NONE, BUSY_ICON_HOSTILE))
		target.overlays -= locked_icon
		return

	target.overlays -= locked_icon

/datum/action/item_action/specialist/yautja_aimed_shot/proc/check_can_use(mob/M, active_shooter)
	var/obj/item/clothing/mask/gas/yautja/mask = holder_item
	var/mob/living/carbon/human/H = owner

	if(!can_use_action())
		return FALSE

	if(mask != H.wear_mask)
		to_chat(H, SPAN_WARNING("How do you expect to do this without your mask?"))
		return FALSE

	if(check_shot_is_blocked(H, M))
		to_chat(H, SPAN_WARNING("Something is in the way!"))
		return FALSE

	if(!active_shooter)
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/bracers = H.gloves
	if(!istype(bracers))
		return FALSE

	if(!bracers.caster_deployed)
		return FALSE

	return TRUE

/datum/action/item_action/specialist/yautja_aimed_shot/proc/check_shot_is_blocked(mob/firer, mob/target)
	var/list/turf/path = getline2(firer, target, include_from_atom = FALSE)
	if(!path.len)
		return TRUE

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.opacity)
			blocked = TRUE
			break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	return blocked
