/obj/effect/landmark/resource_node
	icon_state = "landmark_node"

	var/resource_multiplier = 1
	var/is_area_controller = TRUE

/obj/effect/landmark/resource_node/Initialize(mapload, ...)
	. = ..()
	var/type_to_use = /obj/structure/resource_node


	if(is_area_controller)
		type_to_use = /obj/structure/resource_node/area_controller

	var/obj/structure/resource_node/RN = new type_to_use(loc, TRUE)
	RN.resources_per_second *= resource_multiplier
	return INITIALIZE_HINT_QDEL
