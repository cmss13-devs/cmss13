/obj/structure/machinery/door/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/structure/machinery/door/door in src.loc)
		if(!istype(door, /obj/structure/machinery/door/window) && door.density)
			return 0
	return 1

/turf/closed/wall/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/structure/machinery/door/door in locate(src.x,src.y,src.z))
		if(!istype(door, /obj/structure/machinery/door/window) && door.density)
			return 0
	//There are no false wall checks because that would be fucking retarded
	return 1
