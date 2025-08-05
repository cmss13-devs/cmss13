/datum/faction/clf
	name = "Colonial Liberation Front"
	faction_tag = FACTION_CLF

/datum/faction/clf/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CLF_ENGI)
			hud_icon_state = "engi"
		if(JOB_CLF_MEDIC)
			hud_icon_state = "med"
		if(JOB_CLF_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_CLF_LEADER)
			hud_icon_state = "sl"
		if(JOB_CLF_SYNTH)
			hud_icon_state = "synth"
		if(JOB_CLF_COMMANDER)
			hud_icon_state = "cellcom"
		if(JOB_CLF_COORDINATOR)
			hud_icon_state = "cr"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', human, "clf_[hud_icon_state]")

/datum/faction/clf/get_antag_guns_snowflake_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("ABR-40 Hunting Rifle", 30, /obj/item/weapon/gun/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("Basira-Armstrong Bolt-Action", 15, /obj/item/weapon/gun/boltaction, null, VENDOR_ITEM_REGULAR),
		list("Double Barrel Shotgun", 30, /obj/item/weapon/gun/shotgun/double, null, VENDOR_ITEM_REGULAR),
		list("HG 37-12 Pump Shotgun", 30, /obj/item/weapon/gun/shotgun/double/sawn, null, VENDOR_ITEM_REGULAR),
		list("M16 Rifle", 30, /obj/item/weapon/gun/rifle/m16, null, VENDOR_ITEM_REGULAR),
		list("MAR-30 Battle Carbine", 30, /obj/item/weapon/gun/rifle/mar40/carbine, null, VENDOR_ITEM_REGULAR),
		list("MAR-40 Battle Rifle", 30, /obj/item/weapon/gun/rifle/mar40, null, VENDOR_ITEM_REGULAR),
		list("Type-64 Submachinegun", 20, /obj/item/weapon/gun/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("MAC-15 Submachinegun", 20, /obj/item/weapon/gun/smg/mac15, null, VENDOR_ITEM_REGULAR),
		list("MP27 Submachinegun", 20, /obj/item/weapon/gun/smg/mp27, null, VENDOR_ITEM_REGULAR),
		list("MP5 Submachinegun", 20, /obj/item/weapon/gun/smg/mp5, null, VENDOR_ITEM_REGULAR),
		list("Sawn-Off Shotgun", 30, /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("ABR-40 Magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("Basira-Armstrong Magazine (6.5mm)", 5, /obj/item/ammo_magazine/rifle/boltaction, null, VENDOR_ITEM_REGULAR),
		list("Box Of Buckshot Shells", 10, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells", 10, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs", 10, /obj/item/ammo_magazine/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M16 AP Magazine (5.56x45mm)", 15, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
		list("M16 Magazine (5.56x45mm)", 5, /obj/item/ammo_magazine/rifle/m16, null, VENDOR_ITEM_REGULAR),
		list("MAC-15 Magazine (9mm)", 5, /obj/item/ammo_magazine/smg/mac15, null, VENDOR_ITEM_REGULAR),
		list("MAR Magazine (7.62x39mm)", 5, /obj/item/ammo_magazine/rifle/mar40, null, VENDOR_ITEM_REGULAR),
		list("MAR Extended Magazine (7.62x39mm)", 15, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
		list("Type-64 Helical Magazine (.7.62x19mm)", 5, /obj/item/ammo_magazine/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("MP27 Magazine (4.6x30mm)", 5, /obj/item/ammo_magazine/smg/mp27, null, VENDOR_ITEM_REGULAR),
		list("MP5 Magazine (9mm)", 5, /obj/item/ammo_magazine/smg/mp5, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("88 Mod 4 Combat Pistol", 15, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),
		list("Beretta 92FS Pistol", 15, /obj/item/weapon/gun/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
		list("CMB Spearhead Autorevolver", 15, /obj/item/weapon/gun/revolver/cmb, null, VENDOR_ITEM_REGULAR),
		list("Holdout Pistol", 10, /obj/item/weapon/gun/pistol/holdout, null, VENDOR_ITEM_REGULAR),
		list("KT-42 Automag", 15, /obj/item/weapon/gun/pistol/kt42, null, VENDOR_ITEM_REGULAR),
		list("S&W .357 Revolver", 15, /obj/item/weapon/gun/revolver/small, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("88M4 AP Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),
		list("Beretta 92FS Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
		list("KT-42 Magazine (.44)", 5, /obj/item/ammo_magazine/pistol/kt42, null, VENDOR_ITEM_REGULAR),
		list("Spearhead Speed Loader (.357)", 10, /obj/item/ammo_magazine/revolver/cmb/normalpoint, VENDOR_ITEM_REGULAR),
		list("Hollowpoint Spearhead Speed Loader (.357)", 5, /obj/item/ammo_magazine/revolver/cmb, VENDOR_ITEM_REGULAR),
		list("S&W Speed Loader (.357)", 5, /obj/item/ammo_magazine/revolver/small, null, VENDOR_ITEM_REGULAR),
		list("Tiny Pistol Magazine (.22)", 5, /obj/item/ammo_magazine/pistol/holdout, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("2x Hunting Mini-Scope", 20, /obj/item/attachable/scope/mini/hunting, null, VENDOR_ITEM_REGULAR),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Type 80 Bayonet", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
		list("Lunge Mine", 120, /obj/item/weapon/twohanded/lungemine, null, VENDOR_ITEM_REGULAR),
		list("Melee Weapon (Random)", 7, /obj/effect/essentials_set/random/clf_melee, null, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", 3, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)

/datum/faction/clf/get_antag_guns_sorted_equipment()
	return list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("ABR-40 Hunting Rifle", 30, /obj/item/weapon/gun/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("Basira-Armstrong Bolt-Action", 15, /obj/item/weapon/gun/boltaction, null, VENDOR_ITEM_REGULAR),
		list("Double Barrel Shotgun", 20, /obj/item/weapon/gun/shotgun/double, VENDOR_ITEM_REGULAR),
		list("HG 37-12 Pump Shotgun", 20, /obj/item/weapon/gun/shotgun/double/sawn, VENDOR_ITEM_REGULAR),
		list("M16 Rifle", 20, /obj/item/weapon/gun/rifle/m16, VENDOR_ITEM_REGULAR),
		list("MAC-15 Submachinegun", 20, /obj/item/weapon/gun/smg/mac15, VENDOR_ITEM_REGULAR),
		list("MAR-30 Battle Carbine", 20, /obj/item/weapon/gun/rifle/mar40/carbine, VENDOR_ITEM_REGULAR),
		list("MAR-40 Battle Rifle", 20, /obj/item/weapon/gun/rifle/mar40, VENDOR_ITEM_REGULAR),
		list("Type 64 Submachinegun", 20, /obj/item/weapon/gun/smg/bizon, VENDOR_ITEM_REGULAR),
		list("MP27 Submachinegun", 20, /obj/item/weapon/gun/smg/mp27, VENDOR_ITEM_REGULAR),
		list("MP5 Submachinegun", 20, /obj/item/weapon/gun/smg/mp5, VENDOR_ITEM_REGULAR),
		list("Sawn-Off Shotgun", 20, /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("ABR-40 Magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("Basira-Armstrong Magazine (6.5mm)", 5, /obj/item/ammo_magazine/rifle/boltaction, null, VENDOR_ITEM_REGULAR),
		list("Box Of Buckshot Shells", 15, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells", 15, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs", 15, /obj/item/ammo_magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, VENDOR_ITEM_REGULAR),
		list("M16 Magazine (5.56x45mm)", 60, /obj/item/ammo_magazine/rifle/m16, VENDOR_ITEM_REGULAR),
		list("MAC-15 Magazine (9mm)", 60, /obj/item/ammo_magazine/smg/mac15, VENDOR_ITEM_REGULAR),
		list("MAR Magazine (7.62x39mm)", 60, /obj/item/ammo_magazine/rifle/mar40, VENDOR_ITEM_REGULAR),
		list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, VENDOR_ITEM_REGULAR),
		list("Type 64 Helical Magazine (7.62x19mm)", 60, /obj/item/ammo_magazine/smg/bizon, VENDOR_ITEM_REGULAR),
		list("MP27 Magazine (4.6x30mm)", 60, /obj/item/ammo_magazine/smg/mp27, VENDOR_ITEM_REGULAR),
		list("MP5 Magazine (9mm)", 60, /obj/item/ammo_magazine/smg/mp5, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", 20, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("Beretta 92FS Pistol", 20, /obj/item/weapon/gun/pistol/b92fs, VENDOR_ITEM_REGULAR),
		list("CMB Spearhead Autorevolver", 20, /obj/item/weapon/gun/revolver/cmb, VENDOR_ITEM_REGULAR),
		list("Holdout Pistol", 20, /obj/item/weapon/gun/pistol/holdout, VENDOR_ITEM_REGULAR),
		list("KT-42 Automag", 20, /obj/item/weapon/gun/pistol/kt42, VENDOR_ITEM_REGULAR),
		list("S&W .357 Revolver", 20, /obj/item/weapon/gun/revolver/small, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("88M4 AP Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("Beretta 92FS Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/b92fs, VENDOR_ITEM_REGULAR),
		list("KT-42 Magazine (.44)", 40, /obj/item/ammo_magazine/pistol/kt42, VENDOR_ITEM_REGULAR),
		list("Spearhead Speed Loader (.357)", 40, /obj/item/ammo_magazine/revolver/cmb/normalpoint, VENDOR_ITEM_REGULAR),
		list("Hollowpoint Spearhead Speed Loader (.357)", 40, /obj/item/ammo_magazine/revolver/cmb, VENDOR_ITEM_REGULAR),
		list("S&W Speed Loader (.357)", 40, /obj/item/ammo_magazine/revolver/small, VENDOR_ITEM_REGULAR),
		list("Tiny Pistol Magazine (.22)", 40, /obj/item/ammo_magazine/pistol/holdout, VENDOR_ITEM_REGULAR),

		list("MELEE WEAPONS", -1, null, null),
		list("Baseball Bat", 10, /obj/item/weapon/baseballbat, VENDOR_ITEM_REGULAR),
		list("Baseball Bat (Metal)", 5, /obj/item/weapon/baseballbat/metal, VENDOR_ITEM_REGULAR),
		list("Fireaxe", 5, /obj/item/weapon/twohanded/fireaxe, VENDOR_ITEM_REGULAR),
		list("Hatchet", 15, /obj/item/tool/hatchet, VENDOR_ITEM_REGULAR),
		list("Spear", 10, /obj/item/weapon/twohanded/spear, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("M94 Marking Flare Pack", 20, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("Type 80 Bayonet", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
	)
