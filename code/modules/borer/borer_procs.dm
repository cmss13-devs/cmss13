//############# HELP ##################
/mob/living/carbon/cortical_borer/verb/show_help()
	set category = "Borer.Misc"
	set name = "Show Help"
	set desc = "Show help for borer commands."

	var/target = src

	var/list/options = list("Communicating","Contaminant & Enzymes")
	if(!host_mob)
		options += list("Infecting a host")
	else if(borer_flags_status & BORER_STATUS_CONTROLLING)
		target = host_mob
		options += list("Captive Host", "Releasing Control", "Reproducing", "Transferring Host")
	else if(isxeno(host_mob))
		options += list("Assuming Control","Hibernation","Reproducing")
	else
		options += list("Assuming Control","Hibernation","Secreting Chemicals","Learning Chemicals","Reproducing", "Host Death")

	var/choice = tgui_input_list(target, "What would you like help with?", "Help", options, 20 SECONDS)

	var/help_message = ""
	switch(choice)
		if("Infecting a host")
			var/possible_targets = ""
			if(borer_flags_targets & BORER_TARGET_HUMANS) possible_targets += "\nHumans"
			if(borer_flags_targets & BORER_TARGET_XENOS) possible_targets += "\nXenos"
			if(borer_flags_targets & BORER_TARGET_YAUTJA) possible_targets += "\nYautja"
			if(!possible_targets) possible_targets += "No one."
			help_message = "Infecting a host is the first major step for a borer to complete.\n\nThis is done by getting close to a potential host (This can be Human, Xeno or Yautja depending on settings controlled by admins) and clicking the Infest button in the top left of your screen.\n\nYour host will need to keep still for you to do this, and it's rare that they do so; for this reason you have Dominate Victim, which will allow you to temporarily stun a target.\n\nNote: Dominate is not sufficient to keep them down for 100% of the time it takes to infect however, so be careful with it.\n\nWhilst inside a host, and NOT in direct control, you can be detected by body scanners but otherwise are hidden from everyone but your host and other borers.\nYou can currently infect: [possible_targets]"
		if("Communicating")
			help_message = "All borers share a hivemind, the Cortical Link, this can be accessed using :0 (that's ZERO).\n\nThe hivemind can be used by any borer who is NOT in direct control of their host.\n\nAny borer in direct control of a host can only hear what their host can hear.\n\nA borer inside a host can communicate directly with that host using 'Converse with Host'."
		if("Captive Host")
			help_message = "Your host is now unable to act or speak to anyone but yourself. While in this state you have complete control of your host body, but you are disconnected from the hivemind.\n\nYour host can resist your control and regain their body however this can cause brain damage in humanoids.\n\nNote: Whilst in direct control of your host medical HUDs will detect you.\n\n\nIMPORTANT: While in direct control of a mob you MUST NOT perform antag actions unless you have permission from staff."
		if("Releasing Control")
			help_message = "Releasing control will do as it suggests, give your host their body back.\n\nYour host can resist your control and regain their body however this can cause brain damage in humanoids."
		if("Reproducing")
			var/capability = "able"
			if(!can_reproduce) capability = "forbidden"
			else if((enzymes < BORER_LARVAE_COST)) capability = "unable"
			help_message = "Reproduction will take a minimum of [BORER_LARVAE_COST] enzymes and direct control of your host.\n\nWhen in direct control you can use the Reproduce ability to spit out a new borer.\nMake sure to do this in a safe place, the new borer will not have a player to start with.\n\n If you are choking a human when you reproduce, the borer will infest them directly.\n\nYou are currently [capability] to reproduce."
		if("Assuming Control")
			help_message = "Assuming control will put you in direct control of your host, acting as if you are their player.\n\nYour host will be disassociated with their body, and trapped in their own mind unable to speak to anyone but you.\nWhile in this state you are unable to make use of the hivemind.\n\nYour host can resist your control and regain their body however this can cause brain damage in humanoids.\nYou must assume control to reproduce.\n\nNote: Whilst in direct control of your host medical HUDs will detect you.\n\n\nIMPORTANT: While in direct control of a mob you MUST NOT perform antag actions unless you have permission from staff."
		if("Transferring Host")
			help_message = "If you are in direct control of your host and are choking a human target, you can move directly from your host into the new target."
		if("Contaminant & Enzymes")
			help_message = "Enzymes are the cost of using most of your active abilities, such as secreting chemicals. They are gained passively over time whilst inside a host.\n\nUsing enzymes will in most cases produce Contaminant which upon reaching its capacity will prevent you using abilities.\nYou can clear Contaminant by hibernating when inside a host, alternately Contaminant will naturally be turned into a weak light source whilst outside a host."
		if("Hibernation")
			help_message = "Hibernation is how you purify contaminants from your body, allowing you to use your enzymes more freely.\n\nYou can only hibernate whilst inside a host, and it renders you unable to act other than to speak to your host.\n\nYou can freely enter or leave hibernation by clicking the Hibernate button."
		if("Secreting Chemicals")
			help_message = "Whilst inside a humanoid host you can secrete chemicals to facilitate your relationship.\nThese can vary from helpful medications to harmful control measures.\n\nSecreting chemicals costs enzymes and if a chemical is impure will cause you to gain contaminant.\nIf you are at, or will go over, your contaminant capacity you will be unable to secrete chemicals.\nPure chemicals are chemicals native to borers such as Cortical Enzyme."
		if("Learning Chemicals")
			help_message = "Whilst inside a humanoid host you can learn new chemicals to synthesise, costing [BORER_REPLICATE_COST] Enzymes.\n\nThis requires your host to have a chemical in their blood you do not already know, and for that chemical to be in a state of Overdose.\n\nLearning the chemical has a chance to fail, consuming enzymes but producing no results. This is determined by the number of properties the chemical has.\nSuccessful replication of the chemical will permanently allow you to reproduce it.\nSuccessful or not, attempting to replicate a chemical will consume 90% of the amount in your host's bloodstream."
		if("Host Death")
			help_message = "Upon the death of your host you will be forced to release direct control (if you are currently in control), but otherwise will be largely unaffected. If your host becomes permanently unreviavable however, you will be ejected from their corpse."
	if(!help_message)
		return FALSE
	alert(target, help_message, choice, "Ok")
	return TRUE

