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

	///The icon name for our helmet's action
	var/action_icon_string = "hud_sight_down"

	///The overlay name for when our visor is active
	var/helmet_overlay = "hud_sight_right"

/// Called to see if the user can even use this visor
/obj/item/device/helmet_visor/proc/can_toggle(mob/living/carbon/human/user)
	return TRUE

/// Called to see if this visor is a special non-HUD visor
/obj/item/device/helmet_visor/proc/visor_function(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user, silent = FALSE)
	var/datum/mob_hud/current_mob_hud = huds[hud_type]
	if(attached_helmet == user.head && attached_helmet.active_visor == src)
		current_mob_hud.add_hud_to(user, attached_helmet)
		if(!silent)
			to_chat(user, SPAN_NOTICE("You activate [src] on [attached_helmet]."))
		return TRUE

	current_mob_hud.remove_hud_from(user, attached_helmet)
	if(!silent)
		to_chat(user, SPAN_NOTICE("You deactivate [src] on [attached_helmet]."))
	return TRUE

/obj/item/device/helmet_visor/medical
	name = "basic medical optic"
	icon_state = "med_sight"
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	action_icon_string = "med_sight_down"
	helmet_overlay = "med_sight_right"

/obj/item/device/helmet_visor/medical/advanced
	name = "advanced medical optic"
	helmet_overlay = "med_sight_left"

/obj/item/device/helmet_visor/medical/advanced/can_toggle(mob/living/carbon/human/user)
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

/obj/item/device/helmet_visor/welding_visor/visor_function(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user, silent = FALSE)
	if(attached_helmet == user.head && attached_helmet.active_visor == src)
		attached_helmet.vision_impair = VISION_IMPAIR_MAX
		attached_helmet.flags_inventory |= COVEREYES|COVERMOUTH
		attached_helmet.flags_inv_hide |= HIDEEYES|HIDEFACE
		attached_helmet.eye_protection = EYE_PROTECTION_WELDING
		user.update_tint()
		if(!silent)
			to_chat(user, SPAN_NOTICE("You activate [src] on [attached_helmet]."))
		return TRUE

	attached_helmet.vision_impair = VISION_IMPAIR_NONE
	attached_helmet.flags_inventory &= ~(COVEREYES|COVERMOUTH)
	attached_helmet.flags_inv_hide &= ~(HIDEEYES|HIDEFACE)
	attached_helmet.eye_protection = EYE_PROTECTION_NONE
	if(!silent)
		to_chat(user, SPAN_NOTICE("You deactivate [src] on [attached_helmet]."))
	user.update_tint()
	return TRUE

/obj/item/device/helmet_visor/welding_visor/mercenary
	helmet_overlay = ""

/obj/item/device/helmet_visor/welding_visor/tanker
	helmet_overlay = "tanker_weld_visor"
