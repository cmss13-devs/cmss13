#define iswrench(O) (istype(O, /obj/item/tool/wrench))
#define iswelder(O) (istype(O, /obj/item/tool/weldingtool))
#define iscoil(O) (istype(O, /obj/item/stack/cable_coil))
#define iswirecutter(O) (istype(O, /obj/item/tool/wirecutters))
#define isscrewdriver(O) (istype(O, /obj/item/tool/screwdriver))
#define ismultitool(O) (istype(O, /obj/item/device/multitool))
#define iscrowbar(O) (istype(O, /obj/item/tool/crowbar))
#define iswire(O) (istype(O, /obj/item/stack/cable_coil))
#define isweapon(O)		(O && is_type_in_list(O, weapons))
#define isgun(O)		(istype(O, /obj/item/weapon/gun))
#define istool(O)		(O && is_type_in_list(O, common_tools))
#define ispowerclamp(O) (istype(O, /obj/item/powerloader_clamp))
#define isstorage(O) 	(istype(O, /obj/item/storage))

//Quick type checks for weapons
var/global/list/weapons = list(
    /obj/item/weapon,
    /obj/item/attachable/bayonet
)

//Quick type checks for some tools
var/global/list/common_tools = list(
    /obj/item/stack/cable_coil,
    /obj/item/tool/wrench,
    /obj/item/tool/weldingtool,
    /obj/item/tool/screwdriver,
    /obj/item/tool/wirecutters,
    /obj/item/device/multitool,
    /obj/item/tool/crowbar
)
