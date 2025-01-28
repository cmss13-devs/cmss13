/datum/component/status_effect/xeno_stat_buff
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/buff = 0
	var/max_buildup = 30
	var/dissipation = AMOUNT_PER_TIME(2, 2 SECONDS)
	var/buff_name = "Base buff"
	var/buff_apply_message = "You are affected by a buff!"
	var/buff_remove_message = "The buff has worn off!"

/datum/component/status_effect/xeno_stat_buff/Initialize(buff, max_buildup = 30, dissipation = AMOUNT_PER_TIME(2, 2 SECONDS))
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	ADD_TRAIT(parent, TRAIT_STAT_BUFF, TRAIT_STATUS_EFFECT("xeno_buff"))
	src.buff = buff
	src.max_buildup = max_buildup
	src.dissipation = dissipation
	to_chat(parent, SPAN_XENODANGER("[buff_apply_message]"))

/datum/component/status_effect/xeno_stat_buff/InheritComponent(datum/component/status_effect/xeno_stat_buff/buff, i_am_original, amount, max_buildup)
	. = ..()

	src.max_buildup = max(max_buildup, src.max_buildup) //if the new component's cap is higher, use that

	if(!buff)
		buff += amount
	else
		buff += buff.buff

	buff = min(buff, max_buildup)

/datum/component/status_effect/xeno_stat_buff/process(delta_time)
	if(has_immunity)
		return ..()

	buff = clamp(buff - dissipation * delta_time, 0, max_buildup)

	if(buff <= 0)
		REMOVE_TRAIT(parent, TRAIT_STAT_BUFF, TRAIT_STATUS_EFFECT("xeno_buff"))
		to_chat(parent, SPAN_XENODANGER("[buff_remove_message]"))
		undo_effects()
		qdel(src)

/datum/component/status_effect/xeno_stat_buff/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/xeno_stat_buff/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT)

/datum/component/status_effect/xeno_stat_buff/proc/undo_effects()
	return

/datum/component/status_effect/xeno_stat_buff/proc/stat_append(mob/target, list/listed)
	SIGNAL_HANDLER
	if(has_immunity)
		listed += "[buff_name] immunity [grace_period]/[initial(grace_period)]"
		return
	listed += "[buff_name]: [buff] seconds"

/datum/component/status_effect/xeno_stat_dbuff/cleanse()
	REMOVE_TRAIT(parent, TRAIT_STAT_BUFF, TRAIT_STATUS_EFFECT("xeno_buff"))
	return ..()

/datum/component/status_effect/xeno_stat_buff/slash_buff
	buff_name = "Slash buff"
	buff_apply_message = "You feel your claws flex with greater strength!"
	buff_remove_message = "You feel your claws relax to normal strength!"

/datum/component/status_effect/xeno_stat_buff/slash_buff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.damage_modifier += XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_damage()

/datum/component/status_effect/xeno_stat_buff/slash_buff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_damage()

/datum/component/status_effect/xeno_stat_buff/armor_buff
	buff_name = "Armor buff"
	buff_apply_message = "You feel your carapace harden!"
	buff_remove_message = "You feel your carapace return to normal!"

/datum/component/status_effect/xeno_stat_buff/armor_buff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.armor_modifier += XENO_ARMOR_MOD_SMALL
	xeno.recalculate_armor()

/datum/component/status_effect/xeno_stat_buff/armor_buff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.armor_modifier -= XENO_ARMOR_MOD_SMALL
	xeno.recalculate_armor()

/datum/component/status_effect/xeno_stat_buff/speed_buff
	buff_name = "Speed buff"
	buff_apply_message = "You feel a soothing feeling in your muscles, letting you move faster!"
	buff_remove_message = "You feel your muscles tense up and slow back down to normal!"

/datum/component/status_effect/xeno_stat_buff/speed_buff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	xeno.recalculate_speed()

/datum/component/status_effect/xeno_stat_buff/speed_buff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.speed_modifier -= XENO_SPEED_FASTMOD_TIER_3
	xeno.recalculate_speed()

/datum/component/status_effect/xeno_stat_buff/fireproof_buff
	buff_name = "Fireproof buff"
	buff_apply_message = "You feel your carapace grow colder!"
	buff_remove_message = "You feel your carapace warm up!"

/datum/component/status_effect/xeno_stat_buff/fireproof_buff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.add_filter("fireproof", 1, list("type" = "outline", "color" = "#a5f2f3", "size" = 1))
	if(!(xeno.caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE))
		RegisterSignal(xeno, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))

	if(xeno.caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(xeno, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(flamer_crossed_immune))

/datum/component/status_effect/xeno_stat_buff/fireproof_buff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.remove_filter("fireproof")
	if(!(xeno.caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE))
		UnregisterSignal(xeno, COMSIG_LIVING_PREIGNITION)
	if(xeno.caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(xeno, list(
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED
			))

/datum/component/status_effect/xeno_stat_buff/fireproof_buff/proc/flamer_crossed_immune(mob/living/living, datum/reagent/reagent)
	SIGNAL_HANDLER

	if(reagent.fire_penetrating)
		return

	. |= FIRE_IMMUNITY_NO_DAMAGE


/datum/component/status_effect/xeno_stat_buff/fireproof_buff/proc/fire_immune(mob/living/living)
	SIGNAL_HANDLER

	if(living.fire_reagent?.fire_penetrating && !HAS_TRAIT(living, TRAIT_ABILITY_BURROWED))
		return

	return COMPONENT_CANCEL_IGNITION
