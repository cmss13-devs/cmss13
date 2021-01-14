/// The list of traits a client will gives its human mob upon spawn
/// Store as typepaths
/datum/preferences/var/list/traits
/// State var for preferences to track trait points
/// Change this value to set the amount of trait points you start with
/datum/preferences/var/trait_points = 1
/// State var to check if traits have been read in to modify
/// trait points
/datum/preferences/var/read_traits = FALSE
/// The list of traits a human has
/// Store as typepaths
/mob/living/carbon/human/var/list/traits

/** Global lists
 * character_trait_groups should be defined BEFORE character_traits because of dependencies
 * When trying to reference specific traits or trait groups, reference these lists, which
 * store character traits and character trait groups by their type paths
 *
 * Example:
 * GLOB.character_traits[/datum/character_trait/language/spanish] will get the
 * "Speaks Spanish" character trait, which you can use to give or remove traits
 */
GLOBAL_REFERENCE_LIST_INDEXED(character_trait_groups, /datum/character_trait_group, type)
GLOBAL_REFERENCE_LIST_INDEXED(character_traits, /datum/character_trait, type)

/// Character traits
/// Similar to the traits from Project Zomboid
/datum/character_trait
	var/trait_name = "Character Trait"
	var/trait_desc = "A character trait"
	/// Whether the trait can be applied to mobs
	/// Do not forget to override this var for any child types
	/// Only set this to TRUE for "abstract" parent types
	var/applyable = FALSE
	/**
	 * Trait groups determine whether this trait
	 * can be applied to a given mob
	 *
	 * This var should always be set to the
	 * trait group's typepath
	 */
	var/datum/character_trait_group/trait_group = /datum/character_trait_group
	/// The point cost for the preferences menu
	var/cost = 0

/datum/character_trait/New()
	trait_group = GLOB.character_trait_groups[trait_group]
	if(!trait_group)
		CRASH("Invalid trait_group set for character trait [type]")
	trait_group.traits += src

/// A wrapper to check if the trait can be applied first
/datum/character_trait/proc/can_give_trait(datum/preferences/target)
	if(type in target.traits)
		return FALSE
	if(!trait_group.can_give_trait(target))
		return FALSE
	if(target.trait_points < cost)
		return FALSE
	return TRUE

/// Performs the check for whether the trait is valid for target and then
/// gives it to target
/datum/character_trait/proc/try_give_trait(datum/preferences/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!can_give_trait(target))
		return
	give_trait(target)

/// Gives the target the trait
/datum/character_trait/proc/give_trait(datum/preferences/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	target.trait_points -= cost
	LAZYADD(target.traits, type)

/datum/character_trait/proc/try_remove_trait(datum/preferences/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!LAZYISIN(target.traits, type))
		return
	remove_trait(target)

/datum/character_trait/proc/remove_trait(datum/preferences/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	target.trait_points += cost
	LAZYREMOVE(target.traits, type)

/// Put the actual changes made to the human mob in this proc
/datum/character_trait/proc/apply_trait(mob/living/carbon/human/target)
	SHOULD_CALL_PARENT(TRUE)

	LAZYADD(target.traits, src)

/// Revert character trait changes in this proc
/datum/character_trait/proc/unapply_trait(mob/living/carbon/human/target)
	SHOULD_CALL_PARENT(TRUE)

	LAZYREMOVE(target.traits, src)

/// Character trait groups for constraints (if any)
/datum/character_trait_group
	/// For player prefs menu
	var/trait_group_name = "Trait Group"

	// CONSTRAINTS
	// MODIFY THESE VARS FOR SETTING CONSTRAINTS FOR TRAIT GROUPS
	/// Whether a mob can only have one
	/// trait of this trait group
	var/mutually_exclusive = FALSE
	/// The maximum amount of traits from
	/// this trait group that a mob can have
	var/max
	/**
	 * Override this variable if you want this
	 * trait group to be constraining
	 * Only need to override for the parent
	 * Example, parent type /datum/character_trait_group/language,
	 * set this var to /datum/character_trait_group/language
	 */
	var/base_type

	/// A list of this group's traits populated in /datum/character_trait/New()
	var/list/datum/character_trait/traits = list()

/datum/character_trait_group/New()
	// Modify this if adding more constraints
	var/constraining = mutually_exclusive || max
	if(constraining && !base_type)
		stack_trace("Defined a constraining character trait group without setting base_type for [type]")
		base_type = type

/datum/character_trait_group/proc/can_give_trait(datum/preferences/target)
	SHOULD_CALL_PARENT(TRUE)

	. = TRUE
	// Modify this if adding more constraints
	var/constraining = mutually_exclusive || max
	if(!constraining)
		return
	var/count = 0
	for(var/trait in target.traits)
		var/datum/character_trait/CT = trait
		if(istype(CT.trait_group, base_type))
			if(mutually_exclusive)
				return FALSE
			if(++count >= max)
				return FALSE
