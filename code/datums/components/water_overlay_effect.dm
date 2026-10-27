#define HIDDEN_NONE 0
#define HIDDEN_PLAIN 1
#define HIDDEN_OFFSET 2

/////////////////////////////// WATER OVERLAY EFFECT ///////////////////////////////////

/datum/component/water_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/obj/effect/water_overlay_effect/the_water
	var/obj/effect/water_splash/water_overlay_splash/the_splash
	var/turf/open/effect_turf	//the turf granting this effect, since its for thing that move into it should always be open
	var/hidden = HIDDEN_NONE	//for when we still want to preserve the effect but not display
	var/layer_before   // the layer the mob had before *we* touched it
	var/we_own_layer = FALSE
	var/water_depth = 0


/datum/component/water_overlay_effect/Initialize(turf/input_turf, tried_parent)
	//this should already be handled in the turfs creating this component, but a few backup checks cant hurt
	if(!ismob(parent) && !isobj(parent))
		return COMPONENT_INCOMPATIBLE
	if(!istype(input_turf, /turf/open))
		return COMPONENT_INCOMPATIBLE

	the_splash = new /obj/effect/water_splash/water_overlay_splash(null, water_depth <= WATER_DEPTH_SHALLOW)	//if the waters deep enough --> SPLASH SOUND! :DDDD
	the_water = new /obj/effect/water_overlay_effect()
	effect_turf = input_turf
	water_depth = effect_turf.depth

	update_hidden()
	var/mob/parent_mob = parent
	if(SSwater_overlays.is_coastline(effect_turf))
		update_visuals()
	else
		var/step_delay = 0	//we're going to call update_visuals() ideally halfway through the mobs movement animation
		if(parent_mob.client)
			step_delay = parent_mob.client.move_delay
		else if(isliving(parent))
			var/mob/living/living_parent = parent
			step_delay = living_parent.move_delay

		step_delay = max(world.tick_lag, step_delay)
		addtimer(CALLBACK(src, PROC_REF(update_visuals)), step_delay * 0.6, TIMER_UNIQUE|TIMER_OVERRIDE)


/datum/component/water_overlay_effect/Destroy()
	var/atom/movable/movable_parent = parent

	animate(parent, pixel_y = initial(movable_parent.pixel_y), 0.2 SECONDS)
	movable_parent.plane = initial(movable_parent.plane)

	release_layer()

	movable_parent.vis_contents -= the_water
	movable_parent.vis_contents -= the_splash

	qdel(the_water)
	qdel(the_splash)
	. = ..() //we need to do this last


/datum/component/water_overlay_effect/InheritComponent(datum/component/component, i_am_original, turf/input_turf)
	effect_turf = input_turf
	if(water_depth != effect_turf.depth)
		water_depth = effect_turf.depth
		update_hidden()
		update_visuals()


/datum/component/water_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(handle_position_change))
	RegisterSignal(parent, COMSIG_MOVABLE_LAUNCHED_LANDED, PROC_REF(handle_landed))
	RegisterSignal(parent, COMSIG_MOB_UNHAULED, PROC_REF(handle_buckle_change))
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(handle_death))
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(handle_resting_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_set_body_position))
	RegisterSignal(parent, COMSIG_LIVING_SET_BUCKLED, PROC_REF(handle_buckle_change))
	RegisterSignal(parent, COMSIG_LIVING_LAYER_UPDATED, PROC_REF(handle_layer_update))
	RegisterSignal(parent, COMSIG_HUMAN_HAULED, PROC_REF(handle_hauled))
	if(isxeno(parent))
		RegisterSignal(parent, COMSIG_XENO_POUNCE_STARTED, PROC_REF(handle_pounce))


