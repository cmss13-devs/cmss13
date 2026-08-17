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
	var/turf/open/water_turf
	var/obj/effect/water_splash/splash

/datum/effects/water_overlay_effect/New(atom/input_atom, datum/component/water_overlay_effect/input_component, turf/open/input_water)
	.=..()
	my_component = input_component
	water_turf = input_water

	if(!iscarbon(input_atom))
		input_component.Destroy()
	var/mob/living/carbon/input_carbon = input_atom

	splash = new /obj/effect/water_splash(null, INFINITY)
	splash.vis_flags = VIS_INHERIT_DIR
	the_effect = new /obj/effect/water_overlay_effect()
	the_effect.owner = src

	if(input_carbon.buckled	|| input_carbon.throwing || HAS_TRAIT(input_carbon, TRAIT_HAULED) || (input_carbon.pulledby && input_carbon.pulledby.grab_level >= GRAB_CARRY))
		hidden = TRUE
		return

	//queen footsteps
	if(isqueen(input_atom) || isking(input_atom))
		input_atom.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	pixel_y_offset = water_turf.depth
	var/icon/reference = icon(input_atom.icon, input_atom.icon_state)
	var/ref_w = reference.Width()
	var/icon_path_key = ref_w<=32?"32":(ref_w<=48?"48":(ref_w<=64?"64":ref_w<=88?"88":null))
	icon_path = SSwater_overlays.water_overlay_icon_paths[icon_path_key]
	update()

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
			if(affected_carbon.vis_contents[i] == splash)
				affected_carbon.vis_contents -= affected_carbon.vis_contents[i]
				qdel(splash)
	. = ..() //we need to do this last

/datum/effects/water_overlay_effect/proc/update()
	if(iscarbon(affected_atom))		//should already be handled but one more conditional is surely better than a runtime
		if(hidden)
			return
		var/mob/living/carbon/affected_carbon = affected_atom
		var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in water_turf.contents		//maybe I should just make this a turf variable or something
		var/obj/effect/blocker/water/water_blocker = locate(/obj/effect/blocker/water/) in water_turf.contents	// this too, searching turf contents every update seems expensive
		var/blocker_dispersing = FALSE
		if(water_blocker)
			blocker_dispersing = water_blocker.dispersing
		if(!pixel_y_offset || (water_turf.covered && !blocker_dispersing) || (catwalk && !blocker_dispersing))
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
		if(is_coastline(water_turf) || xeno_resting) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/be a gradient of depth)
			affected_carbon.layer = initial(affected_carbon.layer )
			affected_carbon.plane = initial(affected_carbon.plane)
			for(var/obj/found_obj in affected_carbon.vis_contents)
				found_obj.layer = initial(found_obj.layer)
				found_obj.plane =  initial(found_obj.plane)
		else
			affected_carbon.layer = UNDER_WATER_MOB_LAYER	//in the case theres a dropoff.. ei turf south is high and the one we're in is "deep".
			affected_carbon.plane = FLOOR_PLANE				//to achieve this affect we alter the layer and plane for anything in water

		// Handling the splahes effect using existing /datum/effects code
		if(!xeno_resting && !isfacehugger(affected_carbon) && !islarva(affected_carbon)) //these dont get splashes
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
			splash.icon = icon_path
			splash.icon_state = splash_state
			splash.appearance_flags = RESET_ALPHA | KEEP_APART
			splash.layer = affected_carbon.layer + 1
			splash.plane = affected_carbon.plane
		else
			splash.icon = null
		the_effect.update_wateroverlay(water_turf, affected_atom, pixel_y_offset)	//now that we have all the layerings and splashe sorted, we add water to cover the parts of the body in that depth
		affected_carbon.vis_contents |= the_effect
		affected_carbon.vis_contents |= splash
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
	appearance_flags = RESET_ALPHA
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER

/obj/effect/water_overlay_effect/Destroy()
	. = ..()
	owner = null
	overlays.Cut()

/obj/effect/water_overlay_effect/proc/update_wateroverlay(turf/open/water_turf, mob/living/overlaid_mob, pixel_y_offset = 0)
	var/add_no_texture = (isxeno(overlaid_mob) && pixel_y_offset >= -12 && (overlaid_mob.body_position == LYING_DOWN))
	var/key = ""
	var/toxic_key = 0
	var/found_angle = overlaid_mob.get_lying_angle()
	var/mob/living/carbon/mob_type = overlaid_mob.type
	var/mob_texture_size = icon(overlaid_mob.icon, overlaid_mob.icon_state).Width()
	overlays.Cut()	//clean slate, dont need the old overlay
	if(add_no_texture)
		return
	if(ispath(water_turf.type, /turf/open/gm/river/desert) || ispath(water_turf.type, /turf/open/desert/desert_shore))
		var/turf/open/gm/river/desert/toxic_turf = water_turf
		toxic_key = toxic_turf.toxic
	if(ishuman(overlaid_mob))			//all human subtypes will just use the single human overlay
		mob_type = /mob/living/carbon/human
		mob_texture_size = 32
	var/list/special_mob_types = SSwater_overlays.water_overlay_special["[mob_texture_size]"]
	var/list/special_mob_details = special_mob_types[mob_type] ? special_mob_types[mob_type] : null
	if(special_mob_details && special_mob_details[1])
		key = "_[mob_type]"
	if(overlaid_mob.resting || overlaid_mob.body_position == LYING_DOWN)	//resting will override the special key (deep waters)
		if(found_angle == 270)	//only humans have a found_angle (surely)
			key = "_/mob/living/carbon/human_e"
		else if(found_angle == 90)
			key = "_/mob/living/carbon/human_w"
		if(pixel_y_offset == DEPTH_DEEP)		//when resting in the deep all mobs will look like they're unda da watur
			key = "_u"
	var/mutable_appearance/final_texture = mutable_appearance(SSwater_overlays.water_overlay_icons["[mob_texture_size]_[water_turf.water_type]_[toxic_key]_[pixel_y_offset][key]"])
	final_texture.color = water_turf.color
	overlays += final_texture
