/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	flags_equip_slot = SLOT_WAIST
	attack_verb = list("whipped", "lashed", "disciplined")
	w_class = SIZE_LARGE
	storage_flags = STORAGE_FLAGS_POUCH
	cant_hold = list(/obj/item/weapon/melee/throwing_knife)
	///TRUE Means that it closes a flap over its contents, and therefore update_icon should lift that flap when opened. If it doesn't have _half and _full iconstates, this doesn't matter either way.
	var/flap = TRUE

/obj/item/storage/belt/equipped(mob/user, slot)
	switch(slot)
		if(WEAR_WAIST, WEAR_J_STORE, WEAR_BACK)
			mouse_opacity = 2 //so it's easier to click when properly equipped.
	..()

/obj/item/storage/belt/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/belt/update_icon()
	overlays.Cut()
	if(!length(contents))
		return
	if(content_watchers && flap) //If it has a flap and someone's looking inside it, don't close the flap.
		return
	else if(length(contents) <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/belt/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(/obj/item/clothing/mask/luchador)






//============================//MARINE BELTS\\==================================\\
//=======================================================================\\


/obj/item/storage/belt/utility
	name = "\improper M276 pattern toolbelt rig" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version lacks any combat functionality, and is commonly used by engineers to transport important tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/tool/shovel/etool,
	)
	bypass_w_limit = list(/obj/item/tool/shovel/etool)


/obj/item/storage/belt/utility/full/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	new /obj/item/device/multitool(src)


/obj/item/storage/belt/utility/atmostech/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/t_scanner(src)

/obj/item/storage/belt/medical
	name = "\improper M276 pattern medical storage rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is a less common configuration, designed to transport medical supplies and pistol ammunition."
	icon_state = "medicalbelt"
	item_state = "medical"
	storage_slots = 14
	max_w_class = SIZE_MEDIUM
	max_storage_space = 28
	var/mode = 0 //Pill picking mode

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/syringe,
		/obj/item/tool/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/gloves/latex,
		/obj/item/storage/syringe_case,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/handful,
		/obj/item/device/flashlight/flare,
		/obj/item/reagent_container/hypospray,
		/obj/item/bodybag,
		/obj/item/device/defibrillator,
		/obj/item/roller
	)

/obj/item/storage/belt/medical/full/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/storage/pill_bottle/quickclot(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)

/obj/item/storage/belt/medical/verb/toggle_mode() //A verb that can (should) only be used if in hand/equipped
	set category = "Object"
	set name = "Toggle Belt Mode"
	set src in usr
	if(src && ishuman(usr))
		mode = !mode
		to_chat(usr, SPAN_NOTICE("You will now [mode ? "take pills directly from bottles": "no longer take pills directly from bottles"]."))

/obj/item/storage/belt/medical/full/with_defib_and_analyzer

/obj/item/storage/belt/medical/full/with_defib_and_analyzer/fill_preset_inventory()
	. = ..()
	new /obj/item/device/defibrillator(src)
	new /obj/item/device/healthanalyzer(src)

