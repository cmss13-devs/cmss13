
/obj/effect/landmark/wo_supplies
	name = "Whiskey Outpost supply Spawner"
	var/amount = list(5,15)
	var/list/stuff = list()

/obj/effect/landmark/wo_supplies/New()
	..()
	if(length(stuff))
		for(var/s in stuff)
			var/amt = rand(amount[1], amount[2])
			for(var/i = 1, i <= amt, i++)
				new s (src.loc)
	sleep(-1)
	qdel(src)

/obj/effect/landmark/wo_supplies/attachments/standard
	amount = list(10,15)
	stuff = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/attached_gun/grenade,
	)


/obj/effect/landmark/wo_supplies/attachments/common
	amount = list(3,7)
	stuff = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/reddot,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/magnetic_harness,
	)

/obj/effect/landmark/wo_supplies/attachments/scarce
	amount = list(1,5)
	stuff = list(
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/stock/revolver,
		/obj/item/attachable/stock/smg,
		/obj/item/attachable/stock/shotgun,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/gyro,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/scope/mini,
	)

/obj/effect/landmark/wo_supplies/attachments/rare
	amount = list(0,2)
	stuff = list(
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/scope,
		/obj/item/attachable/gyro,
	)



/obj/effect/landmark/wo_supplies/guns
	icon_state = ""

/obj/effect/landmark/wo_supplies/guns/common
	amount = list(5,10)

/obj/effect/landmark/wo_supplies/guns/common/m41a
	icon_state = "m41a"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/assault_rifles.dmi'
	stuff = list(/obj/item/weapon/gun/rifle/m41a)

/obj/effect/landmark/wo_supplies/guns/common/shotgun
	icon_state = "m37"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/shotguns.dmi'
	stuff = list(/obj/item/weapon/gun/shotgun/pump)

/obj/effect/landmark/wo_supplies/guns/common/m39
	icon_state = "m39"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/smgs.dmi'
	stuff = list(/obj/item/weapon/gun/smg/m39)

/obj/effect/landmark/wo_supplies/guns/common/m44
	icon_state = "m44r"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/revolvers.dmi'
	stuff = list(/obj/item/weapon/gun/revolver/m44)

/obj/effect/landmark/wo_supplies/guns/common/m4a3
	icon_state = "m4a3"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/pistols.dmi'
	stuff = list(/obj/item/weapon/gun/pistol/m4a3)

/obj/effect/landmark/wo_supplies/guns/rare
	amount = list(1,2)

/obj/effect/landmark/wo_supplies/guns/rare/flamer
	icon_state = "m240"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/flamers.dmi'
	stuff = list(/obj/item/weapon/gun/flamer/m240)

/obj/effect/landmark/wo_supplies/guns/rare/hpr
	icon_state = "m41ae2"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/machineguns.dmi'
	stuff = list(/obj/item/weapon/gun/rifle/lmg)

/obj/effect/landmark/wo_supplies/guns/rare/m41aMK1
	icon_state = "m41amk1"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/assault_rifles.dmi'
	stuff = list(/obj/item/weapon/gun/rifle/m41aMK1)


/obj/effect/landmark/wo_supplies/storage
	icon_state = null
	icon = 'icons/obj/items/clothing/accessory/webbings.dmi'
	amount = list(1,5)

/obj/effect/landmark/wo_supplies/storage/webbing
	icon_state = "webbing"
	stuff = list(/obj/item/clothing/accessory/storage/webbing)

/obj/effect/landmark/wo_supplies/storage/machete
	icon_state = "machete_holster_full"
	icon = 'icons/obj/items/storage/holsters.dmi'
	stuff = list(/obj/item/storage/large_holster/machete/full)

/obj/effect/landmark/wo_supplies/storage/m56d
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "M56D_case"
	stuff = list(/obj/item/storage/box/m56d_hmg)

/obj/effect/landmark/wo_supplies/storage/mines
	icon_state = "minebox"
	icon = 'icons/obj/items/storage/packets.dmi'
	stuff = list(/obj/item/storage/box/explosive_mines)

