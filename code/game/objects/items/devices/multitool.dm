/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/multitool
	name = "\improper Security Access Tuner" //Thats what is is in-universe. From Alien: Isolation.
	desc = "A small handheld tool used to override various machine functions. Primarily used to pulse Airlock and APC wires on a shortwave frequency. It contains a small data buffer as well."
	icon_state = "multitool"
	item_state = "multitool"
	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = SPEED_VERY_FAST

	matter = list("metal" = 50,"glass" = 20)

	var/hack_speed = SECONDS_10 // Only used for vendors right now

/obj/item/device/multitool/attack(mob/M as mob, mob/user as mob, def_zone)
	return FALSE

/obj/item/device/multitool/afterattack(atom/target, mob/user, flag)
	for(var/obj/item/explosive/plastic/E in target.contents)
		E.attackby(src, user)
		return
	. = ..()