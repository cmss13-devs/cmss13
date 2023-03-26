/obj/structure/droppod/supply
	name = "\improper USCM requisitions droppod"
	drop_time = 10 SECONDS
	dropping_time = 2 SECONDS
	open_time = 2 SECONDS

/obj/structure/droppod/supply/open()
	. = ..()
	for(var/atom/movable/content as anything in contents)
		///Crates are anchored when launched to avoid pushing them while launching and this created issues with them being anchored when they landed groundside.
		///This unanchors them before moving them out to make sure that crates are able to be moved when groundside.
		if(istype(content, /obj/structure/closet/crate))
			content.anchored = FALSE
		content.forceMove(loc)
	qdel(src)

