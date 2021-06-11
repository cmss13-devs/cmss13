/datum/component/slow_buildup
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/slow_buildup = 0
	var/slow_buildup_dissipation = AMOUNT_PER_TIME(1, 2 SECONDS)
	var/max_buildup = 10
	var/human_stamina_multiplier = 2.5

	var/max_alpha = 35
	var/glow_color = "#00c3ff"

/datum/component/slow_buildup/Initialize(var/slow_buildup, var/slow_buildup_dissipation = AMOUNT_PER_TIME(1, 2 SECONDS), var/max_buildup = 10, var/human_stamina_multiplier = 2.5)
	. = ..()
	src.slow_buildup = slow_buildup
	src.slow_buildup_dissipation = slow_buildup_dissipation
	src.max_buildup = max_buildup
	src.human_stamina_multiplier = human_stamina_multiplier

/datum/component/slow_buildup/InheritComponent(datum/component/slow_buildup/C, i_am_original, var/slow_buildup)
	. = ..()
	if(!C)
		src.slow_buildup += slow_buildup
	else
		src.slow_buildup += C.slow_buildup

	src.slow_buildup = min(src.slow_buildup, max_buildup)

/datum/component/slow_buildup/process(delta_time)
	slow_buildup = max(slow_buildup - slow_buildup_dissipation * delta_time, 0)

	if(ishuman(parent)) //Damages stamina for humans
		var/mob/living/carbon/human/H = parent
		H.apply_stamina_damage(human_stamina_multiplier * slow_buildup_dissipation * delta_time)

	if(slow_buildup <= 0)
		qdel(src)

	var/color = glow_color
	var/intensity = slow_buildup/max_buildup
	color += num2text(max_alpha*intensity, 2, 16)

	if(parent)
		var/atom/A = parent
		A.add_filter("slow_buildup", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/slow_buildup/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	STOP_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(
		COMSIG_XENO_MOVEMENT_DELAY,
		COMSIG_XENO_APPEND_TO_STAT
	))

/datum/component/slow_buildup/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_MOVEMENT_DELAY,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("slow_buildup")

/datum/component/slow_buildup/proc/stat_append(var/mob/M, var/list/L)
	SIGNAL_HANDLER
	L += "Slow: [slow_buildup]/[max_buildup]"

/datum/component/slow_buildup/proc/apply_slow_buildup(var/mob/living/carbon/Xenomorph/X, var/list/speeds)
	SIGNAL_HANDLER
	speeds["speed"] += slow_buildup * 0.075
