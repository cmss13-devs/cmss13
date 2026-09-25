#define HIDDEN_NONE 0
#define HIDDEN_PLAIN 1
#define HIDDEN_OFFSET 2

/////////////////////////////// WATER OVERLAY EFFECT ///////////////////////////////////

/datum/component/water_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/obj/effect/water_overlay_effect/the_water
	var/obj/effect/water_splash/water_overlay_splash/the_splash
	var/turf/open/effect_turf	//the turf granting this effect, since its for thing that move into it should always be open
	var/turf/old_effect_turf	//the turf granting this effect previously, set on inherit
	var/hidden = HIDDEN_NONE	//for when we still want to preserve the effect but not display
	var/water_depth = 0

/datum/component/water_overlay_effect/Initialize(turf/input_turf, y_offset, tried_parent)
	if((!ismob(parent) && !isobj(parent)) || !istype(input_turf, /turf/open))	//this should already be handled in the turfs creating this component, but a few backup checks cant hurt
		return COMPONENT_INCOMPATIBLE

	the_splash = new /obj/effect/water_splash/water_overlay_splash(null, water_depth <= DEPTH_SHALLOW)	//if the waters deep enough --> SPLASH SOUND! :DDDD
	the_water = new /obj/effect/water_overlay_effect()
	effect_turf = input_turf
	water_depth = effect_turf.depth

	if(isqueen(parent) || isking(parent))	//queen footsteps --- since this is a component we'll handle it along with the effect instead of just on water turfs
		parent.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	update_hidden()
	var/mob/parent_mob = parent
	if(SSwater_overlays.is_water(old_effect_turf) || SSwater_overlays.is_coastline(effect_turf))
		update()
	else
		var/step_delay = 0	//we're going to call update() ideally halfway through the mobs movement animation
		if(parent_mob.client)
			step_delay = parent_mob.client.move_delay
		else if(isliving(parent))
			var/mob/living/living_parent = parent
			step_delay = living_parent.move_delay

		step_delay = max(world.tick_lag, step_delay)
		addtimer(CALLBACK(src, PROC_REF(update)), step_delay * 0.6, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/water_overlay_effect/Destroy()
	var/atom/movable/movable_parent = parent

	animate(parent, pixel_y = initial(movable_parent.pixel_y), 0.2 SECONDS)
	movable_parent.plane = initial(movable_parent.plane)

	if(ismob(parent))
		var/mob/parent_mob = parent
		if(!parent_mob.stat == DEAD)
			parent_mob.layer = initial(parent_mob.layer)
		else
			parent_mob.layer = BELOW_MOB_LAYER

	if(isqueen(parent) || isking(parent))
		parent.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large")

	for(var/obj/found_obj in movable_parent.vis_contents)
		if(found_obj == the_water || found_obj == the_splash)
			movable_parent.vis_contents -= found_obj

	qdel(the_water)
	qdel(the_splash)
	. = ..() //we need to do this last

/datum/component/water_overlay_effect/InheritComponent(datum/component/component, i_am_original, turf/input_turf, y_offset)
	effect_turf = input_turf
	if(water_depth != y_offset)
		water_depth = y_offset
		update_hidden()
		update()

/datum/component/water_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_position_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(handle_resting_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_set_body_position))
	RegisterSignal(parent, COMSIG_LIVING_SET_BUCKLED, PROC_REF(handle_buckle_change))
	RegisterSignal(parent, COMSIG_MOB_UNHAULED, PROC_REF(handle_buckle_change))
	RegisterSignal(parent, COMSIG_LIVING_LAYER_UPDATED, PROC_REF(handle_layer_update))
	RegisterSignal(parent, COMSIG_HUMAN_HAULED, PROC_REF(handle_hauled))
	RegisterSignal(parent, COMSIG_MOVABLE_LAUNCHED_LANDED, PROC_REF(handle_landed))
	if(isxeno(parent))
		RegisterSignal(parent, COMSIG_XENO_POUNCE_STARTED, PROC_REF(handle_pounce))

/datum/component/water_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_SET_LYING_ANGLE,
		COMSIG_LIVING_SET_BODY_POSITION,
		COMSIG_LIVING_SET_BUCKLED,
		COMSIG_MOB_UNHAULED,
		COMSIG_LIVING_LAYER_UPDATED,
		COMSIG_HUMAN_HAULED,
		COMSIG_MOVABLE_LAUNCHED_LANDED))
	if(isxeno(parent))
		UnregisterSignal(parent, COMSIG_XENO_POUNCE_STARTED)

