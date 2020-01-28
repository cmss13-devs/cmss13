/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	flags_equip_slot = SLOT_WAIST
	attack_verb = list("whipped", "lashed", "disciplined")
	w_class = SIZE_LARGE
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_ALLOW_DRAWING_METHOD_TOGGLE

/obj/item/storage/belt/equipped(mob/user, slot)
	if(slot == WEAR_WAIST)
		mouse_opacity = 2 //so it's easier to click when properly equipped.
	..()

/obj/item/storage/belt/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

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
		/obj/item/tool/shovel/etool
	)
	bypass_w_limit = list(/obj/item/tool/shovel/etool)


/obj/item/storage/belt/utility/full/New()
	..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	new /obj/item/device/multitool(src)


/obj/item/storage/belt/utility/atmostech/New()
	..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/t_scanner(src)

/obj/item/storage/belt/medical
	name = "\improper M276 pattern medical storage rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is a less common configuration, designed to transport medical supplies, and light ammunitions."
	icon_state = "medicalbelt"
	item_state = "medical"
	storage_slots = 14 //can hold about 3 "rows" of very limited medical equipment and ammo.
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

/obj/item/storage/belt/medical/New()
	..()
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

	if(src && ishuman(usr))
		mode = !mode
		to_chat(usr, SPAN_NOTICE("You will now [mode ? "take pills directly from bottles": "no longer take pills directly from bottles"]."))

/obj/item/storage/belt/medical/with_defib_and_analyzer

/obj/item/storage/belt/medical/with_defib_and_analyzer/New()
	..()
	new /obj/item/device/defibrillator(src)
	new /obj/item/device/healthanalyzer(src)

/obj/item/storage/belt/medical/combatLifesaver
	name = "\improper M276 pattern lifesaver bag"
	desc = "The M276 is the standard load-bearing equipment of the USCM. This configuration mounts a duffel bag filled with a range of injectors and light medical supplies and is common among medics."
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
		/obj/item/stack/medical
	)
	var/has_gamemode_skin = TRUE //whether it has a sprite for each gamemode.

/obj/item/storage/belt/medical/combatLifesaver/New()  //The belt, with all it's magic inside!
	..()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)

	if(has_gamemode_skin)
		select_gamemode_skin(type)

/obj/item/storage/belt/medical/combatLifesaver/upp
	name = "\improper Type 41 pattern lifesaver bag"
	desc = "The Type 41 load rig is the standard load-bearing equipment of the UPP military. This configuration mounts a duffel bag filled with a range of injectors and light medical supplies and is common among medics."
	icon_state = "medicbag_u"
	item_state = "medicbag_u"
	has_gamemode_skin = FALSE
	storage_slots = 42
	max_storage_space = 82

/obj/item/storage/belt/medical/combatLifesaver/upp/New()  //The belt, with all it's magic inside!
	..()

/obj/item/storage/belt/security
	name = "\improper M276 pattern security rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This configuration is commonly seen among USCM Military Police and peacekeepers, though it can hold some light munitions."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21
	can_hold = list(
		/obj/item/explosive/grenade/flashbang,
		/obj/item/explosive/grenade/chem_grenade/teargas,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/handful,
		/obj/item/reagent_container/food/snacks/donut/normal,
		/obj/item/reagent_container/food/snacks/donut/jelly,
		/obj/item/weapon/baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/tool/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight,
		/obj/item/device/radio/headset,
		/obj/item/weapon
	)



/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 9
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21


/obj/item/storage/belt/security/MP
	name = "\improper M276 pattern military police rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is filled with an array of small pouches, meant to carry non-lethal equipment and restraints."
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	max_storage_space = 30


/obj/item/storage/belt/security/MP/full/New()
	..()
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)



/obj/item/storage/belt/marine
	name = "\improper M276 pattern ammo load rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is the standard variant designed for bulk ammunition-carrying operations."
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
		/obj/item/ammo_magazine/smg/m39
	)
	var/has_gamemode_skin = TRUE //whether it has a sprite for each gamemode.

/obj/item/storage/belt/marine/New()
	if(has_gamemode_skin)
		select_gamemode_skin(type)
	..()

/obj/item/storage/belt/marine/m41a/New()
	..()
	new /obj/item/ammo_magazine/rifle (src)
	new /obj/item/ammo_magazine/rifle (src)
	new /obj/item/ammo_magazine/rifle (src)
	new /obj/item/ammo_magazine/rifle (src)
	new /obj/item/ammo_magazine/rifle (src)

