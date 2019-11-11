#define isitem(I) (istype(I, /obj/item))
#define istypestrict(D, typepath) D.type == typepath
#define isStructure(X)  istype(X, /obj/structure)
#define isVehicle(X)    istype(X, /obj/vehicle)
