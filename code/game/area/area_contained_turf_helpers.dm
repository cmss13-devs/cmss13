/area
	/// List of all turfs currently inside this area as nested lists indexed by zlevel.
	/// Acts as a filtered version of area.contents For faster lookup
	/// (area.contents is actually a filtered loop over world)
	/// Semi fragile, but it prevents stupid so I think it's worth it
	var/list/list/turf/turfs_by_zlevel = list()
	/// turfs_by_z_level can hold MASSIVE lists, so rather then adding/removing from it each time we have a problem turf
	/// We should instead store a list of turfs to REMOVE from it, then hook into a getter for it
	/// There is a risk of this and contained_turfs leaking, so a subsystem will run it down to 0 incrementally if it gets too large
	/// This uses the same nested list format as turfs_by_zlevel
	var/list/list/turf/turfs_to_uncontain_by_zlevel = list()

/// Returns the highest zlevel that this area contains turfs for
/area/proc/get_highest_zlevel()
	for (var/area_zlevel in length(turfs_by_zlevel) to 1 step -1)
		if (length(turfs_to_uncontain_by_zlevel) >= area_zlevel)
			if (length(turfs_by_zlevel[area_zlevel]) - length(turfs_to_uncontain_by_zlevel[area_zlevel]) > 0)
				return area_zlevel
		else
			if (length(turfs_by_zlevel[area_zlevel]))
				return area_zlevel
	return 0

/// Returns a nested list of lists with all turfs split by zlevel.
/// only zlevels with turfs are returned. The order of the list is not guaranteed.
/area/proc/get_zlevel_turf_lists()
	if(length(turfs_to_uncontain_by_zlevel))
		canonize_contained_turfs()

	var/list/zlevel_turf_lists = list()

	for (var/list/zlevel_turfs as anything in turfs_by_zlevel)
		if (length(zlevel_turfs))
			zlevel_turf_lists += list(zlevel_turfs)

	return zlevel_turf_lists

/// Returns a list with all turfs in this zlevel.
/area/proc/get_turfs_by_zlevel(zlevel)
	if (length(turfs_to_uncontain_by_zlevel) >= zlevel && length(turfs_to_uncontain_by_zlevel[zlevel]))
		canonize_contained_turfs_by_zlevel(zlevel)

	if (length(turfs_by_zlevel) < zlevel)
		return list()

	return turfs_by_zlevel[zlevel]

/// Merges a list containing all of the turfs zlevel lists from get_zlevel_turf_lists inside one list. Use get_zlevel_turf_lists() or get_turfs_by_zlevel() unless you need all the turfs in one list to avoid generating large lists
/area/proc/get_turfs_from_all_zlevels()
	. = list()
	for (var/list/zlevel_turfs as anything in get_zlevel_turf_lists())
		. += zlevel_turfs

/// Ensures that the contained_turfs list properly represents the turfs actually inside us
/area/proc/canonize_contained_turfs_by_zlevel(zlevel_to_clean, _autoclean = TRUE)
	// This is massively suboptimal for LARGE removal lists
	// Try and keep the mass removal as low as you can. We'll do this by ensuring
	// We only actually add to contained turfs after large changes (Also the management subsystem)
	// Do your damndest to keep turfs out of /area/space as a stepping stone
	// That sucker gets HUGE and will make this take actual seconds
	if (zlevel_to_clean <= length(turfs_by_zlevel) && zlevel_to_clean <= length(turfs_to_uncontain_by_zlevel))
		turfs_by_zlevel[zlevel_to_clean] -= turfs_to_uncontain_by_zlevel[zlevel_to_clean]

	if (!_autoclean) // Removes empty lists from the end of this list
		turfs_to_uncontain_by_zlevel[zlevel_to_clean] = list()
		return

	var/new_length = length(turfs_to_uncontain_by_zlevel)
	// Walk backwards thru the list
	for (var/i in length(turfs_to_uncontain_by_zlevel) to 0 step -1)
		if (i && length(turfs_to_uncontain_by_zlevel[i]))
			break // Stop the moment we find a useful list
		new_length = i

	if (new_length < length(turfs_to_uncontain_by_zlevel))
		turfs_to_uncontain_by_zlevel.len = new_length

	if (new_length >= zlevel_to_clean)
		turfs_to_uncontain_by_zlevel[zlevel_to_clean] = list()

/// Ensures that the contained_turfs list properly represents the turfs actually inside us
/area/proc/canonize_contained_turfs()
	for (var/area_zlevel in 1 to length(turfs_to_uncontain_by_zlevel))
		canonize_contained_turfs_by_zlevel(area_zlevel, _autoclean = FALSE)

	turfs_to_uncontain_by_zlevel = list()

/// Returns TRUE if we have contained turfs, FALSE otherwise
/area/proc/has_contained_turfs()
	for (var/area_zlevel in 1 to length(turfs_by_zlevel))
		if (length(turfs_to_uncontain_by_zlevel) >= area_zlevel)
			if (length(turfs_by_zlevel[area_zlevel]) - length(turfs_to_uncontain_by_zlevel[area_zlevel]) > 0)
				return TRUE
		else
			if (length(turfs_by_zlevel[area_zlevel]))
				return TRUE
	return FALSE
