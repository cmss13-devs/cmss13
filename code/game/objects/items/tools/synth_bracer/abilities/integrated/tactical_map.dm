/datum/action/human_action/synth_bracer/tactical_map
	name = "View Tactical Map"
	action_icon_state = "minimap"

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM
	human_adaptable = TRUE

/datum/action/human_action/synth_bracer/tactical_map/New()
	. = ..()
	tacmap = new(src, minimap_type)

/datum/action/human_action/synth_bracer/tactical_map/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/datum/action/human_action/synth_bracer/tactical_map/action_activate()
	..()
	if(COOLDOWN_FINISHED(synth_bracer, sound_cooldown))
		COOLDOWN_START(synth_bracer, sound_cooldown, 5 SECONDS)
		playsound(synth_bracer, 'sound/machines/terminal_processing.ogg', 35, TRUE)
	tacmap.tgui_interact(usr)
