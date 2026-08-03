//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm
	name = "USCM Synthetic (Generalised)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH
	job_title = JOB_SYNTH
	role_comm_title = "Syn"

	minimap_icon = "synth"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)

	var/is_council = FALSE

/datum/equipment_preset/synth/uscm/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/industrial
	if(!is_council)
		new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(new_human), WEAR_BODY)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
		new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/councillor(new_human), WEAR_BODY)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
		new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

/datum/equipment_preset/synth/uscm/councillor
	name = "USCM Synthetic Council (Generalised)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/wo
	name = "WO Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/synth/uscm/wo/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/RO(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/a1/tan(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/engineering
	name = "USCM Synthetic (Engineering)"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	subtype = "eng"
	assignment = JOB_SYNTH_ENG
	manifest_title = JOB_SYNTH_ENG

/datum/equipment_preset/synth/uscm/engineering/council
	name = "USCM Synthetic Council (Engineering)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/medical
	name = "USCM Synthetic (Medical)"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	subtype = "med"
	assignment = JOB_SYNTH_MED
	manifest_title = JOB_SYNTH_MED

/datum/equipment_preset/synth/uscm/medical/council
	name = "USCM Synthetic Council (Medical)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/intel
	name = "USCM Synthetic (Intel)"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	subtype = "io"
	assignment = JOB_SYNTH_INTEL
	manifest_title = JOB_SYNTH_INTEL

/datum/equipment_preset/synth/uscm/intel/council
	name = "USCM Synthetic Council (Intel)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/command
	name = "USCM Synthetic (Command)"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	subtype = "cmd"
	assignment = JOB_SYNTH_CMD
	manifest_title = JOB_SYNTH_CMD

/datum/equipment_preset/synth/uscm/command/council
	name = "USCM Synthetic Council (Command)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/mp
	name = "USCM Synthetic (MP)"
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	subtype = "mp"
	assignment = JOB_SYNTH_MP
	manifest_title = JOB_SYNTH_MP

/datum/equipment_preset/synth/uscm/mp/council
	name = "USCM Synthetic Council (MP)"
	paygrades = list(PAY_SHORT_MCWO = JOB_PLAYTIME_TIER_0)
	is_council = TRUE

//*****************************************************************************************************/
