/datum/equipment_preset/uscm_ship/uscm_medical

	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)

	utility_under = list(/obj/item/clothing/under/rank/medical/green)
	utility_hat = list()
	utility_gloves = list()
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list()

	service_under = list()
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/suit_jacket)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/uscm_medical/cmo
	name = "USCM Chief Medical Officer (CMO)"

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CMO,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_SENIOR,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_CHEMISTRY,
		ACCESS_MARINE_MORGUE,
	)
	assignment = JOB_CMO
	rank = JOB_CMO
	paygrade = PAY_SHORT_MO2
	role_comm_title = "CMO"
	skills = /datum/skills/CMO

	minimap_icon = list("medic" = MINIMAP_ICON_COLOR_HEAD)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	utility_under = list(/obj/item/clothing/under/rank/chief_medical_officer)
	utility_hat = list(/obj/item/clothing/head/cmo)
	utility_gloves = list(/obj/item/clothing/gloves/latex)
	utility_shoes = list(/obj/item/clothing/shoes/white)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat)

/datum/equipment_preset/uscm_ship/uscm_medical/cmo/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/decent(new_human), WEAR_IN_JACKET)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_J_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/doctor
	name = "USCM Surgeon"

	assignment = JOB_DOCTOR
	rank = JOB_DOCTOR
	paygrade = PAY_SHORT_MO1
	role_comm_title = "Doc"
	skills = /datum/skills/doctor

	minimap_icon = list("medic" = MINIMAP_ICON_COLOR_DOCTOR)

/datum/equipment_preset/uscm_ship/uscm_medical/doctor/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)

	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

//Surgeon this part of the code is to change the name on your ID

/datum/equipment_preset/uscm_ship/uscm_medical/doctor/surgeon

	assignment = JOB_SURGEON

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_medical/nurse
	name = "USCM Nurse"

	assignment = JOB_NURSE
	rank = JOB_NURSE
	paygrade = PAY_SHORT_ME5
	role_comm_title = "Nurse"
	skills = /datum/skills/nurse

	minimap_icon = list("medic")

/datum/equipment_preset/uscm_ship/uscm_medical/nurse/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/nurse(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)

	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)


/datum/equipment_preset/uscm_ship/uscm_medical/nurse/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		if(get_job_playtime(new_human.client, rank) < JOB_PLAYTIME_TIER_1)
			return PAY_SHORT_ME3
	return paygrade

//*****************************************************************************************************/
/datum/equipment_preset/uscm_ship/uscm_medical/researcher
	name = "USCM Researcher"

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_RESEARCHER
	rank = JOB_RESEARCHER
	paygrade = PAY_SHORT_MO1
	role_comm_title = "Rsr"
	skills = /datum/skills/researcher

	minimap_icon = "researcher"

	utility_under = list(/obj/item/clothing/under/marine/officer/researcher)
	utility_hat = list()
	utility_gloves = list()
	utility_shoes = list(/obj/item/clothing/shoes/laceup)
	utility_extra = list(/obj/item/clothing/suit/storage/labcoat/researcher)

	service_under = list(/obj/item/clothing/under/marine/officer/researcher)

/datum/equipment_preset/uscm_ship/uscm_medical/researcher/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/research(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/bad(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/syringe(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
