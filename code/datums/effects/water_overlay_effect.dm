//* //////////////////////////////
// 			DATUM CODE 			//
////////////////////////////// *//

/datum/effects/water_overlay_effect			// used to display water on things
	effect_name = "water_overlay_effect"
	icon_path = 'icons/effects/water_overlay_effects/_32.dmi'
	flags = INF_DURATION|EFFECT_NO_PROCESS
	var/obj/effect/water_overlay_effect/the_effect
	var/pixel_y_offset = 0

/datum/effects/water_overlay_effect/New(atom/input_atom, force_update=FALSE)
	.=..()

	the_effect = new /obj/effect/water_overlay_effect()
	the_effect.owner = src

	//queen footsteps
	if(isqueen(input_atom) || isking(input_atom))
		input_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	var/turf/open/gm/input_openturf = get_turf(input_atom)
	if(istype(input_openturf, /turf/open/gm))
		pixel_y_offset = input_openturf.depth
	else
		debug_log("something went catastrophically wrong, this code should only be called from turfs with depth")
	var/icon/reference = icon(input_atom.icon, input_atom.icon_state)
	var/ref_w = reference.Width()
	var/icon_path_key = ref_w<=32?"32":(ref_w<=48?"48":(ref_w<=64?"64":ref_w<=88?"88":null))
	icon_path = SSwater_overlays.water_overlay_icon_paths[icon_path_key]
	if(force_update)
		update_icons(get_turf(input_atom))

/datum/effects/water_overlay_effect/Destroy()
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
			if(istype(affected_mob.vis_contents[i], /obj/effect/water_overlay_effect))
				affected_mob.vis_contents -= affected_mob.vis_contents[i]
				qdel(the_effect)

	return ..() // we need to know what the mob is to destroy our stuff in its vis_contents, so we run parent code after

/datum/effects/water_overlay_effect/proc/update_icons(turf/open/input_openturf)
	if(iscarbon(affected_atom))
		var/mob/living/carbon/affected_mob = affected_atom
		if(HAS_TRAIT(affected_mob, TRAIT_HAULED) || affected_mob.buckled)
			pixel_y_offset = 0

		var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in input_openturf.contents
		if(!pixel_y_offset || input_openturf.covered || (affected_mob.pulledby && affected_mob.pulledby.grab_level >= GRAB_CARRY) || catwalk ||  input_openturf.covered)
			affected_mob.appearance_flags &= ~KEEP_TOGETHER
			mob_icon_state_path = null
			obj_icon_state_path = null
			affected_mob.update_effects()
			if(!affected_mob.stat == DEAD)
				affected_mob.layer = initial(affected_mob.layer)
			else
				affected_mob.layer = BELOW_MOB_LAYER
			affected_mob.plane = initial(affected_mob.plane)
			animate(affected_mob, pixel_y = initial(affected_mob.pixel_y), 0.2 SECONDS)
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
			var/datum/component/water_overlay_effect/found = affected_mob.GetComponent(/datum/component/water_overlay_effect)
			if(found)
				found.UnregisterFromParent()
				found.Destroy()
			return

		animate(affected_mob, pixel_y = pixel_y_offset, 0.2 SECONDS)	//if there is a meaningful difference in depth, change layerings and animate the mob "down" to where it should be
		affected_mob.appearance_flags |= KEEP_TOGETHER					//this eliminates the water overlays extending past the mobs exisiting sprite, and alot of overhead as a restult
		var/xeno_resting = (isxeno(affected_mob) && (affected_mob.resting||affected_mob.body_position == LYING_DOWN))	//side note here, why isKnockDown() not work for xenos? lol
		if(is_coastline(input_openturf) || xeno_resting) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/be a gradient of depth)
			affected_mob.layer = initial(affected_mob.layer )
			affected_mob.plane = initial(affected_mob.plane)
			for(var/obj/found_obj in affected_mob.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		else
			affected_mob.layer = UNDER_WATER_MOB_LAYER	//in the case theres a dropoff.. ei turf south is high and the one we're in is "deep".
			affected_mob.plane = FLOOR_PLANE				//to achieve this affect we alter the layer and plane for anything in water

		// Handling the splahes effect using existing /datum/effects code
		if(!xeno_resting && !isfacehugger(affected_mob) && !islarva(affected_mob))
			var/splash_state
			var/resting_dir
			var/found_angle = affected_mob.get_lying_angle()
			if(HAS_TRAIT(affected_mob, TRAIT_FLOORED) || found_angle != 0)
				resting_dir = found_angle == 270 ? "_e" : "_w"
				if(pixel_y_offset >= -4)
					splash_state = "coast_resting[resting_dir]"
				else if(pixel_y_offset >= -12)
					splash_state = "floating_resting"
				else
					splash_state = affected_mob.stat == DEAD ? "empty" : "bubbles"
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
			affected_mob.update_effects()
		the_effect.update_wateroverlay(input_openturf, affected_atom, pixel_y_offset)	//now that we have all the layerings and splashe sorted, we add water to cover the parts of the body in that depth
		affected_mob.vis_contents |= the_effect

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
