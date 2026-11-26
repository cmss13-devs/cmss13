/datum/xeno_strain
	/// The name of the strain. Should be short but informative.
	var/name
	/// Short overview of the strain's role and passive tradeoffs.
	var/summary
	/// Description to be displayed on purchase.
	var/description
	/// (OPTIONAL) Flavor text to be shown on purchase. Semi-OOC
	var/flavor_description
	/// (OPTIONAL) A custom icon state prefix for xenos who have taken the strain.
	var/icon_state_prefix

	/// Permanent change to the number of attempts needed for a guaranteed tackle.
	var/tackle_max_change = 0

	/// A list of action typepaths which should be removed when a xeno takes the strain.
	var/list/actions_to_remove
	/// A list of action typepaths which should be added when a xeno takes the strain.
	var/list/actions_to_add

	/// Typepath of the [/datum/behavior_delegate] to add.
	var/behavior_delegate_type

	/// How much phero strength is modified by this strain. Applied in parent of apply_strain.
	var/phero_mod = 0
	/// How much slash damage is modified by this strain. Applied in parent of apply_strain.
	var/damage_mod = 0
	/// How much health is modified by this strain. Applied in parent of apply_strain.
	var/health_mod = 0
	/// How much armor is modified by this strain. Applied in parent of apply_strain.
	var/armor_mod = 0
	/// How much expolosive armor is modified by this strain. Applied in parent of apply_strain.
	var/explosive_armor_mod = 0
	/// How much speed is modified by this strain. Applied in parent of apply_strain.
	var/speed_mod = 0
	/// How much attack speed is modified by this strain (lower faster). Applied in parent of apply_strain.
	var/attack_speed_mod = 0
	/// How much plasma pool is modified by this strain. Applied in parent of apply_strain.
	var/plasma_mod = 0

	/// Regen multiplier that is modified by this strain. Applied in parent of apply_strain.
	var/regen_mult = 1

/**
 * Add this strain to `xeno`, replacing their actions and behavior holder.
 *
 * Returns a bool indicating if the strain was successfully applied.
 * **Override [/datum/xeno_strain/proc/apply_strain], not this! (Unless you know what you're doing.)**
 */
/datum/xeno_strain/proc/_add_to_xeno(mob/living/carbon/xenomorph/xeno)
	SHOULD_NOT_OVERRIDE(TRUE)

	xeno.strain = src

	// Update the xeno's actions.
	for(var/action_path in actions_to_remove)
		remove_action(xeno, action_path)
	for(var/action_path in actions_to_add)
		give_action(xeno, action_path)

	var/datum/action/minimap/ref = xeno.minimap_ref.resolve()
	ref.remove_from(xeno)
	ref.give_to(xeno, ref)

	// Update the xeno's behavior delegate.
	if(behavior_delegate_type)
		if(xeno.behavior_delegate)
			qdel(xeno.behavior_delegate)
		xeno.behavior_delegate = new behavior_delegate_type()
		xeno.behavior_delegate.bound_xeno = xeno
		xeno.behavior_delegate.add_to_xeno()

	apply_strain(xeno)
	xeno.recalculate_everything()

	xeno.update_icons()
	xeno.hive.hive_ui.update_xeno_info()

	// Give them all of the info about the strain.
	to_chat(xeno, SPAN_XENOANNOUNCE(description))
	if(flavor_description)
		to_chat(xeno, SPAN_XENOLEADER(flavor_description))
	return TRUE

/**
 * Adds any special modifiers/changes from this strain to `xeno`.
 *
 * Called when the strain is first added to the player.
 */
/datum/xeno_strain/proc/apply_strain(mob/living/carbon/xenomorph/xeno)
	SHOULD_CALL_PARENT(TRUE)

	xeno.phero_modifier += phero_mod
	xeno.damage_modifier += damage_mod
	xeno.health_modifier += health_mod
	xeno.armor_modifier += armor_mod
	xeno.explosivearmor_modifier += explosive_armor_mod
	xeno.speed_modifier += speed_mod
	xeno.attack_speed_modifier += attack_speed_mod
	xeno.plasmapool_modifier += plasma_mod
	xeno.tackle_max_modifier += tackle_max_change

	xeno.regeneration_multiplier = regen_mult

