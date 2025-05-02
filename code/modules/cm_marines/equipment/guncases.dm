/obj/item/storage/box/guncase
	name = "\improper gun case"
	desc = "It has space for firearm(s). Sometimes magazines or other munitions as well."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "guncase"
	item_state = "guncase"
	w_class = SIZE_HUGE
	max_w_class = SIZE_HUGE //shouldn't be a problem since we can only store the guns and ammo.
	storage_slots = 1
	slowdown = 1
	can_hold = list()//define on a per case basis for the original firearm.
	foldable = TRUE
	foldable = /obj/item/stack/sheet/mineral/plastic//it makes sense
	ground_offset_y = 5

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
	desc = "A gun case containing the SU-6 smart pistol. Comes with a full belt holster."
	can_hold = list(/obj/item/storage/belt/gun/smartpistol, /obj/item/weapon/gun/pistol/smart, /obj/item/ammo_magazine/pistol/smart)
	storage_slots = 2

/obj/item/storage/box/guncase/smartpistol/fill_preset_inventory()
	new /obj/item/storage/belt/gun/smartpistol/full_nogun(src)
	new /obj/item/weapon/gun/pistol/smart(src)

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
	storage_slots = 5
	can_hold = list(/obj/item/weapon/gun/rifle/lmg, /obj/item/ammo_magazine/rifle/lmg)

/obj/item/storage/box/guncase/lmg/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg/holo_target(src)
	new /obj/item/attachable/flashlight

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


/obj/item/storage/box/guncase/m41aMK1AP
	name = "\improper M41A pulse rifle MK1 AP case"
	desc = "A gun case containing the M41A pulse rifle MK1 loaded with AP rounds. It can only use proprietary MK1 magazines."
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/rifle/m41aMK1, /obj/item/ammo_magazine/rifle/m41aMK1)

/obj/item/storage/box/guncase/m41aMK1AP/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/m41aMK1/ap(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1/ap(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1/ap(src)

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

/obj/item/storage/box/guncase/xm88
	name = "\improper XM88 heavy rifle case"
	desc = "A gun case containing the XM88 Heavy Rifle, a prototype weapon designed for use against heavily armored infantry targets and light vehicles. Contains an ammunition belt, two boxes of ammunition, the XS-9 Targeting Relay attachment, and the stock for the rifle."
	storage_slots = 6
	can_hold = list(/obj/item/weapon/gun/lever_action/xm88, /obj/item/attachable/stock/xm88, /obj/item/attachable/scope/mini/xm88, /obj/item/ammo_magazine/lever_action/xm88, /obj/item/storage/belt/shotgun/xm88)

/obj/item/storage/box/guncase/xm88/fill_preset_inventory()
	new /obj/item/weapon/gun/lever_action/xm88(src)
	new /obj/item/attachable/stock/xm88(src)
	new /obj/item/attachable/scope/mini/xm88(src)
	new /obj/item/ammo_magazine/lever_action/xm88(src)
	new /obj/item/ammo_magazine/lever_action/xm88(src)
	new /obj/item/storage/belt/shotgun/xm88(src)

//------------
/obj/item/storage/box/guncase/flamer
	name = "\improper M240 incinerator case"
	desc = "A gun case containing the M240A1 incinerator unit. It does come loaded, but you'll still have to find extra tanks as you go."
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/flamer/m240, /obj/item/ammo_magazine/flamer_tank, /obj/item/attachable/attached_gun/extinguisher)

/obj/item/storage/box/guncase/flamer/fill_preset_inventory()
	new /obj/item/weapon/gun/flamer/m240(src)
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

//------------
/obj/item/storage/box/guncase/m41a
	name = "\improper M41A pulse rifle MK2 case"
	desc = "A gun case containing the M41A pulse rifle MK2."
	storage_slots = 5
	can_hold = list(/obj/item/weapon/gun/rifle/m41a, /obj/item/ammo_magazine/rifle)

/obj/item/storage/box/guncase/m41a/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/m41a(src)
	for(var/i = 1 to 4)
		new /obj/item/ammo_magazine/rifle(src)


//------------
/obj/item/storage/box/guncase/pumpshotgun
	name = "\improper M37A2 Pump Shotgun case"
	desc = "A gun case containing the M37A2 Pump Shotgun."
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/shotgun/pump, /obj/item/ammo_magazine/shotgun/buckshot, /obj/item/ammo_magazine/shotgun/flechette, /obj/item/ammo_magazine/shotgun/slugs)

