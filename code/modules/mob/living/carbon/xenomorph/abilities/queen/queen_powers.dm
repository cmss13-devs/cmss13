// devolve a xeno - lots of old, vaguely shitty code here
/datum/action/xeno_action/onclick/manage_hive/proc/de_evolve_other()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_devolve = 500
	if(!user_xeno.check_state())
		return
	if(!user_xeno.observed_xeno)
		to_chat(user_xeno, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))
		return

	var/mob/living/carbon/xenomorph/target_xeno = user_xeno.observed_xeno
	if(!user_xeno.check_plasma(plasma_cost_devolve))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] не принадлежит вашему улью!")) // SS220 EDIT ADDICTION
		return
	if(target_xeno.is_ventcrawling)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] не может быть регрессирован здесь.")) // SS220 EDIT ADDICTION
		return
	if(!isturf(target_xeno.loc))
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] не может быть регрессирован здесь.")) // SS220 EDIT ADDICTION
		return
	if(target_xeno.health <= 0)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] слишком слаб, чтобы быть регрессированным.")) // SS220 EDIT ADDICTION
		return
	if(length(target_xeno.caste.deevolves_to) < 1)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] не может быть регрессирован.")) // SS220 EDIT ADDICTION
		return
	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] изгнан и не может быть регрессирован.")) // SS220 EDIT ADDICTION
		return


	var/newcaste
	if(length(target_xeno.caste.deevolves_to) == 1)
		newcaste = target_xeno.caste.deevolves_to[1]
	else if(length(target_xeno.caste.deevolves_to) > 1)
		newcaste = tgui_input_list(user_xeno, "Choose a caste you want to de-evolve [target_xeno] to.", "De-evolve", target_xeno.caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return
	if(newcaste == XENO_CASTE_LARVA)
		to_chat(user_xeno, SPAN_XENOWARNING("Вы не можете регрессировать ксеноморфов до грудоломов."))
		return
	if(user_xeno.observed_xeno != target_xeno)
		return

	var/confirm = tgui_alert(user_xeno, "Вы уверены, что хотите регрессировать [target_xeno] из [target_xeno.caste.caste_type] в [newcaste]?", "Регрессирование", list("Да", "Нет")) // SS220 EDIT ADDICTION
	if(confirm == "Нет") // SS220 EDIT ADDICTION
		return

	var/reason = stripped_input(user_xeno, "Укажите причину регрессирования этого ксеноморфа, [target_xeno]") // SS220 EDIT ADDICTION
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("Вы должны указать причину регрессирования [target_xeno].")) // SS220 EDIT ADDICTION
		return

	if(!check_and_use_plasma_owner(plasma_cost))
		return


	to_chat(target_xeno, SPAN_XENOWARNING("Королева регрессировала вас по причине: [reason]")) // SS220 EDIT ADDICTION

	SEND_SIGNAL(target_xeno, COMSIG_XENO_DEEVOLVE)

	var/mob/living/carbon/xenomorph/new_xeno = target_xeno.transmute(newcaste)

	if(new_xeno)
		message_admins("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")
		log_admin("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")

		if(user_xeno.hive.living_xeno_queen && user_xeno.hive.living_xeno_queen.observed_xeno == target_xeno)
			user_xeno.hive.living_xeno_queen.overwatch(new_xeno)

		if(new_xeno.ckey)
			GLOB.deevolved_ckeys += new_xeno.ckey