/obj/item/storage/belt/medical/lifesaver
	name = "\improper M276 pattern lifesaver bag"
	desc = "The M276 is the standard load-bearing equipment of the USCM. This configuration mounts a duffel bag filled with a range of injectors and light medical supplies, and is common among medics."
	icon_state = "medicbag"
	item_state = "medicbag"
	storage_slots = 21 //can hold 3 "rows" of very limited medical equipment, but it *should* give a decent boost to squad medics.
	max_storage_space = 42
	max_w_class = SIZE_SMALL
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/bodybag,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_container/hypospray/autoinjector,
		/obj/item/stack/medical,
		/obj/item/device/defibrillator/compact
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/medical/lifesaver/full/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/storage/pill_bottle/quickclot(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/belt/medical/lifesaver/upp
	name = "\improper Type 41 pattern lifesaver bag"
	desc = "The Type 41 load rig is the standard load-bearing equipment of the UPP military. This configuration mounts a duffel bag filled with a range of injectors and light medical supplies, and is common among medics."
	icon_state = "medicbag_u"
	item_state = "medicbag_u"
	has_gamemode_skin = FALSE

/obj/item/storage/belt/medical/lifesaver/upp/full/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/storage/pill_bottle/quickclot(src)

/obj/item/storage/belt/security
	name = "\improper M276 pattern security rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This configuration is commonly seen among USCM Military Police and peacekeepers, though it can hold some light munitions."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21
	can_hold = list(
		/obj/item/explosive/grenade/flashbang,
		/obj/item/explosive/grenade/custom/teargas,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/handful,
		/obj/item/reagent_container/food/snacks/donut/normal,
		/obj/item/reagent_container/food/snacks/donut/jelly,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/tool/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight,
		/obj/item/device/radio/headset,
		/obj/item/weapon,
		/obj/item/device/clue_scanner
	)



/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	item_state_slots = list(
		WEAR_L_HAND = "upp_belt",
		WEAR_R_HAND = "upp_belt")
	storage_slots = 9
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21


/obj/item/storage/belt/security/MP
	name = "\improper M276 pattern military police rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is filled with an array of small pouches, meant to carry non-lethal equipment and restraints."
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	max_storage_space = 30


/obj/item/storage/belt/security/MP/full/fill_preset_inventory()
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/device/clue_scanner(src)


/obj/item/storage/belt/security/MP/UPP
	name = "\improper Type 43 military police rig"
	desc = "The Type 43 is the standard load-bearing equipment of the UPP. It consists of a modular belt with various clips. This version is filled with an array of small pouches, meant to carry non-lethal equipment and restraints."

/obj/item/storage/belt/security/MP/UPP/full/fill_preset_inventory()
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)


/obj/item/storage/belt/marine
	name = "\improper M276 pattern ammo load rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This is the standard variant, designed for bulk ammunition-carrying operations."
	icon_state = "marinebelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 5
	max_w_class = SIZE_MEDIUM
	max_storage_space = 20
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks
	)
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/marine/m41a/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle (src)

/obj/item/storage/belt/marine/m41amk1/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m41aMK1 (src)

/obj/item/storage/belt/marine/m39/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/m39 (src)

/obj/item/storage/belt/marine/quackers
	name = "Mr. Quackers"
	desc = "What are we going to do today, Mr. Quackers?"
	icon_state = "inflatable"
	item_state = "inflatable"
	item_state_slots = list(
		WEAR_L_HAND = "marinebelt",
		WEAR_R_HAND = "marinebelt")
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/upp
	name = "\improper Type 41 pattern load rig"
	desc = "The Type 41 load rig is the standard-issue load-bearing equipment of the UPP military. The primary function of this belt is to provide easy access to mags for the Type 71 during operations. Despite being designed for the Type 71 weapon system, the pouches are modular enough to fit other types of ammo and equipment."
	icon_state = "upp_belt"
	item_state = "upp_belt"
	has_gamemode_skin = FALSE

//version full of type 71 mags
/obj/item/storage/belt/marine/upp/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/belt/marine/upp/scarce/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/belt/marine/upp/sapper/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71/ap(src)
	new /obj/item/ammo_magazine/rifle/type71/ap(src)
	new /obj/item/ammo_magazine/rifle/type71/ap(src)

// M56E HMG gunner belt
/obj/item/storage/belt/marine/m2c
	name = "\improper M804 heavygunner storage rig"
	desc = "The M804 heavygunner storage rig is an M276 pattern toolbelt rig modified to carry ammunition for Heavy Machinegun Systems and engineering tools for the gunner."
	icon_state = "m2c_ammo_rig"
	item_state = "m2c_ammo_rig"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	storage_slots = 7
	max_w_class = SIZE_LARGE
	max_storage_space = 30
	can_hold = list(
		/obj/item/tool/weldingtool,
		/obj/item/tool/wrench,
		/obj/item/tool/screwdriver,
		/obj/item/tool/crowbar,
		/obj/item/tool/extinguisher/mini,
		/obj/item/explosive/plastic,
		/obj/item/explosive/mine,
		/obj/item/ammo_magazine/m2c,
		/obj/item/ammo_magazine/m56d
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/shotgun
	name = "\improper M276 pattern shotgun shell loading rig"
	desc = "An ammunition belt designed to hold shotgun shells or individual bullets."
	icon_state = "shotgunbelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14 // Make it FLUSH with the UI. *scream
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)
	flap = FALSE
	has_gamemode_skin = TRUE

