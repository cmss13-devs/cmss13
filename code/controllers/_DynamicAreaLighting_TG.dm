/*
	Modified DynamicAreaLighting for TGstation - Coded by Carnwennan

	This is TG's 'new' lighting system. It's basically a heavily modified combination of Forum_Account's and
	ShadowDarke's respective lighting libraries. Credits, where due, to them.

	Like sd_DAL (what we used to use), it changes the shading overlays of areas by splitting each type of area into sub-areas
	by using the var/tag variable and moving turfs into the contents list of the correct sub-area. This method is
	much less costly than using overlays or objects.

	Unlike sd_DAL however it uses a queueing system. Everytime we call a change to opacity or luminosity
	(through SetOpacity() or SetLuminosity()) we are  simply updating variables and scheduling certain lights/turfs for an
	update. Actual updates are handled periodically by the lighting_controller. This carries additional overheads, however it
	means that each thing is changed only once per lighting_controller.processing_interval ticks. Allowing for greater control
	over how much priority we'd like lighting updates to have. It also makes it possible for us to simply delay updates by
	setting lighting_controller.processing = 0 at say, the start of a large explosion, waiting for it to finish, and then
	turning it back on with lighting_controller.processing = 1.

	Unlike our old system there are hardcoded maximum luminositys (different for certain atoms).
	This is to cap the cost of creating lighting effects.
	(without this, an atom with luminosity of 20 would have to update 41^2 turfs!) :s

	Also, in order for the queueing system to work, each light remembers the effect it casts on each turf. This is going to
	have larger memory requirements than our previous system but it's easily worth the hassle for the greater control we
	gain. It also reduces cost of removing lighting effects by a lot!

	Known Issues/TODO:
		Shuttles still do not have support for dynamic lighting (I hope to fix this at some point)
		No directional lighting support. (prototype looked ugly)
*/

#define LIGHTING_CIRCULAR 1									//comment this out to use old square lighting effects.
#define LIGHTING_LAYER 10									//Drawing layer for lighting overlays
#define LIGHTING_ICON 'icons/effects/ss13_dark_alpha6.dmi'	//Icon used for lighting shading effects
#define LIGHTING_STATES 6

#define DIRECTIONAL_LUM_OFFSET		2					//Used to tweak direcitonal luminosity
#define DIRECTIONAL_LUM_GRADIENT 	0.2					//Used to tweak direcitonal luminosity
#define DIRECTIONAL_LUM_MULT		1.5					//how much brighter directional luminosity is in the right direction

/datum/light_source
	var/atom/owner
	var/changed = 1
	var/list/effect = list()
	var/__x = 0		//x coordinate at last update
	var/__y = 0		//y coordinate at last update
	var/__z = 0		//z coordinate at last update

	var/_l_color //do not use directly, only used as reference for updating
	var/col_r
	var/col_g
	var/col_b

#define turf_update_lumcount(T, amount, col_r, col_g, col_b, removing) \
	T.lighting_lumcount += amount; \
	if(!isnull(col_r)){ \
		if(removing){ \
			T.light_col_sources--; \
			T.lumcount_r -= col_r; \
			T.lumcount_g -= col_g; \
			T.lumcount_b -= col_b;} \
		else{ \
			T.light_col_sources++; \
			T.lumcount_r += col_r; \
			T.lumcount_g += col_g; \
			T.lumcount_b += col_b;} \
		if(T.light_col_sources){ \
			var/r_avg = max(0, min(255, round(T.lumcount_r / T.light_col_sources, 16) + 15)); \
			var/g_avg = max(0, min(255, round(T.lumcount_g / T.light_col_sources, 16) + 15)); \
			var/b_avg = max(0, min(255, round(T.lumcount_b / T.light_col_sources, 16) + 15)); \
			T.l_color = rgb(r_avg, g_avg, b_avg);} \
		else \
			T.l_color = null; \
		T.color_lighting_lumcount = max(T.color_lighting_lumcount + amount, 0);} \
	if(!T.lighting_changed){ \
		SSlighting.changed_turfs += T; \
		T.lighting_changed = 1;}

#define ls_remove_effect(ls) for(var/turf/T in ls.effect){ turf_update_lumcount(T, -ls.effect[T], ls.col_r, ls.col_g, ls.col_b, 1); } ls.effect.Cut();

#define ls_lum(ls, T) \
	var/dist; \
	if(!T) \
		dist = 0; \
	else{ \
		var/dx = abs(T.x - __x); \
		var/dy = abs(T.y - __y); \
		if(dx>=dy)	dist = (0.934*dx) + (0.427*dy); \
		else		dist = (0.427*dx) + (0.934*dy);} \
	var/delta_lumen = owner.luminosity - dist; \
	if(delta_lumen > 0){ \
		ls.effect[T] = delta_lumen; \
		turf_update_lumcount(T, delta_lumen, ls.col_r, ls.col_g, ls.col_b, 0);}

