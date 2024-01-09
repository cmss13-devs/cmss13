/datum/tutorial/marine/medical_basic
	name = "Marine - Medical (Basic)"
	desc = "Learn how to treat common injuries you may face as a marine."
	tutorial_id = "marine_medical_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/marine/medical_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This is the tutorial for the basics of medical that you will need to know for playing a marine role.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial()
	message_to_player("The first kind of damage is <b>Brute</b>, the most common kind. It represents physical trauma from things like punches, weapons, or guns.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustBruteLoss(10)
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial_2()
	message_to_player("You can observe if you have <b>Brute</b> or <b>Burn</b> damage by clicking on yourself with an empty hand on help intent.")
	update_objective("Click on yourself with an empty hand.")
	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_health_examine))

/datum/tutorial/marine/medical_basic/proc/on_health_examine(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob != tutorial_mob)
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	message_to_player("Good. Now, you have taken some brute damage. <b>Bicaridine</b> is used to fix brute over time. Pick up the <b>bicaridine EZ autoinjector</b> and use it in-hand.")
	update_objective("Inject yourself with the bicaridine injector.")
	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use/brute_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brute_injector)
	add_highlight(brute_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_brute_inject))

/datum/tutorial/marine/medical_basic/proc/on_brute_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	message_to_player("All medicines take time to work after injection. Next is <b>Burn</b> damage. It is obtained from things like acid or being set on fire.")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustFireLoss(10)
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/burn_tutorial()
	message_to_player("<b>Kelotane</b> is used to fix burn over time. Inject yourself with the <b>kelotane EZ autoinjector</b>.")
	update_objective("Inject yourself with the kelotane injector.")
	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use/burn_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burn_injector)
	add_highlight(burn_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_burn_inject))


/datum/tutorial/marine/medical_basic/proc/on_burn_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	message_to_player("Good. Now, when you normally take damage, you will also feel <b>pain</b>. Pain slows you down and can knock you out if left unchecked.")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(PAIN_CHESTBURST_STRONG)
	addtimer(CALLBACK(src, PROC_REF(pain_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/pain_tutorial()
	message_to_player("<b>Tramadol</b> is used to reduce your pain. Inject yourself with the <b>tramadol EZ autoinjector</b>.")
	update_objective("Inject yourself with the tramadol injector.")
	var/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use/pain_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pain_injector)
	add_highlight(pain_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_pain_inject))

/datum/tutorial/marine/medical_basic/proc/on_pain_inject(datum/source, obj/item/reagent_container/hypospray/injector)
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

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial()
	message_to_player("You can sometimes start <b>bleeding</b> from things like bullets or slashes. Losing blood will accumulate <b>oxygen</b> damage, eventually causing death.")
	update_objective("")
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	mob_chest.add_bleeding(damage_amount = 15)
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial_2()
	message_to_player("Bleeding wounds can clot themselves over time, or you can fix it quickly with <b>gauze</b>. Pick up the gauze and click on yourself while targeting your <b>chest</b>.")
	update_objective("Gauze your chest, or let it clot on its own.")
	var/obj/item/stack/medical/bruise_pack/two/bandage = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(bandage)
	add_highlight(bandage)
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	RegisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING, PROC_REF(on_chest_bleed_stop))

/datum/tutorial/marine/medical_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
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

/datum/tutorial/marine/medical_basic/proc/on_shrapnel_removed()
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

/datum/tutorial/marine/medical_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)


/datum/tutorial/marine/medical_basic/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