/datum/action/xeno_action/onclick/remove_eggsac/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		return
	var/answer = alert(X, "Are you sure you want to remove your ovipositor? (5min cooldown to grow a new one)", , "Yes", "No")
	if(answer != "Yes")
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.visible_message(SPAN_XENOWARNING("[X] начинает отделяться от своего яйцеклада!"), // SS220 EDIT ADDICTION
		SPAN_XENOWARNING("Вы начинаете отделяться от своего яйцеклада."))
	if(!do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10))
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!xeno.check_state())
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf || !istype(current_turf))
		return

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_XENOWARNING("Вы всё ещё восстанавливаетесь после отделения от яйцеклада. Подождите [DisplayTimeText(timeleft(cooldown_timer_id))].")) // SS220 EDIT ADDICTION
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("Вам нужно быть на смоле, чтобы создать яйцеклад."))
		return

	if(SSinterior.in_interior(xeno))
		to_chat(xeno, SPAN_XENOWARNING("Здесь слишком тесно, чтобы создать яйцеклад."))
		return

	if(alien_weeds.linked_hive.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("Эта трава не принадлежат вашему улью! Вы не можете создать яйцеклад здесь."))
		return

	var/area/current_area = get_area(xeno)
	if(current_area.unoviable_timer)
		to_chat(xeno, SPAN_XENOWARNING("Это место не подходит для создания яйцеклада."))
		return

	if(!xeno.check_alien_construction(current_turf))
		return

	if(xeno.action_busy)
		return

	if(!xeno.check_plasma(plasma_cost))
		return

	xeno.visible_message(SPAN_XENOWARNING("[capitalize(xeno.declent_ru(NOMINATIVE))] начинает создавать яйцеклад..."), // SS220 EDIT ADDICTION
	SPAN_XENOWARNING("Вы начинаете создавать яйцеклад... (это займёт 20 секунд, не двигайтесь)"))
	if(!do_after(xeno, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && xeno.check_plasma(plasma_cost))
		return
	if(!xeno.check_state())
		return
	if(!locate(/obj/effect/alien/weeds) in current_turf)
		return
	xeno.use_plasma(plasma_cost)
	xeno.visible_message(SPAN_XENOWARNING("[capitalize(xeno.declent_ru(NOMINATIVE))] создаёт яйцеклад!"), // SS220 EDIT ADDICTION
	SPAN_XENOWARNING("Вы создаёте яйцеклад!"))
	xeno.mount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/set_xeno_lead/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return
	var/datum/hive_status/hive = xeno.hive
	if(xeno.observed_xeno)
		if(!length(hive.open_xeno_leader_positions) && IS_NORMAL_XENO(xeno.observed_xeno))
			to_chat(xeno, SPAN_XENOWARNING("В настоящее время у вас есть [length(hive.xeno_leader_list)] лидеров. Вы не можете иметь больше лидеров, пока ваша сила не возрастёт.")) // SS220 EDIT ADDICTION
			return
		var/mob/living/carbon/xenomorph/targeted_xeno = xeno.observed_xeno
		if(targeted_xeno == xeno)
			to_chat(xeno, SPAN_XENOWARNING("Вы не можете сделать себя лидером!"))
			return
		apply_cooldown()
		if(IS_NORMAL_XENO(targeted_xeno))
			if(!hive.add_hive_leader(targeted_xeno))
				to_chat(xeno, SPAN_XENOWARNING("Невозможно добавить лидера."))
				return
			if(targeted_xeno.stat == DEAD)
				to_chat(xeno, SPAN_XENOWARNING("Вы не можете сделать лидером мёртвых."))
				return
			to_chat(xeno, SPAN_XENONOTICE("Вы выбрали [targeted_xeno.declent_ru(ACCUSATIVE)] в качестве лидера улья.")) // SS220 EDIT ADDICTION
			to_chat(targeted_xeno, SPAN_XENOANNOUNCE("[capitalize(xeno.declent_ru(NOMINATIVE))] выбрала вас в качестве лидера улья. Другие ксеноморфы должны слушаться вас. Вы также будете служить маяком для феромонов Королевы.")) // SS220 EDIT ADDICTION
		else
			hive.remove_hive_leader(targeted_xeno)
			to_chat(xeno, SPAN_XENONOTICE("Вы сняли [targeted_xeno.declent_ru(ACCUSATIVE)] с должности лидера улья.")) // SS220 EDIT ADDICTION
			to_chat(targeted_xeno, SPAN_XENOANNOUNCE("[capitalize(xeno.declent_ru(NOMINATIVE))] сняла вас с должности лидера улья. Ваши права и способности лидера отозваны.")) // SS220 EDIT ADDICTION
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/xenomorph/targeted_xeno in hive.xeno_leader_list)
			possible_xenos += targeted_xeno

		if(length(possible_xenos) > 1)
			var/mob/living/carbon/xenomorph/selected_xeno = tgui_input_list(xeno, "Target", "За каким лидером вы хотите следить?", possible_xenos, theme="hive_status") // SS220 EDIT ADDICTION
			if(!selected_xeno || IS_NORMAL_XENO(selected_xeno) || selected_xeno == xeno.observed_xeno || selected_xeno.stat == DEAD || !xeno.check_state())
				return
			xeno.overwatch(selected_xeno)
		else if(length(possible_xenos))
			xeno.overwatch(possible_xenos[1])
		else
			to_chat(xeno, SPAN_XENOWARNING("Сейчас нет лидеров ксеноморфов. Наблюдайте за ксеноморфом, чтобы сделать его лидером."))
	return ..()

