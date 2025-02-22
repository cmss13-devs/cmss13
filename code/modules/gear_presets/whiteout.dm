/datum/equipment_preset/pmc/w_y_whiteout
	name = "Whiteout Team Operative (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE //We always use a codename!
	faction = FACTION_WY_DEATHSQUAD
	assignment = "Whiteout Team Operative"
	role_comm_title = "WO"
	rank = FACTION_WY_DEATHSQUAD
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_FRENCH, LANGUAGE_SCANDINAVIAN, LANGUAGE_SPANISH, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH, LANGUAGE_TSL) //Synths after all.
	skills = /datum/skills/everything //They are Synths, programmed for Everything.
	minimap_icon = "whiteout"
	idtype = /obj/item/card/id/pmc/ds
	paygrades = list(PAY_SHORT_CDNM = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/pmc/w_y_whiteout/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/pmc/w_y_whiteout/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COMBAT)
	new_human.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE)
	//var/datum/preferences/A = new()
	//A.randomize_appearance(mob)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.greek_letters)]"
	else
		random_name = "[pick(GLOB.greek_letters)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,45)

/datum/equipment_preset/pmc/w_y_whiteout/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/EX, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/EX, WEAR_IN_BACK)

	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)

	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/medic
	name = "Whiteout Team Medic (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Medic"
	role_comm_title = "WO-TM"

/datum/equipment_preset/pmc/w_y_whiteout/medic/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/smg_heap, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/smg_heap, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/terminator
	name = "Whiteout Team Terminator (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Terminator"
	role_comm_title = "WO-TT"

/datum/equipment_preset/pmc/w_y_whiteout/terminator/load_gear(mob/living/carbon/human/new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc/terminator/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty/elite, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/whiteout/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles/whiteout, WEAR_EYES)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/leader
	name = "Whiteout Team Leader (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Leader"
	role_comm_title = "WO-TL"

/datum/equipment_preset/pmc/w_y_whiteout/leader/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/heap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/whiteout, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/rifle_heap, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/low_threat
	name = "Whiteout Team Operative"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)


	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad/standard, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic
	name = "Whiteout Team Medic"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad/standard, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/terminator
	name = "Whiteout Team Terminator"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/terminator/load_gear(mob/living/carbon/human/new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc/terminator/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty, WEAR_J_STORE)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/pmc/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles/whiteout, WEAR_EYES)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader
	name = "Whiteout Team Leader"

/datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader/load_gear(mob/living/carbon/human/new_human)
	// back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/commando/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	// accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(new_human)
