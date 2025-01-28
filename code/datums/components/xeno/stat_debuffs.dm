/datum/component/status_effect/xeno_stat_debuff
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/debuff = 0
	var/max_buildup = 30
	var/dissipation = AMOUNT_PER_TIME(2, 2 SECONDS)
	var/debuff_name = "Base Debuff"
	var/debuff_apply_message = "You are affected by a debuff!"
	var/debuff_remove_message = "The debuff has worn off!"

/datum/component/status_effect/xeno_stat_debuff/Initialize(debuff, max_buildup = 30, dissipation = AMOUNT_PER_TIME(2, 2 SECONDS))
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	ADD_TRAIT(parent, TRAIT_STAT_DEBUFF, TRAIT_STATUS_EFFECT("xeno_debuff"))
	src.debuff = debuff
	src.max_buildup = max_buildup
	src.dissipation = dissipation
	to_chat(parent, SPAN_XENODANGER("[debuff_apply_message]"))

/datum/component/status_effect/xeno_stat_debuff/InheritComponent(datum/component/status_effect/xeno_stat_debuff/debuff, i_am_original, amount, max_buildup)
	. = ..()

	src.max_buildup = max(max_buildup, src.max_buildup) //if the new component's cap is higher, use that

	if(!debuff)
		debuff += amount
	else
		debuff += debuff.debuff

	debuff = min(debuff, max_buildup)

/datum/component/status_effect/xeno_stat_debuff/process(delta_time)
	if(has_immunity)
		return ..()

	debuff = clamp(debuff - dissipation * delta_time, 0, max_buildup)

	if(debuff <= 0)
		REMOVE_TRAIT(parent, TRAIT_STAT_DEBUFF, TRAIT_STATUS_EFFECT("xeno_debuff"))
		to_chat(parent, SPAN_XENODANGER("[debuff_remove_message]"))
		undo_effects()
		qdel(src)

/datum/component/status_effect/xeno_stat_debuff/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/xeno_stat_debuff/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT)

/datum/component/status_effect/xeno_stat_debuff/proc/undo_effects()
	return

/datum/component/status_effect/xeno_stat_debuff/proc/stat_append(mob/target, list/listed)
	SIGNAL_HANDLER
	if(has_immunity)
		listed += "[debuff_name] immunity [grace_period]/[initial(grace_period)]"
		return
	listed += "[debuff_name]: [debuff] seconds"

/datum/component/status_effect/xeno_stat_debuff/cleanse()
	REMOVE_TRAIT(parent, TRAIT_STAT_DEBUFF, TRAIT_STATUS_EFFECT("xeno_debuff"))
	return ..()

/datum/component/status_effect/xeno_stat_debuff/slash_debuff
	debuff_name = "Slash debuff"
	debuff_apply_message = "You feel your claws weaken!"
	debuff_remove_message = "You feel strength return to your claws!"

/datum/component/status_effect/xeno_stat_debuff/slash_debuff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_damage()

/datum/component/status_effect/xeno_stat_debuff/slash_debuff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	if(debuff <= 0)
		xeno.damage_modifier += XENO_DAMAGE_MOD_SMALL
		xeno.recalculate_damage()

/datum/component/status_effect/xeno_stat_debuff/armor_debuff
	debuff_name = "Armor debuff"
	debuff_apply_message = "You feel your carapace soften!"
	debuff_remove_message = "You feel your carapace return to normal!"

/datum/component/status_effect/xeno_stat_debuff/armor_debuff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.armor_modifier -= XENO_ARMOR_MOD_SMALL
	xeno.recalculate_armor()

/datum/component/status_effect/xeno_stat_debuff/armor_debuff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	if(debuff <= 0)
		xeno.armor_modifier += XENO_ARMOR_MOD_SMALL
		xeno.recalculate_armor()

/datum/component/status_effect/xeno_stat_debuff/speed_debuff
	debuff_name = "Speed debuff"
	debuff_apply_message = "You feel your limbs go numb and heavy!"
	debuff_remove_message = "You feel sensation return to your limbs!"

/datum/component/status_effect/xeno_stat_debuff/speed_debuff/Initialize()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = parent

	xeno.speed_modifier += XENO_SPEED_SLOWMOD_TIER_3
	xeno.recalculate_speed()

/datum/component/status_effect/xeno_stat_debuff/speed_debuff/undo_effects()
	var/mob/living/carbon/xenomorph/xeno = parent

	if(debuff <= 0)
		xeno.speed_modifier -= XENO_SPEED_SLOWMOD_TIER_3
		xeno.recalculate_speed()