/obj/item/storage/belt/shotgun/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		var/obj/item/ammo_magazine/handful/H = new(src)
		H.generate_handful(/datum/ammo/bullet/shotgun/slug, "12g", 5, 5, /obj/item/weapon/gun/shotgun)

/obj/item/storage/belt/shotgun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/shotgun/upp
	name = "\improper Type 42 pattern shotgun shell loading rig"
	desc = "An ammunition belt designed to hold shotgun shells, primarily for the Type 23 shotgun."
	icon_state = "shotgunbelt" //placeholder
	item_state = "marinebelt"
	storage_slots = 10

/obj/item/storage/belt/shotgun/upp/heavybuck/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(src)

/obj/item/storage/belt/shotgun/upp/heavyslug/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src)

/obj/item/storage/belt/shotgun/van_bandolier
	name = "two bore bandolier"
	desc = "A leather bandolier designed to hold extremely heavy shells. Can be attached to armour, worn over the back, or attached to belt loops."
	icon_state = "van_bandolier_5"
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	storage_slots = null
	max_storage_space = 20
	can_hold = list(/obj/item/ammo_magazine/handful/shotgun/twobore)
	has_gamemode_skin = FALSE
	item_state_slots = list(
		WEAR_J_STORE = "van_bandolier_10",
		WEAR_BACK = "van_bandolier_10",
		WEAR_WAIST = "van_bandolier_10"
		)

/obj/item/storage/belt/shotgun/van_bandolier/update_icon()
	var/mob/living/carbon/human/user = loc
	icon_state = "van_bandolier_[round(length(contents) * 0.5, 1)]"
	var/new_state = "van_bandolier_[length(contents)]"
	for(var/I in item_state_slots)
		item_state_slots[I] = new_state

	if(!istype(user))
		return
	if(src == user.s_store)
		user.update_inv_s_store()
	else if(src == user.belt)
		user.update_inv_belt()
	else if(src == user.back)
		user.update_inv_back()

/obj/item/storage/belt/shotgun/van_bandolier/fill_preset_inventory()
	for(var/i in 1 to max_storage_space * 0.5)
		new /obj/item/ammo_magazine/handful/shotgun/twobore(src)

/obj/item/storage/belt/shotgun/full/quackers
	icon_state = "inflatable"
	item_state = "inflatable"
	item_state_slots = list(
		WEAR_L_HAND = "marinebelt",
		WEAR_R_HAND = "marinebelt")
	name = "Mrs. Quackers"
	desc = "She always did have a meaner temper."
	has_gamemode_skin = FALSE

/obj/item/storage/belt/knifepouch
	name="\improper M276 pattern knife rig"
	desc="The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is specially designed to store knives. Not commonly issued, but kept in service."
	icon_state = "knifebelt"
	item_state = "marinebelt" // aslo temp, maybe somebody update these icons with better ones?
	w_class = SIZE_LARGE
	storage_slots = 12
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD
	max_w_class = SIZE_SMALL
	max_storage_space = 48
	can_hold = list(
		/obj/item/weapon/melee/throwing_knife,
		/obj/item/attachable/bayonet
	)
	cant_hold = list()
	flap = FALSE
	var/draw_cooldown = 0
	var/draw_cooldown_interval = 1 SECONDS

/obj/item/storage/belt/knifepouch/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/melee/throwing_knife(src)

/obj/item/storage/belt/knifepouch/_item_insertion(obj/item/W, prevent_warning = 0)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/belt/knifepouch/_item_removal(obj/item/W, atom/new_location)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/belt/knifepouch/attack_hand(mob/user, mods)
	if(draw_cooldown < world.time)
		..()
		draw_cooldown = world.time + draw_cooldown_interval
		playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
	else
		to_chat(user, SPAN_WARNING("You need to wait before drawing another knife!"))
		return FALSE

