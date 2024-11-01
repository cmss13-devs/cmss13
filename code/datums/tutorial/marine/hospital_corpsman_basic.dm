/datum/tutorial/marine/hospital_corpsman_basic
	name = "Marine - Hospital Corpsman (Basic)"
	desc = "Learn how to treat common injuries you may face as a marine."
	tutorial_id = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/marine/hospital_corpsman_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the fundamental skills for playing a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(scanner)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/scanner()
	SIGNAL_HANDLER

	message_to_player("First things first, you should get to know your new best friend, the <b>Health Analyzer</b>.")
	var/obj/item/device/healthanalyzer/healthanalyzer = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	message_to_player("Pick up the <b>Health Analyzer</b> by clicking on it with an empty hand.")
	update_objective("Pick up the Health Analyzer.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(scanner_2))

/datum/tutorial/marine/hospital_corpsman_basic/proc/scanner_2()
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)
	message_to_player("The first step to any medical treatment, is identifying the source and type of injury.")
	message_to_player("You can use your <b>Health Analyzer</b> on wounded Marines to see the locations, severity, and types of damage they have sustained.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial()
	message_to_player("<b>Section 1: Basic Damage Treatment</b>")
	message_to_player("There are four main types of damage a Marine can sustain through injuries, each with a different method of treatment.")
	message_to_player("The first kind of damage is <b>Brute</b>, the most common kind. It represents physical trauma from things like punches, weapons, or guns.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_2)), 12 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_2(datum/source, obj/item/device/healthanalyzer)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(2,2))
	add_to_tracking_atoms(human_dummy)
	human_dummy.apply_damage(5, BRUTE, "chest")
	message_to_player("The Dummy has taken some kind of brute damage. Stand next to them, and click on their body with your <b>Health Analyzer</b> in hand to scan them.")
	add_highlight(human_dummy, COLOR_GREEN)
	update_objective("Click on the Dummy with your Health Analyzer")
	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(scanner_3))

/datum/tutorial/marine/hospital_corpsman_basic/proc/scanner_3(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("Good. By looking at the Health Analyzer interface, we can see they have 5 brute damage on their chest.")
	message_to_player("A chemical called <b>Bicaridine</b> is used to heal brute damage over time.")
	message_to_player("<b>Bicaridine</b> is primarily given in pill form.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_3)), 11 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_3()
	SIGNAL_HANDLER

	message_to_player("Click on the <b>Bicaridine pill</b> with an empty hand to pick it up. Then click on the Dummy while holding it and standing next to them to medicate them.")
	message_to_player("Feeding someone a pill takes concentration, and comes with a slight delay. Neither of you should move while the blue circle is over your head, or the process will be disrupted, and you will have to try again.")
	update_objective("Feed the Dummy the Bicaridine pill.")
	var/obj/item/reagent_container/pill/bicaridine/pill = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pill)
	add_highlight(pill, COLOR_GREEN)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PILL_FED, PROC_REF(brute_pill_fed_reject))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_MOB_PILL_FED, PROC_REF(brute_pill_fed))

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_pill_fed_reject()
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_3)), 2 SECONDS)


