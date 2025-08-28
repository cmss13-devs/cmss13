/// Global Response Staff, CIA Paramilitaries. ///

/datum/equipment_preset/cia_global_response
	name = "Global Response"

	assignment = "Global Response"
	job_title = "Global Response"
	idtype = /obj/item/card/id/adaptive/cia
	faction = FACTION_CIA
	faction_group = FACTION_LIST_CIA_MARINE
	minimap_background = "background_ua"

/datum/equipment_preset/cia_global_response/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		new_human.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = rand(15,35)
	new_human.g_hair = rand(15,35)
	new_human.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/standard
	name = JOB_CIA_GRS_OPR
	paygrades = list(PAY_SHORT_GRS_OPR = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_OPR
	job_title = JOB_CIA_GRS_OPR
	skills = /datum/skills/cia/global_response
	minimap_icon = "spec_sniper"

/datum/equipment_preset/cia_global_response/standard/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/tactical, WEAR_J_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16/ap, WEAR_WAIST)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/full, WEAR_L_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black, WEAR_BACK)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/heavy
	name = JOB_CIA_GRS_HVY
	paygrades = list(PAY_SHORT_GRS_HVY = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_HVY
	job_title = JOB_CIA_GRS_HVY
	skills = /datum/skills/cia/global_response/heavy
	minimap_icon = "peacekeeper"

/datum/equipment_preset/cia_global_response/heavy/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs/smartgun, WEAR_JACKET)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)//CIA DONE
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/smartgunner/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)//CIA DONE
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/smartgunner, WEAR_BACK)//CIA DONE
	//gun
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/co(new_human), WEAR_J_STORE)


//*****************************************************************************************************/
/datum/equipment_preset/cia_global_response/engineer
	name = JOB_CIA_GRS_ENG
	paygrades = list(PAY_SHORT_GRS_ENG = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_ENG
	job_title = JOB_CIA_GRS_ENG
	skills = /datum/skills/cia/global_response/engineer
	minimap_icon = "engi"


/datum/equipment_preset/cia_global_response/engineer/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/marsoc/grs/uniform = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/webbing = new()
	uniform.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)//CIA DONE
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/lethal, WEAR_J_STORE)//CIA DONE
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_lethal, WEAR_WAIST)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_L_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)//CIA DONE
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/black, WEAR_BACK)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/medic
	name = JOB_CIA_GRS_MED
	paygrades = list(PAY_SHORT_GRS_MED = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_MED
	job_title = JOB_CIA_GRS_MED
	skills = /datum/skills/cia/global_response/medic
	minimap_icon = "medic"

/datum/equipment_preset/cia_global_response/medic/load_gear(mob/living/carbon/human/new_human)
	//webbing
	var/obj/item/clothing/under/marine/veteran/marsoc/grs/uniform = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	uniform.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)//CIA DONE
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/cia, WEAR_J_STORE)//CIA DONE
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5/ap/black, WEAR_L_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)//CIA DONE

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/medic, WEAR_BACK)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/leader
	name = JOB_CIA_GRS_TL
	paygrades = list(PAY_SHORT_GRS_TL = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_TL
	job_title = JOB_CIA_GRS_TL
	skills = /datum/skills/cia/global_response/leader
	minimap_icon = "leader"

/datum/equipment_preset/cia_global_response/leader/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)//CIA DONE

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/tactical, WEAR_J_STORE)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16/ap, WEAR_WAIST)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)//CIA DONE
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black, WEAR_BACK)//CIA DONE
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