/datum/action/xeno_action/activable/queen_heal/use_ability(atom/target, verbose)
	var/mob/living/carbon/xenomorph/queen/queen = owner
	if(!queen.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		to_chat(queen, SPAN_WARNING("You must select a valid turf to heal around."))
		return

	if(!SSmapping.same_z_map(queen.loc.z, target_turf.loc.z))
		to_chat(queen, SPAN_XENOWARNING("Вы слишком далеко, чтобы сделать это здесь."))
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/xenomorph/current_xeno in range(4, target_turf))
		if(!queen.can_not_harm(current_xeno))
			continue

		if(SEND_SIGNAL(current_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			if(verbose)
				to_chat(queen, SPAN_XENOMINORWARNING("You cannot heal [current_xeno]!"))
			continue

		if(current_xeno == queen)
			continue

		if(current_xeno.stat == DEAD || QDELETED(current_xeno))
			continue

		if(!current_xeno.caste.can_be_queen_healed)
			continue

		new /datum/effects/heal_over_time(current_xeno, current_xeno.maxHealth * 0.3, 2 SECONDS, 2)
		current_xeno.flick_heal_overlay(3 SECONDS, "#D9F500") //it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(queen, SPAN_XENONOTICE("Вы направляете свою плазму, чтобы исцелить раны ваших сестер в этой области."))
	return ..()

/datum/action/xeno_action/onclick/manage_hive/proc/give_evo_points()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_givepoints = 100


	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_givepoints))
		return

	if(world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(usr, SPAN_XENOWARNING("Вы должны дать немного времени для появления грудоломов, прежде чем жертвовать ими. Пожалуйста, подождите ещё [floor((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK - world.time) / 600)] минут.")) // SS220 EDIT ADDICTION
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to give evolution points for a burrowed larva:", "Give Evolution Points", user_xeno.hive.totalXenos, theme="hive_status")

	if(!choice)
		return
	var/evo_points_per_larva = 250
	var/required_larva = 1
	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("Вы не можете дать очки эволюции себе."))
		return

	if(target_xeno.evolution_stored == target_xeno.evolution_threshold)
		to_chat(user_xeno, SPAN_XENOWARNING("Этот ксеноморф уже эволюционирует!"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("Этот ксеноморф не принадлежит вашему улью!"))
		return

	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("В чём смысл? Они вот-вот умрут."))
		return

	if(user_xeno.hive.stored_larva < required_larva)
		to_chat(user_xeno, SPAN_XENOWARNING("Вам нужно как минимум [required_larva] зарывшихся грудоломов, чтобы пожертвовать одного ради очков эволюции.")) // SS220 EDIT ADDICTION
		return

	if(tgui_alert(user_xeno, "Are you sure you want to sacrifice a larva to give [target_xeno] [evo_points_per_larva] evolution points?", "Give Evolution Points", list("Yes", "No")) != "Yes")
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0 || user_xeno.hive.stored_larva < required_larva)
		return

	to_chat(target_xeno, SPAN_XENOWARNING("[user_xeno] дала вам очки эволюции! Используйте их с умом.")) // SS220 EDIT ADDICTION
	to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] получил [evo_points_per_larva] очков эволюции.")) // SS220 EDIT ADDICTION

	if(target_xeno.evolution_stored + evo_points_per_larva > target_xeno.evolution_threshold)
		target_xeno.evolution_stored = target_xeno.evolution_threshold
	else
		target_xeno.evolution_stored += evo_points_per_larva

	user_xeno.hive.stored_larva--
	return



/datum/action/xeno_action/onclick/manage_hive/proc/give_jelly_reward()
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	var/plasma_cost_jelly = 500
	if(!xeno.check_state())
		return
	if(!xeno.check_plasma(plasma_cost_jelly))
		return
	if(give_jelly_award(xeno.hive))
		xeno.use_plasma(plasma_cost_jelly)
		return

/datum/action/xeno_action/onclick/send_thoughts/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/thought_sender = owner
	var/static/list/options = list(
		"Psychic Radiance (100)" = icon(/datum/action/xeno_action::icon_file, "psychic_radiance"),
		"Psychic Whisper (0)" = icon(/datum/action/xeno_action::icon_file, "psychic_whisper"),
		"Give Order (100)" = icon(/datum/action/xeno_action::icon_file, "queen_order")
	)

	var/choice
	if(thought_sender.client?.prefs.no_radials_preference)
		choice = tgui_input_list(thought_sender, "Communicate", "Send Thoughts", options, theme="hive_status")
	else
		choice = show_radial_menu(thought_sender, thought_sender?.client.eye, options)

	if(!choice)
		return

	plasma_cost = 0
	switch(choice)
		if("Psychic Radiance (100)")
			psychic_radiance()
		if("Psychic Whisper (0)")
			psychic_whisper()
		if("Give Order (100)")
			queen_order()
	return ..()

