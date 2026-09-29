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

GLOBAL_ALIST_EMPTY(ignitable_flavor_text_by_type)

/datum/element/traitbound/ignitable/proc/ignite(atom/ignitable, obj/item/igniter, mob/user, custom_flavor_text)
	SIGNAL_HANDLER

	var/flavor_text_by_type = ignitable.get_ignitable_flavor_text()
	var/flavor_text
	var/ignition_source = igniter
	if (custom_flavor_text)
		flavor_text = custom_flavor_text
	else if (flavor_text_by_type)
		var/highest_matching_path = get_matching_paths(igniter, flavor_text_by_type).highest_matching
		if (highest_matching_path)
			var/flavor_text_template = flavor_text_by_type[highest_matching_path]
			flavor_text = text_dynamic_insertion_custom(
				flavor_text_template,
				list("ignitable", "igniter", "user"),
				ignitable,
				igniter,
				user,
			)
	if (!flavor_text)
		flavor_text = "[user] ignites [ignitable] with [ignition_source]."
	ignitable.ignite(ignition_source, user, flavor_text)

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
