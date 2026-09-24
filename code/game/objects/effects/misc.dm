//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items/gifts.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE






/obj/effect/mark
	var/mark = ""
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "blank"
	anchored = TRUE
	layer = 99
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE//Just to be sure.

/obj/effect/beam
	name = "beam"
	unacidable = TRUE//Just to be sure.
	var/def_zone

/obj/effect/beam/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_THROUGH

/obj/effect/list_container
	name = "list container"

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/effect/projection
	name = "Projection"
	desc = "This looks like a projection of something."
	anchored = TRUE


/obj/effect/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )




//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "exhaust"
	anchored = TRUE

/obj/effect/engine_exhaust/New(turf/nloc, ndir, temp)
	setDir(ndir)
	..(nloc)

	spawn(20)
		moveToNullspace()

/obj/effect/falling_pipe
	name = "falling pipe"
	icon = 'icons/obj/pipes/pipe_item.dmi'
	icon_state = "simple"
	dir = EAST
	layer = 100
	pixel_z = 192
	var/fall_duration = 1 SECONDS

/obj/effect/falling_pipe/Initialize(mapload, mob/shooter)
	. = ..()
	visible_message(SPAN_HIGHDANGER("A pipe breaks loose from the ceiling!"))
	animate(src, pixel_z = 0, time = fall_duration, easing = QUAD_EASING|EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(land), shooter), fall_duration)

/obj/effect/falling_pipe/proc/land(mob/shooter)
	var/turf/landing_turf = get_turf(src)
	if(!isfloorturf(landing_turf))
		qdel(src)
		return

	var/obj/item/pipe/fallen_pipe = new(landing_turf, 0, dir)
	fallen_pipe.name = "fallen pipe"
	fallen_pipe.desc = "A section of overhead piping. It seems to have a rather large bullet hole in it..."
	playsound(landing_turf, get_sfx("pipe_crash"), 100, FALSE)
	for(var/mob/living/carbon/human/victim in landing_turf)
		if(!victim.get_limb("head"))
			continue

		victim.visible_message(
			SPAN_HIGHDANGER("CLANG! The pipe lands directly on [victim]'s head!"),
			SPAN_HIGHDANGER("OWH FUCK THE PIPE LANDS DIRECTLY ON YOUR HEAD!!")
		)
		victim.emote("scream")
		victim.apply_damage(50, BRUTE, "head", used_weapon = fallen_pipe, firer = shooter)
		victim.EyeBlur(10)
		victim.Stun(5)
		victim.KnockDown(5)
		qdel(src)
		return

	visible_message(SPAN_HIGHDANGER("CLANG! The pipe crashes onto the deck."))
	qdel(src)

/obj/effect/falling_bird
	name = "falling bird"
	icon = 'icons/mob/animal.dmi'
	icon_state = "parrot_dead"
	layer = 100
	pixel_z = 192

/obj/effect/falling_bird/Initialize(mapload, mob/shooter)
	. = ..()
	visible_message(SPAN_WARNING("A bird tumbles out of the sky!"))
	animate(src, pixel_z = 0, time = 3 SECONDS, easing = QUAD_EASING|EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(land), shooter), 3 SECONDS)

/obj/effect/falling_bird/proc/land(mob/shooter)
	var/turf/landing_turf = get_turf(src)
	if(!istype(landing_turf, /turf/open))
		qdel(src)
		return

	var/obj/item/dead_bird/bird = new(landing_turf)
	playsound(landing_turf, 'sound/effects/gibbed.ogg', 60, FALSE)
	for(var/mob/living/carbon/human/victim in landing_turf)
		if(!victim.get_limb("head"))
			continue

		victim.visible_message(
			SPAN_WARNING("SPLAT! A dead bird lands on [victim]'s head!"),
			SPAN_WARNING("SPLAT! A dead bird lands on your head. Great shot.")
		)
		victim.apply_damage(5, BRUTE, "head", used_weapon = bird, firer = shooter)
		qdel(src)
		return

	visible_message(SPAN_WARNING("SPLAT! The bird hits the ground."))
	qdel(src)
