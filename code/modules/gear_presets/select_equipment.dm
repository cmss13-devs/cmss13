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
	var/minimum_age
	var/faction = FACTION_NEUTRAL

	//Uniform data
	var/utility_under = null
	var/utility_over = null
	var/utility_gloves = null
	var/utility_shoes = null
	var/utility_hat = null
	var/utility_extra = null

	var/service_under = null
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

	var/list/uniform_sets = null


/datum/equipment_preset/New()
	uniform_sets = list(
		UNIFORM_VEND_UTILITY_UNIFORM = utility_under,
		UNIFORM_VEND_UTILITY_JACKET = utility_over,
		UNIFORM_VEND_UTILITY_HEAD = utility_hat,
		UNIFORM_VEND_UTILITY_GLOVES = utility_gloves,
		UNIFORM_VEND_UTILITY_SHOES = utility_shoes,
		UNIFORM_VEND_UTILITY_EXTRA = utility_extra,

		UNIFORM_VEND_SERVICE_UNIFORM = service_under,
		UNIFORM_VEND_SERVICE_JACKET = service_over,
		UNIFORM_VEND_SERVICE_HEAD = service_hat,
		UNIFORM_VEND_SERVICE_GLOVES = service_gloves,
		UNIFORM_VEND_SERVICE_SHOES = service_shoes,
		UNIFORM_VEND_SERVICE_EXTRA = service_extra,

		UNIFORM_VEND_DRESS_UNIFORM = dress_under,
		UNIFORM_VEND_DRESS_JACKET = dress_over,
		UNIFORM_VEND_DRESS_HEAD = dress_hat,
		UNIFORM_VEND_DRESS_GLOVES = dress_gloves,
		UNIFORM_VEND_DRESS_SHOES = dress_shoes,
		UNIFORM_VEND_DRESS_EXTRA = dress_extra
	)

	//load_appearance()
/datum/equipment_preset/proc/load_race(mob/living/carbon/human/H)
	return

/datum/equipment_preset/proc/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/proc/load_age(mob/living/carbon/human/H)
	if(minimum_age && H.age < minimum_age)
		H.age = minimum_age

/datum/equipment_preset/proc/load_rank(mob/living/carbon/human/H)
	return paygrade

/datum/equipment_preset/proc/load_gear(mob/living/carbon/human/H)
	return

/datum/equipment_preset/proc/load_status(mob/living/carbon/human/H)
	return

/datum/equipment_preset/proc/load_skills(mob/living/carbon/human/H)
	H.set_skills(skills)

/datum/equipment_preset/proc/load_id(mob/living/carbon/human/H)
	if(!idtype)
		return
	var/obj/item/card/id/W = new idtype()
	W.name = "[H.real_name]'s ID Card"
	if(assignment)
		W.name += " ([assignment])"
	W.access = access.Copy(1, 0)
	W.faction = faction
	W.assignment = assignment
	W.rank = rank
	W.registered_name = H.real_name
	W.paygrade = load_rank(H)
	W.uniform_sets = uniform_sets
	H.equip_to_slot_or_del(W, WEAR_ID)
	H.faction = faction
	if(H.mind)
		H.mind.name = H.real_name
		if(H.mind.initial_account)
			W.associated_account_number = H.mind.initial_account.account_number
	H.job = rank
	H.faction = faction
	H.comm_title = role_comm_title

/datum/equipment_preset/proc/load_languages(mob/living/carbon/human/H)
	H.set_languages(languages)

/datum/equipment_preset/proc/load_preset(mob/living/carbon/human/H, var/randomise = FALSE, var/count_participant = FALSE)
	load_race(H)
	if(randomise || uses_special_name)
		load_name(H, randomise)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_age(H)
	load_gear(H)
	load_id(H)
	load_status(H)
	load_vanity(H)
	if(round_statistics && count_participant)
		round_statistics.track_new_participant(faction)
	H.regenerate_icons()

