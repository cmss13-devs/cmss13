/obj/structure/pipes/standard
	icon = 'icons/obj/pipes/pipes.dmi'
	layer = ATMOS_PIPE_LAYER

/obj/structure/pipes/standard/update_icon()
	if(istype(loc, /turf/closed))
		level = 1

	var/turf/T = get_turf(src)
	if(istype(T))
		hide(T.intact_tile)

/obj/structure/pipes/standard/hide(var/invis)
	if(level == 1 && istype(loc, /turf))
		invisibility = invis ? 101 : 0

/obj/structure/pipes/standard/proc/change_color(var/new_color)
	if(!pipe_color_check(new_color))
		return

	pipe_color = new_color
	update_icon()

/obj/structure/pipes/standard/color_cache_name(var/obj/structure/pipes/node)
	return pipe_color