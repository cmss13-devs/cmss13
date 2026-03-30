
/**
 * Holder datum to ease updating of atoms to update
 */
/datum/minimap_updater
	/// Atom to update with the overlays
	var/atom/movable/minimap
	///Target zlevel we want to be updating to
	var/ztarget = 0

	/// list of blips we should give to maps that want an update
	var/list/atom/movable/screen/onscreen_tacmap_blip/blips

	/// List of images to add to the map's overlays
	var/list/image/overlays_to_add

	/// does this updater showing map drawing
	var/drawing

/datum/minimap_updater/New(minimap, ztarget, drawing)
	..()
	src.minimap = minimap
	src.ztarget = ztarget
	src.drawing = drawing
	blips = list()
	overlays_to_add = list()

/datum/minimap_updater/proc/add_blip_to_updater(atom/movable/screen/onscreen_tacmap_blip/blip)
	src.blips += blip

/datum/minimap_updater/proc/remove_blip_from_updater(atom/movable/screen/onscreen_tacmap_blip/blip)
	src.blips -= blips

/datum/minimap_updater/proc/add_image_to_updater(image/new_image)
	src.overlays_to_add += new_image

/datum/minimap_updater/proc/update_minimap()
	src.minimap.vis_contents = src.blips
	src.minimap.overlays = src.overlays_to_add
