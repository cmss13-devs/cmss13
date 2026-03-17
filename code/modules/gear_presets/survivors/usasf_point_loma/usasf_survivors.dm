// **United States Aerospace Force Survivors**

/datum/equipment_preset/survivor/usasf //abstract
	name = "Survivor - USASF Enlisted"
	//job_title = JOB_SURVIVOR

	skills = /datum/skills/military/survivor/usasf
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag/usasf
	faction = FACTION_MARINE // ToDO: Figure out why tf this doesn't show mobhuds without this
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	origin_override = ORIGIN_USASF
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_1)
	job_title  = JOB_USASF_CREW
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

	flags = EQUIPMENT_PRESET_STUB
	minimap_icon = "surv"
	minimap_background = "background_ua"

	survivor_variant = CIVILIAN_SURVIVOR

	dress_gloves = list(/obj/item/clothing/gloves/marine/dress) //fail-safes
	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/survivor/usasf/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_usasf, WEAR_L_EAR)

/datum/equipment_preset/survivor/usasf/load_vanity(mob/living/carbon/human/new_human)
	..()

/datum/equipment_preset/survivor/usasf/crew
	name = "Survivor - USASF Enlisted Crew"
	flags = EQUIPMENT_PRESET_STUB // Fails tests without this idk why

/datum/equipment_preset/survivor/usasf/proc/spawn_food(mob/living/carbon/human/new_human)
	var/spawn_food = rand(1,3)
	switch(spawn_food)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr, WEAR_IN_JACKET)
		if (2)
			var/packaged_food = rand(1,3)
			switch(packaged_food)
				if (1)
					new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/packaged_burger, WEAR_IN_JACKET)
				if (2)
					new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/packaged_burrito, WEAR_IN_JACKET)
				if (3)
					new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/packaged_hdogs, WEAR_IN_JACKET)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/wrapped/barcardine, WEAR_IN_JACKET)

/datum/equipment_preset/survivor/usasf/proc/spawn_pouch(mob/living/carbon/human/new_human)
	var/spawn_pouch = rand(1,6)
	switch(spawn_pouch)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full/pills, WEAR_L_STORE)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full, WEAR_L_STORE)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet, WEAR_R_STORE)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_R_STORE)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/first_responder/full, WEAR_L_STORE)
		if (6)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

/datum/equipment_preset/survivor/usasf/proc/spawn_backpack(mob/living/carbon/human/new_human)
	var/spawn_backpack = rand(1,5)
	switch(spawn_backpack)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/chestrig, WEAR_BACK)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/tech, WEAR_BACK)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel, WEAR_BACK)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/stack/folding_barricade/three, WEAR_BACK)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/chestrig, WEAR_BACK)

/datum/equipment_preset/survivor/usasf/proc/spawn_armour(mob/living/carbon/human/new_human)
	var/spawn_armour = rand(1,5)
	switch(spawn_armour)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/rto/navy, WEAR_JACKET)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing, WEAR_JACKET)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/navy, WEAR_JACKET)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/navy/bomber, WEAR_JACKET)

/datum/equipment_preset/survivor/usasf/proc/spawn_fluff(mob/living/carbon/human/new_human)
	var/spawn_fluff_jacket = rand(1,6)
	var/spawn_fluff_backpack = rand(1,7)
	var/spawn_fluff_face = rand(1,10)
	switch(spawn_fluff_jacket)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/compass, WEAR_IN_JACKET)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/plinker, WEAR_IN_JACKET)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/trading_card, WEAR_IN_JACKET)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/toy/handcard/aceofspades, WEAR_IN_JACKET)
		if (5)
			new_human.equip_to_slot_or_del(new /datum/gear/toy/mags/magazine_dirty, WEAR_IN_JACKET)
		if (6)
			new_human.equip_to_slot_or_del(new /datum/gear/paperwork/notepad_blue, WEAR_IN_JACKET)
	switch(spawn_fluff_backpack)
		if (1)
			new_human.equip_to_slot_or_del (new /datum/gear/misc/pdt_kit, WEAR_IN_BACK)
		if (2)
			new_human.equip_to_slot_or_del (new /obj/item/reagent_container/food/drinks/flask, WEAR_IN_BACK)
		if (3)
			new_human.equip_to_slot_or_del (new /obj/item/reagent_container/food/drinks/cans/waterbottle, WEAR_IN_BACK)
		if (4)
			new_human.equip_to_slot_or_del (new /datum/gear/drink/cola, WEAR_IN_BACK)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/toy/deck/uno, WEAR_IN_BACK)
		if (6)
			new_human.equip_to_slot_or_del(new /obj/item/toy/deck, WEAR_IN_BACK)
		if (7)
			new_human.equip_to_slot_or_del(new /datum/gear/toy/camera/disposable, WEAR_IN_BACK)
	switch(spawn_fluff_face)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_FACE)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator, WEAR_FACE)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/tarbacks, WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigar/tarbacktube, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo, WEAR_R_HAND)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/ucigarette, WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo, WEAR_R_HAND)
		if (6)
			new_human.equip_to_slot_or_del(new /datum/gear/paperwork/pen, WEAR_R_EAR)
		//if (7 to 10) // Nothing happens, commented out on purpose

