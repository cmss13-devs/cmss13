// Unrestricted, some might be unusble while on ovi
/datum/action/xeno_action/onclick/queen_word/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	// We don't test or apply the cooldown here because the proc does it since verbs can activate it too
	xeno.hive_message()
	return ..()

/datum/action/xeno_action/onclick/send_thoughts/use_ability(atom/Atom)
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

/datum/action/xeno_action/onclick/send_thoughts/proc/psychic_whisper()
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("You cannot whisper (muted)."))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	for(var/mob/living/carbon/possible_target in view(7, xeno_player))
		if(possible_target == xeno_player || !possible_target.client)
			continue
		target_list += possible_target

	var/mob/living/carbon/target_mob = tgui_input_list(usr, "Target", "Send a Psychic Whisper to whom?", target_list, theme="hive_status")
	if(!target_mob)
		return

	if(!xeno_player.check_state(TRUE))
		return

	var/whisper = tgui_input_text(xeno_player, "What do you wish to say?", "Psychic Whisper")
	if(whisper)
		log_say("PsychicWhisper: [key_name(xeno_player)]->[target_mob.key] : [whisper] (AREA: [get_area_name(target_mob)])")
		if(!istype(target_mob, /mob/living/carbon/xenomorph))
			to_chat(target_mob, SPAN_XENOQUEEN("You hear a strange, alien voice in your head. \"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(target_mob, SPAN_XENOQUEEN("You hear the voice of [xeno_player] resonate in your head. \"[SPAN_PSYTALK(whisper)]\""))
		to_chat(xeno_player, SPAN_XENONOTICE("You said: \"[whisper]\" to [target_mob]"))

		for(var/mob/dead/observer/ghost as anything in GLOB.observer_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
				var/rendered_message
				var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>F</a>)"
				var/target_track = "(<a href='byond://?src=\ref[ghost];track=\ref[target_mob]'>F</a>)"
				rendered_message = SPAN_XENOLEADER("PsychicWhisper: [xeno_player.real_name][xeno_track] to [target_mob.real_name][target_track], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>")
				ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)

	return

