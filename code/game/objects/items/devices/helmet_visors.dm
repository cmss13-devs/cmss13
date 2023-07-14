/obj/item/device/helmet_visor
	name = "squad optic"
	desc = "An insertable visor HUD into a standard USCM helmet."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = SIZE_TINY
	var/hud_type = MOB_HUD_FACTION_USCM
	var/toggle_on_sound = 'sound/handling/hud_on.ogg'
	var/toggle_off_sound = 'sound/handling/hud_off.ogg'

/obj/item/device/helmet_visor/medical
	name = "medical optic"
	hud_type = MOB_HUD_MEDICAL_ADVANCED
