/datum/tutorial/marine/hospital_corpsman_advanced
	name = "Marine - Hospital Corpsman (Advanced) - Under Construction"
	desc = "Learn the more advanced skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_2"
	//required_tutorial = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s7x7/hm
	var/clothing_items_to_vend = 6

// ------------ CONTENTS ------------ //
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.1 Internal Organ Damage (Chest)
// 1.2 Heart Damage
//

/datum/tutorial/marine/hospital_corpsman_advanced/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the more complex elements of playing as a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(uniform)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/uniform()

	message_to_player("Before you're ready to take on the world as a Marine Hospital Corpsman, you should probably put some clothes on...")
	message_to_player("Stroll on over to the outlined vendor and vend everything inside.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced, medical_vendor)
	add_highlight(medical_vendor, COLOR_GREEN)
	medical_vendor.req_access = list()
	RegisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(uniform_vend))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/uniform_vend(datum/source)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced, medical_vendor)
		UnregisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medical_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medical_vendor)

		var/obj/item/storage/belt/medical/lifesaver/medbelt = locate(/obj/item/storage/belt/medical/lifesaver) in tutorial_mob.contents
		add_to_tracking_atoms(medbelt)
		var/obj/item/device/healthanalyzer/healthanalyzer = new(loc_from_corner(0, 4))
		add_to_tracking_atoms(healthanalyzer)
		add_highlight(healthanalyzer, COLOR_GREEN)
		message_to_player("Great. Now pick up your trusty <b>Health Analyzer</b>, and let's get started with the tutorial!")
		update_objective("")
		addtimer(CALLBACK(src, PROC_REF(organ_tutorial)), 5 SECONDS)
		//RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial()

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("<b>Section 1: Stabilizing Types of Organ Damage</b>.")
	message_to_player("In a combat environment, <b>Internal Damage</b> can be just as deadly as its external counterparts.")
	message_to_player("A patient can accumulate internal damage in a variety of forms. However, this section will focus specifically on <b>Internal Organ Damage</b>.")
	message_to_player("A skilled Marine Hospital Corpsman (you) must be able to detect the cause and location of <b>Organ Damage</b>, as well as understanding its various methods of treatment")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_2)), 21 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_2()

	message_to_player("Like the rest of the body, damage to <b>Internal Organs</b> can be classified in levels.")
	message_to_player("As an internal organ sustains increasing amounts of damage, its condition will change from:")
	message_to_player("Healthy -> Slighty Bruised -> Bruised -> Ruptured / Broken")
	message_to_player("Each increase in organ damage severity will produce similarly life-threatening side effects on the body.")
	message_to_player("A <b>Ruptured Internal Organ</b> has been damaged beyond the point of function, and will require immediate surgical intervention from a <u>trained Doctor</u>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_chest)), 21 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest()

	message_to_player("<b>1.1 Internal Organ Damage (Chest)</b>.")

	message_to_player("Unlike the rest of the body, the condition of <b>Internal Organs</b> do not appear on a Health Analyzer scan.")
	message_to_player("Instead, a more specialized tool is used. Say hello to the humble <b>Stethoscope</b>!")

	var/obj/item/clothing/accessory/stethoscope/steth = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(steth)
	add_highlight(steth, COLOR_GREEN)

	message_to_player("Pick up the <b>Stethoscope</b>, and revel is its simple beauty.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial_chest_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest_2()

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("When someone takes any amount of <b>Internal Organ Damage</b>, the <b>Stethoscope</b> can be used in exactly the same manner as a Health Analyzer to scan their condition.")
	message_to_player("Oh, look's like our old friend <b>Mr Dummy</b> is back, and looking for a health checkup!")

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(2,2))
	add_to_tracking_atoms(human_dummy)
	add_highlight(human_dummy, COLOR_GREEN)

	message_to_player("Click on the Dummy with your <b>Stethoscope</b> in hand to test the health of their <b>Internal Organs</b>.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_chest_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest_3(datum/source, mob/living/carbon/human/being, mob/living/user)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			message_to_player("Well done! If you check the <b>Chat-Box</b> on the right of your screen, you will now see the following message from your <b>Stethoscope</b>:")
			message_to_player("You hear normal heart beating patterns, his heart is surely <u>Healthy</u>. You also hear normal respiration sounds aswell, that means his lungs are <u>Healthy</u>,")
			message_to_player("This means that all internal organs in Mr Dummys chest are <b>Fully Healthy</b>!")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart)), 22 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart()

	message_to_player("<b>Section 1.2: Heart Damage</b>.")
	message_to_player("Despite their otherwise stone-cold exterior, the heart of a combat Marine is in actuality, quite delecate.") // naturally excepting members of Delta squad
	message_to_player("A damaged heart is the most common source of <b>Oxygen Damage</b> on the field, as even small amounts of <b>Heart Damage</b> proves capable of seriously impairing the human body.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_2)), 12 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_2()
	message_to_player("Depending on the levels of damage to the heart, patients will experience escelating symptoms.")
	message_to_player("<b>Heart - Slightly Bruised (Damage: 1-9) |</b> Slowly creates up to 21 points of <b>Oxygen Damage</b>.")
	message_to_player("")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_3)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_3()
	message_to_player("<b>Heart - Bruised (Damage: 10-29) |</b> Rapidly creates 50 points of <b>Oxygen Damage</b>, and continues to create Oxygen damage at a slower pace indefinitely past this point.")
	message_to_player("")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_4)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_4()
	message_to_player("<b>Heart - Broken (Damage: 30+) |</b> The Heart has been damaged so severely, that it can no longer function. A broken Heart will rapidly and indefinitely create <b>Oxygen and Toxin Damage</b>, with no damage limit.")
	message_to_player("This condition is known as <b>Heartbreak</b>, and your response to such will be covered in later sections.")
	message_to_player("")

	//addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_5)), 8 SECONDS)


