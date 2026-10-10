// as far as i understand this is only done for one insert
//crashlanding-upp-bar.dmm map.
/datum/equipment_preset/survivor/upp
	name = "Survivor - UPP"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)
	origin_override = ORIGIN_UPP
	job_title = JOB_SURVIVOR
	skills = /datum/skills/military/survivor/upp_private
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	minimap_icon = "upp_pvt"
	minimap_background = "background_upp"
	role_comm_title = "173/RECON"
	idtype = /obj/item/card/id/dogtag/upp
	flags = EQUIPMENT_PRESET_EXTRA
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)

/datum/equipment_preset/survivor/upp/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/airborne, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)

// /obj/effect/landmark/survivor_spawner/upp/soldier
//crashlanding-upp-bar.dmm
/datum/equipment_preset/survivor/upp/soldier
	name = "Survivor - UPP Soldier"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)
	assignment = JOB_UPP
	job_title = JOB_UPP
	skills = /datum/skills/military/survivor/upp_private

/datum/equipment_preset/survivor/upp/soldier/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	add_upp_weapon(new_human)
	spawn_random_upp_headgear(new_human)
	spawn_random_upp_armor(new_human)
	spawn_random_upp_belt(new_human)

	..()

// /obj/effect/landmark/survivor_spawner/upp_sapper
//crashlanding-upp-bar.dmm
/datum/equipment_preset/survivor/upp/sapper
	name = "Survivor - UPP Sapper"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_ENGI
	job_title = JOB_UPP_ENGI

	minimap_icon = "upp_sapper"

	skills = /datum/skills/military/survivor/upp_sapper

/datum/equipment_preset/survivor/upp/sapper/load_gear(mob/living/carbon/human/new_human)

	var/obj/item/clothing/under/marine/veteran/UPP/engi/uniform = new()
	var/R = rand(1,2)
	switch(R)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	spawn_random_upp_armor(new_human)
	add_upp_weapon(new_human)
	spawn_random_upp_headgear(new_human)

	..()
// /obj/effect/landmark/survivor_spawner/upp_medic
//crashlanding-upp-bar.dmm
/datum/equipment_preset/survivor/upp/medic
	name = "Survivor - UPP Medic"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_MEDIC
	job_title = JOB_UPP_MEDIC

	minimap_icon = "upp_med"

	skills = /datum/skills/military/survivor/upp_medic

/datum/equipment_preset/survivor/upp/medic/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/medic/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new/obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/medic/upp(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	spawn_random_upp_armor(new_human)
	add_upp_weapon(new_human)
	spawn_random_upp_headgear(new_human)

	..()
// /obj/effect/landmark/survivor_spawner/upp_specialist
//crashlanding-upp-bar.dmm
/datum/equipment_preset/survivor/upp/specialist
	name = "Survivor - UPP Specialist"
	assignment = JOB_UPP_SPECIALIST
	job_title = JOB_UPP_SPECIALIST
	minimap_icon = "upp_spec"
	paygrades = list(PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/military/survivor/upp_spec

/datum/equipment_preset/survivor/upp/specialist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy (new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73(new_human), WEAR_WAIST)

	..()
//crashlanding-upp-bar.dmm
// /obj/effect/landmark/survivor_spawner/squad_leader
/datum/equipment_preset/survivor/upp/squad_leader
	name = "Survivor - UPP Squad Leader"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_UPP_LEADER
	job_title = JOB_UPP_LEADER
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH,  LANGUAGE_GERMAN,  LANGUAGE_CHINESE)
	role_comm_title = "173/RECON SL"

	minimap_icon = "upp_sl"

	skills = /datum/skills/military/survivor/upp_sl

/datum/equipment_preset/survivor/upp/squad_leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP (new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	add_upp_weapon(new_human)

	..()

/datum/equipment_preset/survivor/upp/mss
	name = "Survivor - UPP - Ministry of Space Security Officer"
	paygrades = list(PAY_SHORT_UO4 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/gold
	assignment = JOB_UPP_MSS_OFFICER
	job_title = JOB_UPP_MSS_OFFICER
	role_comm_title = "MSS-Off."
	minimap_icon = "upp_plt"
	skills = /datum/skills/military/survivor/upp_sl/mss
	languages = list(
		LANGUAGE_RUSSIAN,
		LANGUAGE_ENGLISH,
		LANGUAGE_JAPANESE,
		LANGUAGE_CHINESE,
		LANGUAGE_GERMAN,
		LANGUAGE_SPANISH,
		LANGUAGE_FRENCH,
	)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_SECURITY,
		ACCESS_UPP_ARMORY,
		ACCESS_UPP_FLIGHT,
		ACCESS_UPP_RESEARCH,
		ACCESS_UPP_COMMANDO,
		ACCESS_UPP_LEADERSHIP,
		ACCESS_UPP_SENIOR_LEAD,
	)

/datum/equipment_preset/survivor/upp/mss/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/officer/mss(new_human), WEAR_BODY)
	var/obj/item/clothing/suit/storage/marine/faction/UPP/officer/mss/mss_jacket = new()
	mss_jacket.attach_accessory(new_human, new /obj/item/clothing/accessory/patch/upp)
	mss_jacket.attach_accessory(new_human, new /obj/item/clothing/accessory/patch/upp/alt)
	new_human.equip_to_slot_or_del(mss_jacket, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked/mss(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/pill/cyanide(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera_film(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human.back), WEAR_IN_BACK)
	var/obj/item/clipboard/clipboard = new(new_human)
	for(var/paper_number in 1 to 5)
		clipboard.toppaper = new /obj/item/paper(clipboard)
	clipboard.haspen = new /obj/item/tool/pen/multicolor/fountain(clipboard)
	clipboard.update_icon()
	new_human.equip_to_slot_or_del(clipboard, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73/leader/standard(new_human), WEAR_WAIST)
	add_upp_weapon(new_human)

//it's used on all of the above in their spawner.
/datum/equipment_preset/synth/survivor/upp
	name = "Survivor - Synthetic - UPP Synth"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_SYNTH_LANGUAGES_UPP
	assignment = JOB_UPP_SUPPORT_SYNTH
	job_title = JOB_UPP_SUPPORT_SYNTH
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	origin_override = ORIGIN_UPP

	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag/upp
	role_comm_title = "173/RECON Syn"

	minimap_background = "background_upp"
	minimap_icon = "upp_synth"

	skills = /datum/skills/synthetic
	locked_generation = SYNTH_GEN_THREE

/datum/equipment_preset/synth/survivor/upp/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/medic/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/hyperdyne(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/partial(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/airborne(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/uppsynth(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
