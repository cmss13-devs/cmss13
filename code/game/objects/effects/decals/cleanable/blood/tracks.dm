// Footprints, tire trails...
/obj/effect/decal/cleanable/blood/tracks
	icon = 'icons/effects/fluidtracks.dmi'
	icon_state = ""
	amount = 0
	random_icon_states = null
	randomized = FALSE
	var/coming_state="blood1"
	var/going_state="blood2"
	cleanable_type = CLEANABLE_TRACKS
	overlay_on_initialize = TRUE

	var/list/steps_in
	var/list/steps_out

	var/list/overlay_images = list()

	/// Amount of pixels to shift either way in an attempt to make the tracks more organic
	var/transverse_amplitude = 3

/obj/effect/decal/cleanable/blood/tracks/Crossed()
	return

/obj/effect/decal/cleanable/blood/tracks/can_place_cleanable()
	return FALSE

/obj/effect/decal/cleanable/blood/tracks/proc/add_tracks(direction, tcolor, out)
	var/image/image = image(icon = icon, icon_state = out ? going_state : coming_state, dir = direction)

	var/mutable_appearance/MA = new(image)
	MA.color = tcolor
	MA.layer = layer
	MA.appearance_flags |= RESET_COLOR
	image.appearance = MA

	switch(direction)
		if(NORTH, SOUTH)
			image.pixel_x += rand(-transverse_amplitude, transverse_amplitude)
		if(EAST, WEST)
			image.pixel_y += rand(-transverse_amplitude, transverse_amplitude)

	if(out)
		LAZYSET(steps_out, "[direction]", image)
	else
		LAZYSET(steps_in, "[direction]", image)

	overlay_images += image
	cleanable_turf.overlays += image

/obj/effect/decal/cleanable/blood/tracks/clear_overlay()
	if(length(overlay_images))
		cleanable_turf.overlays -= overlay_images
		overlay_images = null

/obj/effect/decal/cleanable/blood/tracks/footprints
	name = "footprints"
	gender = PLURAL
	desc = "Whoops..."
	coming_state = "human1"
	going_state  = "human2"
	amount = 0

/obj/effect/decal/cleanable/blood/tracks/wheels
	name = "tracks"
	gender = PLURAL
	desc = "Whoops..."
	coming_state = "wheels"
	going_state  = ""
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null
	amount = 0
