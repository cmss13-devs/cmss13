//those preset are only used on this insert.
// /obj/effect/landmark/survivor_spawner/atlan_responders_UPP/soldier

/datum/equipment_preset/survivor/atlan_responder_UPP
	name = "Survivor - Atlan UPP"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_UPP
	job_title = JOB_SURVIVOR
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	role_comm_title = "104/GARRISON"
	minimap_icon = "upp_pvt"
	minimap_background = "background_upp"
	origin_override = ORIGIN_UPP
	access = ACCESS_CIVILIAN_PUBLIC
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)


/datum/equipment_preset/survivor/atlan_responder_UPP/soldier
	name = "Survivor - Atlan UPP Soldier"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)
	idtype = /obj/item/card/id/dogtag/upp
	assignment = JOB_UPP
	job_title = JOB_UPP
	skills = /datum/skills/military/survivor/upp_private

/datum/equipment_preset/survivor/atlan_responder_UPP/soldier/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(new_human), WEAR_JACKET)
	//boots and gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP(new_human), WEAR_L_EAR)
	//helmet + backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp(new_human), WEAR_BACK)
	switch(rand(1,2))
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP(new_human), WEAR_HEAD)

	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)

	//gun
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71, WEAR_J_STORE)


// /obj/effect/landmark/survivor_spawner/atlan_responders_UPP

/datum/equipment_preset/survivor/atlan_responder_UPP/medic
	name = "Survivor - Atlan UPP Medic"
	idtype = /obj/item/card/id/dogtag/upp
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_MEDIC
	job_title = JOB_UPP_MEDIC
	minimap_icon = "upp_med"
	skills = /datum/skills/military/survivor/upp_medic

/datum/equipment_preset/survivor/atlan_responder_UPP/medic/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support, WEAR_JACKET)
	//boots and gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/medic, WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/black/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/bizon/upp, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp(new_human), WEAR_IN_JACKET)

	//eyewear
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)


// /obj/effect/landmark/survivor_spawner/atlan_responders_UPP/sapper

/datum/equipment_preset/survivor/atlan_responder_UPP/sapper
	name = "Survivor - Atlan UPP Sapper"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag/upp
	assignment = JOB_UPP_ENGI
	job_title = JOB_UPP_ENGI
	minimap_icon = "upp_sapper"
	skills = /datum/skills/military/survivor/upp_sapper

/datum/equipment_preset/survivor/atlan_responder_UPP/sapper/load_gear(mob/living/carbon/human/new_human)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval(new_human), WEAR_ACCESSORY)
	//boots and gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	//radio and face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/engi(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/upp(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)

// /datum/equipment_preset/survivor/atlan_responder_UPP/specialist

/datum/equipment_preset/survivor/atlan_responder_UPP/specialist
	name = "Survivor - Atlan UPP Specialist"
	assignment = JOB_UPP_SPECIALIST
	job_title = JOB_UPP_SPECIALIST
	minimap_icon = "upp_spec"
	idtype = /obj/item/card/id/dogtag/upp
	paygrades = list(PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/military/survivor/upp_spec

/datum/equipment_preset/survivor/atlan_responder_UPP/specialist/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy(new_human), WEAR_JACKET)
	//boots and gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP(new_human), WEAR_L_EAR)
	//helmet + backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	switch(rand(1,3))
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy(new_human), WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)

	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp(new_human), WEAR_IN_JACKET)

	//gun and gear
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/bizon/upp, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_BACK)



// /obj/effect/landmark/survivor_spawner/atlan_responder_UPP/squad_leader

/datum/equipment_preset/survivor/atlan_responder_UPP/squad_leader
	name = "Survivor - Atlan UPP Squad Leader"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_LEADER
	job_title = JOB_UPP_LEADER
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	role_comm_title = "104/GARRISON SL"
	minimap_icon = "upp_sl"
	idtype = /obj/item/card/id/dogtag/upp
	skills = /datum/skills/military/survivor/upp_sl

/datum/equipment_preset/survivor/atlan_responder_UPP/squad_leader/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/officer (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//boots and gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	// guns and stuff
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)



// the synth
/datum/equipment_preset/synth/survivor/atlan_responder_UPP
	name = "Survivor - Synthetic - Atlan UPP Support Synth"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_SYNTH_LANGUAGES_UPP
	assignment = JOB_UPP_SUPPORT_SYNTH
	job_title = JOB_UPP_SUPPORT_SYNTH
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	origin_override = ORIGIN_UPP

	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag/upp
	role_comm_title = "104/GARRISON Syn"

	minimap_background = "background_upp"
	minimap_icon = "upp_synth"

	skills = /datum/skills/synthetic
	locked_generation = SYNTH_GEN_THREE

/datum/equipment_preset/synth/survivor/atlan_responder_UPP/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//gloves, boots, headset
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka, WEAR_HEAD)
	// suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support/synth, WEAR_JACKET)
	// backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	// storage and gear
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/hyperdyne(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/black/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wrench(new_human), WEAR_IN_R_STORE)
Z