/obj/item/storage/belt/grenade
	name="\improper M276 pattern M40 Grenade rig"
	desc="The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is designed to carry bulk quantities of M40 pattern and AGM pattern Grenades."
	icon_state = "grenadebelt" // temp
	item_state = "grenadebelt"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	w_class = SIZE_LARGE
	storage_slots = 8
	max_w_class = SIZE_MEDIUM
	max_storage_space = 24
	can_hold = list(/obj/item/explosive/grenade)


/obj/item/storage/belt/grenade/full/fill_preset_inventory()
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)

/obj/item/storage/belt/grenade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box) || istype(W, /obj/item/storage/backpack/marine/grenadepack))
		dump_into(W,user)
	else
		return ..()

/obj/item/storage/belt/grenade/large
	name="\improper M276 pattern M40 Grenade rig Mk. II"
	desc="The M276 Mk. II is is an upgraded version of the M276 Grenade rig, with more storage capacity."
	storage_slots = 18
	max_storage_space = 54

/obj/item/storage/belt/grenade/large/full/fill_preset_inventory()
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)
	new /obj/item/explosive/grenade/HE/airburst(src)



/obj/item/storage/sparepouch
	name="\improper G8-A general utility pouch"
	desc="A small, lightweight pouch that can be clipped onto Armat Systems M3 Pattern armor to provide additional storage. The newer G8-A model, while uncomfortable, can also be clipped around the waist."
	storage_slots = 3
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_WAIST
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state="g8pouch"
	item_state="g8pouch"
	has_gamemode_skin = TRUE

/obj/item/storage/sparepouch/equipped(mob/user, slot)
	switch(slot)
		if(WEAR_WAIST, WEAR_J_STORE) //The G8 can be worn on several armours.
			mouse_opacity = 2 //so it's easier to click when properly equipped.
	..()

/obj/item/storage/sparepouch/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/sparepouch/update_icon()
	overlays.Cut()
	if(!length(contents))
		return
	if(content_watchers)
		return
	else if(length(contents) <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"


////////////////////////////// GUN BELTS /////////////////////////////////////

/obj/item/storage/belt/gun
	name = "pistol belt"
	desc = "A belt-holster assembly that allows one to hold a pistol and two magazines."
	icon_state = "m4a3_holster"
	item_state = "marinebelt" //see post_skin_selection() - this is used for inhand states, the belt sprites use the same filename as the icon state.
	use_sound = null
	w_class = SIZE_LARGE
	storage_slots = 5
	max_storage_space = 11
	max_w_class = SIZE_MEDIUM
	var/obj/item/weapon/gun/current_gun //The gun it holds, used for referencing later so we can update the icon.
	var/image/gun_underlay //The underlay we will use.
	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	var/icon_x = 0
	var/icon_y = 0
	///Some holsters can take both automatic pistols and the M44 revolver. The M44's sprite does not line up with automatics, and needs some massaging to fit.
	var/mixed_pistols = FALSE
	///Used to get flap overlay states as inserting a gun changes icon state.
	var/base_icon
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol
	)

/obj/item/storage/belt/gun/post_skin_selection()
	base_icon = icon_state
	//Saving current inhands, since we'll be switching item_state around for belt onmobs.
	item_state_slots[WEAR_L_HAND] = item_state
	item_state_slots[WEAR_R_HAND] = item_state
	//And switch to correct belt state in case we aren't spawning with a gun inserted.
	item_state = icon_state

/obj/item/storage/belt/gun/update_icon()
	overlays.Cut()

	if(content_watchers)
		return
	var/magazines = current_gun ? length(contents) - 1 : length(contents)
	if(!magazines)
		return
	if(magazines <= (storage_slots - 1) * 0.5) //Final slot is reserved for the gun.
		overlays += "+[base_icon]_half"
	else
		overlays += "+[base_icon]_full"

/obj/item/storage/belt/gun/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null
		update_gun_icon()

