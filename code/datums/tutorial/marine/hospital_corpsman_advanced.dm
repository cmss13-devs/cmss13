/datum/tutorial/marine/hospital_corpsman_advanced
	name = "Marine - Hospital Corpsman (Advanced) - Under Construction"
	desc = "Learn the more advanced skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_2"
	icon_state = "medic"
	//required_tutorial = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s7x7/hm
	var/clothing_items_to_vend = 6

// ------------ CONTENTS ------------ //
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.1 Internal Organ Damage (Chest)
// 1.2 Heart Damage
// 1.3 Lung Damage
// 1.4 Internal Organ Damage (Head)
// 1.5 Liver and Kidney Damage
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
		RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("<b>Section 1: Stabilizing Types of Organ Damage</b>.")
	message_to_player("In a combat environment, <b>Internal Damage</b> can be just as deadly as its external counterparts.")
	message_to_player("A patient can accumulate internal damage in a variety of forms. However, this section will focus specifically on <b>Internal Organ Damage</b>.")
	message_to_player("A skilled Marine Hospital Corpsman (you) must be able to detect the cause and location of <b>Organ Damage</b>, as well as understanding its various methods of treatment")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_2()

	message_to_player("Like the rest of the body, damage to <b>Internal Organs</b> can be classified in levels.")
	message_to_player("As an internal organ sustains increasing amounts of damage, its condition will change from:")
	message_to_player("Healthy -> [SPAN_YELLOW("Slighty Bruised")] -> [SPAN_ORANGE("Bruised")] -> [SPAN_RED("Ruptured / Broken")]")
	message_to_player("Each increase in organ damage severity will produce similarly life-threatening side effects on the body.")
	message_to_player("A <b>Ruptured Internal Organ</b> has been damaged beyond the point of function, and will require immediate surgical intervention from a <u>trained Doctor</u>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_chest)), 21 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest()

	message_to_player("<b>Section 1.1: Internal Organ Damage (Chest)</b>.")

	message_to_player("Unlike the rest of the body, the condition of <b>Internal Organs</b> do not appear on a Health Analyzer scan.")
	message_to_player("Instead, a more specialized tool is used. Say hello to the humble <b>Stethoscope</b>!")

	var/obj/item/clothing/accessory/stethoscope/steth = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(steth)
	add_highlight(steth, COLOR_GREEN)

	message_to_player("Pick up the <b>Stethoscope</b>, and revel is its simple beauty.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial_chest_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest_2()
	SIGNAL_HANDLER

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

			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			remove_highlight(steth)

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart)), 14 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart()

	message_to_player("<b>Section 1.2: Heart Damage</b>.")
	message_to_player("Despite their otherwise stone-cold exterior, the heart of a combat Marine is in actuality, quite delecate.") // naturally excepting members of Delta squad
	message_to_player("A damaged heart is the most common source of <b>Oxygen Damage</b> on the field, as even small amounts of <b>Heart Damage</b> proves capable of seriously impairing the human body.")
	message_to_player("Heart damage can be caused as a result of moving with an <b>Unsplinted Chest Fracture, Extreme Brute Damage</b>, or being shot by an <b>Armor Piercing Bullet</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_2)), 18 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_2()
	message_to_player("Depending on the levels of damage to the heart, patients will experience escelating symptoms.")
	message_to_player("<b>Heart - Slightly Bruised (Damage: 1-9) |</b> Slowly creates up to 21 points of <b>Oxygen Damage</b>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_3)), 10 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_3()
	message_to_player("<b>Heart - Bruised (Damage: 10-29) |</b> Rapidly creates 50 points of <b>Oxygen Damage</b>, and continues to create Oxygen damage at a slower pace indefinitely past this point.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_4)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_4()
	message_to_player("<b>Heart - Broken (Damage: 30+) |</b> The Heart has been damaged so severely, that it can no longer function. A broken Heart will rapidly and indefinitely create <b>Oxygen and Toxin Damage</b>, with no damage limit.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_5)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_5()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(12, "heart")
	human_dummy.setOxyLoss(15)
	message_to_player("Mr Dummy has taken some <b>Internal Organ Damage</b> in his <b>Chest</b>! Use your <b>Stethoscope</b> on his chest to determine his condition.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	add_highlight(steth, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_heart_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_6(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			remove_highlight(steth)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Stethoscope</b> has reported that: you hear deviant heart beating patterns, result of <u>probable heart damage</u>.")
			message_to_player("This tells you that Mr Dummy's Heart is <b>Bruised</b>, and will begin creating <b>Oxygen Damage</b> in his body.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_7_pre)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_7_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/dex = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(dex)
	medbelt.update_icon()

	dex.name = "\improper Dexalin pill bottle"
	dex.icon_state = "pill_canister1"
	dex.maptext_label = "Dx"
	dex.maptext = SPAN_LANGCHAT("Dx")
	dex.max_storage_space = 1
	dex.overlays.Cut()
	dex.bottle_lid = FALSE
	dex.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/dexalin/pill = new(dex)

	add_to_tracking_atoms(pill)
	add_to_tracking_atoms(dex)


	message_to_player("To counteract this, a <b>Dexalin Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Feed the Dummy a <b>Dexalin Pill</b> to heal the <b>Oxygen Damage</b> created by his bruised Heart.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Dexalin Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(dex, COLOR_GREEN)

	RegisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_heart_7))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_7()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/dexalin, pill)

	UnregisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Dexalin Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Dexalin pill.")

	add_highlight(pill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(dex)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_reject))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(dex)
	qdel(dex)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_7_pre)), 2 SECONDS)


