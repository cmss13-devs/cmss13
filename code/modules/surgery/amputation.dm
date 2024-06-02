//Procedures in this file: Amputations, preparing stumps for prosthetics, including stumps of robotic limbs.
//////////////////////////////////////////////////////////////////
// LIMB SURGERY //
//////////////////////////////////////////////////////////////////

//Sever a limb cleanly.
/datum/surgery/amputate
	name = "Amputation"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/cut_muscle,
		/datum/surgery_step/abort_amputation,
		/datum/surgery_step/saw_off_limb,
		/datum/surgery_step/carve_amputation,
		/datum/surgery_step/close_amputation,
	)

//Mend the stump left by a traumatic amputation. Can be performed by medics/nurses. Torn-off limbs should bleed heavily.
/datum/surgery/amputate/repair
	name = "Repair Traumatic Amputation Stump"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(
		/datum/surgery_step/carve_amputation,
		/datum/surgery_step/close_ruptured_veins,
		/datum/surgery_step/close_amputation,
	)
	requires_bodypart = FALSE

/datum/surgery/amputate/repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return !(L.status & LIMB_AMPUTATED)

//Mend the stump left by a traumatic amputation of a prosthetic. Needs a doctor, prosthetics are hard.
/datum/surgery/amputate/repair/robot
	name = "Remove Prosthetic Stump"
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/sever_prosthetic_clamps,
		/datum/surgery_step/remove_old_prosthetic,
	)
	requires_bodypart_type = LIMB_ROBOT
	pain_reduction_required = NONE

//------------------------------------

