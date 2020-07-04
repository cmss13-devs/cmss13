//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/datum/song
	var/name = "Untitled"
	var/list/lines = new()
	var/tempo = 5

/obj/structure/device/broken_piano
	name = "broken vintage piano"
	icon = 'icons/obj/structures/props/musician.dmi'
	desc = "What a shame. This piano looks like it'll never play again. Ever. Don't even ask about it."
	icon_state = "pianobroken"
	anchored = 1
	density = 1

/obj/structure/device/broken_moog
	name = "broken vintage synthesizer"
	icon = 'icons/obj/structures/props/musician.dmi'
	desc = "This spacemoog synthesizer is vintage, but trashed. Seems someone didn't like its hot fresh tunes."
	icon_state = "minimoogbroken"
	anchored = 1
	density = 1