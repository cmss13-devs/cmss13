/obj/structure/machinery/prop/almayer/CICmap
	name = "map table"
	desc = "A table that displays a map of the current target location"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"
	use_power = USE_POWER_IDLE
	density = TRUE
	idle_power_usage = 2
	///flags that we want to be shown when you interact with this table
	var/datum/tacmap/map
	var/minimap_type = MINIMAP_FLAG_MARINE

/obj/structure/machinery/prop/almayer/CICmap/Initialize()
	. = ..()
	map = new(src, minimap_type)

/obj/structure/machinery/prop/almayer/CICmap/Destroy()
	QDEL_NULL(map)
	return ..()

/obj/structure/machinery/prop/almayer/CICmap/attack_hand(mob/user)
	. = ..()

	map.tgui_interact(user)

/obj/structure/machinery/prop/almayer/CICmap/upp
	minimap_type = MINIMAP_FLAG_MARINE_UPP

/obj/structure/machinery/prop/almayer/CICmap/clf
	minimap_type = MINIMAP_FLAG_MARINE_CLF

/obj/structure/machinery/prop/almayer/CICmap/pmc
	minimap_type = MINIMAP_FLAG_MARINE_PMC

/datum/tacmap
	var/allowed_flags = MINIMAP_FLAG_MARINE
	///by default Zlevel 3, groundside is targeted
	var/targeted_zlevel = 3
	var/atom/owner

	var/datum/tacmap_holder/map_holder

/datum/tacmap/New(atom/source, minimap_type)
	allowed_flags = minimap_type
	owner = source

/datum/tacmap/Destroy()
	map_holder = null
	owner = null
	return ..()

/datum/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	if(!map_holder)
		map_holder = SSminimaps.fetch_tacmap_datum(targeted_zlevel, allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(map_holder.map)
		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/tacmap/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = map_holder.map_ref
	return data

/datum/tacmap/ui_status(mob/user)
	if(!(isatom(owner)))
		return UI_INTERACTIVE

	var/dist = get_dist(owner, user)
	if(dist <= 1)
		return UI_INTERACTIVE
	else if(dist <= 2)
		return UI_UPDATE
	else
		return UI_CLOSE

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map

/datum/tacmap_holder/New(loc, zlevel, flags)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags)
	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref

/datum/tacmap_holder/Destroy()
	map = null
	return ..()