//############# Physical Interaction Procs #############
/mob/living/carbon/cortical_borer/proc/summon()
	var/datum/emergency_call/custom/em_call = new()
	em_call.name = real_name
	em_call.mob_max = 1
	em_call.players_to_offer = list(src)
	em_call.owner = null
	em_call.ert_message = "A new Cortical Borer has been birthed!"
	em_call.objectives = "Create enjoyable Roleplay. Do not kill your host. Do not take control unless granted permission or directed to by admins. Hivemind is :0 (That's Zero, not Oscar)"

	em_call.activate(TRUE, FALSE)

	message_admins("A new Cortical Borer has spawned at [get_area(loc)]")

/mob/living/carbon/cortical_borer/UnarmedAttack(atom/A)
	if(istype(A, /obj/structure/ladder))
		A.attack_hand(src)
	else
		A.attack_borer(src)

/atom/proc/attack_borer(mob/living/carbon/cortical_borer/user)
	return

/mob/living/carbon/cortical_borer/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H) || H != usr) return ..()

	if(H.a_intent == INTENT_HELP)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/carbon/cortical_borer/get_scooped(mob/living/carbon/grabber)
	if(stat != DEAD)
		to_chat(grabber, SPAN_WARNING("You probably shouldn't pick that thing up while it still lives."))
		return
	..()

//Brainslug scans the reagents in a target's bloodstream.
/mob/living/carbon/human/attack_borer(mob/M)
	borerscan(M, src)
/mob/living/carbon/xenomorph/attack_borer(mob/M)
	borerscan(M, src)

