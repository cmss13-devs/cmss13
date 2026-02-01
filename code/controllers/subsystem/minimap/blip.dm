/atom/movable/screen/onscreen_tacmap_blip
	name = "tacmap blip"
	icon = null
	icon_state = ""
	var/image/blip_image

	var/mob/living/carbon/human/maybe_human = null
	var/mob/living/carbon/xenomorph/maybe_xeno = null

/atom/movable/screen/onscreen_tacmap_blip/New(image/blip_image, atom/target)
	to_world(SPAN_DEBUG("XXX new blip: target: [target]"))
	src.blip_image = blip_image
	src.blip_image.loc = src
	src.overlays += src.blip_image

	if (ishuman(target))
		maybe_human = target

	if (isxeno(target))
		maybe_xeno = target

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

/atom/movable/screen/onscreen_tacmap_blip/clicked(atom/source, list/mods)
	to_world(SPAN_DEBUG("XXX clicked!"))

	if (src.maybe_human)
		to_world(SPAN_DEBUG("XXX maybe_human!"))

	if (src.maybe_xeno)
		to_world(SPAN_DEBUG("XXX maybe_xeno!"))
