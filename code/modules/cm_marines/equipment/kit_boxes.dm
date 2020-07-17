
/******************************************Spec Kits****************************************************************/

/obj/item/storage/box/spec
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	var/kit_overlay = null
	w_class = SIZE_HUGE
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/spec/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, kit_overlay)
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/spec/demolitionist
	name = "\improper Demolitionist equipment case"
	desc = "A large case containing a heavy-caliber anti-tank M5 RPG rocket launcher, M3-T light armor, five 84mm rockets and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "demo"

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
		new /obj/item/device/binoculars(src)
		update_icon()

/obj/item/storage/box/spec/sniper
	name = "\improper Sniper equipment case"
	desc = "A large case containing your very own long-range M42A sniper rifle, M45 ghillie armor and helmet, M42 scout sight, ammunition and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "sniper"

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
		update_icon()


/obj/item/storage/box/spec/scout
	name = "\improper Scout equipment case"
	desc = "A large case containing M4RA battle rifle, M3-S light armor and helmet, M4RA battle sight, M68 thermal cloak, improved scout laser designator, ammunition and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "scout"

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
		update_icon()

/obj/item/storage/box/spec/pyro
	name = "\improper Pyrotechnician equipment case"
	desc = "A large case containing M240-T incinerator unit, M35 pyrotechnician armor and helmet, Broiler-T flexible refueling system and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "pyro"

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
		new /obj/item/device/binoculars(src)
		update_icon()

/obj/item/storage/box/spec/heavy_grenadier
	name = "\improper Heavy Grenadier equipment case"
	desc = "A large case containing a heavy-duty multi-shot Armat Systems M92 grenade launcher, M3-G4 grenadier armor and helmet, significant amount of various M40 grenades and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "grenadier"

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
		new /obj/item/device/binoculars(src)
		update_icon()

//maybe put in req for later use?
/obj/item/storage/box/spec/B18
	name = "\improper B18 heavy armor case"
	desc = "A large case containing the experimental B18 armor platform. Handle with care, it's more expensive than all of Delta combined.\nDrag this sprite onto yourself to open it up!NOTE: You cannot put items back inside this case."
	kit_overlay = "b18"

/obj/item/storage/box/spec/B18/New()
	..()
	spawn(1)
		new /obj/item/clothing/gloves/marine/specialist(src)
		new /obj/item/clothing/head/helmet/marine/specialist(src)
		new /obj/item/clothing/suit/storage/marine/specialist(src)
		update_icon()

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
	if(user.job == JOB_SQUAD_MARINE)
		user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED)
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
	foldable = TRUE
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
		new /obj/item/attachable/attached_gun/extinguisher(src)
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
		new /obj/item/clothing/gloves/marine/insulated(src)
		new /obj/item/tool/crowbar(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/storage/pouch/tools/pfc(src)
		new /obj/item/folding_barricade(src)
		new /obj/item/device/m56d_gun/mounted(src)

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
