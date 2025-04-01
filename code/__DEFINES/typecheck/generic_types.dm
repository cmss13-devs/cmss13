#define isdatum(X)   (istype(X, /datum))
#define istypestrict(D, typepath)   D.type == typepath
#define ismind(X)    (istype(X, /datum/mind))
#define isitem(X)    (istype(X, /obj/item))
#define isStructure(X)   (istype(X, /obj/structure))
#define isVehicle(X) (istype(X, /obj/vehicle))
#define isVehicleMultitile(X)    (istype(X, /obj/vehicle/multitile))
#define isclient(X)  (istype(X, /client))
#define isStack(X)   (istype(X, /obj/item/stack))
#define issurface(X) (istype(X, /obj/structure/surface))
#define ismovableatom(A) (ismovable(A))
#define isatom(A) (isloc(A))
#define isfloorturf(A) (istype(A, /turf/open/floor))
#define isclosedturf(A) (istype(A, /turf/closed))
#define isweakref(D) (istype(D, /datum/weakref))
#define isgenerator(A) (istype(A, /generator))
#define istransparentturf(A) (HAS_TRAIT(A, TURF_Z_TRANSPARENT_TRAIT))


//Byond type ids
#define TYPEID_NULL "0"
#define TYPEID_NORMAL_LIST "f"
//helper macros
#define GET_TYPEID(ref) ( ( (length(ref) <= 10) ? "TYPEID_NULL" : copytext(ref, 4, -7) ) )
#define IS_NORMAL_LIST(L) (GET_TYPEID("\ref[L]") == TYPEID_NORMAL_LIST)
