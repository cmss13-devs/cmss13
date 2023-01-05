//souto land props

/obj/structure/prop/souto_land
	name = "placeholder"
	desc = "Welcome to souto land! This prop shouldn't be used, so please gitlab this and notify a mapper!"
	icon = 'icons/obj/structures/souto_land.dmi'
	density = 0
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE //can't destroy these
	flags_atom = NOINTERACT

/obj/structure/prop/souto_land/ex_act(severity, direction)
	return

/obj/structure/prop/souto_land/streamer
	name = "orange streamers"
	desc = "They flutter softly. Poignant."
	icon_state = "streamers"
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/souto_land/pole
	name = "streamer pole"
	desc = "It connects streamer to streamer."
	icon_state = "post"
	layer = ABOVE_MOB_LAYER