/datum/action/xeno_action/onclick/manage_hive/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/queen_manager = owner
	plasma_cost = 0
	var/list/options = list("Banish (500)", "Re-Admit (100)", "De-evolve (500)", "Reward Jelly (500)", "Exchange larva for evolution (100)", "Permissions", "Purchase Buffs")
	if(queen_manager.hive.hivenumber == XENO_HIVE_CORRUPTED)
		var/datum/hive_status/corrupted/hive = queen_manager.hive
		options += "Add Personal Ally"
		if(length(hive.personal_allies))
			options += "Remove Personal Ally"
			options += "Clear Personal Allies"

	if(queen_manager.hive.hivenumber == XENO_HIVE_NORMAL)
		options += "Edit Tacmap"

	var/choice = tgui_input_list(queen_manager, "Manage The Hive", "Hive Management", options, theme="hive_status")
	switch(choice)
		if("Banish (500)")
			banish()
		if("Re-Admit (100)")
			readmit()
		if("De-evolve (500)")
			de_evolve_other()
		if("Reward Jelly (500)")
			give_jelly_reward(queen_manager.hive)
		if("Exchange larva for evolution (100)")
			give_evo_points()
		if("Add Personal Ally")
			add_personal_ally()
		if("Remove Personal Ally")
			remove_personal_ally()
		if("Clear Personal Allies")
			clear_personal_allies()
		if("Permissions")
			permissions()
		if("Purchase Buffs")
			purchase_buffs()
		if("Edit Tacmap")
			edit_tacmap()
	return ..()

/datum/action/xeno_action/onclick/manage_hive/proc/edit_tacmap()
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	var/datum/component/tacmap/tacmap_component = xeno.GetComponent(/datum/component/tacmap)

	if(xeno in tacmap_component.interactees)
		tacmap_component.on_unset_interaction(xeno)
	else
		tacmap_component.show_tacmap(xeno)

/datum/action/xeno_action/onclick/manage_hive/proc/permissions()
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	var/choice = tgui_input_list(xeno, "Choose what hive permissions to change.", "Hive Permissions", list("Harming", "Construction", "Deconstruction", "Unnesting"), theme="hive_status")
	switch(choice)
		if("Harming")
			xeno.claw_toggle()
		if("Construction")
			xeno.construction_toggle()
		if("Deconstruction")
			xeno.destruction_toggle()
		if("Unnesting")
			xeno.unnesting_toggle()

/datum/action/xeno_action/onclick/manage_hive/proc/purchase_buffs()
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	var/list/datum/hivebuff/buffs = list()
	var/list/names = list()
	var/list/radial_images = list()
	var/major_available = FALSE
	for(var/datum/hivebuff/buff as anything in xeno.hive.get_available_hivebuffs())
		var/buffname = initial(buff.name)
		names += buffname
		buffs[buffname] = buff
		if(!major_available)
			if(initial(buff.tier) == HIVEBUFF_TIER_MAJOR)
				major_available = TRUE

	if(!length(buffs))
		to_chat(xeno, SPAN_XENONOTICE("Нет доступных благословений!"))
		return

	var/selection
	var/list/radial_images_tiers = list(HIVEBUFF_TIER_MINOR = image('icons/ui_icons/hivebuff_radial.dmi', "minor"), HIVEBUFF_TIER_MAJOR = image('icons/ui_icons/hivebuff_radial.dmi', "major"))

	if(xeno.client?.prefs?.no_radials_preference)
		selection = tgui_input_list(xeno, "Pick a buff.", "Select Buff", names)
	else
		var/tier = HIVEBUFF_TIER_MINOR
		if(major_available)
			tier = show_radial_menu(xeno, xeno?.client?.eye, radial_images_tiers)

		if(tier == HIVEBUFF_TIER_MAJOR)
			for(var/filtered_buffname as anything in buffs)
				var/datum/hivebuff/filtered_buff = buffs[filtered_buffname]
				if(initial(filtered_buff.tier) == HIVEBUFF_TIER_MAJOR)
					radial_images[initial(filtered_buff.name)] += image(initial(filtered_buff.hivebuff_radial_dmi), initial(filtered_buff.radial_icon))
		else
			for(var/filtered_buffname as anything in buffs)
				var/datum/hivebuff/filtered_buff = buffs[filtered_buffname]
				if(initial(filtered_buff.tier) == HIVEBUFF_TIER_MINOR)
					radial_images[initial(filtered_buff.name)] += image(initial(filtered_buff.hivebuff_radial_dmi), initial(filtered_buff.radial_icon))

		selection = show_radial_menu(xeno, xeno?.client?.eye, radial_images, radius = 72, tooltips = TRUE)

	if(!selection)
		return FALSE

	if(!buffs[selection])
		to_chat(xeno, "This selection is impossible!")
		return FALSE

	if(buffs[selection].must_select_pylon)
		var/list/pylon_to_area_dictionary = list()
		for(var/obj/effect/alien/resin/special/pylon/endgame/pylon as anything in xeno.hive.active_endgame_pylons)
			pylon_to_area_dictionary[get_area_name(pylon.loc)] = pylon

		var/choice = tgui_input_list(xeno, "Select a pylon for the buff:", "Choice", pylon_to_area_dictionary, 1 MINUTES)

		if(!choice)
			to_chat(xeno, "You must choose a pylon.")
			return FALSE

		xeno.hive.attempt_apply_hivebuff(buffs[selection], xeno, pylon_to_area_dictionary[choice])
		return TRUE

	xeno.hive.attempt_apply_hivebuff(buffs[selection], xeno, pick(xeno.hive.active_endgame_pylons))
	return TRUE

