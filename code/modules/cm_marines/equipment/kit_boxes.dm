
//******************************************Spec Kits****************************************************************/

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
	if(length(overlays))
		overlays.Cut()
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, kit_overlay)
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/spec/demolitionist
	name = "\improper Demolitionist equipment case"
	desc = "A large case containing a heavy-caliber anti-tank M5 RPG rocket launcher, M3-T light armor, five 84mm rockets and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "demo"

/obj/item/storage/box/spec/demolitionist/fill_preset_inventory()
	new /obj/item/clothing/suit/storage/marine/M3T(src)
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
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/device/binoculars(src)


/obj/item/storage/box/spec/sniper
	name = "\improper Sniper equipment case"
	desc = "A large case containing your very own long-range M42A sniper rifle, M45 ghillie armor and helmet, M42 scout sight, ammunition and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "sniper"

/obj/item/storage/box/spec/sniper/fill_preset_inventory()
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
	name = "\improper Scout equipment case"
	desc = "A large case containing M4RA battle rifle, M3-S light armor and helmet, M4RA battle sight, M68 thermal cloak, improved scout laser designator, ammunition and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "scout"

/obj/item/storage/box/spec/scout/fill_preset_inventory()
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
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/device/encryptionkey/jtac(src)
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		new /obj/item/device/binoculars/designator(src)
	else
		new /obj/item/device/binoculars/range/designator/scout(src)


/obj/item/storage/box/spec/pyro
	name = "\improper Pyrotechnician equipment case"
	desc = "A large case containing M240-T incinerator unit, M35 pyrotechnician armor and helmet, Broiler-T flexible refueling system and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "pyro"

/obj/item/storage/box/spec/pyro/fill_preset_inventory()
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


/obj/item/storage/box/spec/heavy_grenadier
	name = "\improper Heavy Grenadier equipment case"
	desc = "A large case containing a heavy-duty multi-shot Armat Systems M92 grenade launcher, M3-G4 grenadier armor and helmet, significant amount of various M40 grenades and additional pieces of equipment.\nDrag this sprite onto yourself to open it up! NOTE: You cannot put items back inside this case."
	kit_overlay = "grenadier"

/obj/item/storage/box/spec/heavy_grenadier/fill_preset_inventory()
	new /obj/item/weapon/gun/launcher/grenade/m92(src)
	new /obj/item/storage/belt/grenade/large/full(src)
	new /obj/item/storage/backpack/marine/grenadepack(src)
	new /obj/item/storage/backpack/marine/grenadepack(src)
	new /obj/item/clothing/gloves/marine/M3G(src)
	new /obj/item/clothing/suit/storage/marine/M3G(src)
	new /obj/item/clothing/head/helmet/marine/grenadier(src)
	new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/device/binoculars(src)


//maybe put in req for later use?
/obj/item/storage/box/spec/B18
	name = "\improper B18 heavy armor case"
	desc = "A large case containing the experimental B18 armor platform. Handle with care, it's more expensive than all of Delta combined.\nDrag this sprite onto yourself to open it up!NOTE: You cannot put items back inside this case."
	kit_overlay = "b18"

/obj/item/storage/box/spec/B18/fill_preset_inventory()
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
	..()

	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
		to_chat(user, SPAN_NOTICE("This box is not for you, give it to a specialist!"))
		return
	if(select_and_spawn(user))
		qdel(src)

/obj/item/spec_kit/asrs
	desc = "A paper box. Open it and get a specialist kit. Works only for squad marines."

/obj/item/spec_kit/asrs/attack_self(mob/user)
	..()

	if(user.job == JOB_SQUAD_MARINE)
		if(select_and_spawn(user))
			qdel(src)
	else
		to_chat(user, SPAN_NOTICE("This box is not for you, give it to a squad marine!"))

