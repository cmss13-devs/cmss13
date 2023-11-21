#define MAX_ALPHA 35
#define GLOW_COLOR "#7a0000"
/*
This component prevents healing under a certain strength for xenos while active.
Healing above this strength will be reduced by the strength of the buildup.

Humans will take continuous damage instead.
*/

/datum/component/healing_reduction
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/healing_reduction = 0
	var/healing_reduction_dissipation = AMOUNT_PER_TIME(1, 5 SECONDS)
	var/max_buildup = 50 //up to 50 damage off of healing max by default

/datum/component/healing_reduction/Initialize(healing_reduction, healing_reduction_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS), max_buildup = 50)
	if(!isxeno_human(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	src.healing_reduction = healing_reduction
	src.healing_reduction_dissipation = healing_reduction_dissipation
	src.max_buildup = max_buildup

/datum/component/healing_reduction/InheritComponent(datum/component/healing_reduction/C, i_am_original, healing_reduction)
	. = ..()
	if(!C)
		src.healing_reduction += healing_reduction
	else
		src.healing_reduction += C.healing_reduction

	src.healing_reduction = min(src.healing_reduction, max_buildup)

/datum/component/healing_reduction/process(delta_time)
	if(!parent)
		qdel(src)
	healing_reduction = max(healing_reduction - healing_reduction_dissipation * delta_time, 0)

	if(ishuman(parent)) //deals brute to humans
		var/mob/living/carbon/human/H = parent
		H.apply_damage(healing_reduction_dissipation * delta_time, BRUTE)

	if(healing_reduction <= 0)
		qdel(src)

	var/color = GLOW_COLOR
	var/intensity = healing_reduction/max_buildup
	color += num2text(MAX_ALPHA*intensity, 2, 16)

	var/atom/A = parent
	A.add_filter("healing_reduction", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/healing_reduction/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_ON_HEAL_WOUNDS
		), PROC_REF(apply_healing_reduction))
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/healing_reduction/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_ON_HEAL_WOUNDS,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("healing_reduction")

/datum/component/healing_reduction/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	L += "Healing Reduction: [healing_reduction]/[max_buildup]"

/datum/component/healing_reduction/proc/apply_healing_reduction(mob/living/carbon/xenomorph/X, list/healing)
	SIGNAL_HANDLER
	healing["healing"] -= healing_reduction

#undef MAX_ALPHA
#undef GLOW_COLOR
