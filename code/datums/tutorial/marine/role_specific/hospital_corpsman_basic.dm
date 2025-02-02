/datum/tutorial/marine/role_specific/hospital_corpsman_basic
	name = "Marine - Hospital Corpsman (Basic)"
	desc = "Learn the basic skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_1"
	icon_state = "medic"
	required_tutorial = "marine_basic_1"
	tutorial_template = /datum/map_template/tutorial/s7x7/hm
	var/clothing_items_to_vend = 4

	var/mob/living/carbon/human/realistic_dummy/marine_dummy

	/// For use in the handle_pill_bottle helper, should always be set to 0 when not in use
	var/handle_pill_bottle_status = 0

	var/list/vendor_failsafe = list()

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
// 2.3 Oxygen Damage
// 2.4 Overdoses
//

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the fundamental skills for playing as a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(uniform)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/uniform()
	SIGNAL_HANDLER

	message_to_player("<b>Section 0 - Equipment and You</b>.")

	message_to_player("Before you're ready to take on the world as a Marine Hospital Corpsman, you should probably put some clothes on...")
	message_to_player("Stroll on over to the outlined vendor and vend everything inside.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic, medical_vendor)
	add_highlight(medical_vendor, COLOR_GREEN)
	medical_vendor.req_access = list()
	RegisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(uniform_vend))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/uniform_vend(datum/source, obj/structure/machinery/cm_vending/vendor, obj/item/new_item)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	vendor_failsafe |= new_item
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic, medical_vendor)
		UnregisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medical_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medical_vendor)

		var/obj/item/storage/belt/medical/lifesaver/medbelt = locate(/obj/item/storage/belt/medical/lifesaver) in vendor_failsafe
		add_to_tracking_atoms(medbelt)
		add_highlight(medbelt, COLOR_GREEN)

		message_to_player("Well done. This comprises the most basic gear available to a Marine Hospital Corpsman")
		message_to_player("Alongside your standard uniform, you are also provided a <b>M276 Lifesaver Bag</b>, which you are currently wearing on your belt slot.")
		message_to_player("Although yours is empty at the moment, the <b>M276 Lifesaver Bag</b> typically holds a wide range of essential medical gear, which you will be introduced to as you progress this tutorial.")

		addtimer(CALLBACK(src, PROC_REF(scanner)), 13 SECONDS)