/obj/item/storage/box/guncase/pumpshotgun/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/pump(src)
	for(var/i = 1 to 3)
		var/random_pick = rand(1, 3)
		switch(random_pick)
			if(1)
				new /obj/item/ammo_magazine/shotgun/buckshot(src)
			if(2)
				new /obj/item/ammo_magazine/shotgun/flechette(src)
			if(3)
				new /obj/item/ammo_magazine/shotgun/slugs(src)

/obj/item/storage/box/guncase/mk45_automag
	name = "\improper MK-45 Automagnum case"
	desc = "A gun case containing the MK-45 'High-Power' Automagnum sidearm. While this weapon was rejected as a replacement for the M44 Combat Revolver, it is often back-issued to troops who prefer its powerful bullets over more common sidearms."
	storage_slots = 6
	can_hold = list(/obj/item/weapon/gun/pistol/highpower, /obj/item/ammo_magazine/pistol/highpower)

/obj/item/storage/box/guncase/mk45_automag/fill_preset_inventory()
	if(prob(30))
		new /obj/item/weapon/gun/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
		new /obj/item/ammo_magazine/pistol/highpower(src)
	else
		new /obj/item/weapon/gun/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)


/obj/item/storage/box/guncase/nsg23_marine
	name = "\improper NSG-23 assault rifle case"
	desc = "A gun case containing the NSG 23 assault rifle. While usually seen in the hands of PMCs, this weapon is sometimes issued to USCM personnel."
	storage_slots = 6
	can_hold = list(/obj/item/weapon/gun/rifle/nsg23/no_lock, /obj/item/ammo_magazine/rifle/nsg23)

/obj/item/storage/box/guncase/nsg23_marine/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/nsg23/no_lock(src)
	new /obj/item/ammo_magazine/rifle/nsg23/ap(src)
	new /obj/item/ammo_magazine/rifle/nsg23/extended(src)
	new /obj/item/ammo_magazine/rifle/nsg23(src)
	new /obj/item/ammo_magazine/rifle/nsg23(src)
	new /obj/item/ammo_magazine/rifle/nsg23(src)

/obj/item/storage/box/guncase/m3717
	name = "\improper M37-17 pump shotgun case"
	desc = "A gun case containing the M37-17 pump shotgun. Rarely seen issued to USCM vessels on the edges of inhabited space who need the extra bang for their buck (literally) the M37-17 has. Like this one! Well, if it had the budget for it."
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717, /obj/item/ammo_magazine/shotgun/buckshot)

/obj/item/storage/box/guncase/m3717/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)

/obj/item/storage/box/guncase/m1911
	name = "\improper M1911 service pistol case"
	desc = "A gun case containing the M1911 service pistol. It might be three centuries old but it's still a damn good pistol. Back-issue only, though."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/gun/pistol/m1911, /obj/item/ammo_magazine/pistol/m1911)

/obj/item/storage/box/guncase/m1911/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/box/guncase/m1911/socom
	name = "\improper SOCOM M1911 service pistol case"
	storage_slots = 7
	can_hold = list(/obj/item/weapon/gun/pistol/m1911/socom, /obj/item/ammo_magazine/pistol/m1911)

