/**
 * Holder datum for a zlevels data, concerning the overlays and the drawn level itself
 * The individual image trackers have a raw and a normal list
 * raw lists just store the images, while the normal ones are assoc list of [tracked_atom] = image
 * the raw lists are to speed up the Fire() of the subsystem so we don't have to filter through
 */
/datum/minimap_z_level_holder
	///Actual icon of the drawn zlevel with all of it's atoms
	var/icon/hud_image
	///Assoc list of updating images; list("[flag]" = list([source] = blip)
	var/list/blips_assoc = list()
	///Raw list containing updating images by flag; list("[flag]" = list(blip))
	var/list/blips_raw = list()
	///drawing image of the map
	var/image/drawing_image
	///x offset of the actual icon to center it to screens
	var/x_offset = 0
	///y offset of the actual icons to keep it to screens
	var/y_offset = 0
	///max x for this zlevel
	var/x_max = 1
	///max y for this zlevel
	var/y_max = 1

/datum/minimap_z_level_holder/New()
	..()
	for(var/flag in GLOB.all_minimap_flags)
		blips_assoc["[flag]"] = list()
		blips_raw["[flag]"] = list()
		blips_assoc["[flag]label"] = list()
		blips_raw["[flag]label"] = list()

/datum/minimap_z_level_holder/proc/add_blip_to_z_level(atom/movable/screen/onscreen_tacmap_blip/blip, atom/blip_target, flag)
	blips_assoc["[flag]"][blip_target] = blip
	blips_assoc["[flag]"] += blip

/datum/minimap_z_level_holder/proc/remove_blip_from_z_level(atom/movable/screen/onscreen_tacmap_blip/blip, atom/blip_target, flag)
	// delete from assoc list
	blips_assoc["[flag]"] -= blip_target
	blips_assoc["[flag]"] -= blip

/datum/minimap_z_level_holder/proc/remove_atom_from_assoc_lists(atom/the_atom, flag)
	blips_assoc["[flag]"] -= the_atom
	blips_assoc["[flag]label"] -= the_atom

/datum/minimap_z_level_holder/proc/remove_blip_from_raw_lists(atom/movable/screen/onscreen_tacmap_blip/blip, flag)
	blips_raw["[flag]"] -= blip
	blips_raw["[flag]label"] -= blip
