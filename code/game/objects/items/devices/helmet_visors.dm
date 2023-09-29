/obj/item/device/helmet_visor
	name = "squad optic"
	desc = "An insertable visor HUD into a standard USCM helmet."
	icon = 'icons/obj/items/clothing/helmet_visors.dmi'
	icon_state = "hud_sight"
	w_class = SIZE_TINY

	///The type of HUD our visor shows
	var/hud_type = MOB_HUD_FACTION_USCM

	///The sound when toggling on the visor
	var/toggle_on_sound = 'sound/handling/hud_on.ogg'

	///The sound when toggling off the visor
	var/toggle_off_sound = 'sound/handling/hud_off.ogg'

	///The icon name for our helmet's action, in 'icons/obj/items/clothing/helmet_visors.dmi'
	var/action_icon_string = "hud_sight_down"

	///The overlay name for when our visor is active, in 'icons/mob/humans/onmob/helmet_garb.dmi'
	var/helmet_overlay = "hud_sight_right"

/obj/item/device/helmet_visor/Destroy(force)
	if(!istype(loc, /obj/item/clothing/head/helmet/marine))
		return ..()

	if(!istype(loc?.loc, /mob/living/carbon/human))
		return ..()

	var/obj/item/clothing/head/helmet/marine/attached_helmet = loc
	var/mob/living/carbon/human/user = loc.loc
	deactivate_visor(attached_helmet, user)
	. = ..()

/// Called to see if the user can even use this visor
/obj/item/device/helmet_visor/proc/can_toggle(mob/living/carbon/human/user)
	return TRUE

/// Called to see if this visor is a special non-HUD visor
/obj/item/device/helmet_visor/proc/toggle_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user, silent = FALSE)
	if(attached_helmet == user.head && attached_helmet.active_visor == src)

		if(!can_toggle(user))
			return FALSE

		activate_visor(attached_helmet, user)

		if(!silent)
			to_chat(user, SPAN_NOTICE("You activate [src] on [attached_helmet]."))
			playsound_client(user.client, toggle_on_sound, null, 75)

		return TRUE

	deactivate_visor(attached_helmet, user)

	if(!silent)
		to_chat(user, SPAN_NOTICE("You deactivate [src] on [attached_helmet]."))
		playsound_client(user.client, toggle_off_sound, null, 75)

	return TRUE

/// Called by toggle_visor() to activate the visor's effects
/obj/item/device/helmet_visor/proc/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	var/datum/mob_hud/current_mob_hud = huds[hud_type]
	current_mob_hud.add_hud_to(user, attached_helmet)

/// Called by toggle_visor() to deactivate the visor's effects
/obj/item/device/helmet_visor/proc/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	var/datum/mob_hud/current_mob_hud = huds[hud_type]
	current_mob_hud.remove_hud_from(user, attached_helmet)

/// Called by /obj/item/clothing/head/helmet/marine/get_examine_text(mob/user) to get extra examine text for this visor
/obj/item/device/helmet_visor/proc/get_helmet_examine_text()
	return SPAN_NOTICE("\A [name] is flipped down.")

/obj/item/device/helmet_visor/medical
	name = "basic medical optic"
	icon_state = "med_sight"
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	action_icon_string = "med_sight_down"
	helmet_overlay = "med_sight_right"

/obj/item/device/helmet_visor/medical/advanced
	name = "advanced medical optic"
	helmet_overlay = "med_sight_left"

/obj/item/device/helmet_visor/medical/advanced/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	var/datum/action/item_action/view_publications/publication_action = new(attached_helmet)
	publication_action.give_to(user)

/obj/item/device/helmet_visor/medical/advanced/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	var/datum/action/item_action/view_publications/publication_action = locate() in attached_helmet.actions
	qdel(publication_action)

/obj/item/device/helmet_visor/medical/advanced/can_toggle(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_NOTICE("You are not skilled enough to use [src]."))
		return FALSE

	return TRUE

/obj/item/device/helmet_visor/security
	name = "security optic"
	icon_state = "sec_sight"
	hud_type = MOB_HUD_SECURITY_ADVANCED
	action_icon_string = "sec_sight_down"
	helmet_overlay = "sec_sight_right"

/obj/item/device/helmet_visor/welding_visor
	name = "welding visor"
	icon_state = "sight_empty"
	hud_type = null
	action_icon_string = "blank_hud_sight_down"
	helmet_overlay = "weld_visor"

/obj/item/device/helmet_visor/welding_visor/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	attached_helmet.vision_impair = VISION_IMPAIR_MAX
	attached_helmet.flags_inventory |= COVEREYES|COVERMOUTH
	attached_helmet.flags_inv_hide |= HIDEEYES|HIDEFACE
	attached_helmet.eye_protection = EYE_PROTECTION_WELDING
	user.update_tint()

