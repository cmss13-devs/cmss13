/obj/structure/machinery/sentry
	name = "sentry"
	icon = 'icons/obj/structures/machinery/fob_machinery/sentry.dmi'
	icon_state = "sentry_undeployed"
	density = TRUE
	anchored = TRUE
	bound_width = 64
	bound_height = 32
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	var/datum/shape/rectangle/square/range_bounds

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

