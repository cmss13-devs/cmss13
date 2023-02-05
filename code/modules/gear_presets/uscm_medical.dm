/datum/equipment_preset/uscm_ship/uscm_medical/cmo
	name = "USCM Chief Medical Officer (CMO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CMO,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_CHEMISTRY,
		ACCESS_MARINE_MORGUE,
	)
	assignment = JOB_CMO
	rank = JOB_CMO
	paygrade = "MO2"
	role_comm_title = "CMO"
	skills = /datum/skills/CMO

	minimap_icon = list("medic" = MINIMAP_ICON_COLOR_HEAD)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	utility_under = list(/obj/item/clothing/under/rank/chief_medical_officer)
	utility_hat = list(/obj/item/clothing/head/cmo)
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
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/decent(H), WEAR_IN_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_J_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/doctor
	name = "USCM Surgeon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_DOCTOR
	rank = JOB_DOCTOR
	paygrade = "MO1"
	role_comm_title = "Doc"
	skills = /datum/skills/doctor

	minimap_icon = list("medic" = MINIMAP_ICON_COLOR_DOCTOR)

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
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BELT)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/nurse
	name = "USCM Nurse"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_NURSE
	rank = JOB_NURSE
	paygrade = "ME5"
	role_comm_title = "Nurse"
	skills = /datum/skills/nurse

	minimap_icon = list("medic")

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
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/nurse(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/orange(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BELT)

/datum/equipment_preset/uscm_ship/uscm_medical/nurse/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) < JOB_PLAYTIME_TIER_1)
			return "ME3"
	return paygrade

//*****************************************************************************************************/
/datum/equipment_preset/uscm_ship/uscm_medical/researcher
	name = "USCM Researcher"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_RESEARCHER
	rank = JOB_RESEARCHER
	paygrade = "MO1"
	role_comm_title = "Rsr"
	skills = /datum/skills/researcher

	minimap_icon = "researcher"

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
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/bad(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/syringe(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/chem(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/vials(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)

//*****************************************************************************************************/
