#define iswelder(O) (istype(O, /obj/item/tool/weldingtool))
#define iswire(O) (istype(O, /obj/item/stack/cable_coil))
#define isweapon(O) (O && is_type_in_list(O, GLOB.weapons))
#define isgun(O) (istype(O, /obj/item/weapon/gun))
#define istool(O) (O && is_type_in_list(O, GLOB.common_tools))
#define ispowerclamp(O) (istype(O, /obj/item/powerloader_clamp))
#define isstorage(O) (istype(O, /obj/item/storage))
#define isclothing(O) (istype(O, /obj/item/clothing))
//Make sure it defenses!
#define isdefenses(O) (istype(O, /obj/structure/machinery/defenses))

//Quick type checks for weapons
GLOBAL_LIST_INIT(weapons, list(
	/obj/item/weapon,
	/obj/item/attachable/bayonet
))

//Quick type checks for some tools
GLOBAL_LIST_INIT(common_tools, list(
	/obj/item/stack/cable_coil,
	/obj/item/tool/wrench,
	/obj/item/tool/weldingtool,
	/obj/item/tool/screwdriver,
	/obj/item/tool/wirecutters,
	/obj/item/device/multitool,
	/obj/item/tool/crowbar
))
