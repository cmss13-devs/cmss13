/datum/ignitable_constants
	// Update /proc/replace_ignitable_flavor_text(...) to handle any more constants here
	VAR_FINAL/const/APPLY_THE = 1

GLOBAL_REAL(ignitable_constants, /datum/ignitable_constants)

/// Element for atoms that can ignite
/datum/element/traitbound/ignitable
	compatible_types = list(/atom)
	associated_trait = TRAIT_IGNITABLE

/datum/element/traitbound/ignitable/Attach(atom/target)
	. = ..()
	if (. & ELEMENT_INCOMPATIBLE)
		return
	RegisterSignal(target, COMSIG_ATOM_IGNITE, PROC_REF(ignite))

/datum/element/traitbound/ignitable/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_ATOM_IGNITE)
	return ..()

/datum/element/traitbound/ignitable/proc/ignite(atom/ignitable, obj/item/igniter, mob/user, custom_flavor_text)
	SIGNAL_HANDLER

	var/flavor_text_by_type = ignitable.get_ignitable_flavor_text()
	var/flavor_text
	var/ignition_source = igniter
	if (custom_flavor_text)
		flavor_text = custom_flavor_text
	var/datum/igniter_override_metadata/metadata = new /datum/igniter_override_metadata()
	SEND_SIGNAL(igniter, COMSIG_IGNITER_OVERRIDE, metadata)
	if (metadata.igniter_override)
		ignition_source = metadata.igniter_override
	if (flavor_text_by_type)
		var/highest_matching_path = get_matching_paths(igniter, flavor_text_by_type).highest_matching
		if (highest_matching_path)
			var/datum/ignitable_flavor_text_data/flavor_text_data = flavor_text_by_type[highest_matching_path]
			var/replacement_text = flavor_text_data.replacement_text
			var/index_params = flavor_text_data.index_params
			flavor_text = text_dynamic_insertion_custom(
				replacement_text,
				list("ignitable", "igniter", "user"),
				replace_ignitable_flavor_text(
					ignitable,
					LAZYACCESS(index_params, "ignitable"),
				),
				replace_ignitable_flavor_text(
					igniter,
					LAZYACCESS(index_params, "igniter"),
				),
				replace_ignitable_flavor_text(
					user,
					LAZYACCESS(index_params, "user"),
				),
			)
	if (!flavor_text)
		flavor_text = "[user] ignites \the [ignitable] with \the [ignition_source]."
	ignitable.ignite(ignition_source, user, flavor_text)

/// Data class for setting igniter_override
/datum/igniter_override_metadata
	/// Atom to track as source of ignition
	var/atom/igniter_override

// TODO: generalize this to be usable in other contexts
/datum/ignitable_flavor_text_data
	/// Text template for replacement text
	var/replacement_text
	/// Optional mapping of index keys to a text modifiers
	var/alist/index_params

/datum/ignitable_flavor_text_data/New(replacement_text, alist/index_params)
	src.replacement_text = replacement_text
	src.index_params = index_params

/proc/replace_ignitable_flavor_text(atom/atom_to_reference, text_param)
	if (!text_param)
		return "[atom_to_reference.name]"
	else if (text_param == ignitable_constants::APPLY_THE)
		return "\the [atom_to_reference]"
	else
		CRASH("Invalid text_param passed: '[text_param]'")

/**
 * Proc to overwrite for any ignitables with custom flavor text
 *
 * List of string templates containing text when parent ignites an object
 * String templates should have `{ignitable}`, `{igniter}`, and `{user}` in the string
 * templates to get expected results
 * - `{ignitable}` = thing being ignited
 * - `{igniter}` = thing triggering the ignition
 * - `{user}` = evil person responsible
 */
/atom/proc/get_ignitable_flavor_text()
	RETURN_TYPE(/alist)
	return

/**
 * Proc to overwrite for when an ignitable ignites
 *
 * Should not be called directly, instead send the signal `COMSIG_ATOM_IGNITE`
 */
/atom/proc/ignite(obj/item/igniter, mob/user, flavor_text)
	return