/datum/action/xeno_action/onclick/send_thoughts/proc/psychic_radiance()
	var/radiance_plasma_cost = 100
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!xeno_player.check_plasma(radiance_plasma_cost))
		return
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("You cannot whisper (muted)."))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	var/whisper = tgui_input_text(xeno_player, "What do you wish to say?", "Psychic Radiance")
	if(!whisper || !xeno_player.check_state(TRUE))
		return
	FOR_DVIEW(var/mob/living/possible_target, 12, xeno_player, HIDE_INVISIBLE_OBSERVER)
		if(possible_target == xeno_player || !possible_target.client)
			continue
		target_list += possible_target
		if(!istype(possible_target, /mob/living/carbon/xenomorph))
			to_chat(possible_target, SPAN_XENOQUEEN("You hear a strange, alien voice in your head. \"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(possible_target, SPAN_XENOQUEEN("You hear the voice of [xeno_player] resonate in your head. \"[SPAN_PSYTALK(whisper)]\""))
	FOR_DVIEW_END
	if(!length(target_list))
		return
	var/targetstring = english_list(target_list)
	to_chat(xeno_player, SPAN_XENONOTICE("You said: \"[whisper]\" to [targetstring]"))
	xeno_player.use_plasma(radiance_plasma_cost)
	log_say("PsychicRadiance: [key_name(xeno_player)]->[targetstring] : [whisper] (AREA: [get_area_name(xeno_player)])")
	for (var/mob/dead/observer/ghost as anything in GLOB.observer_list)
		if(!ghost.client || isnewplayer(ghost))
			continue
		if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
			var/rendered_message
			var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>F</a>)"
			rendered_message = SPAN_XENOLEADER("PsychicRadiance: [xeno_player.real_name][xeno_track] to [targetstring], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>")
			ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return

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
				var/input = stripped_input(xenomorph, "This message will be sent to the overwatched xeno.", "Queen Order", "")
				if(!input)
					return
				var/queen_order = SPAN_XENOANNOUNCE("<b>[xenomorph]</b> reaches you:\"[input]\"")
				if(!xenomorph.check_state() || !xenomorph.check_plasma(plasma_cost) || xenomorph.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					xenomorph.use_plasma(plasma_cost)
					to_chat(target, "[queen_order]")
					log_admin("[queen_order]")
					message_admins("[key_name_admin(xenomorph)] has given the following Queen order to [target]: \"[input]\"", 1)
					xenomorph.use_plasma(give_order_plasma_cost)

	else
		to_chat(xenomorph, SPAN_WARNING("You must overwatch the Xenomorph you want to give orders to."))
		return
	return

/datum/action/xeno_action/onclick/manage_hive/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/queen_manager = owner
	plasma_cost = 0
	var/list/options = list("Banish (500)", "Re-Admit (100)", "De-evolve (500)", "Reward Jelly (500)", "Exchange larva for evolution (100)", "Purchase Buffs")
	if(queen_manager.hive.hivenumber == XENO_HIVE_CORRUPTED)
		var/datum/hive_status/corrupted/hive = queen_manager.hive
		options += "Add Personal Ally"
		if(length(hive.personal_allies))
			options += "Remove Personal Ally"
			options += "Clear Personal Allies"

	var/choice = tgui_input_list(queen_manager, "Manage The Hive", "Hive Management",  options, theme="hive_status")
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
		if("Purchase Buffs")
			purchase_buffs()
	return ..()

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
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot banish yourself."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph is already banished!"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph doesn't belong to your hive!"))
		return

	// No banishing critted xenos
	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("What's the point? They're already about to die."))
		return

	var/confirm = tgui_alert(user_xeno, "Are you sure you want to banish [target_xeno] from the hive? This should only be done with good reason. (Note this prevents them from rejoining the hive after dying for 30 minutes as well unless readmitted)", "Banishment", list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for banishing [target_xeno]. This will be announced to the entire hive!")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for banishing [target_xeno]."))
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost_banish) || target_xeno.health < 0)
		return

	// Let everyone know they were banished
	xeno_announcement("By [user_xeno]'s will, [target_xeno] has been banished from the hive!\n\n[reason]", user_xeno.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment"))
	to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has banished you from the hive! Other xenomorphs may now attack you freely, but your link to the hivemind remains, preventing you from harming other sisters.")))

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

		var/confirm = tgui_alert(user_xeno, "Are you sure you want to readmit [target_xeno] into the hive?", "Readmittance", list("Yes", "No"))
		if(confirm != "Yes")
			return

		if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
			return

		to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has readmitted you into the hive.")))
		target_xeno.banished = FALSE
		target_xeno.hud_update_banished()
		target_xeno.lock_evolve = FALSE

	user_xeno.hive.banished_ckeys.Remove(banished_name)
	return

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
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] doesn't belong to your hive!"))
		return
	if(target_xeno.is_ventcrawling)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return
	if(!isturf(target_xeno.loc))
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return
	if(target_xeno.health <= 0)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is too weak to be deevolved."))
		return
	if(length(target_xeno.caste.deevolves_to) < 1)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved."))
		return
	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is banished and can't be deevolved."))
		return


	var/newcaste
	if(length(target_xeno.caste.deevolves_to) == 1)
		newcaste = target_xeno.caste.deevolves_to[1]
	else if(length(target_xeno.caste.deevolves_to) > 1)
		newcaste = tgui_input_list(user_xeno, "Choose a caste you want to de-evolve [target_xeno] to.", "De-evolve", target_xeno.caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return
	if(newcaste == XENO_CASTE_LARVA)
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
		return
	if(user_xeno.observed_xeno != target_xeno)
		return

	var/confirm = tgui_alert(user_xeno, "Are you sure you want to deevolve [target_xeno] from [target_xeno.caste.caste_type] to [newcaste]?", "Deevolution", list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for deevolving this xenomorph, [target_xeno]")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for deevolving [target_xeno]."))
		return

	if(!check_and_use_plasma_owner(plasma_cost))
		return


	to_chat(target_xeno, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

	SEND_SIGNAL(target_xeno, COMSIG_XENO_DEEVOLVE)

	var/mob/living/carbon/xenomorph/new_xeno = target_xeno.transmute(newcaste)

	if(new_xeno)
		message_admins("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")
		log_admin("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")

		if(user_xeno.hive.living_xeno_queen && user_xeno.hive.living_xeno_queen.observed_xeno == target_xeno)
			user_xeno.hive.living_xeno_queen.overwatch(new_xeno)

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

/datum/action/xeno_action/onclick/manage_hive/proc/give_evo_points()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_givepoints = 100


	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_givepoints))
		return

	if(world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(usr, SPAN_XENOWARNING("You must give some time for larva to spawn before sacrificing them. Please wait another [floor((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK - world.time) / 600)] minutes."))
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
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot give evolution points to yourself."))
		return

	if(target_xeno.evolution_stored == target_xeno.evolution_threshold)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph is already ready to evolve!"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph doesn't belong to your hive!"))
		return

	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("What's the point? They're about to die."))
		return

	if(user_xeno.hive.stored_larva < required_larva)
		to_chat(user_xeno, SPAN_XENOWARNING("You need at least [required_larva] burrowed larva to sacrifice one for evolution points."))
		return

	if(tgui_alert(user_xeno, "Are you sure you want to sacrifice a larva to give [target_xeno] [evo_points_per_larva] evolution points?", "Give Evolution Points", list("Yes", "No")) != "Yes")
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0 || user_xeno.hive.stored_larva < required_larva)
		return

	to_chat(target_xeno, SPAN_XENOWARNING("\The [user_xeno] has given you evolution points! Use them well."))
	to_chat(user_xeno, SPAN_XENOWARNING("\The [target_xeno] was given [evo_points_per_larva] evolution points."))

	if(target_xeno.evolution_stored + evo_points_per_larva > target_xeno.evolution_threshold)
		target_xeno.evolution_stored = target_xeno.evolution_threshold
	else
		target_xeno.evolution_stored += evo_points_per_larva

	user_xeno.hive.stored_larva--
	return

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

	if(tgui_alert(user_xeno, "Are you sure you want to clear personal allies?", "Clear Personal Allies", list("No", "Yes"), 10 SECONDS) != "Yes")
		return

	if(!length(hive.personal_allies))
		return

	hive.clear_personal_allies()

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
		to_chat(xeno, SPAN_XENONOTICE("No boons are available to us!"))
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
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits an ear-splitting guttural roar!"))
	xeno.create_shriekwave(14) //Adds the visual effect. Wom wom wom, 14 shriekwaves

	var/list/mobs_in_view = list()
	FOR_DOVIEW(var/mob/living/carbon/mob, 11, xeno, HIDE_INVISIBLE_OBSERVER)
		mobs_in_view += mob
		if(mob && mob.client)
			if(isxeno(mob))
				shake_camera(mob, 10, 1)
			else
				shake_camera(mob, 30, 1) //50 deciseconds, SORRY 5 seconds was way too long. 3 seconds now
	FOR_DOVIEW_END

	for(var/mob/living/carbon/mob in orange(11, xeno))
		if(SEND_SIGNAL(mob, COMSIG_MOB_SCREECH_ACT, xeno) & COMPONENT_SCREECH_ACT_CANCEL)
			continue
		mob.handle_queen_screech(xeno, mobs_in_view)

	apply_cooldown()

	return ..()

