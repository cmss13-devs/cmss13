/obj/structure/razorwire
	name = "razorwire"
	desc = "A mesh of metal strips with sharp edges whose purpose is to prevent passage by humans."
	icon = 'icons/obj/structures/razorwire.dmi'
	icon_state = "razorwire-"
	layer = BELOW_OBJ_LAYER

	var/yautja_slowdown = 0.1 SECONDS
	var/human_slowdown = 0.5 SECONDS
	var/xeno_slowdown = 0.3 SECONDS

/obj/structure/razorwire/Initialize()
	. = ..()
	for(var/direction in cardinal)
		var/turf/razor_turf = get_step(src, direction)
		var/obj/structure/razorwire/razor = locate() in razor_turf
		if(razor)
			razor.update_icon()
	update_icon()

/obj/structure/razorwire/update_icon()
	var/text_dirs = ""
	for(var/direction in cardinal)
		var/turf/razor_turf = get_step(src, direction)
		var/obj/structure/razorwire/razor = locate() in razor_turf
		if(razor)
			text_dirs += dir2text(direction)
	icon_state = "[initial(icon_state)][text_dirs]"

/obj/structure/razorwire/Crossed(var/atom/movable/moving_atom)
	. = ..()
	if(!moving_atom.throwing)
		if(isYautja(moving_atom))
			var/mob/living/carbon/human/yautja_mob = moving_atom
			yautja_mob.visible_message(SPAN_WARNING("\The [yautja_mob] deftly avoids \the [src]!"), SPAN_WARNING("You deftly avoid \the [src]!"), max_distance = 3)
			yautja_mob.next_move_slowdown = yautja_mob.next_move_slowdown + yautja_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		else if(ishuman(moving_atom))
			var/mob/living/carbon/human/human = moving_atom
			human.visible_message(SPAN_WARNING("\The [src] cuts into \the [human]'s legs, slowing them down!"), SPAN_WARNING("\The [src] cuts at your legs, slowing you down!"), max_distance = 3)
			human.next_move_slowdown = human.next_move_slowdown + human_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		else if(isXeno(moving_atom))
			var/mob/living/carbon/Xenomorph/xeno = moving_atom
			xeno.visible_message(SPAN_WARNING("\The [src] wraps around \the [xeno]'s legs, slowing it down!"), SPAN_WARNING("\The [src] wraps around your legs, slowing you down!"), max_distance = 3)
			xeno.next_move_slowdown = xeno.next_move_slowdown + xeno_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