/obj/item/spec_kit/proc/select_and_spawn(mob/living/carbon/human/user)
	if(!istype(user))
		to_chat(user, SPAN_WARNING("You can't use \the [src]!"))
		return

	var/selection = tgui_input_list(user, "Pick your equipment", "Specialist Kit Selection", kits)
	if(!selection)
		return FALSE
	if(!kits[selection] || kits[selection] <= 0)
		to_chat(user, SPAN_NOTICE("No more kits of this type may be chosen!!"))
		return FALSE
	if(!istype(user.wear_id, /obj/item/card/id))
		to_chat(user, SPAN_WARNING("You must be wearing your ID card to select a specialization!"))
		return
	var/obj/item/card/id/ID = user.wear_id
	if(ID.registered_ref != WEAKREF(user))
		to_chat(user, SPAN_WARNING("You must be wearing YOUR ID card to select a specialization!"))
		return
	var/turf/T = get_turf(loc)
	var/obj/item/storage/box/spec/spec_box
	var/specialist_assignment
	switch(selection)
		if("Pyro")
			spec_box = new /obj/item/storage/box/spec/pyro(T)
			specialist_assignment = "Pyro"
			user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_PYRO)
		if("Grenadier")
			spec_box = new /obj/item/storage/box/spec/heavy_grenadier(T)
			specialist_assignment = "Grenadier"
			user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)
		if("Sniper")
			spec_box = new /obj/item/storage/box/spec/sniper(T)
			specialist_assignment = "Sniper"
			user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SNIPER)
		if("Scout")
			spec_box = new /obj/item/storage/box/spec/scout(T)
			specialist_assignment = "Scout"
			user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SCOUT)
			user.skills.set_skill(SKILL_ENGINEER, SKILL_ENGINEER_TRAINED)
		if("Demo")
			spec_box = new /obj/item/storage/box/spec/demolitionist(T)
			specialist_assignment = "Demo"
			user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_ROCKET)
			user.skills.set_skill(SKILL_ENGINEER, SKILL_ENGINEER_TRAINED)
	if(specialist_assignment)
		user.put_in_hands(spec_box)
		ID.set_assignment(JOB_SQUAD_SPECIALIST + " ([specialist_assignment])")
		GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), ID.assignment)
		return TRUE
	return FALSE


//******************************************PFC Kits****************************************************************/

/obj/item/storage/box/kit
	desc = "Drag this sprite onto yourself to open it up!\nNOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/pro_case.dmi'
	icon_state = "pro_case_mini"
	w_class = SIZE_HUGE
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = TRUE
	var/pro_case_overlay

/obj/item/storage/box/kit/Initialize()
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	if(pro_case_overlay)
		overlays += image('icons/obj/items/pro_case.dmi', "+[pro_case_overlay]")

/obj/item/storage/box/kit/update_icon()
	if(!length(contents))
		qdel(src)


/obj/item/storage/box/kit/mou53_sapper
	name = "\improper M-OU53 Field Test Kit"
	pro_case_overlay = "mou53"

