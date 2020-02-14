/* SURGERY STEPS */

/datum/surgery_step
	var/priority = 0 //Steps with higher priority will be attempted first. Accepts decimals

	//Provisional priority list
	//0 : Generic (Incision, Bones, Internal Bleeding, Limb Removal, Cautery)
	//X + 0.1 : Upgrades
	//1 : Generic Priority (Encased Surgery, Cavities, Implants, Reattach)
	//2 : Sub-Surgeries (Mouth and Eyes)
	//3 : Special surgeries (Embryos, Bone Chips, Hematoma)

	var/list/allowed_tools = null //Array of type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_species = null //List of names referencing mutantraces that this step applies to.
	var/list/disallowed_species = null



	var/min_duration = 0 //Minimum duration of the step
	var/max_duration = 0 //Maximum duration of the step

	var/can_infect = 0 //Evil infection stuff that will make everyone hate me
	var/blood_level = 0 //How much blood this step can get on surgeon. 1 - hands, 2 - full body

	//Returns how well tool is suited for this step
	proc/tool_quality(obj/item/tool)
		for(var/T in allowed_tools)
			if(istype(tool, T))
				return allowed_tools[T]
		return FALSE

//Checks if this step applies to the user mob at all
/datum/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!hasorgans(target))
		return FALSE
	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.name == species)
				return TRUE

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.name == species)
				return FALSE
	return TRUE


//Checks whether this step can be applied with the given user and target
/datum/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	return FALSE

//Does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	if(ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if(blood_level)
			H.bloody_hands(target, 0)
		if(blood_level > 1)
			H.bloody_body(target, 0)
	return

//Does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	return

//Stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	return null

proc/do_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool)
	if(!istype(M))
		return FALSE
	if(user.a_intent == HARM_INTENT) //Check for Hippocratic Oath
		return FALSE
	if(user.action_busy) //already doing an action
		return TRUE
	if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_BEGINNER))
		to_chat(user, SPAN_WARNING("You have no idea how to do surgery..."))
		return TRUE
	var/datum/limb/affected = M.get_limb(user.zone_selected)
	if(!affected)
		return FALSE
	if(affected.in_surgery_op) //two surgeons can't work on same limb at same time
		to_chat(user, SPAN_WARNING("You can't operate on the patient's [affected.display_name] while it's already being operated on."))
		return TRUE

	for(var/datum/surgery_step/S in surgery_steps)
		//Check if tool is right or close enough, and the target mob valid, and if this step is possible
		if(S.tool_quality(tool) && S.is_valid_target(M))
			var/step_is_valid = S.can_use(user, M, user.zone_selected, tool, affected)
			if(step_is_valid)
				if(step_is_valid == SPECIAL_SURGERY_INVALID) //This is a failure that already has a message for failing.
					return TRUE
				affected.in_surgery_op = TRUE
				S.begin_step(user, M, user.zone_selected, tool, affected) //Start on it
				//We had proper tools! (or RNG smiled.) and user did not move or change hands.

				//Success multiplers!
				var/multipler = 1 //1 = 100%
				if(!isSynth(M) && !isYautja(M))
					if(locate(/obj/structure/bed/roller, M.loc))
						multipler -= SURGERY_MULTIPLIER_SMALL
					else if(locate(/obj/structure/table/, M.loc))
						multipler -= SURGERY_MULTIPLIER_MEDIUM
					if(M.stat == CONSCIOUS)//If not on anesthetics or not unconsious
						multipler -= SURGERY_MULTIPLIER_LARGE
						switch(M.reagent_pain_modifier)
							if(PAIN_REDUCTION_MEDIUM to PAIN_REDUCTION_HEAVY)
								multipler += SURGERY_MULTIPLIER_SMALL
							if(PAIN_REDUCTION_HEAVY to PAIN_REDUCTION_VERY_HEAVY)
								multipler += SURGERY_MULTIPLIER_MEDIUM
							if(PAIN_REDUCTION_VERY_HEAVY to PAIN_REDUCTION_FULL)
								multipler += SURGERY_MULTIPLIER_LARGE
						if(M.shock_stage > 100) //Being near to unconsious is good in this case
							multipler += SURGERY_MULTIPLIER_MEDIUM
					if(istype(M.loc, /turf/open/shuttle/dropship))
						multipler -= SURGERY_MULTIPLIER_HUGE
					multipler = Clamp(multipler, 0, 1)

				//calculate step duration
				var/step_duration = rand(S.min_duration, S.max_duration)
				if(user.mind && user.skills)
					//1 second reduction per level above minimum for performing surgery
					step_duration = max(5, step_duration - 5*user.skills.get_skill_level(SKILL_SURGERY))

				//Multiply tool success rate with multipler
				if(prob(S.tool_quality(tool) * multipler) &&  do_after(user, step_duration, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					if(S.can_use(user, M, user.zone_selected, tool, affected, TRUE)) //to check nothing changed during the do_after
						S.end_step(user, M, user.zone_selected, tool, affected) //Finish successfully

				else if((tool in user.contents) && user.Adjacent(M)) //Or
					if(M.stat == CONSCIOUS && !M.paralyzed) //If not on anesthetics, muscle relaxants, or not unconscious, warn player
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							if(!(H.species.flags & NO_PAIN))
								M.emote("pain")
						to_chat(user, SPAN_DANGER("[M] moved during the surgery! Use anesthetics!"))
					S.fail_step(user, M, user.zone_selected, tool, affected) //Malpractice
				else //This failing silently was a pain.
					to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
				affected.in_surgery_op = FALSE
				return 1				   //Don't want to do weapony things after surgery

	if(user.a_intent == HELP_INTENT)
		to_chat(user, SPAN_WARNING("You can't see any useful way to use \the [tool] on [M]."))
		return TRUE
	return FALSE

//Comb Sort. This works apparently, so we're keeping it that way
proc/sort_surgeries()
	var/gap = surgery_steps.len
	var/swapped = 1
	while(gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= surgery_steps.len; i++)
			var/datum/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/datum/surgery_step/r = surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				surgery_steps.Swap(i, gap + i)
				swapped = 1



/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/in_progress = 0
	var/is_same_target = "" //Safety check to prevent surgery juggling
