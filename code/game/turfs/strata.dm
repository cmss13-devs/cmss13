//Special Strata (Carp Lake) Weedable Jungle/Grass turfs.//

/turf/open/gm/grass/weedable/ //inherit from general turfs

/turf/open/gm/grass/weedable/is_weedable()
	return TRUE

/turf/open/gm/dirtgrassborder/weedable

/turf/open/gm/dirtgrassborder/weedable/is_weedable() //Gotta have our sexy grass borders be weedable.
	return TRUE

/turf/closed/gm/dense/weedable

/turf/closed/gm/dense/weedable/is_weedable() //Weed-able jungle walls. Notably crushers can slam through this, so that might cause overlay issues. 3 months later, yeah it causes overlay issues, so return FALSE!
	return FALSE

/turf/open/floor/strata //Instance me!
	icon = 'icons/turf/floors/strata_floor.dmi'
	icon_state = "floor"
