/datum/hive_status_ui
	var/name = "Hive Status"

	var/list/data = list()

	var/datum/hive_status/assoc_hive = null

	// List of all open UIs and their users. These will be updated whenever the data updates
	var/list/open_uis = list()

/datum/hive_status_ui/proc/set_hive(var/datum/hive_status/hive)
	if(isnull(hive) || !istype(hive))
		return
	assoc_hive = hive

	for(var/ref in open_uis)
		var/datum/nanoui/ui = open_uis[ref]
		if(isnull(ui))
			continue
		ui.close()

	update_all_data()

// Updates the list tracking how many xenos there are in each tier, and how many there are in total
/datum/hive_status_ui/proc/update_xeno_counts()
	var/list/xeno_counts = assoc_hive.get_xeno_counts()

	var/total_xenos = 0
	for(var/counts in xeno_counts)
		for(var/caste in counts)
			total_xenos += counts[caste]
	// +1 to account for queen
	data["total_xenos"] = total_xenos

	xeno_counts[1] -= "Queen" // don't show queen in the amount of xenos
	data["xeno_counts"] = xeno_counts

	// Also update the amount of T2/T3 slots
	data["tier_slots"] = assoc_hive.get_tier_slots()

// Updates the hive location using the area name of the defined hive location turf
/datum/hive_status_ui/proc/update_hive_location()
	var/hive_location_name
	if(assoc_hive.hive_location)
		hive_location_name = strip_improper(get_area(assoc_hive.hive_location.loc))
	data["hive_location"] = hive_location_name

// Updates the sorted list of all xenos that we use as a key for all other information
/datum/hive_status_ui/proc/update_xeno_keys()
	data["xeno_keys"] = assoc_hive.get_xeno_keys()

// Mildly related to the above, but only for when xenos are removed from the hive
// If a xeno dies, we don't have to regenerate all xeno info and sort it again, just remove them from the data list
/datum/hive_status_ui/proc/xeno_removed(var/mob/living/carbon/Xenomorph/X)
	if(!data["xeno_keys"])
		return

	for(var/index = 1 to data["xeno_keys"].len)
		var/list/info = data["xeno_keys"][index]
		if(info["nicknumber"] == X.nicknumber)

			// tried Remove(), didn't work. *shrug*
			data["xeno_keys"][index] = null
			data["xeno_keys"] -= null
			return

// Updates the list of xeno names, strains and references
/datum/hive_status_ui/proc/update_xeno_info()
	data["xeno_info"] = assoc_hive.get_xeno_info()

// Updates vital information about xenos such as health and location. Only info that should be updated regularly
/datum/hive_status_ui/proc/update_xeno_vitals()
	data["xeno_vitals"] = assoc_hive.get_xeno_vitals()

// Updates how many buried larva there are
/datum/hive_status_ui/proc/update_pooled_larva()
	data["pooled_larva"] = assoc_hive.stored_larva
	data["evilution_level"] = SSxevolution.boost_power

// Updates all data except pooled larva
/datum/hive_status_ui/proc/update_all_xeno_data()
	update_xeno_counts()
	update_xeno_vitals()
	update_xeno_keys()
	update_xeno_info()

// Updates all data, including pooled larva
/datum/hive_status_ui/proc/update_all_data()
	update_all_xeno_data()
	update_pooled_larva()

/datum/hive_status_ui/proc/open_hive_status(var/mob/user)
	if(!user)
		return

	// Update absolutely all data
	if(!data.len)
		update_all_data()

	var/list/ui_data = data.Copy()
	// This needs to be passed since we're not handling the full UI interaction on the mob itself
	var/userref = "\ref[user]"
	ui_data["userref"] = userref

	var/datum/nanoui/ui = nanomanager.try_update_ui(user, user, "hive_status_ui", null, ui_data)
	if(isnull(ui))
		ui = new(user, user, "hive_status_ui", "hive_status.tmpl", "Hive Status", 550, 500)
		ui.set_initial_data(ui_data)
		ui.open()

		open_uis[userref] = ui
