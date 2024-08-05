
//Procedures in this file: larva removal surgery
//////////////////////////////////////////////////////////////////
// LARVA SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/chestburster_removal
	name = "Experimental Xenomorph Parasite Removal"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_FULL
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/cut_larval_pseudoroots,
		/datum/surgery_step/remove_larva,
	)

/datum/surgery/chestburster_removal/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	if(!locate(/obj/structure/machinery/optable) in get_turf(patient))
		return FALSE

	return locate(/obj/item/alien_embryo) in patient

//------------------------------------

/datum/surgery_step/cut_larval_pseudoroots
	name = "Cut Larval Pseudoroots"
	desc = "sever the xenomorph larva's pseudoroots"
	//Similar to INCISION, but including the PICT also. Using the PICT prevents acid spray.
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/cut_larval_pseudoroots/proc/larva_blood_spray(mob/living/carbon/human/user, mob/living/carbon/human/patient) //Mostly check_blood_splash().
	var/i = 0 //Tally up our victims.
	var/splash_chance
	for(var/mob/living/carbon/human/victim in orange(1, patient)) //Loop through all nearby victims, excepting patient.
		var/distance = get_dist(patient, victim)
		splash_chance = 80 - (i * 5)
		if(victim.loc == patient.loc) splash_chance += 30 //Same tile? BURN
		splash_chance += distance * -15
		if(victim.species && victim.species.name == "Yautja")
			splash_chance -= 70 //Preds know to avoid the splashback.
		if(splash_chance > 0 && prob(splash_chance)) //Success!
			i++
			victim.visible_message(SPAN_DANGER("\The [victim] is scalded with hissing green blood!"), \
			SPAN_DANGER("You are splattered with sizzling blood! IT BURNS!"))
			if(prob(60) && !victim.stat && victim.pain.feels_pain)
				INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream") //Topkek
			victim.take_limb_damage(0, 12) //Sizzledam! This automagically burns a random existing body part.
			victim.add_blood(BLOOD_COLOR_XENO, BLOOD_BODY)
			playsound(victim, "acid_sizzle", 25, TRUE)
			animation_flash_color(victim, "#FF0000") //pain hit flicker

/datum/surgery_step/cut_larval_pseudoroots/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start carefully cutting the larva's pseudoroots away from [target]'s vital organs with \the [tool]."),
		SPAN_NOTICE("[user] starts to carefully cut the tubes connecting the alien larva to your vital organs with \the [tool]."),
		SPAN_NOTICE("[user] starts to carefully cut the tubes connecting the alien larva to [target]'s vital organs with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began cutting the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], attempting to begin [surgery].")

