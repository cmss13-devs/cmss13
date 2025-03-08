/datum/equipment_preset/uscm/cbrn
	name = "Generic CBRN" //Parent type for easier gear
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CBRN"
	flags = EQUIPMENT_PRESET_EXTRA
	auto_squad_name = SQUAD_CBRN
	ert_squad = TRUE
	skills = /datum/skills/pmc //More trained than the average rifleman

/datum/equipment_preset/uscm/cbrn/New()
	. = ..()
	access = get_access(ACCESS_LIST_UA)

/datum/equipment_preset/uscm/cbrn/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/cbrn/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cbrn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/cbrn(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/cbrn(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_JACKET)

/datum/equipment_preset/uscm/cbrn/standard
	name = "CBRN Rifleman"
	role_comm_title = "RFN"

/datum/equipment_preset/uscm/cbrn/standard/load_gear(mob/living/carbon/human/new_human)
	. = ..()

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/five_slots(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(new_human), WEAR_IN_JACKET)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full/toxin(new_human), WEAR_L_STORE)

	switch(pick("flamethrower", "mk2"))
		if("flamethrower")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/underextinguisher(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_ACCESSORY)

		if("mk2")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/device/analyzer(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/reagent_scanner(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/prop/geiger_counter(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm/cbrn/engineer
	name = "CBRN Combat Technician"
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	role_comm_title = "ComTech"
	minimap_icon = "engi"
	skills = /datum/skills/pmc/engineer

/datum/equipment_preset/uscm/cbrn/engineer/load_gear(mob/living/carbon/human/new_human)
	. = ..()

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge(new_human), WEAR_IN_JACKET)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior(new_human), WEAR_EYES)

	switch(pick("flamethrower", "mk2"))
		if("flamethrower")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/underextinguisher(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_BACK)

		if("mk2")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/device/analyzer(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/reagent_scanner(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/prop/geiger_counter(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/cleaner(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bodybag(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm/cbrn/medic
	name = "CBRN Hospital Corpsman"
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	role_comm_title = "HM"
	minimap_icon = "medic"
	skills = /datum/skills/pmc/medic

/datum/equipment_preset/uscm/cbrn/medic/load_gear(mob/living/carbon/human/new_human)
	. = ..()

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/five_slots(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/medic(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full/toxin(new_human), WEAR_R_STORE)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/synth(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/rad(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/o2(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/toxin(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/toxin(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/russianRed(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/russianRed(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/russianRed(new_human), WEAR_IN_BELT)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(new_human), WEAR_IN_ACCESSORY)

/datum/equipment_preset/uscm/cbrn/leader
	name = "CBRN Fireteam Leader"
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_SQUAD_TEAM_LEADER
	rank = JOB_SQUAD_TEAM_LEADER
	role_comm_title = "TL"
	minimap_icon = "tl"
	skills = /datum/skills/pmc/SL

/datum/equipment_preset/uscm/cbrn/leader/load_gear(mob/living/carbon/human/new_human)
	. = ..()

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/underextinguisher(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/five_slots(new_human), WEAR_ACCESSORY)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(new_human), WEAR_IN_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(new_human), WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_JACKET)

/datum/equipment_preset/uscm/cbrn/specialist
	name = "CBRN Specialist"
	paygrades = list(PAY_SHORT_OPR = JOB_PLAYTIME_TIER_0)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	role_comm_title = "Spc"
	minimap_icon = "spec"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_TSL)
	skills = /datum/skills/commando/deathsquad

/datum/equipment_preset/uscm/cbrn/specialist/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/uscm/cbrn/specialist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cbrn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/cbrn/advanced(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/cbrn/advanced(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/five_slots(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/fuelpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/M240T(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(new_human), WEAR_IN_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/incendiary(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/incendiary(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bottle/labeled_black_goo_cure(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bottle/labeled_black_goo_cure(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/syringes(new_human), WEAR_IN_BELT)

/datum/equipment_preset/uscm/cbrn/specialist/lead //Same gear, better title
	name = "CBRN Specialist SL"
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	role_comm_title = "Spc SL"
	skills = /datum/skills/commando/deathsquad/leader
