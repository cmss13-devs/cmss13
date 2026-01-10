#define PROCESS_ACCURACY 10

/*
				INTERNAL ORGANS
*/


/datum/internal_organ
	var/name = "organ"
	var/mob/living/carbon/human/owner = null
	var/vital //Lose a vital limb, die immediately.
	var/damage = 0 // amount of damage to the organ
	var/min_little_bruised_damage = 1 //to make sure the stethoscope/penlight will not lie to the player
	var/min_bruised_damage = 10
	var/min_broken_damage = 30
	var/parent_limb = "chest"
	var/robotic = 0 //1 for 'assisted' organs (e.g. pacemaker), 2 for actual cyber organ.
	var/cut_away = FALSE //internal organ has its links to the body severed, organ is ready to be removed.
	var/removed_type //When removed, forms this object.
	var/robotic_type //robotic version of removed_type, used in mechanize().
	var/rejecting // Is this organ already being rejected?
	var/obj/item/organ/organ_holder // If not in a body, held in this item.
	var/list/transplant_data
	///status of organ - is it healthy, broken, bruised?
	var/organ_status = ORGAN_HEALTHY


/datum/internal_organ/process()
	if(!owner && !organ_holder)
		if(QDELETED(src))
			stack_trace("[src] is still processing without an owner nor an organ_holder!")
			return PROCESS_KILL
		qdel(src)
		return PROCESS_KILL

/datum/internal_organ/proc/rejuvenate()
	damage=0
	set_organ_status()

/// Set the correct organ state
/datum/internal_organ/proc/set_organ_status()
	if(damage >= min_broken_damage || cut_away)
		if(organ_status != ORGAN_BROKEN)
			organ_status = ORGAN_BROKEN
			return TRUE
		return FALSE
	if(damage >= min_bruised_damage)
		if(organ_status != ORGAN_BRUISED)
			organ_status = ORGAN_BRUISED
			return TRUE
		return FALSE
	if(damage >= min_little_bruised_damage) // Only for the stethoscopes and penlights, smaller damage check for extra precision
		if(organ_status != ORGAN_LITTLE_BRUISED)
			organ_status = ORGAN_LITTLE_BRUISED
			return TRUE
		return FALSE
	if(organ_status != ORGAN_HEALTHY)
		organ_status = ORGAN_HEALTHY
		return TRUE

/datum/internal_organ/New(mob/living/carbon/M)
	..()
	if(M && istype(M))

		M.internal_organs |= src
		src.owner = M

		var/mob/living/carbon/human/H = M
		if(istype(H))
			var/obj/limb/E = H.get_limb(parent_limb)
			if(E.internal_organs == null)
				E.internal_organs = list()
			E.internal_organs |= src

/datum/internal_organ/proc/take_damage(amount, silent = FALSE)
	if(src.robotic == ORGAN_ROBOT)
		src.damage += (amount * 0.8)
	else
		src.damage += amount

	var/obj/limb/parent = owner.get_limb(parent_limb)
	if(!silent)
		owner.custom_pain("Something inside your [parent.display_name] hurts a lot.", 1)
	set_organ_status()

/datum/internal_organ/proc/heal_damage(amount)
	if(damage < amount)
		damage = 0
	else
		damage -= amount
	set_organ_status()

/datum/internal_organ/proc/emp_act(severity)
	switch(robotic)
		if(0)
			return
		if(1)
			switch (severity)
				if (1.0)
					take_damage(20,0)
					return
				if (2.0)
					take_damage(7,0)
					return
				if(3.0)
					take_damage(3,0)
					return
		if(2)
			switch (severity)
				if (1.0)
					take_damage(40,0)
					return
				if (2.0)
					take_damage(15,0)
					return
				if(3.0)
					take_damage(10,0)
					return

/datum/internal_organ/proc/mechanize() //Being used to make robutt hearts, etc
	if(robotic_type)
		robotic = ORGAN_ROBOT
		removed_type = robotic_type


/datum/internal_organ/proc/mechassist() //Used to add things like pacemakers, etc
	robotic = ORGAN_ASSISTED
	min_bruised_damage = 15
	min_broken_damage = 35

/*
				INTERNAL ORGANS TYPES
*/

/datum/internal_organ/heart // This is not set to vital because death immediately occurs in blood.dm if it is removed.
	name = "heart"
	parent_limb = "chest"
	removed_type = /obj/item/organ/heart
	robotic_type = /obj/item/organ/heart/prosthetic

/datum/internal_organ/heart/prosthetic //used by synthetic species
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/heart/prosthetic

/datum/internal_organ/lungs
	name = "lungs"
	parent_limb = "chest"
	removed_type = /obj/item/organ/lungs
	robotic_type = /obj/item/organ/lungs/prosthetic

/datum/internal_organ/lungs/process()
	. = ..()
	if(. == PROCESS_KILL)
		return // Parent implemention qdeleted us

	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return
	if(organ_status >= ORGAN_BRUISED)
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15

/datum/internal_organ/lungs/rejuvenate()
	owner.losebreath = 0
	..()