/datum/action/xeno_action/onclick/manage_hive/proc/add_personal_ally()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive
	var/list/target_list = list()
	if(!user_xeno.client)
		return
	for(var/mob/living/carbon/human/possible_target in range(7, user_xeno.client.eye))
		if(possible_target.stat == DEAD)
			continue
		if(possible_target.status_flags & CORRUPTED_ALLY)
			continue
		if(possible_target.hivenumber)
			continue
		target_list += possible_target

	if(!length(target_list))
		to_chat(user_xeno, SPAN_WARNING("No talls in view."))
		return
	var/mob/living/target_mob = tgui_input_list(usr, "Target", "Set Up a Personal Alliance With...", target_list, theme="hive_status")

	if(!user_xeno.check_state(TRUE))
		return

	if(!target_mob)
		return

	if(target_mob.hivenumber)
		to_chat(user_xeno, SPAN_WARNING("We cannot set up a personal alliance with a hive cultist."))
		return

	hive.add_personal_ally(target_mob)

/datum/action/xeno_action/onclick/manage_hive/proc/remove_personal_ally()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive

	if(!length(hive.personal_allies))
		to_chat(user_xeno, SPAN_WARNING("We don't have personal allies."))
		return

	var/list/mob/living/allies = list()
	var/list/datum/weakref/dead_refs = list()
	for(var/datum/weakref/ally_ref as anything in hive.personal_allies)
		var/mob/living/ally = ally_ref.resolve()
		if(ally)
			allies += ally
			continue
		dead_refs += ally_ref

	hive.personal_allies -= dead_refs

	if(!length(allies))
		to_chat(user_xeno, SPAN_WARNING("We don't have personal allies."))
		return

	var/mob/living/target_mob = tgui_input_list(usr, "Target", "Break the Personal Alliance With...", allies, theme="hive_status")

	if(!target_mob)
		return

	var/target_mob_ref = WEAKREF(target_mob)

	if(!(target_mob_ref in hive.personal_allies))
		return

	if(!user_xeno.check_state(TRUE))
		return

	hive.remove_personal_ally(target_mob_ref)

/datum/action/xeno_action/onclick/manage_hive/proc/clear_personal_allies()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive
	if(!length(hive.personal_allies))
		to_chat(user_xeno, SPAN_WARNING("We don't have personal allies."))
		return

	if(tgui_alert(user_xeno, "Вы уверены, что хотите отменить личные союзы?", "Отмена личных союзов", list("Да", "Нет"), 10 SECONDS) == "Нет") // SS220 EDIT ADDICTION
		return

	if(!length(hive.personal_allies))
		return

	hive.clear_personal_allies()


/datum/action/xeno_action/onclick/manage_hive/proc/banish()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_banish = 500
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_banish))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to banish:", "Banish", user_xeno.hive.totalXenos, theme="hive_status")

	if(!choice)
		return

	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("Вы не можете изгнать самого себя."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("Этот ксеноморф уже изгнан!"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("Этот ксеноморф не принадлежит вашему улью!"))
		return

	// No banishing critted xenos
	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("В чём смысл? Они вот-вот умрут."))
		return

	var/confirm = tgui_alert(user_xeno, "Вы уверены, что хотите изгнать [target_xeno] из улья? Это следует делать ради забавы (Обратите внимание, что они также не смогут вернуться в улей после смерти в течение 30 минут)", "Изгнание", list("Да", "Нет")) // SS220 EDIT ADDICTION
	if(confirm == "Нет") // SS220 EDIT ADDICTION
		return

	var/reason = stripped_input(user_xeno, "Укажите причину изгнания [target_xeno]. Это будет объявлено всему улью!") // SS220 EDIT ADDICTION
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("Вы должны указать причину изгнания [target_xeno].")) // SS220 EDIT ADDICTION
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost_banish) || target_xeno.health < 0)
		return

	// Let everyone know they were banished
	xeno_announcement("По воле [user_xeno], [target_xeno] изгоняется из улья!<br><br>[reason]", user_xeno.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment")) // SS220 EDIT ADDICTION
	to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("Королева [user_xeno] изгнала тебя из улья! Теперь другие ксеноморфы могут свободно нападать на тебя, но твоя связь с коллективным разумом улья остаётся, не позволяя тебе причинять вред другим сёстрам."))) // SS220 EDIT ADDICTION

	target_xeno.banished = TRUE
	target_xeno.hud_update_banished()
	target_xeno.lock_evolve = TRUE
	user_xeno.hive.banished_ckeys[target_xeno.name] = target_xeno.ckey
	addtimer(CALLBACK(src, PROC_REF(remove_banish), user_xeno.hive, target_xeno.name), 30 MINUTES)

	message_admins("[key_name_admin(user_xeno)] has banished [key_name_admin(target_xeno)]. Reason: [reason]")
	return

