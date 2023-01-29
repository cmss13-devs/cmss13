/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = ALL_SYNTH_LANGUAGES
	skills = /datum/skills/synthetic
	paygrade = "SYN"

	minimap_icon = "synth"

/datum/equipment_preset/synth/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/synth/load_race(mob/living/carbon/human/H)
	if(H.client?.prefs?.synthetic_type)
		H.set_species(H.client.prefs.synthetic_type)
		return
	H.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/load_name(mob/living/carbon/human/H, randomise)
	var/final_name = "David"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined")
			final_name = "David"
	H.change_real_name(H, final_name)

/datum/equipment_preset/synth/load_skills(mob/living/carbon/human/H)
	. = ..()
	if(iscolonysynthetic(H) && !isworkingjoe(H))
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
	paygrade = "SYN"
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(H), WEAR_L_EAR)
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
	paygrade = "SYN"
	role_comm_title = "Syn"

/datum/equipment_preset/synth/uscm/councillor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(H), WEAR_L_EAR)
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(H), WEAR_L_EAR)
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
	name = "Survivor - Synthetic - Classic Joe"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SYNTH
	rank = JOB_SYNTH_SURVIVOR
	skills = /datum/skills/colonial_synthetic

	var/list/equipment_to_spawn = list(
		WEAR_BODY = /obj/item/clothing/under/rank/synthetic/joe,
		WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	var/survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/H)
	//Switch to check client for synthetic generation preference, and set the subspecies of colonial synth
	var/generation_selection = SYNTH_COLONY_GEN_ONE
	if(H.client?.prefs?.synthetic_type)
		generation_selection = H.client.prefs.synthetic_type
	switch(generation_selection)
		if(SYNTH_GEN_THREE)
			H.set_species(SYNTH_COLONY)
		if(SYNTH_GEN_TWO)
			H.set_species(SYNTH_COLONY_GEN_TWO)
		if(SYNTH_GEN_ONE)
			H.set_species(SYNTH_COLONY_GEN_ONE)
		else
			H.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_all_civilian_accesses() + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH + ACCESS_WY_CORPORATE //Access to civillians stuff + medbay stuff + engineering stuff + research

/datum/equipment_preset/synth/survivor/load_gear(mob/living/carbon/human/H)
	for(var/equipment in equipment_to_spawn)
		var/equipment_path = islist(equipment_to_spawn[equipment]) ? pick(equipment_to_spawn[equipment]) : equipment_to_spawn[equipment]
		H.equip_to_slot_or_del(new equipment_path(H), equipment)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/fireaxe(H), WEAR_L_HAND)

/datum/equipment_preset/synth/survivor/load_id(mob/living/carbon/human/H, client/mob_client)
	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_COLONIST
	return ..()

/datum/equipment_preset/synth/survivor/medical_synth
	name = "Survivor - Synthetic - Medical Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/nursehat,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/medical,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_JACKET = /obj/item/clothing/suit/storage/labcoat/cmo,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/scientist_synth
	name = "Survivor - Synthetic - Scientist Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/purple,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/scientist,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/device/motiondetector,
		WEAR_JACKET = /obj/item/clothing/suit/storage/labcoat/science,
		WEAR_IN_JACKET = /obj/item/paper/research_notes/good,
		WEAR_IN_JACKET = /obj/item/reagent_container/glass/beaker/vial/random/good,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/purple,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/engineer_synth
	name = "Survivor - Synthetic - Engineer Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/hardhat,
		WEAR_BODY = /obj/item/clothing/under/rank/engineer,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_IN_BACK = /obj/item/weapon/melee/twohanded/fireaxe,
		WEAR_IN_BACK = /obj/item/weapon/gun/smg/nailgun/compact,
		WEAR_IN_BACK = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_IN_BACK = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/security_synth
	name = "Survivor - Synthetic - Security Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/sec,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/rank/security2,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/weapon/melee/telebaton,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/corporate_synth
	name = "Survivor - Synthetic - Corporate Synth"
	equipment_to_spawn = list(
		WEAR_BODY = /obj/item/clothing/under/suit_jacket/trainee,
		WEAR_BACK = /obj/item/storage/backpack/satchel/lockable,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_HANDS = /obj/item/clothing/gloves/botanic_leather,
		WEAR_FEET = /obj/item/clothing/shoes/dress
	)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/corporate_synth/load_gear(mob/living/carbon/human/H)
	..()
	add_random_cl_survivor_loot(H)

/datum/equipment_preset/synth/survivor/janitor_synth
	name = "Survivor - Synthetic - Janitor Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/purple,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/rank/janitor,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/reagent_container/spray/cleaner,
		WEAR_IN_BACK = /obj/item/reagent_container/glass/bucket,
		WEAR_IN_BACK = /obj/item/tool/mop,
		WEAR_IN_BACK = /obj/item/tool/wet_sign,
		WEAR_IN_BACK = /obj/item/storage/bag/trash,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest,
		WEAR_HANDS = /obj/item/clothing/gloves/purple,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/galoshes
	)

/datum/equipment_preset/synth/survivor/chef_synth
	name = "Survivor - Synthetic - Chef Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/chefhat,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/rank/chef,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/book/manual/chef_recipes,
		WEAR_IN_BACK = /obj/item/pizzabox,
		WEAR_IN_BACK = /obj/item/reagent_container/spray/cleaner,
		WEAR_JACKET = /obj/item/clothing/suit/chef,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

