GLOBAL_LIST_INIT(gt_evolutions, list(
	"Alien Tier 0" = XENO_T0_CASTES,
	"Alien Tier 1" = XENO_T1_CASTES,
	"Alien Tier 2" = XENO_T2_CASTES,
	"Alien Tier 3" = XENO_T3_CASTES,
	"Alien Tier 4" = XENO_SPECIAL_CASTES,
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
	/// An instance of selected_template, used to fetch relevant data that is only built during initialization
	var/mob/living/carbon/xenomorph/stat_stick
	///The passives picked
	var/list/xeno_delegates = list()
	///The abilities picked
	var/list/xeno_abilities = list()
	/// The name
	var/xeno_name
	/// What it evolves into, also what can devolve into it
	var/list/evolves_into = list()
	/// What it devolves into, also what can evolve into it
	var/list/devolves_into = list()

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
	data["evolves_into"] = evolves_into
	data["devolves_into"] = devolves_into
	return data

/datum/gene_tailor/ui_static_data(mob/user)
	. = ..()
	.["hives"] = ALL_XENO_HIVES
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
			sanitize_input(params["caste_stats"], params["xeno_stats"])
			spawn_custom_xeno(params["caste_stats"], params["xeno_stats"])
		if("load_template")
			load_template()
		if("add_ability")
			var/list/pickable_abilities = subtypesof(/datum/action/xeno_action/onclick) + subtypesof(/datum/action/xeno_action/activable) + subtypesof(/datum/action/xeno_action/active_toggle) - list(/datum/action/xeno_action/onclick/xeno_resting, /datum/action/xeno_action/onclick/regurgitate, /datum/action/xeno_action/watch_xeno, /datum/action/xeno_action/activable/tail_stab)
			var/ability_choice = tgui_input_list(usr, "Select an ability to add", "Add an Ability", pickable_abilities)
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
		if("set_name")
			xeno_name = sanitize(params["name"])
		if("transform_mob")
			var/mob/mob_choice = tgui_input_list(usr, "Select a mob to transform.", "Transform a Mob", GLOB.living_xeno_list - stat_stick)
			// Make sure it didn't die between selecting and transforming
			if(mob_choice && mob_choice.stat != DEAD)
				sanitize_input(params["caste_stats"], params["xeno_stats"])
				spawn_custom_xeno(params["caste_stats"], params["xeno_stats"], mob_choice)
			else
				tgui_alert(usr, "The selected mob died !", "Whoops !", list("OK"), timeout = 3 SECONDS)
		if("remove_delegate")
			var/delegate_choice = tgui_input_list(usr, "Select a passive to remove.", "Remove a Passive", xeno_delegates)
			if(!delegate_choice)
				return
			xeno_delegates -= delegate_choice
			update_static_data(usr)
		if("change_evolution")
			if(params["type"] == "evolve" && !(params["key"] in evolves_into))
				evolves_into += params["key"]
			else if(params["type"] == "devolve" && !(params["key"] in devolves_into))
				devolves_into += params["key"]
			update_static_data(usr)
		if("apply_genome")
			var/choice = tgui_alert(usr, "Xenomorphs will be able to evolve into a [xeno_name] without your intervention.\n This is irreversible, are you sure it is playable ?", "WARNING", list("Yes", "No"), timeout = FALSE)
			if(!choice || choice == "No")
				return
			sanitize_input(params["caste_stats"], params["xeno_stats"])
			apply_genome(params["caste_stats"], params["xeno_stats"])

/datum/gene_tailor/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/gene_tailor/Destroy(force, ...)
	QDEL_NULL(stat_stick)
	. = ..()

/datum/gene_tailor/proc/load_template()
	selected_template = tgui_input_list(usr, "Select a template from which the custom xenomorph will be based of.", "Load a template", subtypesof(/mob/living/carbon/xenomorph))
	if(!selected_template)
		return
	QDEL_NULL(stat_stick)
	stat_stick = new selected_template
	xeno_abilities = list()
	xeno_stats = list()
	caste_stats = list()
	evolves_into = list()
	devolves_into = list()
	for(var/var_name in type2listofvars(stat_stick.parent_type))
		xeno_stats[var_name] = stat_stick.vars[var_name]
	for(var/var_name in type2listofvars(stat_stick.caste.parent_type))
		caste_stats[var_name] = stat_stick.caste.vars[var_name]
	xeno_abilities = stat_stick.base_actions.Copy()
	xeno_delegates = list(stat_stick.caste.behavior_delegate_type)
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

/datum/gene_tailor/proc/sanitize_input(list/caste_inputs, list/xeno_inputs)
	for(var/var_name in caste_inputs)
		if(istext(caste_inputs[var_name]))
			caste_inputs[var_name] = sanitize(caste_inputs[var_name])
		switch(stored_caste_types[var_name])
			if("number") caste_inputs[var_name] = text2num(caste_inputs[var_name])
			if("path") caste_inputs[var_name] = text2path(caste_inputs[var_name])

	for(var/var_name in xeno_inputs)
		if(istext(xeno_inputs[var_name]))
			xeno_inputs[var_name] = sanitize(xeno_inputs[var_name])
		switch(stored_xeno_types[var_name])
			if("number") xeno_inputs[var_name] = text2num(xeno_inputs[var_name])
			if("path") xeno_inputs[var_name] = text2path(xeno_inputs[var_name])

/datum/gene_tailor/proc/apply_genome(list/custom_caste_stats, list/custom_xeno_stats)
	if(xeno_name in GLOB.custom_evolutions)
		tgui_alert(usr, "The caste [xeno_name] already exists.", "Invalid name", list("OK"), timeout = 3 SECONDS)
		return
	var/datum/caste_datum/custom_caste = new stat_stick.caste.type
	for(var/var_name in custom_caste_stats)
		if(stored_caste_types[var_name] != "other")
			custom_caste.vars[var_name] = custom_caste_stats[var_name]
	custom_caste.display_name = xeno_name
	custom_caste.evolves_to = evolves_into
	custom_caste.deevolves_to = devolves_into
	GLOB.custom_evolutions[xeno_name] = list()
	GLOB.custom_evolutions[xeno_name]["xeno_delegates"] = xeno_delegates
	GLOB.custom_evolutions[xeno_name]["xeno_abilities"] = xeno_abilities
	GLOB.custom_evolutions[xeno_name]["xeno_stats"] = xeno_stats
	GLOB.custom_evolutions[xeno_name]["stored_xeno_types"] = stored_xeno_types
	GLOB.custom_evolutions[xeno_name]["caste_datum"] = custom_caste
	GLOB.custom_evolutions[xeno_name]["mob_type"] = selected_template

	for(var/caste_type in evolves_into)
		GLOB.xeno_datum_list[caste_type].deevolves_to += xeno_name
	for(var/caste_type in devolves_into)
		GLOB.xeno_datum_list[caste_type].evolves_to += xeno_name
/**
 * Spawns a custom xenomorph with the properties specified in the arguments.
 *
 * Arguments :
 * * caste_stats : The attributes of the caste_datum of the custom xenomorph
 * * xeno_stats : The attributes of the carbon xenomorph itself, only the attributes unique to ...carbon/xenomorph can be changed this way
 * * old_xeno : If set, the old xenomoprh will be turned into the custom xenomoprh, otherwise the xenomorph will spawn under the user
 */
/datum/gene_tailor/proc/spawn_custom_xeno(list/custom_caste_stats, list/custom_xeno_stats, mob/living/carbon/xenomorph/old_xeno = null)
	var/datum/caste_datum/custom_caste = new stat_stick.caste.type
	for(var/var_name in custom_caste_stats)
		if(stored_caste_types[var_name] != "other")
			custom_caste.vars[var_name] = custom_caste_stats[var_name]

	custom_caste.evolves_to = evolves_into
	custom_caste.deevolves_to = devolves_into
	var/destination = old_xeno ? old_xeno.loc : usr.loc
	var/mob/living/carbon/xenomorph/custom_xeno = new selected_template(destination, old_xeno, custom_xeno_stats["hivenumber"], custom_caste)
	custom_caste.display_name = xeno_name
	// Some duplicate code lifted from Evolution.dm
	if(old_xeno)
		if(old_xeno.mind)
			old_xeno.mind.transfer_to(custom_xeno)
		custom_xeno.set_lighting_alpha(old_xeno.get_vision_level())
		old_xeno.transfer_observers_to(custom_xeno)
		qdel(old_xeno)
		custom_xeno.xeno_jitter(25)
		if(round_statistics)
			round_statistics.track_new_participant(custom_xeno.faction, -1)
		SSround_recording.recorder.track_player(custom_xeno)


	for(var/var_name in xeno_stats)
		if(stored_xeno_types[var_name] != "other" && !(var_name in stored_caste_types))
			custom_xeno.vars[var_name] = xeno_stats[var_name]

	for(var/action_type in custom_xeno.base_actions)
		qdel(remove_action(custom_xeno, action_type))

	//custom_xeno.name = xeno_name
	custom_xeno.generate_name()
	custom_xeno.create_hud()
	custom_xeno.base_actions = xeno_abilities
	custom_xeno.add_abilities()
	custom_xeno.recalculate_everything()

	var/datum/behavior_delegate/custom/custom_delegate = new(xeno_delegates, custom_xeno)
	custom_xeno.behavior_delegate = custom_delegate
