/datum/job/pmc
	special_role = "PMC"
	comm_title = "WY"
	faction = FACTION_PMC
	supervisors = "the team leader"
	idtype = /obj/item/card/id/centcom
	//flag = WY_PMC
	//department_flag = WY_PMC
	minimal_player_age = 0
	skills_type = /datum/skills/pfc

/datum/job/pmc/proc/generate_random_pmc_primary(shuffle = rand(1,20))
	var/L[] = list(
				WEAR_ACCESSORY = /obj/item/clothing/tie/storage/webbing,
				WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/quickclot,
				WEAR_IN_JACKET = /obj/item/explosive/grenade/HE/PMC
				)
	switch(shuffle)
		if(1 to 11)
			L += list(
					WEAR_J_STORE = /obj/item/weapon/gun/smg/m39/elite,
					WEAR_R_STORE = /obj/item/storage/pouch/magazine/large/pmc_m39,
					WEAR_IN_BACK = /obj/item/ammo_magazine/smg/m39/ap,
					WEAR_IN_BACK = /obj/item/ammo_magazine/smg/m39/ap,
					WEAR_IN_BACK = /obj/item/ammo_magazine/smg/m39/ap
					)
		if(12,15)
			L += list(
					WEAR_J_STORE = /obj/item/weapon/gun/smg/fp9000/pmc,
					WEAR_R_STORE = /obj/item/storage/pouch/magazine/large/pmc_p90,
					WEAR_IN_BACK = /obj/item/ammo_magazine/smg/fp9000,
					WEAR_IN_BACK = /obj/item/ammo_magazine/smg/fp9000
					)
		if(16,18)
			L += list(
					WEAR_J_STORE = /obj/item/weapon/gun/rifle/lmg,
					WEAR_R_STORE = /obj/item/storage/pouch/magazine/large/pmc_lmg,
					WEAR_IN_BACK = /obj/item/ammo_magazine/rifle/lmg,
					WEAR_IN_BACK = /obj/item/ammo_magazine/rifle/lmg
					)
		else
			L += list(
					WEAR_J_STORE = /obj/item/weapon/gun/revolver/mateba,
					WEAR_R_STORE = /obj/item/storage/pouch/magazine/pistol/pmc_mateba,
					WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/revolver/mateba,
					WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/revolver/mateba,
					WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/revolver/mateba
					)
	return L

//PMC standard.
/datum/job/pmc/security_expert
	title = JOB_PMC
	paygrade = "PMC1"
	total_positions = -1
	spawn_positions = -1
	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT

/datum/job/pmc/security_expert/generate_wearable_equipment()
	var/L[] = list(
					WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
					WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
					WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
					WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
					WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC
					)
	if(prob(65)) L[WEAR_FACE] = /obj/item/clothing/mask/gas/PMC
	if(prob(65)) L[WEAR_HEAD] = /obj/item/clothing/head/helmet/marine/veteran/PMC
	return L

/datum/job/pmc/security_expert/generate_stored_equipment()
	var/L[] = new
	if(prob(60))
		L[WEAR_WAIST] = /obj/item/weapon/gun/pistol/mod88
		L[WEAR_L_STORE] = /obj/item/storage/pouch/magazine/pistol/pmc_mod88
	else if(prob(35)) L[WEAR_WAIST] = /obj/item/storage/belt/knifepouch
	L[WEAR_IN_JACKET] = /obj/item/reagent_container/hypospray/autoinjector/quickclot
	L[WEAR_IN_JACKET] = /obj/item/explosive/grenade/HE/PMC
	return L

/datum/job/pmc/security_expert/equip(mob/living/carbon/human/H, L[] = generate_wearable_equipment() + generate_stored_equipment() + generate_random_pmc_primary())
	. = ..(H, L)

//PMC support engineer.
/datum/job/pmc/support_specialist_mechanic
	title = JOB_PMC_ENGINEER
	paygrade = "PMC2S"
	total_positions = 3
	spawn_positions = 3
	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/combat_engineer

/datum/job/pmc/support_specialist_mechanic/generate_wearable_equipment()
	var/L[] = list(
					WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
					WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
					WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
					WEAR_HANDS = /obj/item/clothing/gloves/yellow,
					SLOW_WAIST = /obj/item/storage/belt/utility/full,
					WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC,
					WEAR_EYES = /obj/item/clothing/glasses/welding,
					WEAR_BACK = /obj/item/storage/backpack/satchel/eng
					)
	if(prob(65)) L[WEAR_FACE] = /obj/item/clothing/mask/gas/PMC
	if(prob(65)) L[WEAR_HEAD] = /obj/item/clothing/head/helmet/marine/veteran/PMC
	return L

/datum/job/pmc/support_specialist_mechanic/generate_stored_equipment()
	. = list(
			WEAR_L_STORE = /obj/item/storage/pouch/explosive,
			WEAR_IN_BACK = /obj/item/explosive/plastique,
			WEAR_IN_BACK = /obj/item/stack/sheet/plasteel,
			WEAR_IN_BACK = /obj/item/explosive/grenade/HE/PMC,
			WEAR_IN_BACK = /obj/item/explosive/grenade/incendiary,
			WEAR_IN_BACK = /obj/item/stack/sheet/plasteel,
			WEAR_IN_BACK = /obj/item/tool/crowbar
			)