/datum/equipment_preset/synth/survivor/bartender_synth
	name = "Survivor - Synthetic - Bartender Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bowlerhat,
		WEAR_FACE = /obj/item/clothing/mask/gas/fake_mustache,
		WEAR_BODY = /obj/item/clothing/under/waiter,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/storage/beer_pack,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/tequila,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/cognac,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/grenadine,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/rum,
		WEAR_JACKET = /obj/item/clothing/suit/storage/lawyer/bluejacket,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/black,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

/datum/equipment_preset/synth/survivor/detective_synth
	name = "Survivor - Synthetic - Detective Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/det_hat,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/det,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/weapon/melee/telebaton,
		WEAR_IN_BACK = /obj/item/book/manual/detective,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_IN_BACK = /obj/item/device/camera,
		WEAR_JACKET = /obj/item/clothing/suit/storage/det_suit/black,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/radiation_synth
	name = "Survivor - Synthetic - Radiation Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bio_hood,
		WEAR_BODY = /obj/item/clothing/under/rank/scientist,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/storage/firstaid/toxin,
		WEAR_IN_BACK = /obj/item/device/motiondetector,
		WEAR_JACKET = /obj/item/clothing/suit/bio_suit,
		WEAR_WAIST = /obj/item/tank/emergency_oxygen/double,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife
	)

	survivor_variant = ENGINEERING_SURVIVOR

//*****************************************************************************************************/

/datum/equipment_preset/synth/working_joe
	name = "Working Joe"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	faction_group = list(FACTION_MARINE)
	assignment = JOB_WORKING_JOE
	rank = JOB_WORKING_JOE
	skills = /datum/skills/working_joe
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_APOLLO, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_CHINESE)

/datum/equipment_preset/synth/working_joe/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_WORKING_JOE)

/datum/equipment_preset/synth/working_joe/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	//New equipment added as of 5-20-22
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bucket(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/mop(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/wet_sign(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/bag/trash(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/bag/trash(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/lightreplacer(H.back), WEAR_R_HAND)

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/H)
	. = ..()
	H.h_style = "Bald"
	H.f_style = "Shaved"
	if(prob(5))
		H.h_style = "Shoulder-length Hair" //Added the chance of hair as per Monkeyfist lore accuracy
	H.r_eyes = 0
	H.g_eyes = 0
	H.b_eyes = 0
	H.r_hair = 100
	H.g_hair = 88
	H.b_hair = 74
	H.r_facial = 255
	H.g_facial = 255
	H.b_facial = 255

/datum/equipment_preset/synth/working_joe/load_name(mob/living/carbon/human/H, randomise)
	H.change_real_name(H, "Working Joe #[rand(100)][rand(100)]")

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/cultist_synth
	name = "Cultist - Xeno Cultist Synthetic"
	faction = FACTION_XENOMORPH

/datum/equipment_preset/synth/survivor/cultist_synth/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain/cultist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)

	var/obj/item/clothing/head/cultist_hood/hood = new /obj/item/clothing/head/cultist_hood(H)
	hood.flags_item |= NODROP|DELONDROP
	H.equip_to_slot_or_del(hood, WEAR_HEAD)

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


/datum/equipment_preset/synth/survivor/midwife/load_name(mob/living/carbon/human/H, randomise)
	var/final_name = "Midwife Joe"
	if(H.client && H.client.prefs)
		final_name = H.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Midwife Joe"
		else
			final_name = "Midwife [H.real_name]"
	H.change_real_name(H, final_name)

//*****************************************************************************************************/

/datum/equipment_preset/synth/infiltrator
	name = "Infiltrator Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_NEUTRAL
	assignment = JOB_COLONIST
	rank = JOB_COLONIST
	skills = /datum/skills/infiltrator_synthetic
	idtype = /obj/item/card/id/lanyard
	paygrade = "C"

/datum/equipment_preset/synth/infiltrator/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/synth/infiltrator/load_name(mob/living/carbon/human/H, randomise)
	H.gender = pick(MALE,FEMALE)
	var/random_name
	var/first_name
	var/last_name
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	if(H.gender == MALE)
		first_name = "[pick(first_names_male_colonist)]"
	else
		first_name ="[pick(first_names_female_colonist)]"

	last_name ="[pick(last_names_colonist)]"
	random_name = "[first_name] [last_name]"
	H.change_real_name(H, random_name)
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	H.r_hair = hair_colors[hair_color][1]
	H.g_hair = hair_colors[hair_color][2]
	H.b_hair = hair_colors[hair_color][3]
	H.r_facial = hair_colors[hair_color][1]
	H.g_facial = hair_colors[hair_color][2]
	H.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	H.r_eyes = colors[eye_color][1]
	H.g_eyes = colors[eye_color][2]
	H.b_eyes = colors[eye_color][3]

/datum/equipment_preset/synth/infiltrator/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_INFILTRATOR)

/datum/equipment_preset/synth/infiltrator/load_skills(mob/living/carbon/human/H)
		H.set_skills(/datum/skills/infiltrator_synthetic)
		H.allow_gun_usage = TRUE

/datum/equipment_preset/synth/infiltrator/load_gear(mob/living/carbon/human/H)
	add_random_synth_infiltrator_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs/zip(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/tranquilizer(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/butterfly(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/chloroform(H), WEAR_IN_L_STORE)

//*****************************************************************************************************/