/obj/item/storage/belt/marine/m41amk1/New()
	..()
	new /obj/item/ammo_magazine/rifle/m41aMK1 (src)
	new /obj/item/ammo_magazine/rifle/m41aMK1 (src)
	new /obj/item/ammo_magazine/rifle/m41aMK1 (src)
	new /obj/item/ammo_magazine/rifle/m41aMK1 (src)
	new /obj/item/ammo_magazine/rifle/m41aMK1 (src)

/obj/item/storage/belt/marine/m39/New()
	..()
	new /obj/item/ammo_magazine/smg/m39 (src)
	new /obj/item/ammo_magazine/smg/m39 (src)
	new /obj/item/ammo_magazine/smg/m39 (src)
	new /obj/item/ammo_magazine/smg/m39 (src)
	new /obj/item/ammo_magazine/smg/m39 (src)

/obj/item/storage/belt/marine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/marine/upp
	name = "\improper Type 41 pattern load rig"
	desc = "The Type 41 load rig is the standard-issue load-bearing equipment of the UPP military. The primary function of this belt is to provide easy access to mags for the Type 71 during operations. Despite being designed for the Type 71 weapon system, the pouches are modular enough to fit other types of ammo and equipment."
	icon_state = "upp_belt"
	item_state = "upp_belt"
	has_gamemode_skin = FALSE

//version full of type 71 mags
/obj/item/storage/belt/marine/upp/full/New()
	..()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)

//Crazy Ivan's belt reskin
/obj/item/storage/belt/marine/upp/ivan
	name = "\improper Type 42 pattern load rig"
	desc = "A modified variant of the standard-issue 41 pattern load rig."
	icon_state = "korovin_holster"
	item_state = "ivan_belt"
	storage_slots = 15
	max_storage_space = 40
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

/obj/item/storage/belt/shotgun/New()
	select_gamemode_skin(type)
	..()

/obj/item/storage/belt/shotgun/full/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		var/obj/item/ammo_magazine/handful/H = new(src)
		H.generate_handful(/datum/ammo/bullet/shotgun/slug, "12g", 5, 5, /obj/item/weapon/gun/shotgun)
	return

/obj/item/storage/belt/shotgun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/knifepouch
	name="\improper M276 pattern knife rig"
	desc="The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is specially designed with four holsters to store throwing knives. Not commonly issued, but kept in service."
	icon_state = "knifebelt"
	item_state = "marinebelt" // aslo temp, maybe somebody update these icons with better ones?
	w_class = SIZE_LARGE
	storage_slots = 6
	max_w_class = SIZE_TINY
	max_storage_space = 6
	can_hold=list(/obj/item/weapon/throwing_knife)

/obj/item/storage/belt/knifepouch/New()
	select_gamemode_skin(type)
	..()
	item_state = "marinebelt" //PLACEHOLDER. Override, since it has no unique state.
	new /obj/item/weapon/throwing_knife(src)
	new /obj/item/weapon/throwing_knife(src)
	new /obj/item/weapon/throwing_knife(src)
	new /obj/item/weapon/throwing_knife(src)
	new /obj/item/weapon/throwing_knife(src)
	new /obj/item/weapon/throwing_knife(src)

/obj/item/storage/belt/grenade
	name="\improper M276 pattern M40 HEDP rig"
	desc="The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is designed to carry bulk quantities of M40 HEDP Grenades."
	icon_state = "grenadebelt" // temp
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 8
	max_w_class = SIZE_MEDIUM
	max_storage_space = 24
	can_hold = list(/obj/item/explosive/grenade)


/obj/item/storage/belt/grenade/full/New()
	..()
	spawn(1)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)

/obj/item/storage/belt/grenade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box))
		var/obj/item/storage/box/nade_box/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/grenade/large
	name="\improper M276 pattern M40 HEDP rig Mk. II"
	desc="The M276 Mk. II is is an upgraded version of the M276 HEDP rig, with more storage capacity. It consists of a modular belt with various clips."
	storage_slots = 18
	max_storage_space = 54

/obj/item/storage/belt/grenade/large/full/New()
	..()
	spawn(1)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)
		new /obj/item/explosive/grenade/HE/frag(src)



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

/obj/item/storage/sparepouch/New()
	select_gamemode_skin(type)
	..()


////////////////////////////// GUN BELTS /////////////////////////////////////

