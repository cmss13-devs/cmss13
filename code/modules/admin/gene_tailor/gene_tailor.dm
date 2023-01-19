GLOBAL_LIST_INIT(gt_evolutions, list(
	"Alien Tier 0" = list(
	list(
	name = "Larva",
	key = /mob/living/carbon/Xenomorph/Larva
	),
	),
	"Alien Tier 1" = list(
	list(
	name = XENO_CASTE_RUNNER,
	key = /mob/living/carbon/Xenomorph/Runner
	),
	list(
	name = XENO_CASTE_DRONE,
	key = /mob/living/carbon/Xenomorph/Drone
	),
	list(
	name = XENO_CASTE_SENTINEL,
	key = /mob/living/carbon/Xenomorph/Sentinel
	),
	list(
	name = XENO_CASTE_DEFENDER,
	key = /mob/living/carbon/Xenomorph/Defender
	)
	),

	"Alien Tier 2" = list(
	list(
	name = XENO_CASTE_LURKER,
	key = /mob/living/carbon/Xenomorph/Lurker
	),
	list(
	name = XENO_CASTE_WARRIOR,
	key = /mob/living/carbon/Xenomorph/Warrior
	),
	list(
	name = XENO_CASTE_SPITTER,
	key = /mob/living/carbon/Xenomorph/Spitter
	),
	list(
	name = XENO_CASTE_BURROWER,
	key = /mob/living/carbon/Xenomorph/Burrower
	),
	list(
	name = XENO_CASTE_HIVELORD,
	key = /mob/living/carbon/Xenomorph/Hivelord
	),
	list(
	name = XENO_CASTE_CARRIER,
	key = /mob/living/carbon/Xenomorph/Carrier
	)
	),

	"Alien Tier 3" = list(
	list(
	name = XENO_CASTE_RAVAGER,
	key = /mob/living/carbon/Xenomorph/Ravager
	),
	list(
	name = XENO_CASTE_PRAETORIAN,
	key = /mob/living/carbon/Xenomorph/Praetorian
	),
	list(
	name = XENO_CASTE_BOILER,
	key = /mob/living/carbon/Xenomorph/Boiler
	),
	list(
	name = XENO_CASTE_CRUSHER,
	key = /mob/living/carbon/Xenomorph/Crusher
	)
	),

	"Alien Tier 4" = list(
	list(
	name = XENO_CASTE_QUEEN+" (Young)",
	key = /mob/living/carbon/Xenomorph/Queen
	),
	list(
	name = XENO_CASTE_QUEEN+" (Mature)",
	key = /mob/living/carbon/Xenomorph/Queen/combat_ready
	),
	list(
	name = XENO_CASTE_PREDALIEN,
	key = /mob/living/carbon/Xenomorph/Predalien
	)
	)
))

/datum/gene_tailor
	/// The types of every attribute in the selected template
	var/list/stored_caste_types = list()
	var/list/stored_xeno_types = list()
	/// The baseline of the custom xeno, helps the user get a rough ideas of what the stats of a xeno are, they're not going to build it from the ground up
	var/mob/living/carbon/Xenomorph/selected_template = /mob/living/carbon/Xenomorph/Runner
	var/mob/living/carbon/Xenomorph/stat_stick

/datum/gene_tailor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneTailor", "Gene Tailor")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/gene_tailor/ui_data(mob/user)
	var/list/data = list()
	return data

/datum/gene_tailor/ui_static_data(mob/user)
	. = ..()
	.["glob_gt_evolutions"] = GLOB.gt_evolutions
	var/list/xeno_stats = list()
	var/list/caste_stats = list()
	stat_stick = new selected_template
	for(var/var_name in type2listofvars(stat_stick.parent_type))
		xeno_stats[var_name] = stat_stick.vars[var_name]
	for(var/var_name in type2listofvars(stat_stick.caste.parent_type))
		caste_stats[var_name] = stat_stick.caste.vars[var_name]

	stored_xeno_types = get_data_types(stat_stick)
	stored_caste_types = get_data_types(stat_stick.caste)

	.["xeno_stats"] = xeno_stats
	.["caste_stats"] = caste_stats
	qdel(stat_stick)

/datum/gene_tailor/ui_state(mob/user)
	return GLOB.admin_state

/datum/gene_tailor/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("set_type")
			//BOGUS
		if("spawn_mob")
			sanitize_input(params["caste_stats"], params["xeno_stats"], params["to_change_stats"])
			spawn_mob(params["caste_stats"], params["xeno_stats"])

/**
 * Returns an assoc list of target's attribute types {var_name : var_type}
 * Possible types are : "text", "number", "path", "other"
 *
 */
/datum/gene_tailor/proc/get_data_types(atom/target)
	var/list/result = list()
	for(var/var_name in type2listofvars(target.parent_type))
		var/var_value = target.vars[var_name]
		if(istext(var_value))
			result[var_name] = "text"
		else if(isnum(var_value))
			result[var_name] = "number"
		else if(ispath(var_value))
			result[var_name] = "path"
		else
			result[var_name] = "other"

	return result

/datum/gene_tailor/proc/sanitize_input(list/caste_inputs, list/xeno_inputs, list/to_change)
	for(var/var_name in caste_inputs)
		if(istext(caste_inputs[var_name]))
			caste_inputs[var_name] = sanitize(caste_inputs[var_name])
		switch(stored_caste_types[var_name])
			if("text") continue
			if("number") caste_inputs[var_name] = text2num(caste_inputs[var_name])
			if("path") caste_inputs[var_name] = text2path(caste_inputs[var_name])
			//Either a list or something instancied by the constructor, we should not touch this
			if("other") continue

	for(var/var_name in xeno_inputs)
		if(istext(xeno_inputs[var_name]))
			xeno_inputs[var_name] = sanitize(xeno_inputs[var_name])
		switch(stored_xeno_types[var_name])
			if("text") continue
			if("number") xeno_inputs[var_name] = text2num(xeno_inputs[var_name])
			if("path") xeno_inputs[var_name] = text2path(xeno_inputs[var_name])
			//Either a list or something instancied by the constructor, we should not touch this
			if("other") continue

	for(var/var_to_change in to_change)
		if(stored_caste_types[var_to_change] == "other")
			WARNING("[var_to_change] is not of a type supported by the gene tailor, changes to it will be ignored")

/datum/gene_tailor/proc/spawn_mob(list/caste_stats, list/xeno_stats)
	var/datum/caste_datum/custom/custom_caste = new
	for(var/var_name in caste_stats)
		if(stored_caste_types[var_name] != "other")
			custom_caste.vars[var_name] = caste_stats[var_name]

	var/mob/living/carbon/Xenomorph/Custom/custom_xeno = new(usr.loc, custom_caste)

	for(var/var_name in xeno_stats)
		if(stored_xeno_types[var_name] != "other")
			custom_xeno.vars[var_name] = xeno_stats[var_name]

	custom_xeno.icon = stat_stick.icon
	custom_xeno.stored_visuals["icon_source_caste"] = stat_stick.caste.caste_type
	custom_xeno.stored_visuals["pixel_x"] = stat_stick.pixel_x
	custom_xeno.stored_visuals["pixel_y"] = stat_stick.pixel_y
	custom_xeno.stored_visuals["old_x"] = stat_stick.old_x
	custom_xeno.stored_visuals["old_y"] = stat_stick.old_y
	custom_xeno.stored_visuals["base_pixel_x"] = stat_stick.base_pixel_x
	custom_xeno.stored_visuals["base_pixel_y"] = stat_stick.base_pixel_y
