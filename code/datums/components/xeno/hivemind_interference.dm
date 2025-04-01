/datum/component/status_effect/interference
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/interference = 0
	var/max_buildup = 100
	var/dissipation = AMOUNT_PER_TIME(2, 2 SECONDS)

/datum/component/status_effect/interference/Initialize(interference, max_buildup = 100, dissipation = AMOUNT_PER_TIME(2, 2 SECONDS))
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	ADD_TRAIT(parent, TRAIT_HIVEMIND_INTERFERENCE, TRAIT_SOURCE_HIVEMIND_INTERFERENCE)
	src.interference = interference
	src.max_buildup = max_buildup
	src.dissipation = dissipation
	to_chat(parent, SPAN_XENOHIGHDANGER("Our awareness dims to a small area!"))

/datum/component/status_effect/interference/InheritComponent(datum/component/status_effect/interference/inter, i_am_original, amount, max_buildup)
	. = ..()

	src.max_buildup = max(max_buildup, src.max_buildup) //if the new component's cap is higher, use that

	if(!inter)
		interference += amount
	else
		interference += inter.interference

	interference = min(interference, max_buildup)

/datum/component/status_effect/interference/process(delta_time)
	if(has_immunity)
		return ..()

	interference = clamp(interference - dissipation * delta_time, 0, max_buildup)

	if(interference <= 0)
		REMOVE_TRAIT(parent, TRAIT_HIVEMIND_INTERFERENCE, TRAIT_SOURCE_HIVEMIND_INTERFERENCE)
		qdel(src)

/datum/component/status_effect/interference/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/interference/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT)

/datum/component/status_effect/interference/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	if(has_immunity)
		L += "Hivemind Interference immunity [grace_period]/[initial(grace_period)]"
		return
	L += "Hivemind Interference: [interference]/[max_buildup]"

/datum/component/status_effect/interference/cleanse()
	REMOVE_TRAIT(parent, TRAIT_HIVEMIND_INTERFERENCE, TRAIT_SOURCE_HIVEMIND_INTERFERENCE)
	return ..()
