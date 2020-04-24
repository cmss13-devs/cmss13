// Stolen en masse from N3X15 of /vg/station with much gratitude.

// The idea is to have 4 bits for coming and 4 for going.
#define TRACKS_COMING_NORTH 1
#define TRACKS_COMING_SOUTH 2
#define TRACKS_COMING_EAST  4
#define TRACKS_COMING_WEST  8
#define TRACKS_GOING_NORTH  16
#define TRACKS_GOING_SOUTH  32
#define TRACKS_GOING_EAST   64
#define TRACKS_GOING_WEST   128

// 5 seconds
#define TRACKS_CRUSTIFY_TIME   50

// color-dir-dry
var/global/list/image/fluidtrack_cache=list()

/datum/fluidtrack
	var/direction=0
	var/basecolor="#A10808"
	var/wet=0
	var/fresh=1
	var/crusty=0
	var/image/overlay

/datum/fluidtrack/New(_direction,_color,_wet)
	direction=_direction
	basecolor=_color
	wet=_wet

// Footprints, tire trails...
/obj/effect/decal/cleanable/blood/tracks
	icon = 'icons/effects/fluidtracks.dmi'
	icon_state = ""
	amount = 0
	random_icon_states = null
	drying_blood = FALSE
	var/dirs=0
	var/coming_state="blood1"
	var/going_state="blood2"
	var/updatedtracks=0

	// dir = id in stack
	var/list/setdirs=list(
		"1"=0,
		"2"=0,
		"4"=0,
		"8"=0,
		"16"=0,
		"32"=0,
		"64"=0,
		"128"=0
	)

	// List of laid tracks and their colors.
	var/list/datum/fluidtrack/stack=list()


/obj/effect/decal/cleanable/blood/tracks/update_icon()
	overlays.Cut()
	color = "#FFFFFF"
	var/truedir=0

	// Update ONLY the overlays that have changed.
	for(var/datum/fluidtrack/track in stack)
		var/stack_idx=setdirs["[track.direction]"]
		var/state=coming_state
		truedir=track.direction
		if(truedir&240) // Check if we're in the GOING block
			state=going_state
			truedir=truedir>>4

		if(track.overlay)
			track.overlay=null
		var/image/I = image(icon, icon_state=state, dir=num2dir(truedir))
		I.color = track.basecolor

		track.fresh=0
		track.overlay=I
		stack[stack_idx]=track
		overlays += I
	updatedtracks=0 // Clear our memory of updated tracks.



/obj/effect/decal/cleanable/blood/tracks/footprints
	name = "wet footprints"
	desc = "Whoops..."
	coming_state = "human1"
	going_state  = "human2"
	amount = 0

/obj/effect/decal/cleanable/blood/tracks/wheels
	name = "wet tracks"
	desc = "Whoops..."
	coming_state = "wheels"
	going_state  = ""
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null
	amount = 0