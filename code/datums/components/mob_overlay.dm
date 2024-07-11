///The alpha mask used on mobs submerged in liquid turfs
#define MOB_LIQUID_TURF_MASK "mob_liquid_turf_mask"
///mob_overlay_effect component. adds and removes
/datum/element/mob_overlay_effect
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2
	var/y_offset = 0
	var/mask_y_offset = 0
	var/effect_alpha = 0

/datum/element/mob_overlay_effect/Attach(datum/target, _y_offset, _mask_y_offset)
	. = ..()
	y_offset = _y_offset
	mask_y_offset = _mask_y_offset

	RegisterSignal(get_turf(target), COMSIG_TURF_EXITED, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_exit), override = TRUE)
	RegisterSignal(get_turf(target), COMSIG_TURF_ENTERED, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_enter), override = TRUE)

/datum/element/mob_overlay_effect/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(get_turf(source), COMSIG_TURF_EXITED)
	UnregisterSignal(get_turf(source), COMSIG_TURF_ENTERED)

/datum/element/mob_overlay_effect/proc/on_exit(datum/source, datum/target)
	SIGNAL_HANDLER
	if(!istype(target, /mob/living))
		return
	var/mob/mob = target
	if(mob.get_filter(MOB_LIQUID_TURF_MASK))
		animate(mob.get_filter(MOB_LIQUID_TURF_MASK), y = -32, time = mob.move_delay)
		addtimer(CALLBACK(mob, TYPE_PROC_REF(/atom, remove_filter), MOB_LIQUID_TURF_MASK), mob.move_delay*0.5)
	animate(mob, pixel_y = mob.pixel_y - y_offset, time = mob.move_delay, flags = ANIMATION_PARALLEL)

/datum/element/mob_overlay_effect/proc/on_enter(datum/source, datum/target)
	SIGNAL_HANDLER
	if(!istype(target, /mob/living))
		return
	var/mob/arrived_mob = target
	if(arrived_mob.get_filter(MOB_LIQUID_TURF_MASK))
		animate(arrived_mob.get_filter(MOB_LIQUID_TURF_MASK), y = mask_y_offset, time = arrived_mob.move_delay*0.5)
		animate(arrived_mob, pixel_y = arrived_mob.pixel_y + y_offset, time = arrived_mob.move_delay, flags = ANIMATION_PARALLEL)
	else
		//The mask is spawned below the mob, then the animate() raises it up, giving the illusion of dropping into water, combining with the animate to actual drop the pixel_y into the water
		if(effect_alpha)
			arrived_mob.add_filter(MOB_LIQUID_TURF_MASK, 1, alpha_mask_filter(0, -32, icon('icons/effects/icon_cutter.dmi', "icon_cutter"), null, MASK_INVERSE))
			animate(arrived_mob.get_filter(MOB_LIQUID_TURF_MASK), y = mask_y_offset, time = arrived_mob.move_delay*0.5)
		animate(arrived_mob, pixel_y = arrived_mob.pixel_y + y_offset, time = arrived_mob.move_delay, flags = ANIMATION_PARALLEL)