/datum/action/xeno_action/proc/remove_banish(datum/hive_status/hive, name)
	hive.banished_ckeys.Remove(name)


// Readmission = un-banish

/datum/action/xeno_action/onclick/manage_hive/proc/readmit()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_readmit = 100
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_readmit))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to readmit:", "Re-admit", user_xeno.hive.banished_ckeys, theme="hive_status")

	if(!choice)
		return

	var/banished_ckey
	var/banished_name

	for(var/mob_name in user_xeno.hive.banished_ckeys)
		if(user_xeno.hive.banished_ckeys[mob_name] == user_xeno.hive.banished_ckeys[choice])
			banished_ckey = user_xeno.hive.banished_ckeys[mob_name]
			banished_name = mob_name
			break

	var/banished_living = FALSE
	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(xeno.ckey == banished_ckey)
			target_xeno = xeno
			banished_living = TRUE
			break

	if(banished_living)
		if(!target_xeno.banished)
			to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph isn't banished!"))
			return

		var/confirm = tgui_alert(user_xeno, "Вы уверены, что хотите принять [target_xeno] обратно в улей?", "Возвращение в улей", list("Да", "Нет")) // SS220 EDIT ADDICTION
		if(confirm == "Нет") // SS220 EDIT ADDICTION
			return

		if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
			return

		to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("Королева [user_xeno] приняла вас обратно в улей.")))
		target_xeno.banished = FALSE
		target_xeno.hud_update_banished()
		target_xeno.lock_evolve = FALSE

	user_xeno.hive.banished_ckeys.Remove(banished_name)
	return

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

/datum/action/xeno_action/onclick/eye/use_ability(atom/target)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/datum/action/xeno_action/activable/expand_weeds
	var/list/recently_built_turfs

/datum/action/xeno_action/activable/expand_weeds/New(Target, override_icon_state)
	. = ..()
	recently_built_turfs = list()

/datum/action/xeno_action/activable/expand_weeds/Destroy()
	recently_built_turfs = null
	return ..()

