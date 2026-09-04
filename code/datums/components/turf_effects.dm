//	turf_effects are unique components that turfs give mobs/obj upon them entering,
//	they should have a seperate effect defined in each subtype that affects the mob/obj in someway
//	when created they should register signals that control their behaviour, ideally destroying the effect on some conditions like movement off these turfs
//	but can handle other signals as well that affect the effect, which should all be added in RegisterWithParent()
//	since this should just be architecture for handling adding/removing, the actual effects are seperate...
//	and should be defined per subtype and handled in update() (which all the signal handling procs should call)
//	SPECIAL NOTE: default behavior of turf_effect is to check if its hidden or not and delete itself, update() should always be overriden with detailed behaviour
/datum/component/turf_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/turf/open/effect_turf	//the turf granting this effect, since its for thing that move into it should always be open
	var/hidden = FALSE	//for when we still want to preserve the effect but not display

//subtypes should call .=..() last in their definitions, since this calls update and the hidden_check
/datum/component/turf_effect/Initialize(turf/input_turf)
	. = ..()
	effect_turf = input_turf

/datum/component/turf_effect/InheritComponent(datum/component/C, i_am_original, turf/input_turf, y_offset, force_update)
	. = ..()
	if(force_update)
		update()
	else if(effect_turf.type != input_turf.type)	//all turf_effects should update upon entering a new turf type, since these are turf effects
		effect_turf = input_turf
		update()

/** !!!! this proc should always be overrriden !!!!
*/
/datum/component/turf_effect/proc/update()
	if(!hidden)
		Destroy()

/////////////////////////////// WATER TURF EFFECT ///////////////////////////////////

/datum/component/turf_effect/water
	var/obj/effect/water_overlay_effect/the_water
	var/obj/effect/water_splash/water_overlay_splash/the_splash
	var/water_depth = 0

/datum/component/turf_effect/water/Initialize(turf/input_turf, y_offset, tried_parent)
	. = ..()
	if((!ismob(parent) && !isobj(parent)) || !istype(input_turf, /turf/open))	//this should already be handled in the turfs creating this component, but a few backup checks cant hurt
		return COMPONENT_INCOMPATIBLE

	var/turf/open/input_open = input_turf
	the_splash = new /obj/effect/water_splash/water_overlay_splash(null, input_open.depth <= DEPTH_SHALLOW && water_depth == DEPTH_LAND ? TRUE : FALSE)	//if the waters deep enough, and no depth b4 --> SPLASH SOUND! :DDDD
	the_water = new /obj/effect/water_overlay_effect()
	effect_turf = input_turf
	water_depth = effect_turf.depth

	if(isqueen(parent) || isking(parent))	//queen footsteps --- since this is a component we'll handle it along with the effect instead of just on water turfs
		parent.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sounds_="alien_footstep_large_water")

	update_hidden()

	var/step_delay = 0	//we're going to call update() ideally halfway through the mobs movement animation
	var/mob/parent_mob = parent
	if(parent_mob.client)
		step_delay = parent_mob.client.move_delay
	else if(isliving(parent))
		step_delay = parent:move_delay

	step_delay = max(world.tick_lag, step_delay)
	addtimer(CALLBACK(src, PROC_REF(update)), step_delay * 0.6, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/turf_effect/water/Destroy()
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

	the_water.Destroy()
	the_splash.Destroy()
	. = ..() //we need to do this last

/datum/component/turf_effect/water/InheritComponent(datum/component/component, i_am_original, turf/input_turf, y_offset)
	var/will_update = FALSE
	if(water_depth != y_offset)
		water_depth = y_offset
		will_update = TRUE
	. = ..(component, i_am_original, input_turf, will_update)

/datum/component/turf_effect/water/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_position_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(handle_resting_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_set_body_position))
	RegisterSignal(parent, COMSIG_LIVING_SET_BUCKLED, PROC_REF(handle_buckle_change))
	RegisterSignal(parent, COMSIG_MOB_UNHAULED, PROC_REF(handle_buckle_change))

/datum/component/turf_effect/water/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE)
	UnregisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(parent, COMSIG_LIVING_SET_BUCKLED)
	UnregisterSignal(parent, COMSIG_MOB_UNHAULED)

/datum/component/turf_effect/water/proc/handle_position_change(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER	//simple checks if to remove, if it were a water turf then the comp already has inherited

	var/turf/open/gm/moved_to_turf = get_turf(parent_source)
	var/obj/effect/blocker/water/water_blocker = locate(/obj/effect/blocker/water/) in moved_to_turf.contents

	if(moved_to_turf.depth >= DEPTH_LAND || (moved_to_turf.covered && water_blocker == null) || (moved_to_turf.covered && water_blocker && !water_blocker.dispersing))
		Destroy()
		return

/datum/component/turf_effect/water/proc/handle_resting_change()
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

/datum/component/turf_effect/water/proc/handle_set_body_position()	//passthrough unless human, which actually use lying_angles
	if(!ishuman(parent))
		handle_resting_change()

/datum/component/turf_effect/water/proc/handle_buckle_change()
	SIGNAL_HANDLER	//this is for in the case the affected mob buckles/gets-hauled/unhauled, update_hidden() and update()

	var/turf/unbuckled_turf = get_turf(parent)
	if(istype(unbuckled_turf, /turf/open))
		var/turf/open/open_buckled_turf = unbuckled_turf
		water_depth = open_buckled_turf.depth

	effect_turf = unbuckled_turf
	update_hidden()
	update()

#define HIDDEN_OFFSET 2

/datum/component/turf_effect/water/proc/update_hidden()
	if(iscarbon(parent))
		var/mob/living/carbon/input_carbon = parent
		if(HAS_TRAIT(input_carbon, TRAIT_HAULED) || (input_carbon.pulledby && input_carbon.pulledby.grab_level >= GRAB_CARRY))
			if(!hidden) //if it wasnt hidden before but now is
				input_carbon.layer = initial(input_carbon.layer )
				input_carbon.plane = initial(input_carbon.plane)
				the_water.overlays.Cut()
				the_splash.icon_state = null
			hidden = HIDDEN_OFFSET
			return
		else if(input_carbon.buckled || input_carbon.throwing)
			if(!hidden) //if it wasnt hidden before but now is
				input_carbon.layer = initial(input_carbon.layer )
				input_carbon.plane = initial(input_carbon.plane)
				the_water.overlays.Cut()
				the_splash.icon_state = null
			hidden = TRUE
			return
		hidden = FALSE

/datum/component/turf_effect/water/update()
	if(iscarbon(parent))
		if(hidden == HIDDEN_OFFSET)	//the mob is hauled, or fireman carried
			animate(parent, pixel_y = water_depth, layer = UNDER_WATER_MOB_LAYER-0.01, 0.2 SECONDS)
			return
		else if (hidden) //in flight during a throw, or buckled to something
			return

		var/mob/living/carbon/affected_carbon = parent
		var/catwalk = effect_turf.turf_flags & TURF_CATWALKED
		var/dispersed_waterblocker = effect_turf.turf_flags & TURF_WATERLIKE

		if(!water_depth || (effect_turf.covered && !dispersed_waterblocker) || (catwalk && !dispersed_waterblocker))
			Destroy()
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

#undef HIDDEN_OFFSET
