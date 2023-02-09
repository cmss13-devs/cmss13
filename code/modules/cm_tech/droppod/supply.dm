/obj/structure/droppod/supply
	name = "\improper USCM requisitions droppod"
	drop_time = 10 SECONDS
	dropping_time = 2 SECONDS
	open_time = 2 SECONDS

/obj/structure/droppod/supply/open()
	. = ..()
	for(var/atom/movable/content as anything in contents)
		content.forceMove(loc)
	qdel(src)

