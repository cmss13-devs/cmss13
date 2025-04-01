#define MAX_ALPHA 35
#define GLOW_COLOR "#7a0000"

//Adjusts the speed of a xenomorph the component is on. Humans will take or heal stamina damage.

/datum/component/status_effect/speed_modifier
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/speed_modifier = 0
	var/speed_modifier_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS)
	var/max_buildup = 10
	var/increase_speed = FALSE

/datum/component/status_effect/speed_modifier/Initialize(speed_modifier, increase_speed = FALSE, speed_modifier_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS), max_buildup = 10)
	if(!isxeno_human(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	src.speed_modifier = speed_modifier
	src.speed_modifier_dissipation = speed_modifier_dissipation
	src.max_buildup = max_buildup
	src.increase_speed = increase_speed

/datum/component/status_effect/speed_modifier/InheritComponent(datum/component/status_effect/speed_modifier/C, i_am_original, speed_modifier)
	. = ..()
	if(!C)
		src.speed_modifier += speed_modifier
	else
		src.speed_modifier += C.speed_modifier

	src.speed_modifier = min(src.speed_modifier, max_buildup)

/datum/component/status_effect/speed_modifier/process(delta_time)
	var/atom/parent_atom = parent
	if(has_immunity)
		parent_atom.remove_filter("speed_modifier")
		return ..()

	if(!parent)
		qdel(src)
	speed_modifier = max(speed_modifier - speed_modifier_dissipation * delta_time, 0)

	if(ishuman(parent)) //Damages/heals stamina for humans
		var/mob/living/carbon/human/H = parent
		if(!increase_speed)
			H.apply_stamina_damage(HUMAN_STAMINA_MULTIPLIER * speed_modifier_dissipation * delta_time)
		else
			H.apply_stamina_damage(-HUMAN_STAMINA_MULTIPLIER * speed_modifier_dissipation * delta_time)

	if(speed_modifier <= 0)
		qdel(src)

	var/color = GLOW_COLOR
	var/intensity = speed_modifier/max_buildup
	color += num2text(MAX_ALPHA*intensity, 2, 16)

	parent_atom.add_filter("speed_modifier", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/status_effect/speed_modifier/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_MOVEMENT_DELAY, PROC_REF(apply_speed_modifier))
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/status_effect/speed_modifier/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_MOVEMENT_DELAY,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("speed_modifier")

/datum/component/status_effect/speed_modifier/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	if(has_immunity)
		L += "Slow immunity: [grace_period]/[initial(grace_period)]"
		return
	if(!increase_speed)
		L += "Slow: [speed_modifier]/[max_buildup]"
	else
		L += "Speed Boost: [speed_modifier]/[max_buildup]"

/datum/component/status_effect/speed_modifier/proc/apply_speed_modifier(mob/living/carbon/xenomorph/X, list/speeds)
	SIGNAL_HANDLER
	if(has_immunity)
		return
	if(!increase_speed)
		speeds["speed"] += speed_modifier * 0.075
	else //increasing speed is more effective than decreasing speed
		speeds["speed"] -= speed_modifier * 0.1

#undef MAX_ALPHA
#undef GLOW_COLOR