/datum/equipment_preset/survivor/usasf/proc/spawn_helmet(mob/living/carbon/human/new_human)
	var/spawn_helmet = rand(1,8)
	switch(spawn_helmet)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmbandana, WEAR_HEAD)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie, WEAR_HEAD)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband, WEAR_HEAD)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset, WEAR_HEAD)
		if (6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/flap, WEAR_HEAD)
		if (7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/marine/navy, WEAR_HEAD)
		if (8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/navy, WEAR_HEAD)

/datum/equipment_preset/survivor/usasf/proc/spawn_usasf_weapon(mob/living/carbon/human/new_human)
	var/spawn_usasf_weapon = rand(1,8)
	switch(spawn_usasf_weapon)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l54/full, WEAR_WAIST)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartpistol/full, WEAR_WAIST)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/full, WEAR_WAIST)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
		if (6)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911, WEAR_WAIST)
		if (7)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full, WEAR_WAIST)
		if (8)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m10/full, WEAR_WAIST)

/datum/equipment_preset/survivor/usasf/proc/spawn_security_primary(mob/living/carbon/human/new_human)
	var/spawn_security_primary = rand(1,3)
	switch(spawn_security_primary)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full, WEAR_WAIST)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/full, WEAR_WAIST)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_ACCESSORY)

/datum/equipment_preset/survivor/usasf/crew/load_gear(mob/living/carbon/human/new_human)
	..()
	var/duty = rand(1,10)
	var/shoes = rand(1,3)
	var/watch = rand(1,10)
	switch(duty)
		if(1 to 3) //off-duty
			var/offduty_outfit = rand(1,3) //1 number per outfit
			switch(offduty_outfit)
				if (1)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/frontier, WEAR_BODY)
				if (2)
					var/colour = rand (1,3)
					switch(colour)
						if (1)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue, WEAR_BODY)
						if (2)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown, WEAR_BODY)
						if (3)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray, WEAR_BODY)
				if (3)
					var/flavour = rand(1,3)
					switch(flavour)
						if (1)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br, WEAR_BODY)
						if (2)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
						if(3)
							new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla, WEAR_BODY)
		if (4 to 10) //on-duty
			var/onduty_outfit = rand(1,1) // left as switch just in case it's desired
			switch(onduty_outfit)
				if (1)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/navy, WEAR_BODY)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/usasf, WEAR_ACCESSORY)
	switch(shoes)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal, WEAR_FEET)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET) //ToDO: USASF Boots
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black, WEAR_FEET)
	switch(watch)
		if (1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/wrist/watch, WEAR_ACCESSORY)
		//if (3 to 10) - nothing happens, commented out on purpose


/datum/equipment_preset/survivor/usasf/crew/duty
	name = "Survivor - USASF Ground Crew"
	job_title  = JOB_USASF_CREW
	assignment = JOB_USASF_CREW
	survivor_variant = CIVILIAN_SURVIVOR
	paygrades = list(PAY_SHORT_NE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE2 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "survivor"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/duty/load_gear(mob/living/carbon/human/new_human)
	..()
	spawn_helmet(new_human)
	spawn_armour(new_human)
	spawn_backpack(new_human)
	spawn_fluff(new_human)
	spawn_pouch(new_human)
	spawn_food(new_human)
	spawn_usasf_weapon(new_human)

/datum/equipment_preset/survivor/usasf/crew/duty/chaplain
	name = "Survivor - USASF Chaplain"
	job_title = JOB_USASF_CHAPLAIN
	assignment = JOB_USASF_CHAPLAIN
	survivor_variant = CIVILIAN_SURVIVOR
	paygrades = list(PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO4 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "rmc_rifleman" // ToDO: Change
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/duty/chaplain/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/priest_robe, WEAR_JACKET)
	..()

/datum/equipment_preset/survivor/usasf/crew/duty/hangar_tech
	name = "Survivor - USASF Hangar Technician"
	job_title  = JOB_USASF_HANGARTECH
	assignment = JOB_USASF_HANGARTECH
	skills = /datum/skills/military/survivor/usasf/technician
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "mt"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/duty/hangar_tech/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)

/datum/equipment_preset/survivor/usasf/crew/duty/cargo_tech
	name = "Survivor - USASF Cargo Technician"
	job_title = JOB_USASF_CARGOTECH
	assignment = JOB_USASF_CARGOTECH
	survivor_variant = ENGINEERING_SURVIVOR
	skills = /datum/skills/military/survivor/usasf/technician
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "cargo"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/duty/cargo_tech/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)

/datum/equipment_preset/survivor/usasf/crew/medical //abstract
	name = "Survivor - USASF Medical Staff"
	skills = /datum/skills/military/survivor/usasf/medical // both nurse and doctor are surgery capable
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
	)

	survivor_variant = MEDICAL_SURVIVOR
	flags = EQUIPMENT_PRESET_STUB

