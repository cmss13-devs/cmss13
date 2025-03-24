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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_R_STORE)
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
	skills = /datum/skills/civilian/survivor/manager
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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)
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
	name = "Survivor - CLF Special Forces (Template Base)"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/clf
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_CLF
	faction_group = list(FACTION_CLF, FACTION_SURVIVOR)
	minimap_background = "background_clf"
	minimap_icon = "CLF Guerilla"
	assignment = "CLF Guerilla"
	rank = JOB_CLF
	access = list(ACCESS_CIVILIAN_PUBLIC)
//	survivor_variant = HOSTILE_SURVIVOR

/datum/equipment_preset/survivor/navalis/clf_wet_ops/operative
	name = "Survivor - Navalis - CLF Special Force: Operative"
	role_comm_title = "OPER."

/datum/equipment_preset/survivor/navalis/clf_wet_ops/operative/load_gear(mob/living/carbon/human/new_human)
	var/random_helm = rand(1,2)
	var/random_armor = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/operative(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/clf(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/ld50_syringe/choral(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)


	switch(random_helm)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/riot(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles/clf_riot_shield(new_human), WEAR_IN_HELMET)

	switch(random_armor)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_JACKET)

		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_JACKET)

	..()

/datum/equipment_preset/survivor/navalis/clf_wet_ops/tech
	name = "Survivor - Navalis - CLF Special Force: Technician"
	assignment = "CLF Field Technician"
	rank = JOB_CLF_ENGI
	role_comm_title = "TECH."
	skills = /datum/skills/clf/combat_engineer


/datum/equipment_preset/survivor/navalis/clf_wet_ops/tech/load_gear(mob/living/carbon/human/new_human)
	var/random_helm = rand(1,2)
	var/random_armor = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/operative(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/ld50_syringe/choral(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/toolkit/full(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)


	switch(random_helm)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf, WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/riot, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles/clf_riot_shield, WEAR_IN_HELMET)

	switch(random_armor)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_JACKET)

		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_JACKET)

	..()

/datum/equipment_preset/survivor/navalis/clf_wet_ops/medic
	name = "Survivor - Navalis - CLF Special Force: Medic"
	assignment = "CLF Field Medic"
	rank = JOB_CLF_MEDIC
	role_comm_title = "MED."
	skills = /datum/skills/clf/combat_medic

/datum/equipment_preset/survivor/navalis/clf_wet_ops/medic/load_gear(mob/living/carbon/human/new_human)
	var/random_helm = rand(1,2)
	var/random_armor = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/five_slots(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/tactical(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)

	switch(random_helm)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/riot(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles/clf_riot_shield(new_human), WEAR_IN_HELMET)

	switch(random_armor)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_JACKET)

		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/mre_food_packet/clf(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_JACKET)

	..()

/datum/equipment_preset/survivor/navalis/clf_wet_ops/spec
	name = "Survivor - Navalis - CLF Special Force: Heavy Weapons"
	assignment = "CLF Field Specialist"
	rank = JOB_CLF_SPECIALIST
	role_comm_title = "SPEC."
	skills = /datum/skills/clf/specialist

/datum/equipment_preset/survivor/navalis/clf_wet_ops/spec/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/operative, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf/heavy, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf/heavy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16/ext(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/clf(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/ld50_syringe/choral(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

	..()

/datum/equipment_preset/survivor/navalis/clf_wet_ops/leader
	name = "Survivor - Navalis - CLF Special Force: Unit Leader"
	assignment = "CLF Cell Leader"
	rank = JOB_CLF_LEADER
	role_comm_title = "LEAD."
	skills = /datum/skills/clf/leader

/datum/equipment_preset/survivor/navalis/clf_wet_ops/leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf/leader, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/clf, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/clf, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/clf(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/ld50_syringe/choral(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/book/codebook/wey_yu(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

	..()
