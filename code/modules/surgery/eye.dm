//Procedures in this file: Eye mending surgery
//Steps will only work in a surgery of /datum/surgery/eye_repair or a child of that due to target_eyes var.
//////////////////////////////////////////////////////////////////
// EYE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/eye_repair
	name = "Eye Repair Surgery"
	possible_locs = list("eyes")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_FULL //Eyes DO have pain receptors... Almost more than any other organ. Ever been poked in the eye? Shit hurts.
	steps = list(
		/datum/surgery_step/separate_corneas,
		/datum/surgery_step/lift_corneas,
		/datum/surgery_step/open_eyes,
		/datum/surgery_step/mend_eyes,
		/datum/surgery_step/cauterize/eyes,
	)
	var/datum/internal_organ/eyes/target_eyes

/datum/surgery/eye_repair/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(target)
		var/mob/living/carbon/human/targethuman = target
		target_eyes = targethuman.internal_organs_by_name["eyes"]

/datum/surgery/eye_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/eyes/E = patient.internal_organs_by_name["eyes"]
	return E.robotic != ORGAN_ROBOT && (patient.sdisabilities & DISABILITY_BLIND || patient.disabilities & NEARSIGHTED || E.damage > 0)

//------------------------------------

/datum/surgery_step/separate_corneas
	name = "Separate Corneas"
	desc = "separate the corneas"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/separate_corneas/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to separate the corneas of [target]'s eyes with [tool]."),
		SPAN_NOTICE("[user] starts to separate the corneas of your eyes with [tool]."),
		SPAN_NOTICE("[user] starts to separate the corneas of [target]'s eyes with [tool]."))

	target.custom_pain("You feel a searing, piercing pain in your eyeballs as your corneas are being sliced open!",1)
	log_interact(user, target, "[key_name(user)] started to separate the corneas on [key_name(target)]'s eyes with [tool].")

/datum/surgery_step/separate_corneas/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have separated [target]'s corneas."),
		SPAN_NOTICE("[user] has separated your corneas."),
		SPAN_NOTICE("[user] has separated [target]'s corneas."))

	log_interact(user, target, "[key_name(user)] separated the corneas on [key_name(target)]'s eyes with [tool], starting [surgery].")

	to_chat(target, SPAN_WARNING("Everything goes blurry."))
	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	target.disabilities |= NEARSIGHTED // My corneas! I can't see!

/datum/surgery_step/separate_corneas/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, slicing [target]'s eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing your eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s eyes with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to separate the corneas on [key_name(target)]'s eyes with [tool], aborting [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/lift_corneas
	name = "Lift Corneas and Move Lenses"
	desc = "lift the corneas and move the lenses"
	tools = SURGERY_TOOLS_PINCH
	time = 2 SECONDS

	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/lift_corneas/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin lifting the corneas and moving the lenses out of the way from [target]'s eyes with [tool]."),
		SPAN_NOTICE("[user] begins lifting the corneas and moving the lenses out of the way from your eyes with [tool]."),
		SPAN_NOTICE("[user] begins lifting the corneas and moving the lenses out of the way from [target]'s eyes with [tool]."))

	target.custom_pain("You feel pressure and pulling on the surface of your eyes!",1)
	log_interact(user, target, "[key_name(user)] started lifting the corneas and moving the lenses out of the way from  [key_name(target)]'s eyes with [tool].")

/datum/surgery_step/lift_corneas/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish lifting [target]'s corneas and moving the lenses."),
		SPAN_NOTICE("[user] has lifted your corneas and moving the lenses."),
		SPAN_NOTICE("[user] has lifted [target]'s corneas and moving the lenses."))

	log_interact(user, target, "[key_name(user)] lifted the corneas and lenses away from [key_name(target)]'s eyes with [tool].")

/datum/surgery_step/lift_corneas/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to lift the corneas and lenses away from [key_name(target)]'s eyes with [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/open_eyes
	name = "Open Eyes"
	desc = "open the eyeballs"
	tools = SURGERY_TOOLS_PRY_DELICATE
	time = 4 SECONDS

	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/open_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to gently and carefully open [target]'s eyeballs with [tool] to expose the retinas, optic nerves, and blood vessels."),
		SPAN_NOTICE("[user] begins to gently and carefully open your eyeballs with [tool] to expose the retinas, optic nerves, and blood vessels."),
		SPAN_NOTICE("[user] begins to gently and carefully open [target]'s eyeballs with [tool] to retinas, optic nerves, and blood vessels."))

	target.custom_pain("The pressure inside your eyeballs is immense as [user] holds them open!",1)
	log_interact(user, target, "[key_name(user)] began to open [key_name(target)]'s eyeballs with [tool].")

