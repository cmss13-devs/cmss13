/**
 * A master delegate which decides how to handle behaviours depending on their given delegates
 * If something breaks down try to look at the delegate in question before snowflaking anything here
 */
/datum/behavior_delegate/custom
	name = "Custom xeno behaviour delegate controller"
	/// The list of all delegates
	var/list/datum/behavior_delegate/delegates = list()

/datum/behavior_delegate/custom/New(list/delegate_paths, bound_xeno)
	src.bound_xeno = bound_xeno
	for(var/path as anything in delegate_paths)
		var/datum/behavior_delegate/new_delegate = new path
		new_delegate.bound_xeno = bound_xeno
		delegates += new_delegate

/datum/behavior_delegate/custom/Destroy(force, ...)
	for(var/delegate as anything in delegates)
		QDEL_NULL(delegate)
	. = ..()

/datum/behavior_delegate/custom/on_life()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_life()

/datum/behavior_delegate/custom/append_to_stat()
	. = list()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		. += delegate.append_to_stat()

/datum/behavior_delegate/custom/add_to_xeno()
	..()
	for(var/datum/behavior_delegate/delegate in delegates)
		delegate.add_to_xeno()

/datum/behavior_delegate/custom/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	var/list/original_damages = list()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		original_damages += delegate.melee_attack_modify_damage(original_damage, A)
	return original_damages.len ? max(original_damages) : original_damage

/datum/behavior_delegate/custom/melee_attack_additional_effects_target(mob/living/carbon/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.melee_attack_additional_effects_target(A)

/datum/behavior_delegate/custom/melee_attack_additional_effects_self()
	SEND_SIGNAL(bound_xeno, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.melee_attack_additional_effects_self()

/datum/behavior_delegate/custom/ranged_attack_on_hit()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_on_hit()

/datum/behavior_delegate/custom/ranged_attack_additional_effects_target(atom/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_additional_effects_target(A)

/datum/behavior_delegate/custom/ranged_attack_additional_effects_self(atom/A)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.ranged_attack_additional_effects_self(A)

/datum/behavior_delegate/custom/on_hitby_projectile(ammo)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_hitby_projectile(ammo)

/datum/behavior_delegate/custom/on_kill_mob(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.on_kill_mob(M)

/datum/behavior_delegate/custom/handle_slash(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.handle_slash(M)

/datum/behavior_delegate/custom/handle_death(mob/M)
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.handle_death(M)

/datum/behavior_delegate/custom/post_ability_cast(datum/action/xeno_action/ability, result)
	. = ..()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.post_ability_cast(ability, result)

/datum/behavior_delegate/custom/pre_ability_cast(datum/action/xeno_action/ability)
	. = ..()
	for(var/datum/behavior_delegate/delegate as anything in delegates)
		delegate.pre_ability_cast(ability)

/datum/behavior_delegate/custom/on_update_icons()
	var/results = list(TRUE)
	for(var/datum/behavior_delegate/delegate in delegates)
		results += delegate.on_update_icons()
	return min(results)
