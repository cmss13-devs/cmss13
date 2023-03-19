/datum/effects/turf_overlay_effect //should make this generic and the water_overlay a seperate thing
	effect_name = "turf_effect_overlay"
	icon_path = 'icons/effects/water_effects.dmi'
	obj_icon_state_path
	mob_icon_state_path
	flags = INF_DURATION
	do_proccess = FALSE
	var/will_alter_layerings = FALSE
	var/obj/effect/turf_overlay_effect/the_effect

/datum/effects/turf_overlay_effect/New(atom/A, turf/open/O)
	..(A)

	the_effect = new /obj/effect/turf_overlay_effect()

	update_icons(O)

/datum/effects/turf_overlay_effect/Destroy()
	qdel(the_effect)
	the_effect = null

	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		animate(H, pixel_y = initial(H.pixel_y), 0.2 SECONDS)
		H.update_effects()
		if(will_alter_layerings)
			H.layer = initial(H.layer )
			H.plane = initial(H.plane)
			for(var/obj/found_obj in H.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		for(var/i in 1 to length(H.vis_contents))
			if(istype(H.vis_contents[i], /obj/effect/turf_overlay_effect))
				H.vis_contents -= H.vis_contents[i]
				qdel(the_effect)

	return ..()

/datum/effects/turf_overlay_effect/proc/update_icons(turf/open/O)
	obj_icon_state_path = O.icon_state
	mob_icon_state_path = O.icon_state

	if(ishuman(affected_atom))

		var/mob/living/carbon/human/H = affected_atom
		var/old_will_alter_layerings = will_alter_layerings
		will_alter_layerings = abs(O.pixel_y_offset) >= 8 ? TRUE : FALSE
		H.update_effects(will_alter_layerings ? ABOVE_MOB_LAYER	: FALSE)

		if(old_will_alter_layerings && !will_alter_layerings)
			H.layer = initial(H.layer )
			H.plane = initial(H.plane)
			for(var/obj/found_obj in H.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			for(var/i in 1 to length(H.vis_contents))
				if(istype(H.vis_contents[i], /obj/effect/turf_overlay_effect))
					H.vis_contents -= H.vis_contents[i]
					qdel(the_effect)

		else if(will_alter_layerings)
			H.layer = UNDER_TURF_LAYER - 0.01
			H.plane = FLOOR_PLANE
			for(var/obj/found_obj in H.vis_contents)
				found_obj.layer = UNDER_TURF_LAYER - 0.02
				found_obj.plane = FLOOR_PLANE

		animate(H, pixel_y = O.pixel_y_offset, 0.2 SECONDS)
		if(will_alter_layerings)
			the_effect.set_up_icon(O, affected_atom)
		else
			the_effect.overlays.Cut()
		H.vis_contents |= the_effect

/obj/effect/turf_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180

/obj/effect/turf_overlay_effect/proc/set_up_icon(turf/open/O, mob/living/carbon/human/H)
	overlays.Cut()
	var/mutable_appearance/muta_appppp = mutable_appearance('icons/effects/effects.dmi',"nothing")
	muta_appppp.appearance = O.appearance
	var/icon/output_texture = getFlatIcon(muta_appppp)
	output_texture.Shift(SOUTH, O.pixel_y_offset, TRUE) //south since we want it opposite the + - of the value
	var/icon/subtraction_texture = icon('icons/effects/water_effects.dmi',"culling_mask")
	subtraction_texture.Shift(SOUTH, (32 - abs(O.pixel_y_offset)-3), FALSE)
	output_texture.AddAlphaMask(subtraction_texture)
	var/mutable_appearance/final_texture = mutable_appearance(output_texture)
	final_texture.layer = UNDER_TURF_LAYER
	final_texture.plane = FLOOR_PLANE
	overlays += final_texture

