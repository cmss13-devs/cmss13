
/obj/effect/landmark/wo_supplies
	name = "Whiskey Outpost supply Spawner"
	var/amount = list(5,15)
	var/list/stuff = list()

/obj/effect/landmark/wo_supplies/New()
	..()
	if(stuff.len)
		for(var/s in stuff)
			var/amt = rand(amount[1], amount[2])
			for(var/i = 1, i <= amt, i++)
				new s (src.loc)
	sleep(-1)
	qdel(src)

/obj/effect/landmark/wo_supplies/attachments/standard
	amount = list(10,15)
	stuff = list(/obj/item/attachable/suppressor,
				/obj/item/attachable/bayonet,
				/obj/item/attachable/flashlight,
				/obj/item/attachable/attached_gun/grenade)


/obj/effect/landmark/wo_supplies/attachments/common
	amount = list(3,7)
	stuff = list(/obj/item/attachable/reddot,
				/obj/item/attachable/bipod,
				/obj/item/attachable/burstfire_assembly,
				/obj/item/attachable/reddot,
				/obj/item/attachable/lasersight,
				/obj/item/attachable/extended_barrel,
				/obj/item/attachable/compensator,
				/obj/item/attachable/magnetic_harness)

/obj/effect/landmark/wo_supplies/attachments/scarce
	amount = list(1,5)
	stuff = list(/obj/item/attachable/attached_gun/shotgun,
				/obj/item/attachable/attached_gun/flamer,
				/obj/item/attachable/stock/revolver,
				/obj/item/attachable/stock/smg,
				/obj/item/attachable/stock/shotgun,
				/obj/item/attachable/stock/rifle,
				/obj/item/attachable/gyro,
				/obj/item/attachable/verticalgrip,
				/obj/item/attachable/angledgrip,
				/obj/item/attachable/quickfire,
				/obj/item/attachable/scope/mini)

/obj/effect/landmark/wo_supplies/attachments/rare
	amount = list(0,2)
	stuff = list(/obj/item/attachable/heavy_barrel,
				/obj/item/attachable/scope,
				/obj/item/attachable/quickfire,
				/obj/item/attachable/gyro)



/obj/effect/landmark/wo_supplies/guns
	icon = 'icons/obj/items/weapons/guns/gun.dmi'

/obj/effect/landmark/wo_supplies/guns/common
	amount = list(5,10)

/obj/effect/landmark/wo_supplies/guns/common/m41a
	icon_state = "m41a"
	stuff = list(/obj/item/weapon/gun/rifle/m41a)

/obj/effect/landmark/wo_supplies/guns/common/shotgun
	icon_state = "m37"
	stuff = list(/obj/item/weapon/gun/shotgun/pump)

/obj/effect/landmark/wo_supplies/guns/common/m39
	icon_state = "m39"
	stuff = list(/obj/item/weapon/gun/smg/m39)

/obj/effect/landmark/wo_supplies/guns/common/m44
	icon_state = "m44"
	stuff = list(/obj/item/weapon/gun/revolver/m44)

/obj/effect/landmark/wo_supplies/guns/common/m4a3
	icon_state = "m4a3"
	stuff = list(/obj/item/weapon/gun/pistol/m4a3)

/obj/effect/landmark/wo_supplies/guns/rare
	amount = list(1,2)

/obj/effect/landmark/wo_supplies/guns/rare/flamer
	icon_state = "m240"
	stuff = list(/obj/item/weapon/gun/flamer)

/obj/effect/landmark/wo_supplies/guns/rare/hpr
	icon_state = "m41ae2"
	stuff = list(/obj/item/weapon/gun/rifle/lmg)

/obj/effect/landmark/wo_supplies/guns/rare/m41aMK1
	icon_state = "m41amk1"
	stuff = list(/obj/item/weapon/gun/rifle/m41aMK1)


/obj/effect/landmark/wo_supplies/storage
	icon = 'icons/obj/items/storage.dmi'
	amount = list(1,5)

/obj/effect/landmark/wo_supplies/storage/webbing
	icon = 'icons/obj/items/clothing/ties.dmi'
	icon_state = "webbing"
	stuff = list(/obj/item/clothing/accessory/storage/webbing)

/obj/effect/landmark/wo_supplies/storage/machete
	icon_state = "machete_holster_full"
	stuff = list(/obj/item/storage/large_holster/machete/full)

/obj/effect/landmark/wo_supplies/storage/m56d
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_case"
	stuff = list(/obj/item/storage/box/m56d_hmg)

/obj/effect/landmark/wo_supplies/storage/mines
	icon_state = "minebox"
	stuff = list(/obj/item/storage/box/explosive_mines)

