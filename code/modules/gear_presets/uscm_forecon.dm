/datum/equipment_preset/uscm/forecon
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "FORECON"
	rank = JOB_MARINE
	faction_group = list(FACTION_MARINE)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	auto_squad_name = SQUAD_FORECON
	ert_squad = TRUE

/datum/equipment_preset/uscm/forecon/New()
	. = ..()
	access = get_access(ACCESS_LIST_UA)

	dress_shoes = list(/obj/item/clothing/shoes/dress)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/uscm/forecon/proc/add_forecon_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,3)
	switch(random_gun)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/tactical(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra/tactical(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/ext(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/ext(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/ap(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/ap(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm/forecon/proc/spawn_random_headgear(mob/living/carbon/human/new_human)
	var/i = rand(1,10)
	switch(i)
		if (1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
		if (3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie(new_human), WEAR_HEAD)
		if (5 , 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/durag(new_human), WEAR_HEAD)
		if (7 , 8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie(new_human), WEAR_HEAD)
		if (9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)

/datum/equipment_preset/uscm/forecon/proc/spawn_random_tech_headgear(mob/living/carbon/human/new_human)
	var/i = rand(1,4)
	switch(i)
		if (1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
		if (3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic/white(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)

/datum/equipment_preset/uscm/forecon/proc/add_forecon_weapon_pistol(mob/living/carbon/human/new_human)
	var/random_pistol = rand(1,5)
	switch(random_pistol)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
		if(3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(new_human), WEAR_IN_BELT)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human),WEAR_WAIST)

/datum/equipment_preset/uscm/forecon/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/forecon/standard
	name = "USCM Reconnaissance Marine"
	assignment = JOB_FORECON_RIFLEMAN
	rank = JOB_SQUAD_MARINE
	role_comm_title = "RFN"
	minimap_icon = ""
	skills = /datum/skills/military/survivor/forecon_standard

/datum/equipment_preset/uscm/forecon/standard/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/recon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon(new_human), WEAR_L_EAR)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)

/datum/equipment_preset/uscm/forecon/standard/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	spawn_random_headgear(new_human)
	add_forecon_weapon_pistol(new_human)
	add_forecon_weapon(new_human)

/datum/equipment_preset/uscm/forecon/tech
	name = "USCM Reconnaissance Support Technician"
	assignment = JOB_FORECON_SUPPORT
	rank = JOB_SQUAD_TECH
	role_comm_title = "SuppTech"
	minimap_icon = "engi"
	skills = /datum/skills/military/survivor/forecon_techician

/datum/equipment_preset/uscm/forecon/tech/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/forecon(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool , WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/recon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon(new_human), WEAR_L_EAR)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)

	add_forecon_weapon(new_human)
	spawn_random_tech_headgear(new_human)

/datum/equipment_preset/uscm/forecon/marksman
	name = "USCM Reconnaissance Designated Marksman"
	assignment = JOB_FORECON_MARKSMAN
	rank = JOB_SQUAD_SPECIALIST
	role_comm_title = "DMR"
	minimap_icon = "spec"
	skills = /datum/skills/military/survivor/forecon_marksman

/datum/equipment_preset/uscm/forecon/marksman/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3S, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra_custom/tactical(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom/impact(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom/incendiary(new_human), WEAR_IN_BACK)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)
	..()
	add_forecon_weapon_pistol(new_human)
	spawn_random_headgear(new_human)

/datum/equipment_preset/uscm/forecon/smartgunner
	name = "USCM Reconnaissance Smartgunner"
	assignment = JOB_FORECON_SMARTGUNNER
	rank = JOB_SQUAD_SMARTGUN
	role_comm_title = "SG"
	minimap_icon = "smartgunner"
	skills = /datum/skills/military/survivor/forecon_smartgunner

/datum/equipment_preset/uscm/forecon/smartgunner/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)
	spawn_random_headgear(new_human)

/datum/equipment_preset/uscm/forecon/squad_leader
	name = "USCM Reconnaissance Squad Leader"
	assignment = JOB_FORECON_SL
	rank = JOB_SQUAD_LEADER
	role_comm_title = "SL"
	skills = /datum/skills/military/survivor/forecon_squad_leader
	paygrades = list(PAY_SHORT_MO1 = JOB_PLAYTIME_TIER_0)

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)

/datum/equipment_preset/uscm/forecon/squad_leader/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/o1/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)

	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/recon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon(new_human), WEAR_L_EAR)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)



	..()
	add_forecon_weapon_pistol(new_human)
	spawn_random_headgear(new_human)