/datum/internal_organ/lungs/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/lungs/prosthetic


/datum/internal_organ/liver
	name = "liver"
	parent_limb = "chest"
	removed_type = /obj/item/organ/liver
	robotic_type = /obj/item/organ/liver/prosthetic

/datum/internal_organ/liver/process()
	. = ..()
	if(. == PROCESS_KILL)
		return // Parent implemention qdeleted us

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.take_damage(0.2 * PROCESS_ACCURACY)
			//Damaged one shares the fun
			else
				var/datum/internal_organ/O = pick(owner.internal_organs)
				if(O)
					O.take_damage(0.2 * PROCESS_ACCURACY, TRUE)

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(!(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS))
			if(organ_status >= ORGAN_BRUISED)
				filter_effect--
			if(organ_status >= ORGAN_BROKEN)
				filter_effect -= 2

		// Do some reagent filtering/processing.
		for(var/datum/reagent/ethanol/R in owner.reagents.reagent_list)
			// Damaged liver means some chemicals are very dangerous
			// The liver is also responsible for clearing out alcohol and toxins.
			// Ethanol and all drinks are bad.K
			if(filter_effect < 3)
				owner.apply_damage(0.1 * PROCESS_ACCURACY, TOX)
			owner.reagents.remove_reagent(R.id, R.custom_metabolism*filter_effect)

		//Deal toxin damage if damaged
		if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
			return
		if(organ_status >= ORGAN_BRUISED && prob(25))
			owner.apply_damage(0.1 * (damage/2), TOX)
		else if(organ_status >= ORGAN_BROKEN && prob(50))
			owner.apply_damage(0.3 * (damage/2), TOX)

/datum/internal_organ/liver/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/liver/prosthetic

/datum/internal_organ/kidneys
	name = "kidneys"
	parent_limb = "groin"
	removed_type = /obj/item/organ/kidneys
	robotic_type = /obj/item/organ/kidneys/prosthetic

/datum/internal_organ/kidneys/process()
	. = ..()
	if(. == PROCESS_KILL)
		return // Parent implemention qdeleted us

	//Deal toxin damage if damaged
	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return
	if(organ_status >= ORGAN_BRUISED && prob(25))
		owner.apply_damage(0.1 * (damage/3), TOX)
	else if(organ_status >= ORGAN_BROKEN && prob(50))
		owner.apply_damage(0.2 * (damage/3), TOX)

/datum/internal_organ/kidneys/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/kidneys


/datum/internal_organ/brain
	name = "brain"
	parent_limb = "head"
	removed_type = /obj/item/organ/brain
	robotic_type = /obj/item/organ/brain/prosthetic
	vital = 1

/datum/internal_organ/brain/process(delta_time)
	. = ..()
	if(. == PROCESS_KILL)
		return // Parent implemention qdeleted us

	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return

	if(organ_status >= ORGAN_BRUISED && prob(5 * delta_time))
		var/dir_choice = pick(list(NORTH, SOUTH, EAST, WEST))
		owner.drop_held_items()
		if(!owner.buckled && owner.stat == CONSCIOUS)
			owner.Move(get_step(get_turf(owner), dir_choice))
		to_chat(owner, SPAN_DANGER("Your mind wanders and goes blank for a moment..."))

	if(organ_status >= ORGAN_BROKEN && prob(5 * delta_time))
		owner.apply_effect(1, PARALYZE)
		if(owner.jitteriness < 100)
			owner.make_jittery(50)
		to_chat(owner, SPAN_DANGER("Your body seizes up!"))

/datum/internal_organ/brain/prosthetic //used by synthetic species
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/brain/prosthetic

/datum/internal_organ/brain/xeno
	removed_type = /obj/item/organ/brain/xeno
	robotic_type = null

/datum/internal_organ/eyes
	name = "eyes"
	parent_limb = "head"
	removed_type = /obj/item/organ/eyes
	robotic_type = /obj/item/organ/eyes/prosthetic
	var/eye_surgery_stage = 0 //stores which stage of the eye surgery the eye is at

/datum/internal_organ/eyes/process() //Eye damage replaces the old eye_stat var.
	. = ..()
	if(. == PROCESS_KILL)
		return // Parent implemention qdeleted us

	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return

	if(organ_status >= ORGAN_BRUISED)
		owner.SetEyeBlur(20)
	if(organ_status >= ORGAN_BROKEN)
		owner.SetEyeBlind(20)

/datum/internal_organ/eyes/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/eyes/prosthetic

/datum/internal_organ/proc/remove(mob/user)
	if(!removed_type)
		return 0

	var/obj/item/organ/removed_organ = new removed_type(get_turf(user), src)

	if(istype(removed_organ))
		organ_holder = removed_organ

	return removed_organ

/datum/internal_organ/Destroy()
	if(owner)
		owner.internal_organs -= src
		for(var/organ_name in owner.internal_organs_by_name)
			if(owner.internal_organs_by_name[organ_name] == src)
				owner.internal_organs_by_name -= organ_name
	owner = null
	organ_holder = null

	return ..()
