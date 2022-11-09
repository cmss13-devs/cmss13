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
		if(/obj/item/ammo_magazine/handful in src.can_hold)
			var/obj/item/ammo_magazine/shotgun/M = W
			dump_ammo_to(M,user, M.transfer_handful_amount)
			return
	. = ..()


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
		/obj/item/tool/extinguisher/mini,
		/obj/item/cell,
		/obj/item/device/lightreplacer

	)
	bypass_w_limit = list(
	/obj/item/tool/shovel/etool,
	/obj/item/device/lightreplacer
	)


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
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is a less common configuration, designed to transport medical supplies and pistol ammunition. \nRight click its sprite and click \"toggle belt mode\" to take pills out of bottles by simply clicking them."
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
		/obj/item/tool/surgery/surgical_line,
		/obj/item/device/reagent_scanner,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/roller,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/reagent_container/glass/minitank
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

/obj/item/storage/belt/medical/full/with_defib_and_analyzer/fill_preset_inventory()
	. = ..()
	new /obj/item/device/defibrillator(src)
	new /obj/item/device/healthanalyzer(src)

/obj/item/storage/belt/medical/full/with_suture_and_graft/fill_preset_inventory()
	. = ..()
	new	/obj/item/tool/surgery/surgical_line(src)
	new	/obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/belt/medical/get_examine_text()
	. = ..()
	. += SPAN_NOTICE("The belt is currently set to [mode ? "take pills directly from bottles": "NOT take pills directly from bottles"].")

/obj/item/storage/belt/medical/lifesaver
	name = "\improper M276 pattern lifesaver bag"
	desc = "The M276 is the standard load-bearing equipment of the USCM. This configuration mounts a duffel bag filled with a range of injectors and light medical supplies, and is common among medics. \nRight click its sprite and click \"toggle belt mode\" to take pills out of bottles by simply clicking them."
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
		/obj/item/device/defibrillator/compact,
		/obj/item/device/reagent_scanner,
		/obj/item/device/analyzer/plant_analyzer
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

/obj/item/storage/belt/medical/lifesaver/full/dutch/fill_preset_inventory()
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
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/pill_bottle/imidazoline(src)
	new /obj/item/storage/pill_bottle/alkysine(src)

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

/obj/item/storage/belt/marine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/marine/dutch
	name = "ammo load rig"
	desc = "Good for carrying around extra ammo in the heat of the jungle. Made of special rot-resistant fabric."

/obj/item/storage/belt/marine/dutch/m16/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16 (src)

/obj/item/storage/belt/marine/dutch/m16/ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16/ap (src)

// Outer Rim Weapon Belts

/obj/item/storage/belt/marine/m16/fill_preset_inventory() // M16
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16 (src)

/obj/item/storage/belt/marine/m16/ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16/ap (src)

/obj/item/storage/belt/marine/mar40/fill_preset_inventory() // Mar40
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40 (src)

/obj/item/storage/belt/marine/mar40/drum/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40/lmg (src)

/obj/item/storage/belt/marine/mar40/extended/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40/extended (src)

/obj/item/storage/belt/marine/mp5/fill_preset_inventory() // MP5
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/mp5 (src)

/obj/item/storage/belt/marine/hunting/fill_preset_inventory() // Hunting Rifle
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/hunting(src)

/obj/item/storage/belt/marine/fp9000/fill_preset_inventory() // FP9000
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/fp9000(src)

/obj/item/storage/belt/marine/nsg23/fill_preset_inventory() // NSG23
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/nsg23(src)



/obj/item/storage/belt/marine/smartgunner
	name = "\improper M280 pattern smartgunner drum belt"
	desc = "Despite the fact that 1. drum magazines are incredibly non-ergonomical, and 2. require incredibly precise machining in order to fit universally (spoiler, they don't, adding further to the myth of 'Smartgun Personalities'), the USCM decided to issue a modified marine belt (more formally known by the designation M280) with hooks and dust covers (overly complex for the average jarhead) for the M56B system's drum munitions. When the carry catch on the drum isn't getting stuck in the oiled up velcro, the rig actually does do a decent job at holding a plentiful amount of drums. But at the end of the day, compared to standard rigs... it sucks, but isn't that what being a Marine is all about?"
	icon_state = "sgbelt_ammo"
	storage_slots = 6
	bypass_w_limit = list(
		/obj/item/ammo_magazine/smartgun
	)
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/smartgun,
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

