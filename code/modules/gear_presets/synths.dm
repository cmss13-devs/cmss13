/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = list("English", "Russian", "Tradeband", "Sainja", "Xenomorph")
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
	if(isEarlySynthetic(H))
		H.set_skills(/datum/skills/early_synthetic)

/*****************************************************************************************************/

/datum/equipment_preset/synth/uscm
	name = "USCM Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = "Synthetic"
	rank = "Synthetic"
	paygrade = "???"
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem, WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/wo
	name = "WO Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

/datum/equipment_preset/synth/uscm/wo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/RO, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/brown_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new backItem, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/synth/combat_smartgunner
	name = "USCM Combat Synth (Smartgunner)"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/dogtag
	assignment = "Squad Smartgunner"
	rank = "Squad Smartgunner"
	paygrade = "E3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/synth/combat_smartgunner/load_race(mob/living/carbon/human/H)
	H.set_species("Early Synthetic")

/datum/equipment_preset/synth/combat_smartgunner/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/J = new(H)
	J.icon_state = ""
	H.equip_to_slot_or_del(J, WEAR_BODY)
	var/obj/item/clothing/head/helmet/specrag/L = new(H)
	L.icon_state = ""
	L.name = "synth faceplate"
	L.flags_inventory |= NODROP
	L.anti_hug = 99

	H.equip_to_slot_or_del(L, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles, WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/synth/survivor
	name = "Survivor - Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SURVIVOR
	rank = JOB_SYNTH
	skills = /datum/skills/early_synthetic

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/H)
	H.set_species("Early Synthetic")

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_all_civilian_accesses()+get_region_accesses(2)+get_region_accesses(4) //Access to civillians stuff + medbay stuff + engineering stuff

/datum/equipment_preset/synth/survivor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new backItem, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe, WEAR_L_HAND)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/synth/working_joe
	name = "Working Joe"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SURVIVOR
	rank = JOB_SYNTH
	skills = /datum/skills/early_synthetic

/datum/equipment_preset/synth/working_joe/New()
	. = ..()
	access = get_all_civilian_accesses() //crappy access!

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/H)
	H.set_species("Early Synthetic")

/datum/equipment_preset/synth/working_joe/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new backItem, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

	add_random_survivor_equipment(H)

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
	var/final_name = "Working Joe"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Working Joe"
		else
			final_name = "Working [H.real_name]"
	H.change_real_name(H, final_name)
