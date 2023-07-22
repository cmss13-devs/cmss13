/datum/faction/upp
	name = "Union of Progressive Peoples"
	faction_tag = FACTION_UPP

/datum/faction/upp/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_UPP_MEDIC)
			hud_icon_state = "med"
		if(JOB_UPP_ENGI)
			hud_icon_state = "sapper"
		if(JOB_UPP_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_UPP_LEADER)
			hud_icon_state = "sl"
		if(JOB_UPP_POLICE)
			hud_icon_state = "mp"
		if(JOB_UPP_LT_OFFICER)
			hud_icon_state = "lt"
		if(JOB_UPP_SRLT_OFFICER)
			hud_icon_state = "slt"
		if(JOB_UPP_MAY_OFFICER)
			hud_icon_state = "may"
		if(JOB_UPP_KOL_OFFICER)
			hud_icon_state = "kol"
		if(JOB_UPP_COMBAT_SYNTH)
			hud_icon_state = "synth"
		if(JOB_UPP_COMMANDO)
			hud_icon_state = "com"
		if(JOB_UPP_COMMANDO_MEDIC)
			hud_icon_state = "commed"
		if(JOB_UPP_COMMANDO_LEADER)
			hud_icon_state = "comsl"
		if(JOB_UPP_CREWMAN)
			hud_icon_state = "vc"
		if(JOB_UPP_LT_DOKTOR)
			hud_icon_state = "doc"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "upp_[hud_icon_state]")

/datum/faction/upp/get_antag_guns_snowflake_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("CZ-81 Machine Pistol", 20, /obj/item/weapon/gun/pistol/skorpion/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle", 30, /obj/item/weapon/gun/rifle/type71, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle Carbine", 30, /obj/item/weapon/gun/rifle/type71/carbine, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("CZ-81 Magazine (.32ACP)", 5, /obj/item/ammo_magazine/pistol/skorpion, null, VENDOR_ITEM_REGULAR),
		list("Type 71 AP Magazine (5.45x39mm)", 15, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Magazine (5.45x39mm)", 5, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("Highpower Automag", 15, /obj/item/weapon/gun/pistol/highpower, null, VENDOR_ITEM_REGULAR),
		list("Korovin PK-9 Pistol", 15, /obj/item/weapon/gun/pistol/c99/upp, null, VENDOR_ITEM_REGULAR),
		list("N-Y 7.62mm Revolver", 15, /obj/item/weapon/gun/revolver/nagant, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("Highpower Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/highpower, null, VENDOR_ITEM_REGULAR),
		list("N-Y Speed Loader (7.62x38mmR)", 5, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),
		list("PK-9 Magazine (.22 Hollowpoint)", 5, /obj/item/ammo_magazine/pistol/c99, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
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
		list("M94 Marking Flare Pack", 3, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 80 Bayonet", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
	)

/datum/faction/upp/get_antag_guns_sorted_equipment()
	return list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("CZ-81 Machine Pistol", 20, /obj/item/weapon/gun/pistol/skorpion/upp, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle", 20, /obj/item/weapon/gun/rifle/type71, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle Carbine", 20, /obj/item/weapon/gun/rifle/type71/carbine, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("CZ-81 Magazine (.32ACP)", 60, /obj/item/ammo_magazine/pistol/skorpion, VENDOR_ITEM_REGULAR),
		list("Type 71 AP Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71/ap, VENDOR_ITEM_REGULAR),
		list("Type 71 Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("Highpower Automag", 20, /obj/item/weapon/gun/pistol/highpower, VENDOR_ITEM_REGULAR),
		list("Korovin PK-9 Pistol", 20, /obj/item/weapon/gun/pistol/c99/upp, VENDOR_ITEM_REGULAR),
		list("N-Y 7.62mm Revolver", 20, /obj/item/weapon/gun/revolver/nagant, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("Highpower Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/highpower, VENDOR_ITEM_REGULAR),
		list("N-Y Speed Loader (7.62x38mmR)", 40, /obj/item/ammo_magazine/revolver/upp, VENDOR_ITEM_REGULAR),
		list("PK-9 Magazine (.22 Hollowpoint)", 40, /obj/item/ammo_magazine/pistol/c99, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("M94 Marking Flare Pack", 20, /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("Type 80 Bayonet", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
	)
