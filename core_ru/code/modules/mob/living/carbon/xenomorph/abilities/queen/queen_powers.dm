/datum/action/xeno_action/onclick/give_tech_points/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	if(world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(usr, SPAN_XENOWARNING("You must give some time for larva to spawn before sacrificing them. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK - world.time) / 600)] minutes."))
		return

	if(active)
		to_chat(usr, SPAN_XENOWARNING("We are stopped get points from larvae!"))
		return

	if(tgui_alert(user_xeno, "Do you really want to exchange your doughter for points?", "Sacrafice larvae?", list("Yes", "No")) != "Да")
		return

	if(user_xeno.hive.stored_larva < required_larva)
		to_chat(usr, SPAN_XENOWARNING("Not enought larvaes in core."))
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
		return

	xeno_message(SPAN_XENOANNOUNCE("Hive sacrafice larva for points! influx of points stop in [duration/600] minutes."), hivenumber = user_xeno.hive.hivenumber)
	xeno_maptext("Hive sacrafice larva for points!", "Hive evolution", user_xeno.hive.hivenumber)
	addtimer(CALLBACK(src, PROC_REF(end_boost), user_xeno), duration)
	active = TRUE

	var/datum/techtree/xeno_tree = GET_TREE(TREE_XENO)
	xeno_tree.give_points_over_time(to_give, duration)

	user_xeno.hive.stored_larva--
	user_xeno.hive.hive_ui.update_burrowed_larva()

	return ..()

/datum/action/xeno_action/onclick/give_tech_points/proc/end_boost(mob/living/carbon/xenomorph/queen/user_xeno)
	active = FALSE
	if(!user_xeno)
		return
	xeno_message(SPAN_XENOANNOUNCE("Hive stopped get points from sacrafice. Larvae will not be forgotten!"), hivenumber = user_xeno.hive.hivenumber)
	xeno_maptext("Hive stopped get points from sacrafice.", "Hive evolution", user_xeno.hive.hivenumber)
