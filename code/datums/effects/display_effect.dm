//* //////////////////////////////
// 			DATUM CODE 			//
////////////////////////////// *//

/datum/effects/display_effect			// used to display stuff on things
	effect_name = "display_effect"
	icon_path = 'icons/effects/display_effects/_32.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/will_alter_layerings = FALSE
	var/obj/effect/display_effect/the_effect
	var/pixel_y_offset = 0
	var/list/icon_paths = list(
		'icons/effects/display_effects/_32.dmi',	//humans, etc
		'icons/effects/display_effects/_48.dmi',	//facehugger, drone
		'icons/effects/display_effects/_64.dmi', //most xenos
		'icons/effects/display_effects/_88.dmi',	//queen
	)

/datum/effects/display_effect/New(atom/input_atom, force_update=FALSE)
	.=..()

	the_effect = new /obj/effect/display_effect()
	the_effect.owner = src

	//queen footsteps
	if(isqueen(input_atom) || isking(input_atom))
		input_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	var/turf/open/gm/T = get_turf(input_atom)
	if(istype(T, /turf/open/gm))
		pixel_y_offset = T.depth
	else
		debug_log("something went catastrophically wrong, this code should only be called from turfs with depth")
	var/icon/reference = icon(input_atom.icon, input_atom.icon_state)
	var/ref_w = reference.Width()
	var/icon_path_key = ref_w<=32?1:(ref_w<=48?2:(ref_w<=64?3:ref_w<=88?4:5))
	icon_path = icon_paths[icon_path_key]
	if(force_update)
		update_icons(get_turf(input_atom))

/datum/effects/display_effect/Destroy()
	the_effect.Destroy()

	//queen footsteps
	if(isqueen(affected_atom) || isking(affected_atom))
		affected_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large")

	if(iscarbon(affected_atom))
		var/mob/living/carbon/affected_mob = affected_atom
		animate(affected_mob, pixel_y = initial(affected_mob.pixel_y), 0.2 SECONDS)
		mob_icon_state_path = null
		obj_icon_state_path = null
		affected_mob.update_effects()
		affected_mob.layer = initial(affected_mob.layer )
		affected_mob.plane = initial(affected_mob.plane)
		for(var/obj/found_obj in affected_mob.vis_contents)
			found_obj.layer = initial(found_obj.layer)
			found_obj.plane =  initial(found_obj.plane)
		for(var/i in 1 to length(affected_mob.vis_contents))
			if(istype(affected_mob.vis_contents[i], /obj/effect/display_effect))
				affected_mob.vis_contents -= affected_mob.vis_contents[i]
				qdel(the_effect)

	return ..() // we need to know what the mob is to destroy our stuff in its vis_contents

/datum/effects/display_effect/proc/update_icons(turf/open/input_openturf)
	var/on_coast = FALSE
	if(iscarbon(affected_atom))
		var/mob/living/carbon/affected_mob = affected_atom
		if("hauled" in affected_mob._status_traits || affected_mob.buckled)
			pixel_y_offset = 0
		// Handling the splahes effect using existing /datum/effects code
		obj_icon_state_path = input_openturf.icon_state //we use the turfs own icon_state as keys, since we want the splashes to be colored to match
		mob_icon_state_path = input_openturf.icon_state //and the splashes are sprited according to depth, as defined in these turfs
		affected_mob.update_effects()

		//layerings will be used in the case theres a dropoff.. ei turf south is high and the one we're in is "deep"
		will_alter_layerings = abs(pixel_y_offset) >= 1 ? TRUE : FALSE	//if theres a meaningful difference in depth then we'll need to change the layer of the affected mob so its "below" the dropoff
		if(!pixel_y_offset || input_openturf.covered) 											//firstly if theres no offset, theres no depth, meaning no need for the effect at all
			mob_icon_state_path = null
			obj_icon_state_path = null
			affected_mob.update_effects()
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
			animate(affected_mob, pixel_y = initial(affected_mob.pixel_y), 0.2 SECONDS)
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			var/datum/component/display_effect/found = affected_mob.GetComponent(/datum/component/display_effect)
			if(found)
				found.UnregisterFromParent()
				found.Destroy()
			return													//if there is a meaningful difference in depth, change layerings and animate the mob "down" to where it should be
		if(is_coastline(input_openturf)) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/seemingly be gradient of depth)
			on_coast = TRUE
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
		else
			affected_mob.layer = UNDER_TURF_LAYER - 0.01
			affected_mob.plane = FLOOR_PLANE
		for(var/obj/found_obj in affected_mob.vis_contents)
			found_obj.layer = UNDER_TURF_LAYER - 0.02
			found_obj.plane = FLOOR_PLANE
		animate(affected_mob, pixel_y = pixel_y_offset, 0.2 SECONDS)

		the_effect.set_up_icon(input_openturf, affected_atom, pixel_y_offset, on_coast)	//now that we have all the layerings sorted, we apply the image of water to cover the parts of the body in that depth
		affected_mob.vis_contents |= the_effect

//* //////////////////////////////		we use an object because critically it can be rotated differently from the mob its attached to (in case its resting)
// 			OBJECT CODE			//		and maybe adjust its alpha seperately, like if we wanted really murky water or something but still wanted splashes
////////////////////////////// *//		Also to handle clicks, we dont want to alter the hitboxes.. like we would by having these as part of the mob sprite

/obj/effect/display_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	vis_flags = VIS_INHERIT_DIR
	var/datum/effects/display_effect/owner

/obj/effect/display_effect/Destroy()
	. = ..()
	owner = null
	overlays.Cut()

/obj/effect/display_effect/proc/set_up_icon(turf/open/input_openturf, mob/living/input_living, pixel_y_offset = 0, on_coast = FALSE)
	if(input_living.resting)		//if the mob is resting, we need to rotate our water overlay
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

	overlays.Cut()	//clean slate, dont need the old overlay
	var/icon/water_overlay = icon(owner.icon_path,"empty")						//this is what will our water texture will be
	var/icon/subtraction_texture = icon(owner.icon_path,"culling_mask")			//this is the part of it we'll keep, rest will become "air"
	var/icon/turf_texture = icon(get_water_turf_iconstuff(input_openturf, "icon"), get_water_turf_iconstuff(input_openturf, "icon_state"))
	var/w_w = water_overlay.Width()												//this is the actual texture we'll use to create the water texture
	var/w_h = water_overlay.Height()
	var/t_t = turf_texture.Width()
	var/pieces_x = round(w_w / t_t) + (w_w / t_t > round( w_w / t_t ) ? 1 : 0)	//since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
	for(var/i=0, i<pieces_x, i++)
		for(var/j=0, j<2, j++)
			water_overlay.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)				//place a 32x32 texture on our water texture every 32 pixels
	if(!islarva(owner.affected_atom) && !isfacehugger(owner.affected_atom))
		subtraction_texture.Shift(SOUTH, (w_h - abs(pixel_y_offset)-3), FALSE)	//we move it down to "water level"
		water_overlay.AddAlphaMask(subtraction_texture)								//remove everything other than what the subraction overlay overlaps
	var/mob_culling_mask = GLOB.mob_culling_masks[owner.affected_atom.type]
	water_overlay.AddAlphaMask(icon(owner.icon_path, mob_culling_mask))
	var/mutable_appearance/final_texture = mutable_appearance(water_overlay)	//water overlay done!
	final_texture.layer = input_living.layer+0.01
	final_texture.plane = input_living.plane-0.01

	overlays += final_texture