/datum/equipment_preset/proc/load_vanity(mob/living/carbon/human/H)
	if(!H.client || !H.client.prefs || !H.client.prefs.gear)
		return//We want to equip them with custom stuff second, after they are equipped with everything else.
	var/datum/gear/G
	var/i
	for(i in H.client.prefs.gear)
		G = gear_datums[i]
		if(G)
			if(!H.equip_to_slot_or_del(new G.path, G.slot))
				H.equip_to_slot_or_del(new G.path, WEAR_IN_BACK)

    //Gives ranks to the ranked
	var/current_rank = paygrade
	var/obj/item/card/id/I = H.get_idcard()
	if(I)
		current_rank = I.paygrade
	if(H.w_uniform && current_rank)
		var/rankpath = get_rank_pins(current_rank)
		if(rankpath)
			var/obj/item/clothing/accessory/ranks/R = new rankpath()
			if(H.wear_suit && H.wear_suit.can_attach_accessory(R))
				H.wear_suit.attach_accessory(H, R)
			else if(H.w_uniform && H.w_uniform.can_attach_accessory(R))
				H.w_uniform.attach_accessory(H, R)
			else
				qdel(R)

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/obj/item/clothing/glasses/regular/P = new (H)
		P.prescription = 1
		H.equip_to_slot_or_del(P, WEAR_EYES)

/datum/equipment_preset/strip //For removing all equipment
	name = "*strip*"
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = null


