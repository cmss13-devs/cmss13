/datum/equipment_preset/synth
	name = "Synth"
	uses_special_name = TRUE
	languages = ALL_SYNTH_LANGUAGES
	skills = /datum/skills/synthetic
	paygrade = "SYN"

	minimap_icon = "synth"

/datum/equipment_preset/synth/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth/load_race(mob/living/carbon/human/new_human)
	if(new_human.client?.prefs?.synthetic_type)
		new_human.set_species(new_human.client.prefs.synthetic_type)
		return
	new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "David"
	if(new_human.client && new_human.client.prefs)
		final_name = new_human.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined")
			final_name = "David"
	new_human.change_real_name(new_human, final_name)

/datum/equipment_preset/synth/load_skills(mob/living/carbon/human/new_human)
	. = ..()
	if(iscolonysynthetic(new_human) && !isworkingjoe(new_human))
		new_human.set_skills(/datum/skills/colonial_synthetic)

	new_human.allow_gun_usage = FALSE

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
	paygrade = "SYN"
	role_comm_title = "Syn"

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

/datum/equipment_preset/synth/uscm/wo/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/RO(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/tan(new_human), WEAR_BACK)
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
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	var/survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/load_race(mob/living/carbon/human/new_human)
	//Switch to check client for synthetic generation preference, and set the subspecies of colonial synth
	var/generation_selection = SYNTH_COLONY_GEN_ONE
	if(new_human.client?.prefs?.synthetic_type)
		generation_selection = new_human.client.prefs.synthetic_type
	switch(generation_selection)
		if(SYNTH_GEN_THREE)
			new_human.set_species(SYNTH_COLONY)
		if(SYNTH_GEN_TWO)
			new_human.set_species(SYNTH_COLONY_GEN_TWO)
		if(SYNTH_GEN_ONE)
			new_human.set_species(SYNTH_COLONY_GEN_ONE)
		else
			new_human.set_species(SYNTH_COLONY)

/datum/equipment_preset/synth/survivor/New()
	. = ..()
	access = get_access(ACCESS_LIST_COLONIAL_ALL) + get_region_accesses(2) + get_region_accesses(4) + ACCESS_MARINE_RESEARCH //Access to civillians stuff + medbay stuff + engineering stuff + research

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
		uniform.sensor_faction = FACTION_COLONIST
	return ..()

