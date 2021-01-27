//////////////////////////////////////////////////////////////////
//				BRAIN DAMAGE FIXING								//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/brain
	var/dmg_min = 0
	var/dmg_max

/datum/surgery_step/brain/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	var/datum/internal_organ/brain/sponge = target.internal_organs_by_name["brain"]
	if(!sponge || sponge.damage <= dmg_min || affected.surgery_open_stage != 3 || target_zone != "head")
		return 0
	if(dmg_max && sponge.damage > dmg_max) return 0
	return 1



/datum/surgery_step/brain/bone_chips
	priority = 3
	allowed_tools = list(
	/obj/item/tool/surgery/hemostat = 100, 		   \
	/obj/item/tool/wirecutters = 75, 		   \
	/obj/item/tool/kitchen/utensil/fork = 20
	)

	min_duration = REMOVE_OBJECT_MIN_DURATION
	max_duration = REMOVE_OBJECT_MAX_DURATION
	dmg_max = BONECHIPS_MAX_DAMAGE //need to use the FixOVein past this point

/datum/surgery_step/brain/bone_chips/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts taking bone chips out of [target]'s brain with \the [tool]."), \
	SPAN_NOTICE("You start taking bone chips out of [target]'s brain with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started taking bone chips out of [key_name(target)]'s brain with \the [tool].")

	..()

/datum/surgery_step/brain/bone_chips/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] takes out all the bone chips in [target]'s brain with \the [tool]."),	\
	SPAN_NOTICE("You take out all the bone chips in [target]'s brain with \the [tool]."))
	log_interact(user, target, "[key_name(user)] finished taking bone chips out of [key_name(target)]'s brain with \the [tool].")

	var/datum/internal_organ/brain/sponge = target.internal_organs_by_name["brain"]
	if(sponge)
		sponge.damage = 0

/datum/surgery_step/brain/bone_chips/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, jabbing \the [tool] in [target]'s brain!"), \
	SPAN_WARNING("Your hand slips, jabbing \the [tool] in [target]'s brain!"))
	log_interact(user, target, "[key_name(user)] failed to take the bone chips out of [key_name(target)]'s brain with \the [tool].")

	target.apply_damage(30, BRUTE, "head", 1, sharp = 1)
	target.updatehealth()


/datum/surgery_step/brain/hematoma
	priority = 3
	allowed_tools = list(
	/obj/item/tool/surgery/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)

	min_duration = FIXVEIN_MIN_DURATION
	max_duration = FIXVEIN_MAX_DURATION
	dmg_min = BONECHIPS_MAX_DAMAGE //below that, you use the hemostat


/datum/surgery_step/brain/hematoma/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts mending hematoma in [target]'s brain with \the [tool]."), \
	SPAN_NOTICE("You start mending hematoma in [target]'s brain with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started mending hematoma [key_name(target)]'s brain with \the [tool].")

	..()

/datum/surgery_step/brain/hematoma/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] mends hematoma in [target]'s brain with \the [tool]."),	\
	SPAN_NOTICE("You mend hematoma in [target]'s brain with \the [tool]."))
	log_interact(user, target, "[key_name(user)] finished mending hematoma [key_name(target)]'s brain with \the [tool].")

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BRAIN)
	var/datum/internal_organ/brain/sponge = target.internal_organs_by_name["brain"]
	if(sponge)
		sponge.damage = BONECHIPS_MAX_DAMAGE
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DEAF
	target.sdisabilities &= ~MUTE

/datum/surgery_step/brain/hematoma/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, bruising [target]'s brain with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, bruising [target]'s brain with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to mend hematoma [key_name(target)]'s brain with \the [tool].")

	target.apply_damage(20, BRUTE, "head", 1, sharp = 1)
	target.updatehealth()