// Restricted to off Ovi

/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!xeno.check_state())
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf || !istype(current_turf))
		return

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_XENOWARNING("You're still recovering from detaching your old ovipositor. Wait [DisplayTimeText(timeleft(cooldown_timer_id))]."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("You need to be on resin to grow an ovipositor."))
		return

	if(SSinterior.in_interior(xeno))
		to_chat(xeno, SPAN_XENOWARNING("It's too tight in here to grow an ovipositor."))
		return

	if(alien_weeds.linked_hive.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("These weeds don't belong to your hive! You can't grow an ovipositor here."))
		return

	var/area/current_area = get_area(xeno)
	if(current_area.unoviable_timer)
		to_chat(xeno, SPAN_XENOWARNING("This area is not right for you to grow an ovipositor in."))
		return

	if(!xeno.check_alien_construction(current_turf))
		return

	if(xeno.action_busy)
		return

	if(!xeno.check_plasma(plasma_cost))
		return

	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] starts to grow an ovipositor."),
	SPAN_XENOWARNING("You start to grow an ovipositor...(takes 20 seconds, hold still)"))
	if(!do_after(xeno, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && xeno.check_plasma(plasma_cost))
		return
	if(!xeno.check_state())
		return
	if(!locate(/obj/effect/alien/weeds) in current_turf)
		return
	xeno.use_plasma(plasma_cost)
	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] has grown an ovipositor!"),
	SPAN_XENOWARNING("You have grown an ovipositor!"))
	xeno.mount_ovipositor()
	return ..()


