/datum/action/human_action/synth_bracer/tactical_map
	name = "View Tactical Map"
	action_icon_state = "minimap"

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

/datum/action/human_action/synth_bracer/tactical_map/New()
	. = ..()
	tacmap = new(src, minimap_type)

/datum/action/human_action/synth_bracer/tactical_map/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/datum/action/human_action/synth_bracer/tactical_map/action_activate()
	..()

	tacmap.tgui_interact(usr)
