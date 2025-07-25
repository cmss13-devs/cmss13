// loadouts for riot_in_progress.dmm nightmare, thematic survivor preset.

/datum/equipment_preset/survivor/cmb
	name = "Survivor - Colonial Marshal"
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE, FACTION_SURVIVOR)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/human_versus_human = FALSE
	minimap_background = "background_cmb"
	access = list(
		ACCESS_LIST_UA,
	)

//*************************************************CMB****************************************************/

/datum/equipment_preset/survivor/cmb/riot
	name = "Survivor - CMB Riot Control Officer"
	paygrades = list(PAY_SHORT_CMBR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CMB RCO"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE, FACTION_SURVIVOR)
	assignment = "CMB Riot Control Officer"
	idtype = /obj/item/card/id/deputy/riot
	job_title = JOB_CMB_RIOT
	skills = /datum/skills/cmb
	minimap_icon = "deputy"

/datum/equipment_preset/survivor/cmb/riot/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,10)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/cmb, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/cmb, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/m15/rubber, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/cmb, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles/cmb_riot_shield, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/tactical, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/action, WEAR_IN_BACK)

	switch(choice)
		if(1 to 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(7 to 8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_R_STORE)
		if(9 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)

// cmb synth (of note /datum/equipment_preset/synth/survivor/cmb_synth also exists)
/datum/equipment_preset/synth/survivor/cmb
	flags = EQUIPMENT_PRESET_STUB

/datum/equipment_preset/synth/survivor/cmb/riotsynth
	name = "Survivor - Synthetic - CMB Riot Control Synthetic"
	paygrades = list(PAY_SHORT_CMBRS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CMB Syn"
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE, FACTION_SURVIVOR)
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "CMB Riot Control Synthetic"
	job_title = JOB_CMB_RSYN
	languages = ALL_SYNTH_LANGUAGES
	idtype = /obj/item/card/id/deputy/riot
	skills = /datum/skills/synthetic/cmb
	minimap_icon = "cmb_syn"
	minimap_background = "background_cmb"

/datum/equipment_preset/synth/survivor/cmb/riotsynth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/survivor/cmb/riotsynth/load_gear(mob/living/carbon/human/new_human)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/backpack/surv, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB/beret, WEAR_HEAD)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/cmb, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/autopsy_scanner, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/candy, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/imidazoline, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
	//holding
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)

//************************************************UA RIOT POLICE****************************************************/

/datum/equipment_preset/survivor/cmb/ua
	name = "Survivor - United Americas Riot Officer(Riot Response)"
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	role_comm_title = "UA RCP"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "United Americas Police Officer"
	skills = /datum/skills/civilian/survivor/marshal
	minimap_icon = "mp"
	minimap_background = "background_ua"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/survivor/cmb/ua/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,10)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

	switch(choice)
		if(1 to 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/b92fs, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/b92fs, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/b92fs, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/classic_baton, WEAR_R_HAND)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/riot, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/classic_baton, WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_L_HAND)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/grenade/m84, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/slug/baton, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/slug/baton, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/slug/baton, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/slug/baton, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_R_STORE)
		if(9 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower/black, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)

// ua synth
/datum/equipment_preset/synth/survivor/cmb/ua_synth
	name = "Survivor - Synthetic - UA Police Synthetic(Riot Response)"
	paygrades = list(PAY_SHORT_CMBS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "UA Syn"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "UA Police Synthetic"
	languages = ALL_SYNTH_LANGUAGES
	skills = /datum/skills/colonial_synthetic
	minimap_icon = "synth"
	minimap_background = "background_ua"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/synth/survivor/cmb/ua_synth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/survivor/cmb/ua_synth/load_gear(mob/living/carbon/human/new_human)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/baton_slug, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield, WEAR_IN_HELMET)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/synth, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang, WEAR_IN_JACKET)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full/synth, WEAR_WAIST)
	//holding
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/classic_baton, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_L_HAND)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
