/// Does a pixel shift animation towards a specific target
/datum/element/pixel_shifting

/**
 * Function to attach the `shifting` element to the effect
 *
 * Params:
 * - target (/datum): The effect we are attaching to, should be of type /obj/effect unless you messed up
 * - to_shift_towards (/atom): The atom the effect will pixel shift towards
 * - distance_ratio (num): The percentage of the distance between the effect and `to_shift_towards` that the effect should cover (0 <= distance_ratio <= 1)
 * - duration (num): Duration of the animation (i.e. how fast the effect will pixel shift to its destination)
 */
/datum/element/pixel_shifting/Attach(datum/target, atom/to_shift_towards, distance_ratio = 1, duration)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	if (!istype(target, /obj/effect))
		return ELEMENT_INCOMPATIBLE
	if (!istype(to_shift_towards))
		return ELEMENT_INCOMPATIBLE
	var/obj/effect/effect = target
	var/x_displacement = floor((to_shift_towards.x - effect.x) * distance_ratio * world.icon_size)
	var/y_displacement = floor((to_shift_towards.y - effect.y) * distance_ratio * world.icon_size)
	animate(target, pixel_x = x_displacement, pixel_y = y_displacement, time = duration)