/mob/living/carbon/xenomorph/verb/purchase_strain()
	set name = "Purchase Strain"
	set desc = "Purchase a strain for yourself"
	set category = "Alien.Essentials"

	// Firstly, make sure the xeno is actually able to take a strain.
	if(!can_take_strain())
		return

	var/client/purchasing_client = client
	var/datum/caste_datum/purchasing_caste = caste

	// Make an assoc list of {name: typepath} from the strains available to the xeno's caste.
	var/list/strain_list = list()
	for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
		strain_list[initial(strain_type.name)] = strain_type

	// Ask the user which strain they want.
	var/strain_choice = strain_list[1]
	if(length(strain_list) > 1)
		strain_choice = tgui_input_list(src, "Which strain would you like to take?", "Choose Strain", strain_list, theme = "hive_status")
	if(!strain_choice)
		return
	var/datum/xeno_strain/chosen_strain = strain_list[strain_choice]

	// Check again after the user picks one, in case anything changed.
	if(QDELETED(src) || client != purchasing_client || caste != purchasing_caste || !can_take_strain())
		return
	var/datum/xeno_strain/strain_instance = new chosen_strain()
	if(!strain_instance.show_preview(src, purchasing = TRUE))
		qdel(strain_instance)
		return
	// One more time after they confirm.
	if(QDELETED(src) || client != purchasing_client || caste != purchasing_caste || !can_take_strain() || !(chosen_strain in caste.available_strains))
		qdel(strain_instance)
		return

	if(strain_instance._add_to_xeno(src))
		overlays -= acid_overlay
		xeno_jitter(1.5 SECONDS)
		// If it applied successfully, add it to the logs.
		log_strain("[name] purchased strain '[strain_instance.type]'")

/mob/living/carbon/xenomorph/verb/reset_strain()
	set name = "Reset Strain"
	set desc = "Reset your strain."
	set category = "Alien.Essentials"

	// Firstly, make sure the xeno is actually able to take a strain.
	if(!can_take_strain(reset = TRUE))
		return

	if(!COOLDOWN_FINISHED(src, next_strain_reset))
		to_chat(src, SPAN_WARNING("We lack the strength to reset our strain. We will be able to reset it in [round((next_strain_reset - world.time) / 600, 1)] minutes."))
		return

	var/datum/xeno_strain/current_strain = strain
	if(!caste.show_preview(src, GLOB.RoleAuthority.get_caste_by_text(caste_type), "Reset Strain"))
		return

	// One more time after they confirm.
	if(QDELETED(src) || !client || strain != current_strain || !COOLDOWN_FINISHED(src, next_strain_reset) || !can_take_strain(reset = TRUE))
		return

	var/mob/living/carbon/xenomorph/new_xeno = transmute(caste_type)
	if(!new_xeno)
		return

	new_xeno.xeno_jitter(1.5 SECONDS)
	if(evolution_stored == evolution_threshold)
		if(new_xeno.caste_type == XENO_CASTE_FACEHUGGER)
			return
		give_action(new_xeno, /datum/action/xeno_action/onclick/evolve)

	// If it applied successfully, add it to the logs.
	log_strain("[new_xeno.name] reset their strain.")
	COOLDOWN_START(new_xeno, next_strain_reset, 40 MINUTES)

/mob/living/carbon/xenomorph/verb/strain_info()
	set name = "Strain Information"
	set desc = "Shows your current caste or strain."
	set category = "Alien.Essentials"

	if(strain)
		strain.show_preview(src)
	else
		caste.show_preview(src, type)

/datum/xeno_strain/proc/show_preview(mob/living/carbon/xenomorph/xeno, purchasing = FALSE)
	if(!xeno.client)
		return FALSE
	var/list/original_actions = xeno.caste.get_preview_actions()
	if(purchasing)
		original_actions = list()
		for(var/datum/action/action as anything in xeno.actions)
			original_actions += action.type

	var/datum/tgui_modal/xeno_preview/preview = new(xeno, null, name, purchasing ? list("Mutate", "Cancel") : list("Close"), 0, TRUE, GLOB.always_state)
	original_actions = preview.action_types(original_actions)
	var/list/added = preview.action_types(actions_to_add)
	var/list/gained = added - original_actions
	var/list/lost = (preview.action_types(actions_to_remove) & original_actions) - added

	preview.details = list(
		"caste" = xeno.caste_type,
		"summary" = summary,
		"tackleMin" = xeno.caste.tackle_min,
		"canTackle" = xeno.caste.can_tackle,
		"tackleMax" = xeno.caste.tackle_max + tackle_max_change,
		"flavor" = flavor_description,
		"stats" = preview.stat_changes(xeno, armor_mod, damage_mod, health_mod, show_current = !purchasing),
		"showCurrentStats" = !purchasing,
		"resources" = preview.resource_changes(xeno, xeno.caste, null, xeno.caste, src),
		"description" = description,
		"portrait" = icon2html(get_preview_portrait(xeno), xeno, sourceonly = TRUE, non_standard_size = TRUE),
		"gained" = preview.abilities(xeno, gained),
		"lost" = preview.abilities(xeno, lost),
	)
	var/confirmed = preview.prompt(xeno) == "Mutate"
	qdel(preview)
	return confirmed

