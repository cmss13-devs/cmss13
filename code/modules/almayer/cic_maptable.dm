/obj/structure/machinery/cic_maptable
	name = "map table"
	desc = "A table that displays a map of the current target location"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"
	use_power = USE_POWER_IDLE
	density = TRUE
	idle_power_usage = 2
	///flags that we want to be shown when you interact with this table
	var/datum/tacmap/map

/obj/structure/machinery/cic_maptable/Initialize()
	. = ..()
	map = new
	map.owner = src

/obj/structure/machinery/cic_maptable/Destroy()
	QDEL_NULL(map)
	return ..()

/obj/structure/machinery/cic_maptable/attack_hand(mob/user)
	. = ..()

	map.tgui_interact(user)

/datum/tacmap
	var/allowed_flags = MINIMAP_FLAG_MARINE
	///by default Zlevel 3, groundside is targeted
	var/targeted_zlevel = 3
	///minimap obj ref that we will display to users
	var/atom/movable/screen/minimap/map
	var/map_ref
	var/atom/owner

/datum/tacmap/New()
	. = ..()
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(targeted_zlevel, allowed_flags)
	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref

/datum/tacmap/Destroy()
	map = null
	owner = null
	return ..()

/datum/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(map)
		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/tacmap/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = map_ref
	return data

/datum/tacmap/ui_status(mob/user)
	var/dist = get_dist(owner, user)
	// Open and interact if 1-0 tiles away.
	if(dist <= 1)
		return UI_INTERACTIVE
	// View only if 2-3 tiles away.
	else if(dist <= 2)
		return UI_UPDATE
	// Disable if 5 tiles away.
	else if(dist <= 5)
		return UI_DISABLED
	// Otherwise, we got nothing.
	return UI_CLOSE