#define ls_readrgb(ls, col) \
	ls._l_color = col; \
	if(col){ \
		col_r = GetRedPart(col); \
		col_g = GetGreenPart(col); \
		col_b = GetBluePart(col);}
	else \
		col_r = null;

#define ls_add_effect(ls) \
	if(ls.owner.loc && ls.owner.luminosity > 0) { \
		ls_readrgb(ls, ls.owner.l_color); \
		effect = list(); \
		for(var/turf/T in view(ls.owner.luminosity,owner)){ \
			ls_lum(ls, T) } \
		return 0; } \
	else{ \
		ls.owner.light = null; \
		return 1;} \

/datum/light_source/New(atom/A)
	if(!istype(A))
		CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[A]' instead.")
	..()
	owner = A
	ls_readrgb(src, owner.l_color)
	__x = owner.x
	__y = owner.y
	__z = owner.z
	// the lighting object maintains a list of all light sources
	SSlighting.lights.Add(src)


	//Check a light to see if its effect needs reprocessing. If it does, remove any old effect and create a new one
/datum/light_source/proc/check()
	if(!owner)
		ls_remove_effect(src)
		return 1	//causes it to be removed from our list of lights. The garbage collector will then destroy it.

	if(owner.luminosity > 8)
		owner.luminosity = 8

	if (owner.l_color != _l_color)
		ls_readrgb(src, owner.l_color)
		changed = 1

	if(changed)
		changed = 0
		ls_remove_effect(src)
		ls_add_effect(src)
	return 0

/datum/light_source/proc/changed()
	if(owner)
		__x = owner.x
		__y = owner.y

	if(!changed)
		changed = 1
		SSlighting.lights.Add(src)


/datum/light_source/proc/remove_effect()
	// before we apply the effect we remove the light's current effect.
	for(var/turf/T in effect)	// negate the effect of this light source
		turf_update_lumcount(T, -effect[T], col_r, col_g, col_b, 1)
	effect.Cut()					// clear the effect list

/atom
	var/datum/light_source/light
	var/trueLuminosity = 0  // Typically 'luminosity' squared.  The builtin luminosity must remain linear.
	                        // We may read it, but NEVER set it directly.
	var/l_color
	var/directional_lum = 0

//Turfs with opacity when they are constructed will trigger nearby lights to update
//Turfs and atoms with luminosity when they are constructed will create a light_source automatically
/turf/New()
	..()
	if(luminosity)
		if(light)	WARNING("[type] - Don't set lights up manually during New(), We do it automatically.")
		trueLuminosity = luminosity * luminosity
		light = new(src)

//Movable atoms with opacity when they are constructed will trigger nearby lights to update
//Movable atoms with luminosity when they are constructed will create a light_source automatically
/atom/movable/New()
	..()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	if(luminosity)
		if(light)	WARNING("[type] - Don't set lights up manually during New(), We do it automatically.")
		trueLuminosity = luminosity * luminosity
		light = new(src)

//Objects with opacity will trigger nearby lights to update at next lighting process.
/atom/movable/Dispose()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	. = ..()

//Sets our luminosity.
//If we have no light it will create one.
//If we are setting luminosity to 0 the light will be cleaned up by the controller and garbage collected once all its
//queues are complete.
//if we have a light already it is merely updated, rather than making a new one.
/atom/proc/SetLuminosity(new_luminosity, trueLum = FALSE)
	if(new_luminosity < 0)
		new_luminosity = 0
	if(!trueLum)
		new_luminosity *= new_luminosity
	if(light)
		if(trueLuminosity != new_luminosity)	//non-luminous lights are removed from the lights list in add_effect()
			light.changed()
	else
		if(new_luminosity)
			light = new(src)
	trueLuminosity = new_luminosity
	if (trueLuminosity < 1)
		luminosity = 0
	else if (trueLuminosity <= 100)
		luminosity = sqrtTable[trueLuminosity]
	else
		luminosity = sqrt(trueLuminosity)

/atom/proc/AddLuminosity(delta_luminosity)
	if(delta_luminosity > 0)
		SetLuminosity(trueLuminosity + delta_luminosity*delta_luminosity, TRUE)
	else if(delta_luminosity < 0)
		SetLuminosity(trueLuminosity - delta_luminosity*delta_luminosity, TRUE)


//This slightly modifies human luminosity. Source of light do NOT stack.
//When you drop a light source it should keep a running total of your actual luminosity and set it accordingly.
/mob/SetLuminosity(new_luminosity, trueLum)
	if(!new_luminosity) //Our new addition is positive. Add it to our running total.
		return..(0, trueLum)  //Set to ZERO.
	else
		luminosity_total += new_luminosity //Keep track of our new total.

	if(new_luminosity > luminosity) //The lum we want to set to is higher. Use it.
		..(new_luminosity, trueLum)

	else if(luminosity_total < luminosity) //We want to drop our actual luminosity.
		..(luminosity_total, trueLum)

	return

