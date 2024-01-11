/obj/structure/closet/secure_closet/guncabinet/red
	name = "red level gun cabinet"
	req_level = SEC_LEVEL_RED

// MP ARMORY

// 3 shotgun cabinet are in brig armory
/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_shotgun

/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_shotgun/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_box/magazine/shotgun/buckshot(src)
	new /obj/item/ammo_box/magazine/shotgun(src)

// 2 M39 cabinet are in brig armory (4 M39 and 12 mags)
/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_m39_submachinegun

/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_m39_submachinegun/Initialize()
	. = ..()
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/ammo_box/magazine/m39(src)

// 2 m4ra cabinet are in brig armory (m4ra guns and 12 mags)
/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_m4ra_rifle

/obj/structure/closet/secure_closet/guncabinet/red/mp_armory_m4ra_rifle/Initialize()
	. = ..()
	new /obj/item/weapon/gun/rifle/m4ra(src)
	new /obj/item/weapon/gun/rifle/m4ra(src)
	new /obj/item/weapon/gun/rifle/m4ra(src)
	new /obj/item/weapon/gun/rifle/m4ra(src)
	new /obj/item/ammo_box/magazine/m4ra(src)

// EXECUTION CHAMBER might add that here need to ask first... will reskin if asked.



// CIC ARMORY

// 4 shotgun cabinet are in cic armory
/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_shotgun

/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_shotgun/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)

//4 MK1 cabinet(using guncase because it fit well here it seem)
/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_mk1_rifle

/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_mk1_rifle/Initialize()
	. = ..()
	new /obj/item/storage/box/guncase/m41aMK1(src)

//4 MK1 (with AP) cabinet(using guncase because it fit well here it seem)
/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_mk1_rifle_ap

/obj/structure/closet/secure_closet/guncabinet/red/cic_armory_mk1_rifle_ap/Initialize()
	. = ..()
	new /obj/item/storage/box/guncase/m41aMK1AP(src)

// UPPER MEDBAY ARMORY

//1 shotgun armory closet 2 guns and 4 mags
/obj/structure/closet/secure_closet/guncabinet/red/armory_shotgun

/obj/structure/closet/secure_closet/guncabinet/red/armory_shotgun/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)

// 2 pistol amory closet maybe to replace with full pistol belt...
/obj/structure/closet/secure_closet/guncabinet/red/armory_m4a3_pistol

/obj/structure/closet/secure_closet/guncabinet/red/armory_m4a3_pistol/Initialize()
	. = ..()
	new /obj/item/storage/belt/gun/m4a3/full(src)
	new /obj/item/storage/belt/gun/m4a3/full(src)
	new /obj/item/storage/belt/gun/m4a3/full(src)
	new /obj/item/storage/belt/gun/m4a3/full(src)
	new /obj/item/ammo_box/magazine/m4a3(src)

// 2 M39 cabinet are in medical armory (4 M39 and 12 mags)
/obj/structure/closet/secure_closet/guncabinet/red/armory_m39_submachinegun

/obj/structure/closet/secure_closet/guncabinet/red/armory_m39_submachinegun/Initialize()
	. = ..()
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/ammo_box/magazine/m39(src)

// UPPER ENGI ARMORY
// same as medical

// REQ ARMORY
// same as medical

// Small office in hangar armory same as brig armory....
// same as brig armory