/obj/item/storage/belt/marine/smartgunner/fill_preset_inventory()
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

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
		/obj/item/tool/wirecutters,
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
		new /obj/item/ammo_magazine/handful/shotgun/slug(src)

/obj/item/storage/belt/shotgun/full/random/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		var/random_shell_type = pick(shotgun_handfuls_12g)
		new random_shell_type(src)

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
		LAZYSET(item_state_slots, I, new_state)

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


/obj/item/storage/belt/shotgun/lever_action
	name = "\improper M276 pattern 45-70 loading rig"
	desc = "An ammunition belt designed to hold the large 45-70 Govt. caliber bullets for the R4T lever-action rifle."
	icon_state = "r4t-ammobelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)

/obj/item/storage/belt/shotgun/lever_action/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action))
		var/obj/item/ammo_magazine/lever_action/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)

	if(istype(W, /obj/item/storage/belt/gun/m44/lever_action/attach_holster))
		if(length(contents) || length(W.contents))
			to_chat(user, SPAN_WARNING("Both holster and belt need to be empty to attach the holster!"))
			return
		to_chat(user, SPAN_NOTICE("You attach the holster to the belt, reducing total storage capacity but allowing it to fit the M44 revolver and its speedloaders."))
		var/obj/item/storage/belt/gun/m44/lever_action/new_belt = new /obj/item/storage/belt/gun/m44/lever_action
		qdel(W)
		qdel(src)
		user.put_in_hands(new_belt)
		update_icon(user)
	else
		return ..()

/obj/item/storage/belt/shotgun/xm88
	name = "\improper M300 pattern .458 SOCOM loading rig"
	desc = "An ammunition belt designed to hold the large .458 SOCOM caliber bullets for the XM88 heavy rifle."
	icon_state = "boomslang-belt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)

/obj/item/storage/belt/shotgun/xm88/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action/xm88))
		var/obj/item/ammo_magazine/lever_action/xm88/B = W
		dump_ammo_to(B, user, B.transfer_handful_amount)
	else
		return ..()

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
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
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
	storage_slots = 12
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
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_ALLOW_QUICKDRAW
	///Array of holster slots and stats to use for them. First layer is "1", "2" etc. Guns are stored in both the slot and the holstered_guns list which keeps track of which was last inserted.
	var/list/obj/item/weapon/gun/holster_slots = list(
		"1" = list(
			"gun" = null,
			"underlay_sprite" = null,
			"underlay_transform" = null,
			"icon_x" = 0,
			"icon_y" = 0))

	var/list/holstered_guns = list()

	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	///Used to get flap overlay states as inserting a gun changes icon state.
	var/base_icon
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol
	)

/obj/item/storage/belt/gun/post_skin_selection()
	base_icon = icon_state
	//Saving current inhands, since we'll be switching item_state around for belt onmobs.
	LAZYSET(item_state_slots, WEAR_L_HAND, item_state)
	LAZYSET(item_state_slots, WEAR_R_HAND, item_state)
	//And switch to correct belt state in case we aren't spawning with a gun inserted.
	item_state = icon_state

/obj/item/storage/belt/gun/update_icon()
	overlays.Cut()

	if(content_watchers && flap)
		return
	var/magazines = length(contents) - length(holstered_guns)
	if(!magazines)
		return
	if(magazines <= (storage_slots - length(holster_slots)) * 0.5) //Don't count slots reserved for guns, even if they're empty.
		overlays += "+[base_icon]_half"
	else
		overlays += "+[base_icon]_full"

/obj/item/storage/belt/gun/on_stored_atom_del(atom/movable/AM)
	if(!isgun(AM))
		return
	holstered_guns -= AM
	for(var/slot in holster_slots)
		if(AM == holster_slots[slot]["gun"])
			holster_slots[slot]["gun"] = null
			update_gun_icon(slot)
			return

