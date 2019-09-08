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
		qdel(ui)

	update_data()

// Updates the list tracking how many xenos there are in each tier, and how many there are in total
/datum/hive_status_ui/proc/update_xeno_counts(var/update_uis=FALSE)
	var/list/xeno_counts = assoc_hive.get_xeno_counts()

	var/total_xenos = 0
	for(var/counts in xeno_counts)
		for(var/caste in counts)
			total_xenos += counts[caste]
	// +1 to account for queen
	data["total_xenos"] = total_xenos

	xeno_counts[1] -= "Queen" // don't show queen in the amount of xenos
	data["xeno_counts"] = xeno_counts

	if(update_uis)
		update_uis()

// Updates xeno info such as name, strain, 
/datum/hive_status_ui/proc/update_xeno_info(var/update_uis=FALSE)
	data["xeno_info"] = assoc_hive.get_xeno_info()

	if(update_uis)
		update_uis()

// Updates vital information about xenos such as health and location. Only info that should be updated regularly
/datum/hive_status_ui/proc/update_xeno_vitals(var/update_uis=FALSE)
	data["xeno_vitals"] = assoc_hive.get_xeno_vitals()

	if(update_uis)
		update_uis()

// Updates how many buried larva there are
/datum/hive_status_ui/proc/update_burrowed_larva(var/update_uis=FALSE)
	data["burrowed_larva"] = assoc_hive.stored_larva

	if(update_uis)
		update_uis()

/datum/hive_status_ui/proc/update_data(var/update_uis=FALSE)
	update_xeno_counts()
	update_xeno_vitals()
	update_xeno_info()
	update_burrowed_larva()

	if(update_uis)
		update_uis()

/datum/hive_status_ui/proc/update_uis()
	var/list/ui_data = data.Copy()

	for(var/ref in open_uis)
		var/datum/nanoui/ui = open_uis[ref]
		if(isnull(ui))
			continue

		ui_data["userref"] = ref
		nanomanager.try_update_ui(ui.user, ui.user, "hive_status_ui", ui, ui_data)

/datum/hive_status_ui/proc/open_hive_status(var/mob/user)
	if(!user)
		return

	if(!data.len)
		update_data()

	var/list/ui_data = data.Copy()
	// This needs to be passed since we're not handling the full UI interaction on the mob itself
	var/userref = "\ref[user]"
	ui_data["userref"] = userref

	var/datum/nanoui/ui = open_uis[userref]
	if(isnull(ui))
		ui = new(user, user, "hive_status_ui", "hive_status.tmpl", "Hive Status", 500, 500)
		ui.set_initial_data(ui_data)
		ui.open()

		open_uis[userref] = ui

		return

	nanomanager.try_update_ui(user, user, "hive_status_ui", ui, ui_data)
	ui.open()
