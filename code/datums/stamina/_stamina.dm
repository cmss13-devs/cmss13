/datum/stamina
	var/mob/living/source_mob  = null

	var/current_stamina  = 100
	var/max_stamina  = 100

	var/stamina_slowdown = 0
	var/current_level    = STAMINA_LEVEL_1

	var/has_stamina  = TRUE
	var/stamina_rest_period = 0

	var/list/stamina_levels = list(
		STAMINA_LEVEL_1 = 100, // >100
		STAMINA_LEVEL_2 = 70, // 70 - 99
		STAMINA_LEVEL_3 = 30, // 30 - 69
		STAMINA_LEVEL_4 = 10, // 10 - 29
		STAMINA_LEVEL_5 = 0 // 0 - 9
	)

/datum/stamina/New(mob/owner)
	. = ..()

	if(istype(owner))
		source_mob = owner
		activate_stamina_debuff(current_level)
	else
		qdel(src)

/datum/stamina/proc/apply_rest_period(amount)
	stamina_rest_period = max(world.time + amount, stamina_rest_period)

/datum/stamina/proc/apply_damage(amount = 0)
	if(!has_stamina)
		return

	current_stamina = clamp(current_stamina - amount, 0, max_stamina)

	if(current_stamina < max_stamina)
		START_PROCESSING(SSobj, src)
		if(amount > 0)
			apply_rest_period(STAMINA_REST_PERIOD)
	else
		STOP_PROCESSING(SSobj, src)


	update_stamina_level()

/datum/stamina/process()
	if(stamina_rest_period < world.time)
		apply_damage(-STAMINA_INCREASE_RATE)

/datum/stamina/proc/update_stamina_level()
	if(!has_stamina)
		return

	var/current_stamina_percentage = (current_stamina/max_stamina)*100

	for(var/level in stamina_levels)
		var/to_activate_at = stamina_levels[level]

		if(current_stamina_percentage >= to_activate_at)
			if(current_level != level)
				activate_stamina_debuff(level)
				current_level = level

			break

/datum/stamina/proc/activate_stamina_debuff(tier)
	for(var/datum/effects/stamina/prev_S in source_mob.effects_list)
		qdel(prev_S)

	var/datum/effects/stamina/S = new tier(source_mob)
	stamina_slowdown = S.slowdown

/datum/stamina/Destroy()
	. = ..()

	source_mob = null