/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/scanner()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_highlight(medbelt)

	message_to_player("On the topic of introductions! You should get to know your new best friend, the <b>Health Analyzer</b>.")
	var/obj/item/device/healthanalyzer/healthanalyzer = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	message_to_player("Pick up the <b>Health Analyzer</b> by clicking on it with an empty hand.")
	update_objective("Pick up the Health Analyzer.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(scanner_2))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/scanner_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)
	message_to_player("The first step to any medical treatment, is identifying the source and type of injury.")
	message_to_player("You can use your <b>Health Analyzer</b> on wounded Marines to see the locations, severity, and types of damage they have sustained.")
	addtimer(CALLBACK(src, PROC_REF(medihud)), 8 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/medihud()
	SIGNAL_HANDLER

	message_to_player("Next, you should get to know a Medic's second best friend on the field, the <b>HealthMate HUD</b>.")
	message_to_player("The <b>HealthMate HUD</b> is an extremely useful device that fits over one eye, allowing you to scan anyones condition at a glance.")
	message_to_player("Squad Medical helmets come with an inbuilt <b>HealthMate HUD</b> optic, that activates whilst wearing it on your head.")
	message_to_player("Pick up the <b>M10 corpsman helmet</b>, and wear it on your head, highlighted in green.")

	var/obj/item/clothing/head/helmet/marine/medic/helmet = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(helmet)
	add_highlight(helmet, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_EQUIPPED_ITEM, PROC_REF(medihud_2))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/medihud_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_EQUIPPED_ITEM)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/head/helmet/marine/medic, helmet)
	remove_highlight(helmet)

	message_to_player("While not as detailed as a health analyzer scan, your <b>HealthMate HUD</b> will display a healthbar over the head of any injured Marine, which will indicate their general condition.")
	message_to_player("When someone does not have a healthbar over their head, or when their healthbar disappears, that means they are <b>fully healthy</b>.")
	message_to_player("As you progress through the following sections of the tutorial, pay attention to how the Dummys healthbar changes with different injuries.")

	addtimer(CALLBACK(src, PROC_REF(brute_tutorial)), 16 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial()

	message_to_player("<b>Section 1: Basic Damage Treatment</b>")
	message_to_player("<b>Section 1.1: Brute Damage</b>")
	message_to_player("There are two main types of damage a Marine can sustain through injuries, each with a different method of treatment.")
	message_to_player("The first kind of damage is <b>Brute</b>, the most common kind. It represents physical trauma from things like punches, weapons, or guns.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_2)), 15 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_2(datum/source, obj/item/device/healthanalyzer)
	SIGNAL_HANDLER

	marine_dummy = new(loc_from_corner(2,2))
	add_to_tracking_atoms(marine_dummy)
	arm_equipment(marine_dummy, /datum/equipment_preset/uscm/tutorial_rifleman/mrdummy)
	marine_dummy.apply_damage(5, BRUTE, "chest")
	message_to_player("The Dummy has taken some kind of brute damage. Stand next to them, and click on their body with your <b>Health Analyzer</b> in hand to scan them.")
	add_highlight(marine_dummy, COLOR_GREEN)
	update_objective("Click on the Dummy with your Health Analyzer")
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(scanner_3))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/scanner_3(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return


	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("Good. By looking at the Health Analyzer interface, we can see they have 5 brute damage on their chest.")
	message_to_player("A chemical called <b>Bicaridine</b> is used to heal brute damage over time.")
	message_to_player("<b>Bicaridine</b> is primarily given in pill form.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_3_pre)), 11 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_3_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	handle_pill_bottle(marine_dummy, "Bicaridine", "Bi", "11", /obj/item/reagent_container/pill/bicaridine)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(brute_tutorial_3_pre), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(brute_pill_fed))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_pill_fed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)

	message_to_player("When administered in pill form, chemicals take a few seconds to be digested before they can enter the patients bloodstream, and heal damage.")
	message_to_player("Medications administered when a patient is dead will not heal damage until the patient has been revived.")

	update_objective("")

	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_4)), 9 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_4()
	SIGNAL_HANDLER

	marine_dummy.rejuvenate()
	marine_dummy.apply_damage(5, BRUTE, "chest")

	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use/brute_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brute_injector)
	add_highlight(brute_injector)

	message_to_player("Medicines can also be directly injected into the bloodstream using <b>Autoinjectors</b>, allowing the medication to begin work immediately without the need to be digested first.")
	message_to_player("Click on the <b>Bicaridine Autoinjector</b> with an empty hand to pick it up, and then click on the Dummy while standing next to it to administer an injection.")
	update_objective("Pick up and inject the Dummy with the Bicaridine autoinjector.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(brute_inject_self))
	RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(brute_tutorial_5_pre))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	QDEL_IN(brute_injector, 2 SECONDS)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_4)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_5_pre()
	//adds a slight grace period, so humans are not rejuved before bica is registered in their system

	message_to_player("Well done!")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_5)), 3 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_5()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()
	marine_dummy.apply_damage(10, BRUTE, "chest", 0, 0)
	marine_dummy.apply_damage(10, BRUTE, "l_arm", 0, 0)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	qdel(brute_injector)
	update_objective("")
	message_to_player("The Dummy has taken some moderate brute damage on two different limbs. Stand next to them, and click on their body with your <b>Health Analyzer</b> in hand to scan them.")
	add_highlight(marine_dummy, COLOR_GREEN)
	update_objective("Click on the Dummy with your Health Analyzer")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(brute_tutorial_6))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_6()
	SIGNAL_HANDLER

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("As you can see, the Dummy has taken 10 brute damage to its chest and left arm.")
	message_to_player("More severe injuries can be treated through the use of <b>Advanced Trauma Kits</b>.")
	message_to_player("These items are used to treat moderate to high levels of brute damage, but must be manually applied to each damaged limb.")
	message_to_player("They only heal 12 damage per application, and should be used alongside medicines like <b>Bicaridine</b> when treating a patient.")

	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_7)), 14 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_7()
	SIGNAL_HANDLER

	var/obj/item/stack/medical/advanced/bruise_pack/brutekit = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brutekit)
	add_highlight(brutekit, COLOR_GREEN)
	message_to_player("We will first focus on healing the wound on the Dummy's chest.")
	message_to_player("Click on the <b>Advanced Trauma Kit</b> with an empty hand to pick it up, then click on the Dummy while standing next to them to apply the trauma kit.")

	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in marine_dummy.limbs
	add_to_tracking_atoms(mob_chest)
	RegisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES, PROC_REF(brute_tutorial_8))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	UnregisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES)

	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_to_tracking_atoms(human_hud)
	add_highlight(human_hud.zone_sel)
	message_to_player("Well done!")
	message_to_player("<b>Advanced Trauma Kits</b> can only be applied to one section of the body at a time, and you must select which part of the body you are trying to heal.")
	message_to_player("Since we are manually applying the trauma kit to two different limbs, we will need to change our selected limb to the Dummy's left arm.")
	message_to_player("Use the highlighted <b>zone selection</b> element on the bottom right of your HUD, and change your target to the <b>left arm</b> by clicking the left arm on the little man in the selection box")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ZONE_SEL_CHANGE, PROC_REF(brute_tutorial_9))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/brute_tutorial_9(datum/source, zone_selected)
	SIGNAL_HANDLER

	if(zone_selected != "l_arm")
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ZONE_SEL_CHANGE)

	message_to_player("Excellent. By using your <b>zone selection</b> element to target the left arm, we are now able to apply treatments to that specific zone of the body.")
	message_to_player("Now, just like before, keep the left arm selected, and click on the Dummy while holding the <b>Advanced Trauma Kit</b> in your hand to apply it to their left arm")

	var/obj/limb/arm/l_arm/mob_larm = locate(/obj/limb/arm/l_arm) in marine_dummy.limbs
	add_to_tracking_atoms(mob_larm)
	RegisterSignal(mob_larm, COMSIG_LIMB_ADD_SUTURES, PROC_REF(burn_tutorial))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/arm/l_arm, mob_larm)
	UnregisterSignal(mob_larm, COMSIG_LIMB_ADD_SUTURES)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/advanced/bruise_pack, brutekit)
	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)

	marine_dummy.rejuvenate()
	remove_highlight(brutekit)
	qdel(brutekit)
	remove_from_tracking_atoms(brutekit)
	remove_highlight(human_hud.zone_sel)
	update_objective("")

	marine_dummy.rejuvenate()

	marine_dummy.adjustFireLoss(40)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)

	message_to_player("Great work! That covers the three basic methods to treat <b>Brute</b> damage on the field.")
	message_to_player("<b>Section 1.2: Burn Damage</b>")
	message_to_player("The next most common type of injury is <b>Burn</b> damage. It is obtained from things like acid or being set on fire.")
	message_to_player("The Dummy has taken a large amount of <b>Burn</b> damage. Use your <b>Health Analyzer</b> to scan their condition.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(burn_tutorial_2_pre))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_2_pre(datum/source, obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_2_return)), 1 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_2_return()
	SIGNAL_HANDLER

	message_to_player("Unlike brute damage, <b>burn</b> damage is very rarely concentrated on one part of the body, more commonly spread across multiple limbs.")
	message_to_player("Because of this, medication is the most effective treatment for burn wounds, as they heal the whole body at once.")
	message_to_player("<b>Kelotane</b> is used to fix burn over time.")

	handle_pill_bottle(marine_dummy, "Kelotane", "Kl", "2", /obj/item/reagent_container/pill/kelotane)

	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(burn_tutorial_2_return), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(burn_tutorial_3))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_3()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)

	message_to_player("Well done!")
	message_to_player("While rare, when a large amount of <b>Burn</b> damage is concentrated on a single part of the body, we can apply an <b>Advanced Burn Kit</b> to quickly heal a portion of damage.")
	update_objective("")

	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_4)), 11 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_4()
	SIGNAL_HANDLER


	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()
	marine_dummy.apply_damage(40, BURN, "chest", 0, 0)
	var/obj/item/stack/medical/advanced/ointment/burnkit = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burnkit)
	add_highlight(human_hud.zone_sel)
	add_highlight(burnkit, COLOR_GREEN)

	message_to_player("The Dummy has taken concentrated burn damage on their <b>chest</b>. We will use an <b>Advanced Burn Kit</b> on the area.")
	message_to_player("First make sure you are targeting the chest in the <b>zone selection</b> element, highlighted on the bottom right of your hud. Then click on the Dummy with your <b>Advanced Burn Kit</b> in hand, while standing next to them, to treat their burn wound.")

	RegisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES, PROC_REF(burn_tutorial_5))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_5()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	UnregisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES)

	message_to_player("Good work! We will now use our <b>Health Analyzer</b> to scan the Dummy, to see how much burn damage remains on their chest.")

	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/advanced/ointment, burnkit)
	remove_highlight(human_hud.zone_sel)
	remove_highlight(burnkit)
	qdel(burnkit)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)


	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(burn_tutorial_6))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_6()
	SIGNAL_HANDLER


	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use/burn_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burn_injector)
	add_highlight(burn_injector)

	message_to_player("As you can see, the Dummy still has some burn damage left on their chest")
	message_to_player("To heal this remaining damage, we will use a <b>Kelotane Autoinjector</b>.")
	message_to_player("Click on the autoinjector with an empty hand to pick it up, then click on the Dummy while holding it in hand to inject them with <b>Kelotane</b>.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(burn_inject_self))
	RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(burn_tutorial_7_pre))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	QDEL_IN(burn_injector, 2 SECONDS)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_6)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/burn_tutorial_7_pre()
	SIGNAL_HANDLER

	//adds a slight grace period, so humans are not rejuved before kelo is registered in their system


	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	QDEL_IN(burn_injector, 1.5 SECONDS)

	message_to_player("Well done! This completes the basic damage treatments for brute and burn wounds.")
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial)), 3 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/bleed_tutorial()
	message_to_player("<b>Section 1.3: Treating Bleeding</b>")
	message_to_player("As you may have noticed earlier, severe brute damage injuries occasionally cause <b>bleeding</b> on the affected limb.")
	message_to_player("The Human body carries a finite amount of blood, and losing blood will accumulate internal damage, eventually causing death if not treated.")
	update_objective("")

	marine_dummy.rejuvenate()

	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_1)), 9 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/bleed_tutorial_1()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	mob_chest.add_bleeding(damage_amount = 50)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)

	message_to_player("The Dummy appears to be bleeding. Scan them with your <b>Health Analyzer</b> to identify which limb they are bleeding from.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(bleed_tutorial_2))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/bleed_tutorial_2()
	SIGNAL_HANDLER


	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("Now we can see that the Dummy is bleeding from their chest")
	message_to_player("Bleeding wounds can clot themselves over time, with this process taking longer for more severe injuries.")
	message_to_player("We can also fix it quickly with an <b>Advanced Trauma Kit</b>. Pick up the kit and click on the Dummy while targeting its chest to stop the bleeding.")

	var/obj/item/stack/medical/advanced/bruise_pack/brutekit = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brutekit)
	add_highlight(brutekit, COLOR_GREEN)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	RegisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING, PROC_REF(on_chest_bleed_stop))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	UnregisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/advanced/bruise_pack, brutekit)
	remove_from_tracking_atoms(brutekit)
	remove_highlight(brutekit)
	qdel(brutekit)


	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()

	message_to_player("Great work. The Dummy is no longer bleeding all over the floor, which is always good.")

	addtimer(CALLBACK(src, PROC_REF(shrapnel_tutorial)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/shrapnel_tutorial()
	SIGNAL_HANDLER

	message_to_player("<b>Section 1.4: Shrapnel Removal</b>")
	message_to_player("In the line of duty, Marines occasionally recieve embedded shrapnel in wounds.")
	message_to_player("Shrapnel can come in a variety of forms, all of which can be dug out of the body with a <b>Knife</b> or <b>Scalpel</b>.")
	message_to_player("Pick up the boot-knife by clicking on it with an empty hand")
	var/obj/item/attachable/bayonet/knife = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(knife)
	add_highlight(knife, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(shrapnel_tutorial_3))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/shrapnel_tutorial_3()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("Well done!")
	message_to_player("It seems that our friend PVT Dummy is suddenly injured. Use your <b>Health Analyzer</b> to scan them.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)

	var/obj/item/shard/shrapnel/tutorial/shrapnel = new
	add_to_tracking_atoms(shrapnel)
	shrapnel.on_embed(marine_dummy, mob_chest, TRUE)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(shrapnel_tutorial_4))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/shrapnel_tutorial_4()
	SIGNAL_HANDLER

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/attachable/bayonet, knife)
	add_highlight(knife, COLOR_GREEN)

	message_to_player("As you can see, the Health Analyzer is displaying the warning: <u>Recommend that the patient does not move - embedded objects.</u> This indicates that there is shrapnel somewhere in their body.")
	message_to_player("To remove the shrapnel, make sure you are on the <b>Help Intent</b>, then click on the Dummy while holding the knife to remove their shrapnel.")

	RegisterSignal(marine_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED, PROC_REF(splint_tutorial))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/splint_tutorial()
	SIGNAL_HANDLER

	message_to_player("Well done! You have removed the Dummys shrapnel from their body.")
	message_to_player("<b>Section 1.5: Bone Fractures</b>")

	UnregisterSignal(marine_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/attachable/bayonet, knife)
	remove_highlight(knife)
	remove_from_tracking_atoms(knife)
	qdel(knife)

	message_to_player("When someone recieves an exceptionally severe injury, there is a chance it might cause a <b>Bone Fracture</b> in their body.")
	message_to_player("<b>Bone Fractures</b> can easily prove fatal if left untreated, with a single Bone Fracture capable of triggering <b>Internal Bleeding</b>, and blood loss.")
	message_to_player("While <b>Bone Fractures</b> cannot be fully treated by a Hospital Corpsman through typical means, you can apply a <b>Splint</b> to the damaged area to stabilize the wound.")
	message_to_player("<b>Bone Fractures</b> can be identified through a <b>Health Analyzer</b> scan.")
	message_to_player("Scan the Dummy with your <b>Health Analyzer</b>.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	var/obj/limb/leg/l_leg/mob_lleg = locate(/obj/limb/leg/l_leg) in marine_dummy.limbs
	add_to_tracking_atoms(mob_lleg)
	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()
	mob_lleg.fracture()
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(splint_tutorial_2))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/splint_tutorial_2()
	SIGNAL_HANDLER

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	add_highlight(human_hud.zone_sel, COLOR_GREEN)

	message_to_player("As you can see, your Health Analyzer indicates the Dummy has a fracture on their <b>Left Leg</b>.")
	message_to_player("We are going to apply a <b>Splint</b> to the fractured limb.")
	message_to_player("Like Trauma Kits, you must first select which part of the body you want to apply a splint to")
	message_to_player("Select the <b>Left Leg</b> in the <b>Zone Selection</b> element, highlighted on the bottom right of your HUD. Then, click on the Dummy while holding a splint in hand to apply it to their left leg")

	var/obj/item/stack/medical/splint/splint = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(splint)
	add_highlight(splint, COLOR_GREEN)

	for(var/obj/limb/limb in marine_dummy.limbs)
		RegisterSignal(limb, COMSIG_HUMAN_SPLINT_APPLIED, PROC_REF(splint_tutorial_3_pre))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/splint_tutorial_3_pre()
	//cooldown to register splint application
	for(var/obj/limb/limb in marine_dummy.limbs)
		UnregisterSignal(limb, COMSIG_HUMAN_SPLINT_APPLIED)
	addtimer(CALLBACK(src, PROC_REF(splint_tutorial_3)), 1 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/splint_tutorial_3()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/leg/l_leg, mob_lleg)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/splint, splint)
	if(!(mob_lleg.status & LIMB_SPLINTED))
		message_to_player("You have applied a splint to the wrong limb. Make sure you have the <b>Left Leg</b> selected.")
		remove_highlight(splint)
		remove_from_tracking_atoms(splint)
		qdel(splint)
		addtimer(CALLBACK(src, PROC_REF(splint_tutorial_2)), 3 SECONDS)
		return

	message_to_player("Well done! This completes the first section of your basic training.")

	//section 1 cleanup
	remove_highlight(splint)
	remove_from_tracking_atoms(splint)
	qdel(splint)
	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	remove_highlight(human_hud.zone_sel)

	marine_dummy.rejuvenate()

	addtimer(CALLBACK(src, PROC_REF(intermediate_damage_treatment)), 3 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/intermediate_damage_treatment()

	message_to_player("<b>Section 2: Intermediate Damage Treatment</b>")
	message_to_player("Now that you have a grasp on how to treat the most common forms of damage, it's time to tackle some more complex skills in the Hospital Corpsman arsenal.")

	addtimer(CALLBACK(src, PROC_REF(pain_tutorial)), 8 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/pain_tutorial()

	message_to_player("<b>Section 2.1: Pain Levels</b>")
	message_to_player("When treating the injuries of any patient, it is critical that you also manage their <b>Pain Levels</b>.")
	message_to_player("<b>Pain Levels</b>, while not directly life threatening, can still severely debilitate an untreated Marine in the line of duty.")
	message_to_player("A Marine with high levels of pain will experience slowed movements, blurry vision, or sudden unconsciousness.")
	message_to_player("A patients pain levels with vary according to the severity and types of injury.")
	message_to_player("If a Marine is in especially severe pain, they will enter a <b>Paincrit</b>. Where they are held unconscious in critical condition until their pain levels are reduced.")

	addtimer(CALLBACK(src, PROC_REF(pain_tutorial_2)), 25 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/pain_tutorial_2()
	SIGNAL_HANDLER

	marine_dummy.adjustFireLoss(130)
	message_to_player("The Dummy has taken considerable damage, and is in a lot of pain")
	message_to_player("The flashing red healthbar above their head indicates the Dummy is in <b>Critical Condition</b>.")
	message_to_player("To reduce their pain levels, the chemical painkiller <b>Tramadol</b> is primarily used.")

	addtimer(CALLBACK(src, PROC_REF(pain_tutorial_3_pre)), 7 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/pain_tutorial_3_pre()
	SIGNAL_HANDLER

	handle_pill_bottle(marine_dummy, "Tramadol", "Tr", "5", /obj/item/reagent_container/pill/tramadol)

	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(pain_tutorial_3_pre), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(tram_pill_fed))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tram_pill_fed(/obj/item/reagent_container/hypospray/autoinjector/oxycodone)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)

	message_to_player("Well done! But it looks like the Dummy is still in extreme pain.")
	message_to_player("Like pain levels, each type of painkiller has a varying degree of potency. While effective as a general painkiller, Tramadol is not powerful enough to fully supress extreme levels of pain.")
	message_to_player("<b>Oxycodone</b> is the most powerful painkiller used by field Medics, and is capable of nullifying almost all pain in the body for a short period of time.")
	message_to_player("Apply the <b>Oxycodone Autoinjector</b> to the Dummy.")

	var/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use/oxy = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(oxy)
	add_highlight(oxy, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(oxy_inject_self))
	RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(oxy_inject))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use, oxy)
	remove_highlight(oxy)
	remove_from_tracking_atoms(oxy)
	QDEL_IN(oxy, 2 SECONDS)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	addtimer(CALLBACK(src, PROC_REF(tram_pill_fed)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_inject()
	//adds a slight grace period, so humans are not rejuved before oxy is registered in their system

	message_to_player("Well done!")
	message_to_player("<b>Section 2.2: Toxin Damage</b>")
	addtimer(CALLBACK(src, PROC_REF(tox_tutorial)), 2 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tox_tutorial()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use, oxy)
	remove_highlight(oxy)
	remove_from_tracking_atoms(oxy)
	qdel(oxy)


	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()
	marine_dummy.adjustToxLoss(15)

	message_to_player("While far less common than Brute or Burn damage, knowing how to treat <b>Toxin Damage</b> is still a must for any would-be Hospital Corpsman in training.")
	message_to_player("Although <b>Toxin Damage</b> is almost never directly fatal, it can easily wreak havoc in the body to a magnitude not seen from other forms of damage.")
	message_to_player("Symptoms of <b>Toxin Damage</b> include, vomiting, nausea, organ damage, and extreme pain across the body. It is commonly caused by overdoses, organ failure, or ingesting poisons.")
	message_to_player("The Dummy has taken some <b>Toxin Damage</b>. Scan them with your Health Analyzer.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(tox_tutorial_2_pre))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tox_tutorial_2_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	addtimer(CALLBACK(src, PROC_REF(tox_tutorial_2_return)), 1 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tox_tutorial_2_return()
	SIGNAL_HANDLER

	message_to_player("As you can see, the Dummy has sustained minor <b>Toxin Damage</b>. Like burn damage, toxin damage is almost always spread across the body.")
	message_to_player("The chemical <b>Dylovene</b> is used to treat Toxin Damage.")

	handle_pill_bottle(marine_dummy, "Dylovene", "Dy", "7", /obj/item/reagent_container/pill/antitox)

	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(tox_tutorial_2_return), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(dylo_pill_fed))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/dylo_pill_fed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)

	message_to_player("Well done, the Dummy's Toxin Damage levels will decrease over time")

	addtimer(CALLBACK(src, PROC_REF(tox_tutorial_3)), 8 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tox_tutorial_3()
	//adds a slight grace period, so humans are not rejuved before dylo is registered in their system

	slower_message_to_player("<b>Section 2.3: Oxygen Damage</b>")
	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial()

	marine_dummy.rejuvenate()
	marine_dummy.reagents.clear_reagents()

	message_to_player("<b>Oxygen Damage</b> is the fourth, and final form of field damage that a Marine Hospital Corpsman is expected to be able to treat.")
	message_to_player("The mechanics of Oxygen damage are heavily linked to <b>Internal Organ Damage</b>, something that will be covered in detail in the advanced version of this tutorial.")

	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_1)), 6 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_1()

	message_to_player("Oxygen Damage represents a lack of blood-flow to the Brain, and the bodys shutdown because of it.")
	message_to_player("Oxygen Damage can be caused as a result of <b>Blood Loss, Internal Organ Damage</b>, and <b>Dying</b>.")
	message_to_player("Symptoms of Oxygen Damage include <b>Gasping</b> and/or <b>Coughing up Blood</b>, as well as <b>Unconsciousness</b> beyond 50 points of damage.")
	message_to_player("Like Toxin damage, <b>Oxygen Damage</b> is spread across the body, and not focused on one specific limb or region.")

	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_2)), 15 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_2()
	SIGNAL_HANDLER

	marine_dummy.rejuvenate()
	marine_dummy.adjustOxyLoss(40)

	message_to_player("Pvt Dummy is suffering from <b>Oxygen Damage</b>!")
	message_to_player("Oxygen damage is treated by the chemical <b>Dexalin</b>, color-coded blue.")

	handle_pill_bottle(marine_dummy, "Dexalin", "Dx", "1", /obj/item/reagent_container/pill/dexalin)

	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(oxy_tutorial_2), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(dex_pill_fed))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/dex_pill_fed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)

	message_to_player("Excellent work!")

	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_4)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_4()

	marine_dummy.rejuvenate()
	marine_dummy.adjustOxyLoss(100)

	message_to_player("Oh no! It appears that, despite our prior treatment, Pvt Dummy is still suffering from <b>Extreme Oxygen Damage</b>!")
	message_to_player("Scan him with your <b>Health Analyzer</b> to determine his exact damage amount.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(oxy_tutorial_5))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_5(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("As we can see based on our <b>Health Analyzer</b> scan, Pvt Dummy has around <b>100</b> points of <b>Oxygen Damage</b>!")
	message_to_player("In extreme cases, when Oxygen damage levels are especially high, we can use a chemical called <b>Dexalin+</b> to heal <u>all Oxygen damage instantly</u>.")

	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_6)), 6 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_6()
	SIGNAL_HANDLER

	message_to_player("A <b>Dexalin+ Autoinjector</b> has been placed into your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Use the Autoinjector on Pvt Dummy by clicking on them, to administer the <b>Dexalin+</b>")

	var/obj/item/reagent_container/hypospray/autoinjector/dexalinp/one_use/dexp = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(dexp)
	add_highlight(dexp, COLOR_GREEN)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	medbelt.handle_item_insertion(dexp)
	medbelt.update_icon()

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(dexp_inject_self))

	RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(dexp_inject))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/dexp_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/dexalinp/one_use, dexp)
	remove_highlight(dexp)
	remove_from_tracking_atoms(dexp)
	QDEL_IN(dexp, 2 SECONDS)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_5)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/dexp_inject()
	//adds a slight grace period, so humans are not rejuved before dexp is registered in their system

	message_to_player("Well done!")
	addtimer(CALLBACK(src, PROC_REF(oxy_tutorial_7)), 4 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/oxy_tutorial_7()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/dexalinp/one_use, dexp)
	remove_highlight(dexp)
	remove_from_tracking_atoms(dexp)
	qdel(dexp)

	marine_dummy.rejuvenate()

	addtimer(CALLBACK(src, PROC_REF(od_tutorial)), 1 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial()
	SIGNAL_HANDLER

	message_to_player("<b>Section 2.4: Overdose Treatment</b>")
	message_to_player("Every chemical available to a Marine Hospital Corpsman will have a known <b>Overdose Amount</b>.")
	message_to_player("If a person is has more than the <b>Overdose Amount</b> of any chemical in their body, the chemical will begin damaging the body to varying levels of severity")
	message_to_player("Generally, the more powerful a chemical is at healing the body, the more destructive it will become if <b>Overdosed</b>.")

	addtimer(CALLBACK(src, PROC_REF(od_tutorial_1)), 15 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_1()

	message_to_player("All standard-issue Medical pills and autoinjectors will contain exactly <u>half the overdose amount</u> for their given chemical (with some exceptions).")
	message_to_player("This means administering a Marine with two uses of the same pill or autoinjector in a short span of time will place them <u>just below the overdose amount</u>.")
	message_to_player("The overdose amounts for Bicaridine, Kelotane, Tramadol and Dylovene, is <b>30 units</b>. Pills and Autoinjectors for each will contain 15 units per use.")

	addtimer(CALLBACK(src, PROC_REF(od_tutorial_2)), 16 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_2()
	SIGNAL_HANDLER

	marine_dummy.adjustBruteLoss(55)
	marine_dummy.adjustFireLoss(40)
	marine_dummy.reagents.add_reagent("bicaridine", 40)

	message_to_player("The Dummy has taken some Brute damage, indicated by the fact that they are <I>once again</I> bleeding all over the floor.")
	message_to_player("However, in a combat environment, you can never be sure how recently someone may have been treated by another Medic, and what chemicals will remain in their bloodstream")
	message_to_player("Before administering any form of chemical medication, you must <b>ALWAYS</b> scan the patient with your Health Analyzer to check the amounts of chemicals in their body, and ensure you will not accidentally overdose them.")

	message_to_player("Scan the Dummy with your Health Analyzer.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(od_tutorial_3))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_3()
	SIGNAL_HANDLER

	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("It seems that Pvt Dummy has been careless with their self-medicating, and is <b>Overdosed on Bicaridine</b> by just under 10 units.")
	message_to_player("On the field, an overdose can not be treated by a Hospital Corpsman using standard equipment. Instead, you will have to wait for the body to <b>metabolize</b> the chemical over time, until it is below its overdose amount.")
	message_to_player("A small overdose, while annoying, will very rarely prove lethal in the body.")

	addtimer(CALLBACK(src, PROC_REF(od_tutorial_4)), 16 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_4()
	SIGNAL_HANDLER

	message_to_player("The effects of every overdose will have different methods of treatment depending on the chemical.")
	message_to_player("To stabilize a patient after an overdose, you should follow the automatic medicine recommendations displayed on the bottom of your <b>Health Analyzer</b> interface (you may need to scroll down to see them).")
	message_to_player("As you can see on your Health Analyzer scan, the Bicaridine overdose is creating Burn Damage on the Dummy.")
	message_to_player("Kelotane, which is used to primarily treat <b>Burn</b> damage, can also be used to counteract the effects of this overdose.")
	message_to_player("We will follow the Health Analyzers recommendations on the bottom of the interface, and feed the Dummy a <b>Kelotane Pill</b>.")

	addtimer(CALLBACK(src, PROC_REF(od_tutorial_5)), 20 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_5()
	SIGNAL_HANDLER

	handle_pill_bottle(marine_dummy, "Kelotane", "Kl", "2", /obj/item/reagent_container/pill/kelotane)

	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL, PROC_REF(od_tutorial_5), TRUE)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(od_tutorial_6))

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/od_tutorial_6()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)

	message_to_player("Well done, the Dummy's condition is now stable, and their overdose will disappear over time.")

	addtimer(CALLBACK(src, PROC_REF(tutorial_close)), 4 SECONDS)

// Helpers

/**
* Handles the creation and describes the use of pill bottles and pills in HM tutorials
*
* Currently limited to /mob/living/carbon/human/realistic_dummy
*
* Will break if used more than once per proc, see add_to_tracking_atoms() limitations
*
* Arguments:
* * target Set to realistic_dummy of choosing
* * name Uppercased name of the selected chemical, in string form
* * maptext Sets the maptext_label variable for the created pill bottle, also a string
* * iconnumber Sets the icon for the created pill bottle, input a number string ONLY (IE: "1")
* * pill Typepath of the pill to place into the pill bottle
*/

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/handle_pill_bottle(target, name, maptext, iconnumber, pill)
	SIGNAL_HANDLER

	if(handle_pill_bottle_status == 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		var/obj/item/storage/pill_bottle/bottle = new /obj/item/storage/pill_bottle
		medbelt.handle_item_insertion(bottle)
		medbelt.update_icon()

		bottle.name = "\improper [name] pill bottle"
		bottle.icon_state = "pill_canister[iconnumber]"
		bottle.maptext_label = "[maptext]"
		bottle.maptext = SPAN_LANGCHAT("[maptext]")
		bottle.max_storage_space = 1
		bottle.overlays.Cut()
		bottle.bottle_lid = FALSE
		bottle.overlays += "pills_closed"

		var/obj/item/reagent_container/pill/tpill = new pill(bottle) // tpill = tracking pill
		add_to_tracking_atoms(bottle)


		message_to_player("A <b>[name] Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
		message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>[name] Pill Bottle</b> to draw a pill.")

		add_highlight(medbelt, COLOR_GREEN)
		add_highlight(bottle, COLOR_GREEN)

		handle_pill_bottle_status++
		RegisterSignal(tpill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(handle_pill_bottle))
		return

	if(handle_pill_bottle_status == 1)
		message_to_player("Good. Now stand next to the Dummy, and click their body while holding the pill to feed it to them.")

		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)


		UnregisterSignal(target, COMSIG_ITEM_DRAWN_FROM_STORAGE)

		add_highlight(target, COLOR_GREEN)
		remove_highlight(medbelt)
		remove_highlight(bottle)

		handle_pill_bottle_status++
		RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))
		RegisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))

		return

	if(handle_pill_bottle_status == 2)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)

		if(target == tutorial_mob)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)
			var/mob/living/living_mob = tutorial_mob
			living_mob.rejuvenate()
			remove_highlight(bottle)
			QDEL_IN(bottle, 1 SECONDS)
			medbelt.update_icon()
			message_to_player("Don't feed yourself the pill, try again.")
			handle_pill_bottle_status = 0
			UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
			spawn(2.1 SECONDS)
			SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)
			return

		else if(target == marine_dummy)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)

			remove_highlight(bottle)
			QDEL_IN(bottle, 1 SECONDS)
			handle_pill_bottle_status = 0
			SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)

// Helpers End

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/proc/tutorial_close()
	SIGNAL_HANDLER

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Intermediate</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")

	playsound(tutorial_mob.loc, 'sound/theme/winning_triumph2.ogg', 75)

	tutorial_end_in(15 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)
	remove_action(tutorial_mob, /datum/action/surgery_toggle)


/datum/tutorial/marine/role_specific/hospital_corpsman_basic/init_map()
	var/obj/structure/machinery/cm_vending/clothing/tutorial/medic/medical_vendor = new(loc_from_corner(4, 4))
	add_to_tracking_atoms(medical_vendor)
