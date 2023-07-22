// Footprints, tire trails...
/obj/effect/decal/cleanable/blood/tracks
	icon = 'icons/effects/fluidtracks.dmi'
	icon_state = ""
	amount = 0
	random_icon_states = null
	var/coming_state="blood1"
	var/going_state="blood2"
	cleanable_type = CLEANABLE_TRACKS
	overlay_on_initialize = TRUE

	var/list/steps_in
	var/list/steps_out

	var/list/overlay_images = list()

/obj/effect/decal/cleanable/blood/tracks/Crossed()
	return

/obj/effect/decal/cleanable/blood/tracks/can_place_cleanable()
	return FALSE

/obj/effect/decal/cleanable/blood/tracks/proc/add_tracks(direction, tcolor, out)
	var/image/I = image(icon = icon, icon_state = out ? going_state : coming_state, dir = direction)
	var/mutable_appearance/MA = new(I)
	MA.color = tcolor
	MA.layer = layer
	MA.appearance_flags |= RESET_COLOR
	I.appearance = MA
	if(out)
		LAZYSET(steps_out, "[direction]", I)
	else
		LAZYSET(steps_in, "[direction]", I)

	overlay_images += I
	cleanable_turf.overlays += I

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
