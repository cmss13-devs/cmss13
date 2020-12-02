// placeholders
#define ZTRAIT_GROUND 1
#define ZTRAIT_ADMIN 2
#define ZTRAIT_MARINE_MAIN_SHIP 3
#define ZTRAIT_LOWORBITT 4
#define ZTRAIT_HUNTER_SHIP 5

#define is_admin_level(z) (z == ZTRAIT_ADMIN)

#define is_ground_level(z) (z == ZTRAIT_GROUND)

#define is_mainship_level(z) (z == ZTRAIT_MARINE_MAIN_SHIP)

#define is_loworbit_level(z) (z == ZTRAIT_LOWORBITT)

#define is_huntership_level(z) (z == ZTRAIT_HUNTER_SHIP)

// extremely placeholder
GLOBAL_REAL(SSmapping, /datum/mapping_placeholder) = new

/datum/mapping_placeholder

/datum/mapping_placeholder/proc/levels_by_trait(trait)
	RETURN_TYPE(/list)
	return list(trait)

/datum/mapping_placeholder/proc/levels_by_any_trait(list/traits)
	RETURN_TYPE(/list)
	return traits

#define OBJECTS_CAN_REACH(Oa, Ob) (!(is_admin_level(Oa.z) || is_admin_level(Ob.z)) || Oa.z == Ob.z)
