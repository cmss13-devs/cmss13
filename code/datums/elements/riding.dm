/**
 * This element is used to indicate that a movable atom can be mounted by mobs in order to ride it. The movable is considered mounted when a mob is buckled to it,
 * at which point a [riding component][/datum/component/riding] is created on the movable, and that component handles the actual riding behavior.
 *
 * Besides the target, the ridable element has one argument: the component subtype. This is not really ideal since there's ~20-30 component subtypes rather than
 * having the behavior defined on the ridable atoms themselves or some such, but because the old riding behavior was so horrifyingly spread out and redundant,
 * just having the variables, behavior, and procs be standardized is still a big improvement.
 */
/datum/element/ridable
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// The specific riding component subtype we're loading our instructions from, don't leave this as default please!
	var/riding_component_type = /datum/component/riding

/datum/element/ridable/Attach(atom/movable/target, component_type = /datum/component/riding)
	. = ..()
	if(!ismovable(target))
		return COMPONENT_INCOMPATIBLE

	if(component_type == /datum/component/riding)
		stack_trace("Tried attaching a ridable element to [target] with basic/abstract /datum/component/riding component type. Please designate a specific riding component subtype when adding the ridable element.")
		return COMPONENT_INCOMPATIBLE

	riding_component_type = component_type

	RegisterSignal(target, COMSIG_MOVABLE_PREBUCKLE, PROC_REF(check_mounting))

/datum/element/ridable/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_MOVABLE_PREBUCKLE, COMSIG_PARENT_ATTACKBY))
	return ..()

/// Someone is buckling to this movable, which is literally the only thing we care about
/datum/element/ridable/proc/check_mounting(atom/movable/target_movable, mob/user, mob/potential_rider, ride_check_flags, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	SIGNAL_HANDLER

	if(HAS_TRAIT(potential_rider, TRAIT_CANT_RIDE))
		return

	if(target_hands_needed && !equip_buckle_inhands(potential_rider, target_hands_needed, target_movable)) // can be either 1 (cyborg riding) or 2 (human piggybacking) hands
		potential_rider.visible_message(SPAN_WARNING("[potential_rider] can't get a grip on [target_movable] because [potential_rider.p_their()] hands are full!"),
			SPAN_WARNING("You can't get a grip on [target_movable] because your hands are full!"))
		return COMPONENT_BLOCK_BUCKLE

	if((ride_check_flags & RIDER_NEEDS_LEGS) && HAS_TRAIT(potential_rider, TRAIT_FLOORED))
		potential_rider.visible_message(SPAN_WARNING("[potential_rider] can't get [potential_rider.p_their()] footing on [target_movable]!"),
			SPAN_WARNING("You can't get your footing on [target_movable]!"))
		return COMPONENT_BLOCK_BUCKLE

	var/mob/living/target_living = target_movable

	// need to see if !equip_buckle_inhands() checks are enough to skip any needed incapac/restrain checks
	// CARRIER_NEEDS_ARM shouldn't apply if the ridden isn't even a living mob
	if(hands_needed && !equip_buckle_inhands(target_living, hands_needed, target_living, potential_rider))
		target_living.visible_message(SPAN_WARNING("[target_living] can't get a grip on [potential_rider] because [target_living.p_their()] hands are full!"),
			SPAN_WARNING("You can't get a grip on [potential_rider] because your hands are full!"))
		return COMPONENT_BLOCK_BUCKLE

	target_living.AddComponent(riding_component_type, potential_rider, force, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)

/// Try putting the appropriate number of [riding offhand items][/obj/item/riding_offhand] into the target's hands, return FALSE if we can't
/datum/element/ridable/proc/equip_buckle_inhands(mob/living/carbon/human/user, amount_required = 1, atom/movable/target_movable, riding_target_override = null)
	var/amount_equipped = 0
	for(var/amount_needed = amount_required, amount_needed > 0, amount_needed--)
		var/obj/item/riding_offhand/inhand = new /obj/item/riding_offhand(user)
		if(!riding_target_override)
			inhand.rider = user
		else
			inhand.rider = riding_target_override
		inhand.parent = target_movable

		if(user.put_in_hands(inhand))
			amount_equipped++
		else
			qdel(inhand)
			break

	if(amount_equipped >= amount_required)
		return TRUE
	else
		unequip_buckle_inhands(user, target_movable)
		return FALSE


/// Remove all of the relevant [riding offhand items][/obj/item/riding_offhand] from the target
/datum/element/ridable/proc/unequip_buckle_inhands(mob/living/carbon/user, atom/movable/target_movable)
	for(var/obj/item/riding_offhand/reins in user)
		if(reins.selfdeleting)
			continue
		qdel(reins)
	return TRUE




/obj/item/riding_offhand
	name = "offhand"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "offhand"
	w_class = SIZE_HUGE
	flags_item = ITEM_ABSTRACT | DELONDROP | NOBLUDGEON
	var/mob/living/carbon/rider
	var/mob/living/parent
	var/selfdeleting = FALSE

/obj/item/riding_offhand/Initialize()
	. = ..()
	rider = loc

/obj/item/riding_offhand/dropped()
	selfdeleting = TRUE
	return ..()

/obj/item/riding_offhand/equipped()
	if(loc != rider && loc != parent)
		selfdeleting = TRUE
		qdel(src)
	return ..()

/obj/item/riding_offhand/Destroy()
	if(selfdeleting && parent)
		if(rider in parent.buckled_mobs)
			rider.send_unbuckling_message(rider, rider, parent)
			parent.unbuckle(rider)
	. =..()
	rider = null
	parent = null
