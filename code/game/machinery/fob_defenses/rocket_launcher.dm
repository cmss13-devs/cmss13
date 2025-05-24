/obj/structure/machinery/rocket_launcher
	name = "\improper UH-99 Smart Rocket Launcher"
	desc = "Short range surface-to-surface rocket launcher system firing 60mm AMLE guided smart rockets. This system can be fired from behind cover, but it requires UE-04 Grid Sensors in order to paint targets."
	icon = 'icons/obj/structures/machinery/fob_machinery/rocket_launcher.dmi'
	icon_state = "rocket_launcher_undeployed"
	density = TRUE
	anchored = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	pixel_y = -16
	pixel_x = -16

/obj/structure/machinery/rocket_launcher/attackby(obj/item/attack_item, mob/user)
	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(clamp.loaded)
			return
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return
