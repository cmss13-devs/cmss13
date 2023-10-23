/datum/action/human_action/synth_bracer/crew_monitor
	name = "View Crew Monitor"
	action_icon_state = "crew_monitor"

	var/datum/radar/lifeline/radar

/datum/action/human_action/synth_bracer/crew_monitor/New()
	..()
	radar = new /datum/radar/lifeline(src, "UNSET")

/datum/action/human_action/synth_bracer/crew_monitor/give_to(user)
	..()
	radar.holder = synth_bracer
	radar.faction = synth_bracer.faction

/datum/action/human_action/synth_bracer/crew_monitor/remove_from(user)
	radar.holder = src
	radar.faction = "UNSET"
	return ..()

/datum/action/human_action/synth_bracer/crew_monitor/Destroy()
	QDEL_NULL(radar)
	return ..()

/datum/action/human_action/synth_bracer/crew_monitor/action_activate()
	..()
	radar.tgui_interact(usr)