/area/SetLuminosity(new_luminosity)			//we don't want dynamic lighting for areas
	luminosity = !!new_luminosity
	trueLuminosity = luminosity


//change our opacity (defaults to toggle), and then update all lights that affect us.
/atom/proc/SetOpacity(new_opacity)
	if(new_opacity == null)
		new_opacity = !opacity			//default = toggle opacity
	else if(opacity == new_opacity)
		return 0						//opacity hasn't changed! don't bother doing anything
	opacity = new_opacity				//update opacity, the below procs now call light updates.
	return 1

/turf/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(lighting_lumcount)			//only bother with an update if our turf is currently affected by a light
			UpdateAffectingLights()

/atom/movable/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(isturf(loc))					//only bother with an update if we're on a turf
			var/turf/T = loc
			if(T.lighting_lumcount)		//only bother with an update if our turf is currently affected by a light
				UpdateAffectingLights()


/turf
	var/lighting_lumcount = 0
	var/lighting_changed = 0
	var/color_lighting_lumcount = 0
	var/chemexploded = FALSE

	var/lumcount_r = 0
	var/lumcount_g = 0
	var/lumcount_b = 0
	var/light_col_sources = 0

/turf/open/space
	lighting_lumcount = 4		//starlight

/turf/proc/update_lumcount(amount, col_r, col_g, col_b, removing = 0)
	lighting_lumcount += amount

	if(!isnull(col_r)) //col_r is the "key" var, if it's null so will the rest
		if(removing)
			light_col_sources--
			lumcount_r -= col_r
			lumcount_g -= col_g
			lumcount_b -= col_b
		else
			light_col_sources++
			lumcount_r += col_r
			lumcount_g += col_g
			lumcount_b += col_b

		if(light_col_sources)
			var/r_avg = max(0, min(255, round(lumcount_r / light_col_sources, 16) + 15))
			var/g_avg = max(0, min(255, round(lumcount_g / light_col_sources, 16) + 15))
			var/b_avg = max(0, min(255, round(lumcount_b / light_col_sources, 16) + 15))
			l_color = rgb(r_avg, g_avg, b_avg)
		else
			l_color = null

		color_lighting_lumcount = max(color_lighting_lumcount + amount, 0) // Minimum of 0.

	if(!lighting_changed)
		SSlighting.changed_turfs += src
		lighting_changed = 1

/turf/proc/lighting_tag(const/level)
	var/area/A = loc
	return A.tagbase + "sd_L[level]"

/turf/proc/build_lighting_area(const/tag, const/level, const/color_light)
	var/area/Area = loc
	var/area/A = new Area.type()    // create area if it wasn't found
	// replicate vars
	for(var/V in Area.vars)
		switch(V)
			if ("contents","lighting_overlay", "color_overlay", "overlays")
				continue
			else
				if(issaved(Area.vars[V])) A.vars[V] = Area.vars[V]

	A.tag = tag
	A.lighting_subarea = 1
	A.lighting_space = 0 // in case it was copied from a space subarea

	if (l_color != A.l_color)
		A.l_color = l_color

	A.SetLightLevel(level, color_light)
	Area.related += A
	return A

/turf/proc/shift_to_subarea()
	lighting_changed = 0
	var/area/Area = loc

	if(!istype(Area) || !Area.lighting_use_dynamic) return

	var/level = min(max(round(lighting_lumcount,1),0),LIGHTING_STATES)
	var/new_tag = lighting_tag(level)

	// pomf - If we have a lighting color that is not null, apply the new tag to seperate the areas.
	if (l_color)
		// pomf - We append the (rounded!) color lighting lumcount so we can have colored lights.
		new_tag += "[l_color][min(max(round(color_lighting_lumcount,1),0),LIGHTING_STATES)]"

	if(Area.tag!=new_tag)	//skip if already in this area
		var/area/A = locate(new_tag)	// find an appropriate area
		var/color_light = min(max(round(color_lighting_lumcount,1),0),LIGHTING_STATES)

		if (!A)
			A = build_lighting_area(new_tag, level, color_light)
		else if (l_color != A.l_color)
			A.l_color = l_color
			A.SetLightLevel(level, color_light)

		A.contents += src	// move the turf into the area

// Dedicated lighting sublevel for space turfs
// helps us depower things in space, remove space fire alarms,
// and evens out space lighting
/turf/open/space/lighting_tag(var/level)
	var/area/A = loc
	return A.tagbase + "sd_L_space"
