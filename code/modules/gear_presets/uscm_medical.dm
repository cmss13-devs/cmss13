/datum/equipment_preset/uscm_ship/uscm_medical/cmo
	name = "USCM Chief Medical Officer (CMO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CMO,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_CHEMISTRY,
		ACCESS_MARINE_MORGUE
	)
	assignment = JOB_CMO
	rank = JOB_CMO
	paygrade = "CCMO"
	role_comm_title = "CMO"
	skills = /datum/skills/CMO

	utility_under = list(/obj/item/clothing/under/rank/medical/green)
	utility_hat = list(/obj/item/clothing/head/surgery/green)
	utility_gloves = list(/obj/item/clothing/gloves/latex)
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat)

	service_under = list()
	service_over = list()
	service_hat = list()
	service_shoes = list()

	dress_under = list(/obj/item/clothing/under/suit_jacket)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/uscm_medical/cmo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/decent(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_J_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/doctor
	name = "USCM Doctor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_DOCTOR
	rank = JOB_DOCTOR
	paygrade = "CD"
	role_comm_title = "Doc"
	skills = /datum/skills/doctor

	utility_under = list(/obj/item/clothing/under/rank/medical/green)
	utility_hat = list(/obj/item/clothing/head/surgery/green)
	utility_gloves = list(/obj/item/clothing/gloves/latex)
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat)

	service_under = list()
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/suit_jacket)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/uscm_medical/doctor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/nurse
	name = "USCM Nurse"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_NURSE
	rank = JOB_NURSE
	paygrade = "CD"
	role_comm_title = "Nurse"
	skills = /datum/skills/nurse

	utility_under = list(/obj/item/clothing/under/rank/medical/green)
	utility_hat = list(/obj/item/clothing/head/surgery/green)
	utility_gloves = list(/obj/item/clothing/gloves/latex)
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat)

	service_under = list()
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/suit_jacket)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/uscm_medical/nurse/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/nurse(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/orange(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/
/datum/equipment_preset/uscm_ship/uscm_medical/researcher
	name = "USCM Researcher"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_RESEARCHER
	rank = JOB_RESEARCHER
	paygrade = "CD"
	role_comm_title = "Rsr"
	skills = /datum/skills/researcher

	utility_under = list(/obj/item/clothing/under/rank/medical/green)
	utility_hat = list(/obj/item/clothing/head/surgery/green)
	utility_gloves = list(/obj/item/clothing/gloves/latex)
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat/researcher)

	service_under = list(/obj/item/clothing/under/marine/officer/researcher)
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/suit_jacket)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/uscm_medical/researcher/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/bad(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/syringe(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/chem(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/vials(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_J_STORE)

/*****************************************************************************************************/