/obj/item/storage/belt/gun/attack_hand(mob/user, mods)
	if(length(holstered_guns) && ishuman(user) && loc == user)
		var/obj/item/I
		if(mods && mods["alt"] && length(contents) > length(holstered_guns)) //Withdraw the most recently inserted magazine, if possible.
			var/list/magazines = contents - holstered_guns
			I = magazines[length(magazines)]
		else //Otherwise find and draw the last-inserted gun.
			I = holstered_guns[length(holstered_guns)]
		I.attack_hand(user)
		return

	..()

/obj/item/storage/belt/gun/proc/update_gun_icon(slot) //We do not want to use regular update_icon as it's called for every item inserted. Not worth the icon math.
	var/mob/living/carbon/human/user = loc
	var/obj/item/weapon/gun/current_gun = holster_slots[slot]["gun"]
	if(current_gun)
		/*
		Have to use a workaround here, otherwise images won't display properly at all times.
		Reason being, transform is not displayed when right clicking/alt+clicking an object,
		so it's necessary to pre-load the potential states so the item actually shows up
		correctly without having to rotate anything. Preloading weapon icons also makes
		sure that we don't have to do any extra calculations.
		*/
		playsound(src, drawSound, 7, TRUE)
		var/image/gun_underlay = image(icon, current_gun.base_gun_icon)
		gun_underlay.pixel_x = holster_slots[slot]["icon_x"]
		gun_underlay.pixel_y = holster_slots[slot]["icon_y"]
		gun_underlay.color = current_gun.color
		gun_underlay.transform = holster_slots[slot]["underlay_transform"]
		holster_slots[slot]["underlay_sprite"] = gun_underlay
		underlays += gun_underlay

		icon_state += "_g"
		item_state = icon_state
	else
		playsound(src, sheatheSound, 7, TRUE)
		underlays -= holster_slots[slot]["underlay_sprite"]
		holster_slots[slot]["underlay_sprite"] = null

		icon_state = copytext(icon_state,1,-2)
		item_state = icon_state

	if(istype(user))
		if(src == user.belt)
			user.update_inv_belt()
		else if(src == user.s_store)
			user.update_inv_s_store()

//There are only two types here that can be inserted, and they are mutually exclusive. We only track the gun.
/obj/item/storage/belt/gun/can_be_inserted(obj/item/W, stop_messages) //We don't need to stop messages, but it can be left in.
	. = ..()
	if(!.)
		return

	if(isgun(W))
		for(var/slot in holster_slots)
			if(!holster_slots[slot]["gun"]) //Open holster.
				return

		if(!stop_messages) //No open holsters.
			if(length(holster_slots) == 1)
				to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
			else
				to_chat(usr, SPAN_WARNING("[src] doesn't have any empty holsters."))
		return FALSE

	else if(length(contents) - length(holstered_guns) >= storage_slots - length(holster_slots)) //Compare amount of nongun items in storage with usable ammo pockets.
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] can't hold any more ammo."))
		return FALSE

/obj/item/storage/belt/gun/_item_insertion(obj/item/W, prevent_warning = 0)
	if(isgun(W))
		holstered_guns += W
		for(var/slot in holster_slots)
			if(holster_slots[slot]["gun"])
				continue
			holster_slots[slot]["gun"] = W
			update_gun_icon(slot)
			break
	..()

/obj/item/storage/belt/gun/_item_removal(obj/item/W, atom/new_location)
	if(isgun(W))
		holstered_guns -= W
		for(var/slot in holster_slots)
			if(holster_slots[slot]["gun"] != W)
				continue
			holster_slots[slot]["gun"] = null
			update_gun_icon(slot)
			break
	..()