/datum/action/xeno_action/activable/expand_weeds/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/turf_to_get = get_turf(target)

	if(!turf_to_get || turf_to_get.is_weedable < FULLY_WEEDABLE || turf_to_get.density || !SSmapping.same_z_map(turf_to_get.z, xeno.z))
		to_chat(xeno, SPAN_XENOWARNING("Вы не можете сделать это здесь."))
		return

	var/area/area_to_get = get_area(turf_to_get)
	if(isnull(area_to_get) || !area_to_get.is_resin_allowed)
		if(!area_to_get || area_to_get.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("Эта область не подходит для размещения улья."))
			return
		to_chat(xeno, SPAN_XENOWARNING("Ещё слишком рано распространять улей так далеко."))
		return

	var/obj/effect/alien/weeds/located_weeds = locate() in turf_to_get
	if(located_weeds)
		if(istype(located_weeds, /obj/effect/alien/weeds/node))
			to_chat(xeno, SPAN_XENOWARNING("Здесь уже есть узел."))
			return
		if(located_weeds.weed_strength > xeno.weed_level)
			to_chat(xeno, SPAN_XENOWARNING("Здесь уже есть более сильная трава."))
			return
		if(!check_and_use_plasma_owner(node_plant_plasma_cost))
			return

		to_chat(xeno, SPAN_XENOWARNING("Вы сажаете узел в [turf_to_get]")) // SS220 EDIT ADDICTION
		new /obj/effect/alien/weeds/node(turf_to_get, null, owner)
		playsound(turf_to_get, "alien_resin_build", 35)
		apply_cooldown_override(node_plant_cooldown)
		return

	var/obj/effect/alien/weeds/node/node
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_weed = get_step(turf_to_get, direction)
		var/obj/effect/alien/weeds/weeds_to_locate = locate() in turf_to_weed
		if(weeds_to_locate && weeds_to_locate.hivenumber == xeno.hivenumber && weeds_to_locate.parent && !weeds_to_locate.hibernate && !LinkBlocked(weeds_to_locate, turf_to_weed, turf_to_get))
			node = weeds_to_locate.parent
			break

	if(!node)
		to_chat(xeno, SPAN_XENOWARNING("Вы можете сажать траву только если рядом есть узел."))
		return
	if(turf_to_get in recently_built_turfs)
		to_chat(xeno, SPAN_XENOWARNING("Вы недавно уже строили здесь."))
		return

	if(!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/weeds(turf_to_get, node, FALSE, TRUE)
	playsound(turf_to_get, "alien_resin_build", 35)
	recently_built_turfs += turf_to_get
	addtimer(CALLBACK(src, PROC_REF(reset_turf_cooldown), turf_to_get), turf_build_cooldown)

	to_chat(xeno, SPAN_XENOWARNING("Вы сажаете траву в [turf_to_get]")) // SS220 EDIT ADDICTION
	apply_cooldown()
	return ..()



/datum/action/xeno_action/activable/expand_weeds/proc/reset_turf_cooldown(turf/T)
	recently_built_turfs -= T

/datum/action/xeno_action/onclick/screech/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	//screech is so powerful it kills huggers in our hands
	if(istype(xeno.r_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/hugger = xeno.r_hand
		if(hugger.stat != DEAD)
			hugger.die()

	if(istype(xeno.l_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/hugger = xeno.l_hand
		if(hugger.stat != DEAD)
			hugger.die()

	playsound(xeno.loc, pick(xeno.screech_sound_effect_list), 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[capitalize(xeno.declent_ru(NOMINATIVE))] издаёт оглушительный хриплый рёв!")) // SS220 EDIT ADDICTION
	xeno.create_shriekwave(14) //Adds the visual effect. Wom wom wom, 14 shriekwaves

	FOR_DVIEW(var/mob/mob, world.view, owner, HIDE_INVISIBLE_OBSERVER)
		if(mob && mob.client)
			if(isxeno(mob))
				shake_camera(mob, 10, 1)
			else
				shake_camera(mob, 30, 1) //50 deciseconds, SORRY 5 seconds was way too long. 3 seconds now
	FOR_DVIEW_END

	var/list/mobs_in_view = list()
	FOR_DOVIEW(var/mob/living/carbon/M, 7, xeno, HIDE_INVISIBLE_OBSERVER)
		mobs_in_view += M
	FOR_DOVIEW_END
	for(var/mob/living/carbon/M in orange(10, xeno))
		if(SEND_SIGNAL(M, COMSIG_MOB_SCREECH_ACT, xeno) & COMPONENT_SCREECH_ACT_CANCEL)
			continue
		M.handle_queen_screech(xeno, mobs_in_view)

	apply_cooldown()

	return ..()

/datum/action/xeno_action/activable/gut/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!action_cooldown_check())
		return
	if(xeno.queen_gut(target))
		apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/send_thoughts/proc/psychic_whisper()
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("Вы не можете шептать (вы заглушены)."))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	for(var/mob/living/carbon/possible_target in view(7, xeno_player))
		if(possible_target == xeno_player || !possible_target.client)
			continue
		target_list += possible_target

	var/mob/living/carbon/target_mob = tgui_input_list(usr, "Target", "Что вы хотите сказать?", target_list, theme="hive_status")
	if(!target_mob)
		return

	if(!xeno_player.check_state(TRUE))
		return

	var/whisper = tgui_input_text(xeno_player, "Что вы хотите сказать?", "Пси-шёпот") // SS220 EDIT ADDICTION
	if(whisper)
		log_say("PsychicWhisper: [key_name(xeno_player)]->[target_mob.key] : [whisper] (AREA: [get_area_name(target_mob)])")
		if(!istype(target_mob, /mob/living/carbon/xenomorph))
			to_chat(target_mob, SPAN_XENOQUEEN("Вы слышите странный, чужой голос в своей голове... '[SPAN_PSYTALK(whisper)]'")) // SS220 EDIT ADDICTION
		else
			to_chat(target_mob, SPAN_XENOQUEEN("Вы слышите голос [xeno_player] отражающийся в вашей голове... '[SPAN_PSYTALK(whisper)]'")) // SS220 EDIT ADDICTION
		to_chat(xeno_player, SPAN_XENONOTICE("Вы сказали: '[whisper]' обращаясь к [target_mob.real_name]")) // SS220 EDIT ADDICTION

		for(var/mob/dead/observer/ghost as anything in GLOB.observer_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
				var/rendered_message
				var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>(от кого?)</a>)" // SS220 EDIT ADDICTION
				var/target_track = "(<a href='byond://?src=\ref[ghost];track=\ref[target_mob]'>(с кем?)</a>)" // SS220 EDIT ADDICTION
				rendered_message = SPAN_XENOLEADER("Пси-шёпот: [xeno_player.real_name][xeno_track] обращаясь к [target_mob.real_name][target_track], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>") // SS220 EDIT ADDICTION
				ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)

	return

/datum/action/xeno_action/onclick/send_thoughts/proc/psychic_radiance()
	var/radiance_plasma_cost = 100
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!xeno_player.check_plasma(radiance_plasma_cost))
		return
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("Вы не можете шептать (вы заглушены)."))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	var/whisper = tgui_input_text(xeno_player, "Что вы хотите сказать?", "Пси-сияние") // SS220 EDIT ADDICTION
	if(!whisper || !xeno_player.check_state(TRUE))
		return
	FOR_DVIEW(var/mob/living/possible_target, 12, xeno_player, HIDE_INVISIBLE_OBSERVER)
		if(possible_target == xeno_player || !possible_target.client)
			continue
		target_list += possible_target
		if(!istype(possible_target, /mob/living/carbon/xenomorph))
			to_chat(possible_target, SPAN_XENOQUEEN("Вы слышите странный, чужой голос в своей голове... '[SPAN_PSYTALK(whisper)]'"))
		else
			to_chat(possible_target, SPAN_XENOQUEEN("Вы слышите голос [xeno_player] отражающийся в вашей голове... '[SPAN_PSYTALK(whisper)]'")) // SS220 EDIT ADDICTION
	FOR_DVIEW_END
	if(!length(target_list))
		return
	var/targetstring = english_list(target_list)
	to_chat(xeno_player, SPAN_XENONOTICE("Вы сказали: '[whisper]' обращаясь к [targetstring]")) // SS220 EDIT ADDICTION
	xeno_player.use_plasma(radiance_plasma_cost)
	log_say("PsychicRadiance: [key_name(xeno_player)]->[targetstring] : [whisper] (AREA: [get_area_name(xeno_player)])")
	for (var/mob/dead/observer/ghost as anything in GLOB.observer_list)
		if(!ghost.client || isnewplayer(ghost))
			continue
		if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
			var/rendered_message
			var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>посмотреть</a>)" // SS220 EDIT ADDICTION
			rendered_message = SPAN_XENOLEADER("Пси-cияние: [xeno_player.real_name][xeno_track] обращаясь к [targetstring], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>") // SS220 EDIT ADDICTION
			ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return

