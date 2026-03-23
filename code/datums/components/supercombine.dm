/datum/component/supercombine
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/needles_to_supercombine = 14
	var/needles
	var/shooter_name
	var/direction
	var/overlay_present
	var/mob/living/carbon/human/parent_carbon
	var/atom/movable/overlay/needler_overlay

/datum/component/supercombine/Initialize(shooter, direction, needles_to_supercombine = 14, supercombine_dissipation = 2)
	. = ..()
	src.shooter_name = shooter
	src.direction = direction
	parent_carbon = parent
	generate_overlay()
	for(var/obj/item/shard/shrapnel/needler/needle in parent_carbon.embedded_items)
		needles = needle.count
		needler_overlay.icon_state = needle_overlay(needles)


/datum/component/supercombine/InheritComponent(datum/component/supercombine/supercombine_new, i_am_original, shooter_name, direction)
	. = ..()
	src.shooter_name = shooter_name
	src.direction = direction
	for(var/obj/item/shard/shrapnel/needler/needle in parent_carbon.embedded_items)
		if(!supercombine_new)
			needles = needle.count
		else
			needles = supercombine_new.needles
		if(needler_overlay in parent_carbon.vis_contents)
			needler_overlay.icon_state = needle_overlay(needles)
		if(!overlay_present)
			generate_overlay()
		if(needles >= needles_to_supercombine)
			supercombine()

/datum/component/supercombine/proc/supercombine()
	var/turf/turf = get_turf(parent_carbon)
	var/cause_data = create_cause_data("supercombine explosion", shooter_name)
	cell_explosion(turf, 50, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, cause_data)
	flick_overlay(parent_carbon, image('icons/halo/effects/supercombine.dmi', null, "supercombine"), 3)
	playsound(parent_carbon, 'sound/effects/halo/supercombine.ogg')
	src.needles = 0
	for(var/obj/item/shard/shrapnel/needler/needle in parent_carbon.embedded_items)
		var/obj/limb/organ = needle.embedded_organ
		organ.implants -= needle
		parent_carbon.embedded_items -= needle
		organ = null
		qdel(needle)
		overlay_remove()

/datum/component/supercombine/proc/generate_overlay()
	needler_overlay = new()
	overlay_present = TRUE
	needler_overlay.icon = 'icons/halo/effects/supercombine.dmi'
	needler_overlay.icon_state = needle_overlay(needles)
	needler_overlay.layer = ABOVE_MOB_LAYER
	needler_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	parent_carbon.vis_contents += needler_overlay
	needler_overlay.icon_state = needle_overlay(needles)

/datum/component/supercombine/proc/needle_overlay(needles)
	var/return_icon
	if(needles >= 14)
		return_icon = "needles_7"
	else
		var/return_number = round(needles / 2, 1)
		if(needles == 1)
			return_number = 1
		return_icon = "needles_[return_number]"
	return return_icon

/datum/component/supercombine/proc/overlay_remove()
	qdel(needler_overlay)
	overlay_present = FALSE

/datum/component/supercombine/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HUMAN_SHRAPNEL_REMOVED, PROC_REF(overlay_remove))
	RegisterSignal(parent, COMSIG_LIVING_REJUVENATED, PROC_REF(overlay_remove))

/datum/component/supercombine/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_SHRAPNEL_REMOVED)
	UnregisterSignal(parent, COMSIG_LIVING_REJUVENATED)
