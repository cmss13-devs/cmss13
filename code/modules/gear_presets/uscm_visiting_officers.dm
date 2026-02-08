/datum/equipment_preset/uscm_visitor
	name = "USCM Observer"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	assignment = JOB_USCM_OBSV
	job_title = JOB_USCM_OBSV
	role_comm_title = "USCM Obs"

/datum/equipment_preset/uscm_visitor/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_MAIN)

/datum/equipment_preset/uscm_visitor/co
	name = "USCM Observer (Major)"

	minimap_background = "background_medical_WO"
	minimap_icon = "co"
	var/hud_icon = "visit_co"
	idtype = /obj/item/card/id/gold
	paygrades = list(PAY_SHORT_MO4 = JOB_PLAYTIME_TIER_0)
	minimum_age = 30
	skills = /datum/skills/commander
	var/whitelist_level = WHITELIST_NORMAL

	var/list/equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
	)

	utility_under = list(/obj/item/clothing/under/marine, /obj/item/clothing/under/marine/officer/command, /obj/item/clothing/under/marine/officer/boiler)
	utility_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/cmcap/bridge, /obj/item/clothing/head/beret/cm/tan)
	utility_gloves = list(/obj/item/clothing/gloves/marine, /obj/item/clothing/gloves/marine/brown, /obj/item/clothing/gloves/marine/grey, /obj/item/clothing/gloves/marine/fingerless)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses, /obj/item/clothing/glasses/sunglasses/big, /obj/item/clothing/glasses/sunglasses/aviator, /obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/gray, /obj/item/clothing/under/marine/officer/formal/turtleneck)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/service, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/patchless)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black, /obj/item/clothing/head/marine/peaked/service)

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer, /obj/item/clothing/suit/storage/jacket/marine/dress)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

/datum/equipment_preset/uscm_visitor/co/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/uscm_visitor/co/load_race(mob/living/carbon/human/new_human, client/mob_client)
	..()
	ADD_TRAIT(new_human, TRAIT_EMOTE_CD_EXEMPT, TRAIT_SOURCE_JOB)

/datum/equipment_preset/uscm_visitor/co/load_gear(mob/living/carbon/human/new_human)
	var/sidearm = "Unica (camo comforting)"
	var/kit = null
	var/sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
	var/back_item = /obj/item/storage/backpack/satchel/lockable

	if(new_human.client && new_human.client.prefs)
		sidearm = new_human.client.prefs.commander_sidearm
		switch(sidearm)
			if(CO_GUN_MATEBA)
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
				kit = /obj/item/storage/mateba_case/captain
			if(CO_GUN_MATEBA_SPECIAL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/special
			if(CO_GUN_MATEBA_CLASSIC)
				sidearmpath = /obj/item/storage/belt/gun/mateba/full
				kit = /obj/item/storage/mateba_case/captain
			if(CO_GUN_2006M)
				sidearmpath = /obj/item/storage/belt/gun/mateba/mtr6m/full
			if(CO_GUN_DEAGLE)
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co
			if(CO_GUN_M1911C)
				sidearmpath = /obj/item/storage/belt/gun/m4a3/m1911/commander
			//Council variants
			if(CO_GUN_MATEBA_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/full
				kit = /obj/item/storage/mateba_case/captain/council
			if(CO_GUN_MATEBA_COUNCIL_GOLDEN)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/full_golden
				kit = /obj/item/storage/mateba_case/captain/council_gold
			if(CO_GUN_2006M_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/mtr6m/full
			if(CO_GUN_2006MB_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/mtr6m/full_black
			if(CO_GUN_2006MS_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/mtr6m/full_silver
			if(CO_GUN_DEAGLE_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co_golden
	switch(whitelist_level)
		if(WHITELIST_COUNCIL)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/council(new_human), WEAR_HEAD)
		if(WHITELIST_LEADER)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/councilchief(new_human), WEAR_HEAD)
	. = ..()


	for(var/equipment in equipment_to_spawn)
		var/equipment_path = islist(equipment_to_spawn[equipment]) ? pick(equipment_to_spawn[equipment]) : equipment_to_spawn[equipment]
		new_human.equip_to_slot_or_del(new equipment_path(new_human), equipment)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom/co(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new sidearmpath(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

	if(kit)
		new_human.equip_to_slot_or_del(new kit(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm_visitor/co/ltcol
	name = "USCM Observer (Lt. Col.)"
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm_visitor/co/col
	name = "USCM Observer (Colonel)"
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm_visitor/xo
	name = "USCM Junior Observer (Captain)"
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_USCM_OBSV_JNR
	job_title = JOB_USCM_OBSV_JNR
	role_comm_title = "USCM J-Obs"
	minimap_icon = "xo"

	minimum_age = 27
	skills = /datum/skills/XO

/datum/equipment_preset/uscm_visitor/xo/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_MAIN)
	access |= ACCESS_MARINE_DATABASE_ADMIN

/datum/equipment_preset/uscm_visitor/xo/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom/xo(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/marine/peaked/service(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm_visitor/honor_guard_lead
	name = "USCM Lead Honor Guard (Observer)"
	assignment = JOB_USCM_HG_SL
	job_title = JOB_USCM_HG_SL
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "USCM HG-L"
	skills = /datum/skills/honor_guard/vet
	idtype = /obj/item/card/id/silver

	minimap_icon = "vhg"
	minimap_background = "background_mp"

/datum/equipment_preset/uscm_visitor/honor_guard_lead/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel/sec
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/security

	//back
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/alt(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor/com(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/boiler(new_human), WEAR_BODY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/officer(new_human), WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm_visitor/honor_guard
	name = "USCM Honor Guard (Observer)"
	assignment = JOB_USCM_HG
	job_title = JOB_USCM_HG
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "USCM HG"
	skills = /datum/skills/honor_guard

	minimap_icon = "hg"
	minimap_background = "background_mp"

/datum/equipment_preset/uscm_visitor/honor_guard/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel/sec
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/security

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/boiler(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/officer(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/logisticsofficer(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm_visitor/sea
	name = "USCM Senior Enlisted Advisor (Observer)"
	idtype = /obj/item/card/id/silver
	assignment = JOB_USCM_SEA
	job_title = JOB_USCM_SEA
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "USCM SEA"
	minimum_age = 40
	skills = /datum/skills/SEA

	minimap_icon = "sea"
	minimap_background = "background_command"

	service_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/drillhat)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/uscm_visitor/sea/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/sea(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/drillhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flash(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/whistle(new_human), WEAR_R_HAND)

/datum/equipment_preset/uscm_visitor/sea/load_rank(mob/living/carbon/human/rankee, client/mob_client)
	mob_client?.toggle_newplayer_ic_hud(TRUE)
	if(rankee?.client?.prefs?.pref_special_job_options[JOB_SEA])
		var/paygrade_choice = get_paygrade_id_by_name(rankee.client.prefs.pref_special_job_options[JOB_SEA])
		return paygrade_choice
	..()
