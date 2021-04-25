
// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = 0
	anchored = 1
	layer = FLY_LAYER

//Used by spraybottles.
/obj/effect/decal/chempuff
	name = "chemicals"
	icon = 'icons/effects/effects.dmi'
	icon_state = "chempuff"
	var/mob/source_user

/obj/effect/decal/chempuff/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH

/obj/effect/decal/chempuff/proc/move_towards(atom/A, move_delay = 3, tiles_left = 1)
	if(!step_towards(src, A))
		check_reactions(get_step(src, get_dir(src, A)))
	else
		check_reactions()
	tiles_left -= 1
	if(tiles_left)
		addtimer(CALLBACK(src, /obj/effect/decal/chempuff.proc/move_towards, A, move_delay, tiles_left), move_delay)
	else
		qdel(src)

/obj/effect/decal/chempuff/proc/check_reactions(turf/T)
	if(!reagents)
		return
	if(!T)
		T = get_turf(src)
	reagents.reaction(T)
	for(var/atom/A in T)
		reagents.reaction(A)

		// Are we hitting someone?
		if(ishuman(A))
			// Check what they are hit with
			var/reagent_list_text		// The list of reagents
			var/counter = 0				// Used for formatting
			var/log_spraying = FALSE	// If it worths logging
			for(var/X in reagents.reagent_list)
				var/datum/reagent/R = X
				// Is it a chemical we should log?
				if(R.spray_warning)
					if(counter == 0)
						reagent_list_text += "[R.name]"
					else
						reagent_list_text += ", [R.name]"

			// One or more bad reagents means we log it
			if(!counter)
				log_spraying = TRUE

			// Did we have a log-worthy spray? Then we log it
			if(log_spraying && source_user)
				var/mob/living/carbon/human/M = A
				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been sprayed with [name] (REAGENT: [reagent_list_text]) by [key_name(source_user)]</font>")
				source_user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used \a [name] (REAGENT: [reagent_list_text]) to spray [key_name(M)]</font>")
				msg_admin_attack("[key_name(source_user)] used \a [name] to spray [key_name(M)] with [name] (REAGENT: [reagent_list_text]) in [get_area(src)] ([loc.x],[loc.y],[loc.z]).", loc.x, loc.y, loc.z)

		if(istype(A, /obj/structure/machinery/portable_atmospherics/hydroponics) || istype(A, /obj/item/reagent_container/glass))
			reagents.trans_to(A)

/obj/effect/decal/mecha_wreckage
	name = "Exosuit wreckage"
	desc = "Remains of some unfortunate mecha. Completely unrepairable."
	icon = 'icons/obj/structures/props/mech.dmi'
	density = 1
	anchored = 0
	opacity = 0
	unacidable = FALSE

/obj/effect/decal/mecha_wreckage/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_HIGH_OVER_ONLY|PASS_AROUND

/obj/effect/decal/mecha_wreckage/ex_act(severity)
	if(severity > EXPLOSION_THRESHOLD_MEDIUM)
		qdel(src)
	return

/obj/effect/decal/mecha_wreckage/bullet_act(var/obj/item/projectile/Proj)
	return 1

/obj/effect/decal/mecha_wreckage/attack_alien(mob/living/carbon/Xenomorph/M)
	playsound(src, 'sound/effects/metal_crash.ogg', 50, 1)
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M] slices [src] apart!"), SPAN_DANGER("You slice [src] apart!"))
	robogibs(src)
	qdel(src)
	return XENO_ATTACK_ACTION

/obj/effect/decal/mecha_wreckage/gygax
	name = "Gygax wreckage"
	icon_state = "gygax-broken"

/obj/effect/decal/mecha_wreckage/gygax/dark
	name = "Dark Gygax wreckage"
	icon_state = "darkgygax-broken"

/obj/effect/decal/mecha_wreckage/marauder
	name = "Marauder wreckage"
	icon_state = "marauder-broken"

/obj/effect/decal/mecha_wreckage/mauler
	name = "Mauler Wreckage"
	icon_state = "mauler-broken"
	desc = "The syndicate won't be very happy about this..."

/obj/effect/decal/mecha_wreckage/seraph
	name = "Seraph wreckage"
	icon_state = "seraph-broken"

/obj/effect/decal/mecha_wreckage/ripley
	name = "Ripley wreckage"
	icon_state = "ripley-broken"

/obj/effect/decal/mecha_wreckage/ripley/firefighter
	name = "Firefighter wreckage"
	icon_state = "firefighter-broken"

/obj/effect/decal/mecha_wreckage/ripley/deathripley
	name = "Death-Ripley wreckage"
	icon_state = "deathripley-broken"

/obj/effect/decal/mecha_wreckage/durand
	name = "Durand wreckage"
	icon_state = "durand-broken"

/obj/effect/decal/mecha_wreckage/phazon
	name = "Phazon wreckage"
	icon_state = "phazon-broken"

/obj/effect/decal/mecha_wreckage/odysseus
	name = "Odysseus wreckage"
	icon_state = "odysseus-broken"

/obj/effect/decal/mecha_wreckage/hoverpod
	name = "Hover pod wreckage"
	icon_state = "engineering_pod-broken"
