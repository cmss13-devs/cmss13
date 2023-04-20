/datum/faction/wy
	name = "Weyland Yutani"
	faction_tag = FACTION_WY

/datum/faction/wy/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		/// Weyland Yutani Generic Roles
		if(JOB_CORPORATE_LIAISON)
			hud_icon_state = "wy_liaison"
		if(JOB_TRAINEE, JOB_JUNIOR_EXECUTIVE, JOB_EXECUTIVE)
			hud_icon_state = "wy_junior"
		if(JOB_SENIOR_EXECUTIVE, JOB_EXECUTIVE_SPECIALIST, JOB_EXECUTIVE_SUPERVISOR)
			hud_icon_state = "wy_senior"
		if(JOB_ASSISTANT_MANAGER, JOB_DIVISION_MANAGER)
			hud_icon_state = "wy_manager"
		if(JOB_CHIEF_EXECUTIVE, JOB_DIRECTOR)
			hud_icon_state = "wy_director"
		if(JOB_WY_GOON)
			hud_icon_state = "wy_goon"
		if(JOB_WY_GOON_LEAD)
			hud_icon_state = "wy_goon_ld"
		if(JOB_WY_GOON_RESEARCHER)
			hud_icon_state = "wy_goon_rsr"

		/// WY PMC Roles
		if(JOB_PMC_DIRECTOR)
			hud_icon_state = "pmc_sd"
		if(JOB_PMC_LEADER, JOB_PMC_LEAD_INVEST)
			hud_icon_state = "pmc_ld"
		if(JOB_PMC_DOCTOR)
			hud_icon_state = "pmc_td"
		if(JOB_PMC_ENGINEER)
			hud_icon_state = "pmc_ct"
		if(JOB_PMC_MEDIC, JOB_PMC_INVESTIGATOR)
			hud_icon_state = "pmc_md"
		if(JOB_PMC_SYNTH)
			hud_icon_state = "pmc_syn"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, hud_icon_state)
	if(!(H.mob_flags & ROGUE_UNIT)) //PMCs are only explicitly shown if it's their primary faction, or they're not grouped under WY
		if ((H.faction == FACTION_PMC) || (!(FACTION_WY in H.faction_group) && (FACTION_PMC in H.faction_group)))
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "allegiance_W-Y_PMC")
		else if ((H.faction == FACTION_WY) || (FACTION_WY in H.faction_group))
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "allegiance_W-Y")

/datum/faction/wy/get_antag_guns_snowflake_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("M41A Pulse Rifle", 30, /obj/item/weapon/gun/rifle/m41a/corporate, null, VENDOR_ITEM_REGULAR),
		list("NSG23 assault rifle", 20, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle, null, VENDOR_ITEM_REGULAR),
		list("M41A extended magazine (10x24mm)", 5, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/nsg23, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 extended magazine (10x24mm)", 5, /obj/item/ammo_magazine/rifle/nsg23/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("88 Mod 4 Combat Pistol", 15, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
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

/datum/faction/wy/get_antag_guns_sorted_equipment()
	return list(
		list("PRIMARY FIREARMS", 0, null, null, null),
		list("M41A Pulse Rifle", 30, /obj/item/weapon/gun/rifle/m41a/corporate, null, VENDOR_ITEM_REGULAR),
		list("NSG23 assault rifle", 30, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A magazine (10x24mm)", 30, /obj/item/ammo_magazine/rifle, null, VENDOR_ITEM_REGULAR),
		list("M41A extended magazine (10x24mm)", 50, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 magazine (10x24mm)", 30, /obj/item/ammo_magazine/rifle/nsg23, null, VENDOR_ITEM_REGULAR),
		list("NSG 23 extended magazine (10x24mm)", 50, /obj/item/ammo_magazine/rifle/nsg23/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", 0, null, null, null),
		list("88 Mod 4 Combat Pistol", 30, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("88M4 AP Magazine (9mm)", 50, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("M94 Marking Flare Pack", 30, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade", 30, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)
