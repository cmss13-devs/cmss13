/datum/equipment_preset/pmc/w_y_whiteout
	name = "Whiteout Team Combat Unit (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE //We always use a codename!
	faction = FACTION_WY_DEATHSQUAD
	assignment = JOB_DS_CU
	role_comm_title = "WO"
	rank = JOB_DS_CU
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_FRENCH, LANGUAGE_SCANDINAVIAN, LANGUAGE_SPANISH, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH, LANGUAGE_TSL) //Synths after all.
	skills = /datum/skills/everything //They are Synths, programmed for Everything.
	minimap_icon = "whiteout"
	idtype = /obj/item/card/id/pmc/ds
	paygrades = list(PAY_SHORT_CDNM = JOB_PLAYTIME_TIER_0)
	var/new_bubble_icon = "machine"

/datum/equipment_preset/pmc/w_y_whiteout/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/pmc/w_y_whiteout/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COMBAT)
	new_human.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	new_human.r_eyes = 78
	new_human.g_eyes = 74
	new_human.b_eyes = 59
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.greek_letters)]"
	else
		random_name = "[pick(GLOB.greek_letters)]"
	new_human.change_real_name(new_human, random_name)
	new_human.bubble_icon = new_bubble_icon
	new_human.age = rand(3, 5)

/datum/equipment_preset/pmc/w_y_whiteout/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/flammenwerfer/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/flammenwerfer/whiteout, WEAR_IN_BACK)

	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)

	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/flammenwerfer3/deathsquad, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/medic
	name = "Whiteout Team Support Unit (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	role_comm_title = "WO-SUP"
	minimap_background = "background_ua"
	assignment = JOB_DS_SUP
	rank = JOB_DS_SUP

/datum/equipment_preset/pmc/w_y_whiteout/medic/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout/medical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/flammenwerfer3/deathsquad, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/smg_heap, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/smg_heap, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/cloaker
	name = "Whiteout Team Cloaker Unit (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	role_comm_title = "WO-CK"
	minimap_background = "background_mp"
	assignment = JOB_DS_CK
	rank = JOB_DS_CK
	new_bubble_icon = "syndibot"

/datum/equipment_preset/pmc/w_y_whiteout/cloaker/load_race(mob/living/carbon/human/new_human)
	new_human.set_species("W-Y Combat Android Cloaker")
	new_human.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	new_human.r_eyes = 78
	new_human.g_eyes = 74
	new_human.b_eyes = 59
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/cloaker/load_gear(mob/living/carbon/human/new_human)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/dark/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/dark/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite, WEAR_J_STORE)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/wy_invis_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid/dark, WEAR_HEAD)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/full/whiteout, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android/dark, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_sniper, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_sniper, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/leader
	name = "Whiteout Team Leading Unit (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	role_comm_title = "WO-LU"
	minimap_background = "background_command"
	assignment = JOB_DS_SL
	rank = JOB_DS_SL

/datum/equipment_preset/pmc/w_y_whiteout/leader/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/zipcuffs/small, WEAR_IN_BACK)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/vp78_whiteout, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/sec/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/low_threat
	name = "Whiteout Team Combat Unit"
	minimap_background = "background_pmc"
	assignment = JOB_DS_CU
	rank = JOB_DS_CU

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/load_race(mob/living/carbon/human/new_human)
	new_human.set_species("W-Y Combat Android (Weaker)")
	new_human.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	new_human.r_eyes = 78
	new_human.g_eyes = 74
	new_human.b_eyes = 59
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/flammenwerfer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/flammenwerfer, WEAR_IN_BACK)


	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/flammenwerfer3/deathsquad/standard, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_rifle, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_rifle, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic
	name = "Whiteout Team Support Unit"
	minimap_background = "background_ua"
	role_comm_title = "WO-SUP"
	assignment = JOB_DS_SUP
	rank = JOB_DS_SUP

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout/medical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/flammenwerfer3/deathsquad/standard, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_m39, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_m39, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/cloaker
	name = "Whiteout Team Cloaker Unit"
	role_comm_title = "WO-CK"
	minimap_background = "background_mp"
	assignment = JOB_DS_CK
	rank = JOB_DS_CK
	new_bubble_icon = "syndibot"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/cloaker/load_race(mob/living/carbon/human/new_human)
	new_human.set_species("W-Y Combat Android Cloaker (Weaker)")
	new_human.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	new_human.r_eyes = 78
	new_human.g_eyes = 74
	new_human.b_eyes = 59
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/cloaker/load_gear(mob/living/carbon/human/new_human)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/dark/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/dark/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite, WEAR_J_STORE)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/wy_invis_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid/dark, WEAR_HEAD)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/full/whiteout_low_threat, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android/dark, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_sniper, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_sniper, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)


//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader
	name = "Whiteout Team Leading Unit"
	minimap_background = "background_command"
	role_comm_title = "WO-LU"
	assignment = JOB_DS_SL
	rank = JOB_DS_SL

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/combat_droid, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/zipcuffs/small, WEAR_IN_BACK)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/wy_android, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/combat_android/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/vp78_whiteout, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/combat_droid, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/combat_android, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/pmc_rifle, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/sec/full, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)