/datum/equipment_preset/synth/survivor/medical_synth
	name = "Survivor - Synthetic - Medical Synth"
	equipment_to_spawn = list(
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/medical,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/roller/surgical,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/blue,
		WEAR_IN_JACKET = /obj/item/device/healthanalyzer,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/emt_synth
	name = "Survivor - Synthetic - EMT Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap,
		WEAR_R_EAR = /obj/item/device/flashlight/pen,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/colonist/ua_civvies,
		WEAR_BACK = /obj/item/storage/backpack/satchel/med,
		WEAR_IN_BACK = /obj/item/storage/firstaid/adv,
		WEAR_IN_BACK = /obj/item/tool/extinguisher/mini,
		WEAR_IN_BACK = /obj/item/roller,
		WEAR_JACKET = /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr,
		WEAR_IN_JACKET = /obj/item/device/healthanalyzer,
		WEAR_WAIST = /obj/item/storage/belt/medical/full,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/scientist_synth
	name = "Survivor - Synthetic - Scientist Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bio_hood,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/hud/health,
		WEAR_BODY = /obj/item/clothing/under/rank/scientist,
		WEAR_BACK = /obj/item/storage/backpack/satchel/chem,
		WEAR_IN_BACK = /obj/item/reagent_container/glass/beaker/vial/random/good,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_JACKET = /obj/item/clothing/suit/bio_suit,
		WEAR_WAIST = /obj/item/storage/belt/medical/lifesaver/full,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_HAND = /obj/item/device/motiondetector,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/engineer_synth
	name = "Survivor - Synthetic - Engineer Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/hardhat,
		WEAR_BODY = /obj/item/clothing/under/rank/engineer,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_IN_BACK = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/yellow,
		WEAR_IN_JACKET = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_IN_JACKET = /obj/item/ammo_magazine/smg/nailgun,
		WEAR_J_STORE = /obj/item/weapon/gun/smg/nailgun/compact,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/corporate_synth/load_gear(mob/living/carbon/human/new_human)
	..()
	add_random_cl_survivor_loot(new_human)

/datum/equipment_preset/synth/survivor/janitor_synth
	name = "Survivor - Synthetic - Janitor Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/purple,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/rank/janitor,
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
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

/datum/equipment_preset/synth/survivor/chef_synth
	name = "Survivor - Synthetic - Chef Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/chefhat,
		WEAR_FACE = /obj/item/clothing/mask/surgical,
		WEAR_EYES = /obj/item/clothing/glasses/mgoggles,
		WEAR_BODY = /obj/item/clothing/under/rank/chef,
		WEAR_BACK = /obj/item/storage/backpack/satchel/vir,
		WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/sliceable/lemoncake,
		WEAR_R_HAND = /obj/item/pizzabox/margherita,
		WEAR_JACKET = /obj/item/clothing/suit/chef,
		WEAR_HANDS = /obj/item/clothing/gloves/latex,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

/datum/equipment_preset/synth/survivor/teacher_synth
	name = "Survivor - Synthetic - Teacher Synth"
	equipment_to_spawn = list(
		WEAR_EYES = /obj/item/clothing/glasses/regular/hipster,
		WEAR_BODY = /obj/item/clothing/under/colonist/wy_davisone,
		WEAR_BACK = /obj/item/storage/backpack/satchel/norm,
		WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/wrapped/booniebars,
		WEAR_IN_BACK = /obj/item/reagent_container/food/snacks/wy_chips/pepper,
		WEAR_IN_BACK = /obj/item/reagent_container/spray/cleaner,
		WEAR_JACKET = /obj/item/clothing/suit/storage/bomber/alt,
		WEAR_IN_JACKET = /obj/item/storage/box/pdt_kit,
		WEAR_R_HAND = /obj/item/storage/fancy/crayons,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

/datum/equipment_preset/synth/survivor/trucker_synth
	name = "Survivor - Synthetic - Trucker Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/ferret,
		WEAR_BODY = /obj/item/clothing/under/colonist,
		WEAR_BACK = /obj/item/storage/backpack/satchel/norm,
		WEAR_IN_BACK = /obj/item/pamphlet/skill/powerloader,
		WEAR_R_HAND = /obj/item/tool/weldingtool/hugetank,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/baseballbat/metal
	)

/datum/equipment_preset/synth/survivor/bartender_synth
	name = "Survivor - Synthetic - Bartender Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/bowlerhat,
		WEAR_FACE = /obj/item/clothing/mask/gas/fake_mustache,
		WEAR_BODY = /obj/item/clothing/under/waiter,
		WEAR_BACK = /obj/item/storage/backpack/satchel,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/tequila,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/cognac,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/grenadine,
		WEAR_IN_BACK = /obj/item/reagent_container/food/drinks/bottle/rum,
		WEAR_JACKET = /obj/item/clothing/suit/storage/lawyer/bluejacket,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/black,
		WEAR_R_HAND = /obj/item/storage/beer_pack,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

/datum/equipment_preset/synth/survivor/detective_synth
	name = "Survivor - Synthetic - Detective Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/det_hat,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/det,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_JACKET = /obj/item/clothing/suit/storage/det_suit/black,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_HAND = /obj/item/device/camera,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/cmb_synth
	name = "Survivor - Synthetic - CMB Synth"
	idtype = /obj/item/card/id/deputy
	role_comm_title = "CMB Syn"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/CMB,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/CMB/limited,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/CM_uniform,
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

/datum/equipment_preset/synth/survivor/security_synth
	name = "Survivor - Synthetic - Corporate Security Synth"
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "WY Syn"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/soft/sec/corp,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/formal/servicedress,
		WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
		WEAR_IN_BACK = /obj/item/weapon/telebaton,
		WEAR_JACKET = /obj/item/clothing/suit/storage/webbing,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/protection_synth
	name = "Survivor - Synthetic - Corporate Protection Synth"
	idtype = /obj/item/card/id/pmc
	role_comm_title = "WY Syn"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/pmc,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/pmc/hvh,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/marine/veteran/pmc,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/storage/droppouch,
		WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/flashbang,
		WEAR_IN_ACCESSORY = /obj/item/handcuffs/zip,
		WEAR_IN_ACCESSORY = /obj/item/handcuffs/zip,
		WEAR_BACK = /obj/item/storage/backpack/lightpack,
		WEAR_IN_BACK = /obj/item/device/binoculars,
		WEAR_JACKET = /obj/item/clothing/suit/storage/hazardvest/black,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/pmc,
		WEAR_FEET = /obj/item/clothing/shoes/veteran/pmc/knife,
		WEAR_L_HAND = /obj/item/storage/large_holster/machete/full
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/corporate_synth
	name = "Survivor - Synthetic - Corporate Clerical Synth"
	idtype = /obj/item/card/id/data
	role_comm_title = "WY Syn"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_BODY = /obj/item/clothing/under/suit_jacket/trainee,
		WEAR_BACK = /obj/item/storage/backpack/satchel/lockable,
		WEAR_IN_BACK = /obj/item/paper,
		WEAR_IN_BACK = /obj/item/paper,
		WEAR_IN_BACK = /obj/item/folder,
		WEAR_IN_BACK = /obj/item/paper/research_notes/good,
		WEAR_IN_BACK = /obj/item/tool/pen/clicky,
		WEAR_IN_BACK = /obj/item/device/taperecorder,
		WEAR_WAIST = /obj/item/storage/belt/utility/full,
		WEAR_HANDS = /obj/item/clothing/gloves/botanic_leather,
		WEAR_FEET = /obj/item/clothing/shoes/dress,
		WEAR_R_HAND = /obj/item/clipboard,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/radiation_synth
	name = "Survivor - Synthetic - Radiation Synth"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/radiation,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/engi,
		WEAR_BACK = /obj/item/storage/backpack/satchel/eng,
		WEAR_IN_BACK = /obj/item/tool/weldingtool/hugetank,
		WEAR_IN_BACK = /obj/item/storage/firstaid/toxin,
		WEAR_JACKET = /obj/item/clothing/suit/radiation,
		WEAR_WAIST = /obj/item/tank/emergency_oxygen/double,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_R_HAND = /obj/item/device/motiondetector,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/weapon/twohanded/fireaxe
	)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/upp
	name = "Survivor - Synthetic - UPP Synth"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_SYNTH_LANGUAGES_UPP
	assignment = JOB_UPP_COMBAT_SYNTH
	rank = JOB_UPP_COMBAT_SYNTH
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	skills = /datum/skills/colonial_synthetic
	paygrade = "SYN"
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "UPP 173Rd RECON Syn"

