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
	cache_overlay = FALSE

	var/list/steps_in
	var/list/steps_out

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

	MA = new(cleanable_turf)
	// Need to do this because of BYOND behavior that does not update overlayed images
	// after modifying their appearances
	MA.overlays -= overlayed_image
	overlayed_image.overlays += I
	MA.overlays += overlayed_image
	cleanable_turf.appearance = MA

/obj/effect/decal/cleanable/blood/tracks/footprints
	name = "footprints"
	desc = "Whoops..."
	coming_state = "human1"
	going_state  = "human2"
	amount = 0

/obj/effect/decal/cleanable/blood/tracks/wheels
	name = "tracks"
	desc = "Whoops..."
	coming_state = "wheels"
	going_state  = ""
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null
	amount = 0