/obj/item/storage/box/kit/mou53_sapper/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/double/mou53(src)
	new /obj/item/attachable/stock/mou53(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/flechette(src)
	new /obj/item/storage/belt/shotgun(src)


/obj/item/storage/box/kit/machinegunner
	name = "\improper M2C Heavy Gunner Kit"
	pro_case_overlay = "hmg"

/obj/item/storage/box/kit/machinegunner/fill_preset_inventory()
	new /obj/item/storage/box/m56d/m2c(src)
	new /obj/item/storage/belt/marine/m2c(src)
	new /obj/item/clothing/head/helmet/marine/tech(src)
	new /obj/item/storage/pouch/tools/tank(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/pamphlet/skill/machinegunner(src)

/obj/item/storage/box/kit/defensegunner
	name = "\improper M56D Defense Gunner Kit"
	icon_state = "pro_case_large"
	pro_case_overlay = "m56d"

/obj/item/storage/box/kit/defensegunner/fill_preset_inventory()
	new /obj/item/storage/box/m56d_hmg(src)
	new /obj/item/storage/belt/marine/m2c(src)
	new /obj/item/clothing/head/helmet/marine/tech(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/pamphlet/skill/machinegunner(src)


/obj/item/storage/box/kit/mini_pyro
	name = "\improper M240 Pyrotechnician Support Kit"
	pro_case_overlay = "flamer"


/obj/item/storage/box/kit/mini_pyro/fill_preset_inventory()
	new /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit(src)
	new /obj/item/weapon/gun/flamer/underextinguisher(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/ammo_magazine/flamer_tank/gellied(src)
	new /obj/item/tool/extinguisher/mini(src)


/obj/item/storage/box/kit/mini_sniper
	name = "\improper L42A Sniper Kit"
	pro_case_overlay = "sniper"

/obj/item/storage/box/kit/mini_sniper/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/l42a(src)
	new /obj/item/attachable/scope(src)
	new /obj/item/attachable/suppressor(src)
	new /obj/item/attachable/extended_barrel(src)
	new /obj/item/ammo_magazine/rifle/l42a/ap(src)
	new /obj/item/ammo_magazine/rifle/l42a/ap(src)


/obj/item/storage/box/kit/heavy_support
	name = "\improper Forward HPR Shield Kit"
	pro_case_overlay = "shield"

/obj/item/storage/box/kit/heavy_support/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg/holo_target(src)
	new /obj/item/attachable/bipod(src)
	new /obj/item/stack/folding_barricade/three(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/tool/weldingtool(src)


/obj/item/storage/box/kit/pursuit
	name = "\improper M39 Point Man Kit"
	pro_case_overlay = "pursuit"

/obj/item/storage/box/kit/pursuit/fill_preset_inventory()
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/attachable/stock/smg/collapsible/brace(src)
	new /obj/item/attachable/magnetic_harness(src)
	new /obj/item/storage/large_holster/machete/full(src)
	new /obj/item/ammo_magazine/smg/m39/extended(src)


/obj/item/storage/box/kit/mini_engineer
	name = "\improper Combat Technician Support Kit"
	pro_case_overlay = "engi"

/obj/item/storage/box/kit/mini_engineer/fill_preset_inventory()
	new /obj/item/storage/backpack/marine/engineerpack(src)
	new /obj/item/pamphlet/skill/engineer(src)
	new /obj/item/clothing/gloves/marine/insulated(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/storage/pouch/tools/pfc(src)
	new /obj/item/stack/folding_barricade/three(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)


/obj/item/storage/box/kit/mini_medic
	name = "\improper First Responder Medical Support Kit"
	pro_case_overlay = "medic"

/obj/item/storage/box/kit/mini_medic/fill_preset_inventory()
	new /obj/item/pamphlet/skill/medical(src)
	new /obj/item/storage/pouch/medical/frt_kit/full(src)
	new /obj/item/storage/pouch/autoinjector/full(src)
	new /obj/item/clothing/glasses/hud/sensor(src)
	new /obj/item/roller(src)


/obj/item/storage/box/kit/mini_jtac
	name = "\improper JTAC Radio Kit"
	pro_case_overlay = "jtac"

/obj/item/storage/box/kit/mini_jtac/fill_preset_inventory()
	new /obj/item/weapon/gun/flare(src)
	new /obj/item/storage/belt/gun/flaregun/full_nogun(src)
	new /obj/item/storage/box/m94/signal(src)
	new /obj/item/storage/box/m94/signal(src)
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/encryptionkey/jtac(src)
	new /obj/item/storage/backpack/marine/satchel/rto/small(src)


/obj/item/storage/box/kit/mini_intel
	name = "\improper Field Intelligence Support Kit"
	pro_case_overlay = "intel"

/obj/item/storage/box/kit/mini_intel/fill_preset_inventory()
	new /obj/item/stack/fulton(src)
	new /obj/item/device/encryptionkey/tactics(src)


/obj/item/storage/box/kit/mini_grenadier
	name = "\improper Frontline M40 Grenadier Kit"
	pro_case_overlay = "grenadier"

/obj/item/storage/box/kit/mini_grenadier/fill_preset_inventory()
	new /obj/item/storage/belt/grenade/full(src)
	new /obj/item/storage/pouch/explosive(src)


/obj/item/storage/box/kit/self_defense
	name = "\improper Personal Self Defense Kit"
	pro_case_overlay = "defense"

/obj/item/storage/box/kit/self_defense/fill_preset_inventory()
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
	pro_case_overlay = "smart"

/obj/item/storage/box/kit/exp_trooper/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/attachable/extended_barrel(src)
	new /obj/item/attachable/lasersight(src)
	new /obj/item/storage/belt/gun/smartpistol(src)


/obj/item/storage/box/kit/honorguard
	name = "\improper Honor Guard Kit"
	pro_case_overlay = "honor_guard"

/obj/item/storage/box/kit/honorguard/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/packet/oxycodone(src)
	new /obj/item/storage/pill_bottle/packet/kelotane(src)
	new /obj/item/storage/pill_bottle/packet/bicardine(src)
	new /obj/item/weapon/gun/shotgun/combat/guard(src)
	new /obj/item/storage/pouch/general/large(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)