/obj/item/storage/box/guncase/m1911/socom/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/m1911/socom(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/box/guncase/cane_gun_kit
	name = "spy-agent cane case"
	desc = "A gun case containing a top-secret Gun Cane chambered in .44, alongside two spare handfuls of said caliber. Make sure to fold this after you use it!"
	can_hold = list(/obj/item/weapon/gun/shotgun/double/cane, /obj/item/ammo_magazine/handful/revolver)
	storage_slots = 3

/obj/item/storage/box/guncase/cane_gun_kit/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/double/cane(src)
	new /obj/item/ammo_magazine/handful/revolver/marksman/six_rounds(src)
	new /obj/item/ammo_magazine/handful/revolver/marksman/six_rounds(src)

/obj/item/storage/box/guncase/vulture
	name = "\improper M707 anti-materiel rifle case"
	desc = "A gun case containing the M707 \"Vulture\" anti-materiel rifle and its requisite spotting tools."
	icon_state = "guncase_blue"
	item_state = "guncase_blue"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/boltaction/vulture,
		/obj/item/ammo_magazine/rifle/boltaction/vulture,
		/obj/item/device/vulture_spotter_tripod,
		/obj/item/device/vulture_spotter_scope,
		/obj/item/tool/screwdriver,
		/obj/item/pamphlet/trait/vulture,
	)

/obj/item/storage/box/guncase/vulture/update_icon()
	if(LAZYLEN(contents))
		icon_state = "guncase_blue"
	else
		icon_state = "guncase_blue_e"

