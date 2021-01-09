// UPP HvH Loadouts
//*****************************************************************************************************/
/datum/equipment_preset/upp/soldier/hvh
	name = "UPP Soldier HvH"

/datum/equipment_preset/upp/soldier/hvh/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/hvh, /obj/item/ammo_magazine/rifle/type71, H, 0, 12)

//*****************************************************************************************************/

/datum/equipment_preset/upp/soldier/cryo/hvh
	name = "UPP Cryo Soldier HvH"

/datum/equipment_preset/upp/soldier/cryo/hvh/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/upp/survivor/hvh
	name = "UPP Survivor HvH"

/datum/equipment_preset/upp/survivor/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/synth/hvh
	name = "UPP Combat Synthetic HvH"

/datum/equipment_preset/upp/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_upp)]"
	H.change_real_name(H, random_name)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/synth/load_race(mob/living/carbon/human/H)
	H.set_species("Synthetic")

/datum/equipment_preset/upp/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/hvh, WEAR_J_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/engineer/hvh
	name = "UPP Engineer HvH"

/datum/equipment_preset/upp/engineer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/hvh, /obj/item/ammo_magazine/rifle/type71, H, 0, 6)

//*****************************************************************************************************/

/datum/equipment_preset/upp/engineer/cryo/hvh
	name = "UPP Cryo Engineer HvH"

/datum/equipment_preset/upp/engineer/cryo/hvh/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/
/datum/equipment_preset/upp/medic/hvh
	name = "UPP Medic HvH"

/datum/equipment_preset/upp/medic/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/hvh, /obj/item/ammo_magazine/rifle/type71, H, 0, 6)

//*****************************************************************************************************/
/datum/equipment_preset/upp/medic/cryo/hvh
	name = "UPP Cryo Medic HvH"

/datum/equipment_preset/upp/medic/cryo/hvh/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/upp/specialist/hvh
	name = "UPP Specialist HvH"

/datum/equipment_preset/upp/specialist/hvh/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP/heavy, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/minigun/upp/hvh, /obj/item/ammo_magazine/minigun, H, 0, 5)

//*****************************************************************************************************/

/datum/equipment_preset/upp/specialist/cryo/hvh
	name = "UPP Cryo Specialist HvH"

/datum/equipment_preset/upp/specialist/cryo/hvh/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/upp/leader/hvh
	name = "UPP Leader HvH"

/datum/equipment_preset/upp/leader/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/flamer/hvh, /obj/item/ammo_magazine/rifle/type71, H, 0, 8)

//*****************************************************************************************************/

/datum/equipment_preset/upp/leader/cryo/hvh
	name = "UPP Cryo Leader HvH"

/datum/equipment_preset/upp/leader/cryo/hvh/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando/hvh
	name = "UPP Commando HvH"

/datum/equipment_preset/upp/commando/hvh/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando/hvh, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 8)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando/medic/hvh
	name = "UPP Commando Medic HvH"

/datum/equipment_preset/upp/commando/medic/hvh/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando/hvh, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 5)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando/leader/hvh
	name = "UPP Commando Leader HvH"

/datum/equipment_preset/upp/commando/leader/hvh/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando/hvh, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 7)
