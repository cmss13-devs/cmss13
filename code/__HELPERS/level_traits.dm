
#define is_admin_level(z) SSmapping.level_trait(z, ZTRAIT_ADMIN)

#define is_ground_level(z) SSmapping.level_trait(z, ZTRAIT_GROUND)

#define is_mainship_level(z) SSmapping.level_trait(z, ZTRAIT_MARINE_MAIN_SHIP)

#define is_loworbit_level(z) SSmapping.level_trait(z, ZTRAIT_LOWORBIT)

#define is_reserved_level(z) SSmapping.level_trait(z, ZTRAIT_RESERVED)

#define OBJECTS_CAN_REACH(Oa, Ob) (!(is_admin_level(Oa.z) || is_admin_level(Ob.z)) || Oa.z == Ob.z)
