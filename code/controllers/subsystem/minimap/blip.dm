/atom/movable/screen/onscreen_tacmap_blip
	name = "tacmap blip"
	icon = null
	icon_state = ""
	appearance_flags = NONE

	var/image/blip_image

	var/datum/weakref/human_weakref = null
	var/datum/weakref/xeno_weakref = null

/atom/movable/screen/onscreen_tacmap_blip/New(image/blip_image, atom/target)
	src.blip_image = blip_image
	src.overlays += src.blip_image


	if (ishuman(target))
		human_weakref = WEAKREF(target)

	if (isxeno(target))
		xeno_weakref = WEAKREF(target)

	// N.B. this could probably just be compile-time set to HIGH_FLOAT_LAYER, but doing it this way in case the layer changes later.
	src.layer = blip_image.layer

/atom/movable/screen/onscreen_tacmap_blip/proc/update_loc_on_minimap(atom/movable/source)
	if(isturf(source.loc))
		src.pixel_x = MINIMAP_PIXEL_FROM_WORLD(source.x) + SSminimaps.minimaps_by_z["[source.z]"].x_offset
		src.pixel_y = MINIMAP_PIXEL_FROM_WORLD(source.y) + SSminimaps.minimaps_by_z["[source.z]"].y_offset
		return

	var/atom/movable/movable_loc = source.loc
	source.override_minimap_tracking(source.loc)
	src.pixel_x = MINIMAP_PIXEL_FROM_WORLD(movable_loc.x) + SSminimaps.minimaps_by_z["[movable_loc.z]"].x_offset
	src.pixel_y = MINIMAP_PIXEL_FROM_WORLD(movable_loc.y) + SSminimaps.minimaps_by_z["[movable_loc.z]"].y_offset

/atom/movable/screen/onscreen_tacmap_blip/proc/minimap_on_move(atom/movable/source, _oldloc)
	SIGNAL_HANDLER
	src.update_loc_on_minimap(source)

/atom/movable/screen/onscreen_tacmap_blip/clicked(mob/user, list/mods)
	var/mob/living/carbon/human/maybe_human = human_weakref ? human_weakref.resolve() : null
	if (maybe_human != null)
		SSminimaps.handle_click_on_human_blip(user, maybe_human)

	var/mob/living/carbon/xenomorph/maybe_xeno = xeno_weakref ? xeno_weakref.resolve() : null
	if (maybe_xeno)
		SSminimaps.handle_click_on_xeno_blip(user, maybe_xeno)
