
/mob/living/silicon/spawn_gibs()
	robogibs(loc, viruses)

/mob/living/silicon/gib_animation()
	new /obj/effect/overlay/temp/gib_animation(loc, src, "gibbed-r")



/mob/living/silicon/spawn_dust_remains()
	new /obj/effect/decal/remains/robot(loc)

/mob/living/silicon/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, src, "dust-r")


/mob/living/silicon/death(cause, gibbed, deathmessage)
	SSmob.living_misc_mobs -= src
	return ..()
