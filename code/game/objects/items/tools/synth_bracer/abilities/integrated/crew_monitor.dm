/datum/action/human_action/synth_bracer/crew_monitor
	name = "View Crew Monitor"
	action_icon_state = "crew_monitor"

	var/datum/radar/lifeline/radar
	human_adaptable = TRUE

/datum/action/human_action/synth_bracer/crew_monitor/New()
	..()
	radar = new /datum/radar/lifeline(src, "UNSET")

/datum/action/human_action/synth_bracer/crew_monitor/give_to(user)
	..()
	if(!synth_bracer)
		return
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
	if(COOLDOWN_FINISHED(synth_bracer, sound_cooldown))
		COOLDOWN_START(synth_bracer, sound_cooldown, 5 SECONDS)
		playsound(synth_bracer, 'sound/machines/terminal_processing.ogg', 35, TRUE)
	radar.tgui_interact(usr)
