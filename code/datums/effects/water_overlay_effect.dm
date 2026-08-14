//* //////////////////////////////
// 			DATUM CODE 			//
////////////////////////////// *//

/datum/effects/water_overlay_effect			// used to display water on things
	effect_name = "water_overlay_effect"
	icon_path = 'icons/effects/water_overlay_effects/_32.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/datum/component/water_overlay_effect/my_component
	var/obj/effect/water_overlay_effect/the_effect
	var/pixel_y_offset = 0
	var/hidden = FALSE

/datum/effects/water_overlay_effect/New(atom/input_atom, datum/component/water_overlay_effect/input_component)
	.=..()
	my_component = input_component

	if(!iscarbon(input_atom))
		input_component.Destroy()
	var/mob/living/carbon/input_carbon = input_atom

	the_effect = new /obj/effect/water_overlay_effect()
	the_effect.owner = src

	if(input_carbon.buckled || input_carbon.throwing || HAS_TRAIT(input_carbon, TRAIT_HAULED) || (input_carbon.pulledby && input_carbon.pulledby.grab_level >= GRAB_CARRY))
		hidden = TRUE
		return

	//queen footsteps
	if(isqueen(input_atom) || isking(input_atom))
		input_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	var/turf/input_turf = get_turf(input_atom)
	if(istype(input_turf, /turf/open/gm))
		var/turf/open/gm/input_openturf = input_turf
		pixel_y_offset = input_openturf.depth
		var/icon/reference = icon(input_atom.icon, input_atom.icon_state)
		var/ref_w = reference.Width()
		var/icon_path_key = ref_w<=32?"32":(ref_w<=48?"48":(ref_w<=64?"64":ref_w<=88?"88":null))
		icon_path = SSwater_overlays.water_overlay_icon_paths[icon_path_key]
		update(input_turf)
	else
		debug_log("something went catastrophically wrong, this code should only be called from turfs with depth")

/datum/effects/water_overlay_effect/Destroy()
	the_effect.Destroy()

	//queen footsteps
	if(isqueen(affected_atom) || isking(affected_atom))
		affected_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large")

	if(iscarbon(affected_atom))
		var/mob/living/carbon/affected_carbon = affected_atom
		animate(affected_carbon, pixel_y = initial(affected_carbon.pixel_y), 0.2 SECONDS)
		mob_icon_state_path = null
		obj_icon_state_path = null
		affected_carbon.update_effects()
		affected_carbon.layer = initial(affected_carbon.layer )
		affected_carbon.plane = initial(affected_carbon.plane)
		for(var/obj/found_obj in affected_carbon.vis_contents)
			found_obj.layer = initial(found_obj.layer)
			found_obj.plane =  initial(found_obj.plane)
		for(var/i in 1 to length(affected_carbon.vis_contents))
			if(istype(affected_carbon.vis_contents[i], /obj/effect/water_overlay_effect))
				affected_carbon.vis_contents -= affected_carbon.vis_contents[i]
				qdel(the_effect)
	. = ..() //we need to do this last

