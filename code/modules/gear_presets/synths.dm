/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = ALL_SYNTH_LANGUAGES
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)

	minimap_icon = "synth"

/datum/equipment_preset/synth/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth/load_race(mob/living/carbon/human/new_human)
	var/generation_selection = SYNTH_GEN_THREE
	if(new_human.client?.prefs?.synthetic_type)
		generation_selection = new_human.client.prefs.synthetic_type
	switch(generation_selection)
		if(SYNTH_GEN_THREE)
			new_human.set_species(SYNTH_GEN_THREE)
		if(SYNTH_GEN_TWO)
			new_human.set_species(SYNTH_COLONY_GEN_TWO)
		if(SYNTH_GEN_ONE)
			new_human.set_species(SYNTH_COLONY_GEN_ONE)
		else
			new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "David"
	if(new_human.client && new_human.client.prefs)
		final_name = new_human.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined")
			final_name = "David"
	new_human.change_real_name(new_human, final_name)

/datum/equipment_preset/synth/load_skills(mob/living/carbon/human/new_human, client/mob_client)
	new_human.allow_gun_usage = FALSE

	if(iscolonysynthetic(new_human) && !isworkingjoe(new_human))
		new_human.set_skills(/datum/skills/colonial_synthetic)
		return

	if(!mob_client)
		new_human.set_skills(/datum/skills/synthetic)
		return

	switch(mob_client.prefs.synthetic_type)
		if(SYNTH_GEN_ONE, SYNTH_GEN_TWO)
			new_human.set_skills(/datum/skills/colonial_synthetic)
		else
			new_human.set_skills(/datum/skills/synthetic)
//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm
	name = "USCM Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH
	rank = "Synthetic"
	role_comm_title = "Syn"

	minimap_icon = "synth"
	paygrades = list(PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/synth/uscm/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/industrial

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/councillor
	name = "USCM Synthetic Councillor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH
	rank = "Synthetic"
	role_comm_title = "Syn"
	paygrades = list(PAY_SHORT_ME9 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/synth/uscm/councillor/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/industrial

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/councillor(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/synth/uscm/wo
	name = "WO Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO
	paygrades = list(PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_0)

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

/datum/equipment_preset/synth/survivor
	name = "Survivor - Synthetic - Classic Joe"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_SURVIVOR)
	idtype = /obj/item/card/id/lanyard
	assignment = JOB_SYNTH
	rank = JOB_SYNTH_SURVIVOR
	skills = /datum/skills/colonial_synthetic

	var/list/equipment_to_spawn = list(
		WEAR_BODY = /obj/item/clothing/under/rank/synthetic/joe,
		WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
		WEAR_IN_BACK = /obj/item/tool/weldingtool/hugetank,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/maintenance_jack
	)

	var/survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/new_human)
	//Switch to check client for synthetic generation preference, and set the subspecies of colonial synth
	var/generation_selection = SYNTH_COLONY_GEN_ONE
	if(new_human.client?.prefs?.synthetic_type)
		generation_selection = new_human.client.prefs.synthetic_type
	switch(generation_selection)
		if(SYNTH_GEN_THREE)
			new_human.set_species(SYNTH_GEN_THREE)
		if(SYNTH_GEN_TWO)
			new_human.set_species(SYNTH_COLONY_GEN_TWO)
		if(SYNTH_GEN_ONE)
			new_human.set_species(SYNTH_COLONY_GEN_ONE)
		else
			new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_access(ACCESS_LIST_COLONIAL_ALL) + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH //Access to civillians stuff + medbay stuff + engineering stuff + research

/datum/equipment_preset/synth/survivor/pmc/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_PMC)

/datum/equipment_preset/synth/survivor/wy
	flags = EQUIPMENT_PRESET_STUB
	minimap_background = "background_goon"

/datum/equipment_preset/synth/survivor/wy/New()
	. = ..()
	access = get_access(ACCESS_LIST_COLONIAL_ALL) + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH + ACCESS_WY_GENERAL // for WY synths - admin building and wy fax machines access

