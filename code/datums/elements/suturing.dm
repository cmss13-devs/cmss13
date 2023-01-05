//Item element and limb datums for handling wound suturing.
//You can suture up to half the damage. After that, it has to be healed properly.

//Signal return only appears to work with numbers, with INFINITY not working. These are numbers vast enough they shouldn't ever come up in gameplay otherwise.
#define CANNOT_SUTURE 1<<19
#define FULLY_SUTURED 1<<20

/datum/element/suturing
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	///Action time (in deciseconds) to heal each point of damage.
	var/time_per_damage_point
	/**Damage types that can be treated. Both are healed simultaneously.
	With above: a brute + burn tool with time 2, used on a person with 20 brute and 20 burns, would heal 10 of each type after a 4 second delay.
	On a person with just 20 brute, it would heal 10 brute after 2 seconds.**/
	var/suture_brute = FALSE
	var/suture_burn = FALSE
	///ex. 'suture', "you begin to [] the [wounds]". ALso has 's' put on the end sometimes, '[suture]s'.
	var/description_verb
	///ex 'suturing', "[user] finishes [] the [wounds]"
	var/description_verbing
	///"it feels like your [left arm] is []!"
	var/description_pain
	//ex. 'wounds', "the []"
	var/description_wounds

/datum/element/suturing/Attach(datum/target, brute, burns, time_per_point, desc_verb = "treat", \
	desc_verbing = "treating", desc_pain = "hurts", desc_wounds = "wounds")
	. = ..()
	if(!brute && !burns || !time_per_point)
		return ELEMENT_INCOMPATIBLE

	if(brute) //Making sure it's TRUE/FALSE so there's no miscalculations.
		suture_brute = TRUE
	if(burns)
		suture_burn = TRUE
	time_per_damage_point = time_per_point

	description_verb = desc_verb
	description_verbing = desc_verbing
	description_pain = desc_pain
	description_wounds = desc_wounds

	RegisterSignal(target, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_SELF), PROC_REF(begin_suture))

/datum/element/suturing/Detach(datum/source, force)
	UnregisterSignal(source, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_SELF))
	return ..()

/* WELCOME TO TEND WOUNDS GENTLEMEN, UNFORTUNATELY YOUR CHANCES OF REVIVAL ARE LOW,
PFCS MAY EVEN TANTRUM AGAINST YOUR MEDICS AS 400 BRUTE CORPSES, BUT YOU HAVE MY WORD THAT I
WILL USE MY SURGERY 1 SKILLS TO ENSURE YOUR BODIES ARE SUB-200 DAMAGE. THIS IS THE GREATEST
SURGERY, EVEN MORE THAN LARVA REMOVAL, FOR THE FATE OF YOUR DEFIB IS A 5 MINUTE CONCERN.
NOW COME, RETURN TO CORPSE, STRIKE DOWN THE OB DAMAGE THAT BEAT AGAINST YOU, ALLOW US TO TREAT
YOU TO 200 DAMAGE. I ASK NOT FOR MY OWN MEDIC EGOSTROKING, BUT FOR THE GOOD OF THE ROUND. */
/datum/element/suturing/proc/begin_suture(obj/item/suturing_item, mob/living/carbon/user, mob/living/carbon/human/target)
	SIGNAL_HANDLER
	if(isnull(target)) //Attacking self/using item in hand.
		target = user
	if(!ishuman(target) || user.a_intent == INTENT_HARM)
		return
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't know how to [description_verb] [user == target ? "yourself" : target] with \the [suturing_item]!"))
		return

	INVOKE_ASYNC(src, PROC_REF(suture), suturing_item, user, target, target.get_limb(check_zone(user.zone_selected))) //do_after sleeps.
	return COMPONENT_CANCEL_ATTACK

