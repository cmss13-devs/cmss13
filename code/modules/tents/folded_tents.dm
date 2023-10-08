/obj/item/folded_tent
	name = "Folded Abstract Tent"
	icon = 'icons/obj/structures/tents_folded.dmi'
	w_class = SIZE_LARGE
	/// Required cleared area along X axis
	var/dim_x = 1
	/// Required cleared area along Y axis
	var/dim_y = 1
	/// Deployment X offset
	var/off_x = 0
	/// Deployment Y offset
	var/off_y = 0
	/// Map Template to use for the tent
	var/template
	/// If this tent can be deployed anywhere
	var/unrestricted_deployment = FALSE

/// Check an area is clear for deployment of the tent
/obj/item/folded_tent/proc/check_area(turf/ref_turf, mob/message_receiver, display_error = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	. = TRUE
	var/list/turf_block = get_deployment_area(ref_turf)
	for(var/turf/turf as anything in turf_block)
		var/area/area = get_area(turf)
		if(!area.can_build_special && !unrestricted_deployment)
			if(message_receiver)
				to_chat(message_receiver, SPAN_WARNING("You cannot deploy tents on restricted areas."))
			if(display_error)
				new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
			return FALSE
		if(istype(turf, /turf/open/shuttle))
			if(message_receiver)
				to_chat(message_receiver, SPAN_BOLDWARNING("What are you doing?!! Don't build that on the shuttle please!"))
			return FALSE
		if(turf.density)
			if(message_receiver)
				to_chat(message_receiver, SPAN_WARNING("You cannot deploy the [src] here, something ([turf]) is in the way."))
			if(display_error)
				new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
			return FALSE
		for(var/atom/movable/atom as anything in turf)
			if(isliving(atom) || (atom.density && atom.can_block_movement) || istype(atom, /obj/structure/tent))
				if(message_receiver)
					to_chat(message_receiver, SPAN_WARNING("You cannot deploy the [src] here, something ([atom.name]) is in the way."))
				if(display_error)
					new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
				return FALSE
	return TRUE

/obj/item/folded_tent/proc/unfold(turf/ref_turf)
	var/datum/map_template/template_instance = new template()
	template_instance.load(ref_turf, FALSE, FALSE)

/obj/item/folded_tent/proc/get_deployment_area(turf/ref_turf)
	RETURN_TYPE(/list/turf)
	var/turf/block_end_turf = locate(ref_turf.x + dim_x - 1, ref_turf.y + dim_y - 1, ref_turf.z)
	return block(ref_turf, block_end_turf)

/obj/item/folded_tent/attack_self(mob/living/user)
	. = ..()
	var/turf/deploy_turf = user.loc
	if(!istype(deploy_turf))
		return // In a locker or something. Get lost you already have a home.

	switch(user.dir) // Fix up offset deploy location so tent is better centered + can be deployed under all angles
		if(NORTH)
			deploy_turf = locate(deploy_turf.x + off_x, deploy_turf.y + 1, deploy_turf.z)
		if(SOUTH)
			deploy_turf = locate(deploy_turf.x + off_x, deploy_turf.y - dim_y, deploy_turf.z)
		if(EAST)
			deploy_turf = locate(deploy_turf.x + 1, deploy_turf.y + off_y, deploy_turf.z)
		if(WEST)
			deploy_turf = locate(deploy_turf.x - dim_x, deploy_turf.y + off_y, deploy_turf.z)

	if(!istype(deploy_turf) || (deploy_turf.x + dim_x > world.maxx) || (deploy_turf.y + dim_y > world.maxy)) // Map border basically
		return

	if(!is_ground_level(deploy_turf.z) && !unrestricted_deployment)
		to_chat(user, SPAN_WARNING("USCM Operational Tents are intended for operations, not ship or space recreation."))
		return

	var/list/obj/effect/overlay/temp/tent_deployment_area/turf_overlay = list()
	var/list/turf/deployment_area = get_deployment_area(deploy_turf)

	if(!check_area(deploy_turf, user, TRUE))
		for(var/turf/turf in deployment_area)
			new /obj/effect/overlay/temp/tent_deployment_area(turf) // plus error in check_area
		return

	for(var/turf/turf in deployment_area)
		turf_overlay += new /obj/effect/overlay/temp/tent_deployment_area/casting(turf)

	user.visible_message(SPAN_INFO("[user] starts deploying the [src]..."), \
		SPAN_WARNING("You start assembling the [src]... Stand still, it might take a bit to figure it out..."))
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		for(var/gfx in turf_overlay)
			qdel(gfx)
		return

	if(!check_area(deploy_turf, user, TRUE))
		for(var/gfx in turf_overlay)
			QDEL_IN(gfx, 1.5 SECONDS)
		return

	unfold(deploy_turf)
	user.visible_message(SPAN_INFO("[user] finishes deploying the [src]!"), SPAN_INFO("You finish deploying the [src]!"))
	for(var/gfx in turf_overlay)
		qdel(gfx)
	qdel(src) // Success!

/obj/item/folded_tent/cmd
	name = "folded USCM Command Tent"
	icon_state = "cmd"
	desc = "A standard USCM Command Tent. This one comes equipped with a self-powered Overwatch Console and a Telephone. Unfold in a suitable location to maximize usefulness. Staff Officer not included. ENTRANCE TO THE SOUTH."
	dim_x = 2
	dim_y = 4
	off_x = -1
	template = /datum/map_template/tent/cmd

/obj/item/folded_tent/med
	name = "folded USCM Medical Tent"
	icon_state = "med"
	desc = "A standard USCM Medical Tent. This one comes equipped with advanced field surgery facilities. Unfold in a suitable location to maximize health gains. Surgical Tray not included. ENTRANCE TO THE SOUTH."
	dim_x = 2
	dim_y = 4
	template = /datum/map_template/tent/med

/obj/item/folded_tent/reqs
	name = "folded USCM Requisitions Tent"
	icon_state = "req"
	desc = "A standard USCM Requisitions Tent. Now, you can enjoy req line anywhere you go! Unfold in a suitable location to maximize resource distribution. ASRS not included. ENTRANCE TO THE SOUTH."
	dim_x = 4
	dim_y = 4
	off_x = -2
	template = /datum/map_template/tent/reqs

/obj/item/folded_tent/big
	name = "folded USCM Big Tent"
	icon_state = "big"
	desc = "A standard USCM Tent. This one is just a bigger, general purpose version. Unfold in a suitable location for maximum FOB vibes. Mess Tech not included. ENTRANCE TO THE SOUTH."
	dim_x = 3
	dim_y = 4
	off_x = -2
	template = /datum/map_template/tent/big

/obj/effect/overlay/temp/tent_deployment_error
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#bb0000"
	effect_duration = 1.5 SECONDS
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/temp/tent_deployment_area
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#f39e00"
	effect_duration = 1.5 SECONDS
	layer = FLY_LAYER

/obj/effect/overlay/temp/tent_deployment_area/casting
	effect_duration = 10 SECONDS
	color = "#228822"

/obj/effect/overlay/temp/tent_deployment_area/error
	layer = ABOVE_FLY_LAYER
	color = "#bb0000"