/obj/item/storage/belt/gun/dump_ammo_to(obj/item/ammo_magazine/ammo_dumping, mob/user, amount_to_dump)
	if(user.action_busy)
		return

	if(ammo_dumping.flags_magazine & AMMUNITION_HANDFUL_BOX)
		var/handfuls = round(ammo_dumping.current_rounds / amount_to_dump, 1) //The number of handfuls, we round up because we still want the last one that isn't full
		if(ammo_dumping.current_rounds != 0)
			if(contents.len < storage_slots - 1) //this is because it's a gunbelt and the final slot is reserved for the gun
				to_chat(user, SPAN_NOTICE("You start refilling [src] with [ammo_dumping]."))
				if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
				for(var/i = 1 to handfuls)
					if(contents.len < storage_slots - 1)
						var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
						var/transferred_handfuls = min(ammo_dumping.current_rounds, amount_to_dump)
						new_handful.generate_handful(ammo_dumping.default_ammo, ammo_dumping.caliber, amount_to_dump, transferred_handfuls, ammo_dumping.gun_type)
						ammo_dumping.current_rounds -= transferred_handfuls
						handle_item_insertion(new_handful, TRUE,user)
						update_icon(-transferred_handfuls)
					else
						break
				playsound(user.loc, "rustle", 15, TRUE, 6)
				ammo_dumping.update_icon()
			else
				to_chat(user, SPAN_WARNING("[src] is full."))


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
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/belt/gun/m4a3/commander/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3/custom())
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/belt/gun/m4a3/mod88/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/mod88())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/mod88(src)

/obj/item/storage/belt/gun/m4a3/mod88_near_empty/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/mod88())
	for(var/i = 1 to 3)
		new /obj/item/ammo_magazine/pistol/mod88(src)

/obj/item/storage/belt/gun/m4a3/vp78/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp78(src)

/obj/item/storage/belt/gun/m4a3/m1911/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911())
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/belt/gun/m4a3/m1911/socom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911/socom())
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/belt/gun/m4a3/heavy/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy())
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)

/obj/item/storage/belt/gun/m4a3/heavy/co/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy/co())
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)

/obj/item/storage/belt/gun/m4a3/heavy/co_golden/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy/co/gold())
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)
	new /obj/item/ammo_magazine/pistol/heavy/super(src)

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
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/m44/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/custom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/custom())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/mp/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/mp())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/gunslinger
	name = "custom-tooled gunslinger's belt"
	desc = "It's always high noon <i>somewhere</i>."
	icon_state = "gunslinger_holster"
	storage_slots = 6
	can_hold = list(
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver
	)
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list("icon_x" = -9, "icon_y" = -3),
		"2" = list("icon_x" = 9, "icon_y" = -3))

/obj/item/storage/belt/gun/m44/gunslinger/Initialize()
	var/matrix/M = matrix()
	M.Scale(-1, 1) //Flip the sprite of the second gun.
	holster_slots["2"]["underlay_transform"] = M
	. = ..()

/obj/item/storage/belt/gun/m44/gunslinger/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	for(var/i = 1 to storage_slots - 2)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/lever_action
	name = "\improper M276 pattern 45-70 revolver rig"
	desc = "An ammunition belt designed to hold the large 45-70 Govt. caliber bullets for the R4T lever-action rifle. This version has reduced capacity in exchange for a whole revolver holster."
	icon_state = "r4t-cowboybelt"
	item_state = "r4t-cowboybelt"
	w_class = SIZE_LARGE
	storage_slots = 11
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_magazine/handful,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver
		)
	flap = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = 10,
			"icon_y" = 3))

/obj/item/storage/belt/gun/m44/lever_action/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action))
		var/obj/item/ammo_magazine/lever_action/M = W
		dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()


obj/item/storage/belt/gun/m44/lever_action/verb/detach_holster()
	set category = "Object"
	set name = "Detach Revolver Holster"
	set src in usr
	if(ishuman(usr))
		if(contents.len)
			to_chat(usr, SPAN_WARNING("The belt needs to be fully empty to remove the holster!"))
			return
		to_chat(usr, SPAN_NOTICE("You detach the holster from the belt."))
		var/obj/item/storage/belt/shotgun/lever_action/new_belt = new /obj/item/storage/belt/shotgun/lever_action
		var/obj/item/storage/belt/gun/m44/lever_action/attach_holster/new_holster = new /obj/item/storage/belt/gun/m44/lever_action/attach_holster
		qdel(src)
		usr.put_in_hands(new_belt)
		usr.put_in_hands(new_holster)
		update_icon(usr)
	else
		return

/obj/item/storage/belt/gun/m44/lever_action/attach_holster
	name = "\improper M276 revolver holster attachment"
	desc = "This holster can be instantly attached to an empty M276 45-70 rig, giving up some storage space in exchange for holding a sidearm. You could also clip it to your belt standalone if you really wanted to."
	icon_state = "r4t-attach-holster"
	item_state = "r4t-attach-holster"
	w_class = SIZE_LARGE
	storage_slots = 1
	max_storage_space = 1
	can_hold = list(
		/obj/item/weapon/gun/revolver
	)

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
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/mateba/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)