/obj/effect/landmark/wo_supplies/storage/grenades
	amount = list(0,2)
	icon_state = "nade_placeholder"
	stuff = list(/obj/item/storage/box/nade_box)

/obj/effect/landmark/wo_supplies/storage/m37holster
	icon_state = "m37_holster"
	stuff = list(/obj/item/storage/large_holster/m37)

/obj/effect/landmark/wo_supplies/storage/belts
	icon = 'icons/obj/items/clothing/belts.dmi'
	amount = list(1,3)

/obj/effect/landmark/wo_supplies/storage/belts/grenade
	icon_state = "grenadebelt"
	amount = list(0,1)
	stuff = list(/obj/item/storage/belt/grenade/full)

/obj/effect/landmark/wo_supplies/storage/belts/medical
	icon_state = "medicalbelt"
	stuff = list(/obj/item/storage/belt/medical)



/obj/effect/landmark/wo_supplies/storage/belts/m41abelt
	icon_state = "marinebelt"
	stuff = list(/obj/item/storage/belt/marine)

/obj/effect/landmark/wo_supplies/storage/belts/knifebelt
	icon_state = "knifebelt"
	stuff = list(/obj/item/storage/belt/knifepouch)

/obj/effect/landmark/wo_supplies/storage/belts/shotgunbelt
	icon_state = "shotgunbelt"
	stuff = list(/obj/item/storage/belt/shotgun)

/obj/effect/landmark/wo_supplies/storage/belts/m44belt
	icon_state = "m44_holster"
	stuff = list(/obj/item/storage/belt/gun/m44)

/obj/effect/landmark/wo_supplies/storage/belts/m4a3belt
	icon_state = "m4a3_holster"
	stuff = list(/obj/item/storage/belt/gun/m4a3)

/obj/effect/landmark/wo_supplies/storage/belts/m39holster
	icon_state = "m39_holster"
	amount = list(1,5)
	stuff = list(/obj/item/storage/large_holster/m39)



/obj/effect/landmark/wo_supplies/storage/belts/lifesaver
	icon_state = "medicalbag"
	stuff = list(/obj/item/storage/belt/medical/combatLifesaver)




/obj/effect/landmark/wo_supplies/ammo
	icon = 'icons/obj/items/weapons/guns/ammo.dmi'
	amount = list(1,5)

/obj/effect/landmark/wo_supplies/ammo/powerpack
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "powerpack"
	stuff = list(/obj/item/smartgun_powerpack)

/obj/effect/landmark/wo_supplies/ammo/box
	amount = list(1,2)

/obj/effect/landmark/wo_supplies/ammo/box/m41a
	icon_state = "big_ammo_box"
	stuff = list(/obj/item/ammo_box/rounds)

/obj/effect/landmark/wo_supplies/ammo/box/smg
	icon_state = "big_ammo_box_m39"
	stuff = list(/obj/item/ammo_box/rounds/smg)

/obj/effect/landmark/wo_supplies/ammo/box/m41amag
	icon_state = "mag_box_m41"
	stuff = list(/obj/item/ammo_box/magazine)

/obj/effect/landmark/wo_supplies/ammo/box/slug
	icon_state = "shell_box"
	stuff = list(/obj/item/ammo_box/magazine/shotgun)

/obj/effect/landmark/wo_supplies/ammo/box/buck
	icon_state = "shell_box_buck"
	stuff = list(/obj/item/ammo_box/magazine/shotgun/buckshot)

/obj/effect/landmark/wo_supplies/ammo/box/smgmag
	icon_state = "mag_box_m39"
	stuff = list(/obj/item/ammo_box/magazine/m39)



/obj/effect/landmark/wo_supplies/ammo/box/rare
	amount = list(0,1)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aap
	icon_state = "big_ammo_box_ap"
	stuff = list(/obj/item/ammo_box/rounds/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aapmag
	icon_state = "mag_box_m41_ap"
	stuff = list(/obj/item/ammo_box/magazine/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aincend
	icon_state = "mag_box_m41_incen"
	stuff = list(/obj/item/ammo_box/magazine/incen)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aextend
	icon_state = "mag_box_m41_ext"
	stuff = list(/obj/item/ammo_box/magazine/ext)

/obj/effect/landmark/wo_supplies/ammo/box/rare/smgap
	icon_state = "mag_box_m39_ap"
	stuff = list(/obj/item/ammo_box/magazine/m39/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/smgextend
	icon_state = "mag_box_m39_ext"
	stuff = list(/obj/item/ammo_box/magazine/m39/ext)