/datum/surgery_step/cut_muscle
	name = "Cut Muscular Tissue"
	desc = "begin an amputation"
	tools = SURGERY_TOOLS_INCISION
	time = 5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/cut_muscle/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to sever the muscles in [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_WARNING("[user] begins to sever the muscles in your [surgery.affected_limb.display_name]!"),
		SPAN_NOTICE("[user] begins to sever the muscles in [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("Your [surgery.affected_limb.display_name] is being ripped apart!", 1)

	if(tool.hitsound)
		playsound(target.loc, tool.hitsound, 25, TRUE)
	log_interact(user, target, "[key_name(user)] attempted an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"].")

/datum/surgery_step/cut_muscle/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish severing the muscles in [target]'s [surgery.affected_limb.display_name]. They can be reattached if you've changed your mind, but once you start to cut through the bone you'll have to see it through to the end."),
		SPAN_WARNING("[user] has severed the muscles in your [surgery.affected_limb.display_name]!"),
		SPAN_NOTICE("[user] has severed the muscles in [target]'s [surgery.affected_limb.display_name]."))

	log_interact(user, target, "[key_name(user)] successfully began an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"], starting [surgery].")

/datum/surgery_step/cut_muscle/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, slicing [target]'s [surgery.affected_limb.display_name] in the wrong place!"),
		SPAN_WARNING("[user]'s hand slips, slicing your [surgery.affected_limb.display_name] in the wrong place!"),
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s [surgery.affected_limb.display_name] in the wrong place!"))

	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to begin an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/abort_amputation
	name = "Reconnect Muscular Tissue (Surgery Abort)"
	desc = "reconnect the muscles and abort the amputation"
	tools = SURGERY_TOOLS_SUTURE
	time = 3 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/abort_amputation/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE //This is an abort pathway to stop people from being locked into a major and irreversible surgery. It is not yet too late for my mercy.

/datum/surgery_step/abort_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to stitch the muscles in [target]'s [surgery.affected_limb.display_name] back together with \the [tool]."),
		SPAN_NOTICE("[user] begins to stitch the muscles in your [surgery.affected_limb.display_name] back together with \the [tool]."),
		SPAN_NOTICE("[user] begins to stitch the muscles in [target]'s [surgery.affected_limb.display_name] back together \the [tool]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is unbearable!", 1)

	log_interact(user, target, "[key_name(user)] attempted to abort an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/abort_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish reconnecting the muscles in [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] has reconnected the muscles in your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] has reconnected the muscles in [target]'s [surgery.affected_limb.display_name]."))

	complete(target, surgery)
	log_interact(user, target, "[key_name(user)] successfully aborted an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/abort_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.display_name] with \the [tool]!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to abort an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/saw_off_limb
	name = "Sever Bone"
	desc = "cut off the limb"
	tools = SURGERY_TOOLS_SEVER_BONE
	time = 6 SECONDS
	///Tools which cannot instantly hack off a limb when amputating. Bayonet is for sawing, butcher/hatchet are smaller substitutes for machete/fire axe.
	var/list/cannot_hack = list(
		/obj/item/tool/kitchen/knife/butcher,
		/obj/item/tool/hatchet,
		/obj/item/attachable/bayonet
		)
	preop_sound = 'sound/surgery/saw.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/effects/bone_break6.ogg'

/datum/surgery_step/saw_off_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start cutting through the bone in [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_WARNING("[user] starts cutting through the bone in your [surgery.affected_limb.display_name]!"),
		SPAN_NOTICE("[user] starts cutting through the bone in [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("Your [surgery.affected_limb.display_name] is being hacked away!", 1)

	if(tool.hitsound)
		playsound(target.loc, tool.hitsound, 25, TRUE)

	log_interact(user, target, "[key_name(user)] attempted to continue an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/saw_off_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cut [target]'s [surgery.affected_limb.display_name] off."),
		SPAN_WARNING("[user] cuts your [surgery.affected_limb.display_name] off!"),
		SPAN_NOTICE("[user] cuts [target]'s [surgery.affected_limb.display_name] off."))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_AMPUTATE)
	surgery.affected_limb.droplimb(amputation = TRUE, surgery_in_progress = TRUE)
	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	log_interact(user, target, "[key_name(user)] successfully severed [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/saw_off_limb/failure(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)

	if(tool_type in cannot_hack) //Some tools are not cool enough to instantly hack off a limb.
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, cutting into the wrong part of [target]'s [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, cutting into the wrong part of your [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, cutting into the wrong part of [target]'s [surgery.affected_limb.display_name]!"))

		surgery.affected_limb.fracture()
		target.apply_damage(20, BRUTE, surgery.affected_limb)
		log_interact(user, target, "[key_name(user)] failed to cut [key_name(target)]'s [surgery.affected_limb.display_name] off with \the [tool].")
		return FALSE

	else
		user.affected_message(target,
			SPAN_WARNING("You hack [target]'s [surgery.affected_limb.display_name] off!"),
			SPAN_WARNING("[user] hacks your [surgery.affected_limb.display_name] off!"),
			SPAN_WARNING("[user] hacks [target]'s [surgery.affected_limb.display_name] off!"))

		user.animation_attack_on(target)
		user.count_niche_stat(STATISTICS_NICHE_SURGERY_AMPUTATE)
		surgery.affected_limb.droplimb() //This will sever the limb messily and reset incision depth. The stump cleanup surgery will have to be done to properly amputate, but doing this saved two seconds. Worth it?
		target.apply_damage(20, BRUTE, surgery.affected_limb.parent)
		log_interact(user, target, "[key_name(user)] hacked [key_name(target)]'s [surgery.affected_limb.display_name] off with \the [tool], ending [surgery].")
		return TRUE

//------------------------------------

/datum/surgery_step/carve_amputation
	name = "Remove Excess Flesh"
	desc = "cut excess flesh from the stump"
	tools = SURGERY_TOOLS_INCISION
	time = 3 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/carve_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin removing irregular chunks of flesh from the stump of [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] starts cutting away pieces of flesh from what's left of your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] begins to cut irregular chunks of flesh from what's left of [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("[user] is carving up your stump like a Christmas roast!", 1)
	log_interact(user, target, "[key_name(user)] attempted to begin cleaning up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/carve_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cut away uneven flesh where [target]'s [surgery.affected_limb.display_name] used to be."),
		SPAN_NOTICE("[user] cuts away uneven flesh where your [surgery.affected_limb.display_name] used to be."),
		SPAN_NOTICE("[user] cuts away uneven flesh where [target]'s [surgery.affected_limb.display_name] used to be."))

	log_interact(user, target, "[key_name(user)] successfully began cleaning up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly starting [surgery].")

/datum/surgery_step/carve_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, cutting [target]'s [surgery.affected_limb.parent.display_name] open!"),
		SPAN_WARNING("[user]'s hand slips, cutting your [surgery.affected_limb.parent.display_name] open!"),
		SPAN_WARNING("[user]'s hand slips, cutting [target]'s [surgery.affected_limb.parent.display_name] open!"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to clean up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/close_ruptured_veins
	name = "Close Ruptured Veins"
	desc = "mend the torn blood vessels"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 4 SECONDS
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound =	'sound/surgery/organ2.ogg'

/datum/surgery_step/close_ruptured_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to mend torn blood vessels in [target]'s stump with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend torn blood vessels in your stump with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend torn blood vessels in [target]'s stump with \the [tool]."))

	target.custom_pain("The pain in the stump of your [surgery.affected_limb.display_name] is bizarre and horrifying!", 1)
	log_interact(user, target, "[key_name(user)] attempted to mend blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_ruptured_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish repairing the blood vessels in [target]'s stump."),
		SPAN_NOTICE("[user] finishes repairing the blood vessels in your stump."),
		SPAN_NOTICE("[user] finishes repairing the blood vessels in [target]'s stump."))

	surgery.affected_limb.remove_all_bleeding()
	log_interact(user, target, "[key_name(user)] mended blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_ruptured_veins/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/FixOVein)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, smearing [tool] in the stump of [target]'s [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] in the stump of your [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] in the stump of [target]'s [surgery.affected_limb.display_name]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.display_name]'s stump with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.display_name]'s stump with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.display_name]'s stump with \the [tool]!"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to mend blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/close_amputation
	name = "Seal Stump"
	desc = "stitch the stump closed"
	tools = SURGERY_TOOLS_SUTURE
	time = 3 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/close_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin folding the flesh of [target]'s stump over the bone and stitching it together with \the [tool]."),
		SPAN_NOTICE("[user] begins folding the flesh of your stump over the bone and stitching it together with \the [tool]."),
		SPAN_NOTICE("[user] begins folding the flesh of [target]'s stump over the bone and stitching it together with \the [tool]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is unbearable!", 1)
	log_interact(user, target, "[key_name(user)] attempted to close the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish repairing the stump of [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] finishes repairing the stump of your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] finishes repairing the stump of [target]'s [surgery.affected_limb.display_name]."))

	surgery.affected_limb.setAmputatedTree()
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] closed the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/close_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.display_name]'s stump with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.display_name]'s stump with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.display_name]'s stump with \the [tool]!"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to close the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/sever_prosthetic_clamps
	name = "Sever Damaged Prosthetic Clamps"
	desc = "cut through the jammed clamps holding the prosthesis' stump on"
	tools = SURGERY_TOOLS_SEVER_BONE
	time = 5 SECONDS
	success_sound = 'sound/surgery/saw.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/sever_prosthetic_clamps/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start carefully cutting through the jammed clamps holding what's left of [target]'s prosthesic [surgery.affected_limb.display_name] on with \the [tool]."),
		SPAN_NOTICE("[user] starts carefully cutting through the jammed clamps holding what's left of your prosthetic [surgery.affected_limb.display_name] on with \the [tool]."),
		SPAN_NOTICE("[user] starts carefully cutting through the jammed clamps holding what's left of [target]'s prosthetic [surgery.affected_limb.display_name] on with \the [tool]."))

	log_interact(user, target, "[key_name(user)] attempted to begin repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/sever_prosthetic_clamps/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cut through the last of the clamps. [target]'s prosthetic [surgery.affected_limb.display_name] can now be removed."),
		SPAN_NOTICE("[user] cuts through the last of the clamps. Your prosthetic [surgery.affected_limb.display_name] can now be removed."),
		SPAN_NOTICE("[user] cuts through the last of the clamps. [target]'s prosthetic [surgery.affected_limb.display_name] can now be removed."))

	log_interact(user, target, "[key_name(user)] successfully began repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/sever_prosthetic_clamps/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, cutting into the flesh of [target]'s [surgery.affected_limb.display_name]!"),
		SPAN_WARNING("[user]'s hand slips, cutting into the flesh of your [surgery.affected_limb.display_name]!"),
		SPAN_WARNING("[user]'s hand slips, cutting into the flesh of [target]'s [surgery.affected_limb.display_name]!"))

	target.apply_damage(20, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to begin repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_old_prosthetic
	name = "Remove Damaged Prosthetic"
	desc = "remove the damaged prosthesis"
	accept_hand = TRUE
	time = 3 SECONDS
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/remove_old_prosthetic/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin removing the remains of [target]'s damaged prosthetic [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] begins removing the remains of your damaged prosthetic [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] begins removing the remains of [target]'s prosthetic [surgery.affected_limb.display_name]."))

	log_interact(user, target, "[key_name(user)] attempted to remove the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name].")

/datum/surgery_step/remove_old_prosthetic/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have revealed the bare stump of [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] has revealed the bare stump of your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] has revealed the bare stump of [target]'s [surgery.affected_limb.display_name]."))

	surgery.affected_limb.setAmputatedTree()
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully removed the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/remove_old_prosthetic/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("You can't quite get a grip on [target]'s prosthesis."),
		SPAN_WARNING("[user] can't quite get a grip on your prosthesis."),
		SPAN_WARNING("[user] can't quite get a grip on [target]'s prosthesis."))

	log_interact(user, target, "[key_name(user)] failed to remove the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name].")
	return FALSE
