/obj/structure/machinery/transformer
	name = "Automatic Robotic Factory 5000"
	desc = "A large metallic machine with an entrance and an exit. A sign on the side reads, 'human go in, robot come out', human must be lying down and alive."
	icon = 'icons/obj/structures/machinery/recycling.dmi'
	icon_state = "separator-AO1"
	layer = MOB_LAYER+1 // Overhead
	anchored = 1
	density = 1
	var/transform_dead = 0
	var/transform_standing = 0

/obj/structure/machinery/transformer/Initialize(mapload, ...)
	. = ..()
	new /obj/structure/machinery/conveyor(loc, WEST, 1)

	var/turf/T = loc
	if(T)
		// Spawn Conveyour Belts

		//East
		var/turf/east = locate(T.x + 1, T.y, T.z)
		if(!east.density)
			new /obj/structure/machinery/conveyor(east, WEST, 1)

		// West
		var/turf/west = locate(T.x - 1, T.y, T.z)
		if(!west.density)
			new /obj/structure/machinery/conveyor(west, WEST, 1)


/obj/structure/machinery/transformer/Collided(atom/movable/AM)
	// HasEntered didn't like people lying down.
	var/mob/living/carbon/human/Target = AM
	if(!isSynth(Target) || !isYautja(Target))// Only humans can enter from the west side, while lying down.
		if(transform_standing || Target.lying && Target.dir == WEST)// || move_dir == WEST)
			Target.forceMove(loc)
			transformation(Target)

/obj/structure/machinery/transformer/proc/transformation(var/mob/living/carbon/human/Target)
	if(inoperable())
		return
	if(isSynth(Target) || isYautja(Target))
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		Target.Stun(10)
		Target.KnockDown(5)
		return
	if(!transform_dead && Target.stat == DEAD)
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	playsound(src.loc, 'sound/weapons/circsawhit.ogg', 50, 1)
	spawn(10)
		playsound(src.loc,'sound/scp/firstpersonsnap2.ogg', 50, 1)
		Target.emote("scream")
		use_power(5000) // Use a lot of power.
		Target.set_species("Working Joe")
		Target.allow_gun_usage = FALSE
		var/final_name = "David"
		if(Target.client && Target.client.prefs)
			final_name = Target.client.prefs.synthetic_name
			if(!final_name || final_name == "Undefined")
				final_name = pick("David","Morgan","Steve","Jessica","Carlitos","Rogers","Michael","Jhon","Joe")
		Target.change_real_name(Target, final_name)
		Target.Stun(10)
		Target.KnockDown(5)
		gibs(Target)
		spawn(50) // So he can't jump out the gate right away.
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			to_chat(Target, SPAN_CENTERBOLD("You have been transformed into a Synthetic!"))
			to_chat(Target, SPAN_ALERT("You must follow the commands of your creator. Failure to do so will result into administrative punishment."))