/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_33()

	message_to_player("<b>Section 1.1: Brain and Eye Damage</b>.")
	message_to_player("Brain and Eye damage are both the easiest to treat, and the easiest to incur on the field.")
	message_to_player("Both Brain and Eye damage are directly caused as a result of excessive <b>Brute Damage Injuries</b> to head.")
	message_to_player("Brain Damage is also caused by <b>Tricordrazine overdose</b>, and <b>Brain Hemorrhaging</b> (to be covered further on)")
	message_to_player("Symptoms of a <b>Bruised Brain</b> can include randomly dropping held items, sudden unconsciousness, erratic movements, headaches, and impaired vision.")
	message_to_player("As well as this, symptoms of a <b>Ruptured Brain</b> brain can <u>also include</u> sudden seizures, and paralysis.")





















/datum/tutorial/marine/hospital_corpsman_advanced/proc/oxy_tutorial()
	//message_to_player("<b>Oxygen Damage</b> is the fourth, and final form of field damage that a Marine Hospital Corpsman is expected to be able to treat.")
	//message_to_player("The mechanics of Oxygen damage are heavily linked to


/datum/tutorial/marine/hospital_corpsman_advanced/proc/tutorial_close()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Advanced</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")


	tutorial_end_in(15 SECONDS)



// TO DO LIST
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.1 Internal Organ Damage (Chest)
// 1.2 Heart Damage
// 1.3 Lung Damage
// 1.4 Brain Damage
// 1.5 Eye Damage (IA)
// 1.6 Liver and Kidney Damage
//
// Section 2 - Revivals
// 2.1 Defib
// 2.2 Revival Mix and Epi
// 2.3 CPR
// 2.4 Emergency Revivals
// 2.5 Lost Causes
//
// Section 3 - Field Surgery
// 3.1 Surgical Damage Treatment
// 3.2 Internal Bleeding
// 3.3 Synthetic Limb Repair
//
// Section 4 - Specialized Treatments
// 4.1 Medical Evacuations, Stasis
// 4.2 Genetic Damage
// 4.3 Extreme Overdoses
//




/datum/tutorial/marine/hospital_corpsman_advanced/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)


/datum/tutorial/marine/hospital_corpsman_advanced/init_map()
	var/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced/medical_vendor = new(loc_from_corner(4, 4))
	add_to_tracking_atoms(medical_vendor)
