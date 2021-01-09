/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = list("English", "Russian", "Japanese", "Sainja", "Xenomorph","Spacendeutchen","Spanish")
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

	H.allow_gun_usage = FALSE

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm
	name = "USCM Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = "Synthetic"
	rank = "Synthetic"
	paygrade = ""
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
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
	assignment = "Synthetic"
	rank = "Synthetic"
	paygrade = ""
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/councillor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
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
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)

	H.allow_gun_usage = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor
	name = "Survivor - Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SURVIVOR
	rank = JOB_SYNTH_SURVIVOR
	skills = /datum/skills/early_synthetic

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/H)
	H.set_species("Early Synthetic")

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_all_civilian_accesses() + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH //Access to civillians stuff + medbay stuff + engineering stuff + research

/datum/equipment_preset/synth/survivor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/fireaxe(H), WEAR_L_HAND)

	add_random_survivor_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/working_joe
	name = "Working Joe"

/datum/equipment_preset/synth/survivor/working_joe/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	add_random_survivor_equipment(H)

/datum/equipment_preset/synth/survivor/working_joe/load_race(mob/living/carbon/human/H)
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

/datum/equipment_preset/synth/survivor/working_joe/load_name(mob/living/carbon/human/H, var/randomise)
	var/final_name = "Working Joe"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Working Joe"
		else
			final_name = "Working [H.real_name]"
	H.change_real_name(H, final_name)

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
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/xenos(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/collectable/xenom(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)


/datum/equipment_preset/synth/survivor/midwife/load_name(mob/living/carbon/human/H, var/randomise)
	var/final_name = "Midwife Joe"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Midwife Joe"
		else
			final_name = "Midwife [H.real_name]"
	H.change_real_name(H, final_name)
