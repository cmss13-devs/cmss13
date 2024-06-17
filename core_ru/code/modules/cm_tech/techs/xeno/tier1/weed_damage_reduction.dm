/datum/tech/xeno/weed_damage_reduction
	name = "Fortifying Weeds"
	desc = "Actively causes weeds to reduce the damage taken by Xenomorphs by providing a layer of armour as long as a xenomorph is on weeds."
	icon_state = "weed_reinforcement"

	flags = TREE_FLAG_XENO

	required_points = 15
	tier = /datum/tier/one

	var/max_damage_mult = 0.95
	var/min_damage_mult = 0.5

	var/damage_mult = 0.75
	var/enabled = FALSE

	/// Amount to lose per second
	var/point_drain_per_second = AMOUNT_PER_TIME(0.5, 1 MINUTES) // Drains 1 resource per 2 minute.
	/// How much the drain scales up by depending on damage_mult var
	var/point_drain_scale = 3.5

	var/next_toggle = 0
	var/toggle_cooldown = 5 MINUTES

/datum/tech/xeno/weed_damage_reduction/New()
	. = ..()
	recalculate_point_drain()

/datum/tech/xeno/weed_damage_reduction/proc/recalculate_point_drain()
	var/damage_scale_amount = (1-(damage_mult-min_damage_mult)/(max_damage_mult-min_damage_mult)) * point_drain_scale
	point_drain_per_second = initial(point_drain_per_second) * max(damage_scale_amount, 0)

/datum/tech/xeno/weed_damage_reduction/ui_data(mob/user)
	. = ..()
	.["stats_dynamic"] += list(
		list(
			"content" = "Damage Reduction: [(1-damage_mult)*100]%",
			"color" = "red",
			"icon" = "bomb"
		),
	)

	if(point_drain_per_second)
		.["stats_dynamic"] += list(list(
			"content" = "Lose [round(point_drain_per_second*60, 0.1)] point\s per minute.",
			"color" = "orange",
			"icon" = "coins"
		))

	if(!unlocked)
		return

	.["extra_sliders"] += list(
		list(
			"value" = (1-damage_mult)*100,
			"unit" = "% Damage Reduction",
			"step" = 1,
			"minValue" = (1-max_damage_mult)*100,
			"maxValue" = (1-min_damage_mult)*100,
			"action" = "set_damage_mult"
		)
	)

	.["extra_buttons"] += list(
		list(
			"name" = enabled? "Enabled" : "Disabled",
			"enabled" = enabled,
			"action" = "toggle_enable"
		)
	)

/datum/tech/xeno/weed_damage_reduction/proc/disable()
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)

	for(var/m in hive.totalXenos)
		var/mob/M = m
		qdel(M.GetComponent(/datum/component/weed_damage_mult))

	STOP_PROCESSING(SSprocessing, src)

	enabled = FALSE

/datum/tech/xeno/weed_damage_reduction/proc/enable()
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/register_component)

	for(var/m in hive.totalXenos)
		register_component(src, m)

	START_PROCESSING(SSprocessing, src)

	enabled = TRUE

/datum/tech/xeno/weed_damage_reduction/process(delta_time)
	if(!holder.check_and_use_points(point_drain_per_second*delta_time))
		disable()

/datum/tech/xeno/weed_damage_reduction/proc/register_component(datum/source, mob/living/carbon/xenomorph/X)
	SIGNAL_HANDLER
	if(X.hivenumber == hivenumber)
		X.AddComponent(/datum/component/weed_damage_mult, hivenumber, damage_mult)

/datum/tech/xeno/weed_damage_reduction/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_enable")
			if(params["enabled"] != enabled)
				return

			if(!holder.can_use_points(point_drain_per_second))
				return

			if(params["enabled"])
				disable()
			else
				if(next_toggle > world.time)
					to_chat(usr, SPAN_WARNING("You can't enable this ability for the next [DisplayTimeText(next_toggle - world.time, 1)]!"))
					return

				enable()

			next_toggle = world.time + toggle_cooldown
			. = TRUE

		if("set_damage_mult")
			if(enabled)
				to_chat(usr, SPAN_WARNING("You can't modify the damage reduction whilst the tech is active!"))
				return
			var/multiplier = text2num(params["value"])

			if(!multiplier)
				return

			multiplier = min(max_damage_mult, max(1-(multiplier/100), min_damage_mult))

			damage_mult = multiplier

			recalculate_point_drain()
			. = TRUE
