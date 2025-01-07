/datum/tutorial/marine/debug
	name = "Marine - Hospital Corpsman (Debug)"
	desc = "Learn the basic skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_debug"
	//required_tutorial = "marine_basic_1"
	tutorial_template = /datum/map_template/tutorial/s7x7/hm
	var/clothing_items_to_vend = 4
	var/ontime
	var/stage = 0
	var/handle_pill_bottle_status = 0
	var/cpr_count = 0

	var/mob/living/carbon/human/realistic_dummy/marine_dummy

// ------------ CONTENTS ------------ //
//
// Section 0 - Equipment and You
//
// Section 1 - Basic Damage Treatment
// 1.1 Brute Damage
// 1.2 Burn Damage
// 1.3 Treating Bleeding
// 1.4 Shrapnel Removal
// 1.5 Bone Fractures
//
// Section 2 - Intermediate Damage Treatment
// 2.1 Pain Levels
// 2.2 Toxin Damage
// 2.3 Overdoses
//

/datum/tutorial/marine/debug/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the fundamental skills for playing a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(spawning)), 2 SECONDS)

/datum/tutorial/marine/debug/proc/spawning(datum/source)
	SIGNAL_HANDLER

	new /obj/item/clothing/under/marine/medic(loc_from_corner(0, 4))
	var/obj/item/storage/belt/medical/lifesaver/medbelt = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(medbelt)
	add_highlight(medbelt, COLOR_GREEN)
	marine_dummy = new(loc_from_corner(2,2))
	add_to_tracking_atoms(marine_dummy)
	var/obj/item/device/healthanalyzer/healthanalyzer = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(healthanalyzer)
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in marine_dummy.limbs
	add_to_tracking_atoms(mob_chest)
	var/obj/item/storage/surgical_case/regular/surgical_case = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(surgical_case)
	add_highlight(surgical_case, COLOR_GREEN)
	var/obj/item/clothing/suit/storage/marine/medium/armor = marine_dummy.get_item_by_slot(WEAR_JACKET)
	add_to_tracking_atoms(armor)
	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_to_tracking_atoms(human_hud)
	addtimer(CALLBACK(src, PROC_REF(medevacs)), 1 SECONDS)


/datum/tutorial/marine/debug/proc/medevacs(datum/source, obj/structure/closet/bodybag/stasisbag)

	switch(stage)
		if(0)
			slower_message_to_player("<b>Section 4.1: Medical Evacuations, Stasis</b>.")
			slower_message_to_player("Despite the vast skillset of a Marine Hospital Corpsman, the condition of some patients occasionally fall beyond your abilities of care.")

			stage++
			addtimer(CALLBACK(src, PROC_REF(medevacs)), 16 SECONDS)
			return

		if(1)
			slower_message_to_player("Namely, a HM is unable to repair organ damage, bone fractures, <u>SEVERE</u> overdoses, or <b>Larva Infections</b>.")
			slower_message_to_player("In these situations, you should defer treatment to a <u>trained Doctor</u> or <u>Synthetic</u> on the field.")
			slower_message_to_player("If no Doctor or Synthetic is immediately available, or if a patient has been infected with an <b>Alien Larva (Hugged)</b>, you will need to perform a <b>Medical Evacuation (MedEvac)</b>.")

			stage++
			addtimer(CALLBACK(src, PROC_REF(medevacs)), 22 SECONDS)
			return

		if(2)
			slower_message_to_player("<b>MedEvacs</b>, in general terms, describe the process of transporting a patient from the field, to the Almayer medbay for treatment.")
			slower_message_to_player("Primarily, this is done with a <b>MedEvac Bed</b>! One of which has just appeared in the tutorial chamber!")

			slower_message_to_player("<b>MedEvac Beds</b> work by sending a signal to an overhead dropship, commonly dropship <b>Normandy</b>, allowing for a secured patient to be airlifted and transported back to the Almayer at record pace for treatment!")

			var/obj/structure/bed/medevac_stretcher/prop/medevac = new(loc_from_corner(2, 1))
			add_to_tracking_atoms(medevac)
			add_highlight(medevac, COLOR_GREEN)

			stage++
			addtimer(CALLBACK(src, PROC_REF(medevacs)), 25 SECONDS)
			return

		if(3)
			marine_dummy.say("Doc, I've been hugged!")

			slower_message_to_player("For example, our good friend Pvt Dummy insists that they've been 'hugged' (Infected) by an Alien Facehugger, and will require <u>URGENT</u> surgery to prevent a chestbursting.")
			slower_message_to_player("Since we are unable to carry out a Larva removal surgery ourselves, we must <b>MedEvac</b> Pvt Dummy as soon as possible!")
			slower_message_to_player("First, we must place Pvt Dummy into a <b>Stasis Bag</b>, a fully enclosing cover that slows the internals of Pvt Dummy.")
			slower_message_to_player(" A <b>Stasis Bag</b> greatly reduces the growth-rate of Alien Larva inside of a patient (as well as extends the time until he chestbursts), giving the Almayer Doctors more time to operate without incident.")
			slower_message_to_player("Pick up the <b>Stasis Bag</b> from the desk, and press <b>[retrieve_bind("activate_inhand")]</b> to deploy it!")

			var/obj/item/bodybag/cryobag/cryobag = new(loc_from_corner(0, 4))
			add_highlight(cryobag, COLOR_GREEN)

			stage++
			RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_BODYBAG_DEPLOYED, PROC_REF(medevacs))
			return

		if(4)
			UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_BODYBAG_DEPLOYED)
			add_highlight(stasisbag, COLOR_GREEN)
			add_to_tracking_atoms(stasisbag)

			slower_message_to_player("Excellent, now, drag Pvt Dummy over the <b>Stasis Bag</b> and click anywhere over the bag to <u>zip it closed</u>!")

			slower_message_to_player("Now that Pvt Dummy is secured in the <b>Stasis Bag</b>, drag the closed bag to the <b>MedEvac Bed</b> and secure it within by clicking and dragging your mouse from the Stasis Bag to the Medevac Bed while next to both.")

			stage++
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/medevac_stretcher/prop, medevac)
			RegisterSignal(medevac, COMSIG_LIVING_BED_BUCKLED, PROC_REF(medevacs))
			return

		if(5)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/medevac_stretcher/prop, medevac)
			UnregisterSignal(medevac, COMSIG_LIVING_BED_BUCKLED)
			slower_message_to_player("While this is just a simulation, in a real situation, you would next attempt to contact the <b>Close-Air-Support Pilot</b> over <b>Medical Comms</b> or via a direct phonecall, and notify them that your MedEvac beacon is active, as well as the <u>condition and urgency of the patient</u>.")
			slower_message_to_player("MedEvac beds <u>MUST</u> be deployed outdoors to function, always make sure you are <u>OUTSIDE</u> when using the MedEvac system.")

			stage = 0


/datum/tutorial/marine/debug/proc/tutorial_close()
	SIGNAL_HANDLER

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Advanced</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")


	tutorial_end_in(15 SECONDS)

/datum/tutorial/marine/debug/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)


/datum/tutorial/marine/debug/init_map()
	var/obj/structure/machinery/cm_vending/clothing/tutorial/medic/medical_vendor = new(loc_from_corner(4, 4))
	add_to_tracking_atoms(medical_vendor)
