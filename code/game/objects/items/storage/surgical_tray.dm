/obj/item/storage/surgical_tray
	name = "surgical tray"
	desc = "A small metallic tray covered in sterile tarp. Intended to store surgical tools in a neat and clean fashion."
	icon = 'icons/obj/items/storage/medical.dmi'
	icon_state = "surgical_tray"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	item_state = "surgical_tray"
	flags_atom = FPRINT|CONDUCT|NO_GAMEMODE_SKIN
	w_class = SIZE_LARGE //Should not fit in backpacks
	storage_slots = 19
	max_storage_space = 24
	use_sound = "ruffle"
	matter = list("plastic" = 3000)
	// Set in init
	can_hold = list()
	var/list/types_and_overlays = list(
		/obj/item/tool/surgery/scalpel = "tray_scalpel",
		/obj/item/tool/surgery/scalpel/laser = "tray_scalpel_laser",
		/obj/item/tool/surgery/hemostat = "tray_hemostat",
		/obj/item/tool/surgery/retractor = "tray_retractor",
		/obj/item/tool/surgery/cautery = "tray_cautery",
		/obj/item/tool/surgery/circular_saw = "tray_saw",
		/obj/item/tool/surgery/surgicaldrill = "tray_drill",
		/obj/item/tool/surgery/bonegel = "tray_bone_gel",
		/obj/item/tool/surgery/bonesetter = "tray_bonesetter",
		/obj/item/tool/surgery/FixOVein = "tray_fixovein",
		/obj/item/tool/surgery/surgical_line = "tray_surgical_line",
		/obj/item/tool/surgery/synthgraft = "tray_synthgraft",
		/obj/item/stack/medical/advanced/bruise_pack = "tray_bruise_pack",
		/obj/item/stack/nanopaste = "tray_nanopaste",
		/obj/item/tool/surgery/scalpel/pict_system = "tray_pict",
		/obj/item/device/autopsy_scanner = "tray_autopsy_scanner",
		/obj/item/device/mass_spectrometer = "tray_mass_spectrometer",
		/obj/item/device/mass_spectrometer/adv = "tray_adv_mass_spectrometer",
		/obj/item/reagent_container/syringe = "tray_syringe",
		/obj/item/reagent_container/glass/beaker/vial = "tray_vial",
	)

/obj/item/storage/surgical_tray/Initialize()
	can_hold = types_and_overlays
	return ..()

/obj/item/storage/surgical_tray/update_icon()
	overlays.Cut()
	for(var/obj/item/overlayed_item in contents)
		if(types_and_overlays[overlayed_item.type])
			overlays += types_and_overlays[overlayed_item.type]


/obj/item/storage/surgical_tray/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel/pict_system(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/surgical_tray/stuffed/fill_preset_inventory()
	for(var/type in types_and_overlays)
		// only 'dupe'
		if(type == /obj/item/tool/surgery/scalpel/laser)
			continue
		new type(src)

/obj/item/storage/surgical_tray/empty/fill_preset_inventory()
	return