/datum/job/pmc/support_specialist_mechanic/equip(mob/living/carbon/human/H, L[] = generate_wearable_equipment() + generate_stored_equipment() + generate_random_pmc_primary())
	. = ..(H, L)

//PMC support medic.
/datum/job/pmc/support_specialist_triage
	title = JOB_PMC_DOCTOR
	paygrade = "PMC2M"
	total_positions = 3
	spawn_positions = 3
	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/combat_medic

/datum/job/pmc/support_specialist_triage/generate_wearable_equipment()
	var/L[] = list(
					WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
					WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
					WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
					WEAR_HANDS = /obj/item/clothing/gloves/latex,
					SLOW_WAIST = /obj/item/storage/belt/medical/combatLifesaver,
					WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC,
					WEAR_EYES = /obj/item/clothing/glasses/hud/health,
					WEAR_BACK = /obj/item/storage/backpack/satchel/med
					)
	if(prob(65)) L[WEAR_FACE] = /obj/item/clothing/mask/gas/PMC
	if(prob(65)) L[WEAR_HEAD] = /obj/item/clothing/head/helmet/marine/veteran/PMC
	return L

/datum/job/pmc/support_specialist_triage/generate_stored_equipment()
	. = list(
			WEAR_L_STORE = /obj/item/storage/pouch/medkit/full,
			WEAR_IN_BACK = /obj/item/reagent_container/hypospray/autoinjector/oxycodone,
			WEAR_IN_BACK = /obj/item/storage/firstaid/adv,
			WEAR_IN_BACK = /obj/item/device/defibrillator,
			WEAR_IN_BACK = /obj/item/bodybag,
			WEAR_IN_BACK = /obj/item/tool/crowbar,
			WEAR_IN_BACK = /obj/item/storage/pill_bottle/inaprovaline,
			WEAR_IN_BACK = /obj/item/storage/pill_bottle/tramadol
			)

/datum/job/pmc/support_specialist_triage/equip(mob/living/carbon/human/H, L[] = generate_wearable_equipment() + generate_stored_equipment() + generate_random_pmc_primary())
	. = ..(H, L)

//PMC elite/weapon specialist.
/datum/job/pmc/elite_responder
	title = JOB_PMC_ELITE
	paygrade = "PMC3"
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 7
	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_CORPORATE)

/datum/job/pmc/elite_responder/gunner
	title = JOB_PMC_GUNNER
	skills_type = /datum/skills/smartgunner/pmc

/datum/job/pmc/elite_responder/gunner/generate_wearable_equipment()
	. = list(
			WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
			WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
			WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
			WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
			WEAR_JACKET = /obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC,
			WEAR_FACE = /obj/item/clothing/mask/gas/PMC,
			WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/PMC/gunner,
			WEAR_BACK = /obj/item/smartgun_powerpack/snow,
			WEAR_EYES = /obj/item/clothing/glasses/night/m56_goggles
			)

/datum/job/pmc/elite_responder/gunner/generate_stored_equipment()
	. = list(
			SLOW_WAIST = /obj/item/storage/belt/gun/smartgunner/pmc/full,
			WEAR_J_STORE = /obj/item/weapon/gun/smartgun/dirty,
			WEAR_L_STORE = /obj/item/storage/pouch/magazine/pistol/pmc_mod88,
			WEAR_IN_BACK = /obj/item/explosive/plastique,
			WEAR_IN_BACK = /obj/item/tool/crowbar,
			WEAR_ACCESSORY = /obj/item/clothing/tie/storage/webbing,
			WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/phosphorus,
			WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/smokebomb,
			WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/pistol/mod88,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/quickclot,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/oxycodone
			)

/datum/job/pmc/elite_responder/sharpshooter
	title = JOB_PMC_SNIPER
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/specialist/pmc

/datum/job/pmc/elite_responder/sharpshooter/generate_wearable_equipment()
	. = list(
			WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
			WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
			WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
			WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
			WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper,
			WEAR_EYES = /obj/item/clothing/glasses/m42_goggles,
			WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper
			)

/datum/job/pmc/elite_responder/sharpshooter/generate_stored_equipment()
	. = list(
			SLOW_WAIST = /obj/item/weapon/gun/pistol/mod88,
			WEAR_J_STORE = /obj/item/weapon/gun/rifle/sniper/elite,
			WEAR_L_STORE = /obj/item/storage/pouch/magazine/large/pmc_sniper,
			WEAR_IN_BACK = /obj/item/device/flashlight,
			WEAR_ACCESSORY = /obj/item/clothing/tie/storage/black_vest,
			WEAR_IN_BACK = /obj/item/ammo_magazine/pistol/mod88,
			WEAR_IN_BACK = /obj/item/tool/crowbar,
			WEAR_IN_ACCESSORY = /obj/item/device/flashlight/flare,
			WEAR_IN_ACCESSORY = /obj/item/device/flashlight/flare,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/quickclot,
			WEAR_IN_JACKET = /obj/item/stack/medical/bruise_pack
			)