/datum/equipment_preset/synth/survivor/load_gear(mob/living/carbon/human/new_human)
	for(var/equipment in equipment_to_spawn)
		var/equipment_path = islist(equipment_to_spawn[equipment]) ? pick(equipment_to_spawn[equipment]) : equipment_to_spawn[equipment]
		new_human.equip_to_slot_or_del(new equipment_path(new_human), equipment)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_L_STORE)

/datum/equipment_preset/synth/survivor/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	return ..()

/datum/equipment_preset/synth/survivor/surgeon_synth
	name = "Survivor - Synthetic - Surgeon Synth"
	equipment_to_spawn = list(
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/medical/green,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/stethoscope,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/roller/surgical,
		WEAR_JACKET = /obj/item/clothing/suit/chef/classic/medical,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/white,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe,
		WEAR_R_HAND = /obj/item/device/healthanalyzer
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/doctor_synth
	name = "Survivor - Synthetic - Doctor Synth"
	equipment_to_spawn = list(
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/chief_medical_officer,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/stethoscope,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/roller/surgical,
		WEAR_JACKET = /obj/item/clothing/suit/storage/labcoat,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe,
		WEAR_R_HAND = /obj/item/device/healthanalyzer
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/emt_synth_teal
	name = "Survivor - Synthetic - Teal EMT Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap,
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/paramedic,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/med,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/roller,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/medical_green,
		WEAR_IN_JACKET = /obj/item/device/healthanalyzer,
		WEAR_WAIST = /obj/item/storage/belt/medical/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/emt_synth_red
	name = "Survivor - Synthetic - Red EMT Synth"
	equipment_to_spawn = list(
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/paramedic/red,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/med,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/roller,
		WEAR_JACKET = /obj/item/clothing/suit/hybrisa/EMT_red_utility,
		WEAR_WAIST = /obj/item/storage/belt/medical/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe,
		WEAR_R_HAND = /obj/item/device/healthanalyzer,
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/scientist_synth
	name = "Survivor - Synthetic - Scientist Synth"
	equipment_to_spawn = list(
		WEAR_EYES = /obj/item/clothing/glasses/science,
		WEAR_BODY = /obj/item/clothing/under/detective/neutral,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_JACKET = /obj/item/clothing/suit/storage/labcoat,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_HAND = /obj/item/device/motiondetector,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/biohazard_synth
	name = "Survivor - Synthetic - Biohazardous Research Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bio_hood/synth,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/science,
		WEAR_BODY = /obj/item/clothing/under/rank/scientist/hybrisa,
		WEAR_BACK = /obj/item/storage/backpack/satchel/tox,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_JACKET = /obj/item/clothing/suit/storage/synthbio,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_HAND = /obj/item/device/motiondetector,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/white,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/archaeologist_synth
	name = "Survivor - Synthetic - Archaeologist Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/boonie/tan,
		WEAR_BODY = /obj/item/clothing/under/colonist/workwear/blue,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/tool/shovel/spade,
		WEAR_JACKET = /obj/item/clothing/suit/storage/utility_vest,
		WEAR_IN_JACKET = /obj/item/explosive/plastic,
		WEAR_WAIST = /obj/item/device/flashlight/lantern,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_HAND = /obj/item/stack/sandbags_empty/half,
		WEAR_FEET = /obj/item/clothing/shoes/laceup/brown,
		WEAR_L_HAND = /obj/item/tool/pickaxe
	)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/engineer_synth
	name = "Survivor - Synthetic - Engineer Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/hardhat,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/engineering_utility,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/engine,
		WEAR_EYES = /obj/item/clothing/glasses/kutjevo/safety,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_IN_BACK = /obj/item/stack/sheet/metal/med_small_stack,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/yellow,
		WEAR_IN_JACKET = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_J_STORE = /obj/item/weapon/gun/smg/nailgun/compact,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/maintenance_jack
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/radiation_synth
	name = "Survivor - Synthetic - Radiation Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/radiation,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/engi,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_IN_BACK = /obj/item/tool/weldingtool/hugetank,
		WEAR_JACKET = /obj/item/clothing/suit/radiation,
		WEAR_WAIST = /obj/item/tank/emergency_oxygen/double,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_R_HAND = /obj/item/storage/pouch/electronics/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/maintenance_jack
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/firefighter_synth
	name = "Survivor - Synthetic - Fire Response Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/hardhat/red,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/engineering_utility,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/engine,
		WEAR_EYES = /obj/item/clothing/glasses/kutjevo/safety,
		WEAR_JACKET = /obj/item/clothing/suit/fire/firefighter,
		WEAR_WAIST = /obj/item/storage/backpack/general_belt,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/maintenance_jack,
		WEAR_R_HAND = /obj/item/reagent_container/glass/watertank/atmos
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/miner_synth
	name = "Survivor - Synthetic - Mining Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/hardhat/orange,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/kelland_mining,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/engine,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_EYES = /obj/item/clothing/glasses/material,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/kelland_mining,
		WEAR_J_STORE = /obj/item/maintenance_jack,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_HANDS = /obj/item/clothing/gloves/brown,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/brown,
		WEAR_L_HAND = /obj/item/tool/pickaxe/hammer
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/corporate_synth
	name = "Survivor - Synthetic - Corporate Synth"

/datum/equipment_preset/synth/survivor/corporate_synth/load_gear(mob/living/carbon/human/new_human)
	..()
	add_random_cl_survivor_loot(new_human)

/datum/equipment_preset/synth/survivor/janitor_synth
	name = "Survivor - Synthetic - Janitor Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/purple,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/rank/janitor,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/armband/med,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/reagent_container/glass/bucket,
		WEAR_IN_BACK = /obj/item/tool/wet_sign,
		WEAR_IN_BACK = /obj/item/storage/bag/trash,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest,
		WEAR_IN_JACKET = /obj/item/reagent_container/spray/cleaner,
		WEAR_HANDS = /obj/item/clothing/gloves/purple,
		WEAR_R_HAND = /obj/item/tool/mop,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/galoshes,
		WEAR_L_HAND = /obj/item/weapon/twohanded/spear
	)

/datum/equipment_preset/synth/survivor/fisher_synth
	name = "Survivor - Synthetic - Fishing Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/boonie/tan,
		WEAR_EYES = /obj/item/clothing/glasses/regular/hipster,
		WEAR_BODY = /obj/item/clothing/under/colonist/workwear,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_JACKET = /obj/item/clothing/suit/storage/apron/overalls/red,
		WEAR_IN_JACKET = /obj/item/reagent_container/spray/cleaner,
		WEAR_HANDS = /obj/item/clothing/gloves/brown,
		WEAR_R_HAND = /obj/item/fishing_pole,
		WEAR_FEET = /obj/item/clothing/shoes/marine/brown,
		WEAR_L_HAND = /obj/item/reagent_container/food/snacks/fishable/crab
	)

/datum/equipment_preset/synth/survivor/hydro_synth
	name = "Survivor - Synthetic - Hydroponics Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap,
		WEAR_EYES = /obj/item/clothing/glasses/regular/hipster,
		WEAR_BODY = /obj/item/clothing/under/colonist/workwear/green,
		WEAR_BACK = /obj/item/storage/backpack/satchel/hyd,
		WEAR_IN_BACK = /obj/item/tool/shovel/spade,
		WEAR_WAIST = /obj/item/reagent_container/spray/plantbgone,
		WEAR_JACKET = /obj/item/clothing/suit/storage/jacket/marine/vest,
		WEAR_HANDS = /obj/item/clothing/gloves/brown,
		WEAR_R_HAND = /obj/item/tool/hatchet,
		WEAR_FEET = /obj/item/clothing/shoes/brown
	)

