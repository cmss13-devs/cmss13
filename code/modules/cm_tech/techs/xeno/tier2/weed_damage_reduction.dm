/datum/tech/xeno/weed_damage_reduction
	name = "Fortifying Weeds"
	desc = "Actively causes weeds to reduce the damage taken by Xenomorphs by providing a light layer of armour, reducing all incoming damage by 35% as long as a xenomorph is on weeds."
	icon_state = "weed_reinforcement"

	flags = TREE_FLAG_XENO

	required_points = 15
	tier = /datum/tier/two

	var/damage_mult = 0.65
	var/enabled = FALSE

	/// Amount to lose per second
	var/point_drain_per_second = AMOUNT_PER_TIME(1, 1 MINUTES) // Drains 1 resource per minute.

	var/next_toggle = 0
	var/toggle_cooldown = 5 MINUTES


/datum/tech/xeno/weed_damage_reduction/on_unlock()
	. = ..()
	enable()

/datum/tech/xeno/weed_damage_reduction/proc/disable()
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)

	for(var/m in hive.totalXenos)
		var/mob/M = m
		M.RemoveElement(/datum/element/weed_damage_mult, hivenumber, damage_mult)

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

/datum/tech/xeno/weed_damage_reduction/proc/register_component(datum/source, var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	if(X.hivenumber == hivenumber)
		X.AddElement(/datum/element/weed_damage_mult, hivenumber, damage_mult)

/datum/tech/xeno/weed_damage_reduction/ui_data(mob/user)
	. = ..()
	if(!unlocked)
		return

	.["extra_buttons"] += list(
		list(
			"name" = enabled? "Enabled" : "Disabled",
			"enabled" = enabled,
			"action" = "toggle_enable"
		)
	)

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
					to_chat(usr, SPAN_WARNING("You can't enable this ability for the next [time2text(next_toggle - world.time, "mm:ss")] minutes!"))
					return

				enable()

			next_toggle = world.time + toggle_cooldown
			. = TRUE
