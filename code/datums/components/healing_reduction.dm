#define MAX_ALPHA 35
#define GLOW_COLOR "#7a0000"
/*
This component prevents healing under a certain strength for xenos while active.
Healing above this strength will be reduced by the strength of the buildup.

Humans will take continuous damage instead.
*/

/datum/component/status_effect/healing_reduction
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/healing_reduction = 0
	var/healing_reduction_dissipation = AMOUNT_PER_TIME(1, 5 SECONDS)
	var/max_buildup = 50 //up to 50 damage off of healing max by default

/datum/component/status_effect/healing_reduction/Initialize(healing_reduction, healing_reduction_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS), max_buildup = 50)
	if(!isxeno_human(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	src.healing_reduction = healing_reduction
	src.healing_reduction_dissipation = healing_reduction_dissipation
	src.max_buildup = max_buildup

/datum/component/status_effect/healing_reduction/InheritComponent(datum/component/status_effect/healing_reduction/inherit_component, i_am_original, healing_reduction)
	. = ..()
	if(!inherit_component)
		src.healing_reduction += healing_reduction
	else
		src.healing_reduction += inherit_component.healing_reduction

	src.healing_reduction = min(src.healing_reduction, max_buildup)

/datum/component/status_effect/healing_reduction/process(delta_time)
	var/atom/parent_atom = parent
	if(has_immunity)
		parent_atom.remove_filter("healing_reduction")
		return ..()

	if(!parent)
		qdel(src)
		return

	healing_reduction = max(healing_reduction - healing_reduction_dissipation * delta_time, 0)

	if(healing_reduction <= 0)
		qdel(src)
		return

	if(ishuman(parent)) //deals brute to humans
		var/mob/living/carbon/human/human_parent = parent
		human_parent.apply_damage(healing_reduction_dissipation * delta_time, BRUTE)

	var/color = GLOW_COLOR
	var/intensity = healing_reduction/max_buildup
	color += num2text(MAX_ALPHA*intensity, 2, 16)

	parent_atom.add_filter("healing_reduction", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/status_effect/healing_reduction/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_ON_HEAL_WOUNDS
		), PROC_REF(apply_healing_reduction))
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/healing_reduction/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_ON_HEAL,
		COMSIG_XENO_ON_HEAL_WOUNDS,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/parent_atom = parent
	parent_atom.remove_filter("healing_reduction")

/datum/component/status_effect/healing_reduction/proc/stat_append(mob/target_mob, list/stat_list)
	SIGNAL_HANDLER
	if(has_immunity)
		stat_list += "Healing Reduction Immunity: [grace_period]/[initial(grace_period)]"
		return
	stat_list += "Healing Reduction: [healing_reduction]/[max_buildup]"

/datum/component/status_effect/healing_reduction/proc/apply_healing_reduction(mob/living/carbon/xenomorph/xeno, list/healing)
	SIGNAL_HANDLER
	if(has_immunity)
		return
	healing["healing"] -= healing_reduction

#undef MAX_ALPHA
#undef GLOW_COLOR
