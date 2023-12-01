/obj/structure/droppod/supply
	name = "\improper USCM requisitions package"
	drop_time = 10 SECONDS
	dropping_time = 2 SECONDS
	open_time = 2 SECONDS
	/// The contained parimary object, used as a replacer for the droppod icon
	var/obj/structure/package

/obj/structure/droppod/supply/Initialize(mapload, obj/structure/package)
	. = ..()
	if(!istype(package))
		return INITIALIZE_HINT_QDEL
	package.forceMove(src)
	src.package = package

/obj/structure/droppod/supply/Destroy(force)
	package = null
	return ..()

/* Pose as the crate so we see it falling from the skies */
/obj/structure/droppod/supply/update_icon()
	. = ..()
	icon = package.icon
	icon_state = package.icon_state

/obj/structure/droppod/supply/open()
	. = ..()
	for(var/atom/movable/content as anything in contents)
		content.forceMove(loc)
	package = null
	qdel(src)

