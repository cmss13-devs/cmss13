//Procedures in this file: Eye mending surgery
//////////////////////////////////////////////////////////////////
//						EYE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/eye
	priority = 2
	can_infect = 1
	var/eye_step

/datum/surgery_step/eye/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!affected || (affected.status & LIMB_DESTROYED))
		return 0

	if(target_zone != "eyes")
		return 0

	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	if(!E)
		return 0
	if(E.eye_surgery_stage == eye_step)
		return 1

/datum/surgery_step/eye/cut_open
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,		\
	/obj/item/tool/kitchen/knife = 75,	\
	/obj/item/shard = 50, 		\
	)

	min_duration = SCALPEL_MIN_DURATION
	max_duration = SCALPEL_MAX_DURATION
	eye_step = 0

/datum/surgery_step/eye/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts to separate the cornea on [target]'s eyes with \the [tool]."), \
	SPAN_NOTICE("You start to separate the cornea on [target]'s eyes with \the [tool]."))
	..()

/datum/surgery_step/eye/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has separated the cornea on [target]'s eyes with \the [tool].") , \
	SPAN_NOTICE("You have separated the cornea on [target]'s eyes with \the [tool]."),)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	E.eye_surgery_stage = 1
	target.disabilities |= NEARSIGHTED // code\#define\mobs.dm

/datum/surgery_step/eye/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s eyes with \the [tool]!") , \
	SPAN_WARNING("Your hand slips, slicing [target]'s eyes with \the [tool]!") )
	affected.createwound(CUT, 10)
	E.take_damage(5, 0)
	target.updatehealth()
	affected.update_wounds()


/datum/surgery_step/eye/lift_eyes
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100,          \
	/obj/item/tool/kitchen/utensil/fork = 50
	)

	min_duration = RETRACTOR_MIN_DURATION
	max_duration = RETRACTOR_MAX_DURATION
	eye_step = 1

/datum/surgery_step/eye/lift_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts lifting the cornea from [target]'s eyes with \the [tool]."), \
	SPAN_NOTICE("You start lifting the cornea from [target]'s eyes with \the [tool]."))
	..()

/datum/surgery_step/eye/lift_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has lifted the cornea from [target]'s eyes with \the [tool].") , \
	SPAN_NOTICE("You have lifted the cornea from [target]'s eyes with \the [tool].") )
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	E.eye_surgery_stage = 2

/datum/surgery_step/eye/lift_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/datum/internal_organ/eyes/eyes = target.internal_organs_by_name["eyes"]
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging [target]'s eyes with \the [tool]!"))
	target.apply_damage(10, BRUTE, affected)
	eyes.take_damage(5, 0)
	target.updatehealth()

/datum/surgery_step/eye/mend_eyes
	allowed_tools = list(
	/obj/item/tool/surgery/hemostat = 100,         \
	/obj/item/stack/cable_coil = 75,         \
	/obj/item/device/assembly/mousetrap = 10 //I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = HEMOSTAT_MIN_DURATION
	max_duration = HEMOSTAT_MAX_DURATION
	eye_step = 2

/datum/surgery_step/eye/mend_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts mending the nerves and lenses in [target]'s eyes with \the [tool]."), \
	SPAN_NOTICE("You start mending the nerves and lenses in [target]'s eyes with the [tool]."))
	..()

/datum/surgery_step/eye/mend_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] mends the nerves and lenses in [target]'s with \the [tool].") ,	\
	SPAN_NOTICE("You mend the nerves and lenses in [target]'s with \the [tool]."))
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_EYE)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	E.eye_surgery_stage = 3

/datum/surgery_step/eye/mend_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	user.visible_message(SPAN_WARNING("[user]'s hand slips, stabbing \the [tool] into [target]'s eye!"), \
	SPAN_WARNING("Your hand slips, stabbing \the [tool] into [target]'s eye!"))
	target.apply_damage(10, BRUTE, affected, sharp = 1)
	E.take_damage(5, 0)
	target.updatehealth()


/datum/surgery_step/eye/cauterize
	allowed_tools = list(
    /obj/item/tool/surgery/cautery = 100,         \
    /obj/item/clothing/mask/cigarette = 75,    \
    /obj/item/tool/lighter = 50,    \
    /obj/item/tool/weldingtool = 50
    )
	
	min_duration = CAUTERY_MIN_DURATION
	max_duration = CAUTERY_MAX_DURATION
	eye_step = 3

/datum/surgery_step/eye/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] is beginning to cauterize the incision around [target]'s eyes with \the [tool].") , \
	SPAN_NOTICE("You are beginning to cauterize the incision around [target]'s eyes with \the [tool]."))

/datum/surgery_step/eye/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] cauterizes the incision around [target]'s eyes with \the [tool]."), \
	SPAN_NOTICE("You cauterize the incision around [target]'s eyes with \the [tool]."))
	target.disabilities &= ~NEARSIGHTED
	target.sdisabilities &= ~BLIND
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	E.damage = 0
	E.eye_surgery_stage = 0


/datum/surgery_step/eye/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/datum/internal_organ/eyes/E = target.internal_organs_by_name["eyes"]
	user.visible_message(SPAN_WARNING("[user]'s hand slips, searing [target]'s eyes with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, searing [target]'s eyes with \the [tool]!"))
	target.apply_damage(5, BURN, affected)
	E.take_damage(5, 0)
	target.updatehealth()
