/*

A PROTOTYPE FOR MAKING ANY BULLET TRAITS

/** Element representing traits that can be applied to bullets upon being fired
 *
 * Must be attached to a projectile (`/obj/item/projectile` in `projectile.dm`)
 * Allows for the customization of bullet behavior based on ammo types or guns (or other things)
 */
// By convention, bullet_traits should be named bullet_trait_[insert rest of name here]
/datum/element/bullet_trait
	// General bullet trait vars
	// ALWAYS INCLUDE THESE TWO LINES IN THE BULLET TRAIT DEF
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

/datum/element/bullet_trait/databaseAttach(datum/target)
	. = ..()
	// All bullet traits can only be applied to projectiles
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	[handling here]
*/