/obj/effect/landmark/wo_supplies/storage/grenades
	amount = list(0,2)
	icon_state = "nade_placeholder"
	icon = 'icons/obj/items/storage/packets.dmi'
	stuff = list(/obj/item/storage/box/nade_box)

/obj/effect/landmark/wo_supplies/storage/m37holster
	icon_state = "m37_holster"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/large_holster/m37)

/obj/effect/landmark/wo_supplies/storage/belts
	icon = 'icons/obj/items/clothing/belts/belts.dmi'
	amount = list(1,3)

/obj/effect/landmark/wo_supplies/storage/belts/grenade
	icon_state = "grenadebelt"
	amount = list(0,1)
	stuff = list(/obj/item/storage/belt/grenade/full)

/obj/effect/landmark/wo_supplies/storage/belts/medical
	icon_state = "medicalbelt"
	stuff = list(/obj/item/storage/belt/medical/full)



/obj/effect/landmark/wo_supplies/storage/belts/m41abelt
	icon_state = "marinebelt"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/marine)

/obj/effect/landmark/wo_supplies/storage/belts/knifebelt
	icon_state = "knifebelt"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/knifepouch)

/obj/effect/landmark/wo_supplies/storage/belts/shotgunbelt
	icon_state = "shotgunbelt"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/shotgun)

/obj/effect/landmark/wo_supplies/storage/belts/m44belt
	icon_state = "m44r_holster"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/gun/m44)

/obj/effect/landmark/wo_supplies/storage/belts/m4a3belt
	icon_state = "m4a3_holster"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/gun/m4a3)

/obj/effect/landmark/wo_supplies/storage/belts/m39holster
	icon_state = "m39_holster"
	amount = list(1,5)
	stuff = list(/obj/item/storage/belt/gun/m39)



/obj/effect/landmark/wo_supplies/storage/belts/lifesaver
	icon_state = "medicbag"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	stuff = list(/obj/item/storage/belt/medical/lifesaver/full)




/obj/effect/landmark/wo_supplies/ammo
	icon_state = ""
	amount = list(1,5)

/obj/effect/landmark/wo_supplies/ammo/powerpack
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	icon_state = "powerpack"
	stuff = list(/obj/item/smartgun_battery)

/obj/effect/landmark/wo_supplies/ammo/box
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = ""
	amount = list(1,2)

/obj/effect/landmark/wo_supplies/ammo/box/m41a
	icon_state = "base_m41"
	stuff = list(/obj/item/ammo_box/rounds)

/obj/effect/landmark/wo_supplies/ammo/box/smg
	icon_state = "base_m39"
	stuff = list(/obj/item/ammo_box/rounds/smg)

/obj/effect/landmark/wo_supplies/ammo/box/m41amag
	icon_state = "base_m41"
	stuff = list(/obj/item/ammo_box/magazine)

/obj/effect/landmark/wo_supplies/ammo/box/slug
	icon_state = "base_slug"
	stuff = list(/obj/item/ammo_box/magazine/shotgun)

/obj/effect/landmark/wo_supplies/ammo/box/buck
	icon_state = "base_buck"
	stuff = list(/obj/item/ammo_box/magazine/shotgun/buckshot)

/obj/effect/landmark/wo_supplies/ammo/box/smgmag
	icon_state = "base_m39"
	stuff = list(/obj/item/ammo_box/magazine/m39)



/obj/effect/landmark/wo_supplies/ammo/box/rare
	amount = list(0,1)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aap
	icon_state = "base_m41"
	stuff = list(/obj/item/ammo_box/rounds/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aapmag
	icon_state = "base_m41"
	stuff = list(/obj/item/ammo_box/magazine/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aincend
	icon_state = "base_inc"
	stuff = list(/obj/item/ammo_box/magazine/incen)

/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aextend
	icon_state = "base_m41"
	stuff = list(/obj/item/ammo_box/magazine/ext)

/obj/effect/landmark/wo_supplies/ammo/box/rare/smgap
	icon_state = "base_m39"
	stuff = list(/obj/item/ammo_box/magazine/m39/ap)

/obj/effect/landmark/wo_supplies/ammo/box/rare/smgextend
	icon_state = "base_m39"
	stuff = list(/obj/item/ammo_box/magazine/m39/ext)
