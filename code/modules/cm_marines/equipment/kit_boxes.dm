
/******************************************Spec Kits****************************************************************/

/obj/item/storage/box/spec
	var/spec_set
	icon = 'icons/obj/items/weapons/guns/attachments.dmi'
	w_class = SIZE_HUGE
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/spec/demolitionist
	name = "\improper Demolitionist equipment crate"
	desc = "A large case containing light armor, a heavy-caliber antitank missile launcher, missiles, C4, and claymore mines. Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "rocket_case"
	spec_set = "demolitionist"

/obj/item/storage/box/spec/demolitionist/New()
	..()
	spawn(1)
		new	/obj/item/clothing/suit/storage/marine/M3T(src)
		new /obj/item/clothing/head/helmet/marine(src)
		new /obj/item/storage/backpack/marine/rocketpack(src)
		new /obj/item/storage/backpack/marine/rocketpack(src)
		new /obj/item/weapon/gun/launcher/rocket(src)
		new /obj/item/ammo_magazine/rocket(src)
		new /obj/item/ammo_magazine/rocket(src)
		new /obj/item/ammo_magazine/rocket/ap(src)
		new /obj/item/ammo_magazine/rocket/ap(src)
		new /obj/item/ammo_magazine/rocket/wp(src)
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/explosive/plastique(src)


/obj/item/storage/box/spec/sniper
	name = "\improper Sniper equipment"
	desc = "A large case containing your very own long-range sniper rifle. Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "sniper_case"
	spec_set = "sniper"

/obj/item/storage/box/spec/sniper/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/ghillie(src)
		new /obj/item/clothing/head/helmet/marine/ghillie(src)
		new /obj/item/clothing/glasses/night/m42_night_goggles(src)
		new /obj/item/ammo_magazine/sniper(src)
		new /obj/item/ammo_magazine/sniper/incendiary(src)
		new /obj/item/ammo_magazine/sniper/flak(src)
		new /obj/item/storage/backpack/marine/smock(src)
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/weapon/gun/rifle/sniper/M42A(src)
		new /obj/item/facepaint/sniper(src)


/obj/item/storage/box/spec/scout
	name = "\improper Scout equipment"
	desc = "A large case containing Scout equipment. Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
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
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/weapon/gun/rifle/m4ra(src)
		new /obj/item/storage/backpack/marine/satchel/scout_cloak(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/explosive/plastique(src)
		new /obj/item/device/encryptionkey/jtac(src)
		if(Check_WO())
			new /obj/item/device/binoculars/designator(src)
		else
			new /obj/item/device/binoculars/range/designator/scout(src)


/obj/item/storage/box/spec/pyro
	name = "\improper Pyrotechnician equipment"
	desc = "A large case containing Pyrotechnician equipment. Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "armor_case"
	spec_set = "pyro"

/obj/item/storage/box/spec/pyro/New()
	..()
	spawn(1)
		new /obj/item/clothing/suit/storage/marine/M35(src)
		new /obj/item/clothing/head/helmet/marine/pyro(src)
		new /obj/item/storage/large_holster/fuelpack(src)
		new /obj/item/weapon/gun/flamer/M240T(src)
		new /obj/item/ammo_magazine/flamer_tank/large(src)
		new /obj/item/storage/pouch/flamertank(src)
		new /obj/item/tool/extinguisher(src)
		new /obj/item/tool/extinguisher/mini(src)
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)


/obj/item/storage/box/spec/heavy_grenadier
	name = "\improper Heavy Grenadier equipment"
	desc = "A large case containing M3-G4 heavy armor and a heavy-duty multi-shot grenade launcher, the Armat Systems M92. Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "grenade_case"
	spec_set = "heavy grenadier"

/obj/item/storage/box/spec/heavy_grenadier/New()
	..()
	spawn(1)
		new /obj/item/weapon/gun/launcher/m92(src)
		new /obj/item/storage/belt/grenade/large/full(src)
		new /obj/item/clothing/gloves/marine/M3G(src)
		new /obj/item/clothing/suit/storage/marine/M3G(src)
		new /obj/item/clothing/head/helmet/marine/grenadier(src)
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)

//maybe put in req for later use?
/obj/item/storage/box/spec/B18
	name = "\improper B18 heavy armor case"
	desc = "A large case containing the experimental B18 armor platform. Handle with care, it's more expensive than all of Delta combined.  Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon_state = "armor_case"
	spec_set = "B18 Defensive"

