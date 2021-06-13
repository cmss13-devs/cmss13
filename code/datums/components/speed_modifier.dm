//Adjusts the speed of a xenomorph the component is on. Humans will take or heal stamina damage.

/datum/component/speed_modifier
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/speed_modifier = 0
	var/speed_modifier_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS)
	var/max_buildup = 10
	var/increase_speed = FALSE
	var/human_stamina_multiplier = 5

	var/max_alpha = 35
	var/glow_color = "#00c3ff"

/datum/component/speed_modifier/Initialize(var/speed_modifier, var/increase_speed = FALSE, var/speed_modifier_dissipation = AMOUNT_PER_TIME(1, 2.5 SECONDS), var/max_buildup = 10, var/human_stamina_multiplier = 5)
	. = ..()
	src.speed_modifier = speed_modifier
	src.speed_modifier_dissipation = speed_modifier_dissipation
	src.max_buildup = max_buildup
	src.human_stamina_multiplier = human_stamina_multiplier
	src.increase_speed = increase_speed

/datum/component/speed_modifier/InheritComponent(datum/component/speed_modifier/C, i_am_original, var/speed_modifier)
	. = ..()
	if(!C)
		src.speed_modifier += speed_modifier
	else
		src.speed_modifier += C.speed_modifier

	src.speed_modifier = min(src.speed_modifier, max_buildup)

/datum/component/speed_modifier/process(delta_time)
	speed_modifier = max(speed_modifier - speed_modifier_dissipation * delta_time, 0)

	if(ishuman(parent)) //Damages/heals stamina for humans
		var/mob/living/carbon/human/H = parent
		if(!increase_speed)
			H.apply_stamina_damage(human_stamina_multiplier * speed_modifier_dissipation * delta_time)
		else
			H.apply_stamina_damage(-human_stamina_multiplier * speed_modifier_dissipation * delta_time)

	if(speed_modifier <= 0)
		qdel(src)

	var/color = glow_color
	var/intensity = speed_modifier/max_buildup
	color += num2text(max_alpha*intensity, 2, 16)

	if(parent)
		var/atom/A = parent
		A.add_filter("speed_modifier", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/speed_modifier/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	STOP_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_MOVEMENT_DELAY, .proc/apply_speed_modifier)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, .proc/stat_append)

/datum/component/speed_modifier/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_MOVEMENT_DELAY,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("speed_modifier")

/datum/component/speed_modifier/proc/stat_append(var/mob/M, var/list/L)
	SIGNAL_HANDLER
	if(!increase_speed)
		L += "Slow: [speed_modifier]/[max_buildup]"
	else
		L += "Speed Boost: [speed_modifier]/[max_buildup]"

/datum/component/speed_modifier/proc/apply_speed_modifier(var/mob/living/carbon/Xenomorph/X, var/list/speeds)
	SIGNAL_HANDLER
	if(!increase_speed)
		speeds["speed"] += speed_modifier * 0.075
	else //increasing speed is more effective than decreasing speed
		speeds["speed"] -= speed_modifier * 0.1
