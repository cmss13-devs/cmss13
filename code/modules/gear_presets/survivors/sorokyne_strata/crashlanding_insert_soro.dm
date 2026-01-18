// "SOF's 121st Special Reconnaissance Detachment the SOF's primary Reconnaissance group in the Bau Sau sector, often training along side the CEC and recruiting from the CEC, they are the first to be deployed in the event of war."

/datum/equipment_preset/survivor/upp/SOF_survivor
	name = "Survivor - UPP SOF"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)
	origin_override = ORIGIN_UPP
	job_title = JOB_SURVIVOR
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/military/survivor/upp_private
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	minimap_icon = "upp_pvt"
	minimap_background = "background_upp"
	role_comm_title = "121/RECON"
	idtype = /obj/item/card/id/dogtag/upp
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)

/datum/equipment_preset/survivor/upp/SOF_survivor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy/SOF_helmet(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/SOF_armor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/SOF_belt/t73(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ak4047(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ak4047(new_human), WEAR_IN_JACKET)
	..()

// /obj/effect/landmark/survivor_spawner/SOF_survivor/soldier

/datum/equipment_preset/survivor/upp/SOF_survivor/soldier
	name = "Survivor - UPP SOF Soldier"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)
	assignment = JOB_UPP
	job_title = JOB_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	skills = /datum/skills/military/survivor/upp_private
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/survivor/upp/SOF_survivor/soldier/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	..()

// /obj/effect/landmark/survivor_spawner/SOF_survivor/sapper

/datum/equipment_preset/survivor/upp/SOF_survivor/sapper
	name = "Survivor - UPP SOF Sapper"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_ENGI
	job_title = JOB_UPP_ENGI
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)

	minimap_icon = "upp_sapper"

	skills = /datum/skills/military/survivor/upp_sapper

/datum/equipment_preset/survivor/upp/SOF_survivor/sapper/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/sof/full(new_human), WEAR_R_STORE)
	..()

// /obj/effect/landmark/survivor_spawner/SOF_survivor/medic

/datum/equipment_preset/survivor/upp/SOF_survivor/medic
	name = "Survivor - UPP SOF Medic"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_MEDIC
	job_title = JOB_UPP_MEDIC
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)

	minimap_icon = "upp_med"

	skills = /datum/skills/military/survivor/upp_medic

/datum/equipment_preset/survivor/upp/SOF_survivor/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/medic(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new/obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/black/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/black(new_human), WEAR_R_STORE)
	..()

// /obj/effect/landmark/survivor_spawner/SOF_survivor/specialist

/datum/equipment_preset/survivor/upp/SOF_survivor/specialist
	name = "Survivor - UPP SOF Specialist"
	assignment = JOB_UPP_SPECIALIST
	job_title = JOB_UPP_SPECIALIST
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	minimap_icon = "upp_spec"
	paygrades = list(PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/military/survivor/upp_spec/rocket

/datum/equipment_preset/survivor/upp/SOF_survivor/specialist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/SOF_armor/heavy(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	..()

// /obj/effect/landmark/survivor_spawner/SOF_survivor/squad_leader

/datum/equipment_preset/survivor/upp/SOF_survivor/squad_leader
	name = "Survivor - UPP SOF Squad Leader"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_LEADER
	job_title = JOB_UPP_LEADER
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	role_comm_title = "121/RECON SL"

	minimap_icon = "upp_sl"

	skills = /datum/skills/military/survivor/upp_sl

/datum/equipment_preset/survivor/upp/SOF_survivor/squad_leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/SOF_armor/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/SOF_beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/SOF_belt/revolver/upp(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy/SOF_helmet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/black(new_human), WEAR_R_STORE)
	..()

//it's used on all of the above in their spawner.

/datum/equipment_preset/synth/survivor/upp/SOF_synth
	name = "Survivor - Synthetic - UPP SOF Synth"

	languages = ALL_SYNTH_LANGUAGES_UPP
	assignment = JOB_UPP_SUPPORT_SYNTH
	job_title = JOB_UPP_SUPPORT_SYNTH
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	skills = /datum/skills/colonial_synthetic
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag/upp
	role_comm_title = "121/RECON Syn"
	minimap_background = "background_upp"
	minimap_icon = "upp_synth"

/datum/equipment_preset/synth/survivor/upp/SOF_synth/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/SOF_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/SOF_beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/SOF_armor/synth(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/hyperdyne(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/black/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/uppsynth/black/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/black/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy/SOF_helmet(new_human.back), WEAR_IN_BACK)