/datum/action/xeno_action/activable/queen_give_plasma/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/queen = owner
	if(!queen.check_state())
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/target_xeno = target
	if(!istype(target_xeno) || target_xeno.stat == DEAD)
		to_chat(queen, SPAN_WARNING("Вы должны выбрать ксеноморфа, которому хотите передать плазму."))
		return

	if(target_xeno == queen)
		to_chat(queen, SPAN_XENOWARNING("Мы не можем передать плазму самому себе!"))
		return

	if(!queen.can_not_harm(target_xeno))
		to_chat(queen, SPAN_WARNING("Вы можете выбрать только ксеноморфов, являющихся частью вашего улья!"))
		return

	if(!target_xeno.caste.can_be_queen_healed)
		to_chat(queen, SPAN_XENOWARNING("Этой касте нельзя передать плазму!"))
		return

	if(SEND_SIGNAL(target_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(queen, SPAN_XENOWARNING("Этому ксеноморфу нельзя передать плазму!"))
		return

	if(!check_and_use_plasma_owner())
		return

	target_xeno.gain_plasma(target_xeno.plasma_max * 0.75)
	target_xeno.flick_heal_overlay(3 SECONDS, COLOR_CYAN)
	apply_cooldown()
	to_chat(queen, SPAN_XENONOTICE("Вы передаёте немного плазмы [target_xeno].")) // SS220 EDIT ADDICTION
	return ..()

/datum/action/xeno_action/onclick/send_thoughts/proc/queen_order()
	var/mob/living/carbon/xenomorph/queen/xenomorph = owner
	var/give_order_plasma_cost = 100

	if(!xenomorph.check_plasma(give_order_plasma_cost))
		return
	if(!xenomorph.check_state())
		return
	if(xenomorph.observed_xeno)
		var/mob/living/carbon/xenomorph/target = xenomorph.observed_xeno
		if(target.stat != DEAD && target.client)
			if(xenomorph.check_plasma(plasma_cost))
				var/input = stripped_input(xenomorph, "Это сообщение будет отправлено наблюдаемому ксеноморфу.", "Приказ Королевы", "") // SS220 EDIT ADDICTION
				if(!input)
					return
				var/queen_order = SPAN_XENOANNOUNCE("<b>[xenomorph]</b> обращается к вам: '[input]'") // SS220 EDIT ADDICTION
				if(!xenomorph.check_state() || !xenomorph.check_plasma(plasma_cost) || xenomorph.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					xenomorph.use_plasma(plasma_cost)
					to_chat(target, "[queen_order]")
					log_admin("[queen_order]")
					message_admins("[key_name_admin(xenomorph)] has given the following Queen order to [target]: \"[input]\"", 1)
					xenomorph.use_plasma(give_order_plasma_cost)

	else
		to_chat(xenomorph, SPAN_WARNING("Вы должны наблюдать за ксеноморфом, которому хотите отдать приказ."))
		return
	return

/datum/action/xeno_action/onclick/queen_word/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	// We don't test or apply the cooldown here because the proc does it since verbs can activate it too
	xeno.hive_message()
	return ..()