/datum/equipment_preset/synth/survivor/upp/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/medic/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/small_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/partial, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/uppsynth, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)

/datum/equipment_preset/synth/survivor/pmc
	name = "Survivor - Synthetic - PMC Support Synth"
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_SURVIVOR)
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/pmc
	assignment = JOB_PMC_SYNTH
	rank = JOB_PMC_SYNTH
	role_comm_title = "WY Syn"

/datum/equipment_preset/synth/survivor/pmc/load_race(mob/living/carbon/human/new_human)
		new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/survivor/pmc/load_gear(mob/living/carbon/human/new_human)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth, WEAR_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/nailgun, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/nailgun, WEAR_IN_JACKET)

		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
		new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/command/hvh, WEAR_L_EAR)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/experimental_mesons, WEAR_EYES)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)

		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

		new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/white, WEAR_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor, WEAR_IN_BACK)

		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun/compact, WEAR_J_STORE)

		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_R_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/synth/working_joe
	name = "Synthetic - Working Joe"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	faction_group = list(FACTION_MARINE)
	assignment = JOB_WORKING_JOE
	rank = JOB_WORKING_JOE
	skills = /datum/skills/working_joe
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_APOLLO, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_CHINESE)

/datum/equipment_preset/synth/working_joe/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_WORKING_JOE)

/datum/equipment_preset/synth/working_joe/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/synth/working_joe/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET) //don't remove shrap by yourself, go to android maintenance or have ARES call a human handler!
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bucket(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wet_sign(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/lights/mixed(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bag/trash(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/circuitboard/apc(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/circuitboard/airlock(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/cell(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/cell(new_human.back), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/lightreplacer(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/glass/medium_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_J_STORE)


/datum/equipment_preset/synth/working_joe/engi
	name = "Synthetic - Hazmat Joe"

/datum/equipment_preset/synth/working_joe/engi/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/joe(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/joe(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/inflatable/door(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/inflatable/door(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/inflatable(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/inflatable(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_J_STORE)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe/engi(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/joe/engi/overalls(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/lightreplacer(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/glass/large_stack(new_human.back), WEAR_IN_R_STORE)

/datum/equipment_preset/synth/working_joe/load_race(mob/living/carbon/human/new_human)
	. = ..()
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
	new_human.change_real_name(new_human, "Working Joe #[rand(100)][rand(100)]")

//*****************************************************************************************************/

/datum/equipment_preset/synth/survivor/cultist_synth
	name = "Cultist - Xeno Cultist Synthetic"
	faction = FACTION_XENOMORPH

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
	paygrade = "C"

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
		first_name = "[pick(first_names_male_colonist)]"
	else
		first_name ="[pick(first_names_female_colonist)]"

	last_name ="[pick(last_names_colonist)]"
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
	new_human.equip_to_slot_or_del(new /obj/item/handcuffs/zip(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/tranquilizer(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/butterfly(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/chloroform(new_human), WEAR_IN_L_STORE)

//*****************************************************************************************************/
