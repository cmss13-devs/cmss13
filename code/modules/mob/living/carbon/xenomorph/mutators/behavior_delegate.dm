// Used to hold mutator-specific state and encompass mutator-specific behavior, such as on-hit effects.

///////////////////////////////////
//
// How this code works
//
// Basically, I inserted 'hooks' in all the relevant locations that call these procs whenever the xeno takes damage,
// lands a slash, etc. The goal functionality is to modularize all extra behavior needed by strains in one place.
// One of these is instanced onto every xeno and is also used to track all additional state needed by the strain itself.
//
// A brief flowchart
//   xeno New() -OR- strain applicator
// |
//  constructs
//    \/
//  behavior_delegate
//    attack procs  <- called by attacking code
//    other stuff   <- called in xeno Life, etc
//    constant variables <- used as balancing values for strains, etc
//    state variables <- used to store all strain-unique state associated with THIS xeno.
//
//
//
/datum/behavior_delegate

	/// Userfriendly name of the mutator
	var/name = "Set This"

	/// The Xeno we handle mutator state for
	var/mob/living/carbon/xenomorph/bound_xeno

/datum/behavior_delegate/Destroy(force, ...)
	remove_from_xeno()
	bound_xeno = null
	return ..()

/**
 * Called during Xeno life
 * Handles anything that needs to be periodically ticked
 * for this mutator to function
 */
/datum/behavior_delegate/proc/on_life()
	return

/// Returns any extra information to display via stat.
/datum/behavior_delegate/proc/append_to_stat()
	return list()

/datum/behavior_delegate/proc/add_to_xeno()
	return

/datum/behavior_delegate/proc/remove_from_xeno()
	return

/**
 * Modifies the damage of a slash based on the current mutator state.
 * Do not override this proc unless you need to affect the rolled damage
 * of an attack before it happens
 */
/datum/behavior_delegate/proc/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	return original_damage

/datum/behavior_delegate/proc/melee_attack_additional_effects_target(mob/living/carbon/A)
	return

/datum/behavior_delegate/proc/melee_attack_additional_effects_self()
	SEND_SIGNAL(bound_xeno, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)

// Identical to the above 3 procs but for ranged attacks.
/**
 * Technically speaking, these are called whenever a xeno projectile impacts
 * a target (acid spit), NOT when gas damages them.
 * If you want to deal any more damage, just do it in the addl. effects proc
 * adding damage to a projectile in the actual proc is highly nontrivial
 */
/datum/behavior_delegate/proc/ranged_attack_on_hit()
	return

/datum/behavior_delegate/proc/ranged_attack_additional_effects_target(atom/A)
	return

/datum/behavior_delegate/proc/ranged_attack_additional_effects_self(atom/A)
	return

/// Any special behaviors on reception of a projectile attack
/datum/behavior_delegate/proc/on_hitby_projectile(ammo)
	return

/// Behaviour when killing people
/datum/behavior_delegate/proc/on_kill_mob(mob/M)
	return

/// Handling specific behavior - if TRUE, the attack will not have an attack delay by default.
/datum/behavior_delegate/proc/handle_slash(mob/M)
	return

/datum/behavior_delegate/proc/handle_death(mob/M)
	return

/// Handling the xeno icon state or overlays, return TRUE if icon state should not be changed
/datum/behavior_delegate/proc/on_update_icons()
	return

/// Used to override an intent for some abilities that must force harm on next attack_alien()
/datum/behavior_delegate/proc/override_intent(mob/living/carbon/target_carbon)
	return bound_xeno.a_intent

/// Used to do something when a xeno collides with a movable atom
/datum/behavior_delegate/proc/on_collide(atom/movable/movable_atom)
	return
