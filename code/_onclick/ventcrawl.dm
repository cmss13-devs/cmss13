/mob/living/proc/can_ventcrawl()
	return FALSE

/mob/living/proc/ventcrawl_carry()
	. = TRUE
	if(HAS_TRAIT(src, TRAIT_CRAWLER))
		return
	for(var/atom/A as anything in src)
		if(!(is_type_in_list(A, canEnterVentWith)))
			to_chat(src, SPAN_WARNING("We cannot be carrying items or have items equipped when vent crawling!"))
			return FALSE

/mob/living/click(atom/A, list/mods)
	if(..())
		return TRUE
	if(mods[ALT_CLICK])
		if(can_ventcrawl() && istype(A, /obj/structure/pipes/vents))
			handle_ventcrawl(A)
			return TRUE

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/structure/pipes/vents/V in range(1))
		if(Adjacent(V) && !V.welded)
			pipes |= V
	if(!LAZYLEN(pipes))
		to_chat(src, SPAN_WARNING("There are no pipes that we can ventcrawl into within range!"))
		return
	if(length(pipes) == 1)
		pipe = pipes[1]
	else
		pipe = tgui_input_list(usr, "Crawl Through Vent", "Pick a pipe", pipes)
	if(!is_mob_incapacitated() && pipe)
		return pipe

/mob/living/simple_animal/mouse/can_ventcrawl()
	return TRUE

/mob/living/simple_animal/spiderbot/can_ventcrawl()
	return TRUE

/mob/living/proc/handle_ventcrawl(atom/clicked_on)
	if(stat)
		to_chat(src, SPAN_WARNING("We must be conscious to do this!"))
		return

	if(is_mob_incapacitated())
		to_chat(src, SPAN_WARNING("We can't vent crawl while we are stunned!"))
		return

	var/obj/structure/pipes/vents/vent_found
	if(clicked_on && Adjacent(clicked_on))
		vent_found = clicked_on
		if(!istype(vent_found))
			vent_found = null

	if(!vent_found)
		vent_found = locate(/obj/structure/pipes/vents/) in range(1, src)

	if(!vent_found)
		to_chat(src, SPAN_WARNING("We must be standing on or beside an air vent to enter it."))
		return

	if(vent_found.welded)
		to_chat(src, SPAN_WARNING("This vent is closed off, we cannot climb through it."))
		return

	if(!ventcrawl_carry())
		return

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in vent_found.loc
	if(W)
		var/mob/living/carbon/xenomorph/X = src
		if(!istype(X) || X.hivenumber != W.linked_hive.hivenumber)
			to_chat(src, SPAN_WARNING("The weeds are blocking the entrance of this vent"))
			return

	if(length(vent_found.connected_to))
		if(src.action_busy)
			to_chat(src, SPAN_WARNING("We are already busy with something."))
			return

		visible_message(SPAN_NOTICE("[src] begins climbing into [vent_found]."), SPAN_NOTICE("We begin climbing into [vent_found]."))
		vent_found.animate_ventcrawl()
		if(!do_after(src, 45, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			vent_found.animate_ventcrawl_reset()
			return

		updatehealth()
		if(is_mob_incapacitated(src) || health < 0 || !client || !ventcrawl_carry())
			vent_found.animate_ventcrawl_reset()
			return

		vent_found.animate_ventcrawl_reset()
		visible_message(SPAN_DANGER("[src] scrambles into [vent_found]!"), SPAN_WARNING("You climb into [vent_found]."))
		playsound(src, pick('sound/effects/alien_ventpass1.ogg', 'sound/effects/alien_ventpass2.ogg'), 35, 1)
		forceMove(vent_found)
		update_pipe_icons(vent_found)
	else
		to_chat(src, SPAN_WARNING("This vent is not connected to anything."))

/mob/living/proc/update_pipe_icons(obj/structure/pipes/P)
	is_ventcrawling = TRUE

	if(!client)
		return

	for(var/obj/structure/pipes/next_pipe in P.connected_to)
		if(!next_pipe.pipe_vision_img)
			next_pipe.pipe_vision_img = image(next_pipe, next_pipe.loc, layer = BELOW_MOB_LAYER, dir = next_pipe.dir)
			next_pipe.pipe_vision_img.alpha = 180

		addToListNoDupe(pipes_shown, next_pipe.pipe_vision_img)
		client.images |= next_pipe.pipe_vision_img

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = FALSE

	if(!client)
		return

	for(var/image/pipe_image in pipes_shown)
		client.images -= pipe_image
	reset_view()

	pipes_shown = list()

/mob/living/proc/remove_specific_pipe_image(obj/structure/pipes/P)
	if(!client || !P || !P.pipe_vision_img)
		return

	var/image/pipe_image = P.pipe_vision_img
	if(pipe_image in pipes_shown)
		client.images -= pipe_image
