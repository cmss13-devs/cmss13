/datum/faction/upp
	name = "Union of Progressive Peoples"
	faction_tag = FACTION_UPP

/datum/faction/upp/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/default_color = FALSE //so squad units get red icons as survs and ERT
	var/datum/squad/squad = human.assigned_squad

	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_UPP_MEDIC)
			hud_icon_state = "med"
			default_color = TRUE
		if(JOB_UPP_ENGI)
			hud_icon_state = "sapper"
			default_color = TRUE
		if(JOB_UPP_SPECIALIST)
			hud_icon_state = "spec"
			default_color = TRUE
		if(JOB_UPP_LEADER)
			hud_icon_state = "sl"
			default_color = TRUE
		if(JOB_UPP_POLICE)
			hud_icon_state = "mp"
		if(JOB_UPP_LT_OFFICER)
			hud_icon_state = "lt"
		if(JOB_UPP_SRLT_OFFICER)
			hud_icon_state = "slt"
		if(JOB_UPP_KPT_OFFICER)
			hud_icon_state = "xo"
		if(JOB_UPP_CO_OFFICER, JOB_UPP_MAY_OFFICER, JOB_UPP_LTKOL_OFFICER, JOB_UPP_KOL_OFFICER)
			hud_icon_state = "co"
		if(JOB_UPP_BRIG_GENERAL, JOB_UPP_MAY_GENERAL, JOB_UPP_LT_GENERAL, JOB_UPP_GENERAL)
			hud_icon_state = "hc"
		if(JOB_UPP_COMBAT_SYNTH, JOB_UPP_SUPPORT_SYNTH)
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
		if(JOB_UPP_PILOT)
			hud_icon_state = "vc"
		if(JOB_UPP_SUPPLY)
			hud_icon_state = "log"
		if(JOB_UPP_COMMISSAR)
			hud_icon_state = "commi"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', human, "upp_background")
		var/image/rank_icon_image = image('icons/mob/hud/marine_hud.dmi', human, "upp_[hud_icon_state]")
		if(istype(squad))
			human.langchat_color = human.assigned_squad.chat_color
			rank_icon_image.color = squad.equipment_color
			var/image/squad_circle = image('icons/mob/hud/marine_hud.dmi', human, "upp_squad_circle")
			squad_circle.color = squad.equipment_color
			holder.overlays += squad_circle
		else
			if(default_color)
				rank_icon_image.color = "#e61919"
		holder.overlays += rank_icon_image

/datum/faction/upp/get_antag_guns_snowflake_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("Type 71 Pulse Rifle", 20, /obj/item/weapon/gun/rifle/type71, null, VENDOR_ITEM_RECOMMENDED),
		list("Type 71 Pulse Rifle Carbine", 20, /obj/item/weapon/gun/rifle/type71/carbine, null, VENDOR_ITEM_REGULAR),
		list("Type 64 Submachinegun", 20, /obj/item/weapon/gun/smg/bizon/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 23 Riot Shotgun", 20, /obj/item/weapon/gun/shotgun/type23, null, VENDOR_ITEM_REGULAR),


		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 15, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Magazine (5.45x39mm)", 5, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_REGULAR),
		list("Type 64 Helical Magazine (7.62x19mm)", 5, /obj/item/ammo_magazine/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("Handful of Heavy Buckshot Shells (8g)", 5, /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("Type 73 Pistol", 15, /obj/item/weapon/gun/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("NP92 Pistol", 15, /obj/item/weapon/gun/pistol/np92, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Revolver", 15, /obj/item/weapon/gun/revolver/upp, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("Type 73 Magazine (7.62x25mm Tokarev)", 5, /obj/item/ammo_magazine/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Speed Loader (7.62x38mmR)", 5, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),
		list("NP92 Magazine (9x18mm Makarov)", 5, /obj/item/ammo_magazine/pistol/np92, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", 20, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_REGULAR),
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
		list("Type 71 Pulse Rifle", 20, /obj/item/weapon/gun/rifle/type71, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle Carbine", 20, /obj/item/weapon/gun/rifle/type71/carbine, null, VENDOR_ITEM_REGULAR),
		list("Type 64 Submachinegun", 20, /obj/item/weapon/gun/smg/bizon/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 23 Riot Shotgun", 20, /obj/item/weapon/gun/shotgun/type23, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
		list("Type 71 Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_RECOMMENDED),
		list("Type 64 Helical Magazine (7.62x19mm)", 60, /obj/item/ammo_magazine/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("Handful of Heavy Buckshot Shells (8g)", 60, /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("Type 73 Pistol", 20, /obj/item/weapon/gun/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("NP02 Pistol", 20, /obj/item/weapon/gun/pistol/np92, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Revolver", 20, /obj/item/weapon/gun/revolver/upp, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("Type 73 Magazine (7.62x25mm Tokarev)", 40, /obj/item/ammo_magazine/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("NP92 Magazine (9x18mm Makarov)", 40, /obj/item/ammo_magazine/pistol/np92, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Speed Loader (7.62x38mmR)", 40, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("M94 Marking Flare Pack", 20, /obj/item/storage/box/m94, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 80 Bayonet", 40, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
	)
