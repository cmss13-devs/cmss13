/*
Injury buildup prevents healing under a certain strength for xenos while active.
Healing above this strength will be reduced by the strength of the buildup.

Humans will take continuous damage instead.
*/

/datum/component/injury_buildup
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/injury_buildup = 0
	var/injury_buildup_dissipation = AMOUNT_PER_TIME(1, 2 SECONDS)
	var/max_buildup = 25 //up to 25 damage off of healing max by default

	var/max_alpha = 35
	var/glow_color = "#7a0000"

/datum/component/injury_buildup/Initialize(var/injury_buildup, var/injury_buildup_dissipation = AMOUNT_PER_TIME(1, 2 SECONDS), var/max_buildup = 25)
	. = ..()
	src.injury_buildup = injury_buildup
	src.injury_buildup_dissipation = injury_buildup_dissipation
	src.max_buildup = max_buildup

/datum/component/injury_buildup/InheritComponent(datum/component/injury_buildup/C, i_am_original, var/injury_buildup)
	. = ..()
	if(!C)
		src.injury_buildup += injury_buildup
	else
		src.injury_buildup += C.injury_buildup

	src.injury_buildup = min(src.injury_buildup, max_buildup)

/datum/component/injury_buildup/process(delta_time)
	injury_buildup = max(injury_buildup - injury_buildup_dissipation * delta_time, 0)

	if(ishuman(parent)) //winds humans
		var/mob/living/carbon/human/H = parent
		H.apply_damage(injury_buildup_dissipation * delta_time, BRUTE)

	if(injury_buildup <= 0)
		qdel(src)

	var/color = glow_color
	var/intensity = injury_buildup/max_buildup
	color += num2text(max_alpha*intensity, 2, 16)

	if(parent)
		var/atom/A = parent
		A.add_filter("injury_buildup", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/injury_buildup/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_APPEND_TO_STAT
	))

/datum/component/injury_buildup/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("injury_buildup")

/datum/component/injury_buildup/proc/stat_append(var/mob/M, var/list/L)
	SIGNAL_HANDLER
	L += "Healing Reduction: [injury_buildup]/[max_buildup]"

/datum/component/injury_buildup/proc/apply_injury_buildup(var/mob/living/carbon/Xenomorph/X, var/list/healing)
	SIGNAL_HANDLER
	healing["healing"] -= injury_buildup
	if(healing["healing"] < 0)
		healing["healing"] = 0