/obj/item/storage/belt/gun/attack_hand(mob/user, mods)
	if(current_gun && ishuman(user) && loc == user)
		if(mods && mods["alt"] && length(contents) > 1) //Withdraw the most recently inserted magazine, if possible.
			var/obj/item/I = contents[length(contents)]
			if(isgun(I))
				I = contents[length(contents) - 1]
			I.attack_hand(user)
		else
			current_gun.attack_hand(user)
		return

	..()


/obj/item/storage/belt/gun/proc/update_gun_icon() //We do not want to use regular update_icon as it's called for every item inserted. Not worth the icon math.
	var/mob/living/carbon/human/user = loc
	if(current_gun) //So it has a gun, let's make an icon.
		/*
		Have to use a workaround here, otherwise images won't display properly at all times.
		Reason being, transform is not displayed when right clicking/alt+clicking an object,
		so it's necessary to pre-load the potential states so the item actually shows up
		correctly without having to rotate anything. Preloading weapon icons also makes
		sure that we don't have to do any extra calculations.
		*/
		playsound(src, drawSound, 15, TRUE)
		gun_underlay = image(icon, src, current_gun.base_gun_icon)
		if(mixed_pistols && !istype(current_gun,/obj/item/weapon/gun/pistol)) //The M44 doesn't line up with the sprites automatic pistols use. These numbers mostly work with the flare pistol, mateba, and smartpistol as well.
			gun_underlay.pixel_x = icon_x + 1
			gun_underlay.pixel_y = icon_y + 3
		else
			gun_underlay.pixel_x = icon_x
			gun_underlay.pixel_y = icon_y
		gun_underlay.color = current_gun.color
		icon_state += "_g"
		item_state = icon_state
		underlays += gun_underlay
	else
		playsound(src, sheatheSound, 15, TRUE)
		underlays -= gun_underlay
		icon_state = copytext(icon_state,1,-2)
		item_state = icon_state
		gun_underlay = null
	if(istype(user))
		if(src == user.belt)
			user.update_inv_belt()
		else if(src == user.s_store)
			user.update_inv_s_store()


//There are only two types here that can be inserted, and they are mutually exclusive. We only track the gun.
/obj/item/storage/belt/gun/can_be_inserted(obj/item/W, stop_messages) //We don't need to stop messages, but it can be left in.
	if( ..() ) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(isgun(W))
			if(current_gun)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
				return
		else //Must be ammo.
			var/ammo_slots = storage_slots - 1 //We have a slot reserved for the gun
			var/ammo_stored = length(contents)
			if(current_gun)
				ammo_stored -= 1
			if(ammo_stored >= ammo_slots)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] can't hold any more magazines."))
				return
		return 1

/obj/item/weapon/gun/on_enter_storage(obj/item/storage/belt/gun/gun_belt)
	..()
	if(istype(gun_belt) && !gun_belt.current_gun)
		gun_belt.current_gun = src //If there's no active gun, we want to make this our icon.
		gun_belt.update_gun_icon()

/obj/item/weapon/gun/on_exit_storage(obj/item/storage/belt/gun/gun_belt)
	..()
	if(istype(gun_belt) && gun_belt.current_gun == src)
		gun_belt.current_gun = null
		gun_belt.update_gun_icon()

