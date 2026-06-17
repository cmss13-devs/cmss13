///*****************************LV-1021 CLF Survivors*******************************************************/
/datum/equipment_preset/survivor/clf_lv1021
	name = "LV1021 - CLF Role"
	idtype = /obj/item/card/id/dogtag
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/civilian/survivor/clf
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	assignment = JOB_CLF
	role_comm_title = "GRL"
	faction = FACTION_CLF
	faction_group = list(FACTION_CLF, FACTION_SURVIVOR)
	origin_override = ORIGIN_CIVILIAN
	minimap_background = "background_clf"
	minimap_icon = "clf_mil"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CLF_GENERAL,
	)

/datum/equipment_preset/survivor/clf_lv1021/load_gear(mob/living/carbon/human/new_human)
	spawn_rebel_gloves(new_human)
	spawn_rebel_belt(new_human)

	var/obj/item/clothing/under/colonist/clf/operative/uniform = new()
	var/obj/item/clothing/accessory/patch/clf_patch/patch_clf = new()
	uniform.attach_accessory(new_human,patch_clf)
	uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/clf_patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/clf_lv1021/add_survivor_weapon_security(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/clf_lv1021/proc/add_clf_helm(mob/living/carbon/human/new_human)
	var/random_helm = rand(1,8)
	switch(random_helm)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/rebel(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/clf/guerilla(new_human), WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/riot(new_human), WEAR_HEAD)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/skullcap(new_human), WEAR_HEAD)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(new_human), WEAR_HEAD)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/red(new_human), WEAR_HEAD)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/canc(new_human), WEAR_HEAD)

/datum/equipment_preset/survivor/clf_lv1021/proc/add_clf_suit(mob/living/carbon/human/new_human)
	var/random_helm = rand(1,6)
	switch(random_helm)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/brace(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/partial(new_human), WEAR_JACKET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/vest(new_human), WEAR_JACKET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/canc(new_human), WEAR_JACKET)

/datum/equipment_preset/survivor/clf_lv1021/add_survivor_weapon_pistol(mob/living/carbon/human/new_human)
	return

/// --------------------------------------------- \\\\

/datum/equipment_preset/survivor/clf_lv1021/standard
	name = "Survivor - LV1021 CLF Standard"

/datum/equipment_preset/survivor/clf_lv1021/standard/load_gear(mob/living/carbon/human/new_human)
	..()
	add_clf_helm(new_human)
	add_clf_suit(new_human)

/// --------------------------------------------- \\\\


/datum/equipment_preset/survivor/clf_lv1021/medic
	name = "Survivor - LV1021 CLF Medic"
	assignment = JOB_CLF_MEDIC
	job_title = JOB_CLF_MEDIC
	role_comm_title = "MED"
	minimap_icon = "clf_med"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/clf/combat_medic

/datum/equipment_preset/survivor/clf_lv1021/medic/load_gear(mob/living/carbon/human/new_human)

	var/obj/item/clothing/under/colonist/clf/medic/uniform = new()
	var/obj/item/clothing/accessory/patch/clf_patch/patch_clf = new()
	uniform.attach_accessory(new_human,patch_clf)
	uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/medic(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/structure/bed/portable_surgery(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)

	..()
	add_clf_helm(new_human)
	add_clf_suit(new_human)

/// --------------------------------------------- \\\\

/datum/equipment_preset/survivor/clf_lv1021/engineer
	name = "Survivor - LV1021 CLF Engineer"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_ENGI
	job_title = JOB_CLF_ENGI
	role_comm_title = "TECH"

	minimap_icon = "clf_engi"

	skills = /datum/skills/civilian/survivor/clf/combat_engineer

/datum/equipment_preset/survivor/clf_lv1021/engineer/load_gear(mob/living/carbon/human/new_human)
	add_clf_suit(new_human)

	var/obj/item/clothing/under/colonist/clf/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/web = new()
	uniform.attach_accessory(new_human, web)
	uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)

	..()
	add_clf_helm(new_human)
	add_clf_suit(new_human)

/// --------------------------------------------- \\\\

/datum/equipment_preset/survivor/clf_lv1021/upp_liaison
	name = "Survivor - LV1021 UPP Liaison"
	assignment = JOB_UPP_SRLT_OFFICER
	job_title = JOB_UPP_SRLT_OFFICER
	origin_override = ORIGIN_UPP
	faction_group = list(FACTION_UPP, FACTION_CLF)
	idtype = /obj/item/card/id/dogtag/upp

/datum/equipment_preset/survivor/clf_lv1021/upp_liaison/load_gear(mob/living/carbon/human/new_human)
	access = get_access(ACCESS_LIST_UPP_ALL)

	var/obj/item/clothing/under/marine/veteran/UPP/officer/uniform = new()
	uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army/simple, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/notepad/green(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain, WEAR_R_EAR)

	..()

/// --------------------------------------------- \\\\

/datum/equipment_preset/survivor/clf_lv1021/leader
	name = "Survivor - LV1021 CLF Camp Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_LEADER
	job_title = JOB_CLF_LEADER
	role_comm_title = "LDR"

	minimap_icon = "clf_sl"

	skills = /datum/skills/clf/leader

/datum/equipment_preset/survivor/clf_lv1021/leader/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CLF_ARMORY, ACCESS_CLF_LEADERSHIP, ACCESS_CLF_FLIGHT)

/datum/equipment_preset/survivor/clf_lv1021/leader/load_gear(mob/living/carbon/human/new_human)

	//No random armor, so that it's more clear that he's the leader
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/leader(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/full(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/clf(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/clf_patch, WEAR_ACCESSORY)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/mar40, /obj/item/ammo_magazine/rifle/mar40, new_human)

/// --------------------------------------------- \\\\


/datum/equipment_preset/survivor/clf_lv1021/coordinator
	name = "Survivor - LV1021 CLF Coordinator"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_COORDINATOR
	job_title = JOB_CLF_COORDINATOR
	role_comm_title = "CRDN"
	minimap_icon = "clf_cr"
	skills = /datum/skills/clf/coordinator

/datum/equipment_preset/survivor/clf_lv1021/coordinator/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/colonist/clf/leader/new_uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/new_webbing = new()
	new_uniform.attach_accessory(new_human, new_webbing)
	new_human.equip_to_slot_or_del(new_uniform, WEAR_BODY)

	var/obj/item/clothing/accessory/clf_cape/new_cape = new()
	var/obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/new_gambeson = new()
	new_gambeson.attach_accessory(new_human, new_cape)
	new_human.equip_to_slot_or_del(new_gambeson, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/riot(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/dragon_katana/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen(new_human), WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/clf(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/smg/fp9000, /obj/item/ammo_magazine/smg/fp9000, new_human)

/// --------------------------------------------- \\\\


/datum/equipment_preset/synth/survivor/clf/lv1021
	name = "Survivor - LV1021 CLF Multipurpose Synthetic"

/datum/equipment_preset/synth/survivor/clf/lv1021/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new/obj/item/stack/sheet/plasteel/large_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/makeshift, WEAR_IN_BACK)

	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp, WEAR_FACE)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/jan, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/colonist/clf/medic/CLF = new()
	var/obj/item/clothing/accessory/storage/webbing/webbing = new()
	CLF.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(CLF, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/clf_patch, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_R_STORE)