/turf/open/space/build_lighting_area(var/tag,var/level)
	var/area/A = ..(tag,4)
	A.lighting_space = 1
	A.SetLightLevel(4)
	A.icon_state = null
	return A


/area
	var/lighting_use_dynamic = 1	//Turn this flag off to prevent sd_DynamicAreaLighting from affecting this area
	var/image/lighting_overlay		//tracks the darkness image of the area for easy removal
	var/lighting_subarea = 0		//tracks whether we're a lighting sub-area
	var/lighting_space = 0			// true for space-only lighting subareas
	var/tagbase
	var/image/color_overlay //Tracks the color image.

/area/proc/SetLightLevel(light, color_light = 0)
	if(!src) return
	if(light <= 0)
		light = 0
		luminosity = 0
	if(light > LIGHTING_STATES)
		light = LIGHTING_STATES
	luminosity = 1

	if(lighting_overlay)
		overlays -= lighting_overlay
		lighting_overlay.icon_state = "[light]"
	else
		lighting_overlay = image(LIGHTING_ICON,,num2text(light),LIGHTING_LAYER)

	if (color_overlay)
		overlays.Remove(color_overlay)
		color_overlay.icon_state = "5"
	else
		if (l_color)
			color_overlay = image('icons/effects/effects.dmi', ,"5", 10.1)
			//color_overlay = image('icons/effects/effects.dmi', ,"white", 10.1)

	if (istype(color_overlay))
		color_overlay.color = l_color


		switch (color_light)
			if (6)
				color_overlay.icon_state = "5"
				//color_overlay.alpha = 180
			if (5)
				color_overlay.icon_state = "4"
				//color_overlay.alpha = 150
			if (4)
				color_overlay.icon_state = "3"
				//color_overlay.alpha = 120
			if (3)
				color_overlay.icon_state = "2"
				//color_overlay.alpha = 90
			if (2)
				color_overlay.icon_state = "1"
				//color_overlay.alpha = 60
			if (1)
				color_overlay.icon_state = "1"
				color_overlay.alpha = 200
				//color_overlay.alpha = 30
			if (-INFINITY to 0)
				color_overlay.alpha = 0
			else
				color_overlay.alpha = 180

		color_overlay.blend_mode = BLEND_ADD
		if (color_overlay.color)
			overlays.Add(color_overlay)

	if (isnull(color_overlay))
		overlays.Add(lighting_overlay)
	else if (light < 6)
		overlays.Add(lighting_overlay)

/area/proc/SetDynamicLighting()
	src.lighting_use_dynamic = 1
	for(var/turf/T in src.contents)
		turf_update_lumcount(T, 0, 0, 0, 0, 0)

/area/proc/InitializeLighting()	//TODO: could probably improve this bit ~Carn
	tagbase = "[type]"
	if(!tag) tag = tagbase
	if(!lighting_use_dynamic)
		if(!lighting_subarea)	// see if this is a lighting subarea already
		//show the dark overlay so areas, not yet in a lighting subarea, won't be bright as day and look silly.
			SetLightLevel(4)

//#undef LIGHTING_LAYER
#undef LIGHTING_CIRCULAR
//#undef LIGHTING_ICON

#define LIGHTING_MAX_LUMINOSITY_STATIC	8	//Maximum luminosity to reduce lag.
#define LIGHTING_MAX_LUMINOSITY_MOBILE	6	//Moving objects have a lower max luminosity since these update more often. (lag reduction)
#define LIGHTING_MAX_LUMINOSITY_TURF	1	//turfs have a severely shortened range to protect from inevitable floor-lighttile spam.

//set the changed status of all lights which could have possibly lit this atom.
//We don't need to worry about lights which lit us but moved away, since they will have change status set already
//This proc can cause lots of lights to be updated. :(
/atom/proc/UpdateAffectingLights()
//	for(var/atom/A in oview(LIGHTING_MAX_LUMINOSITY_STATIC-1,src))
//		if(A.light)
//			A.light.changed()	//force it to update at next process()

/atom/movable/UpdateAffectingLights()
	if(isturf(loc))
		loc.UpdateAffectingLights()

/turf/UpdateAffectingLights()
	for(var/atom/A in oview(LIGHTING_MAX_LUMINOSITY_STATIC-1,src))
		if(A.light)
			A.light.changed()

//caps luminosity effects max-range based on what type the light's owner is.
/atom/proc/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

/atom/movable/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_MOBILE)

/obj/structure/machinery/light/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

/turf/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_TURF)

#undef LIGHTING_MAX_LUMINOSITY_STATIC
#undef LIGHTING_MAX_LUMINOSITY_MOBILE
#undef LIGHTING_MAX_LUMINOSITY_TURF
#undef DIRECTIONAL_LUM_OFFSET
#undef DIRECTIONAL_LUM_MULT