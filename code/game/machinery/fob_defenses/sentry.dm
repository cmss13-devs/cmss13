/obj/structure/machinery/sentry
	name = "\improper UH-46 Heavy Sentry Gun"
	desc = "Massive omni directional dual barrelled 30mm automated heavy sentry gun."
	icon = 'icons/obj/structures/machinery/fob_machinery/sentry.dmi'
	icon_state = "sentry_undeployed"
	density = TRUE
	anchored = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	pixel_x = -17
	var/datum/shape/rectangle/square/range_bounds
	var/ammo_type = /datum/ammo/bullet/turret/fob

/obj/structure/machinery/sentry/Initialize(mapload, ...)
	range_bounds = SQUARE(x, y, 15)

	. = ..()

/obj/structure/machinery/sentry/attackby(obj/item/attack_item, mob/user)
	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(clamp.loaded)
			return
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return