/datum/action/xeno_action/activable/frontal_assault/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if(!istype(xeno) || !xeno.check_state() || !action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	xeno.face_atom(target)

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = Get_Compass_Dir(xeno, target)
	var/turf/infront = get_step(root, facing)
	var/turf/left = get_step(root, turn(facing, 90))
	var/turf/right = get_step(root, turn(facing, -90))
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	if(!(!infront || infront.density) && !(!left || left.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density) && !(!right || right.density))
		temp_turfs += infront_right

	for(var/turf/range_turf in temp_turfs)
		if (!istype(range_turf))
			continue

		if (range_turf.density)
			continue

		target_turfs += range_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(range_turf, 0.25 SECONDS)

		var/turf/next_turf = get_step(range_turf, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(next_turf, 0.25 SECONDS)

	if(!length(target_turfs))
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough room!"))
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENODANGER("[xeno] madly swings its claws infront of it!"), \
	SPAN_XENODANGER("We slash madly infront of us!"))
	xeno.emote("roar")

	for(var/turf/range in target_turfs)
		for(var/mob/living/carbon/carbon_target in range)
			if(carbon_target.stat == DEAD)
				continue

			if(!isxeno_human(carbon_target) || xeno.can_not_harm(carbon_target))
				continue

			if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
				continue

			var/random_limb_target = rand_zone("chest", 20)
			var/obj/limb/affected_limb = carbon_target.get_limb(random_limb_target) // CoM probably going to be hit more often
			if(ishuman(carbon_target) && (!affected_limb || (affected_limb.status & LIMB_DESTROYED))) // Failsafe just in case
				affected_limb = carbon_target.get_limb("chest")

			carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, xeno.melee_damage_upper * 1.4), ARMOR_MELEE, BRUTE, random_limb_target)
			carbon_target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
			if(xeno.stamina_extras_active && ishuman(carbon_target))
				affected_limb.add_bleeding(damage_amount = xeno.melee_damage_lower)

			xeno.flick_attack_overlay(carbon_target, "slash")
			to_chat(carbon_target, SPAN_DANGER("[xeno] violently gashes you in [affected_limb ? affected_limb.display_name : "chest"]!"))
			playsound(carbon_target, "alien_claw_flesh", 20) // Since there's one per affected target, keep it quiet so attacks aren't deafening
			shake_camera(carbon_target, 2, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/disarming_sweep/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!istype(xeno) || !xeno.check_state() || !action_cooldown_check())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("We sweep our tail in a wide circle!"))
	xeno.emote("tail")
	xeno.spin_circle()

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/carbon_target in orange(2, get_turf(xeno)))
		if(carbon_target.stat == DEAD)
			continue

		if(!isxeno_human(carbon_target) || xeno.can_not_harm(carbon_target))
			continue

		if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
			continue

		if(xeno.stamina_extras_active && carbon_target.mob_size < MOB_SIZE_BIG)
			new /datum/effects/xeno_slow(carbon_target, xeno, ttl = get_xeno_stun_duration(carbon_target, 2.5 SECONDS))
			carbon_target.apply_effect(get_xeno_stun_duration(carbon_target, 1.5 SECONDS), WEAKEN)
			to_chat(carbon_target, SPAN_XENOWARNING("You are swept off your feet by [xeno]'s tail sweep!"))
		else
			new /datum/effects/xeno_slow(carbon_target, xeno, ttl = get_xeno_stun_duration(carbon_target, 1.5 SECONDS))
			if(ishuman(carbon_target))
				carbon_target.drop_held_items()
				to_chat(carbon_target, SPAN_XENOWARNING("[xeno]'s tail knocks into you, causing you to stumble and drop what you were holding!"))
			else
				to_chat(carbon_target, SPAN_XENOWARNING("[xeno]'s tail knocks into you, causing you to stumble!"))

		xeno.flick_attack_overlay(carbon_target, "punch")
		playsound(carbon_target,'sound/weapons/alien_claw_block.ogg', 50, 1)
		shake_camera(carbon_target, 2, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/ram/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if(!xeno.check_state() || !action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	var/distance = get_dist(xeno, target)

	if(distance > max_distance)
		return

	var/turf/target_turf = get_turf(target)

	if(istype(target_turf, /turf/open/space))
		return



	if(!check_and_use_plasma_owner())
		return

	xeno.face_atom(target)

	switch(xeno.stamina_tier)
		if(0)
			windup_duration = 3 SECONDS
		if(1)
			windup_duration = 2.5 SECONDS
		if(2)
			windup_duration = 2 SECONDS
		if(3)
			windup_duration = 1.5 SECONDS
		if(4)
			windup_duration = 1 SECONDS
		if(5, 6)
			windup_duration = 0.5 SECONDS

	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Queen Ram"))
	xeno.anchored = TRUE

	if(!do_after(xeno, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		// Just in case
		to_chat(xeno, SPAN_XENODANGER("We fail to charge!"))
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Queen Ram"))
		xeno.anchored = FALSE
		return

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Queen Ram"))
	xeno.anchored = FALSE

	xeno.visible_message(SPAN_XENOWARNING("[xeno] charges at [target]!"), \
	SPAN_XENOWARNING("We charge at [target]!"))

	while((xeno.loc != target || xeno.loc != target_turf) && !impassable_collide) // Due to how throw_atom works, check to see if we're at our desired target and repeat...
		xeno.throw_atom(target, max_distance, SPEED_FAST, xeno, launch_type = LOW_LAUNCH, pass_flags = PASS_CRUSHER_CHARGE, collision_callbacks = ram_callbacks)
		if((xeno.loc == target || xeno.loc == target_turf) || impassable_collide) // ...Until we are at our target location or we hit a thing we're not supposed to charge through
			break

	xeno.update_icons()

	var/datum/action/xeno_action/onclick/screech/scree = get_action(xeno, /datum/action/xeno_action/onclick/screech)
	if(scree && (scree.current_cooldown_duration <= 50))
		scree.apply_cooldown_override(5 SECONDS)
		to_chat(xeno, SPAN_XENODANGER("We feel our throat muscles weaken!"))

	impassable_collide = FALSE
	apply_cooldown()
	return ..()

/mob/living/carbon/xenomorph/queen/proc/ram_mob(mob/living/carbon/target)
	if(target.stat == DEAD || can_not_harm(target) || target == src)
		throwing = FALSE
		return

	target.apply_effect(2, WEAKEN)
	target.apply_armoured_damage(get_xeno_damage_slash(target, src.melee_damage_upper), ARMOR_MELEE, BRUTE)
	target.last_damage_data = create_cause_data(src.caste_type, src)
	playsound(target, "punch", 30) // Quieter than most other instances since there could be a lot being hit at the same time

	if(!target.mob_size >= MOB_SIZE_BIG)
		src.visible_message(SPAN_XENODANGER("[src] crashes into [target], violently flinging them!"), \
	SPAN_XENODANGER("We violently fling [target] as we crash into them!"))
		src.throw_carbon(target, angle2dir(rand(1, 360)), rand(1, 2))
		return TRUE
	else
		src.visible_message(SPAN_XENODANGER("[src] crashes into [target], violently knocking them back!"), \
	SPAN_XENODANGER("We knock [target] back as we crash into them!"))
		step_away(target, src, 1)
		return FALSE // Small targets are easy to bash through, bigger targets are more wall-like

/mob/living/carbon/xenomorph/queen/proc/ram_obj(obj/target)
	var/datum/action/xeno_action/activable/ram/ramAction = get_action(src, /datum/action/xeno_action/activable/ram)

	if(!check_state() || (!throwing && !ramAction.action_cooldown_check()))
		obj_launch_collision(target)
		ramAction.impassable_collide = TRUE
		return FALSE

	if(!target)
		return FALSE

	else if(istype(target, /obj/structure/machinery/door/poddoor))
		var/obj/structure/machinery/door/poddoor/poddoor_target = target
		visible_message(SPAN_DANGER("[src] rams straight through [poddoor_target]!"), SPAN_XENODANGER("We ram straight through [poddoor_target]!"))
		playsound(poddoor_target, 'sound/effects/metal_door_close.ogg', 25)
		ramAction.impassable_collide = TRUE
		return FALSE

	else if(istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/cade_target = target
		visible_message(SPAN_DANGER("[src] rams straight through [cade_target]!"), SPAN_XENODANGER("We ram straight through [cade_target]!"))
		playsound(cade_target, cade_target.barricade_hitsound, 50)
		cade_target.deconstruct(FALSE)
		return TRUE

	else if(istype(target, /obj/structure/surface/table) || istype(target, /obj/structure/surface/rack))
		var/obj/structure/structure_target = target
		visible_message(SPAN_DANGER("[src] rams straight through [structure_target]!"), SPAN_XENODANGER("We ram straight through [structure_target]!"))
		playsound(structure_target, "metalbang", 20)
		structure_target.deconstruct(FALSE)
		return TRUE

	else if(istype(target, /obj/structure/window))
		var/obj/structure/window/window_target = target
		if(window_target.unacidable)
			playsound(window_target, 'sound/effects/glassbash.ogg', 30)
			target.hitby(src)
			ramAction.impassable_collide = TRUE
			return FALSE
		else
			playsound(window_target, "windowshatter", 50)
			window_target.shatter_window(TRUE)
			visible_message(SPAN_DANGER("[src] rams straight through [window_target]!"))
			return TRUE

	else if(istype(target, /obj/structure/window_frame))
		var/obj/structure/window_frame/winframe_target = target
		visible_message(SPAN_DANGER("[src] rams straight through [winframe_target]!"))
		playsound(winframe_target, 'sound/effects/metal_shatter.ogg', 20)
		winframe_target.deconstruct(FALSE)
		return TRUE

	else if(istype(target, /obj/structure/grille))
		var/obj/structure/grille/grille_target = target
		if(grille_target.unacidable)
			ramAction.impassable_collide = TRUE
			return FALSE
		else
			grille_target.health -=  80 //Usually knocks it down.
			grille_target.healthcheck()
			return TRUE

	else if(istype(target, /obj/structure/fence/electrified))
		var/obj/structure/fence/electrified/fence_target = target
		if(fence_target.cut)
			return FALSE
		else
			src.visible_message(SPAN_DANGER("[src] rams [fence_target]!"))
			fence_target.cut_grille()
			return TRUE

	else if(istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/airlock_target = target
		if(airlock_target.unacidable)
			target.hitby(src)
			ramAction.impassable_collide = TRUE
			return FALSE
		else
			playsound(airlock_target, 'sound/effects/metal_crash.ogg', 20, 1)
			airlock_target.deconstruct(FALSE)
			return TRUE

	else if(istype(target, /obj/structure/machinery/vending))
		var/obj/structure/machinery/vending/vendor_target = target
		if(vendor_target.unslashable)
			target.hitby(src)
		else
			visible_message(SPAN_DANGER("[src] rams [vendor_target]!"), SPAN_XENODANGER("We ram straight into [vendor_target]!"))
			playsound(loc, "punch", 25, 1)
			vendor_target.tip_over()

			var/impact_range = 1
			var/turf/TA = get_diagonal_step(vendor_target, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			launch_towards(TA, impact_range, launch_speed)

			vendor_target.hitby(src)
			ramAction.impassable_collide = TRUE
			return FALSE

	else if(istype(target, /obj/structure/machinery/cm_vending))
		var/obj/structure/machinery/cm_vending/cm_vendor_target = target
		if(cm_vendor_target.unslashable)
			target.hitby(src)
		else
			visible_message(SPAN_DANGER("[src] rams [cm_vendor_target]!"), SPAN_XENODANGER("We ram [cm_vendor_target]!"))
			playsound(loc, "punch", 25, 1)
			cm_vendor_target.tip_over()

			var/impact_range = 1
			var/turf/TA = get_diagonal_step(cm_vendor_target, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			throw_atom(TA, impact_range, launch_speed)

			cm_vendor_target.hitby(src)
			ramAction.impassable_collide = TRUE
			return FALSE

	else if(istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multi_target = target
		visible_message(SPAN_DANGER("[src] rams [multi_target] and skids to a halt!"), SPAN_XENOWARNING("We ram [multi_target] and skid to a halt!"))
		multi_target.Collided(src)
		ramAction.impassable_collide = TRUE
		return FALSE

	else if(istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/HMG_target = target
		visible_message(SPAN_DANGER("[src] rams [HMG_target]!"), SPAN_XENODANGER("We ram [HMG_target]!"))
		playsound(HMG_target, "punch", 25, 1)
		HMG_target.CrusherImpact()
		HMG_target.hitby(src)
		ramAction.impassable_collide = TRUE
		return FALSE

	else if(istype(target, /obj/structure/machinery/defenses))
		var/obj/structure/machinery/defenses/DF_target = target
		if(DF_target.unacidable)
			visible_message(SPAN_DANGER("[src] rams [DF_target]!"), SPAN_XENODANGER("We ram [DF_target]!"))
			playsound(DF_target, "punch", 25, 1)
			target.hitby(src)
			ramAction.impassable_collide = TRUE
			return FALSE
		else
			visible_message(SPAN_DANGER("[src] rams straight through [DF_target]!"), SPAN_XENODANGER("We ram straight through [DF_target]!"))
			playsound(DF_target, "punch", 25, 1)
			DF_target.destroyed_action()
			return TRUE

	else if(istype(target, /obj/structure/cargo_container))
		var/obj/structure/cargo_container/cargocontainer_target = target
		visible_message(SPAN_DANGER("[src] rams into [cargocontainer_target]!"), SPAN_XENODANGER("We ram straight into [cargocontainer_target]!"))
		playsound(cargocontainer_target, 'sound/effects/metalhit.ogg', 25, 1)
		qdel(cargocontainer_target)
		ramAction.impassable_collide = TRUE
		return FALSE

	else if(istype(target, /obj/structure/largecrate))
		var/obj/structure/largecrate/largecrate_target = target
		visible_message(SPAN_DANGER("[src] smashes straight through [largecrate_target]!"), SPAN_XENODANGER("We smash straight through [largecrate_target]!"))
		largecrate_target.unpack()
		return TRUE

	else if(istype(target, /obj/structure/dropship_equipment))
		var/obj/structure/dropship_equipment/dropshipequip_target = target
		visible_message(SPAN_DANGER("[src] smashes straight through [dropshipequip_target]!"), SPAN_XENODANGER("We smash straight through [dropshipequip_target]!"))
		playsound(dropshipequip_target, 'sound/effects/metalhit.ogg', 25, 1)
		qdel(dropshipequip_target)
		return TRUE

	else if(istype(target, /obj/structure/girder))
		var/obj/structure/girder/girder_target = target
		visible_message(SPAN_DANGER("[src] smashes straight through [girder_target]!"), SPAN_XENODANGER("We smash straight through [girder_target]!"))
		playsound(girder_target, 'sound/effects/metal_shatter.ogg', 20)
		qdel(girder_target)
		return TRUE

	else if(isobj(target))
		var/obj/obj_target = target
		if(obj_target.unacidable)
			ramAction.impassable_collide = TRUE
			return FALSE

		else if (obj_target.anchored)
			visible_message(SPAN_DANGER("[src] crushes [obj_target]!"), SPAN_XENODANGER("We crush [obj_target]!"))
			if(length(obj_target.contents)) //Hopefully won't auto-delete things inside crushed stuff.
				var/turf/T = get_turf(src)
				for(var/atom/movable/S in T.contents) S.forceMove(T)

			qdel(obj_target)
			return TRUE

		else
			if(obj_target.buckled_mob)
				obj_target.unbuckle()
			visible_message(SPAN_WARNING("[src] knocks [obj_target] aside!"), SPAN_XENOWARNING("We knock [obj_target] aside.")) //Canisters, crates etc. go flying.
			playsound(loc, "punch", 25, 1)

			var/impact_range = 2
			var/turf/TA = get_diagonal_step(obj_target, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			throw_atom(TA, impact_range, launch_speed)
			return TRUE

	else
		obj_launch_collision(target)
		ramAction.impassable_collide = TRUE
		return FALSE

/mob/living/carbon/xenomorph/queen/proc/ram_turf(turf/target)
	var/datum/action/xeno_action/activable/ram/ramAction = get_action(src, /datum/action/xeno_action/activable/ram)
	var/mob/living/carbon/xenomorph/xeno = src

	if(istype(target, /turf/closed/wall/resin))
		var/turf/closed/wall/resin/resinwall_target = target
		if(!HIVE_ALLIED_TO_HIVE(xeno, resinwall_target))
			playsound(resinwall_target, "alien_resin_break", 25)
			resinwall_target.dismantle_wall()
			return TRUE

	else if(istype(target, /turf/closed))
		ramAction.impassable_collide = TRUE

	if(!target.density)
		for(var/mob/living/carbon/mob in target)
			ram_mob(mob)
			break

	else
		turf_launch_collision(target)
		ramAction.impassable_collide = TRUE
		return FALSE

/datum/action/xeno_action/activable/brutality/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if(!xeno.check_state() || !action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if(xeno.can_not_harm(target) || !ismob(target))
		return

	var/mob/living/carbon/carbon_target = target
	if(carbon_target.stat == DEAD)
		return

	if(!check_and_use_plasma_owner())
		return

	apply_cooldown()

	xeno.throw_atom(get_step_towards(target, xeno), max_range, SPEED_FAST, xeno)

	if(xeno.Adjacent(carbon_target) && xeno.start_pulling(carbon_target, TRUE))
		playsound(carbon_target.pulledby, 'sound/voice/predalien_growl.ogg', 75, 0, status = 0) // bang and roar for dramatic effect
		playsound(carbon_target, 'sound/effects/bang.ogg', 25, 0)
		animate(carbon_target, pixel_y = carbon_target.pixel_y + 32, time = 4, easing = SINE_EASING)
		sleep(4)
		playsound(carbon_target, 'sound/effects/bang.ogg', 25, 0)
		playsound(carbon_target,"slam", 50, 1)
		animate(carbon_target, pixel_y = 0, time = 4, easing = BOUNCE_EASING) //animates the smash
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, xeno.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest", 20)


	return ..()
/*
/datum/action/xeno_action/activable/brutality/proc/animate_original2original(mob/living/carbon/xenomorph/xeno, mob/living/carbon/target)
	// Dramatic heavy smash into dramatic throw
	xeno.emote("roar")
	sleep(6)
	animate(target, pixel_y = 0, time = 4, easing = BOUNCE_EASING)

/datum/action/xeno_action/activable/brutality/proc/animate_backwards2original(mob/living/carbon/xenomorph/xeno, mob/living/carbon/target)
	// 180 smash into 180 throw

/datum/action/xeno_action/activable/brutality/proc/animate_left2original(mob/living/carbon/xenomorph/xeno, mob/living/carbon/target)
	// Dramatic smash to the left into throw

/datum/action/xeno_action/activable/brutality/proc/animate_right2original(mob/living/carbon/xenomorph/xeno, mob/living/carbon/target)
	// Quick smash to the right into dramatic throw


/mob/living/carbon/xenomorph/queen/stop_pulling()
	if(isliving(pulling) && smashing)
		smashing = FALSE // To avoid extreme cases of stopping a lunge then quickly pulling and stopping to pull someone else
		var/mob/living/smashed = pulling
		smashed.set_effect(0, STUN)
		smashed.set_effect(0, WEAKEN)
	return ..()

/mob/living/carbon/xenomorph/queen/start_pulling(atom/movable/movable_atom, brutality)
	if(!check_state())
		return FALSE

	if(!isliving(movable_atom))
		return FALSE
	var/mob/living/living_mob = movable_atom
	var/should_neckgrab = !(src.can_not_harm(living_mob)) && brutality


	. = ..(living_mob, brutality, should_neckgrab)

	if(.) //successful pull
		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/xeno = living_mob
			if(xeno.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return

		if(should_neckgrab && living_mob.mob_size < MOB_SIZE_BIG)
			visible_message(SPAN_XENOWARNING("[src] grabs [living_mob] by the back of their leg and slams them onto the ground!"),
			SPAN_XENOWARNING("We grab [living_mob] by the back of their leg and slam them onto the ground!")) // more flair
			smashing = TRUE
			living_mob.drop_held_items()
			var/duration = get_xeno_stun_duration(living_mob, 1)
			living_mob.KnockDown(duration)
			living_mob.Stun(duration)
			addtimer(VARSET_CALLBACK(src, smashing, FALSE), duration)
*/
/datum/action/xeno_action/activable/gut/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!action_cooldown_check())
		return
	if(xeno.queen_gut(target))
		apply_cooldown()
	return ..()

// Restricted to on Ovi

/datum/action/xeno_action/onclick/remove_eggsac/use_ability(atom/A)
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
	X.visible_message(SPAN_XENOWARNING("\The [X] starts detaching itself from its ovipositor!"),
		SPAN_XENOWARNING("You start detaching yourself from your ovipositor."))
	if(!do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10))
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()
	return ..()

/datum/action/xeno_action/activable/expand_weeds
	var/list/recently_built_turfs

/datum/action/xeno_action/activable/expand_weeds/New(Target, override_icon_state)
	. = ..()
	recently_built_turfs = list()

/datum/action/xeno_action/activable/expand_weeds/Destroy()
	recently_built_turfs = null
	return ..()

/datum/action/xeno_action/activable/expand_weeds/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/turf_to_get = get_turf(atom)

	if(!turf_to_get || turf_to_get.is_weedable < FULLY_WEEDABLE || turf_to_get.density || (turf_to_get.z != xeno.z))
		to_chat(xeno, SPAN_XENOWARNING("You can't do that here."))
		return

	var/area/area_to_get = get_area(turf_to_get)
	if(isnull(area_to_get) || !area_to_get.is_resin_allowed)
		if(!area_to_get || area_to_get.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive."))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	var/obj/effect/alien/weeds/located_weeds = locate() in turf_to_get
	if(located_weeds)
		if(istype(located_weeds, /obj/effect/alien/weeds/node))
			to_chat(xeno, SPAN_XENOWARNING("There's already a node here."))
			return
		if(located_weeds.weed_strength > xeno.weed_level)
			to_chat(xeno, SPAN_XENOWARNING("There's already stronger weeds here."))
			return
		if(!check_and_use_plasma_owner(node_plant_plasma_cost))
			return

		to_chat(xeno, SPAN_XENOWARNING("You plant a node at [turf_to_get]"))
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
		to_chat(xeno, SPAN_XENOWARNING("You can only plant weeds if there is a nearby node."))
		return
	if(turf_to_get in recently_built_turfs)
		to_chat(xeno, SPAN_XENOWARNING("You've recently built here already."))
		return

	if(!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/weeds(turf_to_get, node, FALSE, TRUE)
	playsound(turf_to_get, "alien_resin_build", 35)
	recently_built_turfs += turf_to_get
	addtimer(CALLBACK(src, PROC_REF(reset_turf_cooldown), turf_to_get), turf_build_cooldown)

	to_chat(xeno, SPAN_XENOWARNING("You plant weeds at [turf_to_get]"))
	apply_cooldown()
	return ..()



/datum/action/xeno_action/activable/expand_weeds/proc/reset_turf_cooldown(turf/T)
	recently_built_turfs -= T

/datum/action/xeno_action/activable/secrete_resin/remote/queen/use_ability(atom/target_atom, mods)
	if(boosted)
		var/area/target_area = get_area(target_atom)
		if(!target_area)
			return

		if(target_area.linked_lz && istype(SSticker.mode, /datum/game_mode/colonialmarines))
			to_chat(owner, SPAN_XENONOTICE("It's too early to spread the hive this far."))
			return

	return ..()

/datum/action/xeno_action/activable/secrete_resin/remote/queen/give_to(mob/L)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(apply_queen_build_boost)))

// queenos don't need weeds under them to build on ovi
/datum/action/xeno_action/activable/secrete_resin/remote/queen/can_remote_build()
	return TRUE

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/apply_queen_build_boost()
	var/boost_duration = 30 MINUTES
	// In the event secrete_resin is given after round start
	if(SSticker.round_start_time)
		boost_duration = (30 MINUTES) - (world.time - SSticker.round_start_time)
	if(boost_duration > 0)
		boosted = TRUE
		xeno_cooldown = 0
		plasma_cost = 0
		build_speed_mod = 1
		thick = TRUE // Allow queen to remotely thicken structures.
		RegisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS, PROC_REF(override_secrete_thick_resin))
		addtimer(CALLBACK(src, PROC_REF(disable_boost)), boost_duration)

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/disable_boost()
	xeno_cooldown = 3 SECONDS
	plasma_cost = 100
	boosted = FALSE
	thick = FALSE
	UnregisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS)

	if(owner)
		to_chat(owner, SPAN_XENOHIGHDANGER("Your boosted building has been disabled!"))

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/override_secrete_thick_resin()
	return COMPONENT_THICK_BYPASS

/datum/action/xeno_action/onclick/set_xeno_lead/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return
	var/datum/hive_status/hive = X.hive
	if(X.observed_xeno)
		if(!length(hive.open_xeno_leader_positions) && X.observed_xeno.hive_pos == NORMAL_XENO)
			to_chat(X, SPAN_XENOWARNING("You currently have [length(hive.xeno_leader_list)] promoted leaders. You may not maintain additional leaders until your power grows."))
			return
		var/mob/living/carbon/xenomorph/T = X.observed_xeno
		if(T == X)
			to_chat(X, SPAN_XENOWARNING("You cannot add yourself as a leader!"))
			return
		apply_cooldown()
		if(T.hive_pos == NORMAL_XENO)
			if(!hive.add_hive_leader(T))
				to_chat(X, SPAN_XENOWARNING("Unable to add the leader."))
				return
			to_chat(X, SPAN_XENONOTICE("You've selected [T] as a Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has selected you as a Hive Leader. The other Xenomorphs must listen to you. You will also act as a beacon for the Queen's pheromones."))
		else
			hive.remove_hive_leader(T)
			to_chat(X, SPAN_XENONOTICE("You've demoted [T] from Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has demoted you from Hive Leader. Your leadership rights and abilities have waned."))
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/xenomorph/T in hive.xeno_leader_list)
			possible_xenos += T

		if(length(possible_xenos) > 1)
			var/mob/living/carbon/xenomorph/selected_xeno = tgui_input_list(X, "Target", "Watch which leader?", possible_xenos, theme="hive_status")
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.overwatch(selected_xeno)
		else if(length(possible_xenos))
			X.overwatch(possible_xenos[1])
		else
			to_chat(X, SPAN_XENOWARNING("There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader."))
	return ..()

/datum/action/xeno_action/activable/queen_heal/use_ability(atom/A, verbose)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)
	if(!T)
		to_chat(X, SPAN_WARNING("You must select a valid turf to heal around."))
		return

	if(X.loc.z != T.loc.z)
		to_chat(X, SPAN_XENOWARNING("You are too far away to do this here."))
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/xenomorph/Xa in range(4, T))
		if(!X.can_not_harm(Xa))
			continue

		if(SEND_SIGNAL(Xa, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			if(verbose)
				to_chat(X, SPAN_XENOMINORWARNING("You cannot heal [Xa]!"))
			continue

		if(Xa == X)
			continue

		if(Xa.stat == DEAD || QDELETED(Xa))
			continue

		if(!Xa.caste.can_be_queen_healed)
			continue

		new /datum/effects/heal_over_time(Xa, Xa.maxHealth * 0.3, 2 SECONDS, 2)
		Xa.flick_heal_overlay(3 SECONDS, "#D9F500") //it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("You channel your plasma to heal your sisters' wounds around this area."))
	return ..()

/datum/action/xeno_action/activable/queen_give_plasma/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/target = A
	if(!istype(target) || target.stat == DEAD)
		to_chat(X, SPAN_WARNING("You must target the xeno you want to give plasma to."))
		return

	if(target == X)
		to_chat(X, SPAN_XENOWARNING("We cannot give plasma to yourself!"))
		return

	if(!X.can_not_harm(target))
		to_chat(X, SPAN_WARNING("You can only target xenos part of your hive!"))
		return

	if(!target.caste.can_be_queen_healed)
		to_chat(X, SPAN_XENOWARNING("This caste cannot be given plasma!"))
		return

	if(SEND_SIGNAL(target, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(X, SPAN_XENOWARNING("This xeno cannot be given plasma!"))
		return

	if(!check_and_use_plasma_owner())
		return

	target.gain_plasma(target.plasma_max * 0.75)
	target.flick_heal_overlay(3 SECONDS, COLOR_CYAN)
	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("You transfer some plasma to [target]."))
	return ..()

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

/datum/action/xeno_action/onclick/eye/use_ability(atom/A)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/mob/living/carbon/xenomorph/proc/xeno_tacmap()
	set name = "View Xeno Tacmap"
	set desc = "This opens a tactical map, where you can see where every xenomorph is."
	set category = "Alien"
	hive.tacmap.tgui_interact(src)

/datum/action/xeno_action/onclick/queen_tacmap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	xeno.xeno_tacmap()
	return ..()
