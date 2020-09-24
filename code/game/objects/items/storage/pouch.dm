/obj/item/storage/pouch
	name = "abstract pouch"
	desc = "The physical manifestation of a concept of a pouch. Woah."
	icon = 'icons/obj/items/clothing/pouches.dmi'
	icon_state = "small_drop"
	w_class = SIZE_LARGE //does not fit in backpack
	max_w_class = SIZE_SMALL
	flags_equip_slot = SLOT_STORE
	storage_slots = 1
	storage_flags = STORAGE_FLAGS_POUCH


/obj/item/storage/pouch/Initialize()
	. = ..()

	update_icon()


/obj/item/storage/pouch/update_icon()
	overlays.Cut()
	if(!contents.len)
		return
	else if(contents.len <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"


/obj/item/storage/pouch/examine(mob/user)
	..()
	to_chat(user, "Can be worn by attaching it to a pocket.")


/obj/item/storage/pouch/equipped(mob/user, slot)
	if(slot == WEAR_L_STORE || slot == WEAR_R_STORE)
		mouse_opacity = 2 //so it's easier to click when properly equipped.
	..()

/obj/item/storage/pouch/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()




/obj/item/storage/pouch/general
	name = "light general pouch"
	desc = "A general purpose pouch used to carry small items and ammo magazines."
	icon_state = "small_drop"
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
	)

/obj/item/storage/pouch/general/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_into(M,user)
	else if(istype(W, /obj/item/storage/box/nade_box))
		var/obj/item/storage/box/nade_box/M = W
		dump_into(M,user)
	else if(istype(W, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/general/medium
	name = "medium general pouch"
	storage_slots = 2
	icon_state = "medium_drop"
	storage_flags = STORAGE_FLAGS_POUCH

/obj/item/storage/pouch/general/large
	name = "large general pouch"
	storage_slots = 3
	icon_state = "large_drop"
	storage_flags = STORAGE_FLAGS_POUCH

/obj/item/storage/pouch/flamertank
	name = "fuel tank strap pouch"
	desc = "Two rings straps that loop around M240 variety napalm tanks. Handle with care."
	storage_slots = 2
	icon_state = "fueltank_pouch"
	storage_flags = STORAGE_FLAGS_POUCH
	can_hold = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/tool/extinguisher
					)
	bypass_w_limit = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/tool/extinguisher
					)

/obj/item/storage/pouch/general/large/m39ap/Initialize()
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	..()
/obj/item/storage/pouch/bayonet
	name = "bayonet sheath"
	desc = "A pouch for your knives."
	can_hold = list(
		/obj/item/weapon/melee/throwing_knife,
		/obj/item/attachable/bayonet
	)
	icon_state = "bayonet"
	storage_slots = 3
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD

/obj/item/storage/pouch/bayonet/full/Initialize()
	new /obj/item/attachable/bayonet(src)
	..()

/obj/item/storage/pouch/bayonet/upp/Initialize()
	new /obj/item/attachable/bayonet/upp(src)
	..()

/obj/item/storage/pouch/survival
	name = "survival pouch"
	desc = "It can contain flashlights, a pill, a crowbar, metal sheets, and some bandages."
	icon_state = "survival"
	storage_slots = 5
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/device/flashlight,
		/obj/item/tool/crowbar,
		/obj/item/reagent_container/pill,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/sheet/metal
	)

/obj/item/storage/pouch/survival/full/Initialize()
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/reagent_container/pill/tramadol(src)
	new /obj/item/stack/medical/bruise_pack (src, 3)
	new /obj/item/stack/sheet/metal(src, 60)
	..()



/obj/item/storage/pouch/firstaid
	name = "first-aid pouch"
	desc = "It can contain autoinjectors, ointments, and bandages."
	icon_state = "firstaid"
	storage_slots = 4
	can_hold = list(
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/stack/medical/bruise_pack
	)

/obj/item/storage/pouch/firstaid/full
	desc = "Contains a painkiller autoinjector, first-aid autoinjector, some ointment, and some bandages."

/obj/item/storage/pouch/firstaid/full/Initialize()
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless(src)
	new /obj/item/stack/medical/bruise_pack(src)
	..()

/obj/item/storage/pouch/pistol
	name = "sidearm pouch"
	desc = "It can contain a pistol. Useful for emergencies."
	icon_state = "pistol"
	max_w_class = SIZE_MEDIUM
	can_hold = list(/obj/item/weapon/gun/pistol, /obj/item/weapon/gun/revolver/m44)
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD



//// MAGAZINE POUCHES /////

/obj/item/storage/pouch/magazine
	name = "magazine pouch"
	desc = "It can contain ammo magazines."
	icon_state = "medium_ammo_mag"
	max_w_class = SIZE_MEDIUM
	storage_slots = 3
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg/m39
	)
	can_hold = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful
	)

/obj/item/storage/pouch/magazine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/magazine/large
	name = "large magazine pouch"
	icon_state = "large_ammo_mag"
	storage_slots = 4