/obj/item/storage/belt/gun/mateba/cmateba
	name = "\improper M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, along with five small pouches for speedloaders. It was included with the mail-order USCM edition of the Mateba autorevolver in the early 2170s."
	icon_state = "cmateba_holster"
	item_state = "marinebelt"
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/mateba/cmateba/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/cmateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)

/obj/item/storage/belt/gun/mateba/council
	name = "colonel's M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. \
	It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, \
	along with five small pouches for speedloaders. This specific one is tinted black and engraved with gold, heavily customized for a high-ranking official."

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/council/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/engraved())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)

/obj/item/storage/belt/gun/mateba/general
	name = "general's M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. \
	It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, \
	along with five small pouches for speedloaders. This specific one is tinted black and engraved with gold, heavily customized for a high-ranking official."

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/general/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

/obj/item/storage/belt/gun/mateba/general/impact/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

/obj/item/storage/belt/gun/mateba/general/santa/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general/santa())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)

/obj/item/storage/belt/gun/mateba/pmc
	name = "PMC M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. \
	It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, \
	along with five small pouches for speedloaders. This specific one is tinted black and engraved with gold, heavily customized for a high-ranking official."

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/pmc/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

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
	holster_slots = list("1" = list("icon_x" = -1))

/obj/item/storage/belt/gun/type47/PK9/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/c99/upp())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/c99(src)

/obj/item/storage/belt/gun/type47/PK9/tranq/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/c99/upp/tranq())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/c99/tranq(src)

/obj/item/storage/belt/gun/type47/NY/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/nagant())
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp(src)

/obj/item/storage/belt/gun/type47/NY/shrapnel/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/nagant/shrapnel())
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp/shrapnel(src)

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
	handle_item_insertion(new guntype())
	for(var/total_storage_slots in 2 to storage_slots) //minus templates
		new random_mag(src)
		random_mag = pick(picklist)

/obj/item/storage/belt/gun/smartpistol
	name = "\improper M276 pattern SU-6 Smartpistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the SU-6 smartpistol."
	icon_state = "smartpistol_holster"
	storage_slots = 6
	holster_slots = list(
		"1" = list(
			"icon_x" = -5,
			"icon_y" = -2))
	can_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartpistol/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/smart())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/smart(src)

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
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/flaregun/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/flare())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/device/flashlight/flare(src)

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
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/webley/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/custom/webley())
	for(var/i in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/webley(src)

/obj/item/storage/belt/gun/smartgunner
	name = "\improper M802 pattern smartgunner sidearm rig"
	desc = "The M802 is a limited-issue mark of USCM load-bearing equipment, designed to carry smartgun ammunition and a sidearm."
	icon_state = "sgbelt"
	holster_slots = list(
		"1" = list(
			"icon_x" = 5,
			"icon_y" = -2))
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
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3())
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/gun/smartgunner/pmc
	name = "\improper M802 pattern 'Dirty' smartgunner sidearm rig"
	desc = "A modification of the standard M802 load-bearing equipment, designed to carry smartgun ammunition and a Mateba revolver."
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/weapon/gun/revolver/mateba,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/mateba,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartgunner/pmc/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)

/obj/item/storage/belt/gun/smartgunner/clf
	name = "\improper M802 pattern 'Freedom' smartgunner sidearm rig"
	desc = "A modification of the standard M802 load-bearing equipment, designed to carry smartgun ammunition and a Mateba revolver. This one has the CLF logo carved over the manufacturing stamp."
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/weapon/gun/revolver/mateba,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/mateba,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun
	)
	has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartgunner/clf/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/gun/mortarbelt
	name="\improper M276 pattern mortar operator belt"
	desc="An M276 load-bearing rig configured to carry ammunition for the M402 mortar, along with a sidearm."
	icon_state="mortarbelt"
	holster_slots = list("1" = list("icon_x" = 11))
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
	desc = "Souto Man's trusty utility belt with breakaway Souto cans. They cannot be put back."
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
