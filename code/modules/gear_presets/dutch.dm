//Dutch's Dozens, pred hunter ERT, moved from fun file as they don't fit there to be honest.

/datum/equipment_preset/dutch
	name = JOB_DUTCH_RIFLEMAN
	paygrade = "DTC"
	assignment = JOB_DUTCH_RIFLEMAN
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_DUTCH

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/New()
	..()
	rank = assignment

/datum/equipment_preset/dutch/load_name(mob/living/carbon/human/H, randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_dutch)] [pick(last_names)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_dutch)] [pick(last_names)]"

	H.change_real_name(H, random_name)
	H.age = rand(25,35)
	H.r_hair = rand(10,30)
	H.g_hair = rand(10,30)
	H.b_hair = rand(20,50)
	H.r_eyes = rand(129,149)
	H.g_eyes = rand(52,72)
	H.b_eyes = rand(9,29)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/dutch/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,10)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	switch(choice)
		if(1 to 6) // 60%
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(H), WEAR_L_STORE)

		if(7 to 9) // 30%
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/grenadier/dutch(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large/dutch/full(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(H), WEAR_L_STORE)

		if(10) // 10%
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/m60(H), WEAR_J_STORE)//these preds gonna GET SOME!!!!!!!!!!!
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(H), WEAR_IN_JACKET)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m60(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m60(H), WEAR_L_STORE)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures, and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs. You have a very wide variety of skills, put them to use!"))

/datum/equipment_preset/dutch/minigun
	name = JOB_DUTCH_MINIGUNNER
	paygrade = "DTCMG"
	assignment = JOB_DUTCH_MINIGUNNER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/minigun/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/flamer
	name = JOB_DUTCH_FLAMETHROWER
	paygrade = "DTCF"
	assignment = JOB_DUTCH_FLAMETHROWER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/flamer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/fuelpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/M240T(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/medic
	name = JOB_DUTCH_MEDIC
	paygrade = "DTCM"
	assignment = JOB_DUTCH_MEDIC
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmedic

/datum/equipment_preset/dutch/medic/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact_adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a medic of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to help your team members hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/arnie
	name = "Dutch's Dozen - Arnold"
	paygrade = "ARN"
	assignment = JOB_DUTCH_ARNOLD
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutch
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	H.change_real_name(H, "Arnold 'Dutch' Schäfer")
	H.f_style = "5 O'clock Shadow"
	H.h_style = "Mulder"

	H.age = 38
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/empproof(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(H), WEAR_J_STORE) //he uses a grenadier m16 in the movie but too gear limited to add it so he gets the cool gun
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/arnold/full(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/dutch(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	H.set_species("Human Hero") //Arnold is STRONG.

	to_chat(H, SPAN_WARNING("You are Dutch, the leader of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your pouch have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))