/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_pill_fed(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_PILL_FED)

	message_to_player("When administered in pill form, chemicals take a few seconds to be digested before they can enter the patients bloodstream, and heal damage.")
	message_to_player("Medications administered when a patient is dead will not heal damage until the patient has been revived.")

	update_objective("")

	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_4)), 9 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_4()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	human_dummy.apply_damage(5, BRUTE, "chest")

	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use/brute_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brute_injector)
	add_highlight(brute_injector)

	message_to_player("Medicines can also be directly injected into the bloodstream using <b>Autoinjectors</b>, allowing the medication to begin work immediately, without the need to be digested first.")
	message_to_player("Click on the <b>Bicaridine Autoinjector</b> with an empty hand to pick it up, and then click on the Dummy while standing next to it to administer an injection")
	update_objective("Pick up, and inject the Dummy with the Bicaridine Autoinjector")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(brute_inject_self))
	RegisterSignal(human_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(brute_tutorial_5_pre))

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_inject_self()
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	qdel(brute_injector)
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_4)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_5_pre()
	//adds a slight grace period, so humans are not rejuved before bica is registered in their system

	message_to_player("Well done!")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_5)), 3 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_5()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	human_dummy.rejuvenate()
	human_dummy.reagents.clear_reagents()
	human_dummy.apply_damage(10, BRUTE, "chest", 0, 0)
	human_dummy.apply_damage(10, BRUTE, "l_arm", 0, 0)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	qdel(brute_injector)
	update_objective("")
	message_to_player("The Dummy has taken some moderate brute damage on two different limbs. Stand next to them, and click on their body with your <b>Health Analyzer</b> in hand to scan them.")
	add_highlight(human_dummy, COLOR_GREEN)
	update_objective("Click on the Dummy with your Health Analyzer")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)
	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(brute_tutorial_6))

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("As you can see, the Dummy has taken 10 brute damage to its chest and left arm.")
	message_to_player("More severe injuries can be treated through the use of <b>Advanced Trauma Kits</b>.")
	message_to_player("These items are used to treat moderate to high levels of brute damage, but must be manually applied to each damaged limb.")
	message_to_player("They only heal 12 damage per application, and should be used alongside medicines like <b>Bicaridine</b> when treating a patient.")

	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_7)), 14 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_7()
	SIGNAL_HANDLER

	var/obj/item/stack/medical/advanced/bruise_pack/brutekit = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brutekit)
	add_highlight(brutekit, COLOR_GREEN)
	message_to_player("We will first focus on healing the wound on the Dummy's chest.")
	message_to_player("Click on the <b>Advanced Trauma Kit</b> with an empty hand to pick it up, then click on the Dummy while standing next to them to apply the trauma kit.")
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_dummy.limbs
	add_to_tracking_atoms(mob_chest)
	RegisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES, PROC_REF(brute_tutorial_8))

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_8()
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