/datum/surgery_step/open_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You open [target]'s eyeballs."),
		SPAN_NOTICE("[user] opens your eyeballs."),
		SPAN_NOTICE("[user] opens [target]'s eyeballs."))

	log_interact(user, target, "[key_name(user)] opened [key_name(target)]'s eyeballs with [tool].")

/datum/surgery_step/open_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to open [key_name(target)]'s eyes with [tool].")

	target.apply_damage(10, BRUTE, target_zone, sharp = 1)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_eyes
	name = "Mend the Eyes"
	desc = "mend the damage inside the eyeballs"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 5 SECONDS

	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/mend_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to repair the damage done to [target]'s eyeballs with [tool]."),
		SPAN_NOTICE("[user] begins to repair the damage done to your eyeballs with [tool]."),
		SPAN_NOTICE("[user] begins to repair the damage done to [target]'s eyeballs with [tool]."))

	target.custom_pain("[tool] moving around in your eyeballs feels bizarre and painful!",1)
	log_interact(user, target, "[key_name(user)] begins to mend the damage to [key_name(target)]'s eyeballs with [tool].")

/datum/surgery_step/mend_eyes/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	if(target.sdisabilities & DISABILITY_BLIND)
		user.affected_message(target,
			SPAN_NOTICE("You finish laying [target]'s detached retinas back into place and mending the damaged optic nerves that caused total blindness."),
			SPAN_WARNING("[user] finishes laying your detached retinas back into place and mending the damaged optic nerves that caused total blindness."),
			SPAN_WARNING("[user] finishes laying [target]'s detached retinas back into place and mending the damaged optic nerves that caused total blindness."))
	if(target.disabilities & NEARSIGHTED)
		user.affected_message(target,
			SPAN_NOTICE("You finish reshaping [target]'s corneas so they can focus light accurately again."),
			SPAN_NOTICE("[user] finishes reshaping your corneas so they can focus light accurately again."),
			SPAN_WARNING("[user] finishes reshaping [target]'s corneas so they can focus light accurately again."))
	if(E && E.damage > 0)
		user.affected_message(target,
			SPAN_NOTICE("You finish mending the damaged blood vessels within and the surface damage outside of [target]'s eyes."),
			SPAN_NOTICE("[user] finishes mending the damaged blood vessels within and the surface damage outside of your eyes."),
			SPAN_NOTICE("[user] finishes mending the damaged blood vessels within and the surface damage outside of [target]'s eyes."))
	user.affected_message(target,
			SPAN_NOTICE("You finish mending the damage in [target]'s eyes."),
			SPAN_NOTICE("[user] finishes mending the damage in your eyes."),
			SPAN_NOTICE("[user] finishes mending the damage in [target]'s eyes."))

	log_interact(user, target, "[key_name(user)] mended the damage inside [key_name(target)]'s eyes with [tool].")

/datum/surgery_step/mend_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s eyeballs with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your eyeballs with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyeballs with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend the damage inside [key_name(target)]'s eyes with [tool].")

	target.apply_damage(10, BRUTE, target_zone, sharp = 1)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/eyes
	name = "Cauterize Eye Incisions"
	desc = "reattach the corneas and lenses and close the eyeballs"
	time = 3 SECONDS

/datum/surgery_step/cauterize/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to reattach [target]'s corneas and lenses and close \his eyeballs with [tool]."),
		SPAN_NOTICE("[user] begins to reattach your corneas and lenses and close your eyeballs with [tool]."),
		SPAN_NOTICE("[user] begins to reattach [target]'s corneas and lenses and close \his eyeballs with [tool]."))

	target.custom_pain("Your eyes burn!",1)
	log_interact(user, target, "[key_name(user)] began to cauterize the incision around [key_name(target)]'s eyes with [tool].")

/datum/surgery_step/cauterize/eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You reattach [target]'s corneas and lenses and close \his eyeballs."),
		SPAN_NOTICE("[user] reattaches your corneas and lenses and closes your eyeballs."),
		SPAN_NOTICE("[user] reattaches [target]'s corneas and lenses and closes \his eyeballs."))

	log_interact(user, target, "[key_name(user)] cauterized the incision around [key_name(target)]'s eyes with [tool], ending [surgery].")

	to_chat(target, SPAN_NOTICE("The pain in your eyeballs is gone and you can see again!"))
	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.disabilities &= ~NEARSIGHTED
	target.sdisabilities &= ~DISABILITY_BLIND
	surgery.target_eyes.heal_damage(surgery.target_eyes.damage)
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_EYE)
	target.pain.recalculate_pain()

/datum/surgery_step/cauterize/eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, searing [target]'s eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, searing your eyes with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, searing [target]'s eyes with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to cauterize the incision around [key_name(target)]'s eyes with [tool].")

	target.apply_damage(15, BURN, target_zone)
	surgery.target_eyes.take_damage(10, FALSE)
	return FALSE
