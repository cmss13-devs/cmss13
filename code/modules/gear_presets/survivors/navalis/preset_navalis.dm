// Civilian Survivors //

// Automation Specialist

/datum/equipment_preset/survivor/navalis/automation_specialist
	name = "Survivor - Navalis - Automation Specialist"
	assignment = "Automation Specialist"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/navalis/automation_specialist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/blue(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor(new_human), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

// Radio Operator (Has knowedge of Marines coming)

/datum/equipment_preset/survivor/navalis/radio_operator
	name = "Survivor - Navalis - Radio Operator"
	assignment = "Radio Operator"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/navalis/radio_operator/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/blue(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/navalis/rescue(new_human), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

// Security Survivors //

// Security Officer

/datum/equipment_preset/survivor/navalis/platform_guard
	name = "Survivor - Navalis - Platform Security Guard"
	assignment = "NP13 - Platform Security Guard"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	skills = /datum/skills/civilian/survivor/goon
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/navalis/platform_guard/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)

// Science Survivors //

// Exo-Geologist

/datum/equipment_preset/survivor/navalis/exo_geologist
	name = "Survivor - Navalis - Exo-Geologist"
	assignment = "Exo-Geologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/navalis/exo_geologist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/nspa_hazard, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green, WEAR_FEET)
	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

// Medical Survivors //

// Medic

/datum/equipment_preset/survivor/navalis/medic
	name = "Survivor - Navalis - Medical Technician"
	assignment = "Medical Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = "Medical Technician"
	skills = /datum/skills/civilian/survivor/paramedic
	idtype = /obj/item/card/id/silver
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/navalis/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_green, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Corporate Survivors //

// Platform First Officer

/datum/equipment_preset/survivor/navalis/first_officer
	name = "Survivor - Navalis - Platform First Officer"
	assignment = "First Officer"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL,ACCESS_WY_EXEC,)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/navalis/first_officer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone(new_human), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)
	..()

// Engineering Survivors //

// Operations Engineer

/datum/equipment_preset/survivor/navalis/operations_engineer
	name = "Survivor - Navalis - Operations Engineer"
	assignment = "Operations Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/navalis/operations_engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding, WEAR_EYES)
	add_survivor_weapon_civilian(new_human)
	..()

// Platform Maint Tech

/datum/equipment_preset/survivor/navalis/maint_tech
	name = "Survivor - Navalis - Platform Maintenance Technician"
	assignment = "Platform Maintenance Technician"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/navalis/maint_tech/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/worker_overalls, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding, WEAR_EYES)
	add_survivor_weapon_civilian(new_human)
	..()

// Hostile Survivors //

/datum/equipment_preset/survivor/navalis/clf_wet_ops
	name = "Survivor - Navalis - CLF Special Forces"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/civilian/survivor/clf
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_CLF
	faction_group = list(FACTION_CLF, FACTION_SURVIVOR)
	minimap_background = "background_clf"
	minimap_icon = "clf_mil"
	access = list(ACCESS_CIVILIAN_PUBLIC)
	survivor_variant = HOSTILE_SURVIVOR

/datum/equipment_preset/survivor/navalis/clf_wet_ops/load_gear(mob/living/carbon/human/new_human)
	spawn_rebel_uniform(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/grey, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/cosmetic, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/bullet_pipe, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/vest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/book/codebook/wey_yu(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/clf(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/ld50_syringe/choral(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	..()
