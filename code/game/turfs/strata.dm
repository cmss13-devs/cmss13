//Special Strata (Carp Lake) Weedable Jungle/Grass turfs.//

/turf/open/gm/grass/weedable/ //inherit from general turfs

/turf/open/gm/grass/weedable/is_weedable()
	return FULLY_WEEDABLE

//just in case

/turf/open/gm/grass/grass1/weedable //inherit from general turfs

/turf/open/gm/grass/grass1/weedable/is_weedable()
	return FULLY_WEEDABLE

/turf/open/gm/dirtgrassborder/weedable

/turf/open/gm/dirtgrassborder/weedable/is_weedable() //Gotta have our sexy grass borders be weedable.
	return FULLY_WEEDABLE

/turf/closed/gm/dense/weedable

/turf/closed/gm/dense/weedable/is_weedable() //Weed-able jungle walls. Notably crushers can slam through this, so that might cause overlay issues. 3 months later, yeah it causes overlay issues, so return FALSE!
	return NOT_WEEDABLE

/turf/open/floor/strata //Instance me!
	icon = 'icons/turf/floors/strata_floor.dmi'
	icon_state = "floor"
