/datum/tutorial/marine/medical_basic_item
	name = "Marine - Medical Tutorial 2 (Standard Tools)"
	desc = "Learn the medical tools you'll need to use to heal yourself and others"
	tutorial_id = "marine_medical_2"
	tutorial_template = /datum/map_template/tutorial/s8x9

	var/clothing_items_to_vend = 7
	var/med_one_items_to_vend = 1
	var/med_two_items_to_vend = 1
	var/med_three_items_to_vend = 1

// START OF SCRIPTING

/datum/tutorial/marine/medical_basic_item/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will discuss the medical tools you will use as a standard Marine.")
	addtimer(CALLBACK(src, PROC_REF(intro_one)), 6 SECONDS)
//pouch_one intro_one
/datum/tutorial/marine/medical_basic_item/proc/intro_one()
	message_to_player("You are capable of tending to your own basic injuries without needing Corpsman (sometimes called a Medic) to assist you.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(intro_two)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/intro_two()
	message_to_player("The knowledge and ability to tend to your own injuries will allow you to not only survive, but thrive, on the battlefield.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(kit_one)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_one()
	message_to_player("We will now show and discuss the basic medical items you can use. Afterwards, we will examine where you can find and store these items.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(kit_two)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_two()
	SIGNAL_HANDLER

	message_to_player("These are <b>Bandages</b>. You can use these to heal <b>Brute</b> damage and stop bleeding. You always want to carry one of these.")
	update_objective("")
	var/obj/item/stack/medical/bruise_pack/bandage = new(loc_from_corner(0, 5))
	add_to_tracking_atoms(bandage)
	add_highlight(bandage)
	addtimer(CALLBACK(src, PROC_REF(kit_three)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_three()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/bruise_pack, bandage)
	remove_highlight(bandage)
	message_to_player("These are <b>Ointments</b>. You can use these to heal <b>Burn</b> damage. These are less important to carry, but are useful if you have the space for it.")
	update_objective("")
	var/obj/item/stack/medical/ointment/cream = new(loc_from_corner(0, 6))
	add_to_tracking_atoms(cream)
	add_highlight(cream)
	addtimer(CALLBACK(src, PROC_REF(kit_four)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_four()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/ointment, cream)
	remove_highlight(cream)
	message_to_player("These are <b>Splints</b>. You can use these to stabalize <b>fractures</b>. These are very important to use, as a unsplinted fracture can cause permanent injuries.")
	update_objective("")
	var/obj/item/stack/medical/splint/splint = new(loc_from_corner(1, 5))
	add_to_tracking_atoms(splint)
	add_highlight(splint)
	addtimer(CALLBACK(src, PROC_REF(interject_one)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/interject_one()
	message_to_player("It is significantly faster for someone else to apply a splint to you. It is suggested you ask someone else to splint your fractures.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(interject_two)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/interject_two()
	message_to_player("Furthermore, splints can be broken by further damage, requiring a replacement. Keep a close eye on your splints for this.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(kit_five)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_five()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/splint, splint)
	remove_highlight(splint)
	message_to_player("These are autoinjectors, these can be used to inject yourself with a healing chemical. This one is a <b>Bicaradine</b> autoinjector, it heals <b>Brute</b> damage.")
	update_objective("")
	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/autobic = new(loc_from_corner(1, 6))
	add_to_tracking_atoms(autobic)
	add_highlight(autobic)
	addtimer(CALLBACK(src, PROC_REF(kit_six)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_six()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine, autobic)
	remove_highlight(autobic)
	message_to_player("This one is a <b>Kelotane</b> autoinjector, it heals <b>Burn</b> damage.")
	update_objective("")
	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/autokel = new(loc_from_corner(2, 5))
	add_to_tracking_atoms(autokel)
	add_highlight(autokel)
	addtimer(CALLBACK(src, PROC_REF(kit_seven)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_seven()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane, autokel)
	remove_highlight(autokel)
	message_to_player("This one is a <b>Tramadol</b> autoinjector, it helps counter <b>Pain</b>, which is generated by being injured.")
	update_objective("")
	var/obj/item/reagent_container/hypospray/autoinjector/tramadol/autotra = new(loc_from_corner(2, 6))
	add_to_tracking_atoms(autotra)
	add_highlight(autotra)
	addtimer(CALLBACK(src, PROC_REF(kit_eight)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_eight()
	message_to_player("Tramadol is a highly dangerous medication, be certain to not overdose yourself be injecting more than three doses of this at a time. You will die if you do this.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(kit_nine)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_nine()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/tramadol, autotra)
	remove_highlight(autotra)
	message_to_player("This one is a <b>Tricordrazine</b> autoinjector, it heals all damage types but slower than other chemicals. Its useful as a generalist medication for minor injuries.")
	update_objective("")
	var/obj/item/reagent_container/hypospray/autoinjector/tricord/autotri = new(loc_from_corner(3, 5))
	add_to_tracking_atoms(autotri)
	add_highlight(autotri)
	addtimer(CALLBACK(src, PROC_REF(kit_ten)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_ten()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/tricord, autotri)
	remove_highlight(autotri)
	message_to_player("This is an <b>Emergency</b> autoinjector. It is unique in that it is a single use, non-refillable, injector. It will inject you with a large amount of healing medications and a powerful pain killer. Use this when you are on the brink of death.")
	update_objective("")
	var/obj/item/reagent_container/hypospray/autoinjector/emergency/autoemer = new(loc_from_corner(3, 6))
	add_to_tracking_atoms(autoemer)
	add_highlight(autoemer)
	addtimer(CALLBACK(src, PROC_REF(kit_eleven)), 8 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_eleven()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/emergency, autoemer)
	remove_highlight(autoemer)
	message_to_player("These are pill packets. They are uncommonly issued. You get four pills per packet, one dose more than a autoinjector. But you can not refill these.")
	update_objective("")
	var/obj/item/storage/pill_bottle/packet/bicaridine/packetbic = new(loc_from_corner(4, 5))
	var/obj/item/storage/pill_bottle/packet/kelotane/packetkel = new(loc_from_corner(4, 6))
	var/obj/item/storage/pill_bottle/packet/tramadol/packettram = new(loc_from_corner(5, 5))
	add_to_tracking_atoms(packetbic)
	add_to_tracking_atoms(packetkel)
	add_to_tracking_atoms(packettram)
	add_highlight(packetbic)
	add_highlight(packetkel)
	add_highlight(packettram)
	addtimer(CALLBACK(src, PROC_REF(kit_twelve)), 8 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/kit_twelve()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle/packet/bicaridine, packetbic)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle/packet/kelotane, packetkel)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle/packet/tramadol, packettram)
	remove_highlight(packetbic)
	remove_highlight(packetkel)
	remove_highlight(packettram)
	message_to_player("Take this moment to pause and review the previous chat logs, or the medical items on the floor. When you are ready, please take the food bar and eat it.")
	update_objective("Eat the food bar when you are ready to continue")
	var/obj/item/reagent_container/food/snacks/protein_pack/food = new(loc_from_corner(3, 3))
	add_to_tracking_atoms(food)
	add_highlight(food)
	RegisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK, PROC_REF(pouch_one))

/datum/tutorial/marine/medical_basic_item/proc/pouch_one()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/food/snacks/protein_pack, food)
	remove_highlight(food)
	message_to_player("This section of the tutorial will discuss where to get these items, and how to store them. To begin, go to the equipment vendor and equip a standard Marine loadout.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorialmed, clothing_vendor)
	add_highlight(clothing_vendor)
	clothing_vendor.req_access = list()
	RegisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(pouch_two))

/datum/tutorial/marine/medical_basic_item/proc/pouch_two()
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorialmed, clothing_vendor)
		UnregisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		clothing_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(clothing_vendor)
		message_to_player("Now, go to your personal equipment vendor and vend the <b>First-Aid Pouch (Refillable Injectors)</b>.")
		update_objective("Vend the first-aid pouch.")
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/medic_equip, medic_vendor_alpha)
		add_highlight(medic_vendor_alpha)
		medic_vendor_alpha.req_access = list()
		RegisterSignal(medic_vendor_alpha, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(pouch_three))

/datum/tutorial/marine/medical_basic_item/proc/pouch_three()
	SIGNAL_HANDLER

	med_one_items_to_vend--
	if(med_one_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/medic_equip, medic_vendor_alpha)
		UnregisterSignal(medic_vendor_alpha, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medic_vendor_alpha.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medic_vendor_alpha)
		message_to_player("You have equipped this pouch into your pouch slot. This is the first of three medical pouches you can vend for yourself, this is the injector pouch, which contains the basic injectors and a emergency injector.")
		update_objective("")
		addtimer(CALLBACK(src, PROC_REF(pouch_four)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_four()
	message_to_player("This pouch is unique as you can only get this from your personal vendor, the remaining two pouches can be acquired freely from the squad vendor.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(pouch_five)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_five()
	SIGNAL_HANDLER

	message_to_player("Vend the <b>First-Aid Pouch (Splints, Gauze, Ointment)</b>.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/medic_equip_bravo, medic_vendor_bravo)
	add_highlight(medic_vendor_bravo)
	medic_vendor_bravo.req_access = list()
	RegisterSignal(medic_vendor_bravo, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(pouch_six))

/datum/tutorial/marine/medical_basic_item/proc/pouch_six()
	SIGNAL_HANDLER

	med_two_items_to_vend--
	if(med_two_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/medic_equip_bravo, medic_vendor_bravo)
		UnregisterSignal(medic_vendor_bravo, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medic_vendor_bravo.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medic_vendor_bravo)
		message_to_player("This pouch contains a set of bandages, ointment, splints and a tricodrazine injector. It is a good generalist pouch.")
		update_objective("")
		addtimer(CALLBACK(src, PROC_REF(pouch_seven)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_seven()
	message_to_player("You can vend these items from the marine medical vendor in the ship's medbay, as an alternative source.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(pouch_eight)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_eight()
	SIGNAL_HANDLER

	message_to_player("Vend the <b>First-Aid Pouch (Pills)</b>.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/uniform_supply/medic_equip_charlie, medic_vendor_charlie)
	add_highlight(medic_vendor_charlie)
	medic_vendor_charlie.req_access = list()
	RegisterSignal(medic_vendor_charlie, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(pouch_nine))

/datum/tutorial/marine/medical_basic_item/proc/pouch_nine()
	SIGNAL_HANDLER

	med_three_items_to_vend--
	if(med_three_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/uniform_supply/medic_equip_charlie, medic_vendor_charlie)
		UnregisterSignal(medic_vendor_charlie, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medic_vendor_charlie.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medic_vendor_charlie)
		message_to_player("This pouch contains a set of pills. You can only get these pill packets from your personal or squad vendor.")
		update_objective("")
		addtimer(CALLBACK(src, PROC_REF(pouch_ten)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_ten()
	message_to_player("It will be up to you to figure out which of these you should take. You can consider using these pouches, or placing some of them in your satchel/backpack.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(pouch_eleven)), 6 SECONDS)

/datum/tutorial/marine/medical_basic_item/proc/pouch_eleven()
	SIGNAL_HANDLER

	message_to_player("Feel free to examine these items. When you are finished, eat the food to end the tutoiral.")
	update_objective("Eat the food bar when you are ready to end the tutorial")
	var/obj/item/reagent_container/food/snacks/protein_pack/food = new(loc_from_corner(3, 3))
	add_to_tracking_atoms(food)
	add_highlight(food)
	RegisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK, PROC_REF(the_end))

/datum/tutorial/marine/medical_basic_item/proc/the_end()
	SIGNAL_HANDLER

	message_to_player("Good luck Marine")
	update_objective("")
	tutorial_end_in(5 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS

// END OF SCRIPT HELPERS

/datum/tutorial/marine/medical_basic_item/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)


/datum/tutorial/marine/medical_basic_item/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
	new /obj/structure/surface/table/almayer(loc_from_corner(1, 4))
	new /obj/structure/surface/table/almayer(loc_from_corner(2, 4))
	new /obj/structure/surface/table/almayer(loc_from_corner(3, 4))
	new /obj/structure/surface/table/almayer(loc_from_corner(4, 4))
	new /obj/structure/surface/table/almayer(loc_from_corner(5, 4))
	var/obj/structure/machinery/cm_vending/clothing/tutorialmed/clothing_vendor = new(loc_from_corner(5, 0))
	add_to_tracking_atoms(clothing_vendor)
	var/obj/structure/machinery/cm_vending/clothing/medic_equip/medic_vendor_alpha = new(loc_from_corner(5, 1))
	add_to_tracking_atoms(medic_vendor_alpha)
	var/obj/structure/machinery/cm_vending/clothing/medic_equip_bravo/medic_vendor_bravo = new(loc_from_corner(5, 2))
	add_to_tracking_atoms(medic_vendor_bravo)
	var/obj/structure/machinery/cm_vending/sorted/uniform_supply/medic_equip_charlie/medic_vendor_charlie = new(loc_from_corner(5, 3))
	add_to_tracking_atoms(medic_vendor_charlie)