/datum/xeno_strain/proc/get_preview_portrait(mob/living/carbon/xenomorph/xeno)
	var/portrait_state = "[icon_state_prefix || "Normal"] [xeno.caste_type] Running"
	var/portrait_file = xeno.icon
	if(!icon_exists(portrait_file, portrait_state))
		portrait_file = xeno.icon_xeno
	return icon(portrait_file, portrait_state, SOUTH, 1)

/datum/tgui_modal/xeno_preview
	var/list/details
	/// The xeno this preview was opened for
	var/mob/living/carbon/xenomorph/preview_owner
	var/client/preview_client
	var/datum/caste_datum/preview_caste
	var/datum/xeno_strain/preview_strain
	var/invalidated = FALSE

/datum/tgui_modal/xeno_preview/New(mob/living/carbon/xenomorph/user, message, title, list/buttons, timeout, autofocus, ui_state)
	..()
	preview_owner = user
	preview_client = user.client
	preview_caste = user.caste
	preview_strain = user.strain
	RegisterSignal(user, list(COMSIG_MOB_LOGOUT, COMSIG_PARENT_QDELETING), PROC_REF(invalidate))

/datum/tgui_modal/xeno_preview/Destroy()
	if(preview_owner)
		UnregisterSignal(preview_owner, list(COMSIG_MOB_LOGOUT, COMSIG_PARENT_QDELETING))
	preview_owner = null
	preview_client = null
	preview_caste = null
	preview_strain = null
	return ..()

/datum/tgui_modal/xeno_preview/proc/is_valid(mob/user)
	return !invalidated && !QDELETED(preview_owner) && user == preview_owner && preview_client && preview_owner.client == preview_client && preview_client.mob == preview_owner && preview_owner.caste == preview_caste && preview_owner.strain == preview_strain

/datum/tgui_modal/xeno_preview/proc/invalidate()
	SIGNAL_HANDLER
	invalidated = TRUE
	choice = null
	closed = TRUE
	SStgui.close_uis(src)

/datum/tgui_modal/xeno_preview/ui_status(mob/user, datum/ui_state/state)
	if(!is_valid(user))
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/tgui_modal/xeno_preview/set_choice(choice)
	if(!is_valid(preview_owner))
		invalidate()
		return
	return ..()

/datum/tgui_modal/xeno_preview/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(!ui || !is_valid(ui.user))
		invalidate()
		if(ui)
			ui.status = UI_CLOSE
	return ..()

/datum/tgui_modal/xeno_preview/wait()
	while(!choice && !closed && !QDELETED(src))
		if(!is_valid(preview_owner))
			invalidate()
			return
		stoplag(0.2 SECONDS)

/datum/tgui_modal/xeno_preview/proc/resource_changes(mob/living/carbon/xenomorph/user, datum/caste_datum/from_caste, datum/xeno_strain/from_strain, datum/caste_datum/to_caste, datum/xeno_strain/to_strain)
	var/from_pool = from_caste.base_plasma_capacity(from_strain)
	var/to_pool = to_caste.base_plasma_capacity(to_strain)
	var/plasma_icon = icon2html('icons/mob/hud/actions_xeno.dmi', user, "transfer_plasma", sourceonly = TRUE)
	var/list/resources = list(list(
		"name" = "Plasma capacity", "icon" = plasma_icon,
		"before" = from_pool, "after" = to_pool,
		"description" = to_pool ? null : "This form uses no plasma.",
	))
	var/from_regen = from_pool * from_caste.plasma_gain / 100
	var/to_regen = to_pool * to_caste.plasma_gain / 100
	if(from_regen != to_regen)
		resources += list(list(
			"name" = "Plasma recovery", "icon" = plasma_icon,
			"before" = from_regen, "after" = to_regen,
			"description" = "Base plasma restored per regeneration tick on weeds.",
		))
	var/datum/behavior_delegate/old_behavior = from_strain?.behavior_delegate_type || from_caste.behavior_delegate_type
	var/datum/behavior_delegate/new_behavior = to_strain?.behavior_delegate_type || to_caste.behavior_delegate_type
	if(old_behavior != new_behavior && initial(old_behavior.resource_capacity))
		resources += list(special_resource(user, old_behavior, initial(old_behavior.resource_capacity), 0))
	if(initial(new_behavior.resource_capacity))
		resources += list(special_resource(user, new_behavior, old_behavior == new_behavior ? initial(new_behavior.resource_capacity) : 0, initial(new_behavior.resource_capacity)))
	return resources

