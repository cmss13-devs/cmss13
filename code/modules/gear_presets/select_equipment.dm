
/datum/equipment_preset
	var/name = "Preset"
	var/flags = EQUIPMENT_PRESET_STUB

	//load_appearance()
/datum/equipment_preset/proc/load_race(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_name(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_skills(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_gear(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_id(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_languages(ob/living/carbon/human/H)
/datum/equipment_preset/proc/load_status(ob/living/carbon/human/H)

/datum/equipment_preset/proc/load_preset(mob/living/carbon/human/H)
	load_race(H)
	//load_name(H)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_gear(H)
	load_id(H)
	load_status(H)

/datum/equipment_preset/strip
	name = "*strip*"

/datum/equipment_preset/proc/spawn_rebel_gun(var/atom/M,var/sidearm = 0)
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