/obj/item/storage/pouch/magazine/large/with_beanbags

/obj/item/storage/pouch/magazine/large/with_beanbags/Initialize()
	. = ..()
	for(var/i=1; i <= storage_slots; i++)
		var/obj/item/ammo_magazine/handful/H = new(src)
		H.generate_handful(/datum/ammo/bullet/shotgun/beanbag, "12g", 5, 5, /obj/item/weapon/gun/shotgun)
	return


/obj/item/storage/pouch/magazine/pistol
	name = "pistol magazine pouch"
	desc = "It can contain pistol and revolver ammo magazines."
	max_w_class = SIZE_SMALL
	icon_state = "pistol_mag"
	storage_slots = 3

	can_hold = list(
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
	)

/obj/item/storage/pouch/magazine/pistol/large
	name = "large pistol magazine pouch"
	storage_slots = 6
	icon_state = "large_pistol_mag"


/obj/item/storage/pouch/magazine/pistol/pmc_mateba/Initialize()
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	..()

/obj/item/storage/pouch/magazine/pistol/pmc_mod88/Initialize()
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	..()

/obj/item/storage/pouch/magazine/pistol/pmc_vp78/Initialize()
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	..()

/obj/item/storage/pouch/magazine/upp/Initialize()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	..()

/obj/item/storage/pouch/magazine/large/upp/Initialize()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	..()

/obj/item/storage/pouch/magazine/upp_smg/Initialize()
	new /obj/item/ammo_magazine/smg/skorpion(src)
	new /obj/item/ammo_magazine/smg/skorpion(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_m39/Initialize()
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	new /obj/item/ammo_magazine/smg/m39/ap(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_p90/Initialize()
	new /obj/item/ammo_magazine/smg/fp9000(src)
	new /obj/item/ammo_magazine/smg/fp9000(src)
	new /obj/item/ammo_magazine/smg/fp9000(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_lmg/Initialize()
	new /obj/item/ammo_magazine/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg(src)
	new /obj/item/ammo_magazine/rifle/lmg(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_sniper/Initialize()
	new /obj/item/ammo_magazine/sniper/elite(src)
	new /obj/item/ammo_magazine/sniper/elite(src)
	new /obj/item/ammo_magazine/sniper/elite(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_rifle/Initialize()
	new /obj/item/ammo_magazine/rifle/ap(src)
	new /obj/item/ammo_magazine/rifle/ap(src)
	new /obj/item/ammo_magazine/rifle/ap(src)
	..()

/obj/item/storage/pouch/magazine/large/pmc_sg/Initialize()
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	..()

/obj/item/storage/pouch/explosive
	name = "explosive pouch"
	desc = "It can contain grenades, plastics, mine boxes, and other explosives."
	icon_state = "large_explosive"
	storage_slots = 3
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/explosive/plastic,
		/obj/item/explosive/mine,
		/obj/item/explosive/grenade,
		/obj/item/storage/box/explosive_mines
	)

/obj/item/storage/pouch/explosive/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box))
		var/obj/item/storage/box/nade_box/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/explosive/full/Initialize()
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	new /obj/item/explosive/grenade/HE(src)
	..()

/obj/item/storage/pouch/explosive/upp/Initialize()
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	..()

/obj/item/storage/pouch/medical
	name = "medical pouch"
	desc = "It can contain small medical supplies."
	icon_state = "medical"
	storage_slots = 3

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
	    /obj/item/reagent_container/hypospray
	)

/obj/item/storage/pouch/medical/full/Initialize()
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	..()

/obj/item/storage/pouch/medical/frt_kit
	name = "first responder technical pouch"
	desc = "Holds everything one might need for rapid field triage and treatment. Make sure to coordinate with the proper field medics."
	icon_state = "frt_med"
	storage_slots = 4
	can_hold = list(
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/hypospray,
		/obj/item/tool/extinguisher/mini,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/storage/syringe_case,
	)

/obj/item/storage/pouch/medical/frt_kit/full/Initialize()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	..()

/obj/item/storage/pouch/vials
	name = "vial pouch"
	desc = "A pouch for carrying glass vials."
	icon_state = "vial"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/glass/beaker/vial)

/obj/item/storage/pouch/vials/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/fancy/vials))
		var/obj/item/storage/fancy/vials/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/chem
	name = "chemist pouch"
	desc = "A pouch for carrying glass beakers."
	icon_state = "chemist"
	storage_slots = 2
	can_hold = list(
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/bottle
	)

/obj/item/storage/pouch/chem/Initialize()
	new /obj/item/reagent_container/glass/beaker/large(src)
	new /obj/item/reagent_container/glass/beaker(src)
	..()

/obj/item/storage/pouch/autoinjector
	name = "auto-injector pouch"
	desc = "A pouch specifically for auto-injectors."
	icon_state = "injectors"
	storage_slots = 7
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector)

