/datum/component/acid_immunity
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

/datum/component/acid_immunity/Initialize(duration)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	QDEL_IN(src, duration)
