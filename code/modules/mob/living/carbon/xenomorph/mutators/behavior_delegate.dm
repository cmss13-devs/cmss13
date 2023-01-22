// Used to hold mutator-specific state and encompass mutator-specific behavior, such as on-hit effects.

///////////////////////////////////
//
// How this code works
//
// Basically, I inserted 'hooks' in all the relevant locations that call these procs whenever the xeno takes damage,
// lands a slash, etc. The goal functionality is to modularize all extra behavior needed by strains in one place.
// One of these is instanced onto every xeno and is also used to track all additional state needed by the strain itself.
//
// Addendum
//
// This datum is meant to be M.O.D.U.L.A.R, you should NOT assume your delegate will be held by any specific xenomoprh.
// This also means xenomorphs should NOT assume they have any delegate in particular, if your strain/caste needs to call a specific proc from their
// specific delegate, reconsider its necessity, this is for shared behaviors, not a fancy proc holder.
//
// A brief flowchart
//   xeno New() -OR- strain applicator
// |
//  constructs
//    \/
//  behavior_delegate
//    attack procs  <- called by attacking code
//    ability procs <- called by action code, use them for inter-ability interactions after checking for the ability
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
	var/mob/living/carbon/Xenomorph/bound_xeno

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
	SHOULD_CALL_PARENT(TRUE)
	if(!bound_xeno)
		return
	RegisterSignal(bound_xeno, COMSIG_ACTION_GIVEN, PROC_REF(register_action))
	RegisterSignal(bound_xeno, COMSIG_ACTION_REMOVED, PROC_REF(unregister_action))
	for(var/datum/action/xeno_action/ability in bound_xeno.actions)
		register_action(ability)
	return

/datum/behavior_delegate/proc/remove_from_xeno()
	SHOULD_CALL_PARENT(TRUE)
	for(var/ability in bound_xeno.actions)
		unregister_action(bound_xeno, ability)
	return

/datum/behavior_delegate/proc/register_action(action)
	SIGNAL_HANDLER
	RegisterSignal(action, COMSIG_XENO_ACTION_PRE_USE, PROC_REF(pre_ability_cast))
	RegisterSignal(action, COMSIG_XENO_ACTION_POST_USE, PROC_REF(post_ability_cast))

/datum/behavior_delegate/proc/unregister_action(owner, action)
	SIGNAL_HANDLER
	UnregisterSignal(action, COMSIG_XENO_ACTION_PRE_USE)
	UnregisterSignal(action, COMSIG_XENO_ACTION_POST_USE)

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
/**
 * Called just before an ability is used with every argument of said ability
 * ability : the ability that is about to be used
 */
/datum/behavior_delegate/proc/pre_ability_cast(datum/action/xeno_action/ability)
	SIGNAL_HANDLER
	return

/**
 * Called just after an ability is used
 * ability : the ability that was just used
 * result : value returned by the ability
 */
/datum/behavior_delegate/proc/post_ability_cast(datum/action/xeno_action/ability, result)
	SIGNAL_HANDLER
	return