/obj/item/storage/box/guncase/vulture/fill_preset_inventory()
	var/obj/item/weapon/gun/boltaction/vulture/rifle = new(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture(src)
	new /obj/item/device/vulture_spotter_tripod(src)
	new /obj/item/device/vulture_spotter_scope(src, WEAKREF(rifle))
	new /obj/item/tool/screwdriver(src) // Spotter scope needs a screwdriver to disassemble
	new /obj/item/pamphlet/trait/vulture(src) //both pamphlets give use of the scope and the rifle
	new /obj/item/pamphlet/trait/vulture(src)

/obj/item/storage/box/guncase/vulture/skillless
	storage_slots = 5

/obj/item/storage/box/guncase/vulture/skillless/fill_preset_inventory()
	var/obj/item/weapon/gun/boltaction/vulture/skillless/rifle = new(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture(src)
	new /obj/item/device/vulture_spotter_tripod(src)
	new /obj/item/device/vulture_spotter_scope/skillless(src, WEAKREF(rifle))
	new /obj/item/tool/screwdriver(src) // Spotter scope needs a screwdriver to disassemble

/obj/item/storage/box/guncase/vulture/holo_target
	name = "\improper M707 holo-targetting anti-materiel rifle case"
	desc = "A gun case containing the M707 \"Vulture\" anti-materiel rifle and its requisite spotting tools. This variant is pre-loaded with <b>IFF-CAPABLE</b> holo-targeting rounds."

/obj/item/storage/box/guncase/vulture/holo_target/fill_preset_inventory()
	var/obj/item/weapon/gun/boltaction/vulture/holo_target/rifle = new(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target(src)
	new /obj/item/device/vulture_spotter_tripod(src)
	new /obj/item/device/vulture_spotter_scope(src, WEAKREF(rifle))
	new /obj/item/tool/screwdriver(src)
	new /obj/item/pamphlet/trait/vulture(src)
	new /obj/item/pamphlet/trait/vulture(src)

/obj/item/storage/box/guncase/vulture/holo_target/skillless
	storage_slots = 5

/obj/item/storage/box/guncase/vulture/holo_target/skillless/fill_preset_inventory()
	var/obj/item/weapon/gun/boltaction/vulture/holo_target/skillless/rifle = new(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target(src)
	new /obj/item/device/vulture_spotter_tripod(src)
	new /obj/item/device/vulture_spotter_scope/skillless(src, WEAKREF(rifle))
	new /obj/item/tool/screwdriver(src)


/obj/item/storage/box/guncase/xm51
	name = "\improper XM51 breaching scattergun case"
	desc = "A gun case containing the XM51 Breaching Scattergun. Comes with two spare magazines, two spare shell boxes, an optional stock and a belt to holster the weapon."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/gun/rifle/xm51, /obj/item/ammo_magazine/rifle/xm51, /obj/item/storage/belt/gun/xm51, /obj/item/attachable/stock/xm51)

/obj/item/storage/box/guncase/xm51/fill_preset_inventory()
	new /obj/item/attachable/stock/xm51(src)
	new /obj/item/weapon/gun/rifle/xm51(src)
	new /obj/item/ammo_magazine/rifle/xm51(src)
	new /obj/item/ammo_magazine/rifle/xm51(src)
	new /obj/item/ammo_magazine/shotgun/light/breaching(src)
	new /obj/item/ammo_magazine/shotgun/light/breaching(src)
	new /obj/item/storage/belt/gun/xm51(src)

//Handgun case for Military police vendor three mag , a railflashligh and the handgun.

//88 Mod 4 Combat Pistol
/obj/item/storage/box/guncase/mod88
	name = "\improper 88 Mod 4 Combat Pistol case"
	desc = "A gun case containing an 88 Mod 4 Combat Pistol."
	storage_slots = 8
	can_hold = list(/obj/item/attachable/flashlight, /obj/item/weapon/gun/pistol/mod88, /obj/item/ammo_magazine/pistol/mod88)

/obj/item/storage/box/guncase/mod88/fill_preset_inventory()
	new /obj/item/attachable/flashlight(src)
	new /obj/item/weapon/gun/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)

//M44 Combat Revolver
/obj/item/storage/box/guncase/m44
	name = "\improper M44 Combat Revolver case"
	desc = "A gun case containing an M44 Combat Revolver loaded with marksman ammo."
	storage_slots = 8
	can_hold = list(/obj/item/attachable/flashlight, /obj/item/weapon/gun/revolver/m44, /obj/item/ammo_magazine/revolver)

/obj/item/storage/box/guncase/m44/fill_preset_inventory()
	new /obj/item/attachable/flashlight(src)
	new /obj/item/weapon/gun/revolver/m44/mp(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)

//M4A3 Service Pistol
/obj/item/storage/box/guncase/m4a3
	name = "\improper M4A3 Service Pistol case"
	desc = "A gun case containing an M4A3 Service Pistol."
	storage_slots = 8
	can_hold = list(/obj/item/attachable/flashlight, /obj/item/weapon/gun/pistol/m4a3, /obj/item/ammo_magazine/pistol)

/obj/item/storage/box/guncase/m4a3/fill_preset_inventory()
	new /obj/item/attachable/flashlight(src)
	new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

// -------- UPP Gun Kits --------

/obj/item/storage/box/guncase/type19
	name = "\improper Type-19 submachinegun case"
	desc = "A gun case containing the Type-19 submachine gun, an outdated firearm of the UPP, but still found in limited service with more outlying union forces."
	storage_slots = 6
	can_hold = list(/obj/item/weapon/gun/smg/pps43, /obj/item/ammo_magazine/smg/pps43, /obj/item/ammo_magazine/smg/pps43/extended)

/obj/item/storage/box/guncase/type19/fill_preset_inventory()
	new /obj/item/weapon/gun/smg/pps43(src)
	new /obj/item/ammo_magazine/smg/pps43(src)
	new /obj/item/ammo_magazine/smg/pps43(src)
	new /obj/item/ammo_magazine/smg/pps43(src)
	new /obj/item/ammo_magazine/smg/pps43(src)
	new /obj/item/ammo_magazine/smg/pps43(src)

/obj/item/storage/box/guncase/ppsh
	name = "\improper PPSh-17b submachinegun case"
	desc = "A gun case containing the PPSh-17b submachine gun, copy of an ancient firearm, woefully inadequate for modern warfare, but highly sought after by collectors."
	storage_slots = 6
	can_hold = list(/obj/item/weapon/gun/smg/ppsh, /obj/item/ammo_magazine/smg/ppsh, /obj/item/ammo_magazine/smg/ppsh/extended)

/obj/item/storage/box/guncase/ppsh/fill_preset_inventory()
	new /obj/item/weapon/gun/smg/ppsh(src)
	new /obj/item/ammo_magazine/smg/ppsh/extended(src)
	new /obj/item/ammo_magazine/smg/ppsh/extended(src)
	new /obj/item/ammo_magazine/smg/ppsh(src)
	new /obj/item/ammo_magazine/smg/ppsh(src)
	new /obj/item/ammo_magazine/smg/ppsh(src)
