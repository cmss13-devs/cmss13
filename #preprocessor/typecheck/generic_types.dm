
#define istypestrict(D, typepath)   D.type == typepath
#define ismind(X)                   (istype(X, /datum/mind))
#define isitem(X)                   (istype(X, /obj/item))
#define isStructure(X)              (istype(X, /obj/structure))
#define isVehicle(X)                (istype(X, /obj/vehicle))
#define isclient(X)                 (istype(X, /client))
#define isStack(X)                  (istype(X, /obj/item/stack))