/datum/tutorial/marine/hospital_corpsman_basic/proc/brute_tutorial_9(datum/source, zone_selected)
	SIGNAL_HANDLER

	if(zone_selected != "l_arm")
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ZONE_SEL_CHANGE)

	message_to_player("Excellent. As you can see, the left arm of the little man in the <b>zone selection</b> element is now highlighted. This means we will target the left arm of patients when treating them.")
	message_to_player("Now, just like before, keep the left arm selected, and click on the Dummy while holding the <b>Advanced Trauma Kit</b> in your hand to apply it to their left arm")
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	var/obj/limb/chest/mob_larm = locate(/obj/limb/arm/l_arm) in human_dummy.limbs
	add_to_tracking_atoms(mob_larm)
	RegisterSignal(mob_larm, COMSIG_LIMB_ADD_SUTURES, PROC_REF(burn_tutorial))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_larm)
	UnregisterSignal(mob_larm, COMSIG_LIMB_ADD_SUTURES)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/advanced/bruise_pack, brutekit)
	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	remove_highlight(brutekit)
	qdel(brutekit)
	remove_from_tracking_atoms(brutekit)
	remove_highlight(human_hud.zone_sel)
	update_objective("")

	human_dummy.adjustFireLoss(40)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)

	message_to_player("Great work! That covers the three basic methods to treat <b>Brute</b> damage on the field.")
	message_to_player("The next most common type of injury is <b>Burn</b> damage. It is obtained from things like acid or being set on fire.")
	message_to_player("The Dummy has taken a large amount of <b>Burn</b> damage. Use your <b>Health Analyzer</b> to scan their condition.")

	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(burn_tutorial_2))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_2()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("Unlike brute damage, <b>burn</b> damage is very rarely concentrated on one part of the body, more commonly spread across multiple limbs.")
	message_to_player("Because of this, medication is the most effective treatment for burn wounds, as they heal the whole body at once.")
	message_to_player("<b>Kelotane</b> is used to fix burn over time. Feed the Dummy the <b>Kelotane pill</b>.")
	update_objective("Feed the Dummy the Kelotane pill.")
	var/obj/item/reagent_container/pill/kelotane/kelopill = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(kelopill)
	add_highlight(kelopill, COLOR_GREEN)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PILL_FED, PROC_REF(burn_pill_fed_reject))
	RegisterSignal(human_dummy, COMSIG_MOB_PILL_FED, PROC_REF(burn_tutorial_3))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_pill_fed_reject()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_2)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_3()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PILL_FED)
	UnregisterSignal(human_dummy, COMSIG_MOB_PILL_FED)

	message_to_player("Well done!")
	message_to_player("While rare, when a large amount of <b>Burn</b> damage is concentrated on a single part of the body, we can apply an <b>Advanced Burn Kit</b> to quickly heal a portion of damage.")
	update_objective("")

	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_4)), 11 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_4()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/datum/hud/human, human_hud)
	human_dummy.rejuvenate()
	human_dummy.reagents.clear_reagents()
	human_dummy.apply_damage(40, BURN, "chest", 0, 0)
	var/obj/item/stack/medical/advanced/ointment/burnkit = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burnkit)
	add_highlight(human_hud.zone_sel)
	add_highlight(burnkit, COLOR_GREEN)

	message_to_player("The Dummy has taken concentrated burn damage on their <b>chest</b>. We will use an <b>Advanced Burn Kit</b> on the area.")
	message_to_player("First make sure you are targeting the chest in the <b>zone selection</b> element, highlighted on the bottom right of your hud. Then click on the Dummy with your <b>Advanced Burn Kit</b> in hand, while standing next to them, to treat their burn wound.")

	RegisterSignal(mob_chest, COMSIG_LIMB_ADD_SUTURES, PROC_REF(burn_tutorial_5))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_5()
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

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(burn_tutorial_6))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use/burn_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burn_injector)
	add_highlight(burn_injector)

	message_to_player("As you can see, the Dummy still has some burn damage left on their chest")
	message_to_player("To heal this remaining damage, we will use a <b>Kelotane Autoinjector</b>.")
	message_to_player("Click on the autoinjector with an empty hand to pick it up, then click on the Dummy while holding it in hand to inject them with <b>Kelotane</b>.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(burn_inject_self))
	RegisterSignal(human_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(burn_tutorial_7_pre))

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	qdel(burn_injector)
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial_6)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/burn_tutorial_7_pre()
	//adds a slight grace period, so humans are not rejuved before kelo is registered in their system

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	human_dummy.rejuvenate()
	human_dummy.reagents.clear_reagents()

	message_to_player("Well done! This completes the basic damage treatments for brute and burn wounds.")
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial)), 3 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/bleed_tutorial()
	message_to_player("As you may have noticed earlier, severe brute damage injuries occasionally cause <b>bleeding</b> on the affected limb.")
	message_to_player("The Human body carries a finite amount of blood, and losing blood will accumulate internal damage, eventually causing death if not treated.")
	update_objective("")
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	mob_chest.add_bleeding(damage_amount = 15)
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_2)), 4 SECONDS)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)

	message_to_player("The Dummy appears to be bleeding. Scan them with your <b>Health Analyzer</b> to identify which limb they are bleeding from.")
	RegisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(bleed_tutorial_2))

/datum/tutorial/marine/hospital_corpsman_basic/proc/bleed_tutorial_2()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

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