/obj/item/storage/box/spec/B18/New()
	..()
	spawn(1)
		new /obj/item/clothing/gloves/marine/specialist(src)
		new /obj/item/clothing/head/helmet/marine/specialist(src)
		new /obj/item/clothing/suit/storage/marine/specialist(src)


var/list/kits = list("Pyro" = 2, "Grenadier" = 2, "Sniper" = 2, "Scout" = 2, "Demo" = 2)

/obj/item/spec_kit //For events/WO, allowing the user to choose a specalist kit
	name = "specialist kit"
	desc = "A paper box. Open it and get a specialist kit."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "deliverycrate"

/obj/item/spec_kit/attack_self(mob/user)
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED))
		to_chat(user, SPAN_NOTICE("This box is not for you, give it to a specialist!"))
		return
	var/selection = input(user, "Pick your equipment", "Specialist Kit Selection") as null|anything in kits
	if(!selection)
		return
	if(!kits[selection])
		to_chat(user, SPAN_NOTICE("No more kits of this type may be chosen!!"))
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
	qdel(src)

/obj/item/spec_kit/asrs
	desc = "A paper box. Open it and get a specialist kit. Works only for squad marines."

/obj/item/spec_kit/asrs/attack_self(mob/user)
	if(user.mind && user.mind.assigned_role == JOB_SQUAD_MARINE)
		user.skills.set_skill(SKILL_SPEC_WEAPONS)
	else
		to_chat(user, SPAN_NOTICE("This box is not for you, give it to a squad marine!"))
	..()

/******************************************PFC Kits****************************************************************/

/obj/item/storage/box/kit
	icon = 'icons/obj/items/pro_case.dmi'
	icon_state = "pro_case_mini"
	w_class = SIZE_HUGE
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null
	desc = "Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."

/obj/item/storage/box/kit/mou53_sapper
	name = "\improper M-OU53 Field Test Kit"

/obj/item/storage/box/kit/mou53_sapper/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+mou53")
	spawn(1)
		new /obj/item/weapon/gun/shotgun/double/mou53(src)
		new /obj/item/attachable/stock/mou53(src)
		new /obj/item/ammo_magazine/shotgun/slugs(src)
		new /obj/item/ammo_magazine/shotgun/flechette(src)
		new /obj/item/storage/belt/shotgun(src)

/obj/item/storage/box/kit/update_icon()
	if(!contents.len)
		var/turf/T = get_turf(src)
		if(T)
			new /obj/item/paper/crumpled(T)
		qdel(src)

/obj/item/storage/box/kit/mini_pyro
	name = "\improper M240 Pyrotechnician Support Kit"

/obj/item/storage/box/kit/mini_pyro/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+flamer")
	spawn(1)
		new /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit(src)
		new /obj/item/weapon/gun/flamer(src)
		new /obj/item/ammo_magazine/flamer_tank(src)
		new /obj/item/ammo_magazine/flamer_tank(src)
		new /obj/item/ammo_magazine/flamer_tank/gellied(src)
		new /obj/item/tool/extinguisher/mini(src)

/obj/item/storage/box/kit/mini_sniper
	name = "\improper L42A Sniper Kit"

/obj/item/storage/box/kit/mini_sniper/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+sniper")
	spawn(1)
		new /obj/item/weapon/gun/rifle/l42a(src)
		new /obj/item/attachable/scope(src)
		new /obj/item/attachable/suppressor(src)
		new /obj/item/attachable/extended_barrel(src)
		new /obj/item/ammo_magazine/rifle/l42a/ap(src)
		new /obj/item/ammo_magazine/rifle/l42a/ap(src)

/obj/item/storage/box/kit/heavy_support
	name = "\improper Forward HPR Shield Kit"

