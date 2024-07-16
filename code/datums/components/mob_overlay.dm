///The alpha mask used on mobs submerged in liquid turfs or standing on high ground
#define MOB_MOVING_EFFECT_MASK "mob_moving_effect_mask"
///mob_overlay_effect component. adds and removes
/datum/element/mob_overlay_effect
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2
	var/y_offset = 0
	var/mask_y_offset = 0
	var/effect_alpha = 0

/datum/element/mob_overlay_effect/Attach(datum/target, _y_offset = 0, _mask_y_offset = 0, _effect_alpha = 0)
	. = ..()
	y_offset = _y_offset
	mask_y_offset = _mask_y_offset
	effect_alpha = _effect_alpha

	RegisterSignal(get_turf(target), COMSIG_TURF_EXITED, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_remove), override = TRUE)
	RegisterSignal(get_turf(target), COMSIG_TURF_ENTERED, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_add), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_REMOVE, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_remove), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_UPDATE, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_add), override = TRUE)

/datum/element/mob_overlay_effect/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(get_turf(source), COMSIG_TURF_EXITED)
	UnregisterSignal(get_turf(source), COMSIG_TURF_ENTERED)
	UnregisterSignal(source, COMSIG_MOB_OVERLAY_FORCE_REMOVE)
	UnregisterSignal(source, COMSIG_MOB_OVERLAY_FORCE_UPDATE)

/datum/element/mob_overlay_effect/proc/on_remove(datum/source, datum/target)
	SIGNAL_HANDLER
	if(!istype(target, /mob/living))
		return
	var/mob/mob = target
	if(mob.get_filter(MOB_MOVING_EFFECT_MASK))
		animate(mob.get_filter(MOB_MOVING_EFFECT_MASK), y = -32, time = mob.move_delay)
	animate(mob, pixel_y = mob.pixel_y - y_offset, time = mob.move_delay, flags = ANIMATION_PARALLEL)

/datum/element/mob_overlay_effect/proc/on_add(datum/source, datum/target)
	SIGNAL_HANDLER
	if(!istype(target, /mob/living))
		return
	var/mob/arrived_mob = target
	if(arrived_mob.get_filter(MOB_MOVING_EFFECT_MASK))
		animate(arrived_mob.get_filter(MOB_MOVING_EFFECT_MASK), y = mask_y_offset, time = arrived_mob.move_delay*0.5)
		animate(arrived_mob, pixel_y = arrived_mob.pixel_y + y_offset, time = arrived_mob.move_delay, flags = ANIMATION_PARALLEL)
	else
		//The mask is spawned below the mob, then the animate() raises it up, giving the illusion of dropping into water or climbing up, combining with the animate to actual drop the pixel_y into the water
		if(effect_alpha)
			arrived_mob.add_filter(MOB_MOVING_EFFECT_MASK, 1, alpha_mask_filter(0, -32, icon('icons/effects/icon_cutter.dmi', "icon_cutter"), null, MASK_INVERSE))
			animate(arrived_mob.get_filter(MOB_MOVING_EFFECT_MASK), y = mask_y_offset, time = arrived_mob.move_delay*0.5)
		animate(arrived_mob, pixel_y = arrived_mob.pixel_y + y_offset, time = arrived_mob.move_delay, flags = ANIMATION_PARALLEL)

#undef MOB_MOVING_EFFECT_MASK
