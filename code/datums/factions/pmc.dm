/datum/faction/pmc
	name = "Private Military Company"
	faction_tag = FACTION_PMC

/datum/faction/pmc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_PMC_DIRECTOR)
			hud_icon_state = "sd"
		if(JOB_PMC_LEADER)
			hud_icon_state = "ld"
		if(JOB_PMC_LEAD_INVEST)
			hud_icon_state = "inv"
		if(JOB_PMC_DOCTOR)
			hud_icon_state = "td"
		if(JOB_PMC_ENGINEER)
			hud_icon_state = "ct"
		if(JOB_PMC_MEDIC)
			hud_icon_state = "md"
		if(JOB_PMC_INVESTIGATOR)
			hud_icon_state = "mi"
		if(JOB_PMC_SYNTH)
			hud_icon_state = "syn"
		if(JOB_PMC_XENO_HANDLER)
			hud_icon_state = "handler"
		if(JOB_PMC_GUNNER)
			hud_icon_state = "sg"
		if(JOB_PMC_DETAINER)
			hud_icon_state = "mp"
		if(JOB_PMC_CREWMAN)
			hud_icon_state = "crew"
		if(JOB_PMC_SNIPER)
			hud_icon_state = "spec"
		if(JOB_PMC_STANDARD)
			hud_icon_state = "gun"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "pmc_[hud_icon_state]")

/datum/faction/pmc/get_antag_guns_snowflake_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("M41A/2 Pulse Rifle", 30, /obj/item/weapon/gun/rifle/m41a/elite, null, VENDOR_ITEM_REGULAR),
		list("M39B/2 submachinegun", 30, /obj/item/weapon/gun/smg/m39/elite, null, VENDOR_ITEM_REGULAR),
		list("NSG23 assault rifle", 20, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A AP magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A extended magazine (10x24mm)", 5, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 AP magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 HV extended magazine (10x20mm)", 5, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 armor-piercing magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/nsg23/ap, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 extended magazine (10x24mm)", 5, /obj/item/ammo_magazine/rifle/nsg23/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("VP78 pistol", 20, /obj/item/weapon/gun/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("88 Mod 4 Combat Pistol", 15, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("VP78 magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("88M4 AP Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Advanced Underbarrel Flamethrower", 15, /obj/item/attachable/attached_gun/flamer/advanced, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("M94 Marking Flare Pack", 3, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)

/datum/faction/pmc/get_antag_guns_sorted_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("M41A/2 Pulse Rifle", 30, /obj/item/weapon/gun/rifle/m41a/elite, null, VENDOR_ITEM_REGULAR),
		list("M39B/2 submachinegun", 30, /obj/item/weapon/gun/smg/m39/elite, null, VENDOR_ITEM_REGULAR),
		list("NSG23 assault rifle", 30, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A AP magazine (10x24mm)", 30, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A extended magazine (10x24mm)", 50, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 AP magazine (10x20mm)", 30, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 HV extended magazine (10x20mm)", 50, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 armor-piercing magazine (10x24mm)", 30, /obj/item/ammo_magazine/rifle/nsg23/ap, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 extended magazine (10x24mm)", 50, /obj/item/ammo_magazine/rifle/nsg23/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("VP78 pistol", 20, /obj/item/weapon/gun/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("88 Mod 4 Combat Pistol", 30, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("VP78 magazine (9mm)", 50, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("88M4 AP Magazine (9mm)", 50, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("M94 Marking Flare Pack", 30, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 30, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)