/obj/item/storage/belt/gun
	name = "pistol belt"
	desc = "A belt-holster assembly that allows one to hold a pistol and two magazines."
	icon_state = "m4a3_holster"
	item_state = "marinebelt"
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
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol
	)

/obj/item/storage/belt/gun/Dispose()
	if(gun_underlay)
		qdel(gun_underlay)
		gun_underlay = null
	if(current_gun)
		qdel(current_gun)
		current_gun = null
	. = ..()


/obj/item/storage/belt/gun/attack_hand(mob/user)
	if(current_gun && ishuman(user) && loc == user)
		current_gun.attack_hand(user)
	else
		..()


/obj/item/storage/belt/gun/proc/update_gun_icon() //We do not want to use regular update_icon as it's called for every item inserted. Not worth the icon math.
	var/mob/user = loc
	if(current_gun) //So it has a gun, let's make an icon.
		/*
		Have to use a workaround here, otherwise images won't display properly at all times.
		Reason being, transform is not displayed when right clicking/alt+clicking an object,
		so it's necessary to pre-load the potential states so the item actually shows up
		correctly without having to rotate anything. Preloading weapon icons also makes
		sure that we don't have to do any extra calculations.
		*/
		playsound(src,drawSound, 15, 1)
		gun_underlay = image(icon, src, current_gun.base_gun_icon)
		gun_underlay.pixel_x = icon_x
		gun_underlay.pixel_y = icon_y
		icon_state += "_g"
		item_state = icon_state
		underlays += gun_underlay
	else
		playsound(src,sheatheSound, 15, 1)
		underlays -= gun_underlay
		icon_state = copytext(icon_state,1,-2)
		item_state = icon_state
		qdel(gun_underlay)
		gun_underlay = null
	if(istype(user)) user.update_inv_belt()
	if(istype(user)) user.update_inv_s_store()


//There are only two types here that can be inserted, and they are mutually exclusive. We only track the gun.
/obj/item/storage/belt/gun/can_be_inserted(obj/item/W, stop_messages) //We don't need to stop messages, but it can be left in.
	if( ..() ) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(istype(W,/obj/item/weapon/gun))
			if(current_gun)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
				return
		else //Must be ammo.
			var/ammo_slots = storage_slots - 1 //We have a slot reserved for the gun
			var/ammo_stored = contents.len
			if(current_gun)
				ammo_stored -= 1
			if(ammo_stored >= ammo_slots)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] can't hold any more magazines."))
				return
		return 1

/obj/item/weapon/gun/on_enter_storage(obj/item/storage/belt/gun/gun_belt)
	if(istype(gun_belt))
		if(!gun_belt.current_gun)
			gun_belt.current_gun = src //If there's no active gun, we want to make this our icon.
			gun_belt.update_gun_icon()

/obj/item/weapon/gun/on_exit_storage(obj/item/storage/belt/gun/gun_belt)
	if(istype(gun_belt))
		fast_pulled = TRUE //We fast pulled that gun, for equipped()
		if(gun_belt.current_gun == src)
			gun_belt.current_gun = null
			gun_belt.update_gun_icon()

/obj/item/storage/belt/gun/m4a3
	name = "\improper M276 pattern general pistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version has a holster assembly that allows one to carry the most common pistols. It also contains side pouches that can store 9mm or .45 magazines."
	storage_slots = 7
	item_state = "marinebelt"
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol
	)

/obj/item/storage/belt/gun/m4a3/New()
	select_gamemode_skin(type)
	..()

/obj/item/storage/belt/gun/m4a3/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/commander/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3/custom(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/mod88/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m4a3/vp78/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/m44
	name = "\improper M276 pattern M44 holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the M44 magnum revolver, along with three pouches for speedloaders. It faintly smells of hay."
	icon_state = "m44r_holster"
	item_state = "marinebelt"
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/ammo_magazine/revolver
	)

/obj/item/storage/belt/gun/m44/New()
	..()
	select_gamemode_skin(type)

