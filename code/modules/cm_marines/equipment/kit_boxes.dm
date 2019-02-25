
/******************************************Spec Kits****************************************************************/

/obj/item/storage/box/spec
	var/spec_set
	icon = 'icons/Marine/marine-weapons.dmi'
	w_class = 5
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/spec/demolitionist
	name = "\improper Demolitionist equipment crate"
	desc = "A large case containing light armor, a heavy-caliber antitank missile launcher, missiles, C4, and claymore mines. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "rocket_case"
	spec_set = "demolitionist"

/obj/item/storage/box/spec/demolitionist/New()
	..()
	spawn(1)
		new	/obj/item/clothing/suit/storage/marine/M3T(src)
		new /obj/item/clothing/head/helmet/marine(src)
		new /obj/item/weapon/gun/launcher/rocket(src)
		new /obj/item/ammo_magazine/rocket(src)
		new /obj/item/ammo_magazine/rocket(src)
		new /obj/item/ammo_magazine/rocket/ap(src)
		new /obj/item/ammo_magazine/rocket/ap(src)
		new /obj/item/ammo_magazine/rocket/wp(src)
		new /obj/item/explosive/mine(src)
		new /obj/item/explosive/mine(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/explosive/plastique(src)


/obj/item/storage/box/spec/sniper
	name = "\improper Sniper equipment"
	desc = "A large case containing your very own long-range sniper rifle. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "sniper_case"
	spec_set = "sniper"

/obj/item/storage/box/spec/sniper/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/sniper(src)
		new /obj/item/clothing/glasses/night/m42_night_goggles(src)
		new /obj/item/ammo_magazine/sniper(src)
		new /obj/item/ammo_magazine/sniper/incendiary(src)
		new /obj/item/ammo_magazine/sniper/flak(src)
		new /obj/item/device/binoculars(src)
		new /obj/item/storage/backpack/marine/smock(src)
		new /obj/item/weapon/gun/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/weapon/gun/rifle/sniper/M42A(src)

/obj/item/storage/box/spec/sniper/open(mob/user) //A ton of runtimes were caused by ticker being null, so now we do the special items when its first opened
	if(!opened) //First time opening it, so add the round-specific items
		if(map_tag)
			switch(map_tag)
				if(MAP_ICE_COLONY)
					new /obj/item/clothing/head/helmet/marine(src)
				else
					new /obj/item/clothing/head/helmet/durag(src)
					new /obj/item/facepaint/sniper(src)
	..()


/obj/item/storage/box/spec/scout
	name = "\improper Scout equipment"
	desc = "A large case containing Scout equipment. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "sniper_case"
	spec_set = "scout"

/obj/item/storage/box/spec/scout/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/M3S(src)
		new /obj/item/clothing/head/helmet/marine/scout(src)
		new /obj/item/clothing/glasses/night/M4RA(src)
		new /obj/item/ammo_magazine/rifle/m4ra(src)
		new /obj/item/ammo_magazine/rifle/m4ra(src)
		new /obj/item/ammo_magazine/rifle/m4ra(src)
		new /obj/item/ammo_magazine/rifle/m4ra(src)
		new /obj/item/ammo_magazine/rifle/m4ra/incendiary(src)
		new /obj/item/ammo_magazine/rifle/m4ra/incendiary(src)
		new /obj/item/ammo_magazine/rifle/m4ra/impact(src)
		new /obj/item/ammo_magazine/rifle/m4ra/impact(src)
		new /obj/item/weapon/gun/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/weapon/gun/rifle/m4ra(src)
		new /obj/item/storage/backpack/marine/satchel/scout_cloak(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/device/encryptionkey/jtac(src)
		if(Check_WO())
			new /obj/item/device/binoculars/designator(src)
		else
			new /obj/item/device/binoculars/tactical/scout(src)


/obj/item/storage/box/spec/pyro
	name = "\improper Pyrotechnician equipment"
	desc = "A large case containing Pyrotechnician equipment. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "armor_case"
	spec_set = "pyro"

/obj/item/storage/box/spec/pyro/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/M35(src)
		new /obj/item/clothing/head/helmet/marine/pyro(src)
		new /obj/item/storage/backpack/marine/engineerpack/flamethrower(src)
		new /obj/item/weapon/gun/flamer/M240T(src)
		new /obj/item/ammo_magazine/flamer_tank/large(src)
		new /obj/item/ammo_magazine/flamer_tank/large(src)
		new /obj/item/ammo_magazine/flamer_tank/large/B(src)
		new /obj/item/ammo_magazine/flamer_tank/large/X(src)
		new /obj/item/tool/extinguisher(src)
		new /obj/item/tool/extinguisher/mini(src)


/obj/item/storage/box/spec/heavy_grenadier
	name = "\improper Heavy Grenadier equipment"
	desc = "A large case containing M50 Heavy Armor and a heavy-duty multi-shot grenade launcher, the Armat Systems M92. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "grenade_case"
	spec_set = "heavy grenadier"

/obj/item/storage/box/spec/heavy_grenadier/New()
	..()
	spawn(1)
		new /obj/item/weapon/gun/launcher/m92(src)
		new /obj/item/storage/belt/grenade/large/full(src)
		new /obj/item/clothing/gloves/marine/specialist(src)
		new /obj/item/clothing/suit/storage/marine/specialist(src)
		new /obj/item/clothing/head/helmet/marine/specialist(src)

/obj/item/storage/box/spec/antitank_rifle
	name = "\improper XM42B anti-tank rifle case"
	desc = "A large case containing sniper armour, a Mod 88, binoculars, a sniper smock and an experimental M42B anti-tank rifle. Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "sniper_case"
	spec_set = "sniper"

/obj/item/storage/box/spec/antitank_rifle/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/sniper(src)
		new /obj/item/device/binoculars(src)
		new /obj/item/storage/backpack/marine/smock(src)
		new /obj/item/weapon/gun/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/ammo_magazine/pistol/vp70(src)
		new /obj/item/weapon/gun/rifle/sniper/M42B(src)
		new /obj/item/clothing/suit/storage/marine/ghillie(src)
		new /obj/item/ammo_magazine/sniper/anti_tank(src)
		new /obj/item/ammo_magazine/sniper/anti_tank(src)
		new /obj/item/ammo_magazine/sniper/anti_tank(src)

var/list/kits = list("Pyro" = 2, "Grenadier" = 2, "Sniper" = 2, "Scout" = 2, "Demo" = 2)

/obj/item/spec_kit //For events/WO, allowing the user to choose a specalist kit
	name = "specialist kit"
	desc = "A paper box. Open it and get a specialist kit."
	icon = 'icons/obj/items/storage/storage.dmi'
	icon_state = "deliverycrate"

/obj/item/spec_kit/attack_self(mob/user)
	if(user.mind && user.mind.cm_skills && user.mind.cm_skills.spec_weapons < SKILL_SPEC_TRAINED)
		user << "<span class='notice'>This box is not for you, give it to a specialist!</span>"
		return
	var/selection = input(user, "Pick your equipment", "Specialist Kit Selection") as null|anything in kits
	if(!selection)
		return
	if(!kits[selection])
		user << "<span class='notice'>No more kits of this type may be chosen!!</span>"
		return
	var/turf/T = get_turf(loc)
	switch(selection)
		if("Pyro")
			new /obj/item/storage/box/spec/pyro (T)
			kits["Pyro"] --
		if("Grenadier")
			new /obj/item/storage/box/spec/heavy_grenadier (T)
			kits["Genader"] --
		if("Sniper")
			new /obj/item/storage/box/spec/sniper (T)
			kits["Sniper"] --
		if("Scout")
			new /obj/item/storage/box/spec/scout (T)
			kits["Scout"] --
		if("Demo")
			new /obj/item/storage/box/spec/demolitionist (T)
			kits["Demo"] --
	cdel(src)

/obj/item/spec_kit/asrs
	desc = "A paper box. Open it and get a specialist kit. Works only for squad marines."
	
/obj/item/spec_kit/asrs/attack_self(mob/user)
	if(user.mind && user.mind.assigned_role == "Squad Marine")
		user.mind.cm_skills.spec_weapons = SKILL_SPEC_TRAINED
	else
		user << "<span class='notice'>This box is not for you, give it to a squad marine!</span>"
	..()

/******************************************PFC Kits****************************************************************/

/obj/item/storage/box/kit
	icon = 'icons/Marine/marine-weapons.dmi'
	icon_state = "kit_case"
	w_class = 5
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null
	desc = "Drag this sprite onto you to open it up!\nNOTE: You cannot put items back inside this case."


/obj/item/storage/box/kit/mini_pyro
	name = "\improper Mini Pyro Kit"

/obj/item/storage/box/kit/mini_pyro/New()
	..()
	spawn(1)
		new /obj/item/storage/backpack/marine/engineerpack(src)
		new /obj/item/attachable/attached_gun/flamer(src)
		new /obj/item/tool/extinguisher(src)
		new /obj/item/tool/extinguisher/mini(src)
		new /obj/item/weapon/gun/flamer(src)
		new /obj/item/ammo_magazine/flamer_tank(src)

/obj/item/storage/box/kit/mini_sniper
	name = "\improper Mini Sniper Kit"

/obj/item/storage/box/kit/mini_sniper/New()
	..()
	spawn(1)
		//TODO: add carbine here later
		new /obj/item/weapon/gun/rifle/m41a(src)
		new /obj/item/attachable/scope(src)
		new /obj/item/attachable/bipod(src)
		new /obj/item/attachable/stock/rifle(src)
		new /obj/item/attachable/extended_barrel(src)
		new /obj/item/ammo_magazine/rifle/ap(src)

/obj/item/storage/box/kit/mini_engineer
	name = "\improper Mini Engineer Kit"

/obj/item/storage/box/kit/mini_engineer/New()
	..()
	spawn(1)
		new /obj/item/pamphlet/engineer(src)
		new /obj/item/storage/pouch/construction(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/tool/shovel/etool(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/storage/pouch/tools/pfc(src)

		var/obj/item/stack/sheet/metal/MET = new /obj/item/stack/sheet/metal(src)
		MET.amount = 20
		var/obj/item/stack/sandbags_empty/SND1 = new /obj/item/stack/sandbags_empty(src)
		SND1.amount = 15

/obj/item/storage/box/kit/mini_medic
	name = "\improper Mini Medic Kit"

/obj/item/storage/box/kit/mini_medic/New()
	..()
	spawn(1)
		new /obj/item/pamphlet/medical(src)
		new /obj/item/storage/firstaid/adv(src)
		new /obj/item/storage/pouch/medical/full(src)
		new /obj/item/clothing/glasses/hud/health(src)
		new /obj/item/device/healthanalyzer(src)

/obj/item/storage/box/kit/mini_jtac
	name = "\improper Mini JTAC Kit"

/obj/item/storage/box/kit/mini_jtac/New()
	..()
	spawn(1)
		new /obj/item/storage/box/m94/signal(src)
		new /obj/item/storage/box/m94/signal(src)
		new /obj/item/device/binoculars/tactical(src)
		new /obj/item/device/encryptionkey/jtac(src)

