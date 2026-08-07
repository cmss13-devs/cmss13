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
	var/icon_path_key = ref_w<=32?"32":(ref_w<=48?"48":(ref_w<=64?"64":ref_w<=88?"88":null))
	icon_path = GLOB.water_overlay_icon_paths[icon_path_key]
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
	if(iscarbon(affected_atom))
		var/mob/living/carbon/affected_mob = affected_atom
		if("hauled" in affected_mob._status_traits || affected_mob.buckled)
			pixel_y_offset = 0
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
			return
											//if there is a meaningful difference in depth, change layerings and animate the mob "down" to where it should be
		animate(affected_mob, pixel_y = pixel_y_offset, 0.2 SECONDS)
		if(is_coastline(input_openturf)) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/seemingly be gradient of depth)
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
		else
			affected_mob.layer = UNDER_TURF_LAYER - 0.01
			affected_mob.plane = FLOOR_PLANE

		for(var/obj/found_obj in affected_mob.vis_contents)
			found_obj.layer = UNDER_TURF_LAYER - 0.02
			found_obj.plane = FLOOR_PLANE

		// Handling the splahes effect using existing /datum/effects code
		var/splash_state
		var/resting_key = affected_mob.resting ? "_resting" : ""
		if(pixel_y_offset == -2) //shallow coast
			splash_state = "coast_shallow[resting_key]"
		else if(pixel_y_offset == -4) //deep coast
			splash_state = "coast_deep[resting_key]"
		else if(pixel_y_offset == -8) //shallows
			splash_state = "shallow[resting_key]"
		else if(pixel_y_offset == -12)	//intermediate depth
			splash_state = "intermediate[resting_key]"
		else //pixel_y_offset== -18 //deep water
			splash_state = "deep[resting_key]"
		obj_icon_state_path = splash_state
		mob_icon_state_path = splash_state
		affected_mob.update_effects()
		the_effect.update_wateroverlay(input_openturf, affected_atom, pixel_y_offset)	//now that we have all the layerings and splashe sorted, we add water to cover the parts of the body in that depth
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
	var/debug_data

/obj/effect/display_effect/Destroy()
	. = ..()
	owner = null
	overlays.Cut()

/obj/effect/display_effect/proc/update_wateroverlay(turf/open/input_openturf, mob/living/input_living, pixel_y_offset = 0)
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

	var/mob_type = input_living.type
	if(ishuman(input_living))					//all subtypes will use the single human overlay
		mob_type = /mob/living/carbon/human

	overlays.Cut()	//clean slate, dont need the old overlay
	var/mutable_appearance/final_texture = mutable_appearance(GLOB.display_effect_water_overlays["[mob_type]_[input_openturf.type]"])
	debug_data = "[mob_type]_[input_openturf.type]"
	final_texture.layer = input_living.layer+0.01
	final_texture.plane = input_living.plane-0.01
	overlays += final_texture