/obj/item/storage/belt/gun/m44/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/m44(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new /obj/item/ammo_magazine/revolver/marksman(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba
	name = "\improper M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, along with three pouches for speedloaders. This one is aging poorly, and seems to be surplus equipment. This one is stamped '3rd 'Dust Raiders' Battalion'."
	icon_state = "s_cmateba_holster"
	item_state = "s_cmateba_holster"
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/weapon/gun/revolver/mateba,
		/obj/item/ammo_magazine/revolver/mateba
	)

/obj/item/storage/belt/gun/mateba/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/cmateba
	name = "\improper M276 pattern Mateba holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the powerful Mateba magnum revolver, along with three pouches for speedloaders. Was included with the mail-in order for the USCM edition of the Mateba autorevolver in the early 2170s."
	icon_state = "cmateba_holster"
	item_state = "cmateba_holster"

/obj/item/storage/belt/gun/mateba/cmateba/New()
	..()
	select_gamemode_skin(type)

/obj/item/storage/belt/gun/mateba/cmateba/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/cmateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/mateba/admiral/New()
	..()
	icon_state = "amateba_holster"
	item_state = "amateba_holster"
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/revolver/mateba/admiral(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/korovin
	name = "\improper Type 41 pistol holster rig"
	desc = "A modification of the standard UPP pouch rig to carry a single Korovin PK-9 pistol. It also contains side pouches that can store .22 magazines, either hollowpoints or tranquilizers."
	icon_state = "korovin_holster"
	item_state = "korovin_holster"
	can_hold = list(
		/obj/item/weapon/gun/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99t
	)

/obj/item/storage/belt/gun/korovin/standard/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/c99/upp(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/korovin/tranq/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/c99/upp/tranq(src)
	new /obj/item/ammo_magazine/pistol/c99t(src)
	new /obj/item/ammo_magazine/pistol/c99t(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new /obj/item/ammo_magazine/pistol/c99(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/smartpistol
	name = "\improper M276 pattern SU-6 Smartpistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the SU-6 smartpistol."
	icon_state = "smartpistol_holster"
	item_state = "marinebelt"
	storage_slots = 6
	icon_x = -5
	icon_y = -2
	can_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart
	)
	var/has_gamemode_skin = TRUE

/obj/item/storage/belt/gun/smartpistol/New()
	..()
	select_gamemode_skin(type)

/obj/item/storage/belt/gun/smartpistol/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/flaregun
	name = "\improper M276 pattern M82F flare gun holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is for the M82F flare gun."
	storage_slots = 17
	max_storage_space = 20
	icon_state = "m82f_holster"
	item_state = "m82f_holster"
	can_hold = list(
		/obj/item/weapon/gun/flare,
		/obj/item/device/flashlight/flare
	)

/obj/item/storage/belt/gun/flaregun/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/flaregun/full_nogun/New()
	..()
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/flashlight/flare(src)

/obj/item/storage/belt/gun/flaregun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/tank
	name = "\improper M103 pattern Tank-Ammo rig" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "The M103 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. Made specially for Tank Crewmen for store their ammunition."
	icon_state = "tankbelt"
	item_state = "tankbelt"
	storage_slots = 2 //can hold 2 only two large items such as Tank Ammo.
	max_w_class = SIZE_LARGE
	max_storage_space = 2
	can_hold = list(
		/obj/item/ammo_magazine/tank/ltb_cannon,
		/obj/item/ammo_magazine/tank/ltaaap_minigun,
		/obj/item/ammo_magazine/tank/primary_flamer,
		/obj/item/ammo_magazine/tank/secondary_flamer,
		/obj/item/ammo_magazine/tank/ace_autocannon,
		/obj/item/ammo_magazine/tank/towlauncher,
		/obj/item/ammo_magazine/tank/m56_cupola,
		/obj/item/ammo_magazine/tank/tank_glauncher,
		/obj/item/ammo_magazine/tank/tank_slauncher
	)


/obj/item/storage/belt/gun/smartgunner
	name = "\improper M802 pattern smartgunner rig"
	desc = "The M802 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is designed to carry smartgun ammunition, as well as a sidearm."
	icon_state = "sgbelt"
	item_state = "sgbelt"
	icon_x = 6
	icon_y = -2
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver/m44,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun
	)

/obj/item/storage/belt/gun/smartgunner/New()
	select_gamemode_skin(type)
	..()

/obj/item/storage/belt/gun/smartgunner/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/gun/smartgunner/pmc/full/New()
	..()
	var/obj/item/weapon/gun/new_gun = new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new_gun.on_enter_storage(src)

/obj/item/storage/belt/souto
	name = "\improper Souto belt"
	desc = "A belt with break away souto cans. They cannot be put back."
	flags_equip_slot = SLOT_WAIST
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD
	storage_slots = 8
	flags_item = NODROP|DELONDROP
	flags_inventory = CANTSTRIP
	max_w_class = 0 //this belt cannot hold anything


/obj/item/storage/belt/souto/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_container/food/drinks/cans/souto/classic(src)