/datum/equipment_preset/synth/survivor/chef_synth
	name = "Survivor - Synthetic - Chef Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/chefhat,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/liaison_suit/black,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/sliceable/lemoncake,
		WEAR_R_HAND = /obj/item/pizzabox/margherita,
		WEAR_JACKET = /obj/item/clothing/suit/chef/classic,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/tool/kitchen/knife/butcher
	)

/datum/equipment_preset/synth/survivor/teacher_synth
	name = "Survivor - Synthetic - Teacher Synth"
	equipment_to_spawn = list(
		WEAR_EYES = /obj/item/clothing/glasses/regular/hipster,
		WEAR_BODY = /obj/item/clothing/under/rank/utility/brown,
		WEAR_BACK = /obj/item/storage/backpack/satchel/norm,
		WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/wy_chips/pepper,
		WEAR_IN_BACK = /obj/item/storage/box/pdt_kit,
		WEAR_JACKET = /obj/item/clothing/suit/storage/bomber/alt,
		WEAR_IN_JACKET = /obj/item/device/healthanalyzer,
		WEAR_WAIST = /obj/item/reagent_container/spray/cleaner,
		WEAR_R_HAND = /obj/item/storage/fancy/crayons,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/butterfly/switchblade
	)

/datum/equipment_preset/synth/survivor/freelancer_synth
	name = "Survivor - Synthetic - Freelancer Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/welding,
		WEAR_FACE = /obj/item/clothing/mask/rebreather/scarf,
		WEAR_BODY = /obj/item/clothing/under/marine/veteran/freelancer,
		WEAR_BACK = /obj/item/storage/backpack/lightpack,
		WEAR_IN_BACK = /obj/item/tool/weldpack/minitank,
		WEAR_JACKET = /obj/item/clothing/suit/storage/utility_vest,
		WEAR_IN_JACKET = /obj/item/explosive/grenade/smokebomb,
		WEAR_WAIST = /obj/item/storage/belt/marine,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran,
		WEAR_R_HAND = /obj/item/storage/pouch/flare/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/upp/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/katana/full,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/patch/freelancer_patch
	)

