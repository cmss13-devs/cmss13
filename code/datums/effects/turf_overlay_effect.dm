/datum/effects/turf_overlay_effect //should make this generic and the water_overlay a seperate thing
	effect_name = "turf_effect_overlay"
	icon_path = 'icons/effects/water_effects.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/will_alter_layerings = FALSE
	var/obj/effect/turf_overlay_effect/the_effect
	var/pixel_y_offset = 0

/datum/effects/turf_overlay_effect/New(atom/input_atom)
	.=..()

	the_effect = new /obj/effect/turf_overlay_effect()
	the_effect.owner = src

	update_icons(get_turf(input_atom))

/datum/effects/turf_overlay_effect/Destroy()
	QDEL_NULL(the_effect)
	the_effect = null

	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		animate(affected_human, pixel_y = initial(affected_human.pixel_y), 0.2 SECONDS)
		affected_human.update_effects()
		if(will_alter_layerings)
			affected_human.layer = initial(affected_human.layer )
			affected_human.plane = initial(affected_human.plane)
			for(var/obj/found_obj in affected_human.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		for(var/i in 1 to length(affected_human.vis_contents))
			if(istype(affected_human.vis_contents[i], /obj/effect/turf_overlay_effect))
				affected_human.vis_contents -= affected_human.vis_contents[i]
				qdel(the_effect)

	return ..()

/datum/effects/turf_overlay_effect/proc/update_icons(turf/open/input_openturf)
	obj_icon_state_path = input_openturf.icon_state
	mob_icon_state_path = input_openturf.icon_state

	if(ishuman(affected_atom))

		var/mob/living/carbon/human/affected_human = affected_atom
		var/old_will_alter_layerings = will_alter_layerings
		will_alter_layerings = abs(pixel_y_offset) >= 8 ? TRUE : FALSE
		affected_human.update_effects(will_alter_layerings ? ABOVE_MOB_LAYER	: FALSE)

		if(old_will_alter_layerings && !will_alter_layerings)
			affected_human.layer = initial(affected_human.layer )
			affected_human.plane = initial(affected_human.plane)
			for(var/obj/found_obj in affected_human.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			for(var/i in 1 to length(affected_human.vis_contents))
				if(istype(affected_human.vis_contents[i], /obj/effect/turf_overlay_effect))
					affected_human.vis_contents -= affected_human.vis_contents[i]
					qdel(the_effect)

		else if(will_alter_layerings)
			affected_human.layer = UNDER_TURF_LAYER - 0.01
			affected_human.plane = FLOOR_PLANE
			for(var/obj/found_obj in affected_human.vis_contents)
				found_obj.layer = UNDER_TURF_LAYER - 0.02
				found_obj.plane = FLOOR_PLANE

		animate(affected_human, pixel_y = pixel_y_offset, 0.2 SECONDS)
		if(will_alter_layerings)
			the_effect.set_up_icon(input_openturf, affected_atom, pixel_y_offset)
		else
			the_effect.overlays.Cut()
		affected_human.vis_contents |= the_effect

/obj/effect/turf_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	var/datum/effects/turf_overlay_effect/owner

/obj/effect/turf_overlay_effect/Destroy()
	. = ..()
	owner = null

/obj/effect/turf_overlay_effect/proc/adjust_transform(turf/open/input_openturf, mob/living/carbon/human/input_human, pixel_y_offset = 0)
	set_up_icon(input_openturf, input_human, pixel_y_offset)

/obj/effect/turf_overlay_effect/proc/set_up_icon(turf/open/input_openturf, mob/living/carbon/human/input_human, pixel_y_offset = 0)
	if(input_human.lying)
		var/matrix/matrix = matrix() //all this to make their face actually face the floor... sigh... I hate resting code
		switch(input_human.transform.b)
			if(1) //uh I have no idea how matricies work
				matrix.Turn(270)
			if(-1) //but I noticed these values were unique between the laying directions :0)
				matrix.Turn(90)
		pixel_y_offset = -12
		apply_transform(matrix)
	else
		apply_transform()

	overlays.Cut()
	var/icon/output_texture = icon(input_openturf.icon, input_openturf.icon_state)
	output_texture.Shift(SOUTH, pixel_y_offset, TRUE) //south since we want it opposite the + - of the value
	var/icon/subtraction_texture = icon('icons/effects/water_effects.dmi',"culling_mask")
	subtraction_texture.Shift(SOUTH, (32 - abs(pixel_y_offset)-3), FALSE)
	output_texture.AddAlphaMask(subtraction_texture)
	var/mutable_appearance/final_texture = mutable_appearance(output_texture)
	final_texture.layer = UNDER_TURF_LAYER
	final_texture.plane = FLOOR_PLANE
	overlays += final_texture



