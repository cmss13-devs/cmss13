var/global/list/cleanable_decal_cache = list()

/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	var/obj/structure/machinery/bot/cleanbot/targeted_by = null			// Used so cleanbots can't claim a mess.
	var/cleanable_type = CLEANABLE_MISC // What kind of cleanable is this
	var/overlay_on_initialize = TRUE
	/// The overlayed image
	var/image/overlayed_image
	/// Whether to cache the overlayed image or not
	var/cache_overlay = TRUE
	/// The turf that the cleanable is on,
	/// whether overlayed or physically on top of
	var/turf/cleanable_turf
	garbage = TRUE

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
	LAZYSET(T.cleanables, cleanable_type, src)
	cleanable_turf = T
	if(overlayed)
		create_overlay()

/obj/effect/decal/cleanable/proc/cleanup_cleanable()
	if(overlayed_image)
		cleanable_turf.overlays -= overlayed_image
		overlayed_image = null
	QDEL_NULL(cleanable_turf.cleanables[cleanable_type])
	LAZYREMOVE(cleanable_turf.cleanables, cleanable_type)

/obj/effect/decal/cleanable/proc/create_overlay(overlay_icon = icon, overlay_icon_state = icon_state)
	var/cache_key = "[overlay_icon]&[overlay_icon_state]"
	var/image/I
	if(cache_overlay)
		I = cleanable_decal_cache[cache_key]
		if(!istype(I))
			I = image(overlay_icon, icon_state = overlay_icon_state)
			cleanable_decal_cache[cache_key] = I
	else
		I = image(overlay_icon, icon_state = overlay_icon_state)
	var/mutable_appearance/MA = new(I)
	MA.layer = layer
	MA.dir = dir
	MA.color = color
	I.appearance = MA
	overlayed_image = I
	cleanable_turf.overlays += overlayed_image
	moveToNullspace() // This obj should not be on the turf for performance
