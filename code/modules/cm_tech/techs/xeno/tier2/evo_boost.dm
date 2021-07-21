/datum/tech/xeno/powerup/evo_boost
	name = "Evolution Boost"
	desc = "The hive is put on an evolution frenzy! Increases evolution rate temporarily."
	icon_state = "frenzy"

	flags = TREE_FLAG_XENO

	required_points = 10
	tier = /datum/tier/two

	var/evo_rate = 5
	var/duration = 5 MINUTES
	var/active = FALSE
	xenos_required = FALSE

/datum/tech/xeno/powerup/evo_boost/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Evolution Boost: [evo_rate]",
			"color" = "green",
			"icon" = "exchange-alt"
		),
		list(
			"content" = "Timed ([DisplayTimeText(duration, 1)])",
			"tooltip" = "Lasts for [DisplayTimeText(duration, 1)] before disabling once purchased.",
			"color" = "orange",
			"icon" = "clock"
		)
	)

/datum/tech/xeno/powerup/evo_boost/ui_data(mob/user)
	. = ..()
	.["stats_dynamic"] += list(
		list(
			"content" = active? "Active" : "Inactive",
			"color" = active? "green" : "red",
			"icon" = "lightbulb"
		)
	)

/datum/tech/xeno/powerup/evo_boost/can_unlock(mob/M, datum/techtree/tree)
	. = ..()
	if(!.)
		return
	if(active)
		to_chat(M, SPAN_WARNING("This tech is still active!"))
		return FALSE

/datum/tech/xeno/powerup/evo_boost/on_unlock(datum/techtree/tree)
	. = ..()
	addtimer(CALLBACK(src, .proc/end_boost), duration)
	active = TRUE
	hive.evolution_bonus += evo_rate


/datum/tech/xeno/powerup/evo_boost/proc/end_boost()
	active = FALSE
	hive.evolution_bonus -= evo_rate