/datum/effects/water_overlay_effect/proc/update(turf/open/input_openturf)
	if(iscarbon(affected_atom))		//should already be handled but one more conditional is surely better than a runtime
		if(hidden)
			return
		var/mob/living/carbon/affected_carbon = affected_atom
		var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in input_openturf.contents
		if(!pixel_y_offset || input_openturf.covered || catwalk)
			affected_carbon.appearance_flags &= ~KEEP_TOGETHER
			mob_icon_state_path = null
			obj_icon_state_path = null
			affected_carbon.update_effects()
			if(!affected_carbon.stat == DEAD)
				affected_carbon.layer = initial(affected_carbon.layer)
			else
				affected_carbon.layer = BELOW_MOB_LAYER
			affected_carbon.plane = initial(affected_carbon.plane)
			animate(affected_carbon, pixel_y = initial(affected_carbon.pixel_y), 0.2 SECONDS)
			for(var/obj/found_obj in affected_carbon.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			my_component.Destroy()
			return

		animate(affected_carbon, pixel_y = pixel_y_offset, 0.2 SECONDS)	//if there is a meaningful difference in depth, change layerings and animate the mob "down" to where it should be
		affected_carbon.appearance_flags |= KEEP_TOGETHER					//this eliminates the water overlays extending past the mobs exisiting sprite, and alot of overhead as a restult
		var/xeno_resting = (isxeno(affected_carbon) && (affected_carbon.resting||affected_carbon.body_position == LYING_DOWN))	//side note here, why isKnockDown() not work for xenos? lol
		if(is_coastline(input_openturf) || xeno_resting) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/be a gradient of depth)
			affected_carbon.layer = initial(affected_carbon.layer )
			affected_carbon.plane = initial(affected_carbon.plane)
			for(var/obj/found_obj in affected_carbon.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		else
			affected_carbon.layer = UNDER_WATER_MOB_LAYER	//in the case theres a dropoff.. ei turf south is high and the one we're in is "deep".
			affected_carbon.plane = FLOOR_PLANE				//to achieve this affect we alter the layer and plane for anything in water

		// Handling the splahes effect using existing /datum/effects code
		if(!xeno_resting && !isfacehugger(affected_carbon) && !islarva(affected_carbon))
			var/splash_state
			var/resting_dir
			var/found_angle = affected_carbon.get_lying_angle()
			if(HAS_TRAIT(affected_carbon, TRAIT_FLOORED) || found_angle != 0)
				resting_dir = found_angle == 270 ? "_e" : "_w"
				if(pixel_y_offset >= -4)
					splash_state = "coast_resting[resting_dir]"
				else if(pixel_y_offset >= -12)
					splash_state = "floating_resting"
				else
					splash_state = affected_carbon.stat == DEAD ? "empty" : "bubbles"
			else
				if(pixel_y_offset == -2) //shallow coast
					splash_state = "coast_shallow"
				else if(pixel_y_offset == -4) //deep coast
					splash_state = "coast_deep"
				else if(pixel_y_offset == -8) //shallows
					splash_state = "shallow"
				else if(pixel_y_offset == -12)	//intermediate depth
					splash_state = "intermediate"
				else //pixel_y_offset== -18 //deep water
					splash_state = "deep"
			obj_icon_state_path = splash_state
			mob_icon_state_path = splash_state
			affected_carbon.update_effects()
		the_effect.update_wateroverlay(input_openturf, affected_atom, pixel_y_offset)	//now that we have all the layerings and splashe sorted, we add water to cover the parts of the body in that depth
		affected_carbon.vis_contents |= the_effect
	else
		my_component.Destroy()

//* //////////////////////////////		we use an object because critically  we dont want to alter the hitboxes.. like we would by having these as part of the mob sprite
// 			OBJECT CODE			//		and the water overlay is created to over extend past just the pixels of the body sprites, to cover armors/backpacks/inhands/alt sprites etc
////////////////////////////// *//		it can have its alpha adjusted as well, the sprites of water turfs are opaque... also like if we ever wanted to add quicksand or mud thats easy now

/obj/effect/water_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	var/datum/effects/water_overlay_effect/owner
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER

/obj/effect/water_overlay_effect/Destroy()
	. = ..()
	owner = null
	overlays.Cut()

/obj/effect/water_overlay_effect/proc/update_wateroverlay(turf/open/input_openturf, mob/living/input_living, pixel_y_offset = 0)
	var/add_no_texture = (isxeno(input_living) && pixel_y_offset >= -12 && (input_living.body_position == LYING_DOWN))
	var/key = ""
	var/toxic_key = 0
	var/found_angle = input_living.get_lying_angle()
	var/mob/living/carbon/mob_type = input_living.type
	var/mob_texture_size = icon(input_living.icon, input_living.icon_state).Width()
	overlays.Cut()	//clean slate, dont need the old overlay
	if(add_no_texture)
		return
	if(ispath(input_openturf.type, /turf/open/gm/river/desert) || ispath(input_openturf.type, /turf/open/desert/desert_shore))
		var/turf/open/gm/river/desert/toxic_turf = input_openturf
		toxic_key = toxic_turf.toxic
	if(ishuman(input_living))			//all human subtypes will just use the single human overlay
		mob_type = /mob/living/carbon/human
		mob_texture_size = 32
	var/list/special_mob_types = SSwater_overlays.water_overlay_special["[mob_texture_size]"]
	var/list/special_mob_details = special_mob_types[mob_type] ? special_mob_types[mob_type] : null
	if(special_mob_details && special_mob_details[1])
		key = "_[mob_type]"
	if(input_living.resting || input_living.body_position == LYING_DOWN)	//resting will override the special key (deep waters)
		if(found_angle == 270)	//only humans have a found_angle (surely)
			key = "_/mob/living/carbon/human_e"
		else if(found_angle == 90)
			key = "_/mob/living/carbon/human_w"
		if(pixel_y_offset == DEPTH_DEEP)		//when resting in the deep all mobs will look like they're unda da watur
			key = "_u"
	var/mutable_appearance/final_texture = mutable_appearance(SSwater_overlays.water_overlay_icons["[mob_texture_size]_[input_openturf.type][toxic_key][key]"])
	overlays += final_texture
