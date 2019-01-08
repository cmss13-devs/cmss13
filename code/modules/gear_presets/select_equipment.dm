
/datum/equipment_preset
	var/name = "Preset"
	var/flags = EQUIPMENT_PRESET_STUB
	var/uses_special_name = FALSE //For equipment that loads special name, aka Synths, Yautja, Death Squad, etc.

	var/list/languages = list("English")
	var/skills
	var/idtype = /obj/item/card/id
	var/list/access = list()
	var/assignment
	var/rank
	var/paygrade
	var/role_comm_title
	var/special_role

	//load_appearance()
/datum/equipment_preset/proc/load_race(mob/living/carbon/human/H)
/datum/equipment_preset/proc/load_name(mob/living/carbon/human/H, var/randomise)
/datum/equipment_preset/proc/load_gear(mob/living/carbon/human/H)
/datum/equipment_preset/proc/load_status(mob/living/carbon/human/H)

/datum/equipment_preset/proc/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(skills)

/datum/equipment_preset/proc/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new idtype()
	W.name = "[H.real_name]'s ID Card"
	if(assignment)
		W.name += " ([assignment])"
	W.access = access.Copy(1, 0)
	W.assignment = assignment
	W.rank = rank
	W.registered_name = H.real_name
	W.paygrade = paygrade
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = role_comm_title
		H.mind.assigned_role = W.rank
		H.mind.special_role = special_role
		if(H.mind.initial_account)
			W.associated_account_number = H.mind.initial_account.account_number

/datum/equipment_preset/proc/load_languages(mob/living/carbon/human/H)
	H.set_languages(languages)

/datum/equipment_preset/proc/load_preset(mob/living/carbon/human/H, var/randomise = FALSE)
	load_race(H)
	if(randomise || uses_special_name)
		load_name(H, randomise)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_gear(H)
	load_id(H)
	load_status(H)
	load_vanity(H)

/datum/equipment_preset/proc/load_vanity(mob/living/carbon/human/H)
	if(!H.client || !H.client.prefs || !H.client.prefs.gear)
		return//We want to equip them with custom stuff second, after they are equipped with everything else.
	var/datum/gear/G
	var/i
	for(i in H.client.prefs.gear)
		G = gear_datums[i]
		if(G)
			if(!H.equip_to_slot_or_del(new G.path(H), G.slot))
				H.equip_to_slot_or_del(new G.path(H), WEAR_IN_BACK)

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/obj/item/clothing/glasses/regular/P = new (H)
		P.prescription = 1
		H.equip_to_slot_or_del(P, WEAR_EYES)

/datum/equipment_preset/strip
	name = "*strip*"

/datum/equipment_preset/proc/spawn_rebel_gun(var/atom/M, var/sidearm = 0)
	if(!M) return
	var/atom/spawnloc = M

	var/list/rebel_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/automatic,
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/skorpion/upp = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/pistol/c99 = /obj/item/ammo_magazine/pistol/c99,
		/obj/item/weapon/gun/pistol/vp70 = /obj/item/ammo_magazine/pistol/vp70
		)


	//no guns in sidearms list, we don't want players spawning with a gun in hand.
	var/list/rebel_sidearms = list(
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/katana/full = null,
		/obj/item/storage/large_holster/machete/full = null,
		/obj/item/weapon/combat_knife = null,
		/obj/item/explosive/grenade/HE/stick = null,
		/obj/item/explosive/grenade/HE/stick = null,
		/obj/item/explosive/grenade/HE/stick = null,
		/obj/item/weapon/combat_knife/upp = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/clothing/tie/storage/webbing = null,
		/obj/item/clothing/tie/storage/webbing = null,
		/obj/item/storage/belt/marine = null,
		/obj/item/storage/pill_bottle/tramadol/skillless = null,
		/obj/item/explosive/grenade/phosphorus = null,
		/obj/item/clothing/glasses/welding = null,
		/obj/item/reagent_container/ld50_syringe/choral = null,
		/obj/item/storage/firstaid/regular = null,
		/obj/item/reagent_container/pill/cyanide = null,
		/obj/item/device/megaphone = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/bible = null,
		/obj/item/tool/surgery/scalpel = null,
		/obj/item/tool/surgery/scalpel = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat/metal = null,
		/obj/item/explosive/grenade/empgrenade = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/phosphorus/upp = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/storage/box/MRE = null,
		/obj/item/clothing/mask/gas/PMC = null,
		/obj/item/clothing/glasses/night/m42_night_goggles/upp = null,
		/obj/item/storage/box/handcuffs = null,
		/obj/item/storage/pill_bottle/happy = null,
		/obj/item/weapon/twohanded/fireaxe = null,
		/obj/item/weapon/twohanded/spear = null
		)

	var/gunpath = sidearm? pick(rebel_sidearms) : pick(rebel_firearms)
	var/ammopath = sidearm? rebel_sidearms[gunpath] : rebel_firearms[gunpath]
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/H = spawnloc
			H.equip_to_slot_or_del(gun, sidearm? WEAR_L_HAND : WEAR_J_STORE)
			if(ammopath && H.back && istype(H.back,/obj/item/storage))
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
		else
			if(ammopath != null)
				spawnloc = get_turf(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)


	return 1

/datum/equipment_preset/proc/spawn_merc_gun(var/atom/M,var/sidearm = 0)
	if(!M) return

	var/atom/spawnloc = M

	var/list/merc_sidearms = list(
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/automatic,
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended)

	var/list/merc_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/combat = /obj/item/ammo_magazine/shotgun,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/weapon/gun/smg/p90 = /obj/item/ammo_magazine/smg/p90,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi/extended)

	var/gunpath = sidearm? pick(merc_sidearms) : pick(merc_firearms)
	var/ammopath = sidearm? merc_sidearms[gunpath] : merc_firearms[gunpath]
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/H = spawnloc
			H.equip_to_slot_or_del(gun, sidearm? WEAR_L_HAND : WEAR_J_STORE)
			if(ammopath && H.back && istype(H.back,/obj/item/storage))
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
				new ammopath(H.back)
		else
			if(ammopath)
				spawnloc = get_turf(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)
				new ammopath(spawnloc)

	return 1

/datum/equipment_preset/proc/generate_random_marine_primary_for_wo(var/mob/living/carbon/human/H, shuffle = rand(0,10))
	switch(shuffle)
		if(0 to 4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/stripped(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
		if(5,7)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m39(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full(H), WEAR_WAIST)
	return

/datum/equipment_preset/proc/add_common_wo_equipment(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/self_setting(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)