/datum/element/suturing/proc/suture(obj/item/suturing_item, mob/living/carbon/user, mob/living/carbon/human/target, obj/limb/target_limb, looping)
	if(user.action_busy || user.a_intent == INTENT_HARM || QDELETED(target))
		return

	if(!target_limb || target_limb.status & LIMB_DESTROYED)
		to_chat(user, SPAN_WARNING("[user == target ? "You have" : "\The [target] has"] no [target_limb.display_name]!"))
		return
	if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		to_chat(user, SPAN_WARNING("You can't repair a robotic limb with \the [suturing_item]!"))
		return
	if(target_limb.get_incision_depth())
		to_chat(user, SPAN_WARNING("[user == target ? "Your" : "\The [target]'s"] [target_limb.display_name] has been cut open and needs to be closed surgically!"))
		return

	//Figure out how much damage we can suture.
	var/suturable_damage = SEND_SIGNAL(target_limb, COMSIG_LIMB_SUTURE_CHECK, suture_brute, suture_burn, looping) //looping = we don't need to recalc suture datum.

	switch(suturable_damage) //SEND_SIGNAL returns 0 by default if there's no signal to answer.
		if(CANNOT_SUTURE) //Datum exists, no suturable damage types.
			to_chat(user, SPAN_WARNING("There are no [description_wounds] on [user == target ? "your" : "\the [target]'s"] [target_limb.display_name]."))
			return
		if(FULLY_SUTURED) //Datum exist, all suturable damage types have been fully sutured.
			to_chat(user, SPAN_WARNING("The [description_wounds] on [user == target ? "your" : "\the [target]'s"] [target_limb.display_name] have already been treated."))
			return
		if(0) //No datum.
			//Stitch in 10 damage increments. Balance between flexibility, spam, performance, and opportunities for people to mess about during do_afters.
			if(suture_brute)
				suturable_damage += min(10, target_limb.brute_dam * 0.5)
			if(suture_burn)
				suturable_damage += min(10, target_limb.burn_dam * 0.5)
			if(!suturable_damage) //This stuff would be much tidier if datum stuff is moved to the limb.
				to_chat(user, SPAN_WARNING("There are no [description_wounds] on [user == target ? "your" : "\the [target]'s"] [target_limb.display_name]."))
				return

	//Select user feedback and get a time-per-point mult.
	var/suture_time = time_per_damage_point
	var/skill_msg
	switch(user.skills.get_skill_level(SKILL_MEDICAL))
		if(SKILL_MEDICAL_MEDIC) //Numbers are centered around medics.
			skill_msg = " with [pick("steady", "careful", "practiced")] [pick("skill", "motions", "hands")]"
		if(SKILL_MEDICAL_DOCTOR) //Who?
			suture_time *= 0.75
			skill_msg = " with [pick("swift", "precise", "smooth")] [pick("skill", "care", "motions", "competence")]"
		if(SKILL_MEDICAL_MASTER) //I hand my munted biker jacket to the synth. "Hey, Sewing Machine. Need this fixed real quick, hot date tonight."
			suture_time *= 0.5
			skill_msg = " with [pick("mechanical", "inhuman", "absolute")] [pick("perfection", "precision", "certainty")]"

	var/possessive
	var/possessive_their
	if(user == target)
		suture_time *= 1.5 //Stitching yourself up is badass but awkward.
		possessive = "your"
		possessive_their = user.gender == MALE ? "his" : "her"
		if(!looping) //start message.
			skill_msg = pick("awkwardly", "slowly and carefully")
			user.visible_message(SPAN_NOTICE("[user] begins to [skill_msg] [description_verb] the [description_wounds] on \his [target_limb.display_name]."),
				SPAN_HELPFUL("You <b>begin to [skill_msg] [description_verb]</b> the [description_wounds] on your <b>[target_limb.display_name]</b>."))
			target.custom_pain("It feels like your [target_limb.display_name] is [description_pain]!")
	else
		possessive = "\the [target]'s"
		possessive_their = "\the [target]'s"
		if(!looping)
			user.affected_message(target,
				SPAN_HELPFUL("You <b>begin to [description_verb]</b> the [description_wounds] on [possessive_their] <b>[target_limb.display_name]</b>[skill_msg]."),
				SPAN_HELPFUL("[user] <b>begins to [description_verb]</b> the [description_wounds] on your <b>[target_limb.display_name]</b>[skill_msg]."),
				SPAN_NOTICE("[user] begins to [description_verb] the [description_wounds] on [possessive_their] [target_limb.display_name][skill_msg]."))
			target.custom_pain("It feels like your [target_limb.display_name] is [description_pain]!")

	if(target.pain?.feels_pain && target.stat == CONSCIOUS && target.pain.reduction_pain < PAIN_REDUCTION_HEAVY && prob(max(0, PAIN_REDUCTION_HEAVY - target.pain.reduction_pain))) //This is based on surgery pain failure code but more lenient.
		do_after(user, max(rand(suture_time * 0.1, suture_time * 0.5), 0.5), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)
		if(user != target)
			to_chat(user, SPAN_DANGER("[target] couldn't hold still through the pain of the [description_verbing]!"))
		to_chat(target, SPAN_DANGER("The pain was too much, you couldn't hold still!"))
		INVOKE_ASYNC(target, TYPE_PROC_REF(/mob, emote), "pain")
		return

	/*Adjust suture time by how much damage we're going to remove. This does technically have a loophole where you could start a suture for ~5 damage and then
	take damage before it finishes, meaning damage is sutured faster than it should be, but only half can be sutured away so even so, you're still in trouble.*/
	suture_time *= suturable_damage

	//Timer and redo checks in case something funny happened during the do_after().
	if(!do_after(user, suture_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)\
		|| target_limb.status & (LIMB_DESTROYED|LIMB_ROBOT|LIMB_SYNTHSKIN) || target_limb.get_incision_depth())
		to_chat(user, SPAN_WARNING("You were interrupted before you could finish!"))
		return

	//Add the sutures.
	var/added_sutures = SEND_SIGNAL(target_limb, COMSIG_LIMB_ADD_SUTURES, suture_brute, suture_burn)
	if(!added_sutures) //No suture datum to answer the signal
		new /datum/suture_handler(target_limb)
		added_sutures = SEND_SIGNAL(target_limb, COMSIG_LIMB_ADD_SUTURES, suture_brute, suture_burn) //This time, with feeling.

	if(added_sutures & SUTURED_FULLY)
		user.affected_message(target,
			SPAN_HELPFUL("You <b>finish [description_verbing]</b> the [description_wounds] on [possessive] <b>[target_limb.display_name]</b>."),
			SPAN_HELPFUL("[user] <b>finishes [description_verbing]</b> the [description_wounds] on your <b>[target_limb.display_name]</b>."),
			SPAN_NOTICE("[user] finishes [description_verbing] the [description_wounds] on [possessive_their] [target_limb.display_name]."))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You [description_verb] some of the [description_wounds] on [possessive] [target_limb.display_name]."),
			SPAN_HELPFUL("[user] [description_verb]s some of the [description_wounds] on your [target_limb.display_name]."),
			SPAN_NOTICE("[user] [description_verb]s some of the [description_wounds] on [possessive_their] [target_limb.display_name]."))

		suture(suturing_item, user, target, target_limb, TRUE) //Loop - untreated wounds remain.

////////////////////////////////////
///Handles sutures for this limb. Doesn't process, updates on limb damage and new suture attempts.
/datum/suture_handler
	//The amounts of damage that were sutured.
	var/sutured_brute
	var/sutured_burn
	//The amounts of damage remaining. Compared with limb damage on update to determine how much has healed in the meantime.
	var/remaining_brute
	var/remaining_burn

/datum/suture_handler/New(obj/limb/target_limb)
	. = ..()
	remaining_brute = target_limb.brute_dam
	remaining_burn = target_limb.burn_dam
	RegisterSignal(target_limb, COMSIG_LIMB_TAKEN_DAMAGE, PROC_REF(update_sutures))
	RegisterSignal(target_limb, COMSIG_LIMB_ADD_SUTURES, PROC_REF(add_sutures))
	RegisterSignal(target_limb, COMSIG_LIMB_SUTURE_CHECK, PROC_REF(check_sutures))
	RegisterSignal(target_limb, COMSIG_LIMB_REMOVE_SUTURES, PROC_REF(remove_sutures))

///Unregisters datum. The signals are the only references to this.
/datum/suture_handler/proc/remove_sutures(obj/limb/target_limb)
	SIGNAL_HANDLER
	UnregisterSignal(target_limb, list(
		COMSIG_LIMB_TAKEN_DAMAGE,
		COMSIG_LIMB_ADD_SUTURES,
		COMSIG_LIMB_SUTURE_CHECK,
		COMSIG_LIMB_REMOVE_SUTURES
		))

///Updates the amount of sutured damage remaining.
/datum/suture_handler/proc/update_sutures(obj/limb/target_limb, is_ff, previous_brute, previous_burn, pre_add)
	SIGNAL_HANDLER

	if(sutured_brute)
		if(!previous_brute) //To catch an annoying floating point error with tiny amounts of suturing never healing.
			sutured_brute = 0
		else
			var/delta_brute = previous_brute - remaining_brute //Get difference between amount of damage before the attack and the amount of damage as of the last update
			if(delta_brute < 0) //Damage had healed since last update, so sutures should heal also.
				sutured_brute = max(0, sutured_brute + delta_brute)

	if(sutured_burn)
		if(!previous_burn)
			sutured_burn = 0
		else
			var/delta_burn = previous_burn - remaining_burn
			if(delta_burn < 0)
				sutured_burn = max(0, sutured_burn + delta_burn)

	//Update remaining damage. Note *post-attack dam* not previous_xxx.
	remaining_brute = target_limb.brute_dam
	remaining_burn = target_limb.burn_dam

	if(!sutured_brute && !sutured_burn && !pre_add) //All sutures healed and not about to add more, unregister datum.
		remove_sutures(target_limb)

///Determines how many sutures can be added up to the max of 10 per type. Modifies a list referenced as an arg.
/datum/suture_handler/proc/check_sutures(obj/limb/target_limb, suture_brute, suture_burn, repeat)
	SIGNAL_HANDLER
	if(!repeat) //Don't need to update again if we're doing it immediately after adding stitches.
		update_sutures(target_limb, previous_brute = target_limb.brute_dam, previous_burn = target_limb.burn_dam, pre_add = TRUE)
	if(suture_brute)
		. += clamp(0, (remaining_brute - sutured_brute) * 0.5, 10)
	if(suture_burn)
		. += clamp(0, (remaining_burn - sutured_burn) * 0.5, 10)
	if(. <= 0.1) //to distinguish with 0 from send_signal() not getting any return value. Uses <= to prevent floating point errors.
		if(suture_brute && sutured_brute || suture_burn && sutured_burn)
			return FULLY_SUTURED
		return CANNOT_SUTURE

/**Used to order a limb to add sutures. COMSIG_LIMB_ADD_SUTURES doesn't return something = no suture datum to answer.
suture_brute = heals brute, boolean, also tracks fully-sutured state.
suture_burn = ^ but for burns
maximum_heal = total amount of each damage type that can be healed - IE TRUE/TRUE/10 = up to 10 brute AND up to 10 burns**/
/datum/suture_handler/proc/add_sutures(obj/limb/target_limb, suture_brute, suture_burn, maximum_heal = 10)
	SIGNAL_HANDLER
	update_sutures(target_limb, previous_brute = target_limb.brute_dam, previous_burn = target_limb.burn_dam, pre_add = TRUE) //Damage may have been healed during the do_after.

	var/brute_to_heal
	var/burn_to_heal
	if(suture_brute)
		brute_to_heal = min(maximum_heal, (remaining_brute - sutured_brute) * 0.5)
		sutured_brute += brute_to_heal
		remaining_brute -= brute_to_heal
		if(remaining_brute - sutured_brute <= 0)
			target_limb.remove_all_bleeding(TRUE)
			suture_brute = FALSE
			for(var/datum/wound/W as anything in target_limb.wounds)
				if(W.internal || W.damage_type == BURN) //Can't suture IB.
					continue
				W.bandaged |= WOUND_SUTURED

	if(suture_burn)
		burn_to_heal = min(maximum_heal, (remaining_burn - sutured_burn) * 0.5)
		sutured_burn += burn_to_heal
		remaining_burn -= burn_to_heal
		if(remaining_burn - sutured_burn <= 0)
			suture_burn = FALSE
			for(var/datum/wound/W as anything in target_limb.wounds)
				if(W.internal)
					continue
				if(W.damage_type == BURN)
					W.salved |= WOUND_SUTURED

	target_limb.heal_damage(brute_to_heal, burn_to_heal)

	if(!suture_brute && !suture_burn)
		return SUTURED_FULLY
	else
		return SUTURED

#undef CANNOT_SUTURE
#undef FULLY_SUTURED
