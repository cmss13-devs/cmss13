//Dutch's Dozens, pred hunter ERT, moved from fun file as they don't fit there to be honest.

/datum/equipment_preset/dutch
	name = JOB_DUTCH_RIFLEMAN
	paygrades = list(PAY_SHORT_DTC = JOB_PLAYTIME_TIER_0)
	assignment = JOB_DUTCH_RIFLEMAN
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_DUTCH

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/New()
	..()
	rank = assignment

/datum/equipment_preset/dutch/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/human = new()
	human.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male_dutch)] [pick(GLOB.last_names)]"
		new_human.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(GLOB.first_names_female_dutch)] [pick(GLOB.last_names)]"

	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(25,35)
	new_human.r_hair = rand(10,30)
	new_human.g_hair = rand(10,30)
	new_human.b_hair = rand(20,50)
	new_human.r_eyes = rand(129,149)
	new_human.g_eyes = rand(52,72)
	new_human.b_eyes = rand(9,29)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/dutch/load_gear(mob/living/carbon/human/new_human)


	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)

	switch(rand(1, 10))
		if(1 to 6) // 60% for standard m16
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(new_human), WEAR_L_STORE)

		if(7 to 9) // 30% for m16 with m203
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/grenadier/dutch(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large/dutch/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(new_human), WEAR_L_STORE)

		if(10) // 10% for M60
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/m60(new_human), WEAR_J_STORE)//these preds gonna GET SOME!!!!!!!!!!!
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m60(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m60(new_human), WEAR_L_STORE)

	to_chat(new_human, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures, and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs. You have a very wide variety of skills, put them to use!"))

/datum/equipment_preset/dutch/minigun
	name = JOB_DUTCH_MINIGUNNER
	paygrades = list(PAY_SHORT_DTCMG = JOB_PLAYTIME_TIER_0)
	assignment = JOB_DUTCH_MINIGUNNER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/minigun/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)

	to_chat(new_human, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/flamer
	name = JOB_DUTCH_FLAMETHROWER
	paygrades = list(PAY_SHORT_DTCF = JOB_PLAYTIME_TIER_0)
	assignment = JOB_DUTCH_FLAMETHROWER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/dutch/flamer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/fuelpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/m240/spec(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)

	to_chat(new_human, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/medic
	name = JOB_DUTCH_MEDIC
	paygrades = list(PAY_SHORT_DTCM = JOB_PLAYTIME_TIER_0)
	assignment = JOB_DUTCH_MEDIC
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmedic

/datum/equipment_preset/dutch/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(new_human), WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact_adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/dutch(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)

	to_chat(new_human, SPAN_WARNING("You are a medic of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask on your leader's face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to help your team members hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/dutch/arnie
	name = "Dutch's Dozen - Arnold"
	paygrades = list(PAY_SHORT_DTCA = JOB_PLAYTIME_TIER_0)
	assignment = JOB_DUTCH_ARNOLD
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutch
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	new_human.change_real_name(new_human, "Arnold 'Dutch' Schäfer")
	new_human.f_style = "5 O'clock Shadow"
	new_human.h_style = "Mulder"

	new_human.age = 38
	new_human.r_hair = 15
	new_human.g_hair = 15
	new_human.b_hair = 25
	new_human.r_eyes = 139
	new_human.g_eyes = 62
	new_human.b_eyes = 19
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/dutch/arnie/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/empproof(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/xm177/dutch(new_human), WEAR_J_STORE) //he uses a grenadier m16 in the movie but too gear limited to add it so he gets the cool gun
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/arnold/full(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/dutch(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)

	new_human.set_species("Human Hero") //Arnold is STRONG.

	to_chat(new_human, SPAN_WARNING("You are Dutch, the leader of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your pouch have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))
