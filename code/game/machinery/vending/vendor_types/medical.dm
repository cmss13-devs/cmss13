//------------SORTED MEDICAL VENDORS---------------

/obj/structure/machinery/cm_vending/sorted/medical
	name = "\improper WestonMed Plus"
	desc = "Medical Pharmaceutical dispenser. Provided by W-Y Pharmaceuticals Division(TM)."
	icon_state = "med"
	req_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)

	unacidable = TRUE
	unslashable = FALSE
	wrenchable = TRUE
	hackable = TRUE

	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 5

/obj/structure/machinery/cm_vending/sorted/medical/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))
		if(vend_delay)
			overlays += image(icon, icon_state + "_vend")
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)
			sleep(vend_delay)
		var/prod_path = L[3]
		var/obj/item/IT
		IT = new prod_path(T)

		IT.add_fingerprint(usr)

		L[2]--
	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		overlays += image(icon, icon_state + "_deny")
		sleep(15)
	update_icon()
	stat &= ~IN_USE
	return

/obj/structure/machinery/cm_vending/sorted/medical/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_container/hypospray/autoinjector) && stat == WORKING) // only if we are completely fine and working
		if(!hacked)
			if(!allowed(user))
				to_chat(user, SPAN_WARNING("Access denied."))
				return

			var/mob/living/carbon/human/H = user
			var/obj/item/card/id/ID = H.wear_id
			if(!istype(ID)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				return

			if(ID.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				return

			if(LAZYLEN(vendor_role) && !vendor_role.Find(H.job))
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				return

		var/obj/item/reagent_container/hypospray/autoinjector/AI = I
		for(var/list/R in listed_products)
			if(AI.type == R[3])
				if(AI.reagents.total_volume > 0)
					to_chat(user, SPAN_WARNING("\The [src] makes a warning noise. \The [AI.name] doesn't seem to be empty."))
					return

		to_chat(user, SPAN_NOTICE("\The [src] makes a whirring noise as it refills your [AI.name]."))
		// Since the reagent is deleted on use it's easier to make a new one instead of snowflake checking
		var/obj/item/reagent_container/hypospray/autoinjector/new_injector = new AI.type(src)
		qdel(AI)
		user.put_in_hands(new_injector)
	else
		. = ..()

/obj/structure/machinery/cm_vending/sorted/medical/populate_product_list(var/scale)
	listed_products = list(
		list("FIELD SUPPLIES", -1, null, null),
		list("Advanced Burn Kit", round(scale * 7), /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("Advanced Trauma Kit", round(scale * 7), /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", round(scale * 7), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", round(scale * 7), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", round(scale * 7), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", -1, null, null),
		list("Autoinjector (Bicaridine)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/bicaridine, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/dexalinp, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/adrenaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/kelotane, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/oxycodone, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/quickclot, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Suxamorycin)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/suxamorycin, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/tramadol, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/tricord, VENDOR_ITEM_REGULAR),

		list("LIQUID BOTTLES", -1, null, null),
		list("Bottle (Bicaridine)", round(scale * 5), /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Bottle (Dylovene)", round(scale * 5), /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("Bottle (Dexalin)", round(scale * 5), /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Bottle (Inaprovaline)", round(scale * 5), /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Bottle (Kelotane)", round(scale * 5), 	/obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Bottle (Oxycodone)", round(scale * 5), /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("Bottle (Peridaxon)", round(scale * 5), /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Bottle (Suxamorycin)", round(scale * 5), /obj/item/reagent_container/glass/bottle/suxamorycin, VENDOR_ITEM_REGULAR),
		list("Bottle (Tramadol)", round(scale * 5), /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", -1, null, null),
		list("Pill Bottle (Bicaridine)", round(scale * 3), /obj/item/storage/pill_bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dexalin)", round(scale * 3), /obj/item/storage/pill_bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", round(scale * 3), /obj/item/storage/pill_bottle/antitox, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", round(scale * 3), /obj/item/storage/pill_bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", round(scale * 3), /obj/item/storage/pill_bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Peridaxon)", round(scale * 2), /obj/item/storage/pill_bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (QuickClot)", round(scale * 2), /obj/item/storage/pill_bottle/quickclot, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", round(scale * 3), /obj/item/storage/pill_bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("MEDICAL UTILITIES", -1, null, null),
		list("Emergency Defibrillator", round(scale * 3), /obj/item/device/defibrillator, VENDOR_ITEM_REGULAR),
		list("Hypospray", round(scale * 2), /obj/item/reagent_container/hypospray/tricordrazine, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", round(scale * 5), /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Medical Storage Rig", round(scale * 2), /obj/item/storage/belt/medical, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", round(scale * 3), /obj/item/clothing/glasses/hud/health, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", round(scale * 2), /obj/item/bodybag/cryobag, VENDOR_ITEM_REGULAR),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/chemistry
	name = "\improper WestonChem Plus"
	desc = "Medical chemistry dispenser. Provided by W-Y Pharmaceuticals Division(TM)."

/obj/structure/machinery/cm_vending/sorted/medical/chemistry/populate_product_list(var/scale)
	listed_products = list(
		list("LIQUID BOTTLES", -1, null, null),
		list("Bicaridine Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Dylovene Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("Dexalin Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Inaprovaline Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Kelotane Bottle", round(scale * 5), 	/obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Oxycodone Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("Peridaxon Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Suxamorycin Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/suxamorycin, VENDOR_ITEM_REGULAR),
		list("Tramadol Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Beaker (60 Units)", round(scale * 3), /obj/item/reagent_container/glass/beaker, VENDOR_ITEM_REGULAR),
		list("Beaker, Large (120 Units)", round(scale * 3), /obj/item/reagent_container/glass/beaker/large, VENDOR_ITEM_REGULAR),
		list("Box of Pill Bottles", round(scale * 2), /obj/item/storage/box/pillbottles, VENDOR_ITEM_REGULAR),
		list("Dropper", round(scale * 3), /obj/item/reagent_container/dropper, VENDOR_ITEM_REGULAR),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/no_access
	req_access = list()

/obj/structure/machinery/cm_vending/sorted/medical/chemistry/no_access
	req_access = list()

/obj/structure/machinery/cm_vending/sorted/medical/antag
	name = "\improper Medical Equipment Vendor"
	desc = "A vending machine dispensing various pieces of medical equipment."
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/marinemed
	name = "\improper ColMarTech MarineMed"
	desc = "Medical Pharmaceutical dispenser with basic medical supplies for marines."
	icon_state = "marinemed"
	req_access = list()
	req_one_access = list()
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/populate_product_list(var/scale)
	listed_products = list(
		list("AUTOINJECTORS", -1, null, null),
		list("First-Aid Autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),

		list("DEVICES", -1, null, null),
		list("Health Analyzer", round(scale * 3), /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),

		list("FIELD SUPPLIES", -1, null, null),
		list("Fire Extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("Ointment", round(scale * 7), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", round(scale * 7), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", round(scale * 7), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/antag
	name = "\improper Basic Medical Supplies Vendor"
	desc = "A vending machine dispensing basic medical supplies."
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/blood
	name = "\improper MM Blood Dispenser"
	desc = "Marine Med brand Blood Pack Dispensery"
	icon_state = "blood"
	wrenchable = FALSE

	listed_products = list(
		list("BLOOD PACKS", -1, null, null),
		list("A+ Blood Pack", 5, /obj/item/reagent_container/blood/APlus, VENDOR_ITEM_REGULAR),
		list("A- Blood Pack", 5, /obj/item/reagent_container/blood/AMinus, VENDOR_ITEM_REGULAR),
		list("B+ Blood Pack", 5, /obj/item/reagent_container/blood/BPlus, VENDOR_ITEM_REGULAR),
		list("B- Blood Pack", 5, /obj/item/reagent_container/blood/BMinus, VENDOR_ITEM_REGULAR),
		list("O+ Blood Pack", 5, /obj/item/reagent_container/blood/OPlus, VENDOR_ITEM_REGULAR),
		list("O- Blood Pack", 5, /obj/item/reagent_container/blood/OMinus, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Empty Blood Pack", 5, /obj/item/reagent_container/blood, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/blood/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/medical/blood/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/wall_med
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment Dispenser."
	icon_state = "wallmed"
	vend_delay = 7

	req_access = list()

	density = FALSE
	wrenchable = FALSE
	listed_products = list(
		list("SUPPLIES", -1, null, null),
		list("First-Aid Autoinjector", 1, /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", 1, /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),
		list("Roll Of Gauze", 2, /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", 2, /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("UTILITY", -1, null, null),
		list("HF2 Health Analyzer", 1, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/wall_med/populate_product_list(var/scale)
	return