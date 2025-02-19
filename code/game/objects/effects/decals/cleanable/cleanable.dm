GLOBAL_LIST_EMPTY(cleanable_decal_cache)

/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	/// Used so cleanbots can't claim a mess.
	var/obj/structure/machinery/bot/cleanbot/targeted_by = null
	var/cleanable_type = CLEANABLE_MISC
	var/overlay_on_initialize = TRUE
	/// A reference to the image overlayed on a turf
	var/image/overlayed_image
	/**
	 * The turf that the cleanable is on,
	 * whether overlayed or physically on top of
	 */
	var/turf/cleanable_turf
	/**
	 * Whether this cleanable has had its overlays and
	 * refs on turfs cleaned up
	 */
	var/cleaned_up = FALSE

	keep_as_object = TRUE

	garbage = TRUE

	keep_as_object = TRUE

/obj/effect/decal/cleanable/Initialize(mapload, ...)
	. = ..()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	var/turf/T = loc

	if(!T)
		return INITIALIZE_HINT_QDEL

	var/obj/effect/decal/cleanable/C = LAZYACCESS(T.cleanables, cleanable_type)
	if(C && !can_place_cleanable(C))
		return INITIALIZE_HINT_QDEL

	place_cleanable(T, overlay_on_initialize)

/obj/effect/decal/cleanable/Destroy()
	if(!cleaned_up)
		cleanup_cleanable()

	random_icon_states = null
	if(targeted_by)
		if(targeted_by.target == src)
			targeted_by.target = null
		if(targeted_by.oldtarget)
			targeted_by.oldtarget = null
	targeted_by = null
	return ..()

/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user)
	var/obj/effect/alien/weeds/A = locate() in loc
	if(A)
		return A.attackby(W,user)
	else
		return ..()

/obj/effect/decal/cleanable/proc/can_place_cleanable(obj/effect/decal/cleanable/old_cleanable)
	return TRUE

/obj/effect/decal/cleanable/proc/place_cleanable(turf/T, overlayed)
	var/obj/effect/decal/cleanable/C = LAZYACCESS(T.cleanables, cleanable_type)
	if(C)
		C.cleanup_cleanable()
	cleaned_up = FALSE
	LAZYSET(T.cleanables, cleanable_type, src)
	cleanable_turf = T
	if(overlayed)
		create_overlay()

/obj/effect/decal/cleanable/proc/cleanup_cleanable()
	cleaned_up = TRUE
	if(!cleanable_turf?.cleanables || !cleanable_turf?.cleanables[cleanable_type])
		return
	clear_overlay()
	if(!QDELING(cleanable_turf.cleanables[cleanable_type]))
		qdel(cleanable_turf.cleanables[cleanable_type])
	LAZYREMOVE(cleanable_turf.cleanables, cleanable_type)

/obj/effect/decal/cleanable/proc/create_overlay(overlay_icon = icon, overlay_icon_state = icon_state)
	overlayed_image = image(overlay_icon, icon_state = overlay_icon_state)
	if(pixel_x)
		overlayed_image.pixel_x = pixel_x
	if(pixel_y)
		overlayed_image.pixel_y = pixel_y
	if(color)
		overlayed_image.color = color
	
	cleanable_turf.overlays += overlayed_image
	moveToNullspace() // This obj should not be on the turf for performance

/obj/effect/decal/cleanable/proc/clear_overlay()
	if(overlayed_image)
		cleanable_turf.overlays -= overlayed_image
		overlayed_image = null
