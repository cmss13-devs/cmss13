var/global/list/cleanable_decal_cache = list()

/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	var/targeted_by = null			// Used so cleanbots can't claim a mess.
	var/dirt_type = DIRT_MISC//What kind of dirt is this

/obj/effect/decal/cleanable/New()
	set waitfor = 0
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	var/turf/T = get_turf(src)

	if(T && dirt_type)
		var/cache_key = "[icon]&[icon_state]"
		var/image/I = cleanable_decal_cache[cache_key]
		if(!istype(I))
			I = image(icon, icon_state = src.icon_state)
			cleanable_decal_cache[cache_key] = I
		I.layer = layer
		I.dir = dir 
		I.color = color
		if(T.dirt_overlays[dirt_type])
			T.overlays -= T.dirt_overlays[dirt_type] 
			qdel(T.dirt_overlays[dirt_type])
		T.dirt_overlays[dirt_type] = I
		T.overlays += T.dirt_overlays[dirt_type]

	..()
	QDEL_IN(src, 3 SECONDS)



/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user)
	var/obj/effect/alien/weeds/A = locate() in loc
	if(A)
		return A.attackby(W,user)
	else
		return ..()