/datum/surgery_step/cut_larval_pseudoroots/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.visible_message(SPAN_NOTICE("[user] severs the last of the pseudoroots with \the [tool], without spilling any of the larva's acid blood."),
			SPAN_NOTICE("You sever the last of the pseudoroots with \the [tool], without spilling any of the larva's acid blood."))
	else
		user.visible_message(SPAN_WARNING("Pressurised acid sprays everywhere as [user] severs the larva's tubes!"),
			SPAN_WARNING("As you sever the larva's pseudoroots, acid sprays through the air, pools in [target]'s [surgery.affected_limb.cavity], and spills sizzling across \his organs!"))

		if(target.stat == CONSCIOUS)
			to_chat(target, SPAN_HIGHDANGER("Your organs are melting!"))
			target.emote("scream")

		larva_blood_spray(user, target)
		target.apply_damage(15, BURN, target_zone)

		/*10-30 dam across 1-3 organs. This may shred one organ, but will most likely scatter a decent amount of damage across several.
		Xeno acid can melt steel beams, and y'all just spilled it in his thoracic cavity.
		You're also right there with the ribs cracked to fix it, so you can use the 3-9 seconds you spend on that to think about using the PICT next time.*/
		for(var/I in 1 to rand(2,6))
			var/datum/internal_organ/O = pick(surgery.affected_limb.internal_organs)
			O.take_damage(5, I == 1)

	log_interact(user, target, "[key_name(user)] cut the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/cut_larval_pseudoroots/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]'s hand slips and a jet of acid spurts as \he slices the larva with \the [tool]!"),
		SPAN_WARNING("Your hand slips and a jet of acid spurts as you slice the larva with \the [tool]!"))

	if(target.stat == CONSCIOUS)
		target.emote("scream")

	larva_blood_spray(user, target)
	target.apply_damage(15, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to cut the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_larva
	name = "Remove Larva"
	desc = "extract the xenomorph larva"
	accept_hand = TRUE
	/*Using the hands to forcefully rip out the larva will be faster at the cost of damaging both the doctor and the patient, with the addition of organ damage.
	Unlike before, the hemostat is now the best tool for removing removing the larva, as opposed to wirecutters and the fork.*/
	tools = list(
		/obj/item/tool/surgery/hemostat = 1.5 * SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = 1.5 * SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = 1.5 * SURGERY_TOOL_MULT_SUBSTITUTE
		)
	time = 6 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	failure_sound = 'sound/effects/acid_sizzle2.ogg'

/datum/surgery_step/remove_larva/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You try to extract the larva from [target]'s chest with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the larva from your chest with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the larva from [target]'s chest with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You try to forcefully rip the larva from [target]'s chest with your bare hand."),
			SPAN_NOTICE("[user] tries to forcefully rip the larva from your chest."),
			SPAN_NOTICE("[user] tries to forcefully rip the larva from [target]'s chest."))

	target.custom_pain("Something hurts horribly in your chest!",1)
	log_interact(user, target, "[key_name(user)] started to remove an embryo from [key_name(target)]'s ribcage.")

/datum/surgery_step/remove_larva/success(mob/living/carbon/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/obj/item/alien_embryo/A = locate() in target
	if(A)
		if(tool)
			user.affected_message(target,
				SPAN_WARNING("You pull a wriggling parasite out of [target]'s ribcage!"),
				SPAN_WARNING("[user] pulls a wriggling parasite out of [target]'s ribcage!"),
				SPAN_WARNING("[user] pulls a wriggling parasite out of [target]'s ribcage!"))
		else
			user.affected_message(target,
				SPAN_WARNING("Your hands and your patient's insides are burned by acid as you forcefully rip a wriggling parasite out of [target]'s ribcage!"),
				SPAN_WARNING("[user]'s hands are burned by acid as \he rips a wriggling parasite out of your ribcage!"),
				SPAN_WARNING("[user]'s hands are burned by acid as \he rips a wriggling parasite out of [target]'s ribcage!"))
			var/datum/internal_organ/impacted_organ = pick(surgery.affected_limb.internal_organs)
			impacted_organ.take_damage(5, FALSE)
			if(target.stat == CONSCIOUS)
				target.emote("scream")
			target.apply_damage(15, BURN, target_zone)

			play_failure_sound(user, target, target_zone, tool, surgery)
			user.emote("pain")

			if(user.hand)
				user.apply_damage(15, BURN, "l_hand")
			else
				user.apply_damage(15, BURN, "r_hand")

		user.count_niche_stat(STATISTICS_NICHE_SURGERY_LARVA)
		var/mob/living/carbon/xenomorph/larva/L = locate() in target //the larva was fully grown, ready to burst.
		if(L)
			L.forceMove(target.loc)
			qdel(A)
		else
			A.forceMove(target.loc)
			target.status_flags &= ~XENO_HOST

		log_interact(user, target, "[key_name(user)] removed an embryo from [key_name(target)]'s ribcage with [tool ? "\the [tool]" : "their hands"], ending [surgery].")

/datum/surgery_step/remove_larva/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s organs and spilling acid in \his [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising your organs and spilling acid in your [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s organs and spilling acid in \his [surgery.affected_limb.cavity]!"))

	var/datum/internal_organ/I = pick(surgery.affected_limb.internal_organs)
	I.take_damage(5,0)
	if(target.stat == CONSCIOUS)
		target.emote("scream")
	target.apply_damage(15, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to remove an embryo from [key_name(target)]'s ribcage with [tool ? "\the [tool]" : "their hands"].")
	return FALSE