/obj/item/device/helmet_visor/welding_visor/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	attached_helmet.vision_impair = VISION_IMPAIR_NONE
	attached_helmet.flags_inventory &= ~(COVEREYES|COVERMOUTH)
	attached_helmet.flags_inv_hide &= ~(HIDEEYES|HIDEFACE)
	attached_helmet.eye_protection = EYE_PROTECTION_NONE
	user.update_tint()

/obj/item/device/helmet_visor/welding_visor/mercenary
	helmet_overlay = ""

/obj/item/device/helmet_visor/welding_visor/tanker
	helmet_overlay = "tanker_weld_visor"

#define NVG_VISOR_USAGE(delta_time) (power_cell.use(power_use * (delta_time ? delta_time : 1)))

/obj/item/device/helmet_visor/night_vision
	name = "night vision optic"
	desc = "An insertable visor HUD into a standard USCM helmet. This type gives a form of night vision and is standard issue in units with regular funding."
	icon_state = "nvg_sight"
	hud_type = null
	action_icon_string = "nvg_sight_down"
	helmet_overlay = "nvg_sight_right"
	toggle_on_sound = 'sound/handling/toggle_nv1.ogg'
	toggle_off_sound = 'sound/handling/toggle_nv2.ogg'

	/// The internal battery for the visor
	var/obj/item/cell/high/power_cell

	/// About 5 minutes active use charge (hypothetically)
	var/power_use = 33

	/// The alpha of darkness we set to for the mob while the visor is on, not completely fullbright but see-able
	var/lighting_alpha = 100

/obj/item/device/helmet_visor/night_vision/Initialize(mapload, ...)
	. = ..()
	power_cell = new(src)

/obj/item/device/helmet_visor/night_vision/Destroy()
	power_cell = null
	. = ..()

/obj/item/device/helmet_visor/night_vision/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("It is currently at [round((power_cell.charge / power_cell.maxcharge) * 100)]% charge.")

/obj/item/device/helmet_visor/night_vision/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(on_update_sight))

	user.add_client_color_matrix("nvg_visor", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string("#7aff7a")))
	user.overlay_fullscreen("nvg_visor", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("nvg_visor_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	user.update_sight()
	START_PROCESSING(SSobj, src)

/obj/item/device/helmet_visor/night_vision/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	user.remove_client_color_matrix("nvg_visor", 1 SECONDS)
	user.clear_fullscreen("nvg_visor", 0.5 SECONDS)
	user.clear_fullscreen("nvg_visor_blur", 0.5 SECONDS)

	UnregisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT)

	user.update_sight()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/helmet_visor/night_vision/process(delta_time)
	if(!NVG_VISOR_USAGE(delta_time))

		if(!istype(loc, /obj/item/clothing/head/helmet/marine))
			return PROCESS_KILL

		if(!istype(loc?.loc, /mob/living/carbon/human))
			return PROCESS_KILL

		var/obj/item/clothing/head/helmet/marine/attached_helmet = loc
		var/mob/living/carbon/human/user = loc.loc
		to_chat(user, SPAN_NOTICE("[src] deactivates as the battery goes out."))
		deactivate_visor(attached_helmet, user)
		return PROCESS_KILL

/obj/item/device/helmet_visor/night_vision/can_toggle(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(!NVG_VISOR_USAGE(FALSE))
		to_chat(user, SPAN_NOTICE("Your [src] is out of power! You'll need to recharge it."))
		return FALSE

	return TRUE

/obj/item/device/helmet_visor/night_vision/get_helmet_examine_text()
	. = ..()

	. += SPAN_NOTICE(" It is currently at [round((power_cell.charge / power_cell.maxcharge) * 100)]% charge.")

/obj/item/device/helmet_visor/night_vision/proc/on_update_sight(mob/user)
	SIGNAL_HANDLER

	if(lighting_alpha < 255)
		user.see_in_dark = 12
	user.lighting_alpha = lighting_alpha
	user.sync_lighting_plane_alpha()

#undef NVG_VISOR_USAGE

/obj/item/device/helmet_visor/night_vision/marine_raider
	name = "advanced night vision optic"
	desc = "An insertable visor HUD into a standard USCM helmet. This type gives a form of night vision and is standard issue in special forces units."
	hud_type = list(MOB_HUD_FACTION_USCM, MOB_HUD_MEDICAL_ADVANCED)
	power_use = 0

/obj/item/device/helmet_visor/night_vision/marine_raider/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = huds[type]
		current_mob_hud.add_hud_to(user, attached_helmet)

/obj/item/device/helmet_visor/night_vision/marine_raider/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = huds[type]
		current_mob_hud.remove_hud_from(user, attached_helmet)

/obj/item/device/helmet_visor/night_vision/marine_raider/process(delta_time)
	return PROCESS_KILL