/datum/tgui_modal/xeno_preview/proc/special_resource(mob/living/carbon/xenomorph/user, datum/behavior_delegate/behavior, before, after)
	return list(
		"name" = initial(behavior.resource_name),
		"icon" = icon2html('icons/mob/hud/actions_xeno.dmi', user, initial(behavior.resource_icon_state), sourceonly = TRUE),
		"before" = before, "after" = after,
		"current" = before == after && istype(user.behavior_delegate, behavior) ? user.behavior_delegate.preview_resource_amount() : null,
		"description" = after ? initial(behavior.resource_description) : null,
	)

/datum/tgui_modal/xeno_preview/proc/stat_changes(mob/living/carbon/xenomorph/user, armor_change, damage_change, health_change, show_current = FALSE)
	var/list/stats = list()
	if(show_current || armor_change)
		stats += list(preview_stat(user, "Armor", "phero_warding", armor_change, XENO_ARMOR_MOD_VERY_SMALL, user.armor_deflection))
	if(show_current || damage_change)
		var/damage = user.melee_damage_lower == user.melee_damage_upper ? user.melee_damage_lower : "[user.melee_damage_lower]-[user.melee_damage_upper]"
		stats += list(preview_stat(user, "Slash Damage", "phero_frenzy", damage_change, XENO_DAMAGE_MOD_VERY_SMALL, damage))
	if(show_current || health_change)
		stats += list(preview_stat(user, show_current ? "Max Health" : "Health", "phero_recov", health_change, XENO_HEALTH_MOD_VERY_SMALL, user.maxHealth))
	return stats

/datum/tgui_modal/xeno_preview/proc/preview_stat(mob/user, label, icon_state, amount, step_size, current)
	return list(
		"name" = label,
		"icon" = icon2html('icons/mob/radial.dmi', user, icon_state, sourceonly = TRUE),
		"amount" = amount,
		"current" = current,
		"chevrons" = min(6, ceil(abs(amount) / step_size)),
	)

/datum/tgui_modal/xeno_preview/proc/action_types(list/actions)
	var/list/result = list()
	for(var/action_path in actions)
		if(!ispath(action_path, /datum/action/xeno_action))
			continue
		var/datum/action/xeno_action/ability = action_path
		result |= initial(ability.preview_as) || ability
	return result

/datum/tgui_modal/xeno_preview/proc/abilities(mob/user, list/actions)
	var/list/result = list()
	for(var/datum/action/xeno_action/ability as anything in actions)
		var/icon_file = initial(ability.preview_icon_file) || initial(ability.icon_file)
		var/icon_state = initial(ability.preview_icon_state) || initial(ability.action_icon_state)
		result += list(list(
			"name" = initial(ability.name),
			"description" = initial(ability.ability_description),
			"stats" = get_xeno_ability_stats(ability),
			"costs" = get_xeno_ability_costs(ability),
			"icon" = icon2html(icon_file, user, icon_state, sourceonly = TRUE),
		))
	return result

/datum/tgui_modal/xeno_preview/proc/prompt(mob/user)
	if(!is_valid(user))
		return null
	tgui_interact(user)
	wait()
	return is_valid(user) ? choice : null

/datum/tgui_modal/xeno_preview/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoStrainPreview", title)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tgui_modal/xeno_preview/ui_static_data(mob/user)
	return details + list("name" = title, "buttons" = buttons)

/// Is this xeno currently able to take a strain?
/mob/living/carbon/xenomorph/proc/can_take_strain(reset=FALSE)
	if(!client || !length(caste.available_strains) || !check_state(TRUE))
		return FALSE

	if(strain && !reset)
		to_chat(src, SPAN_WARNING("We have already chosen a strain."))
		return FALSE

	if(!strain && reset)
		to_chat(src, SPAN_WARNING("We must first pick a strain before resetting it."))
		return FALSE

	if(is_zoomed)
		to_chat(src, SPAN_WARNING("We can't do that while looking far away."))
		return FALSE

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("This place is too constraining to take a strain."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("We can't take a strain here."))
		return FALSE

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow us to take a strain."))
		return FALSE

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("We must be at full health to take a strain."))
		return FALSE

	if(fortify || crest_defense || stealth || HAS_TRAIT(src, TRAIT_ABILITY_ENCLOSED_PLATES) || HAS_TRAIT(src, TRAIT_ABILITY_REFLECTIVE_PLATES))
		to_chat(src, SPAN_WARNING("We cannot take a strain while in this stance."))
		return FALSE

	return TRUE
