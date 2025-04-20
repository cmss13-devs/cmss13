/datum/equipment_preset/fax_responder
	name = "Fax Responder"
	assignment = "Fax Responder"
	rank = "Fax Responder"

	role_comm_title = "Resp."

	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_FAX
	faction_group = list(FACTION_FAX)

	uses_special_name = TRUE

	access = list(ACCESS_CIVILIAN_PUBLIC)
	skills = /datum/skills/civilian/fax_responder
	idtype = /obj/item/card/id/lanyard

	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	languages = ALL_HUMAN_LANGUAGES

	var/obj/item/device/radio/headset/headset_type = /obj/item/device/radio/headset

/datum/equipment_preset/fax_responder/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new headset_type(new_human), WEAR_L_EAR)


/datum/equipment_preset/fax_responder/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	return ..()

/datum/equipment_preset/fax_responder/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "John Doe"
	if(new_human.gender == FEMALE)
		final_name = "Jane Doe"

	if(new_human.client && new_human.client.prefs)
		var/new_name = get_fax_responder_name(new_human.client)
		if(new_name)
			final_name = new_name

	new_human.change_real_name(new_human, final_name)

/datum/equipment_preset/fax_responder/proc/get_fax_responder_name(client/target_client)
	var/datum/preferences/target_prefs = target_client.prefs
	var/new_name
	switch(assignment)
		if(JOB_FAX_RESPONDER_USCM_HC)
			new_name = target_prefs.fax_name_uscm
		if(JOB_FAX_RESPONDER_USCM_PVST)
			new_name = target_prefs.fax_name_pvst
		if(JOB_FAX_RESPONDER_WY)
			new_name = target_prefs.fax_name_wy
		if(JOB_FAX_RESPONDER_UPP)
			new_name = target_prefs.fax_name_upp
		if(JOB_FAX_RESPONDER_CLF)
			new_name = target_prefs.fax_name_clf
		if(JOB_FAX_RESPONDER_CMB)
			new_name = target_prefs.fax_name_cmb
		if(JOB_FAX_RESPONDER_PRESS)
			new_name = target_prefs.fax_name_press
		if(JOB_FAX_RESPONDER_TWE)
			new_name = target_prefs.fax_name_twe

	return new_name

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/uscm
	name = "Fax Responder - USCM HC"
	assignment = JOB_FAX_RESPONDER_USCM_HC
	rank = JOB_FAX_RESPONDER_USCM_HC
	faction_group = list(FACTION_FAX, FACTION_MARINE)

	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_MO4 = JOB_PLAYTIME_TIER_3)
	idtype = /obj/item/card/id/gold
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_BRIG, ACCESS_MARINE_AI)
	headset_type = /obj/item/device/radio/headset/almayer/highcom
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fax_responder/uscm/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/marine/dress_cover/officer(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/dress/blues/senior(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/dress(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/blue(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/provost, WEAR_R_EAR)
	. = ..()

/datum/equipment_preset/fax_responder/uscm/provost
	name = "Fax Responder - USCM Provost"
	assignment = JOB_FAX_RESPONDER_USCM_PVST
	rank = JOB_FAX_RESPONDER_USCM_PVST
	faction_group = list(FACTION_FAX, FACTION_MARINE)
	idtype = /obj/item/card/id/provost

/datum/equipment_preset/fax_responder/uscm/provost/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/chief(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/provost/chief(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)


	new_human.equip_to_slot_or_del(new /obj/item/notepad/red(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/provost, WEAR_R_EAR)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/wey_yu
	name = "Fax Responder - WY"
	assignment = JOB_FAX_RESPONDER_WY
	rank = JOB_FAX_RESPONDER_WY
	faction_group = list(FACTION_FAX, FACTION_MARINE, FACTION_WY, FACTION_WY_DEATHSQUAD, FACTION_PMC)
	paygrades = list(PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC6 = JOB_PLAYTIME_TIER_1, PAY_SHORT_WYC7 = JOB_PLAYTIME_TIER_3)
	access = list(ACCESS_MARINE_COMMAND, ACCESS_WY_COLONIAL, ACCESS_WY_EXEC, ACCESS_WY_GENERAL, ACCESS_WY_LEADERSHIP)
	headset_type = /obj/item/device/radio/headset/distress/pmc/command
	idtype = /obj/item/card/id/pmc

/datum/equipment_preset/fax_responder/wey_yu/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/upp
	name = "Fax Responder - UPP"
	assignment = JOB_FAX_RESPONDER_UPP
	rank = JOB_FAX_RESPONDER_UPP
	faction_group = list(FACTION_FAX, FACTION_UPP)
	paygrades = list(PAY_SHORT_UO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UO3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_UO4 = JOB_PLAYTIME_TIER_3)
	headset_type = /obj/item/device/radio/headset/distress/UPP/kdo/command
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fax_responder/upp/New()
	. = ..()
	access = get_access(ACCESS_LIST_UPP_ALL)

/datum/equipment_preset/fax_responder/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/officer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/green(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()


//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/twe
	name = "Fax Responder - TWE"
	assignment = JOB_FAX_RESPONDER_TWE
	rank = JOB_FAX_RESPONDER_TWE
	faction_group = list(FACTION_FAX, FACTION_MARINE, FACTION_TWE)
	headset_type = /obj/item/device/radio/headset/distress/royal_marine
	idtype = /obj/item/card/id/gold
	paygrades = list(PAY_SHORT_RNO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_RNO3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_RNO4 = JOB_PLAYTIME_TIER_3)

/datum/equipment_preset/fax_responder/twe/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/twe_suit(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/blue(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/clf
	name = "Fax Responder - CLF"
	assignment = JOB_FAX_RESPONDER_CLF
	rank = JOB_FAX_RESPONDER_CLF
	faction_group = list(FACTION_FAX, FACTION_CLF)
	headset_type = /obj/item/device/radio/headset/distress/CLF/command
	paygrades = list(PAY_SHORT_REBC = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/fax_responder/clf/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_ALL)

/datum/equipment_preset/fax_responder/clf/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/clf_patch, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/cmb
	name = "Fax Responder - CMB"
	assignment = JOB_FAX_RESPONDER_CMB
	rank = JOB_FAX_RESPONDER_CMB
	faction_group = list(FACTION_FAX, FACTION_MARINE, FACTION_MARSHAL)
	headset_type = /obj/item/device/radio/headset/distress/CMB
	idtype = /obj/item/card/id/marshal
	paygrades = list(PAY_SHORT_CMBD = JOB_PLAYTIME_TIER_0, PAY_SHORT_CMBM = JOB_PLAYTIME_TIER_2)

/datum/equipment_preset/fax_responder/cmb/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

/datum/equipment_preset/fax_responder/cmb/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/marshal, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/red(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()

//*****************************************************************************************************/

/datum/equipment_preset/fax_responder/press
	name = "Fax Responder - Press"
	assignment = JOB_FAX_RESPONDER_PRESS
	rank = JOB_FAX_RESPONDER_PRESS
	faction_group = list(FACTION_FAX, FACTION_MARINE, FACTION_COLONIST)
	headset_type = /obj/item/device/radio/headset/almayer/reporter
	idtype = /obj/item/card/id/silver/cl
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/fax_responder/press/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

/datum/equipment_preset/fax_responder/press/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/reporter(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/blue(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()