/datum/job/pmc/elite_responder/ninja
	title = JOB_PMC_NINJA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/ninja

/datum/job/pmc/elite_responder/ninja/generate_wearable_equipment()
	. = list(
			WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
			WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC,
			WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
			WEAR_WAIST = /obj/item/storage/belt/knifepouch,
			WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC,
			WEAR_BACK = /obj/item/weapon/katana
			)

/datum/job/pmc/elite_responder/ninja/generate_stored_equipment()	
	. = list(
			WEAR_IN_BACK = /obj/item/device/binoculars,
			WEAR_R_STORE = /obj/item/storage/pouch/magazine/large/pmc_rifle,
			WEAR_L_STORE = /obj/item/storage/pouch/general/large,
			WEAR_J_STORE = /obj/item/weapon/gun/rifle/m41a/elite,
			WEAR_ACCESSORY = /obj/item/clothing/tie/storage/black_vest,
			WEAR_IN_BACK = /obj/item/ammo_magazine/rifle/extended,
			WEAR_IN_BACK = /obj/item/tool/crowbar,
			WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/HE/PMC,
			WEAR_IN_ACCESSORY = /obj/item/device/flashlight,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/quickclot,
			WEAR_IN_JACKET = /obj/item/stack/medical/advanced/bruise_pack
			)

/datum/job/pmc/elite_responder/commando
	title = PMC_COMMANDO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/commando

/datum/job/pmc/elite_responder/commando/generate_wearable_equipment()
	. = list(
			WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
			WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC/commando,
			WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC/commando,
			WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC/commando,
			SLOW_WAIST = /obj/item/storage/belt/grenade/full,
			WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC/commando,
			WEAR_FACE = /obj/item/clothing/mask/gas/PMC,
			WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/PMC/commando,
			WEAR_BACK = /obj/item/storage/backpack/commando
			)

/datum/job/pmc/elite_responder/commando/generate_stored_equipment()
	. = list(
			WEAR_L_STORE = /obj/item/storage/pouch/bayonet/full,
			WEAR_IN_BACK = /obj/item/explosive/plastique,
			WEAR_IN_BACK = /obj/item/explosive/plastique,
			WEAR_IN_BACK = /obj/item/storage/firstaid/regular,
			WEAR_IN_BACK = /obj/item/device/flashlight,
			WEAR_IN_BACK = /obj/item/tool/crowbar
			)

/datum/job/pmc/elite_responder/commando/equip(mob/living/carbon/human/H, L[] = generate_wearable_equipment() + generate_stored_equipment() + generate_random_pmc_primary())
	. = ..(H, L)

//PMC team leader, the one in charge.
/datum/job/pmc/team_leader
	title = PMC_LEADER
	paygrade = "PMC4"
	supervisors = "the W-Y corporate office"
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 10
	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_PMC_WHITE, ACCESS_WY_CORPORATE)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	skills_type = /datum/skills/SL/pmc

/datum/job/pmc/team_leader/generate_wearable_equipment()
	. = list(
			WEAR_EAR = /obj/item/device/radio/headset/distress/PMC,
			WEAR_BODY = /obj/item/clothing/under/marine/veteran/PMC/leader,
			WEAR_FEET = /obj/item/clothing/shoes/veteran/PMC,
			WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
			WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/PMC/leader,
			WEAR_EYES = /obj/item/clothing/glasses/hud/health,
			WEAR_FACE = /obj/item/clothing/mask/gas/PMC/leader,
			WEAR_HEAD = /obj/item/clothing/head/helmet/marine/veteran/PMC/leader,
			WEAR_BACK = /obj/item/storage/backpack/satchel
			)

/datum/job/pmc/team_leader/generate_stored_equipment()
	. = list(
			SLOW_WAIST = /obj/item/weapon/gun/pistol/vp78,
			WEAR_J_STORE = /obj/item/weapon/gun/shotgun/combat,
			WEAR_IN_BACK = /obj/item/device/binoculars,
			WEAR_R_STORE = /obj/item/storage/pouch/magazine/pistol/pmc_vp78,
			WEAR_IN_BACK = /obj/item/ammo_magazine/shotgun/slugs,
			WEAR_IN_BACK = /obj/item/ammo_magazine/shotgun/buckshot,
			WEAR_IN_BACK = /obj/item/ammo_magazine/shotgun/incendiary,
			WEAR_IN_BACK = /obj/item/weapon/baton,
			WEAR_IN_BACK = /obj/item/device/flashlight,
			WEAR_IN_BACK = /obj/item/explosive/grenade/HE/PMC,
			WEAR_IN_BACK = /obj/item/tool/crowbar,
			WEAR_ACCESSORY = /obj/item/clothing/tie/storage/webbing,
			WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/pistol/mod88,
			WEAR_IN_ACCESSORY = /obj/item/ammo_magazine/pistol/mod88,
			WEAR_IN_ACCESSORY = /obj/item/explosive/grenade/smokebomb,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/quickclot,
			WEAR_IN_JACKET = /obj/item/reagent_container/hypospray/autoinjector/bicaridine
			)