/datum/component/water_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_TURF_ENTERED,
		COMSIG_LIVING_SET_LYING_ANGLE,
		COMSIG_LIVING_SET_BODY_POSITION,
		COMSIG_LIVING_SET_BUCKLED,
		COMSIG_MOB_UNHAULED,
		COMSIG_LIVING_LAYER_UPDATED,
		COMSIG_HUMAN_HAULED,
		COMSIG_MOVABLE_LAUNCHED_LANDED,
		COMSIG_MOB_DEATH))
	if(isxeno(parent))
		UnregisterSignal(parent, COMSIG_XENO_POUNCE_STARTED)


/datum/component/water_overlay_effect/proc/handle_position_change(atom/movable/parent_source, turf/newloc)
	SIGNAL_HANDLER	//simple checks if to remove, if it were a water turf then the comp already has inherited

	var/turf/open/gm/moved_to_turf = get_turf(parent_source)
	var/obj/effect/blocker/water/water_blocker = locate(/obj/effect/blocker/water/) in moved_to_turf.contents

	if(moved_to_turf.depth >= WATER_DEPTH_LAND)
		qdel(src)
		return
	if(moved_to_turf.covered && water_blocker == null)
		qdel(src)
		return
	if(moved_to_turf.covered && water_blocker && !water_blocker.dispersing)
		qdel(src)
		return
	if(moved_to_turf.turf_flags & TURF_CATWALKED)
		qdel(src)
		return


/datum/component/water_overlay_effect/proc/handle_resting_change()
	SIGNAL_HANDLER	//the effects should exist but as resting/unresting varients, update_visuals() to switch between them

	if(iscarbon(parent))
		var/mob/living/carbon/carbon_parent = parent
		if(carbon_parent.buckled)	//luckily this always get called after handle_buckle_change() :)
			return

	var/turf/laid_on_turf = get_turf(parent)

	if(istype(laid_on_turf, /turf/open))
		var/turf/open/open_laid_on_turf = laid_on_turf
		water_depth = open_laid_on_turf.depth

	effect_turf = laid_on_turf
	update_visuals()


/datum/component/water_overlay_effect/proc/handle_set_body_position()	//passthrough unless human, which actually use lying_angles
	if(!ishuman(parent))
		handle_resting_change()


/datum/component/water_overlay_effect/proc/handle_buckle_change()	//this is for in the case the affected mob buckles/gets-hauled/unhauled, update_hidden() and update_visuals()
	SIGNAL_HANDLER

	var/turf/unbuckled_turf = get_turf(parent)

	if(istype(unbuckled_turf, /turf/open))
		var/turf/open/open_buckled_turf = unbuckled_turf
		water_depth = open_buckled_turf.depth

	effect_turf = unbuckled_turf
	update_hidden()
	update_visuals()


/datum/component/water_overlay_effect/proc/handle_layer_update(new_layer)	//if something tries to change the layer of our mob while we are altering it...
	SIGNAL_HANDLER

	if(we_own_layer && !hidden)
		var/mob/parent_mob = parent
		parent_mob.layer = UNDER_WATER_MOB_LAYER


/datum/component/water_overlay_effect/proc/handle_hauled(xenomorph)
	SIGNAL_HANDLER

	update_hidden()
	update_visuals()


/datum/component/water_overlay_effect/proc/handle_landed(atom/movable/launchee, turf/landed_upon)
	SIGNAL_HANDLER

	effect_turf = landed_upon
	update_hidden()
	update_visuals()


/datum/component/water_overlay_effect/proc/handle_pounce()
	SIGNAL_HANDLER

	var/my_turf = get_turf(parent)
	if(my_turf)
		new /obj/effect/water_splash(my_turf, TRUE)


/datum/component/water_overlay_effect/proc/handle_death()
	SIGNAL_HANDLER

	update_visuals()


/// this proc just stores the layer of the mob and sets a var saying we are controlling the layer now
/datum/component/water_overlay_effect/proc/claim_layer()
	if(we_own_layer)	//already claimed
		return
	var/atom/movable/movable_parent = parent
	layer_before = movable_parent.layer
	we_own_layer = TRUE