/obj/item/storage/pouch/autoinjector/full/Initialize()
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)
	..()

/obj/item/storage/pouch/syringe
	name = "syringe pouch"
	desc = "It can contain syringes."
	icon_state = "syringe"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/syringe)

/obj/item/storage/pouch/syringe/full/Initialize()
	. = ..()
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)

/obj/item/storage/pouch/medkit
	name = "medkit pouch"
	max_w_class = SIZE_MEDIUM
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	icon_state = "medkit"
	desc = "It's specifically made to hold a medkit."
	can_hold = list(/obj/item/storage/firstaid)


/obj/item/storage/pouch/medkit/full/Initialize()
	new /obj/item/storage/firstaid/regular(src)
	..()

/obj/item/storage/pouch/medkit/full_advanced/Initialize()
	new /obj/item/storage/firstaid/adv(src)
	..()

/obj/item/storage/pouch/document
	name = "large document pouch"
	desc = "It can contain papers and clipboards."
	icon_state = "document"
	storage_slots = 21
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_CLICK_GATHER
	can_hold = list(
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/document_objective/paper,
		/obj/item/document_objective/report,
		/obj/item/document_objective/folder,
		/obj/item/disk/objective,
		/obj/item/document_objective/technical_manual
	)

/obj/item/storage/pouch/document/small
	name = "small document pouch"
	storage_slots = 7

/obj/item/storage/pouch/flare
	name = "flare pouch"
	desc = "A pouch designed to hold flares. Refillable with a M94 flare pack."
	max_w_class = SIZE_SMALL
	storage_slots = 8
	max_storage_space = 8
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	icon_state = "flare"
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)

/obj/item/storage/pouch/flare/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/flare/full/Initialize()
	contents = list()
	var/i = 0
	while(i++ < storage_slots)
		new /obj/item/device/flashlight/flare(src)
	..()

/obj/item/storage/pouch/radio
	name = "radio pouch"
	storage_slots = 2
	icon_state = "radio"
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	desc = "It can contain two handheld radios."
	can_hold = list(/obj/item/device/radio)


/obj/item/storage/pouch/electronics
	name = "electronics pouch"
	desc = "It is designed to hold most electronics, power cells and circuitboards."
	icon_state = "electronics"
	storage_slots = 6
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/cell
	)

/obj/item/storage/pouch/electronics/full/Initialize()
	new /obj/item/circuitboard/apc(src)
	new /obj/item/cell/high(src)
	..()

/obj/item/storage/pouch/construction
	name = "construction pouch"
	desc = "It's designed to hold construction materials - glass/metal sheets, metal rods, barbed wire, cable coil, and empty sandbags. It also has two hooks for an entrenching tool and light replacer."
	storage_slots = 3
	max_w_class = SIZE_MEDIUM
	icon_state = "construction"
	can_hold = list(
		/obj/item/stack/barbed_wire,
		/obj/item/stack/sheet,
		/obj/item/stack/rods,
		/obj/item/stack/cable_coil,
		/obj/item/stack/tile,
		/obj/item/tool/shovel/etool,
		/obj/item/stack/sandbags_empty,
		/obj/item/device/lightreplacer,
	)

/obj/item/storage/pouch/construction/full/Initialize()
	. = ..()
	var/obj/item/stack/sheet/plasteel/PLAS = new /obj/item/stack/sheet/plasteel(src)
	PLAS.amount = 50
	var/obj/item/stack/sheet/metal/MET = new /obj/item/stack/sheet/metal(src)
	MET.amount = 50
	var/obj/item/stack/sandbags_empty/SND1 = new /obj/item/stack/sandbags_empty(src)
	SND1.amount = 50

/obj/item/storage/pouch/tools
	name = "tools pouch"
	desc = "It's designed to hold maintenance tools - screwdriver, wrench, cable coil, etc. It also has a hook for an entrenching tool."
	storage_slots = 4
	max_w_class = SIZE_MEDIUM
	icon_state = "tools"
	can_hold = list(
		/obj/item/tool/wirecutters,
		/obj/item/tool/shovel/etool,
		/obj/item/tool/screwdriver,
		/obj/item/tool/crowbar,
		/obj/item/tool/weldingtool,
		/obj/item/device/multitool,
		/obj/item/tool/wrench,
		/obj/item/stack/cable_coil,
		/obj/item/tool/extinguisher/mini,
		/obj/item/tool/shovel/etool
	)
	bypass_w_limit = list(/obj/item/tool/shovel/etool)

/obj/item/storage/pouch/tools/full/Initialize()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/tool/wrench(src)
	..()

/obj/item/storage/pouch/tools/pfc/Initialize()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/wrench(src)
	..()

/obj/item/storage/pouch/tools/synth/Initialize()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/device/multitool(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/stack/cable_coil(src)
	..()

/obj/item/storage/pouch/tools/tank/Initialize()
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool/hugetank(src)
	new /obj/item/tool/extinguisher/mini(src)
	..()