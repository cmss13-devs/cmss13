GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name			= "openspace_backdrop"
	anchored		= TRUE
	icon            = 'icons/turf/floors/floors.dmi'
	icon_state      = "grey"
	plane           = OPENSPACE_BACKDROP_PLANE
	mouse_opacity 	= MOUSE_OPACITY_TRANSPARENT

/turf/open_space
    name = "open space"
    icon_state = "transparent"
    baseturfs = /turf/open_space
    plane = OPEN_SPACE_PLANE

/turf/open_space/Initialize()
    return INITIALIZE_HINT_LATELOAD

/turf/open_space/LateInitialize()
    update_vis_contents()

/turf/open_space/proc/update_vis_contents()
    vis_contents.Cut()
    vis_contents += GLOB.openspace_backdrop_one_for_all
    var/turf/below = locate(x, y, z-1)

    if(below)
        vis_contents += below

/turf/open_space/multiz_new(dir)
    if(dir == DOWN)
        update_vis_contents()

/turf/open_space/multiz_del(dir)
    if(dir == DOWN)
        update_vis_contents()
