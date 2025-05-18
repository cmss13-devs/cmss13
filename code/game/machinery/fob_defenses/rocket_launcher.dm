/obj/structure/machinery/rocket_launcher
	name = "rocket launcher"
	icon = 'icons/obj/structures/machinery/fob_machinery/rocket_launcher.dmi'
	icon_state = "rocket_launcher_undeployed"
	density = TRUE
	anchored = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	bound_width = 64
	bound_height = 32
	pixel_y = -16

/obj/structure/machinery/rocket_launcher/attackby(obj/item/attack_item, mob/user)
	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(clamp.loaded)
			return
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return