/datum/equipment_preset/synth/survivor/surveyor_synth
	name = "Survivor - Synthetic - Surveyor Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/flap,
		WEAR_FACE = /obj/item/clothing/mask/tornscarf,
		WEAR_BODY = /obj/item/clothing/under/rank/utility,
		WEAR_BACK = /obj/item/storage/backpack/lightpack/five_slot,
		WEAR_IN_BACK = /obj/item/storage/box/m94,
		WEAR_JACKET = /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant,
		WEAR_IN_JACKET = /obj/item/device/binoculars,
		WEAR_WAIST = /obj/item/storage/backpack/general_belt,
		WEAR_IN_BELT = /obj/item/stack/flag/green,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran,
		WEAR_R_HAND = /obj/item/storage/box/lightstick,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

/datum/equipment_preset/synth/survivor/trucker_synth
	name = "Survivor - Synthetic - Trucker Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/ferret,
		WEAR_BODY = /obj/item/clothing/under/rank/frontier,
		WEAR_BACK = /obj/item/storage/backpack/satchel/norm,
		WEAR_IN_BACK = /obj/item/pamphlet/skill/powerloader,
		WEAR_R_HAND = /obj/item/hardpoint/locomotion/van_wheels,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/baseballbat/metal
	)

/datum/equipment_preset/synth/survivor/bartender_synth
	name = "Survivor - Synthetic - Bartender Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bowlerhat,
		WEAR_BODY = /obj/item/clothing/under/colonist/white_service,
		WEAR_BACK = /obj/item/storage/backpack/satchel/black,
		WEAR_IN_BACK = /obj/item/clothing/mask/gas/fake_mustache,
		WEAR_JACKET = /obj/item/clothing/suit/storage/wcoat,
		WEAR_IN_JACKET = /obj/item/reagent_container/food/drinks/bottle/rum,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/black,
		WEAR_R_HAND = /obj/item/storage/beer_pack,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/baseballbat
	)