/proc/borerscan(mob/living/user, mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/human_target = M
		if(human_target.reagents)
			if(human_target.reagents.reagent_list.len)
				to_chat(user, SPAN_XENONOTICE("Subject contains the following reagents:"))
				for(var/datum/reagent/R in human_target.reagents.reagent_list)
					to_chat(user, "[R.overdose != 0 && R.volume >= R.overdose && !(R.flags & REAGENT_CANNOT_OVERDOSE) ? SPAN_WARNING("<b>OD: </b>") : ""] <font color='#9773C4'><b>[R.volume]u [R.name]</b></font>")
			else
				to_chat(user, SPAN_XENONOTICE("Subject contains no reagents."))
	if(isxeno(M))
		var/mob/living/carbon/xenomorph/xeno_target = M
		to_chat(user, SPAN_XENONOTICE("Subject status as follows:"))
		var/health_perc = xeno_target.maxHealth / 100
		to_chat(user, SPAN_XENONOTICE("Subject is at [xeno_target.health / health_perc]% bio integrity."))
		if(xeno_target.plasma_max)
			var/plasma_perc = xeno_target.plasma_max / 100
			to_chat(user, SPAN_XENONOTICE("Subject has [xeno_target.plasma_stored / plasma_perc]% bio plasma."))

//Brainslug scuttles under a door, same code as used by xeno larva.
/obj/structure/machinery/door/airlock/attack_borer(mob/living/carbon/cortical_borer/M)
	M.scuttle(src)

/mob/living/carbon/cortical_borer/proc/scuttle(obj/structure/S)
	var/move_dir = get_dir(src, loc)
	for(var/atom/movable/AM in get_turf(S))
		if(AM != S && AM.density && AM.BlockedPassDirs(src, move_dir))
			to_chat(src, SPAN_WARNING("\The [AM] prevents you from squeezing under \the [S]!"))
			return FALSE
	// Is it an airlock?
	if(istype(S, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/A = S
		if(A.locked || A.welded) //Can't pass through airlocks that have been bolted down or welded
			to_chat(src, SPAN_WARNING("\The [A] is locked down tight. You can't squeeze underneath!"))
			return FALSE
	visible_message(SPAN_WARNING("\The [src] scuttles underneath \the [S]!"), \
	SPAN_WARNING("You squeeze and scuttle underneath \the [S]."), null, 5)
	forceMove(S.loc)
	return TRUE

//############# Action Give/Take Procs #############
/mob/living/carbon/cortical_borer/proc/give_new_actions(actions_list = ACTION_SET_HOSTLESS, target = src)
	for(var/datum/action/innate/borer/action in actions)
		action.hide_from(target)

	if(host_mob && current_actions == ACTION_SET_CONTROL)
		for(var/datum/action/innate/borer/action in host_mob.actions)
			action.hide_from(host_mob)

	var/list/abilities_to_give
	switch(actions_list)
		if(ACTION_SET_HOSTLESS)
			abilities_to_give = actions_hostless.Copy()
			if(host_mob)
				for(var/datum/action/innate/borer/action in host_mob.actions)
					action.hide_from(host_mob)
		if(ACTION_SET_HUMANOID)
			abilities_to_give = actions_humanoidhost.Copy()
		if(ACTION_SET_XENO)
			abilities_to_give = actions_xenohost.Copy()
		if(ACTION_SET_CONTROL)
			if(!host_mob)
				return FALSE
			abilities_to_give = actions_control.Copy()
			target = host_mob
			for(var/datum/action/innate/borer/talk_to_borer/action in host_mob.actions)
				action.hide_from(host_mob)

	for(var/path in abilities_to_give)
		give_action(target, path)
	current_actions = actions_list
	return TRUE

/mob/living/carbon/cortical_borer/proc/get_host_actions()
	if(!host_mob)
		return FALSE
	if(ishuman(host_mob))
		give_new_actions(ACTION_SET_HUMANOID)
	else if(isxeno(host_mob))
		give_new_actions(ACTION_SET_XENO)
	else
		return FALSE
	give_action(host_mob, /datum/action/innate/borer/talk_to_borer)
	return TRUE

/mob/living/carbon/cortical_borer/proc/hibernate()
	if(borer_flags_actives & BORER_ABILITY_HIBERNATING)
		borer_flags_actives &= ~BORER_ABILITY_HIBERNATING
	else
		borer_flags_actives |= BORER_ABILITY_HIBERNATING

	if(borer_flags_actives & BORER_ABILITY_HIBERNATING)
		to_chat(src, SPAN_XENONOTICE("You are now hibernating! Your body will dissolve impurities built up from the creation of chemicals, however your enzyme reserves will not replenish. You cannot act beyond communicating whilst in hibernation."))
		sleeping = 2
	else
		sleeping = 0
		to_chat(src, SPAN_XENOWARNING("You are no longer hibernating. You have access to your full capabilities once more."))

//############# Control Related Procs #############
//Check for brain worms in head.
/mob/proc/has_brain_worms()
	return FALSE

/mob/living/carbon/has_brain_worms()
	if(isborer(borer))
		return borer
	else
		return FALSE

/mob/living/carbon/cortical_borer/proc/can_target(mob/living/carbon/target)
	var/obj/limb/head/head = target.get_limb("head")
	if((isborer(target)) || (head?.status & (LIMB_DESTROYED|LIMB_ROBOT|LIMB_SYNTHSKIN)))//No infecting synths, or borers.
		return FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(isspecieshuman(human_target) && !(borer_flags_targets & BORER_TARGET_HUMANS))//Can it infect humans? Normally, yes.
			return FALSE
		else if(isspeciesyautja(human_target) && !(borer_flags_targets & BORER_TARGET_YAUTJA))//Can it infect yautja? Normally, no.
			return FALSE
	if(isxeno(target) && !(borer_flags_targets & BORER_TARGET_XENOS))//Can it infect xenos? Normally, no.
		return FALSE
	if(target.stat == DEAD)
		var/mob/living/carbon/human/human_target
		if(ishuman(target))
			human_target = target
		if(isxeno(target) || (target.status_flags & PERMANENTLY_DEAD) || human_target && human_target.undefibbable)
			return FALSE
	if(Adjacent(target) && !target.has_brain_worms())
		return TRUE
	else
		return FALSE

//Brainslug infests a target
/mob/living/carbon/cortical_borer/verb/infest()
	set category = "Borer.Hostless"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host_mob)
		to_chat(src, "You are already within a host.")
		return FALSE
	if(stat)
		to_chat(src, "You cannot infest a target in your current state.")
		return FALSE
	var/list/choices = list()
	for(var/mob/living/carbon/candidate in view(1,src))
		if(can_target(candidate))
			choices += candidate
	if(!choices)
		to_chat(src, SPAN_XENOWARNING("No possible targets found."))
	var/mob/living/carbon/target = tgui_input_list(src, "Who do you wish to infest?", "Targets", choices)
	if(!target || !src || !Adjacent(target))
		return FALSE
	if(target.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return FALSE
	if(is_mob_incapacitated())
		return FALSE
	to_chat(src, SPAN_NOTICE("You slither up [target] and begin probing at their ear canal..."))
	var/used_icon = BUSY_ICON_HOSTILE
	if(stealthy)
		used_icon = NO_BUSY_ICON
	if(!do_after(src, 50, INTERRUPT_ALL_OUT_OF_RANGE, used_icon, target))
		to_chat(src, SPAN_WARNING("As [target] moves away, you are dislodged and fall to the ground."))
		return FALSE
	if(!target || !src)
		return FALSE
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot infest a target in your current state."))
		return FALSE
	if(target.stat == DEAD)
		var/mob/living/carbon/human/human_target
		if(ishuman(target))
			human_target = target
		if(isxeno(target) || (target.status_flags & PERMANENTLY_DEAD) || human_target && human_target.undefibbable)
			to_chat(src, SPAN_WARNING("You cannot infest the dead."))
			return FALSE
	if(target in view(1, src))
		to_chat(src, SPAN_NOTICE("You wiggle into [target]'s ear."))
		if(!stealthy && !target.stat)
			to_chat(target, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))
		perform_infestation(target)
		return TRUE
	else
		to_chat(src, "They are no longer in range!")
		return FALSE

/mob/living/carbon/cortical_borer/proc/perform_infestation(mob/living/carbon/target)
	if(!target)
		return FALSE
	if(target.has_brain_worms())
		to_chat(src, SPAN_XENOWARNING("[target] is already infested!"))
		return FALSE
	host_mob = target
	log_interact(src, host_mob, "Borer: [key_name(src)] Infested [key_name(host_mob)]")
	target.borer = src
	forceMove(target)
	host_mob.status_flags |= PASSEMOTES
	host_mob.verbs += /mob/living/proc/borer_comm
	get_host_actions()
	faction = target.faction
	faction_group = target.faction_group
	return TRUE


//Brainslug abandons the host
/mob/living/carbon/cortical_borer/verb/release_host()
	set category = "Borer.Infested"
	set name = "Release Host"
	set desc = "Slither out of your host."
	if(!host_mob)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return FALSE
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot leave your host in your current state."))
		return FALSE
	if(borer_flags_status & BORER_STATUS_DOCILE)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return FALSE
	if(!host_mob || !src)
		return FALSE
	if(borer_flags_status & BORER_STATUS_LEAVING)
		borer_flags_status &= ~BORER_STATUS_LEAVING
		to_chat(src, SPAN_XENOWARNING("You decide against leaving your host.</span>"))
		return TRUE
	to_chat(src, SPAN_XENOHIGHDANGER("You begin disconnecting from [host_mob]'s synapses and prodding at their internal ear canal."))
	borer_flags_status |= BORER_STATUS_LEAVING
	addtimer(CALLBACK(src, PROC_REF(let_go)), 200)
	return TRUE

/mob/living/carbon/cortical_borer/proc/let_go()
	if(!host_mob || !src || QDELETED(host_mob) || QDELETED(src))
		return FALSE
	if(!(borer_flags_status & BORER_STATUS_LEAVING) || borer_flags_status & BORER_STATUS_CONTROLLING)
		return FALSE
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot release a target in your current state."))
		return FALSE

	to_chat(src, SPAN_XENOHIGHDANGER("You wiggle out of [host_mob]'s ear and plop to the ground."))

	borer_flags_status &= ~BORER_STATUS_LEAVING
	leave_host()
	return TRUE

/mob/living/carbon/cortical_borer/proc/leave_host()
	if(!host_mob)
		return FALSE
	if(borer_flags_status & BORER_STATUS_CONTROLLING)
		detach()
	give_new_actions(ACTION_SET_HOSTLESS)

	forceMove(get_turf(host_mob))
	apply_effect(1, STUN)

	faction = "Cortical"
	faction_group = list("Cortical")

	log_interact(src, host_mob, "Borer: [key_name(src)] left their host; [key_name(host_mob)]")
	host_mob.reset_view(null)

	var/mob/living/carbon/H = host_mob
	H.borer = null
	H.status_flags &= ~PASSEMOTES
	host_mob = null
	return TRUE


//Brainslug takes control of the body
/mob/living/carbon/cortical_borer/verb/bond_brain()
	set category = "Borer.Infested"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(!host_mob)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return FALSE

	if(host_mob.stat == DEAD)
		to_chat(src, SPAN_XENODANGER("This host is in no condition to be controlled."))
		return FALSE

	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot do that in your current state."))
		return FALSE

	if(borer_flags_status & BORER_STATUS_DOCILE)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return FALSE

	if(borer_flags_actives & BORER_PROCESS_BONDING)
		borer_flags_actives &= ~BORER_PROCESS_BONDING
		to_chat(src, SPAN_XENOWARNING("You stop attempting to take control of your host."))
		return FALSE

	to_chat(src, "You begin delicately adjusting your connection to the host brain...")

	if(QDELETED(src) || QDELETED(host_mob))
		return FALSE

	borer_flags_actives |= BORER_PROCESS_BONDING

	var/delay = 300+(host_mob.getBrainLoss()*5)
	addtimer(CALLBACK(src, PROC_REF(assume_control)), delay)
	return TRUE

/mob/living/carbon/cortical_borer/proc/assume_control()
	if(!host_mob || !src || borer_flags_status & BORER_STATUS_CONTROLLING)
		return FALSE
	if(!(borer_flags_actives & BORER_PROCESS_BONDING))
		return FALSE
	if(borer_flags_status & BORER_STATUS_DOCILE)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return FALSE
	else
		to_chat(src, SPAN_XENOHIGHDANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
		to_chat(host_mob, SPAN_HIGHDANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
		to_chat(host_mob, SPAN_NOTICE("You can [SPAN_BOLD("resist")] this consciousness, but be warned you may suffer some degree of brain damage in the process!"))
		var/borer_key = src.key
		log_interact(src, host_mob, "Borer: [key_name(src)] Assumed control of [key_name(host_mob)]")
		// host -> brain
		var/h2b_id = host_mob.computer_id
		var/h2b_ip= host_mob.lastKnownIP
		host_mob.computer_id = null
		host_mob.lastKnownIP = null

		qdel(host_brain)
		host_brain = new(src)

		host_brain.ckey = host_mob.ckey

		host_brain.name = host_mob.name
		host_brain.faction = host_mob.faction
		host_brain.faction_group = host_mob.faction_group

		if(!host_brain.computer_id)
			host_brain.computer_id = h2b_id

		if(!host_brain.lastKnownIP)
			host_brain.lastKnownIP = h2b_ip

		// self -> host
		var/s2h_id = src.computer_id
		var/s2h_ip= src.lastKnownIP
		src.computer_id = null
		src.lastKnownIP = null

		host_mob.ckey = src.ckey

		if(!host_mob.computer_id)
			host_mob.computer_id = s2h_id

		if(!host_mob.lastKnownIP)
			host_mob.lastKnownIP = s2h_ip

		borer_flags_actives &= ~BORER_PROCESS_BONDING
		borer_flags_status |= BORER_STATUS_CONTROLLING

		give_new_actions(ACTION_SET_CONTROL)
		host_mob.med_hud_set_status()
		host_mob.special_mob = TRUE

		GLOB.brainlink.living_borers += host_mob

		if(src && !src.key)
			src.key = "@[borer_key]"
		return TRUE

//Captive mind reclaims their body.
/mob/living/captive_brain/proc/return_control(mob/living/carbon/cortical_borer/the_borer)
	if(!the_borer || !(the_borer.borer_flags_status & BORER_STATUS_CONTROLLING) || !resisting_control)
		return FALSE
	the_borer.host_mob.adjustBrainLoss(rand(5,10))
	to_chat(src, SPAN_HIGHDANGER("With an immense exertion of will, you regain control of your body!"))
	to_chat(the_borer.host_mob, SPAN_XENOHIGHDANGER("You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
	resisting_control = FALSE
	the_borer.detach()
	return TRUE

///Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Borer.Controlling"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/carbon/cortical_borer/the_borer = has_brain_worms()

	if(the_borer && the_borer.host_brain)
		to_chat(src, SPAN_XENONOTICE("You withdraw your probosci, releasing control of [the_borer.host_brain]"))

		the_borer.detach()

	else
		log_debug(EXCEPTION("Missing borer or missing host brain upon borer release."), src)

/mob/living/carbon/cortical_borer/proc/detach()
	if(!host_mob || !(borer_flags_status & BORER_STATUS_CONTROLLING))
		return FALSE

	borer_flags_status &= ~BORER_STATUS_CONTROLLING
	reset_view(null)

	get_host_actions()
	host_mob.med_hud_set_status()
	sleeping = 0
	if(host_brain)
		log_interact(host_mob, src, "Borer: [key_name(host_mob)] Took control back")
		host_mob.special_mob = FALSE
		GLOB.brainlink.living_borers -= host_mob
		// host -> self
		var/h2s_id = host_mob.computer_id
		var/h2s_ip= host_mob.lastKnownIP
		host_mob.computer_id = null
		host_mob.lastKnownIP = null
		src.ckey = host_mob.ckey
		if(!src.computer_id)
			src.computer_id = h2s_id
		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip = host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null
		host_mob.ckey = host_brain.ckey

		if(!host_mob.computer_id)
			host_mob.computer_id = b2h_id
		if(!host_mob.lastKnownIP)
			host_mob.lastKnownIP = b2h_ip
		qdel(host_brain)
	return TRUE

//Host Has died
/mob/living/carbon/cortical_borer/proc/host_death(perma = FALSE)
	if(!(host_mob && loc == host_mob))
		log_debug("Borer ([key_name(src)]) called host_death without being inside a host!")
		return FALSE
	if(borer_flags_status & BORER_STATUS_CONTROLLING)
		detach()
		to_chat(src, SPAN_XENOHIGHDANGER("You release your proboscis and flee as the psychic shock of your host's death washes over you!"))
	if(perma)
		to_chat(src, SPAN_XENOHIGHDANGER("You flee your host in anguish!"))
		leave_host()
	return TRUE

//############# External Ability Procs #############
/mob/living/carbon/cortical_borer/verb/hide_borer()
	set category = "Borer.Hostless"
	set name = "Hide"
	set desc = "Become invisible to the common eye."

	if(host_mob)
		to_chat(usr, SPAN_WARNING("You cannot do this while you're inside a host."))
		return FALSE

	if(stat != CONSCIOUS)
		return FALSE

	if(!hiding)
		layer = TURF_LAYER+0.2
		to_chat(src, SPAN_XENONOTICE("You are now hiding."))
		hiding = TRUE
	else
		layer = MOB_LAYER
		to_chat(src, SPAN_XENONOTICE("You stop hiding."))
		hiding = FALSE
	return TRUE

/mob/living/carbon/cortical_borer/verb/dominate_victim()
	set category = "Borer.Hostless"
	set name = "Dominate Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_XENOWARNING("You cannot use that ability again so soon."))
		return FALSE
	if(host_mob)
		to_chat(src, SPAN_XENOWARNING("You cannot do that from within a host body."))
		return FALSE
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot do that in your current state."))
		return FALSE
	if(attempting_to_dominate)
		to_chat(src, SPAN_XENOWARNING("You're already targeting someone!"))
		return FALSE
	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3,src))
		if(can_target(C))
			choices += C
	if(world.time - used_dominate < 300)
		to_chat(src, SPAN_XENOWARNING("You cannot use that ability again so soon."))
		return FALSE
	attempting_to_dominate = TRUE
	if(!choices)
		to_chat(src, SPAN_XENOWARNING("No possible targets found."))
	var/mob/living/carbon/M = tgui_input_list(src, "Who do you wish to dominate?", "Targets", choices)
	if(!M)
		attempting_to_dominate = FALSE
		return FALSE
	if(!src) //different statement to avoid a runtime since if the source is deleted then attempting_to_dominate would also be deleted
		return FALSE
	if(M.has_brain_worms())
		to_chat(src, SPAN_XENOWARNING("You cannot dominate someone who is already infested!"))
		attempting_to_dominate = FALSE
		return FALSE
	if(is_mob_incapacitated())
		attempting_to_dominate = FALSE
		return FALSE
	if(get_dist(src, M) > 5) //to avoid people remotely doing from across the map etc, 7 is the default view range
		to_chat(src, SPAN_XENOWARNING("You're too far away!"))
		attempting_to_dominate = FALSE
		return FALSE
	to_chat(src, SPAN_XENONOTICE("You begin to focus your psychic lance on [M], this will take a few seconds."))
	if(!do_after(src, 30, INTERRUPT_OUT_OF_RANGE, NO_BUSY_ICON, M, max_dist = 5))
		to_chat(src, SPAN_XENODANGER("You are out of position to dominate [M], get closer!"))
		attempting_to_dominate = FALSE
		return FALSE

	to_chat(src, SPAN_XENOWARNING("You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_WARNING("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	M.KnockDown(3)
	used_dominate = world.time
	attempting_to_dominate = FALSE
	return TRUE

//############# Internal Abiity Procs #############
/mob/living/carbon/proc/punish_host()
	set category = "Borer.Controlling"
	set name = "Torment Host"
	set desc = "Punish your host with agony."

	var/mob/living/carbon/cortical_borer/the_borer = has_brain_worms()

	if(!the_borer)
		return FALSE

	if(the_borer.host_brain)
		to_chat(src, SPAN_XENONOTICE("You send a punishing spike of psychic agony lancing into your host's brain."))
		to_chat(the_borer.host_brain, SPAN_HIGHDANGER("Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!"))
		return TRUE


/mob/living/carbon/proc/spawn_larvae()
	set category = "Borer.Controlling"
	set name = "Reproduce"
	set desc = "Spawn a new borer."

	var/mob/living/carbon/cortical_borer/brainworm = has_brain_worms()

	if(!brainworm)
		return FALSE
	if(brainworm.can_reproduce)
		if(brainworm.enzymes >= BORER_LARVAE_COST)
			to_chat(src, SPAN_XENOWARNING("Your host twitches and quivers as you rapdly excrete a larva from your sluglike body.</span>"))
			visible_message(SPAN_WARNING("[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</span>"))
			if(brainworm.generation <= 1)
				brainworm.enzymes -= BORER_LARVAE_COST
			else
				brainworm.enzymes = 0
			var/turf/T = get_turf(src)
			T.add_vomit_floor()
			brainworm.contaminant = 0
			var/repro = max(brainworm.can_reproduce - 1, 0)
			var/list/ancestors = brainworm.ancestry
			ancestors += real_name

			var/mob/living/carbon/cortical_borer/birthed = new /mob/living/carbon/cortical_borer(T, brainworm.generation + 1, TRUE, repro, brainworm.borer_flags_targets, ancestors)
			brainworm.offspring += birthed.real_name

			var/obj/item/grab/grab_effect = get_held_item()
			if(istype(grab_effect) && ishuman(grab_effect.grabbed_thing))
				var/mob/living/carbon/human/human_grab = grab_effect.grabbed_thing
				if(grab_level >= GRAB_AGGRESSIVE)
					birthed.perform_infestation(human_grab)
			else
				birthed.hide_borer()
			return TRUE
		else
			to_chat(src, SPAN_XENONOTICE("You need at least [BORER_LARVAE_COST] enzymes to reproduce!"))
			return FALSE
	else
		to_chat(src, SPAN_XENOWARNING("You are not allowed to reproduce!"))
		return FALSE

/mob/living/carbon/cortical_borer/proc/get_possible_chems()
	var/list/possibilities = list()
	for(var/datum/borer_chem/chem in GLOB.brainlink.borer_chemicals)
		possibilities += chem
	for(var/datum/borer_chem/chem in GLOB.brainlink.synthesized_chems)
		possibilities += chem
	return possibilities

/mob/living/carbon/cortical_borer/verb/secrete_chemicals()
	set category = "Borer.Infested"
	set name = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(!host_mob)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return FALSE

	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot secrete chemicals in your current state."))
		return FALSE

	if(borer_flags_status & BORER_STATUS_DOCILE)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return FALSE

	var/content = ""

	content += "<table>"

	if(ishuman(host_mob))
		var/mob/living/carbon/human/human_host
		human_host = host_mob
		for(var/datum/borer_chem/chem_datum in get_possible_chems())
			if(chem_datum.species != "Universal")
				if(isspeciesyautja(human_host))
					if(chem_datum.species != SPECIES_YAUTJA)
						continue
				else if(chem_datum.species != SPECIES_HUMAN)
					continue
			if(chem_datum.restricted && !restricted_chems_allowed)
				continue
			var/datum/borer_chem/current_chem = chem_datum
			var/chem = current_chem.chem_id
			var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
			if(R)
				content += "<tr><td><a href='byond://?_src_=\ref[src];src=\ref[src];borer_use_chem=[chem]'>[current_chem.quantity] units of [current_chem.chem_name] ([current_chem.cost] Enzymes)</a><p>[current_chem.desc]</p></td></tr>"

	content += "</table>"

	var/html = get_html_template(content)

	usr << browse(html, "window=ViewBorer\ref[src]Chems;size=585x400")

	return TRUE


/mob/living/carbon/cortical_borer/verb/learn_chemicals()
	set category = "Borer.Infested"
	set name = "Replicate Chemical"
	set desc = "Study a chemical compound for replication."

	if(!host_mob)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return FALSE

	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot replicate chemicals in your current state."))
		return FALSE

	if(borer_flags_status & BORER_STATUS_DOCILE)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return FALSE

	if(enzymes < BORER_REPLICATE_COST)
		to_chat(src, SPAN_XENONOTICE("You need at least [BORER_REPLICATE_COST] enzymes to attempt chemical replication!"))
		return FALSE

	var/list/options = list()
	var/list/options_datums = list()
	var/list/existing_chems = list()
	for(var/datum/borer_chem/existing_chem in GLOB.brainlink.borer_chemicals)
		if(!(existing_chem.chem_id in existing_chems))
			existing_chems += existing_chem.chem_id
	for(var/datum/borer_chem/existing_chem in GLOB.brainlink.synthesized_chems)
		if(!(existing_chem.chem_id in existing_chems))
			existing_chems += existing_chem.chem_id

	for(var/datum/reagent/potential_chem in host_mob.reagents?.reagent_list)
		if(potential_chem.id in existing_chems)
			continue
		if(potential_chem.volume < potential_chem.overdose)
			continue
		options += potential_chem.id
		options_datums[potential_chem.id] = potential_chem

	if(!options.len)
		to_chat(src, SPAN_XENONOTICE("There are no chemicals within your host you are able to replicate!"))
		return FALSE

	var/choice = tgui_input_list(usr, "Which option do you wish to attempt replication for?", "Choose Option", options, 20 SECONDS)
	if(!choice)
		return FALSE
	if(tgui_alert(usr, "Do you wish to attempt replication of '[choice]'?", "Confirm", list("Yes", "No"), 10 SECONDS) != "Yes")
		return FALSE
	var/datum/reagent/chosen = options_datums[choice]
	if(!chosen)
		return FALSE

	enzymes -= BORER_REPLICATE_COST
	var/failure_mult = 0
	for(var/property in chosen.properties)
		failure_mult++
	var/failure_chance = failure_mult * 10

	chosen.volume = (chosen.volume / 10)

	if(prob(failure_chance))
		to_chat(src, SPAN_XENOWARNING("Replication failed! This chemical has a failure chance of [failure_chance]%!"))
		return FALSE

	var/datum/borer_chem/synthesised/new_chem = new
	new_chem.chem_id = chosen.id
	new_chem.chem_name = chosen.name
	new_chem.desc = chosen.description
	var/n_species = host_mob.get_species()
	if(!n_species)
		n_species = "UNSET"
	new_chem.species = n_species

	var/new_cost = (5 * failure_chance)
	if(!new_cost)
		new_cost = 20
	new_chem.cost = new_cost

	var/new_quantity = chosen.overdose / 3
	if(!new_quantity)
		new_quantity = 10
	new_chem.quantity = new_quantity

	GLOB.brainlink.synthesized_chems += new_chem
	to_chat(src, SPAN_XENONOTICE("Replication successful!"))
	GLOB.brainlink.impulse_broadcast("[real_name] has replicated [new_chem.chem_name]!", "Small")

	return TRUE


//############# Communication Procs #############
/mob/living/carbon/cortical_borer/verb/Communicate()
	set category = "Borer.Infested"
	set name = "Converse with Host"
	set desc = "Send a silent message to your host."

	if(!host_mob)
		to_chat(src, "You do not have a host to communicate with!")
		return FALSE

	if(host_mob.stat == DEAD)
		to_chat(src, SPAN_XENODANGER("Not even you can commune with the dead."))
		return FALSE

	if(stat == DEAD)
		to_chat(src, "You're dead, Jim.")
		return FALSE

	var/input = stripped_input(src, "Please enter a message to tell your host.", "Borer", "")
	if(!input)
		return FALSE

	if(src && !QDELETED(src) && !QDELETED(host_mob))
		var/say_string = (borer_flags_status & BORER_STATUS_DOCILE) ? "slurs" :"states"
		if(host_mob)
			to_chat(host_mob, SPAN_XENO("[real_name] [say_string]: [input]"), type = MESSAGE_TYPE_RADIO)
			show_blurb(host_mob, 15, input, TRUE, "center", "center", COLOR_BROWN, null, null, 1)
			log_say("BORER: ([key_name(src)] to [key_name(host_mob)]) [input]", src)
			to_chat(src, SPAN_XENO("[real_name] [say_string]: [input]"), type = MESSAGE_TYPE_RADIO)
			for (var/mob/dead in GLOB.dead_mob_list)
				var/track_host = " (<a href='byond://?src=\ref[dead];track=\ref[host_mob]'>F</a>)"
				if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
					dead.show_message(SPAN_BORER("BORER: ([real_name] to [host_mob.real_name][track_host]) [say_string]: [input]"), SHOW_MESSAGE_VISIBLE)
			return TRUE

/mob/living/carbon/cortical_borer/verb/toggle_silence_inside_host()
	set name = "Toggle speech inside Host"
	set category = "Borer.Misc"
	set desc = "Toggle whether you will be able to say audible messages while inside your host."

	if(talk_inside_host)
		talk_inside_host = FALSE
		to_chat(src, SPAN_XENONOTICE("You will no longer talk audibly while inside a host."))
	else
		talk_inside_host = TRUE
		to_chat(src, SPAN_XENONOTICE("You will now be able to audibly speak from inside of a host."))

/mob/living/proc/borer_comm()
	set name = "Converse with Borer"
	set category = "Borer.Host"
	set desc = "Communicate mentally with your borer."


	var/mob/living/carbon/cortical_borer/borer = has_brain_worms()
	if(!borer)
		return FALSE

	if(stat == DEAD)
		to_chat(src, SPAN_XENODANGER("You're dead, Jim."))
		return FALSE

	var/input = stripped_input(src, "Please enter a message to tell the borer.", "Message", "")
	if(!input)
		return FALSE

	to_chat(borer, SPAN_XENO("[src.real_name] says: [input]"), type = MESSAGE_TYPE_RADIO)
	show_blurb(borer, 15, input, TRUE, "center", "center", COLOR_BROWN, null, null, 1)
	log_say("BORER: ([key_name(src)] to [key_name(borer)]) [input]", src)
	to_chat(src, SPAN_XENO("[src.real_name] says: [input]"), type = MESSAGE_TYPE_RADIO)
	for (var/mob/dead in GLOB.dead_mob_list)
		var/track_host = " (<a href='byond://?src=\ref[dead];track=\ref[borer.host_mob]'>F</a>)"
		if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
			dead.show_message(SPAN_BORER("BORER: ([name][track_host] to [borer.real_name]) says: [input]"), SHOW_MESSAGE_VISIBLE)
	return TRUE

/mob/living/proc/trapped_mind_comm()
	set name = "Converse with Trapped Mind"
	set category = "Borer.Controlling"
	set desc = "Communicate mentally with the trapped mind of your host."


	var/mob/living/carbon/cortical_borer/borer = has_brain_worms()
	if(!borer || !borer.host_brain)
		return FALSE
	var/mob/living/captive_brain/CB = borer.host_brain
	var/input = stripped_input(src, "Please enter a message to tell the trapped mind.", "Message", "")
	if(!input)
		return FALSE

	to_chat(CB, SPAN_XENO("[borer.real_name] says: [input]"), type = MESSAGE_TYPE_RADIO)
	log_say("BORER: ([key_name(src)] to [key_name(CB)]) [input]", borer)
	to_chat(src, SPAN_XENO("[borer.real_name] says: [input]"), type = MESSAGE_TYPE_RADIO)
	for (var/mob/dead in GLOB.dead_mob_list)
		var/track_borer = " (<a href='byond://?src=\ref[dead];track=\ref[borer.host_mob]'>F</a>)"
		if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
			dead.show_message(SPAN_BORER("BORER: ([borer.real_name][track_borer] to [real_name] (trapped mind)) says: [input]"), SHOW_MESSAGE_VISIBLE)
	return TRUE



//############# TOPIC #############
/mob/living/carbon/cortical_borer/Topic(href, href_list, hsrc)
	if(href_list["borer_use_chem"])
		locate(href_list["src"])
		if(!isborer(src))
			return FALSE
		if(borer_flags_status & BORER_STATUS_DOCILE)
			to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
			return FALSE

		var/topic_chem = href_list["borer_use_chem"]
		var/datum/borer_chem/current_chem = null

		for(var/datum/borer_chem/chem_datum in GLOB.brainlink.borer_chemicals)
			current_chem = chem_datum
			if(current_chem.chem_id == topic_chem)
				break
		if(current_chem.chem_id != topic_chem)
			for(var/datum/borer_chem/chem_datum in GLOB.brainlink.synthesized_chems)
				current_chem = chem_datum
				if(current_chem.chem_id == topic_chem)
					break

		if(!current_chem || !host_mob || (borer_flags_status & BORER_STATUS_CONTROLLING) || !src || stat)
			to_chat(src, SPAN_WARNING("ERROR: CHEM FAILURE - CONTACT FOREST2001"))
			return FALSE
		var/datum/reagent/R = GLOB.chemical_reagents_list[current_chem.chem_id]
		if(enzymes < current_chem.cost)
			to_chat(src, SPAN_XENOWARNING("You need [current_chem.cost] enzymes stored to secrete [current_chem.chem_name]!"))
			return FALSE
		var/contamination = round(current_chem.cost / 10)
		if(current_chem.impure && ((contaminant + contamination) > max_contaminant))
			to_chat(src, SPAN_XENOWARNING("You are too contaminated to secrete [current_chem.chem_name]!"))
			return FALSE
		to_chat(src, SPAN_XENONOTICE("You squirt a measure of [current_chem.chem_name] from your reservoirs into [host_mob]'s bloodstream."))
		contaminant += contamination
		host_mob.reagents.add_reagent(current_chem.chem_id, current_chem.quantity)
		enzymes -= current_chem.cost
		log_interact(src, host_mob, "[key_name(src)] has injected [current_chem.quantity] units of [R.name] into their host, [key_name(host_mob)]")

		// This is used because we use a static set of datums to determine what chems are available,
		// instead of a table or something. Thus, when we instance it, we can safely delete it
		qdel(current_chem)
		return TRUE
	..()



/client/proc/borer_broadcast(msg as text)
	set category = "Admin.Factions"
	set name = "Borer Impulse"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only staff members may talk on this channel.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	message_admins("Borer Impulse: [key_name(src)] : [msg]")

	msg = process_chat_markup(msg, list("*"))

	GLOB.brainlink.impulse_broadcast(msg)


/mob/living/carbon/human/proc/make_borer_host(worm_generation = 1, worm_repro = 1)
	if(has_brain_worms())
		return FALSE
	var/mob/living/carbon/cortical_borer/birthed = new /mob/living/carbon/cortical_borer(src, worm_generation, TRUE, worm_repro)
	birthed.perform_infestation(src)
	log_admin("[key_name(src)] was infected with a Cortical Borer by proccall.")
	return TRUE