/datum/component/water_overlay_effect/proc/handle_position_change(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER	//simple checks if to remove, if it were a water turf then the comp already has inherited

	var/turf/open/gm/moved_to_turf = get_turf(parent_source)
	var/obj/effect/blocker/water/water_blocker = locate(/obj/effect/blocker/water/) in moved_to_turf.contents

	if(moved_to_turf.depth >= DEPTH_LAND || (moved_to_turf.covered && water_blocker == null) || (moved_to_turf.covered && water_blocker && !water_blocker.dispersing))
		qdel(src)
		return

/datum/component/water_overlay_effect/proc/handle_resting_change()
	SIGNAL_HANDLER	//the effects should exist but as resting/unresting varients, update() to switch between them

	if(iscarbon(parent))
		var/mob/living/carbon/carbon_parent = parent
		if(carbon_parent.buckled)	//luckily this always get called after handle_buckle_change() :)
			return

	var/turf/laid_on_turf = get_turf(parent)
	if(istype(laid_on_turf, /turf/open))
		var/turf/open/open_laid_on_turf = laid_on_turf
		water_depth = open_laid_on_turf.depth

	effect_turf = laid_on_turf
	update()

/datum/component/water_overlay_effect/proc/handle_set_body_position()	//passthrough unless human, which actually use lying_angles
	if(!ishuman(parent))
		handle_resting_change()

/datum/component/water_overlay_effect/proc/handle_buckle_change()
	SIGNAL_HANDLER	//this is for in the case the affected mob buckles/gets-hauled/unhauled, update_hidden() and update()

	var/turf/unbuckled_turf = get_turf(parent)
	if(istype(unbuckled_turf, /turf/open))
		var/turf/open/open_buckled_turf = unbuckled_turf
		water_depth = open_buckled_turf.depth

	effect_turf = unbuckled_turf
	update_hidden()
	update()

/datum/component/water_overlay_effect/proc/handle_layer_update(new_layer)
	SIGNAL_HANDLER

	if(!hidden && ismob(parent))
		var/mob/parent_mob = parent
		parent_mob.layer = UNDER_WATER_MOB_LAYER

/datum/component/water_overlay_effect/proc/handle_hauled(xenomorph)
	SIGNAL_HANDLER

	update_hidden()

/datum/component/water_overlay_effect/proc/handle_landed(atom/movable/launchee, turf/landed_upon)
	SIGNAL_HANDLER

	effect_turf = landed_upon
	update_hidden()
	update()

/datum/component/water_overlay_effect/proc/handle_pounce()
	SIGNAL_HANDLER

	var/my_turf = get_turf(parent)
	new /obj/effect/water_splash(my_turf, TRUE)

/datum/component/water_overlay_effect/proc/update_hidden()
	if(iscarbon(parent))
		var/mob/living/carbon/input_carbon = parent
		if(HAS_TRAIT(input_carbon, TRAIT_HAULED) || (input_carbon.pulledby && input_carbon.pulledby.grab_level >= GRAB_CARRY))
			if(!hidden) //if it wasnt hidden before but now is
				animate(parent, pixel_y = water_depth, layer = UNDER_WATER_MOB_LAYER-0.01, 0.2 SECONDS)
				input_carbon.plane = initial(input_carbon.plane)
				the_water.overlays.Cut()
				the_splash.icon_state = null
			hidden = HIDDEN_OFFSET
			return
		else if(water_depth == DEPTH_COAST_DEPTHLESS || input_carbon.buckled || HAS_TRAIT(input_carbon, TRAIT_LAUNCHED))
			if(!hidden) //if it wasnt hidden before but now is
				animate(input_carbon, pixel_y = initial(input_carbon.pixel_y), 0.2 SECONDS) //remove offset
				input_carbon.layer = initial(input_carbon.layer )
				input_carbon.plane = initial(input_carbon.plane)
				the_water.overlays.Cut()
				the_splash.icon_state = null
			hidden = HIDDEN_PLAIN
			return
		hidden = HIDDEN_NONE

/datum/component/water_overlay_effect/proc/update()
	if(iscarbon(parent))
		if(hidden)	//the mob is hauled, or fireman carried
			return

		var/mob/living/carbon/affected_carbon = parent
		var/catwalk = effect_turf.turf_flags & TURF_CATWALKED
		var/dispersed_waterblocker = effect_turf.turf_flags & TURF_WATERLIKE

		if(!water_depth || (effect_turf.covered && !dispersed_waterblocker) || (catwalk && !dispersed_waterblocker))
			qdel(src)
			return

		animate(affected_carbon, pixel_y = water_depth, 0.2 SECONDS)	//if there is a meaningful difference in depth, change layerings and animate the mob "down" to where it should be
		affected_carbon.appearance_flags |= KEEP_TOGETHER					//this eliminates the water overlays extending past the mobs exisiting sprite, and alot of overhead as a result

		var/xeno_resting = (isxeno(affected_carbon) && (affected_carbon.resting || affected_carbon.body_position == LYING_DOWN))
		if(SSwater_overlays.is_coastline(effect_turf) || xeno_resting) 				//unless its a coast, things here will never need to be "below" the turf south of it (they should always be shallow/be a gradient of depth)
			affected_carbon.layer = initial(affected_carbon.layer)
			affected_carbon.plane = initial(affected_carbon.plane)
		else
			affected_carbon.layer = UNDER_WATER_MOB_LAYER	//in the case theres a dropoff.. ei turf south is high and the one we're in is "deep".
			affected_carbon.plane = FLOOR_PLANE				//to achieve this affect we alter the layer and plane for anything in water

		the_splash.update_wateroverlay(effect_turf, parent, water_depth, xeno_resting)
		the_water.update_wateroverlay(effect_turf, parent, water_depth)	//now that we have all the layerings and splashe sorted, we add water to cover the parts of the body in that depth
		affected_carbon.vis_contents |= the_water
		affected_carbon.vis_contents |= the_splash

#undef HIDDEN_NONE
#undef HIDDEN_PLAIN
#undef HIDDEN_OFFSET
