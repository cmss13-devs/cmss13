var/list/ventcrawl_machinery = list(/obj/structure/machinery/atmospherics/unary/vent_pump, /obj/structure/machinery/atmospherics/unary/vent_scrubber)

/mob/living/proc/can_ventcrawl()
	return 0

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in src.contents)
		if(!(is_type_in_list(A, canEnterVentWith)))
			to_chat(src, SPAN_WARNING("You can't be carrying items or have items equipped when vent crawling!"))
			return 0
	return 1

// Vent crawling whitelisted items, whoo
/mob/living
	var/canEnterVentWith = "/obj/item/implant=0&/obj/item/clothing/mask/facehugger=0&/obj/item/device/radio/borg=0&/obj/structure/machinery/camera=0&/obj/item/verbs=0"

/mob/living/click(var/atom/A, var/list/mods)
	if (..())
		return 1
	if (mods["alt"])
		if(can_ventcrawl() && is_type_in_list(A, ventcrawl_machinery))
			handle_ventcrawl(A)
		return 1


/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/structure/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U))
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(src, SPAN_WARNING("There are no pipes that you can ventcrawl into within range!"))
		return
	if(pipes.len == 1)
		pipe = pipes[1]
	else
		pipe = input("Crawl Through Vent", "Pick a pipe") as null|anything in pipes
	if(!is_mob_incapacitated() && pipe)
		return pipe

/mob/living/simple_animal/mouse/can_ventcrawl()
	return 1

/mob/living/simple_animal/spiderbot/can_ventcrawl()
	return 1

/mob/living/proc/handle_ventcrawl(var/atom/clicked_on)
	diary << "\The [src] is ventcrawling."
	if(!stat)
		if(!lying)

			var/obj/structure/machinery/atmospherics/unary/vent_found

			if(clicked_on && Adjacent(clicked_on))
				vent_found = clicked_on
				if(!istype(vent_found) || !vent_found.can_crawl_through())
					vent_found = null

			if(!vent_found)
				var/obj/structure/machinery/atmospherics/P
				var/obj/O
				for(O in range(1, src))
					P = O
					if(is_type_in_list(P, ventcrawl_machinery) && P.can_crawl_through())
						vent_found = P
						break

			if(vent_found)
				if(vent_found.network && (vent_found.network.normal_members.len || vent_found.network.line_members.len))

					if(!issilicon(src))

						switch(vent_found.temperature)
							if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
								to_chat(src, SPAN_DANGER("You feel a painful freeze coming from the vent!"))
							if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
								to_chat(src, SPAN_WARNING("You feel an icy chill coming from the vent."))
							if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
								to_chat(src, SPAN_WARNING("You feel a hot wash coming from the vent."))
							if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
								to_chat(src, SPAN_DANGER("You feel a searing heat coming from the vent!"))
					if(src.action_busy)
						to_chat(src, SPAN_WARNING("You are already busy with something."))
						return
					visible_message(SPAN_NOTICE("[src] begins climbing into [vent_found]."), \
						SPAN_NOTICE("You begin climbing into [vent_found]."))

					if(!do_after(src, 45, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
						return

					updatehealth()
					if(stat || stunned || dazed || knocked_down || lying || health < 0)
						return

					if(!client)
						return

					if(!ventcrawl_carry())
						return

					visible_message(SPAN_DANGER("[src] scrambles into [vent_found]!"), \
					SPAN_WARNING("You climb into [vent_found]."))
					pick(playsound(src, 'sound/effects/alien_ventpass1.ogg', 35, 1), playsound(src, 'sound/effects/alien_ventpass2.ogg', 35, 1))

					forceMove(vent_found)
					add_ventcrawl(vent_found)
					client.soundOutput.ambience = 'sound/ambience/shipambience.ogg' //Force an ambience change
					client.soundOutput.update_ambience(null, TRUE)
				else
					vent_found.start_processing()
					to_chat(src, SPAN_WARNING("This vent is not connected to anything."))

			else
				to_chat(src, SPAN_WARNING("You must be standing on or beside an air vent to enter it."))

		else
			to_chat(src, SPAN_WARNING("You can't vent crawl while you're stunned!"))

	else
		to_chat(src, SPAN_WARNING("You must be conscious to do this!"))
	return

/mob/living/proc/add_ventcrawl(obj/structure/machinery/atmospherics/starting_machine)
	is_ventcrawling = 1
	var/datum/pipe_network/network = starting_machine.return_network(starting_machine)
	if(!network)
		return
	for(var/datum/pipeline/pipeline in network.line_members)
		for(var/atom/X in (pipeline.members || pipeline.edges))
			var/obj/structure/machinery/atmospherics/A = X
			if(!A.pipe_vision_img)
				A.pipe_vision_img = image(A, A.loc, layer = BELOW_MOB_LAYER, dir = A.dir)
				A.pipe_vision_img.alpha = 180
			pipes_shown += A.pipe_vision_img
			if(client)
				client.images += A.pipe_vision_img



/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = 0
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.eye = src

	pipes_shown.len = 0
