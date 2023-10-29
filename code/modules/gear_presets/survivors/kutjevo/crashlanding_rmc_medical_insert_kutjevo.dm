/datum/equipment_preset/survivor/rmc
	name = "Survivor - TWE Royal Marine Commando"
	paygrade = "RMC E1"
	assignment = JOB_TWE_RMC_RIFLEMAN
	rank = JOB_TWE_RMC_RIFLEMAN
	skills = /datum/skills/military/survivor/rmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_TWE
	faction_group = list(FACTION_TWE, FACTION_USCM, FACTION_SURVIVOR)
	role_comm_title = "RMC"
	idtype = /obj/item/card/id/dogtag
	flags = EQUIPMENT_PRESET_EXTRA
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)

/datum/equipment_preset/survivor/rmc/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			royal_marine.roll_suit_jacket(new_human)
		if(2)
			royal_marine.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/royal_marine(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/royal_marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l905/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare(new_human), WEAR_R_STORE)
	spawn_random_rmc_headgear(new_human)

	..()

/datum/equipment_preset/survivor/rmc/specialist
	name = "Survivor - TWE Royal Marine Commando Breacher"
	assignment = JOB_TWE_RMC_BREACHER
	rank = JOB_TWE_RMC_BREACHER
	paygrade = "RMC E2"
	role_comm_title = "RMC SPC"
	skills = /datum/skills/military/survivor/rmc/specialist

/datum/equipment_preset/survivor/rmc/specialist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine/breacher(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/pointman(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/shotgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt/rmc(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot/ballistic(new_human), WEAR_BACK)

	..()

/datum/equipment_preset/survivor/rmc/team_leader
	name = "Survivor - TWE Royal Marine Commando Team Leader"
	paygrade = "RMC E4"
	role_comm_title = "RMC TL"
	assignment = JOB_TWE_RMC_TEAMLEADER
	rank = JOB_TWE_RMC_TEAMLEADER
	skills = /datum/skills/military/survivor/rmc/leader

/datum/equipment_preset/survivor/rmc/team_leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine/team_leader(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/tl(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/team_leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/a_grip(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l905/full(new_human), WEAR_WAIST)

	..()

/datum/equipment_preset/synth/survivor/rmc
	name = "Survivor - Synthetic - TWE Royal Marine Commando Synth"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_SYNTH_LANGUAGES
	assignment = "Royal Marines Support Synthetic"
	rank = JOB_SYNTH_SURVIVOR
	faction = FACTION_TWE
	faction_group = list(FACTION_TWE, FACTION_USCM, FACTION_SURVIVOR)
	skills = /datum/skills/colonial_synthetic
	paygrade = "SYN"
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "RMC Syn"

/datum/equipment_preset/synth/survivor/upp/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			royal_marine.roll_suit_jacket(new_human)
		if(2)
			royal_marine.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/royal_marine, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/medium, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/small_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/partial, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/royal_marine/knife, WEAR_FEET)
