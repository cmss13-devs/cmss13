/datum/action/human_action/synth_bracer/crew_monitor
	name = "View Crew Monitor"
	icon_file = 'icons/obj/items/experimental_tools.dmi'
	action_icon_state = "crew_monitor"

	var/datum/radar/lifeline/radar

/datum/action/human_action/synth_bracer/crew_monitor/New()
	. = ..()
	radar = new /datum/radar/lifeline(synth_bracer, synth_bracer.faction)

/datum/action/human_action/synth_bracer/crew_monitor/Destroy()
	QDEL_NULL(radar)
	return ..()

/datum/action/human_action/synth_bracer/crew_monitor/action_activate()
	..()
	radar.tgui_interact(usr)