/datum/equipment_preset/synth/survivor/atc_synth
	name = "Survivor - Synthetic - Landing Pad Attendant Synth"
	equipment_to_spawn = list(
		WEAR_R_EAR = /obj/item/clothing/ears/earmuffs,
		WEAR_HEAD = /obj/item/clothing/head/cmcap,
		WEAR_BODY = /obj/item/clothing/under/rank/utility/yellow,
		WEAR_BACK = /obj/item/storage/backpack/satchel/norm,
		WEAR_IN_BACK = /obj/item/storage/box/m94,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest,
		WEAR_IN_JACKET = /obj/item/device/binoculars,
		WEAR_WAIST = /obj/item/storage/backpack/general_belt,
		WEAR_IN_BELT = /obj/item/stack/flag/red,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran,
		WEAR_R_HAND = /obj/item/storage/box/lightstick/red,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

/datum/equipment_preset/synth/survivor/journalist_synth
	name = "Survivor - Synthetic - Videojournalist Synth"
	equipment_to_spawn = list(
		WEAR_EYES = /obj/item/clothing/glasses/regular/hipster,
		WEAR_BODY = /obj/item/clothing/under/liaison_suit/black,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/blue,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_JACKET = /obj/item/clothing/suit/storage/jacket/marine/corporate/black,
		WEAR_IN_JACKET = /obj/item/reagent_container/spray/cleaner,
		WEAR_WAIST = /obj/item/device/camera/oldcamera,
		WEAR_R_HAND = /obj/item/device/broadcasting,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_L_HAND = /obj/item/weapon/butterfly/switchblade
	)

/datum/equipment_preset/synth/survivor/detective_synth
	name = "Survivor - Synthetic - Detective Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/fedora,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/detective,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_JACKET = /obj/item/clothing/suit/storage/CMB/trenchcoat,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full/synth,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_HAND = /obj/item/device/camera,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/cmb_synth
	name = "Survivor - Synthetic - CMB Investigative Synthetic"
	idtype = /obj/item/card/id/deputy
	role_comm_title = "CMB Syn"
	assignment = JOB_CMB_SYN
	rank = JOB_CMB_SYN
	paygrades = list(PAY_SHORT_CMBS = JOB_PLAYTIME_TIER_0)
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE, FACTION_SURVIVOR)
	minimap_background = "background_cmb"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/CMB,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/CMB/limited,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/CM_uniform,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/holobadge/cord,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/device/camera,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_JACKET = /obj/item/clothing/suit/storage/CMB,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/CMB/synth,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/wy/security_synth
	name = "Survivor - Synthetic - Corporate Security Synth"
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "WY Syn"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/wy_cap,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/colonist/white_service,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/restraint/handcuffs,
		WEAR_IN_BACK = /obj/item/restraint/handcuffs,
		WEAR_JACKET = /obj/item/clothing/suit/storage/webbing,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full/synth,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/classic_baton
	)

	survivor_variant = SECURITY_SURVIVOR
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/synth/survivor/wy/protection_synth
	name = "Survivor - Synthetic - Corporate Protection Synth"
	idtype = /obj/item/card/id/pmc
	role_comm_title = "WY Syn"
	minimap_icon = "pmc_syn"
	minimap_background = "background_pmc"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/pmc,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/pmc/hvh,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/marine/veteran/pmc,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/storage/droppouch,
		WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/flashbang,
		WEAR_BACK = /obj/item/storage/backpack/lightpack/five_slot,
		WEAR_IN_BACK = /obj/item/device/binoculars,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/black,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/pmc,
		WEAR_FEET = /obj/item/clothing/shoes/veteran/pmc/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

	survivor_variant = SECURITY_SURVIVOR
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/synth/survivor/wy/corporate_synth
	name = "Survivor - Synthetic - Corporate Clerical Synth"
	idtype = /obj/item/card/id/data
	role_comm_title = "WY Syn"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_R_EAR = /obj/item/tool/pen/clicky,
		WEAR_BODY = /obj/item/clothing/under/suit_jacket/trainee,
		WEAR_BACK = /obj/item/storage/backpack/satchel/lockable,
		WEAR_IN_BACK = /obj/item/notepad,
		WEAR_IN_BACK = /obj/item/folder,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_HANDS = /obj/item/clothing/gloves/botanic_leather,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_R_HAND = /obj/item/clipboard,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = CORPORATE_SURVIVOR
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/synth/survivor/icc_synth
	name = "Survivor - Synthetic - Interstellar Commerce Commission Synthetic"
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "ICC Syn"
	minimap_background = "background_cmb"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/CMB/limited,
		WEAR_R_EAR = /obj/item/tool/pen/clicky,
		WEAR_HEAD = /obj/item/clothing/head/hardhat/white,
		WEAR_BODY = /obj/item/clothing/under/liaison_suit/black,
		WEAR_BACK = /obj/item/storage/backpack/satchel/lockable,
		WEAR_IN_BACK = /obj/item/notepad,
		WEAR_IN_BACK = /obj/item/folder,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_WAIST = /obj/item/clipboard,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/yellow,
		WEAR_IN_JACKET = /obj/item/device/taperecorder,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_R_HAND = /obj/item/device/camera,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/pilot_synth
	name = "Survivor - Synthetic - WY Pilot Synth"
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "Pilot Syn"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_R_EAR = /obj/item/tool/pen/clicky,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/aviator/silver,
		WEAR_HEAD = /obj/item/clothing/head/hybrisa/wy_po_cap,
		WEAR_BODY = /obj/item/clothing/under/hybrisa/wy_pilot,
		WEAR_BACK = /obj/item/storage/backpack/satchel/black,
		WEAR_IN_BACK = /obj/item/map/current_map,
		WEAR_WAIST = /obj/item/clipboard,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hybrisa/wy_Pilot,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_L_HAND = /obj/item/weapon/telebaton
	)

	survivor_variant = CORPORATE_SURVIVOR

