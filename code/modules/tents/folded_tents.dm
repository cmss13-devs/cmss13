/obj/item/folded_tent
	name = "Folded Abstract Tent"
	icon = 'icons/obj/structures/tents_folded.dmi'
	/// Required cleared area along X axis
	var/dim_x = 1
	/// Required cleared area along Y axis
	var/dim_y = 1
	/// Map Template to use for the tent
	var/template

/// Check an area is clear for deployment of the tent
/obj/item/folded_tent/proc/check_area(turf/ref_turf, mob/message_receiver, display_error = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	. = TRUE
	var/list/turf_block = get_deployment_area(ref_turf)
	for(var/turf/turf as anything in turf_block)
		for(var/atom/movable/atom as anything in turf)
			if(ismob(atom) || (atom.density && atom.can_block_movement))
				if(message_receiver)
					to_chat(message_receiver, SPAN_WARNING("You cannot deploy the [src] here, something ([atom.name]) is in the way."))
				if(display_error)
					new /obj/effect/overlay/temp/tent_deployment_error(turf)
				return FALSE
	return TRUE

/obj/item/folded_tent/proc/unfold(turf/ref_turf)
	var/turf/starting_turf = locate(ref_turf.x, ref_turf.y, ref_turf.z)
	var/datum/map_template/template_instance = new template()
	template_instance.load(starting_turf, FALSE, FALSE)

/obj/item/folded_tent/proc/get_deployment_area(turf/ref_turf)
	RETURN_TYPE(/list/turf)
	var/turf/starting_turf = locate(ref_turf.x, ref_turf.y, ref_turf.z)
	var/turf/block_end_turf = locate(starting_turf.x + dim_x - 1, starting_turf.y + dim_y - 1, starting_turf.z)
	return block(starting_turf, block_end_turf)

/obj/item/folded_tent/attack_self(mob/living/user)
	. = ..()
	var/turf/deploy_turf = user.loc
	if(!istype(deploy_turf))
		return // In a locker or something. Get lost you already have a home.
	deploy_turf = get_step(deploy_turf, user.dir)
	if(!is_ground_level(deploy_turf.z))
		to_chat(user, SPAN_WARNING("USCM Operational Tents are intended for operations, not ship or space recreation."))
		return

	var/list/obj/effect/overlay/temp/tent_deployment_area/turf_overlay = list()
	var/list/turf/deployment_area = get_deployment_area(deploy_turf)
	for(var/turf/turf in deployment_area)
		turf_overlay += new /obj/effect/overlay/temp/tent_deployment_area(turf)

	if(!check_area(deploy_turf, user, TRUE))
		for(var/gfx as anything in turf_overlay)
			QDEL_IN(gfx, 1 SECONDS)
		return

	user.visible_message(SPAN_INFO("[user] starts deploying the [src]..."), \
		SPAN_WARNING("You start assembling the [src]... Stand still, it might take a bit to figure it out..."))
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	if(!check_area(deploy_turf, user, TRUE))
		for(var/gfx as anything in turf_overlay)
			QDEL_IN(gfx, 1 SECONDS)
		return

	unfold(deploy_turf)
	user.visible_message(SPAN_INFO("[user] finishes deploying the [src]!"), SPAN_INFO("You finish deploying the [src]!"))
	for(var/gfx as anything in turf_overlay)
		qdel(gfx)
	qdel(src) // Success!

/obj/item/folded_tent/cmd
	name = "Folded USCM Command Tent"
	icon_state = "cmd"
	dim_x = 2
	dim_y = 4
	template = /datum/map_template/tent/cmd

/obj/effect/overlay/temp/tent_deployment_error
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#bb0000"
	effect_duration = 1 SECONDS
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/temp/tent_deployment_area
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#ffa500"
	effect_duration = 10 SECONDS
	layer = FLY_LAYER
