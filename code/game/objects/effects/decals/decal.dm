//decal parent

/obj/effect/decal
	name = "you should not be seeing this!"

/obj/effect/decal/Initialize()
	if(!loc)
		qdel(src)
	else
		loc.icon += icon
		qdel(src)