/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	remove_from_tracking_atoms(dex)
	qdel(dex)

	message_to_player("Well done. The Dexalin will slowly begin to reduce the amount of Oxygen damage in the Dummys body.")
	message_to_player("However, the Dexalin in the Dummys body is only counteracting the Oxygen damage created by the bruised Heart, and not any of its other side-effects.")
	message_to_player("This is where the chemical <b>Peridaxon</b> comes in to play.")
	message_to_player("<b>Peridaxon</b> is, without a doubt, the most useful tool at a Medics disposal when treating various types of organ damage.")
	message_to_player("When fed to a patient suffering from <b>Internal Organ Damage</b>, a <b>Peridaxon Pill</b> can <u>TEMPORARILY</u> return damaged internal organs to a fully healthy state.")
	message_to_player("However, this does <b>NOT</b> actually heal damaged organs, and all symptoms will return once the Peridaxon has been fully metabolized.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_8_pre)), 24 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_8_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/peri = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(peri)
	medbelt.update_icon()

	peri.name = "\improper Peridaxon pill bottle"
	peri.icon_state = "pill_canister10"
	peri.maptext_label = "Pr"
	peri.maptext = SPAN_LANGCHAT("Pr")
	peri.max_storage_space = 1
	peri.overlays.Cut()
	peri.bottle_lid = FALSE
	peri.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/peridaxon/peripill = new(peri)

	add_to_tracking_atoms(peripill)
	add_to_tracking_atoms(peri)


	message_to_player("A <b>Peridaxon Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Peridaxon Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(peri, COLOR_GREEN)

	RegisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_heart_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/peridaxon, peripill)

	UnregisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Peridaxon Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Peridaxon pill.")

	add_highlight(peripill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(peri)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_reject))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(peri)
	qdel(peri)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_8_pre)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	remove_from_tracking_atoms(peri)
	qdel(peri)

	message_to_player("Well done! The Dummys condition has been stabilized.. at least until the medication wears off.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()

	message_to_player("<b>Section 1.3: Lung Damage</b>.")

	message_to_player("As you may have guessed, the second vital organ in the chest is of course, the <b>Lungs</b>!")
	message_to_player("The Lungs, alongside other functions, allow Marines to breathe while carrying out their combat-related duties.")
	message_to_player("Like Heart damage, <b>Lung Damage</b> can be caused by moving with an <b>Unsplinted Chest Fracture, Extreme Brute Damage</b>, or being shot by an <b>Armor Piercing Bullet</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_2)), 20 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_2()

	message_to_player("However, unlike Heart damage, symptoms of <b>Lung Damage</b> will only appear <u>beyond the point of rupture</u>.")
	message_to_player("A <b>Bruised Lung</b> will generate no harmful side-effects on the body, but is still detectable with a <b>Stethoscope</b>.")
	message_to_player("Once the Lungs have taken more than <b>30 Points of Internal Damage</b>, they will become <b>Ruptured</b>.")
	message_to_player("<b>Ruptured Lungs</b> will create <b>Oxygen Damage</b> at a rapid pace, as well as causing afflicted patients to cough up blood.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_3)), 20 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_3()

	message_to_player("Mr Dummys Lungs are looking rather squishy... Use your <b>Stethoscope</b> to test the condition of his <b>Lungs</b>.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(35, "lungs")
	human_dummy.setOxyLoss(15)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	add_highlight(steth, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_lungs_4))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_4(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			remove_highlight(steth)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Stethoscope</b> has reported that: you [SPAN_RED("barely hear any respiration sounds")] and a lot of difficulty to breath, the Dummys lungs are [SPAN_RED("heavily failing")]")
			message_to_player("This tells you that Mr Dummys Lungs have <b>Ruptured</b>, and <u>need to be stabilized immediately</u>.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_5)), 11 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_5(datum/source, obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/dex = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(dex)
	medbelt.update_icon()

	dex.name = "\improper Dexalin pill bottle"
	dex.icon_state = "pill_canister1"
	dex.maptext_label = "Dx"
	dex.maptext = SPAN_LANGCHAT("Dx")
	dex.max_storage_space = 1
	dex.overlays.Cut()
	dex.bottle_lid = FALSE
	dex.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/dexalin/pill = new(dex)

	add_to_tracking_atoms(pill)
	add_to_tracking_atoms(dex)


	message_to_player("To counteract the immediate <b>Oxygen Damage</b>, a <b>Dexalin Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Dexalin Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(dex, COLOR_GREEN)

	RegisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_lungs_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/dexalin, pill)

	UnregisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Dexalin Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Dexalin pill.")

	add_highlight(pill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(dex)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(dex)
	qdel(dex)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_5)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	remove_from_tracking_atoms(dex)
	qdel(dex)

	message_to_player("Well done. Next, we need to stabilize Mr Dummys <b>Ruptured Lungs</b> with <b>Peridaxon</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_7)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_7(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/peri = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(peri)
	medbelt.update_icon()

	peri.name = "\improper Peridaxon pill bottle"
	peri.icon_state = "pill_canister10"
	peri.maptext_label = "Pr"
	peri.maptext = SPAN_LANGCHAT("Pr")
	peri.max_storage_space = 1
	peri.overlays.Cut()
	peri.bottle_lid = FALSE
	peri.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/peridaxon/peripill = new(peri)

	add_to_tracking_atoms(peripill)
	add_to_tracking_atoms(peri)


	message_to_player("A <b>Peridaxon Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Peridaxon Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(peri, COLOR_GREEN)

	RegisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_lungs_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/peridaxon, peripill)

	UnregisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Peridaxon Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Peridaxon pill.")

	add_highlight(peripill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(peri)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(peri)
	qdel(peri)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_7)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	remove_from_tracking_atoms(peri)
	qdel(peri)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	remove_highlight(steth)
	remove_from_tracking_atoms(steth)
	qdel(steth)

	message_to_player("Well done! The Dummys condition has been stabilized.")
	message_to_player("However, one Peridaxon pill will be fully metabolized in just over <u>5 minutes</u>, at which point full symptoms will return.")
	message_to_player("Once you have stabilized a patient with a ruptured organ, you <u>MUST</u> transport them to a <b>Trained Doctor for Surgery</b> as <u>SOON AS POSSIBLE</u>.")

	human_dummy.rejuvenate()

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head)), 10 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head()

	message_to_player("<b>Section 1.4: Internal Organ Damage (Head)</b>.")
	message_to_player("Inside the skulls of most Marines, a <b>Brain</b> and <b>Eyes</b> can typically be found.")
	message_to_player("While the presence of the former is sometimes debated in particular Marines, a Hospital Corpsman remains responsible for the health of both.")
	message_to_player("Both Brain and Eye damage are directly caused as a result of excessive <b>Brute Damage Injuries</b> to head.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_2)), 17 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_2()

	message_to_player("In addition to <b>Brute Damage</b>, Brain Damage is also caused by <b>Tricordrazine overdose</b>, and <b>Brain Hemorrhaging</b> (to be covered further on)")
	message_to_player("Symptoms of a <b>Bruised Brain</b> can include randomly dropping held items, sudden unconsciousness, erratic movements, headaches, and impaired vision.")
	message_to_player("As well as this, symptoms of a <b>Ruptured Brain</b> brain can <u>also include</u> sudden seizures, and paralysis.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_3)), 15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_3()

	message_to_player("<b>Brain</b> and <b>Eye</b> damage can be detected in a patient using a simple <b>Pen Light</b>!")
	message_to_player("Pick up the <b>Pen Light</b>, then press <b>[retrieve_bind("activate_inhand")]</b> to switch its light on.")

	var/obj/item/device/flashlight/pen/pen = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pen)
	add_highlight(pen, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(organ_tutorial_head_4))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_4(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/device/flashlight/pen))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)

	message_to_player("Well done!")
	message_to_player("Now, use the <b>Zone Selection Element</b> on the bottom right of your HUD to target the <b>Eyes</b>, a smaller zone within the Head.")
	message_to_player("Once this is done, make sure you are on the green <b>Help Intent</b>, then click on the Dummy with your <b>Pen Light</b> in hand to test for damage to the organs in their head.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(35, "eyes")
	human_dummy.apply_internal_damage(15, "brain")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_PENLIGHT_USED, PROC_REF(organ_tutorial_head_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_5(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "eyes")
			message_to_player("Make sure to have the Dummys <b>Eyes</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys Eyes, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_PENLIGHT_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight/pen, pen)
			remove_highlight(pen)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Pen Light</b> has reported that: notice that the Dummys eyes are not reacting to the light, and the pupils of both eyes are not constricting with the light shine at all, the Dummy is probably [SPAN_RED("blind")].")
			message_to_player("We also see that: the Dummys pupils are >not consensually constricting when light is separately applied to each eye, meaning possible [SPAN_ORANGE("brain damage")].")
			message_to_player("This tells you that Mr Dummy has <b>Broken Eyes</b> and a <b>Bruised Brain</b>.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_6)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_6()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight/pen, pen)
	remove_from_tracking_atoms(pen)
	qdel(pen)
	message_to_player("The only way to treat Brain and Eye damage without surgical intervention, is through the use of <b>Custom Chemical Medications</b>.")
	message_to_player("<b>Custom Chemical Medications</b> describes any medicine that must be specifically synthesised by a <u>trained Chemist</u> in the Almayer Medical Bay.")
	message_to_player("Imidazoline-Alkysine <b>(IA)</b> is one such custom medication that is used to heal <b>Brain and Eye Damage</b> on the field.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_7)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_7(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/ia = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(ia)
	medbelt.update_icon()

	ia.name = "\improper IA pill bottle"
	ia.icon_state = "pill_canister11"
	ia.maptext_label = "IA"
	ia.maptext = SPAN_LANGCHAT("IA")
	ia.max_storage_space = 1
	ia.overlays.Cut()
	ia.bottle_lid = FALSE
	ia.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/imialky/iapill = new(ia)

	add_to_tracking_atoms(iapill)
	add_to_tracking_atoms(ia)


	message_to_player("An <b>IA Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>IA Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(ia, COLOR_GREEN)

	RegisterSignal(iapill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_head_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/imialky, iapill)

	UnregisterSignal(iapill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>IA Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the IA pill.")

	add_highlight(iapill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(ia)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(ia_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(ia_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/ia_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	remove_highlight(ia)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(ia)
	qdel(ia)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_7)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/ia_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	remove_highlight(ia)
	remove_from_tracking_atoms(ia)
	qdel(ia)

	message_to_player("Well done! The Dummys condition has been stabilized, and their Brain/Eye damage will rapidly heal.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_tox)), 5 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_tox()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()

	message_to_player("<b>Section 1.5: Liver and Kidney Damage</b>.")

	message_to_player("The Liver and Kidney, located in the Chest and Groin respectively, are the final two internal organs to be covered in this tutorial.")
	message_to_player("Both organs can be damaged by moving with an <b>Unsplinted Bone Fracture</b> in their respective regions, as well as from extreme amounts of <b>Brute damage</b> to either area.")
	message_to_player("Both the Liver and Kidney are <u>extremely vulnerable</u> to <b>Toxin Damage</b> in the body.")
	message_to_player("This includes <b>Alcohol Poisoning</b> in the case of the Liver <u>specifically</u>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_tox_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_tox_2()

	message_to_player("When damaged, both the Liver and Kidney will create <b>Toxin Damage</b> in the body, corresponding to the amount of damage they have <u>already taken</u>.")
	message_to_player("If not stabilized, this will create a feedback loop of endless <b>Toxin Damage</b>, eventually resulting in the complete failure of both organs.")
	message_to_player("Damage to the Liver and Kidney can only be treated via <u>surgical intervention</u>.")
	message_to_player("Marines with high levels of <b>Toxin Damage</b> in their body without an obvious cause, are likely suffering from internal organ damage to their Liver or Kidney.")

	addtimer(CALLBACK(src, PROC_REF(tutorial_close)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery()

	message_to_player("<b>Section 3: Field Surgery</b>.")
	message_to_player("In this section of the tutorial, we will cover a more hands-on method of medical treatment on the field.")
	message_to_player("All Marine Hospital Corpsmen have been trained in basic surgery procedures.")
	message_to_player("This allows you to carry out simple, but highly effective procedures to heal injured Marines far closer to the frontlines than any Doctor could.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute)), 10 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute()

	message_to_player("<b>Section 3.1: Surgical Damage Treatment (Brute)</b>.")
	message_to_player("When dealing with large amounts of mundane damage focused on a specific region of the body, damage kits will prove ineffective.")
	message_to_player("This is where <b>Surgical Damage Treatment</b> comes into play!")
	message_to_player("Using tools like the <b>Surgical Line</b> (Brute) and <b>Synth-Graft</b> (Burn), a trained Hospital Corpsman can surgically treat damage for specific parts of the body")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_2)), 12 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_2()

	message_to_player("Oh no! Mr Dummy has taken a large amount of <b>Brute Damage</b>! Scan him with your <b>Health Analyzer</b> for more details.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	human_dummy.apply_damage(70, BRUTE, "chest")
	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(field_surgery_brute_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_3(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("As you can see, the Dummy has <b>75 Brute Damage</b> on their chest.")
	message_to_player("To treat this, we are going to surgically <b>Suture</b> their wounds with a <b>Surgical Line</b>.")
	message_to_player("But first, we must apply a painkiller to the Dummy, to avoid complications during surgery.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_4)), 12 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_4()
	SIGNAL_HANDLER

	message_to_player("A <b>Tramadol Pill Bottle</b> has been placed into your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Tramadol Pill Bottle</b> to draw a pill.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)

	var/obj/item/storage/pill_bottle/tram = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(tram)

	medbelt.update_icon()

	tram.name = "\improper Tramadol pill bottle"
	tram.icon_state = "pill_canister5"
	tram.maptext_label = "Tr"
	tram.maptext = SPAN_LANGCHAT("Tr")
	tram.max_storage_space = 1
	tram.overlays.Cut()
	tram.bottle_lid = FALSE
	tram.overlays += "pills_closed"
	var/obj/item/reagent_container/pill/tramadol/trampill = new(tram)

	add_to_tracking_atoms(trampill)
	add_to_tracking_atoms(tram)

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(tram, COLOR_GREEN)

	RegisterSignal(trampill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(field_surgery_brute_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_5()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/tramadol, trampill)

	UnregisterSignal(trampill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Tramadol Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Tramadol pill.")

	add_highlight(trampill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(tram)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(tram_pill_fed))
	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(tram_pill_fed_reject))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/tram_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	remove_highlight(tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(tram)
	qdel(tram)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_3)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/tram_pill_fed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	message_to_player("Now that Mr Dummy has been medicated with a painkiller, we can begin surgery on their chest.")
	message_to_player("Pick up the <b>Surgical Line</b> on the desk, and click on Mr Dummy with it while <u>targeting his chest</u> to begin the surgery")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	remove_highlight(tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(tram)
	qdel(tram)
	medbelt.update_icon()

	var/obj/item/tool/surgery/surgical_line/surgical_line = new(loc_from_corner(1,4))
	add_to_tracking_atoms(surgical_line)
	add_highlight(surgical_line, COLOR_GREEN)

	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_dummy.limbs
	add_to_tracking_atoms(mob_chest)
	add_highlight(mob_chest, COLOR_GREEN)

	RegisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED, PROC_REF(field_surgery_brute_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)

	UnregisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED)
	remove_highlight(mob_chest)
	remove_highlight(surgical_line)

	message_to_player("Well done! Suturing wounds can only heal up to <u>half</u> of the regions overall damage, and should be used alongside other methods of treatment.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_burn)), 5 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)
	remove_from_tracking_atoms(surgical_line)
	qdel(surgical_line)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	human_dummy.apply_damage(70, BURN, "chest")
	human_dummy.pain.feels_pain = FALSE //so that we dont need to reapply tramadol

	message_to_player("Like Brute damage treatment, <b>Burn Damage</b> can also be surgically treated using a <b>Synth-Graft</b>.")
	message_to_player("Mr Dummy has taken additional <b>Burn Damage</b> to his chest!")
	message_to_player("Pick up your <b>Synth-Graft</b>, and apply it to the Dummys <b>Chest</b>.")

	var/obj/item/tool/surgery/synthgraft/graft = new(loc_from_corner(1,4))
	add_to_tracking_atoms(graft)
	add_highlight(graft, COLOR_ORANGE)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	add_highlight(mob_chest, COLOR_ORANGE)

	RegisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED, PROC_REF(field_surgery_burn_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn_2()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/synthgraft, graft)

	UnregisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED)
	remove_highlight(mob_chest)
	remove_from_tracking_atoms(mob_chest)
	remove_highlight(graft)

	message_to_player("Well done! Mr Dummy has been healed!")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_burn_3)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn_3()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	human_dummy.pain.feels_pain = TRUE
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/synthgraft, graft)
	remove_from_tracking_atoms(graft)
	qdel(graft)

	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib)), 1 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib()

	message_to_player("<b>Section 3.2: Internal Bleeding</b>.")

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_2()

	message_to_player("While not as extensively fitted as a proper surgical kit, Combat Medics recieve <b>Basic Surgical Case</b> for field use.")

	var/obj/item/storage/surgical_case/regular/surgical_case = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(surgical_case)
	add_highlight(surgical_case, COLOR_GREEN)

	message_to_player("Pickup your <b>Basic Surgical Case</b>, highlighted in green!")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(field_surgery_ib_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_3()

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("Excellent! Your <b>Basic Surgical Case</b> comes pre-fitted with three tools; a <b>Scalpel, Hemostat, and Retractor</b>.")
	message_to_player("These can be used to create <b>Incisions</b> on the body, which are the first step to most surgeries.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/surgical_case/regular, surgical_case)
	remove_highlight(surgical_case)

	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_4)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_4()

	var/obj/item/roller/foldedroller = new(loc_from_corner(1, 4))
	add_to_tracking_atoms(foldedroller)
	add_highlight(foldedroller, COLOR_GREEN)

	message_to_player("Some surgeries require the patient to be laying down on a secure surface, such as an Operating Table.")
	message_to_player("However, for the purposes of field surgery, we will have to make do with a <b>Roller Bed</b>.")
	message_to_player("<b>Roller Beds</b> serve a dual function, being able to quickly transport patients, as well as acting as a <b>Secure Surface</b> to carry out surgeries.")
	message_to_player("Pickup the <b>Folded Roller Bed</b>, walk to the middle of the room, then press the <b>[retrieve_bind("activate_inhand")]</b> key while holding it in hand to unfold it.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ROLLER_DEPLOYED, PROC_REF(field_surgery_ib_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_5(datum/source, obj/structure/bed/roller/rollerdeployed)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ROLLER_DEPLOYED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/roller, foldedroller)
	remove_highlight(foldedroller)
	remove_from_tracking_atoms(foldedroller)

	add_to_tracking_atoms(rollerdeployed)
	add_highlight(rollerdeployed, COLOR_GREEN)
	rollerdeployed.anchored = TRUE

	message_to_player("Excellent! Now, to prepare Mr Dummy for surgery, we need to buckle him to the Roller Bed.")
	message_to_player("Set your intent to the yellow <b>Grab Intent</b>, and click on Mr Dummy to grab them.")

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_6()

	message_to_player("Then, drag them next to the <b>Roller Bed</b>, and click and drag your mouse from Mr Dummy, to the Roller bed to buckle them into it.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_LIVING_SET_BUCKLED, PROC_REF(field_surgery_ib_7))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_7()

	//TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	//if(human_dummy.buckled)
	//	UnregisterSignal(human_dummy, COMSIG_LIVING_SET_BUCKLED)
	//	message_to_player("Well done! It is important that you keep the Dummy secured to the roller bed for the rest of the surgery tutorial.")
	//	message_to_player("")













// SCRATCHPAD

/datum/tutorial/marine/hospital_corpsman_advanced/proc/oxy_tutorial()
	//message_to_player("<b>Oxygen Damage</b> is the fourth, and final form of field damage that a Marine Hospital Corpsman is expected to be able to treat.")
	//message_to_player("The mechanics of Oxygen damage are heavily linked to


//

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
// Oxygen Damage
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.5 Liver and Kidney Damage
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
