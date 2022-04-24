/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH, LANGUAGE_WELTRAUMDEUTSCH, LANGUAGE_NEOSPANISH)
	skills = /datum/skills/synthetic

/datum/equipment_preset/synth/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/synth/load_race(mob/living/carbon/human/H)
	if(!H.client || !H.client.prefs || !H.client.prefs.synthetic_type)
		H.set_species("Synthetic")
	else
		H.set_species(H.client.prefs.synthetic_type)

/datum/equipment_preset/synth/load_name(mob/living/carbon/human/H, var/randomise)
	var/final_name = "David"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined")
			final_name = "David"
	H.change_real_name(H, final_name)

/datum/equipment_preset/synth/load_skills(mob/living/carbon/human/H)
	. = ..()
	if(isColonySynthetic(H))
		H.set_skills(/datum/skills/colonial_synthetic)

	H.allow_gun_usage = FALSE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm
	name = "USCM Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH
	rank = "Synthetic"
	paygrade = ""
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/councillor
	name = "USCM Synthetic Councillor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH
	rank = "Synthetic"
	paygrade = ""
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/councillor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/councillor(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/wo
	name = "WO Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

/datum/equipment_preset/synth/uscm/wo/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/RO(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/tan(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor
	name = "Survivor - Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SYNTH
	rank = JOB_SYNTH_SURVIVOR
	skills = /datum/skills/colonial_synthetic

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_all_civilian_accesses() + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH + ACCESS_WY_CORPORATE //Access to civillians stuff + medbay stuff + engineering stuff + research

/datum/equipment_preset/synth/survivor/load_gear(mob/living/carbon/human/H)
	add_random_synth_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/device/radio/marine(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/fireaxe(H), WEAR_L_HAND)

/datum/equipment_preset/synth/survivor/load_id(mob/living/carbon/human/H, client/mob_client)
	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_COLONIST
	return ..()


//*****************************************************************************************************/

/datum/equipment_preset/synth/working_joe
	name = "Working Joe"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	faction_group = list(FACTION_MARINE)
	assignment = JOB_WORKING_JOE
	rank = JOB_WORKING_JOE
	skills = /datum/skills/colonial_synthetic

/datum/equipment_preset/synth/working_joe/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/working_joe/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/H)
	. = ..()
	H.r_eyes = 255
	H.g_eyes = 255
	H.b_eyes = 255
	H.h_style = "Bald"
	H.r_hair = 255
	H.g_hair = 255
	H.b_hair = 255
	H.f_style = "Shaved"
	H.r_facial = 255
	H.g_facial = 255
	H.b_facial = 255

/datum/equipment_preset/synth/working_joe/load_name(mob/living/carbon/human/H, var/randomise)
	H.change_real_name(H, "Working Joe")

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/midwife
	name = "Fun - Xeno Cultist Midwife (Synthetic)"
	faction = FACTION_XENOMORPH

/datum/equipment_preset/synth/survivor/midwife/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/xenos(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/collectable/xenom(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)


/datum/equipment_preset/synth/survivor/midwife/load_name(mob/living/carbon/human/H, var/randomise)
	var/final_name = "Midwife Joe"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Midwife Joe"
		else
			final_name = "Midwife [H.real_name]"
	H.change_real_name(H, final_name)
