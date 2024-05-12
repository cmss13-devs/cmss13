/obj/structure/closet/phonebox
	name = "phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are... It seems the line is down though."
	icon = 'icons/obj/structures/props/phonebox .dmi'
	icon_state = "phonebox_off_empty_closed"
	bound_width = 32
	bound_height = 64
	material = MATERIAL_METAL
	anchored = TRUE
	layer = BETWEEN_OBJECT_ITEM_LAYER

	open_sound = 'sound/effects/metal_door_open.ogg'
	close_sound = 'sound/effects/metal_door_close.ogg'

/obj/structure/closet/phonebox/update_icon()
	icon_state = "phonebox_on_open"
	if(!opened)
		icon_state = "phonebox_on_empty_closed"
		for(var/mob/M in src)
			icon_state = "phonebox_on_full_closed"
