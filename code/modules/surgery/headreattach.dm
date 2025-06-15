//Procedures in this file: Synth head reattachment
//////////////////////////////////////////////////////////////////
//   REATTACHING ROBOHEAD //
//////////////////////////////////////////////////////////////////

/datum/surgery/head_reattach
	name = "Synthetic Head Reattachment"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	pain_reduction_required = NONE
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/peel_skin,
		/datum/surgery_step/reattach_head,
		/datum/surgery_step/mend_connections,
		/datum/surgery_step/cauterize/reposition_flesh,
	)
	requires_bodypart = FALSE
	requires_bodypart_type = LIMB_DESTROYED
	pain_reduction_required = NONE
	var/obj/item/limb/head/synth/patient_head
	var/no_revive = FALSE

/datum/surgery/head_reattach/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	if(IS_SYNTHETIC)
		return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/peel_skin
	name = "Peel Back Skin"
	desc = "peel the skin back"
	//Tools used to pry things open without orthopedic dramatics.
	tools = list(
		/obj/item/tool/surgery/retractor = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/crowbar = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 4 SECONDS

/datum/surgery_step/peel_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	//No need for to-patient messages on this one, they're ghosted or in the head.
	user.visible_message(SPAN_NOTICE("[user] begins to peel [target]'s neck stump open with \the [tool].") ,
	SPAN_NOTICE("You begin to peel [target]'s neck stump open with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began to peel back tattered artificial skin around [key_name(target)]'s neck with \the [tool].")

/datum/surgery_step/peel_skin/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	//we could fetch the synth's flesh type, but because this surgery is only for synths, I'm too lazy to do it.
	user.visible_message(SPAN_NOTICE("[user] draws back the ragged synthetic flesh of [target]'s neck stump."),
	SPAN_NOTICE("You draw back the ragged synthetic flesh of [target]'s neck stump."))

	surgery.affected_limb.setAmputatedTree()
	target.update_body()

	log_interact(user, target, "[key_name(user)] peeled back synthetic flesh where [key_name(target)]'s head used to be with \the [tool], beginning [surgery]")

/datum/surgery_step/peel_skin/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, somehow damaging the synthetic flesh of [target]'s stump even worse!"),
	SPAN_WARNING("Your hand slips, somehow damaging the synthetic flesh of [target]'s stump even worse!"))

	log_interact(user, target, "[key_name(user)] failed to finish peeling back synthetic flesh where [key_name(target)]'s head used to be with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/reattach_head
	name = "Reattach Synthetic Head"
	desc = "reattach the head"
	tools = list(/obj/item/limb/head/synth = SURGERY_TOOL_MULT_IDEAL)
	time = 10 SECONDS

/datum/surgery_step/reattach_head/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] begins to reattach [tool] to [target]'s neck."),
	SPAN_NOTICE("You begin reattaching [tool] to [target]'s neck."))
	log_interact(user, target, "[key_name(user)] started to attach [tool] to [key_name(target)]'s reshaped neck.")

/datum/surgery_step/reattach_head/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/head_reattach/surgery)
	user.visible_message(SPAN_NOTICE("[user] reattaches [target]'s head to the carbon fiber skeleton and silicon musculature of \his body."),
	SPAN_NOTICE("You reattach [target]'s head to the carbon fiber skeleton and silicon musculature of \his body."))
	log_interact(user, target, "[key_name(user)] attached [tool] to [key_name(target)]'s neck.")

	surgery.patient_head = tool

	user.drop_inv_item_to_loc(surgery.patient_head, target)
	surgery.affected_limb.robotize(surgery_in_progress = TRUE, uncalibrated = FALSE, synth_skin = TRUE)
	target.updatehealth()
	target.regenerate_icons()

	if(target.status_flags & PERMANENTLY_DEAD) //We'll be using this flag so the patient doesn't get defibbed before their head is all the way reattached.
		surgery.no_revive = TRUE

	target.status_flags |= PERMANENTLY_DEAD

/datum/surgery_step/reattach_head/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the connectors on [target]'s neck!"),
	SPAN_WARNING("Your hand slips, damaging the connectors on [target]'s neck!"))
	log_interact(user, target, "[key_name(user)] failed to attach [tool] to [key_name(target)]'s reshaped neck.")

	target.apply_damage(20, BRUTE, target_zone)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_connections
	name = "Reconstruct Throat"
	desc = "reconstruct the throat"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 4 SECONDS

/datum/surgery_step/mend_connections/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] begins to shape the synthetic flesh of [target]'s neck back into something anatomically recognizable with \the [tool]."),
	SPAN_NOTICE("You begin to shape the synthetic flesh of [target]'s neck back into something anatomically recognizable with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started to reshape [key_name(target)]'s head esophagal and vocal region with \the [tool].")

/datum/surgery_step/mend_connections/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] finishes reconstructing [target]'s throat."),
	SPAN_NOTICE("You finish reconstructing [target]'s throat."))

	log_interact(user, target, "[key_name(user)] reshaped [key_name(target)]'s head esophagal and vocal region with \the [tool].")

/datum/surgery_step/mend_connections/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, rending the synthetic flesh of [target]'s neck and throat even more!"),
	SPAN_WARNING("Your hand slips, rending the synthetic flesh of [target]'s neck and throat even more!"))

	log_interact(user, target, "[key_name(user)] failed to reshape [key_name(target)]'s head esophagal and vocal region with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/reposition_flesh
	name = "Seal Skin"
	desc = "seal the skin"
	time = 6 SECONDS

/datum/surgery_step/cauterize/reposition_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] begins making final adjustments to the area around [target]'s neck with \the [tool]."),
	SPAN_NOTICE("You begin making final adjustments to the area around [target]'s neck with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started to adjust the area around [key_name(target)]'s neck with \the [tool].")

/datum/surgery_step/cauterize/reposition_flesh/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/head_reattach/surgery)
	user.visible_message(SPAN_NOTICE("[user] finishes adjusting [target]'s neck."),
	SPAN_NOTICE("You finish adjusting [target]'s neck."))
	log_interact(user, target, "[key_name(user)] adjusted the area around [key_name(target)]'s neck with \the [tool].")

	if(!surgery.no_revive) //Unset this flag if they didn't have it before the surgery started.
		target.status_flags &= ~PERMANENTLY_DEAD

	//Prepare mind datum
	if(surgery.patient_head.brainmob.mind)
		surgery.patient_head.brainmob.mind.transfer_to(target)

	else // attempt to transfer linked ghost if not found
		for(var/mob/dead/observer/G in GLOB.observer_list)
			if(istype(G) && G.mind && G.mind.original == surgery.patient_head.brainmob && G.can_reenter_corpse)
				G.mind.original = target
				break

	qdel(surgery.patient_head) //Destroy head item.

/datum/surgery_step/cauterize/reposition_flesh/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, searing [target]'s neck!"),
	SPAN_WARNING("Your hand slips, searing [target]'s [surgery.affected_limb.name]!"))
	log_interact(user, target, "[key_name(user)] failed to adjust the area around [key_name(target)]'s neck with \the [tool].")

	return FALSE

