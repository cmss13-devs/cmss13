/obj/item/ammo_magazine/hardpoint/ltb_cannon
	name = "LTB Cannon Magazine"
	desc = "A primary armament cannon magazine."
	caliber = "86mm" //Making this unique on purpose
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "ltbcannon_4"
	w_class = SIZE_LARGE //Heavy fucker
	default_ammo = /datum/ammo/rocket/ltb
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/cannon
	/// Custom message engraved onto this shell, inherited by the fired projectile.
	var/engraved_message

/obj/item/ammo_magazine/hardpoint/ltb_cannon/update_icon()
	icon_state = "ltbcannon_[current_rounds]"

/**
 * Lets a marine scratch a message onto this shell with a hand labeler, a pen, or a bayonet.
 *
 * Bespoke flavor feature for the LTB cannon, not the generic label component other items use.
 *
 * Arguments:
 * * obj/item/I = The item used against the shell.
 * * mob/living/user = Whoever is engraving.
 * * bypass_hold_check = Unused here, kept for signature parity with the base attackby().
 */
/obj/item/ammo_magazine/hardpoint/ltb_cannon/attackby(obj/item/I, mob/living/user, bypass_hold_check = 0)
	. = ..()
	if(!is_engraving_tool(I))
		return

	var/new_message = copytext(reject_bad_text(tgui_input_text(user, "Engrave what onto [src]?", "Engrave Shell", engraved_message, MAX_NAME_LEN, ui_state = GLOB.not_incapacitated_state, encode = FALSE)), 1, MAX_NAME_LEN)
	new_message = trim_right(replace_non_alphanumeric_plus(new_message))

	if(QDELETED(src) || QDELETED(user) || !user.Adjacent(src) || !user.is_holding(I))
		return

	if(!new_message || !length(new_message))
		if(engraved_message)
			user.visible_message(SPAN_NOTICE("[user] scratches the engraving off [src]."), SPAN_NOTICE("You scratch the engraving off [src]."))
			clear_engraving()
		return

	if(new_message == engraved_message)
		to_chat(user, SPAN_WARNING("[src] is already engraved with \"[new_message]\"."))
		return

	if(length(name) + length(new_message) > 64)
		to_chat(user, SPAN_WARNING("That message is too long to fit on [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] engraves \"[new_message]\" onto [src] with \a [I]."), SPAN_NOTICE("You engrave \"[new_message]\" onto [src]."))
	set_engraving(new_message)

/// Whether I can be used to engrave this shell (hand labeler, pen, or any bayonet).
/obj/item/ammo_magazine/hardpoint/ltb_cannon/proc/is_engraving_tool(obj/item/I)
	if(istype(I, /obj/item/tool/hand_labeler))
		return TRUE
	if(istype(I, /obj/item/tool/pen))
		return TRUE
	return istype(I, /obj/item/attachable/bayonet)

/// Sets new_message as this shell's engraving, replacing any existing one.
/obj/item/ammo_magazine/hardpoint/ltb_cannon/proc/set_engraving(new_message)
	clear_engraving()
	engraved_message = new_message
	name += " \"[engraved_message]\""

/// Clears this shell's engraving, if any.
/obj/item/ammo_magazine/hardpoint/ltb_cannon/proc/clear_engraving()
	if(!engraved_message)
		return
	name = trim(replacetext(name, " \"[engraved_message]\"", ""))
	engraved_message = null

// Single-round alternative magazine, still istype()-matched against the hardpoint's cached ammo_type
/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell
	name = "86x455mm HE Shell"
	desc = "A single high-explosive 86x455mm shell for the LTB Cannon."
	icon_state = "lbtshell_1"
	max_rounds = 1

/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell/update_icon()
	icon_state = "lbtshell_[current_rounds]"