/datum/equipment_preset/survivor/usasf/crew/medical/nurse
	name = "Survivor - USASF Nurse"
	job_title = JOB_USASF_NURSE
	assignment = JOB_USASF_NURSE
	paygrades = list(PAY_SHORT_NO1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "nurse"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/medical/nurse/load_gear(mob/living/carbon/human/new_human)
	..()
	spawn_helmet(new_human)
	spawn_armour(new_human)
	spawn_backpack(new_human)
	spawn_fluff(new_human)
	spawn_pouch(new_human)
	spawn_food(new_human)
	spawn_usasf_weapon(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_L_HAND)

/datum/equipment_preset/survivor/usasf/crew/medical/doctor
	name = "Survivor - USASF Doctor"
	job_title = JOB_USASF_DOCTOR
	assignment = JOB_USASF_DOCTOR
	paygrades = list(PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "doctor"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/medical/doctor/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del (new /obj/item/clothing/suit/chef/classic/medical, WEAR_BODY)
	new_human.equip_to_slot_or_del (new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_L_HAND)

/datum/equipment_preset/survivor/usasf/crew/security
	name = "Survivor - USASF Security Police"
	job_title = JOB_USASF_SECURITY_DEFENDER
	assignment = JOB_USASF_SECURITY_DEFENDER
	skills = /datum/skills/military/survivor/usasf/security
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE) // needed to communicate with alpha-tech staff
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_COMMAND,
	)

	survivor_variant = SECURITY_SURVIVOR
	minimap_icon = "mp"
	minimap_background = "background_ua"


/datum/equipment_preset/survivor/usasf/crew/security/load_gear(mob/living/carbon/human/new_human)
	..()
	var/obj/item/clothing/under/marine/navy/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/special/brassard/patch_SP = new()
	var/obj/item/clothing/accessory/patch/usasf/patch_usasf = new()
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	uniform.attach_accessory(new_human,patch_usasf)
	uniform.attach_accessory(new_human,patch_SP)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/navy, WEAR_HEAD)
	spawn_security_primary(new_human)
	spawn_armour(new_human)
	spawn_backpack(new_human)
	spawn_fluff(new_human)
	spawn_pouch(new_human)
	spawn_food(new_human)

/datum/equipment_preset/survivor/usasf/crew/officer
	name = "Survivor - USASF Officer"
	job_title = JOB_USASF_OFFICER
	assignment = JOB_USASF_OFFICER
	skills = /datum/skills/military/survivor/usasf/officer
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE) // needed to communicate with alpha-tech staff
	idtype = /obj/item/card/id/gold/usasf
	paygrades = list(PAY_SHORT_NO1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_1)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

	minimap_icon = "so"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/officer/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/navy, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/MP/SO, WEAR_HEAD)
	spawn_security_primary(new_human)
	spawn_armour(new_human)
	spawn_backpack(new_human)
	spawn_fluff(new_human)
	spawn_pouch(new_human)
	spawn_food(new_human)

/datum/equipment_preset/survivor/usasf/crew/officer/pilot
	name = "Survivor - USASF Pilot"
	job_title = JOB_USASF_PILOT
	assignment = JOB_USASF_PILOT
	skills = /datum/skills/military/survivor/usasf/pilot
	paygrades = list(PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "pilot"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/officer/pilot/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot/novisor, WEAR_HEAD)

/datum/equipment_preset/survivor/usasf/crew/officer/co
	name = "Survivor - USASF Aerospace Base Commander"
	job_title = JOB_USASF_CO
	assignment = JOB_USASF_CO
	skills = /datum/skills/commander
	paygrades = list(PAY_SHORT_NO5 = JOB_PLAYTIME_TIER_0) // Major equivalent
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "co"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/usasf/crew/officer/co/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del (new /obj/item/storage/pouch/pistol/command, WEAR_L_STORE)
	new_human.equip_to_slot_or_del (new /obj/item/device/binoculars/range/designator, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/mtr6m/full, WEAR_WAIST)

/datum/equipment_preset/synth/usasf // only thing that needs to be parented to something else
	name = "Survivor - USASF Synthetic"
	paygrades = list(PAY_SHORT_NE7 = JOB_PLAYTIME_TIER_0)
	faction = FACTION_MARINE // ToDO: Figure out why tf this doesn't show mobhuds without this
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	assignment = JOB_USASF_SYNTHETIC
	job_title  = JOB_USASF_SYNTHETIC
	idtype = /obj/item/card/id/gold
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	minimap_icon = "synth"
	minimap_background = "background_ua"

/datum/equipment_preset/synth/usasf/load_gear(mob/living/carbon/human/preset_human)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/navy, WEAR_BODY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/ranks/navy/e7, WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/usasf, WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/chestrig(preset_human), WEAR_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest(preset_human), WEAR_JACKET)
	preset_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(preset_human), WEAR_IN_JACKET)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(preset_human), WEAR_WAIST)
	preset_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic(preset_human), WEAR_IN_JACKET)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(preset_human), WEAR_IN_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(preset_human), WEAR_IN_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/black/full(preset_human), WEAR_R_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/sling(preset_human), WEAR_L_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(preset_human), WEAR_IN_L_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_usasf(preset_human), WEAR_L_EAR)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(preset_human), WEAR_FEET)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/navy(preset_human), WEAR_HEAD)
