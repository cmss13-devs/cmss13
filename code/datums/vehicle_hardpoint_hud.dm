/**
 * Global visibility gate for the vehicle hardpoint status HUD. Mirrors /datum/mob_hud, just
 * re-targeted at vehicles instead of mobs. Only one kind exists, so a single global instance is enough.
 */
/datum/vehicle_hardpoint_hud
	/// Every vehicle currenttly enrolled.
	var/list/obj/vehicle/multitile/hudvehicles = list()
	/// Viewer mob to list of sources currently granting them this HUD. Only removing the last one revokes it.
	var/list/mob/hudusers = list()

/// Allow user to see every enrolled vehicle's hardpoint HUD (e.g. flipping down a compatible helmet visor).
/datum/vehicle_hardpoint_hud/proc/add_hud_to(mob/user, source)
	if(!user)
		return
	if(LAZYLEN(hudusers[user]))
		hudusers[user] |= list(source)
	else
		hudusers[user] = list(source)
	for(var/obj/vehicle/multitile/vehicle as anything in hudvehicles)
		add_to_single_hud(user, vehicle)

/// Stop showing every enrolled vehicle's hardpoint HUD to user, once EVERY granting source has been removed.
/datum/vehicle_hardpoint_hud/proc/remove_hud_from(mob/user, source)
	if(!user || !LAZYLEN(hudusers[user]))
		return
	hudusers[user] -= source
	if(LAZYLEN(hudusers[user]))
		return
	for(var/obj/vehicle/multitile/vehicle as anything in hudvehicles)
		remove_from_single_hud(user, vehicle)
	hudusers -= user

/// "Enroll" a freshly-created vehicle. Every current viewer immediately sees its hardpoint images.
/datum/vehicle_hardpoint_hud/proc/add_to_hud(obj/vehicle/multitile/vehicle)
	hudvehicles |= vehicle
	for(var/mob/user as anything in hudusers)
		add_to_single_hud(user, vehicle)

/// "Unenroll" a vehicle that's about to be deleted.
/datum/vehicle_hardpoint_hud/proc/remove_from_hud(obj/vehicle/multitile/vehicle)
	for(var/mob/user as anything in hudusers)
		remove_from_single_hud(user, vehicle)
	hudvehicles -= vehicle

/datum/vehicle_hardpoint_hud/proc/add_to_single_hud(mob/user, obj/vehicle/multitile/vehicle)
	if(!user.client)
		return
	for(var/slot in vehicle.hardpoint_hud_images)
		user.client.images |= vehicle.hardpoint_hud_images[slot]

/datum/vehicle_hardpoint_hud/proc/remove_from_single_hud(mob/user, obj/vehicle/multitile/vehicle)
	if(!user.client)
		return
	for(var/slot in vehicle.hardpoint_hud_images)
		user.client.images -= vehicle.hardpoint_hud_images[slot]

/**
 * Keeps every current viewer's client.images in sync the instant one specific slot's image is
 * added, replaced, or removed on a vehicle.
 *
 * Arguments:
 * * old_image = The image to revoke from every current viewer, or null if this slot didn't exist before.
 * * new_image = The image to grant to every current viewer, or null if this slot no longer exists.
 */
/datum/vehicle_hardpoint_hud/proc/sync_single_image(obj/vehicle/multitile/vehicle, image/old_image, image/new_image)
	for(var/mob/user as anything in hudusers)
		if(!user.client)
			continue
		if(old_image)
			user.client.images -= old_image
		if(new_image)
			user.client.images |= new_image

GLOBAL_DATUM_INIT(vehicle_hardpoint_hud, /datum/vehicle_hardpoint_hud, new)
