/datum/action/human_action/synth_bracer/tactical_map
	name = "View Tactical Map"
	action_icon_state = "resin_pit"

/datum/action/human_action/synth_bracer/tactical_map/action_activate()
	..()

	var/icon/O = overlay_tacmap(TACMAP_DEFAULT, TACMAP_BASE_OCCLUDED)
	if(O)
		synth << browse_rsc(O, "marine_minimap.png")
		show_browser(synth, "<img src=marine_minimap.png>", "Marine Minimap", "marineminimap", "size=[(map_sizes[1]*2)+50]x[(map_sizes[2]*2)+50]", closeref = synth)