/// this proc releases control over the layer and sets the mobs layer back to what it was before we claimed it
/datum/component/water_overlay_effect/proc/release_layer()
	if(!we_own_layer)	//already released
		return
	var/atom/movable/movable_parent = parent
	if(ismob(movable_parent))
		var/mob/parent_mob = movable_parent
		if(parent_mob.stat == DEAD)
			parent_mob.layer = BELOW_MOB_LAYER
		else
			parent_mob.layer = layer_before
	else
		movable_parent.layer = layer_before
	movable_parent.plane = GAME_PLANE
	we_own_layer = FALSE


/// this proc determines whether the water_overlay_effect ought ot not display or not, and how it ought not display
/datum/component/water_overlay_effect/proc/update_hidden()
	if(!isliving(parent))
		return

	var/mob/living/living_parent = parent

	if(HAS_TRAIT(living_parent, TRAIT_HAULED) || (living_parent.pulledby && living_parent.pulledby.grab_level >= GRAB_CARRY))
		hidden = HIDDEN_OFFSET	//the component still exists, but mob looks like its not in water at all

	else if(water_depth == WATER_DEPTH_COAST_DEPTHLESS || living_parent.buckled || HAS_TRAIT(living_parent, TRAIT_LAUNCHED))
		hidden = HIDDEN_PLAIN	//the component still exists but hidden and we still want to change the mob's pixel_y to depth

	else
		hidden = HIDDEN_NONE	//not hidden at all; have the mob down to depth, render the water overlay, and splashes!


/// the workhorse of the water_overlay_effect; checks if we've moved to a non water turf and deletes itself OR moves the mob down to depth and adds the overlay and splash
/datum/component/water_overlay_effect/proc/update_visuals()
	if(!isliving(parent))
		return

	var/mob/living/affected_living = parent
	var/catwalk = effect_turf.turf_flags & TURF_CATWALKED
	var/dispersed_waterblocker = effect_turf.turf_flags & TURF_WATERLIKE

	// Left water entirely
	if(water_depth >= WATER_DEPTH_LAND || (effect_turf.covered && !dispersed_waterblocker) || (catwalk && !dispersed_waterblocker))
		qdel(src)
		return

	switch(hidden)
		if(HIDDEN_PLAIN)	//the component still exists, but mob looks like its not in water at all
			animate(affected_living, pixel_y = initial(affected_living.pixel_y), 0.2 SECONDS)
			release_layer()
			the_water.overlays.Cut()
			the_splash.icon_state = null
		if(HIDDEN_OFFSET)	//the component is hidden, yet we still want to change the mob's pixel_y to depth
			claim_layer()
			animate(affected_living, pixel_y = water_depth,  layer = UNDER_WATER_MOB_LAYER-0.01, 0.2 SECONDS)
			affected_living.plane = initial(affected_living.plane)
			the_water.overlays.Cut()
			the_splash.icon_state = null
		if(HIDDEN_NONE)	//not hidden at all, move the mob down to depth, render the water overlay, and the splashes!
			claim_layer()
			animate(affected_living, pixel_y = water_depth, layer = UNDER_WATER_MOB_LAYER, 0.2 SECONDS)
			affected_living.appearance_flags |= KEEP_TOGETHER
			affected_living.plane = FLOOR_PLANE

			var/xeno_resting = (isxeno(affected_living) && (affected_living.resting || affected_living.body_position == LYING_DOWN))
			if(SSwater_overlays.is_coastline(effect_turf) || xeno_resting)
				release_layer()

			the_splash.update_wateroverlay(effect_turf, parent, water_depth, xeno_resting)
			the_water.update_wateroverlay(effect_turf, parent, water_depth)
			affected_living.vis_contents |= the_water
			affected_living.vis_contents |= the_splash


#undef HIDDEN_NONE
#undef HIDDEN_PLAIN
#undef HIDDEN_OFFSET
