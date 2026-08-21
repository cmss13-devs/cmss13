//generic water splash for when things hit water, we could eventually make different sizes for different sized things too
//plays a sound and an animation then dies, nice job water_splash effect you did good RIP
/obj/effect/water_splash
	name = "splash"
	desc = "Disturbed water, watch how it flies!"
	icon = 'icons/effects/water.dmi'
	icon_state = "splash"
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_XENO_LAYER
	var/lifetime = 2 SECONDS	//generous amount of time to let the animation play

/obj/effect/water_splash/Initialize(mapload=FALSE, playsound = TRUE)
	. = ..()
	if(lifetime != INFINITY)
		addtimer(CALLBACK(src, PROC_REF(destroy_effect)), lifetime)
	if(playsound)
		playsound(get_turf(src), "sound/effects/water/splash.ogg", 20, 1, 10, falloff=1)

/obj/effect/water_splash/proc/destroy_effect()
	qdel(src)


//this is what turf_effect/water puts on mobs that are in water
/obj/effect/water_splash/water_overlay_splash
	lifetime = INFINITY
	appearance_flags = RESET_ALPHA | KEEP_APART
	vis_flags = VIS_INHERIT_DIR
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE

/obj/effect/water_splash/water_overlay_splash/proc/update_wateroverlay(turf/water_turf, mob/living/carbon/affected_carbon, pixel_y_offset = 0, xeno_resting=FALSE)
	icon_state = null
	icon = null
	if(!(xeno_resting && pixel_y_offset != DEPTH_DEEP) && !isfacehugger(affected_carbon) && !islarva(affected_carbon)) //these dont get splashes
		var/splash_state
		var/resting_dir
		var/found_angle = affected_carbon.get_lying_angle()
		var/icon/reference = icon(affected_carbon.icon, affected_carbon.icon_state)
		var/ref_w = reference.Width()
		if(ishuman(affected_carbon))
			ref_w = 32
		var/icon_path_key = ref_w<=32?"32":(ref_w<=48?"48":(ref_w<=64?"64":ref_w<=88?"88":null))
		if(HAS_TRAIT(affected_carbon, TRAIT_FLOORED) || found_angle != 0)
			resting_dir = found_angle == 270 ? "_e" : "_w"
			if(pixel_y_offset >= DEPTH_COAST_INTERMEDIATE)
				splash_state = "coast_resting[resting_dir]"
			else if(pixel_y_offset >= DEPTH_INTERMEDIATE)
				splash_state = "floating_resting"
			else	//pixel_y_offset== DEPTH_DEEP -- deep water
				splash_state = affected_carbon.stat == DEAD ? "empty" : "bubbles"
		else
			if(pixel_y_offset == DEPTH_COAST_SHALLOW) //shallow coast
				splash_state = "coast_shallow"
			else if(pixel_y_offset == DEPTH_COAST_INTERMEDIATE) //deep coast
				splash_state = "coast_deep"
			else if(pixel_y_offset == DEPTH_SHALLOW) //shallows
				splash_state = "shallow"
			else if(pixel_y_offset == DEPTH_INTERMEDIATE)	//intermediate depth
				splash_state = "intermediate"
			else //pixel_y_offset== DEPTH_DEEP -- deep water
				if(xeno_resting || isrunner(affected_carbon))	//runner literally underwater at this depth :P
					splash_state = affected_carbon.stat == DEAD ? "empty" : "bubbles"
				else
					splash_state = "deep"
		icon = SSwater_overlays.water_overlay_icon_paths[icon_path_key]
		icon_state = splash_state