/obj/item/storage/belt/gun/m4a3
	name = "\improper M276 pattern general pistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version has a holster assembly that allows one to carry the most common pistols. It also contains side pouches that can store most pistol magazines."
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy/super,
		/obj/item/ammo_magazine/pistol/heavy/super/highimpact
	)
	cant_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/m4a3/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/commander/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3/custom(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/mod88/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/mod88(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/mod88(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/vp78/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/vp78(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp78(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/m1911/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/heavy/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/heavy/co/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/heavy/co(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/heavy/co_golden/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/heavy/co/gold(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m44
	name = "\improper M276 pattern M44 holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the M44 magnum revolver, along with six small pouches for speedloaders. It smells faintly of hay."
	icon_state = "m44r_holster"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/ammo_magazine/revolver
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/m44/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/m44(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m44/custom/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/m44/custom(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba
	name = "\improper M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, along with five small pouches for speedloaders. This one is aging poorly, and seems to be surplus equipment. It's stamped '3rd 'Dust Raiders' Battalion'."
	icon_state = "s_cmateba_holster"
	item_state = "s_marinebelt"
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/weapon/gun/revolver/mateba,
		/obj/item/ammo_magazine/revolver/mateba/highimpact,
		/obj/item/ammo_magazine/revolver/mateba
	)

/obj/item/storage/belt/gun/mateba/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/cmateba
	name = "\improper M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, along with five small pouches for speedloaders. It was included with the mail-order USCM edition of the Mateba autorevolver in the early 2170s."
	icon_state = "cmateba_holster"
	item_state = "marinebelt"
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/mateba/cmateba/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/cmateba(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/commodore
	name = "commodore's M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. \
	It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, \
	along with five small pouches for speedloaders. This specific one is tinted black and engraved with gold, heavily customized for a high-ranking official."

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/commodore/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/engraved(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/admiral
	name = "admiral's M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. \
	It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, \
	along with five small pouches for speedloaders. This specific one is tinted black and engraved with gold, heavily customized for a high-ranking official."

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/admiral/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/admiral(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/admiral/impact/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/admiral(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/admiral/santa/fill_preset_inventory()
	var/obj/item/weapon/gun/revolver/new_gun = new /obj/item/weapon/gun/revolver/mateba/admiral/santa(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/type47
	name = "\improper Type 47 pistol holster rig"
	desc = "This UPP-designed sidearm rig can very snugly and securely fit either a Nagant-Yamasaki revolver or a Korovin PK-9, and both their magazines or speedloaders. However, it lacks versatility in stored weaponry."
	icon_state = "korovin_holster"
	item_state = "upp_belt"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99/tranq,
		/obj/item/weapon/gun/revolver/nagant,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp/shrapnel
	)

/obj/item/storage/belt/gun/type47/PK9/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/c99/upp(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/c99(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/type47/PK9/tranq/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/c99/upp/tranq(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/c99/tranq(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/type47/NY/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/nagant(src)
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/type47/NY/shrapnel/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/nagant/shrapnel(src)
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp/shrapnel(src)
	new_gun.on_enter_storage(src)

//Crazy Ivan's belt reskin
/obj/item/storage/belt/gun/type47/ivan
	name = "The Rack"
	desc = "From the formless void, there springs an entity more primordial than the elements themselves. In its wake, there will follow a storm."
	icon_state = "ivan_belt"
	storage_slots = 56
	max_storage_space = 56
	has_gamemode_skin = FALSE
	max_w_class = SIZE_MASSIVE
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine
	)

/obj/item/storage/belt/gun/type47/ivan/Initialize()
	. = ..()
	var/list/bad_mags = typesof(/obj/item/ammo_magazine/hardpoint) + /obj/item/ammo_magazine/handful + /obj/item/ammo_magazine/handful/shotgun/custom_color + /obj/item/ammo_magazine/flamer_tank/empty + /obj/item/ammo_magazine/flamer_tank/large/empty + /obj/item/ammo_magazine/flamer_tank/custom + /obj/item/ammo_magazine/rocket/custom + /obj/item/ammo_magazine/smg
	var/list/sentry_mags = typesof(/obj/item/ammo_magazine/sentry) + typesof(/obj/item/ammo_magazine/sentry_flamer) + /obj/item/ammo_magazine/m56d + /obj/item/ammo_magazine/m2c
	var/list/internal_mags = (typesof(/obj/item/ammo_magazine/internal) + /obj/item/ammo_magazine/handful)
	var/list/training_mags = list(
		/obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/l42a/rubber,
		/obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/pistol/rubber,
		/obj/item/ammo_magazine/pistol/mod88/rubber) //Ivan doesn't bring children's ammo.

	var/list/picklist = subtypesof(/obj/item/ammo_magazine) - (internal_mags + bad_mags + sentry_mags + training_mags)
	var/random_mag = pick(picklist)
	var/guntype = pick(subtypesof(/obj/item/weapon/gun/revolver) + subtypesof(/obj/item/weapon/gun/pistol) - list(/obj/item/weapon/gun/pistol/m4a3/training, /obj/item/weapon/gun/pistol/mod88/training))
	var/obj/item/weapon/gun/sidearm = new guntype(src)
	sidearm.on_enter_storage(src)	
	for(var/total_storage_slots in 2 to storage_slots) //minus templates
		new random_mag(src)
		random_mag = pick(picklist)

/obj/item/storage/belt/gun/smartpistol
	name = "\improper M276 pattern SU-6 Smartpistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the SU-6 smartpistol."
	icon_state = "smartpistol_holster"
	storage_slots = 6
	icon_x = -5
	icon_y = -2
	can_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartpistol/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/smart(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/smart(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/flaregun
	name = "\improper M276 pattern M82F flare gun holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the M82F flare gun."
	storage_slots = 17
	max_storage_space = 20
	icon_state = "m82f_holster"
	item_state = "s_marinebelt"
	can_hold = list(
		/obj/item/weapon/gun/flare,
		/obj/item/device/flashlight/flare
	)

/obj/item/storage/belt/gun/flaregun/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/flare(src)
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/device/flashlight/flare(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/flaregun/full_nogun/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/belt/gun/flaregun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/gun/webley
	name = "\improper Webley Mk VI gunbelt"
	desc = "Finely-tooled British leather, a Webley, and six speedloaders of .455. More than enough to kill anything with legs."
	icon_state = "m44r_holster"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/revolver/m44/custom/webley,
		/obj/item/ammo_magazine/revolver
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/webley/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/m44/custom/webley(src)
	for(var/i in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/webley(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/smartgunner
	name = "\improper M802 pattern smartgunner rig"
	desc = "The M802 is a limited-issue mark of USCM load-bearing equipment, designed to carry smartgun ammunition and a sidearm."
	icon_state = "sgbelt"
	icon_x = 5
	icon_y = -2
	mixed_pistols = TRUE
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartgunner/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/smartgunner/pmc/full/fill_preset_inventory()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mortarbelt
	name="\improper M276 pattern mortar operator belt"
	desc="An M276 load-bearing rig configured to carry ammunition for the M402 mortar, along with a sidearm."
	icon_state="mortarbelt"
	icon_x = 11
	icon_y = 0
	mixed_pistols = TRUE
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/weapon/gun/flare,
		/obj/item/mortar_shell
	)
	bypass_w_limit = list(/obj/item/mortar_shell)
	has_gamemode_skin = TRUE

////////////OTHER BELTS//////////////

/obj/item/storage/belt/tank
	name = "\improper M103 pattern vehicle ammo rig"
	desc = "The M103 is a limited-issue mark of USCM load-bearing equipment, made specially for crewmen to carry their vehicle's ammunition."
	icon_state = "tankbelt"
	item_state = "tankbelt"
	item_state_slots = list(
		WEAR_L_HAND = "utility",
		WEAR_R_HAND = "utility")
	storage_slots = 2 //can hold 2 only two large items such as Tank Ammo.
	max_w_class = SIZE_LARGE
	max_storage_space = 2
	can_hold = list(
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/flare_launcher
	)

/obj/item/storage/belt/souto
	name = "\improper Souto belt"
	desc = "Souto Man's trusty utility belt with break away Souto cans. They cannot be put back."
	icon_state = "souto_man"
	item_state = "souto_man"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	flags_equip_slot = SLOT_WAIST
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD
	storage_slots = 8
	flags_inventory = CANTSTRIP
	max_w_class = 0 //this belt cannot hold anything

/obj/item/storage/belt/souto/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_container/food/drinks/cans/souto/classic(src)

/obj/item/storage/belt/souto/update_icon()
	var/mob/living/carbon/human/user = loc
	item_state = "souto_man[length(contents)]"
	if(istype(user))
		user.update_inv_belt() //Makes sure the onmob updates.
