/obj/effect/alien/resin/special/nest
	name = XENO_STRUCTURE_NEST
	desc = "A very thick nest, oozing with a thick sticky substance."
	pixel_x = -8
	pixel_y = -8

	mouse_opacity = MOUSE_OPACITY_ICON

	icon = 'icons/mob/xenos/structures48x48.dmi'
	icon_state = "reinforced_nest"
	health = 400
	var/obj/structure/bed/nest/structure/pred_nest

	block_range = 0

/obj/effect/alien/resin/special/nest/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && faction)
		. += "Used to secure formidable hosts."

/obj/effect/alien/resin/special/nest/Initialize(mapload)
	. = ..()

	pred_nest = new /obj/structure/bed/nest/structure(loc, faction.code_identificator, src) // Nest cannot be destroyed unless the structure itself is destroyed


/obj/effect/alien/resin/special/nest/Destroy()
	. = ..()

	pred_nest?.linked_structure = null
	QDEL_NULL(pred_nest)
