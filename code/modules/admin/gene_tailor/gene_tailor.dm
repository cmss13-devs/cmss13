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
	/// The types of every attribute of the caste in the selected template
	var/list/stored_caste_types = list()
	/// The types of every attribute of the xeno in the selected template
	var/list/stored_xeno_types = list()
	/// Compile-time values of the attribute of the xeno in the selected template
	var/list/xeno_stats = list()
	/// Compile-time values of the attribute of the xeno in the selected template
	var/list/caste_stats = list()
	/// The baseline of the custom xeno, helps the user get a rough ideas of what the stats of a xeno are, they're not going to build it from the ground up
	var/selected_template
	var/mob/living/carbon/Xenomorph/stat_stick
	///The passives picked
	var/list/xeno_delegates = list()
	///The abilities picked
	var/list/xeno_abilities = list()

/datum/gene_tailor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneTailor", "Gene Tailor")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/gene_tailor/ui_data(mob/user)
	var/list/data = list()
	data["selected_template"] = selected_template
	data["xeno_abilities"] = xeno_abilities
	data["xeno_passives"] = xeno_delegates
	return data

/datum/gene_tailor/ui_static_data(mob/user)
	. = ..()
	if(!selected_template)
		return

	.["glob_gt_evolutions"] = GLOB.gt_evolutions
	.["xeno_stats"] = xeno_stats
	.["caste_stats"] = caste_stats

/datum/gene_tailor/ui_state(mob/user)
	return GLOB.admin_state

/datum/gene_tailor/ui_act(action, params)
	if(..())
		return
	if(!selected_template && action != "load_template")
		tgui_alert(usr, "Please select a template first !", "No template detected", list("OK"), timeout = FALSE)
		return
	switch(action)
		if("spawn_mob")
			sanitize_input(params["caste_stats"], params["xeno_stats"], params["to_change_stats"])
			spawn_mob(params["caste_stats"], params["xeno_stats"])
		if("load_template")
			load_template()
		if("add_ability")
			var/list/pickable_abilities = subtypesof(/datum/action/xeno_action/onclick) + subtypesof(/datum/action/xeno_action/activable) + subtypesof(/datum/action/xeno_action/active_toggle) - list(/datum/action/xeno_action/onclick/xeno_resting, /datum/action/xeno_action/onclick/regurgitate, /datum/action/xeno_action/watch_xeno, /datum/action/xeno_action/activable/tail_stab)
			var/ability_choice = tgui_input_list(usr, "Select an ability to add, you DO NOT need to add generic abilities like rest, they are included by default.", "Add an Ability", pickable_abilities)
			if(!ability_choice)
				return
			xeno_abilities += ability_choice
			update_static_data(usr)
		if("remove_ability")
			var/ability_choice = tgui_input_list(usr, "Select an ability to remove.", "Remove an Ability", xeno_abilities)
			if(!ability_choice)
				return
			xeno_abilities -= ability_choice
			update_static_data(usr)
		if("add_delegate")
			var/delegate_choice = tgui_input_list(usr, "Select a passive to add.", "Add a Passive", subtypesof(/datum/behavior_delegate))
			if(!delegate_choice)
				return
			xeno_delegates += delegate_choice
			update_static_data(usr)
		if("remove_delegate")
			var/delegate_choice = tgui_input_list(usr, "Select a passive to remove.", "Remove a Passive", xeno_delegates)
			if(!delegate_choice)
				return
			xeno_delegates -= delegate_choice
			update_static_data(usr)

/datum/gene_tailor/Destroy(force, ...)
	QDEL_NULL(stat_stick)
	. = ..()

/datum/gene_tailor/proc/load_template()
	selected_template = tgui_input_list(usr, "Select a template from which the custom xenomorph will be based of.", "Load a template", subtypesof(/mob/living/carbon/Xenomorph) - /mob/living/carbon/Xenomorph/Custom)
	if(!selected_template)
		return
	QDEL_NULL(stat_stick)
	stat_stick = new selected_template
	for(var/var_name in type2listofvars(stat_stick.parent_type))
		xeno_stats[var_name] = stat_stick.vars[var_name]
	for(var/var_name in type2listofvars(stat_stick.caste.parent_type))
		caste_stats[var_name] = stat_stick.caste.vars[var_name]

	stored_xeno_types = get_data_types(stat_stick)
	stored_caste_types = get_data_types(stat_stick.caste)
	update_static_data(usr)
/**
 * Returns an assoc list of target's attribute types {var_name : var_type}
 * Possible types are : "text", "number", "path", "other"
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

/datum/gene_tailor/proc/spawn_mob(list/caste_stats, list/xeno_stats)
	var/datum/caste_datum/custom/custom_caste = new
	for(var/var_name in caste_stats)
		if(stored_caste_types[var_name] != "other")
			custom_caste.vars[var_name] = caste_stats[var_name]

	var/mob/living/carbon/Xenomorph/Custom/custom_xeno = new(usr.loc, custom_caste)

	for(var/var_name in xeno_stats)
		if(stored_xeno_types[var_name] != "other" && !(var_name in stored_caste_types))
			custom_xeno.vars[var_name] = xeno_stats[var_name]

	var/datum/behavior_delegate/Custom/custom_delegate = new(xeno_delegates, custom_xeno)
	custom_xeno.behavior_delegate = custom_delegate
	custom_xeno.base_actions += list(/datum/action/xeno_action/onclick/xeno_resting, /datum/action/xeno_action/onclick/regurgitate, /datum/action/xeno_action/watch_xeno, /datum/action/xeno_action/activable/tail_stab)
	custom_xeno.base_actions += xeno_abilities
	custom_xeno.add_abilities()
	custom_xeno.recalculate_everything()
	custom_xeno.icon = stat_stick.icon
	custom_xeno.stored_visuals["icon_source_caste"] = stat_stick.caste.caste_type
	custom_xeno.stored_visuals["pixel_x"] = stat_stick.pixel_x
	custom_xeno.stored_visuals["pixel_y"] = stat_stick.pixel_y
	custom_xeno.stored_visuals["old_x"] = stat_stick.old_x
	custom_xeno.stored_visuals["old_y"] = stat_stick.old_y
	custom_xeno.stored_visuals["base_pixel_x"] = stat_stick.base_pixel_x
	custom_xeno.stored_visuals["base_pixel_y"] = stat_stick.base_pixel_y