/obj/item/storage/box/kit/heavy_support/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+shield")
	spawn(1)
		new /obj/item/weapon/gun/rifle/lmg(src)
		new /obj/item/ammo_magazine/rifle/lmg(src)
		new /obj/item/attachable/bipod(src)
		new /obj/item/folding_barricade(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/tool/weldingtool(src)

/obj/item/storage/box/kit/pursuit
	name = "\improper M39 Point Man Kit"

/obj/item/storage/box/kit/pursuit/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+pursuit")
	spawn(1)
		new /obj/item/weapon/gun/smg/m39(src)
		new /obj/item/attachable/stock/smg/brace(src)
		new /obj/item/attachable/magnetic_harness(src)
		new /obj/item/storage/large_holster/machete/full(src)
		new /obj/item/ammo_magazine/smg/m39/extended(src)

/obj/item/storage/box/kit/mini_engineer
	name = "\improper Combat Technician Support Kit"

/obj/item/storage/box/kit/mini_engineer/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+engi")
	spawn(1)
		new /obj/item/storage/backpack/marine/engineerpack(src)
		new /obj/item/pamphlet/engineer(src)
		new /obj/item/storage/pouch/construction(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/tool/crowbar(src)
		new /obj/item/tool/shovel/etool(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/storage/pouch/tools/pfc(src)
		new /obj/item/folding_barricade(src)

		var/obj/item/stack/sheet/metal/MET = new /obj/item/stack/sheet/metal(src)
		MET.amount = 20
		var/obj/item/stack/sandbags_empty/SND1 = new /obj/item/stack/sandbags_empty(src)
		SND1.amount = 15

/obj/item/storage/box/kit/mini_medic
	name = "\improper First Responder Medical Support Kit"

/obj/item/storage/box/kit/mini_medic/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+medic")
	spawn(1)
		new /obj/item/pamphlet/medical(src)
		new /obj/item/storage/pouch/medical/frt_kit/full(src)
		new /obj/item/storage/pouch/autoinjector/full(src)
		new /obj/item/clothing/glasses/hud/sensor(src)
		new /obj/item/roller(src)

/obj/item/storage/box/kit/mini_jtac
	name = "\improper JTAC Radio Kit"

/obj/item/storage/box/kit/mini_jtac/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+jtac")
	spawn(1)
		new /obj/item/weapon/gun/flare(src)
		new /obj/item/storage/belt/gun/flaregun/full_nogun(src)
		new /obj/item/storage/box/m94/signal(src)
		new /obj/item/storage/box/m94/signal(src)
		new /obj/item/device/binoculars/range/designator(src)
		new /obj/item/device/encryptionkey/jtac(src)

/obj/item/storage/box/kit/mini_intel
	name = "\improper Field Intelligence Support Kit"

/obj/item/storage/box/kit/mini_intel/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+intel")
	spawn(1)
		new /obj/item/stack/fulton(src)
		new /obj/item/storage/pouch/document/small(src)
		new /obj/item/device/motiondetector/intel(src)
		new /obj/item/device/encryptionkey/intel(src)

/obj/item/storage/box/kit/veteran_enlist
	name = "\improper Veteran Enlisted Assault Kit"

/obj/item/storage/box/kit/veteran_enlist/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+veteran")
	spawn(1)
		new /obj/item/weapon/gun/rifle/m41aMK1(src)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
		new /obj/item/attachable/attached_gun/flamer(src)
		new /obj/item/attachable/attached_gun/shotgun(src)
		new /obj/item/storage/pouch/magazine/large(src)

/obj/item/storage/box/kit/mini_grenadier
	name = "\improper Frontline M40 Grenadier Kit"

/obj/item/storage/box/kit/mini_grenadier/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+grenadier")
	spawn(1)
		new /obj/item/storage/belt/grenade/full(src)
		new /obj/item/storage/pouch/explosive(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)

/obj/item/storage/box/kit/self_defense
	name = "\improper Personal Self Defense Kit"

/obj/item/storage/box/kit/self_defense/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+defense")
	spawn(1)
		new /obj/item/weapon/gun/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/ammo_magazine/pistol/vp78(src)
		new /obj/item/attachable/reddot(src)
		new /obj/item/attachable/lasersight(src)
		new /obj/item/storage/belt/gun/m4a3(src)

/obj/item/storage/box/kit/exp_trooper
	name = "\improper Experimental Trooper Kit"

/obj/item/storage/box/kit/exp_trooper/New()
	..()
	overlays += image('icons/obj/items/pro_case.dmi', "+smart")
	spawn(1)
		new /obj/item/weapon/gun/pistol/smart(src)
		new /obj/item/ammo_magazine/pistol/smart(src)
		new /obj/item/ammo_magazine/pistol/smart(src)
		new /obj/item/ammo_magazine/pistol/smart(src)
		new /obj/item/ammo_magazine/pistol/smart(src)
		new /obj/item/ammo_magazine/pistol/smart(src)
		new /obj/item/attachable/extended_barrel(src)
		new /obj/item/attachable/quickfire(src)
		new /obj/item/attachable/lasersight(src)
		new /obj/item/storage/belt/gun/smartpistol(src)
