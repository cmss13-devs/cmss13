/datum/faction/wy/pmc
	name = "Private Military Company"
	desc = "Weyland-Yutani PMCs are military personnel owned and operated by the company. They are equipped with advanced modern military equipment and weaponry akin to the USCM and similar national militaries. The tasks of the PMCs are never limited to one specific job and they are often deployed on 'shadow missions'. Their deployment is often kept secret from the USCM to avoid conflict with the anti-corporate officers in the USCM. The recruitment process largely consists of those who have personal contacts with higher Weyland-Yutani employees, or those who have caught the eye of the superiors and been hand-picked. The superiors value abilities in the field and willingness to obey company directives, for a large sum of money, despite of their moral beliefs. Following the defeat of the Dust Raiders and the withdrawal of the United Americas of the Neroid sector, a group of employees became skilled mercenaries. They are part of Weyland-Yutani's Task Force Oberon that was stationed aboard the USCSS Royce, a powerful Weyland-Yutani cruiser that patrols the outer edges of the Neroid sector. Under the directive of Weyland-Yutani's board member Johan Almric, they act as private security for company science teams. The USCSS Royce contains a crew of roughly two hundred PMCs, and one hundred scientists and support personnel. Rumors say that a Weyland-Yutani Special Task Force known as \"Royal\" of the USCSS Lunalorne are part of a different specialization, designed to capture anomalies associated with alien and supernatural life."
	code_identificator = FACTION_PMC

	faction_iff_tag_type = /obj/item/faction_tag/wy/pmc

	minimap_flag = MINIMAP_FLAG_WY

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
