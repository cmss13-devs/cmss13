/datum/equipment_preset/pmc/w_y_whiteout
	name = "Whiteout Team Operative"
	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE //We always use a codename!
	faction = FACTION_WY_DEATHSQUAD
	assignment = "Whiteout Team Operative"
	role_comm_title = "WO"
	rank = FACTION_WY_DEATHSQUAD
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_WELTRAUMDEUTSCH, LANGUAGE_NEOSPANISH, LANGUAGE_RUSSIAN, LANGUAGE_TSL, LANGUAGE_CHINESE) //Synths after all.
	skills = /datum/skills/everything //They are Synths, programmed for Everything.
	idtype = /obj/item/card/id/pmc/ds
	paygrade = "O"

/datum/equipment_preset/pmc/w_y_whiteout/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/pmc/w_y_whiteout/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COMBAT)
	H.allow_gun_usage = TRUE //To allow usage of Guns/Grenades
	H.h_style = "Bald"
	H.f_style = "Shaved"

/datum/equipment_preset/pmc/w_y_whiteout/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE)
	//var/datum/preferences/A = new()
	//A.randomize_appearance(mob)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(greek_letters)]"
	else
		random_name = "[pick(greek_letters)]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)

/datum/equipment_preset/pmc/w_y_whiteout/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/PMC/commando/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/medic
	name = "Whiteout Team Medic"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Medic"
	role_comm_title = "WO-TM"

/datum/equipment_preset/pmc/w_y_whiteout/medic/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil/white, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil/white, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/PMC/commando/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/deathsquad, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/terminator
	name = "Whiteout Team Terminator"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Terminator"
	role_comm_title = "WO-TT"

/datum/equipment_preset/pmc/w_y_whiteout/terminator/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow, WEAR_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC/terminator/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/pmc/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/leader
	name = "Whiteout Team Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Leader"
	role_comm_title = "WO-TL"

/datum/equipment_preset/pmc/w_y_whiteout/leader/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/PMC/commando/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)
