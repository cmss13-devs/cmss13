/obj/item/storage/box/guncase
	name = "\improper gun case"
	desc = "It has space for firearm(s). Sometimes magazines or other munitions as well."
	icon_state = "guncase"
	w_class = SIZE_HUGE
	max_w_class = SIZE_HUGE //shouldn't be a problem since we can only store the guns and ammo.
	storage_slots = 1
	slowdown = 1
	can_hold = list()//define on a per case basis for the original firearm.
	foldable = TRUE
	foldable = /obj/item/stack/sheet/mineral/plastic//it makes sense

/obj/item/storage/box/guncase/update_icon()
	if(LAZYLEN(contents))
		icon_state = "guncase"
	else
		icon_state = "guncase_e"

/obj/item/storage/box/guncase/Initialize()
	. = ..()
	update_icon()

//------------
/obj/item/storage/box/guncase/vp78
	name = "\improper VP78 pistol case"
	desc = "A gun case containing the VP78. Comes with two magazines."
	can_hold = list(/obj/item/weapon/gun/pistol/vp78, /obj/item/ammo_magazine/pistol/vp78)
	storage_slots = 3

/obj/item/storage/box/guncase/vp78/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)

//------------
/obj/item/storage/box/guncase/smartpistol
	name = "\improper SU-6 pistol case"
	desc = "A gun case containing the SU-6 smart pistol. Comes with two magazines and a belt holster."
	can_hold = list(/obj/item/storage/belt/gun/smartpistol, /obj/item/weapon/gun/pistol/smart, /obj/item/ammo_magazine/pistol/smart)
	storage_slots = 4

/obj/item/storage/box/guncase/smartpistol/fill_preset_inventory()
	new /obj/item/storage/belt/gun/smartpistol(src)
	new /obj/item/weapon/gun/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)

//------------
/obj/item/storage/box/guncase/mou53
	name = "\improper MOU53 shotgun case"
	desc = "A gun case containing the MOU53 shotgun. It does come loaded, but you'll still have to find ammunition as you go."
	storage_slots = 2
	can_hold = list(/obj/item/weapon/gun/shotgun/double/mou53, /obj/item/attachable/stock/mou53)

/obj/item/storage/box/guncase/mou53/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/double/mou53(src)
	new /obj/item/attachable/stock/mou53(src)

//------------
/obj/item/storage/box/guncase/lmg
	name = "\improper M41AE2 heavy pulse rifle case"
	desc = "A gun case containing the M41AE2 heavy pulse rifle. You can get additional ammunition at requisitions."
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/rifle/lmg, /obj/item/ammo_magazine/rifle/lmg)

/obj/item/storage/box/guncase/lmg/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg/holo_target(src)

//------------
/obj/item/storage/box/guncase/m41aMK1
	name = "\improper M41A pulse rifle MK1 case"
	desc = "A gun case containing the M41A pulse rifle MK1. It can only use proprietary MK1 magazines."
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/rifle/m41aMK1, /obj/item/ammo_magazine/rifle/m41aMK1)

/obj/item/storage/box/guncase/m41aMK1/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/m41aMK1(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)

//------------
//M79 grenade launcher
/obj/item/storage/box/guncase/m79
	name = "\improper M79 grenade launcher case"
	desc = "A gun case containing the modernized M79 grenade launcher. Comes with 3 baton slugs, 3 hornet shells and 3 star shell grenades."
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/launcher/grenade/m81/m79, /obj/item/storage/box/packet)

/obj/item/storage/box/guncase/m79/fill_preset_inventory()
	new /obj/item/weapon/gun/launcher/grenade/m81/m79(src)
	new /obj/item/storage/box/packet/flare(src)
	new /obj/item/storage/box/packet/baton_slug(src)
	new /obj/item/storage/box/packet/hornet(src)

//------------
//R4T lever action rifle
/obj/item/storage/box/guncase/r4t_scout
	name = "\improper R4T lever action rifle case"
	desc = "A gun case containing the R4T lever action rifle, intended for scouting. Comes with an ammunition belt, the optional revolver attachment for it, two boxes of ammunition, a sling, and a stock for the rifle."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/gun/lever_action/r4t, /obj/item/attachable/stock/r4t, /obj/item/attachable/magnetic_harness/lever_sling, /obj/item/ammo_magazine/lever_action, /obj/item/ammo_magazine/lever_action/training, /obj/item/storage/belt/shotgun/lever_action, /obj/item/storage/belt/gun/m44/lever_action/attach_holster, /obj/item/device/motiondetector/m717)

/obj/item/storage/box/guncase/r4t_scout/fill_preset_inventory()
	new /obj/item/weapon/gun/lever_action/r4t(src)
	new /obj/item/attachable/stock/r4t(src)
	new /obj/item/attachable/magnetic_harness/lever_sling(src)
	new /obj/item/ammo_magazine/lever_action(src)
	new /obj/item/ammo_magazine/lever_action(src)
	new /obj/item/storage/belt/shotgun/lever_action(src)
	new /obj/item/storage/belt/gun/m44/lever_action/attach_holster(src)

//------------
/obj/item/storage/box/guncase/flamer
	name = "\improper M240 incinerator case"
	desc = "A gun case containing the M240A1 incinerator unit. It does come loaded, but you'll still have to find extra tanks as you go."
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/flamer, /obj/item/ammo_magazine/flamer_tank, /obj/item/attachable/attached_gun/extinguisher)

/obj/item/storage/box/guncase/flamer/fill_preset_inventory()
	new /obj/item/weapon/gun/flamer(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/attachable/attached_gun/extinguisher(src)

//------------
/obj/item/storage/box/guncase/m56d
	name = "\improper M56D heavy machine gun case"
	desc = "A gun case containing the M56D heavy machine gun. You'll need to order resupplies from requisitions or scavenge them on the field. How do they fit all this into a case? Wouldn't you need a crate."
	storage_slots = 8
	can_hold = list(/obj/item/device/m56d_gun, /obj/item/ammo_magazine/m56d, /obj/item/device/m56d_post, /obj/item/tool/wrench, /obj/item/tool/screwdriver, /obj/item/ammo_magazine/m56d, /obj/item/pamphlet/skill/machinegunner, /obj/item/storage/belt/marine/m2c)

/obj/item/storage/box/guncase/m56d/fill_preset_inventory()
	new /obj/item/device/m56d_gun(src)
	new /obj/item/ammo_magazine/m56d(src)
	new /obj/item/ammo_magazine/m56d(src)
	new /obj/item/device/m56d_post(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/screwdriver(src)
	new /obj/item/pamphlet/skill/machinegunner(src)
	new /obj/item/storage/belt/marine/m2c(src)

//------------
/obj/item/storage/box/guncase/m2c
	name = "\improper M2C heavy machine gun case"
	desc = "A gun case containing the M2C heavy machine gun. It doesn't come loaded, but it does have spare ammunition. You'll have to order extras from requisitions."
	storage_slots = 7
	can_hold = list(/obj/item/pamphlet/skill/machinegunner, /obj/item/device/m2c_gun, /obj/item/ammo_magazine/m2c, /obj/item/storage/belt/marine/m2c, /obj/item/pamphlet/skill/machinegunner)

/obj/item/storage/box/guncase/m2c/fill_preset_inventory()
	new /obj/item/pamphlet/skill/machinegunner(src)
	new /obj/item/device/m2c_gun(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/storage/belt/marine/m2c(src)