/datum/tutorial/marine/hospital_corpsman_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
	SIGNAL_HANDLER

	// If you exit on this step, your limbs get deleted, which stops the bleeding, which progresses the tutorial despite it ending
	if(!tutorial_mob || QDELETED(src))
		return

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	UnregisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/advanced/bruise_pack, brutekit)
	remove_from_tracking_atoms(brutekit)
	remove_highlight(brutekit)
	qdel(brutekit)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()
	human_dummy.reagents.clear_reagents()

	message_to_player("Great work. The Dummy is no longer bleeding all over the floor, which is always good.")






/datum/tutorial/marine/hospital_corpsman_basic/proc/on_burn_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	qdel(burn_injector)
	message_to_player("Good. Now, when you normally take damage, you will also feel <b>pain</b>. Pain slows you down and can knock you out if left unchecked.")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(PAIN_CHESTBURST_STRONG)
	addtimer(CALLBACK(src, PROC_REF(pain_tutorial)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/pain_tutorial()
	message_to_player("<b>Tramadol</b> is used to reduce your pain. Inject yourself with the <b>tramadol EZ autoinjector</b>.")
	update_objective("Inject yourself with the tramadol injector.")
	var/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use/pain_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pain_injector)
	add_highlight(pain_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_pain_inject))

/datum/tutorial/marine/hospital_corpsman_basic/proc/on_pain_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use, pain_injector)
	remove_highlight(pain_injector)
	message_to_player("Good. Keep in mind that you can overdose on chemicals, so don't inject yourself with the same chemical too much too often. In the field, injectors have 3 uses.")
	update_objective("Don't overdose! Generally, 3 injections of a chemical will overdose you.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(-PAIN_CHESTBURST_STRONG) // just to make sure
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/bleed_tutorial()
	message_to_player("You can sometimes start <b>bleeding</b> from things like bullets or slashes. Losing blood will accumulate <b>oxygen</b> damage, eventually causing death.")
	update_objective("")
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	mob_chest.add_bleeding(damage_amount = 15)
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_basic/proc/bleed_tutorial_2()
	message_to_player("Bleeding wounds can clot themselves over time, or you can fix it quickly with <b>gauze</b>. Pick up the gauze and click on yourself while targeting your <b>chest</b>.")
	update_objective("Gauze your chest, or let it clot on its own.")
	var/obj/item/stack/medical/bruise_pack/two/bandage = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(bandage)
	add_highlight(bandage)
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	RegisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING, PROC_REF(on_chest_bleed_stop))

/datum/tutorial/marine/hospital_corpsman_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
	SIGNAL_HANDLER

	// If you exit on this step, your limbs get deleted, which stops the bleeding, which progresses the tutorial despite it ending
	if(!tutorial_mob || QDELETED(src))
		return

	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	UnregisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/bruise_pack/two, bandage)
	remove_from_tracking_atoms(bandage)
	remove_highlight(bandage)
	qdel(bandage)

	message_to_player("Good. Sometimes, a bullet or bone shard can result in you getting <b>shrapnel</b>, dealing damage over time. Pick up the <b>knife</b> and use it in-hand to remove the shrapnel.")
	update_objective("Remove your shrapnel by using the knife in-hand.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.feels_pain = FALSE

	var/obj/item/attachable/bayonet/knife = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(knife)
	add_highlight(knife)

	var/obj/item/shard/shrapnel/tutorial/shrapnel = new
	shrapnel.on_embed(tutorial_mob, mob_chest, TRUE)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED, PROC_REF(on_shrapnel_removed))

/datum/tutorial/marine/hospital_corpsman_basic/proc/on_shrapnel_removed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/attachable/bayonet, knife)
	remove_highlight(knife)
	message_to_player("Good. This is the end of the basic marine medical tutorial. The tutorial will end shortly.")
	update_objective("Tutorial completed.")
	tutorial_end_in(5 SECONDS)

// END OF SCRIPTING
// START OF SCRIPT HELPERS

// END OF SCRIPT HELPERS

/datum/tutorial/marine/hospital_corpsman_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)


/datum/tutorial/marine/hospital_corpsman_basic/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
