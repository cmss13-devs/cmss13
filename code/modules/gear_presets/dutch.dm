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

/datum/equipment_preset/dutch/load_name(mob/living/carbon/human/NEW_HUMAN, randomise)
	NEW_HUMAN.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/HUMAN = new()
	HUMAN.randomize_appearance(NEW_HUMAN)
	var/random_name
	if(NEW_HUMAN.gender == MALE)
		random_name = "[pick(first_names_male_dutch)] [pick(last_names)]"
		NEW_HUMAN.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_dutch)] [pick(last_names)]"

	NEW_HUMAN.change_real_name(NEW_HUMAN, random_name)
	NEW_HUMAN.age = rand(25,35)
	NEW_HUMAN.r_hair = rand(10,30)
	NEW_HUMAN.g_hair = rand(10,30)
	NEW_HUMAN.b_hair = rand(20,50)
	NEW_HUMAN.r_eyes = rand(129,149)
	NEW_HUMAN.g_eyes = rand(52,72)
	NEW_HUMAN.b_eyes = rand(9,29)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/dutch/load_gear(mob/living/carbon/human/NEW_HUMAN)


	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(NEW_HUMAN), WEAR_HEAD)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(NEW_HUMAN), WEAR_L_EAR)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(NEW_HUMAN), WEAR_BODY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(NEW_HUMAN), WEAR_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(NEW_HUMAN), WEAR_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(NEW_HUMAN), WEAR_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(NEW_HUMAN), WEAR_HANDS)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(NEW_HUMAN), WEAR_R_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(NEW_HUMAN), WEAR_FEET)

	switch(rand(1, 10))
		if(1 to 6) // 60% for standard m16
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(NEW_HUMAN), WEAR_J_STORE)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(NEW_HUMAN), WEAR_WAIST)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(NEW_HUMAN), WEAR_L_STORE)

		if(7 to 9) // 30% for m16 with m203
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/grenadier/dutch(NEW_HUMAN), WEAR_J_STORE)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large/dutch/full(NEW_HUMAN), WEAR_WAIST)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(NEW_HUMAN), WEAR_L_STORE)

		if(10) // 10% for M60
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/m60(NEW_HUMAN), WEAR_J_STORE)//these preds gonna GET SOME!!!!!!!!!!!
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(NEW_HUMAN), WEAR_IN_JACKET)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m60(NEW_HUMAN), WEAR_WAIST)
			NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m60(NEW_HUMAN), WEAR_L_STORE)

	to_chat(NEW_HUMAN, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures, and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs. You have a very wide variety of skills, put them to use!"))

/datum/equipment_preset/dutch/minigun
	name = JOB_DUTCH_MINIGUNNER
	paygrade = "DTCMG"
	assignment = JOB_DUTCH_MINIGUNNER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/minigun/load_gear(mob/living/carbon/human/NEW_HUMAN)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(NEW_HUMAN), WEAR_HEAD)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(NEW_HUMAN), WEAR_L_EAR)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(NEW_HUMAN), WEAR_BODY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(NEW_HUMAN), WEAR_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(NEW_HUMAN), WEAR_J_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(NEW_HUMAN), WEAR_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(NEW_HUMAN), WEAR_WAIST)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(NEW_HUMAN), WEAR_HANDS)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(NEW_HUMAN), WEAR_R_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(NEW_HUMAN), WEAR_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(NEW_HUMAN), WEAR_FEET)

	to_chat(NEW_HUMAN, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/flamer
	name = JOB_DUTCH_FLAMETHROWER
	paygrade = "DTCF"
	assignment = JOB_DUTCH_FLAMETHROWER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/flamer/load_gear(mob/living/carbon/human/NEW_HUMAN)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(NEW_HUMAN), WEAR_BODY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(NEW_HUMAN), WEAR_HEAD)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(NEW_HUMAN), WEAR_L_EAR)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(NEW_HUMAN), WEAR_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch, WEAR_J_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(NEW_HUMAN), WEAR_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(NEW_HUMAN), WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/large_holster/fuelpack(NEW_HUMAN), WEAR_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/M240T(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(NEW_HUMAN), WEAR_WAIST)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(NEW_HUMAN), WEAR_HANDS)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(NEW_HUMAN), WEAR_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(NEW_HUMAN), WEAR_IN_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(NEW_HUMAN), WEAR_IN_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(NEW_HUMAN), WEAR_R_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(NEW_HUMAN), WEAR_FEET)

	to_chat(NEW_HUMAN, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/medic
	name = JOB_DUTCH_MEDIC
	paygrade = "DTCM"
	assignment = JOB_DUTCH_MEDIC
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmedic

/datum/equipment_preset/dutch/medic/load_gear(mob/living/carbon/human/NEW_HUMAN)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(NEW_HUMAN), WEAR_HEAD)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(NEW_HUMAN), WEAR_IN_HELMET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(NEW_HUMAN), WEAR_L_EAR)
	if(NEW_HUMAN.disabilities & NEARSIGHTED)
		NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(NEW_HUMAN), WEAR_EYES)
	else
		NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(NEW_HUMAN), WEAR_EYES)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(NEW_HUMAN), WEAR_BODY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(NEW_HUMAN), WEAR_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(NEW_HUMAN), WEAR_J_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(NEW_HUMAN), WEAR_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact_adv(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(NEW_HUMAN), WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch(NEW_HUMAN), WEAR_WAIST)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(NEW_HUMAN), WEAR_HANDS)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(NEW_HUMAN), WEAR_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(NEW_HUMAN), WEAR_R_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(NEW_HUMAN), WEAR_FEET)

	to_chat(NEW_HUMAN, SPAN_WARNING("You are a medic of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to help your team members hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/arnie
	name = "Dutch's Dozen - Arnold"
	paygrade = "ARN"
	assignment = JOB_DUTCH_ARNOLD
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutch
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_name(mob/living/carbon/human/NEW_HUMAN, randomise)
	NEW_HUMAN.gender = MALE
	NEW_HUMAN.change_real_name(NEW_HUMAN, "Arnold 'Dutch' Schäfer")
	NEW_HUMAN.f_style = "5 O'clock Shadow"
	NEW_HUMAN.h_style = "Mulder"

	NEW_HUMAN.age = 38
	NEW_HUMAN.r_hair = 15
	NEW_HUMAN.g_hair = 15
	NEW_HUMAN.b_hair = 25
	NEW_HUMAN.r_eyes = 139
	NEW_HUMAN.g_eyes = 62
	NEW_HUMAN.b_eyes = 19
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_gear(mob/living/carbon/human/NEW_HUMAN)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(NEW_HUMAN), WEAR_HEAD)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(NEW_HUMAN), WEAR_L_EAR)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/empproof(NEW_HUMAN), WEAR_EYES)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter(NEW_HUMAN), WEAR_FACE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(NEW_HUMAN), WEAR_BODY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(NEW_HUMAN), WEAR_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(NEW_HUMAN), WEAR_J_STORE) //he uses a grenadier m16 in the movie but too gear limited to add it so he gets the cool gun
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(NEW_HUMAN), WEAR_IN_JACKET)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/arnold/full(NEW_HUMAN), WEAR_BACK)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(NEW_HUMAN), WEAR_WAIST)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(NEW_HUMAN), WEAR_HANDS)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(NEW_HUMAN), WEAR_L_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/dutch(NEW_HUMAN), WEAR_R_STORE)
	NEW_HUMAN.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(NEW_HUMAN), WEAR_FEET)

	NEW_HUMAN.set_species("Human Hero") //Arnold is STRONG.

	to_chat(NEW_HUMAN, SPAN_WARNING("You are Dutch, the leader of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your pouch have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))