//*****************************************************************************************************/

/datum/equipment_preset/synth/working_joe
	name = "Synthetic - Working Joe"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	faction_group = list(FACTION_MARINE)
	assignment = JOB_WORKING_JOE
	rank = JOB_WORKING_JOE

	minimap_icon = "joe"

	skills = /datum/skills/working_joe
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_APOLLO, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_GERMAN, LANGUAGE_SCANDINAVIAN, LANGUAGE_FRENCH, LANGUAGE_SPANISH, LANGUAGE_CHINESE)
	/// Used to set species when loading race
	var/joe_type = SYNTH_WORKING_JOE

/datum/equipment_preset/synth/working_joe/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/new_human)
	. = ..()
	new_human.set_species(joe_type)
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"
	if(prob(5))
		new_human.grad_style = "None" //No gradients for Working Joes
		new_human.h_style = "Shoulder-length Hair" //Added the chance of hair as per Monkeyfist lore accuracy
	new_human.r_eyes = 0
	new_human.g_eyes = 0
	new_human.b_eyes = 0
	new_human.r_hair = 100
	new_human.g_hair = 88
	new_human.b_hair = 74
	new_human.r_facial = 255
	new_human.g_facial = 255
	new_human.b_facial = 255

/datum/equipment_preset/synth/working_joe/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/synth/working_joe/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET) //don't remove shrap by yourself, go to android maintenance or have ARES call a human handler!
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/sling(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/working_joe_pda(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/seegson(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bucket(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wet_sign(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bag/trash(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/circuitboard/apc(new_human.back), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/circuitboard/airlock(new_human.back), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/cell(new_human.back), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/lightreplacer(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/glass/reinforced/medium_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_J_STORE)


/datum/equipment_preset/synth/working_joe/engi
	name = "Synthetic - Hazmat Joe"
	joe_type = SYNTH_HAZARD_JOE

/datum/equipment_preset/synth/working_joe/engi/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/joe(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/joe(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/seegson(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/briefcase/inflatable/small(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_J_STORE)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe/engi(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe/engi/overalls(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/sling(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/working_joe_pda(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/lightreplacer(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/glass/reinforced/large_stack(new_human.back), WEAR_IN_R_STORE)

/datum/equipment_preset/synth/working_joe/upp
	name = "Synthetic - Dzho Automaton"
	assignment = JOB_UPP_JOE
	rank = JOB_UPP_JOE
	joe_type = SYNTH_UPP_JOE
	idtype = /obj/item/card/id/dogtag
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_CHINESE, LANGUAGE_ENGLISH)

/datum/equipment_preset/synth/working_joe/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/upp_joe(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/upp/dzho(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bucket/janibucket(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/hyperdyne(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/lightreplacer(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/glass/reinforced/medium_stack(new_human.back), WEAR_IN_R_STORE)

/datum/equipment_preset/synth/working_joe/upp/load_skills(mob/living/carbon/human/new_human)
	. = ..()
	new_human.allow_gun_usage = TRUE

/datum/equipment_preset/synth/working_joe/upp/load_race(mob/living/carbon/human/new_human)
	. = ..()
	new_human.set_species(joe_type)
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"
	if(prob(5))
		new_human.grad_style = "None" //No gradients for Working Joes
		new_human.h_style = "Shoulder-length Hair" //Added the chance of hair as per Monkeyfist lore accuracy
	new_human.r_eyes = 0
	new_human.g_eyes = 0
	new_human.b_eyes = 0
	new_human.r_hair = 100
	new_human.g_hair = 88
	new_human.b_hair = 74
	new_human.r_facial = 255
	new_human.g_facial = 255
	new_human.b_facial = 255

/datum/equipment_preset/synth/working_joe/load_name(mob/living/carbon/human/new_human, randomise)
	if(src.faction == FACTION_UPP)
		new_human.change_real_name(new_human, "Dzho Automaton №[rand(9)][rand(9)][ascii2text(rand(65, 90))][ascii2text(rand(65, 90))]")
	else
		new_human.change_real_name(new_human, "Working Joe #[rand(100)][rand(100)]")

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/cultist_synth
	name = "Cultist - Xeno Cultist Synthetic"
	faction = FACTION_XENOMORPH
	minimap_icon = "cult_synth"
	minimap_background = "background_cultist"

/datum/equipment_preset/synth/survivor/cultist_synth/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/medic
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/medic

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain/cultist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)

	var/obj/item/clothing/head/cultist_hood/hood = new /obj/item/clothing/head/cultist_hood(new_human)
	hood.flags_item |= NODROP|DELONDROP
	new_human.equip_to_slot_or_del(hood, WEAR_HEAD)

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/midwife
	name = "Fun - Xeno Cultist Midwife (Synthetic)"
	faction = FACTION_XENOMORPH

/datum/equipment_preset/synth/survivor/midwife/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/medic
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/medic

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/xenos(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/collectable/xenom(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)


/datum/equipment_preset/synth/survivor/midwife/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "Midwife Joe"
	if(new_human.client && new_human.client.prefs)
		final_name = new_human.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Midwife Joe"
		else
			final_name = "Midwife [new_human.real_name]"
	new_human.change_real_name(new_human, final_name)

//*****************************************************************************************************/

/datum/equipment_preset/synth/infiltrator
	name = "Infiltrator Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_NEUTRAL
	assignment = JOB_COLONIST
	rank = JOB_COLONIST
	skills = /datum/skills/infiltrator_synthetic
	idtype = /obj/item/card/id/lanyard
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/synth/infiltrator/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth/infiltrator/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE,FEMALE)
	var/random_name
	var/first_name
	var/last_name
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	if(new_human.gender == MALE)
		first_name = "[pick(GLOB.first_names_male_colonist)]"
	else
		first_name ="[pick(GLOB.first_names_female_colonist)]"

	last_name ="[pick(GLOB.last_names_colonist)]"
	random_name = "[first_name] [last_name]"
	new_human.change_real_name(new_human, random_name)
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]

/datum/equipment_preset/synth/infiltrator/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_INFILTRATOR)

/datum/equipment_preset/synth/infiltrator/load_skills(mob/living/carbon/human/new_human)
		new_human.set_skills(/datum/skills/infiltrator_synthetic)
		new_human.allow_gun_usage = TRUE

/datum/equipment_preset/synth/infiltrator/load_gear(mob/living/carbon/human/new_human)
	add_random_synth_infiltrator_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/nanopaste(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/tranquilizer(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/butterfly(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/chloroform(new_human), WEAR_IN_L_STORE)

//*****************************************************************************************************/
