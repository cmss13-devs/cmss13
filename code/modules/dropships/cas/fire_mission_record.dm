/// Defines firing patterns in Fire Missions, transverse to its firing direction
/datum/cas_fire_mission_record
	/// Weapon relevant to this fire mission record
	var/obj/structure/dropship_equipment/weapon/weapon
	/// List of transverse offsets for each firing step - null meaning not shooting
	var/list/offsets

/datum/cas_fire_mission_record/ui_data(mob/user)
	. = list()
	.["weapon"] = weapon.ship_base.attach_id
	.["offsets"] = offsets

/// Get offset range allowed when firing weapon in this configuration
/datum/cas_fire_mission_record/proc/get_offsets()
	if(!weapon?.ship_base)
		return null
	// Currently doesn't take weapon into account yet
	var/obj/effect/attach_point/weapon/AW = weapon.ship_base
	if(istype(AW))
		return AW.get_offsets()
	return null


/// Get current ammo status for a weapon
/datum/cas_fire_mission_record/proc/get_ammo()
	if(!weapon || !weapon.ship_base || !offsets)
		return list("count" = 0, "used" = 0, "max" = 0)
	if(!weapon.ammo_equipped)
		return list("count" = 0, "used" = 0, "max" = 0)
	var/ammocount = weapon.ammo_equipped.ammo_count
	var/used = 0
	var/max_ammo = 0
	if(weapon.ammo_equipped)
		for(var/step = 1; step<=length(offsets); step++)
			if(offsets[step]!=null && offsets[step]!="-")
				used += weapon.ammo_equipped.ammo_used_per_firing
		max_ammo = weapon.ammo_equipped.max_ammo_count
	return list("count" = ammocount, "used" = used, "max" = max_ammo)