/datum/equipment_preset/proc/spawn_rebel_uniform(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/uniformpath = pick(
		/obj/item/clothing/under/colonist/clf,
		)
	H.equip_to_slot_or_del(new uniformpath, WEAR_BODY)


/datum/equipment_preset/proc/spawn_rebel_suit(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/suitpath = pick(
		/obj/item/clothing/suit/storage/militia,
		/obj/item/clothing/suit/storage/militia/vest,
		/obj/item/clothing/suit/storage/militia/brace,
		/obj/item/clothing/suit/storage/militia/partial,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/vest,
		)
	H.equip_to_slot_or_del(new suitpath, WEAR_JACKET)


/datum/equipment_preset/proc/spawn_rebel_helmet(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/helmetpath = pick(
		/obj/item/clothing/head/militia,
		/obj/item/clothing/head/militia/bucket,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/helmet/durag,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/rebel,
		/obj/item/clothing/head/headband/rambo,
		)
	H.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)


/datum/equipment_preset/proc/spawn_rebel_shoes(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/shoespath = pick(
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/swat,
		)
	H.equip_to_slot_or_del(new shoespath, WEAR_FEET)


/datum/equipment_preset/proc/spawn_rebel_gloves(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/glovespath = pick(
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/gloves/botanic_leather,
		)
	H.equip_to_slot_or_del(new glovespath, WEAR_HANDS)


/datum/equipment_preset/proc/spawn_rebel_belt(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/beltpath = pick(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/knifepouch,
		/obj/item/storage/belt/gun/flaregun/full,
		/obj/item/storage/sparepouch,
		/obj/item/storage/large_holster/katana/full,
		/obj/item/storage/large_holster/machete/full,
		)
	H.equip_to_slot_or_del(new beltpath, WEAR_WAIST)


/datum/equipment_preset/proc/spawn_rebel_weapon(var/atom/M, var/sidearm = 0, var/ammo_amount = 12)
	if(!M) return

	var/list/rebel_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/handful/shotgun/slug,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/flechette,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/hunting = /obj/item/ammo_magazine/rifle/hunting,
		/obj/item/weapon/gun/rifle/hunting = /obj/item/ammo_magazine/rifle/hunting,
		/obj/item/weapon/gun/rifle/hunting = /obj/item/ammo_magazine/rifle/hunting,
		/obj/item/weapon/gun/rifle/hunting = /obj/item/ammo_magazine/rifle/hunting,
		/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd,
		/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd,
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/smg/mp7 = /obj/item/ammo_magazine/smg/mp7,
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/skorpion = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/skorpion/upp = /obj/item/ammo_magazine/smg/skorpion,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/pistol/mod88 = /obj/item/ammo_magazine/pistol/mod88,
		)

	//no guns in sidearms list, we don't want players spawning with a gun in hand.
	var/list/rebel_sidearms = list(
		/obj/item/weapon/twohanded/lungemine = null,
		/obj/item/weapon/twohanded/lungemine = null,
		/obj/item/attachable/bayonet = null,
		/obj/item/attachable/bayonet/upp = null,
		/obj/item/explosive/grenade/custom/ied = null,
		/obj/item/explosive/grenade/custom/ied = null,
		/obj/item/explosive/grenade/custom/ied_incendiary = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/clothing/accessory/storage/webbing = null,
		/obj/item/clothing/accessory/storage/webbing = null,
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

	spawn_weapon(gunpath, ammopath, M, sidearm, ammo_amount)

	return 1


/datum/equipment_preset/proc/spawn_merc_helmet(var/mob/living/carbon/human/H)
	if(!istype(H)) return
	var/helmetpath = pick(
		/obj/item/clothing/head/freelancer,
		/obj/item/clothing/head/helmet/durag,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/cmbandana,
		/obj/item/clothing/head/cmbandana/tan,
		/obj/item/clothing/head/beanie,
		/obj/item/clothing/head/headband,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/tan,
	)
	H.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)


/datum/equipment_preset/proc/spawn_merc_weapon(var/atom/M, var/sidearm = 0, var/ammo_amount = 12)
	if(!M) return

	var/list/merc_sidearms = list(
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
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/handful/shotgun/slug,
		/obj/item/weapon/gun/shotgun/combat = /obj/item/ammo_magazine/handful/shotgun/slug,
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16)

	var/gunpath = sidearm? pick(merc_sidearms) : pick(merc_firearms)
	var/ammopath = sidearm? merc_sidearms[gunpath] : merc_firearms[gunpath]

	spawn_weapon(gunpath, ammopath, M, sidearm, ammo_amount)

	return 1


/datum/equipment_preset/proc/spawn_weapon(var/gunpath, var/ammopath, var/atom/M, var/sidearm = 0, var/ammo_amount = 12)

	var/atom/spawnloc = M
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/H = spawnloc
			H.equip_to_slot_or_del(gun, sidearm? WEAR_L_HAND : WEAR_J_STORE)
			if(ammopath && ammo_amount)
				for(var/i in 0 to ammo_amount-1)
					if(!H.equip_to_appropriate_slot(new ammopath))
						break
		else if(ammopath)
			spawnloc = get_turf(spawnloc)
			for(var/i in 0 to ammo_amount-1)
				new ammopath(spawnloc)


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

/datum/equipment_preset/proc/add_ice_colony_survivor_equipment(var/mob/living/carbon/human/H)
	if((map_tag in MAPS_COLD_TEMP) && (map_tag != MAP_CORSAT))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(H), WEAR_FACE)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)

/datum/equipment_preset/proc/add_random_survivor_equipment(var/mob/living/carbon/human/H)
	var/random_gear = rand(0,20)
	switch(random_gear)
		if(0)
			H.equip_to_slot_or_del(new /obj/item/device/camera/oldcamera(H), WEAR_R_HAND)
		if(1)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), WEAR_R_HAND)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), WEAR_R_HAND)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_R_HAND)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgicaldrill(H), WEAR_R_HAND)
		if(5)
			H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack(H), WEAR_R_HAND)
		if(6)
			H.equip_to_slot_or_del(new /obj/item/weapon/butterfly/switchblade(H), WEAR_R_HAND)
		if(7)
			H.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife(H), WEAR_R_HAND)
		if(8)
			H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/lemoncakeslice(H), WEAR_R_HAND)
		if(9)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(H), WEAR_R_HAND)
		if(10)
			H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/largetank(H), WEAR_R_HAND)

/datum/equipment_preset/proc/add_random_survivor_weapon(var/mob/living/carbon/human/H)
	if(map_tag != MAP_PRISON_STATION)
		var/random_weap = rand(0,3)
		switch(random_weap)
			if(0)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout(H), WEAR_WAIST)
			if(1)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/b92fs(H), WEAR_WAIST)
			if(2)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/kt42(H), WEAR_WAIST)
			if(3)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/small(H), WEAR_WAIST)
