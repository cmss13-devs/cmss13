//* //////////////////////////////
// 			DATUM CODE 			//
////////////////////////////// *//

/datum/effects/display_effect			// used to display stuff on things
	effect_name = "display_effect"
	icon_path = 'icons/effects/display_effects.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/will_alter_layerings = FALSE
	var/obj/effect/display_effect/the_effect
	var/pixel_y_offset = 0

/datum/effects/display_effect/New(atom/input_atom)
	.=..()

	the_effect = new /obj/effect/display_effect()
	the_effect.owner = input_atom

	var/turf/open/gm/T = get_turf(input_atom)
	if(istype(T, /turf/open/gm))
		pixel_y_offset = T.depth
	else
		debug_log("something went catastrophically wrong, this code should only be called from turfs with depth")
	update_icons(get_turf(input_atom))

/datum/effects/display_effect/Destroy()
	QDEL_NULL(the_effect)
	the_effect = null

	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(isliving(affected_atom))
		var/mob/living/affected_mob = affected_atom
		animate(affected_mob, pixel_y = initial(affected_mob.pixel_y), 0.2 SECONDS)
		if(ishuman(affected_mob))
			var/mob/living/carbon/human/affected_human = affected_mob
			affected_human.update_effects()
		if(will_alter_layerings)
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		for(var/i in 1 to length(affected_mob.vis_contents))
			if(istype(affected_mob.vis_contents[i], /obj/effect/display_effect))
				affected_mob.vis_contents -= affected_mob.vis_contents[i]
				qdel(the_effect)

	return ..()

/datum/effects/display_effect/proc/update_icons(turf/open/input_openturf) //called by: /datum/effects/display_effect/New(), /datum/component/display_effect/InheritComponent(), /datum/component/display_effect/proc/update_turf_overlays_effects()
	if(!pixel_y_offset)
		mob_icon_state_path = null
		obj_icon_state_path = null
	else
		obj_icon_state_path = input_openturf.icon_state
		mob_icon_state_path = input_openturf.icon_state


	if(isliving(affected_atom))
		var/mob/living/affected_mob = affected_atom
		var/old_will_alter_layerings = will_alter_layerings
		will_alter_layerings = abs(pixel_y_offset) >= 1 ? TRUE : FALSE //if theres a meaningful difference in depth then we'll do something
		if(ishuman(affected_mob))
			var/mob/living/carbon/human/affected_human = affected_mob
			affected_human.update_effects(will_alter_layerings ? ABOVE_MOB_LAYER : FALSE)

		if(old_will_alter_layerings && !will_alter_layerings)
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			for(var/i in 1 to length(affected_mob.vis_contents))
				if(istype(affected_mob.vis_contents[i], /obj/effect/display_effect))
					affected_mob.vis_contents -= affected_mob.vis_contents[i]
					qdel(the_effect)

		else if(will_alter_layerings)
			affected_mob.layer = UNDER_TURF_LAYER - 0.01
			affected_mob.plane = FLOOR_PLANE
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = UNDER_TURF_LAYER - 0.02
				found_obj.plane = FLOOR_PLANE

		animate(affected_mob, pixel_y = pixel_y_offset, 0.2 SECONDS)
		if(will_alter_layerings)
			the_effect.set_up_icon(input_openturf, affected_atom, pixel_y_offset)
		else
			the_effect.overlays.Cut()
		affected_mob.vis_contents |= the_effect

//* //////////////////////////////
// 			OBJECT CODE			//
////////////////////////////// *//

/obj/effect/display_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	var/datum/effects/display_effect/owner

/obj/effect/display_effect/Destroy()
	. = ..()
	owner = null

/obj/effect/display_effect/proc/adjust_transform(turf/open/input_openturf, mob/living/input_living, pixel_y_offset = 0)
	set_up_icon(input_openturf, input_living, pixel_y_offset)

/obj/effect/display_effect/proc/set_up_icon(turf/open/input_openturf, mob/living/input_living, pixel_y_offset = 0)
	if(input_living.resting)
		var/matrix/matrix = matrix() //all this to make their face actually face the floor... sigh... I hate resting code
		switch(input_living.transform.b)
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

	var/icon/subtraction_texture = icon('icons/effects/display_effects.dmi',"culling_mask")
	subtraction_texture.Shift(SOUTH, (32 - abs(pixel_y_offset)-3), FALSE)

	var/icon/I = icon(input_living.icon, input_living.icon_state)
	if(I.Width() > 32)
		output_texture.Shift(EAST, 16, FALSE)
		subtraction_texture.Shift(EAST, 16, FALSE)
	output_texture.AddAlphaMask(subtraction_texture)

	var/mutable_appearance/final_texture = mutable_appearance(output_texture)
	final_texture.layer = UNDER_TURF_LAYER
	final_texture.plane = FLOOR_PLANE
	overlays += final_texture

