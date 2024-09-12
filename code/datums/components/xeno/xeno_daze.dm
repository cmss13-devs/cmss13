//snowflake used only for warcrime's effects

/datum/component/status_effect/daze
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/daze = 0
	var/max_buildup = 20
	var/dissipation = AMOUNT_PER_TIME(2, 2 SECONDS)

/datum/component/status_effect/daze/Initialize(daze, max_buildup = 30, dissipation = AMOUNT_PER_TIME(2, 2 SECONDS))
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	ADD_TRAIT(parent, TRAIT_DAZED, TRAIT_STATUS_EFFECT("daze_warcrimes"))
	src.daze = daze
	src.max_buildup = max_buildup
	src.dissipation = dissipation
	to_chat(parent, SPAN_XENOHIGHDANGER("We feel weak and dazed!"))

/datum/component/status_effect/daze/InheritComponent(datum/component/status_effect/daze/daze_new, i_am_original, amount, max_buildup)
	. = ..()

	src.max_buildup = max(max_buildup, src.max_buildup) //if the new component's cap is higher, use that

	if(!daze_new)
		daze += amount
	else
		daze += daze_new.daze

	daze = min(daze, max_buildup)

/datum/component/status_effect/daze/process(delta_time)
	if(has_immunity)
		return ..()

	daze = clamp(daze - dissipation * delta_time, 0, max_buildup)

	if(daze <= 0)
		REMOVE_TRAIT(parent, TRAIT_DAZED, TRAIT_STATUS_EFFECT("daze_warcrimes"))
		qdel(src)

/datum/component/status_effect/daze/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/daze/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT)

/datum/component/status_effect/daze/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	if(has_immunity)
		L += "Daze immunity [grace_period]/[initial(grace_period)]"
		return
	L += "Daze: [daze]/[max_buildup]"

/datum/component/status_effect/daze/cleanse()
	REMOVE_TRAIT(parent, TRAIT_DAZED, TRAIT_STATUS_EFFECT("daze_warcrimes"))
	return ..()
