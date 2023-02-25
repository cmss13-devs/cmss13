//############# Physical Interaction Procs #############
/mob/living/simple_animal/borer/UnarmedAttack(atom/A)
	A.attack_borer(src)

/atom/proc/attack_borer(mob/living/simple_animal/borer/user)
	return


//Brainslug scans the reagents in a target's bloodstream.
/mob/living/carbon/human/attack_borer(mob/M)
	borerscan(M, src)

/proc/borerscan(mob/living/user, mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.reagents)
			if(H.reagents.reagent_list.len)
				to_chat(user, SPAN_XENONOTICE("Subject contains the following reagents:"))
				for(var/datum/reagent/R in H.reagents.reagent_list)
					to_chat(user, "[R.overdose != 0 && R.volume >= R.overdose && !(R.flags & REAGENT_CANNOT_OVERDOSE) ? SPAN_WARNING("<b>OD: </b>") : ""] <font color='#9773C4'><b>[round(R.volume, 1)]u [R.name]</b></font>")
			else
				to_chat(user, SPAN_XENONOTICE("Subject contains no reagents."))

//Brainslug scuttles under a door, same code as used by xeno larva.
/obj/structure/machinery/door/airlock/attack_borer(mob/living/simple_animal/borer/M)
	M.scuttle(src)

/mob/living/simple_animal/borer/proc/scuttle(obj/structure/S)
	var/move_dir = get_dir(src, loc)
	for(var/atom/movable/AM in get_turf(S))
		if(AM != S && AM.density && AM.BlockedPassDirs(src, move_dir))
			to_chat(src, SPAN_WARNING("\The [AM] prevents you from squeezing under \the [S]!"))
			return
	// Is it an airlock?
	if(istype(S, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/A = S
		if(A.locked || A.welded) //Can't pass through airlocks that have been bolted down or welded
			to_chat(src, SPAN_WARNING("\The [A] is locked down tight. You can't squeeze underneath!"))
			return
	visible_message(SPAN_WARNING("\The [src] scuttles underneath \the [S]!"), \
	SPAN_WARNING("You squeeze and scuttle underneath \the [S]."), null, 5)
	forceMove(S.loc)

//############# Action Give/Take Procs #############
/mob/living/simple_animal/borer/proc/GrantBorerActions()
	action_infest_host.give_to(src)
	action_toggle_hide.give_to(src)
	action_freeze_victim.give_to(src)

/mob/living/simple_animal/borer/proc/RemoveBorerActions()
	action_infest_host.remove_from(src)
	action_toggle_hide.remove_from(src)
	action_freeze_victim.remove_from(src)

/mob/living/simple_animal/borer/proc/GrantInfestActions()
	action_talk_to_host.give_to(src)
	action_leave_body.give_to(src)
	action_take_control.give_to(src)
	action_make_chems.give_to(src)
	action_scan_chems.give_to(src)
	action_hibernate.give_to(src)

/mob/living/simple_animal/borer/proc/RemoveInfestActions()
	action_talk_to_host.remove_from(src)
	action_take_control.remove_from(src)
	action_leave_body.remove_from(src)
	action_make_chems.remove_from(src)
	action_scan_chems.remove_from(src)
	action_hibernate.remove_from(src)

/mob/living/simple_animal/borer/proc/GrantControlActions()
	action_talk_to_brain.give_to(host)
	action_give_back_control.give_to(host)
	action_make_larvae.give_to(host)
	action_torment.give_to(host)

/mob/living/simple_animal/borer/proc/RemoveControlActions()
	action_talk_to_brain.remove_from(host)
	action_make_larvae.remove_from(host)
	action_give_back_control.remove_from(host)
	action_torment.remove_from(host)

/mob/living/simple_animal/borer/proc/hibernate()
	hibernating = !hibernating
	if(hibernating)
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
	if(borer)
		return borer
	else
		return FALSE


//Brainslug infests a target
/mob/living/simple_animal/borer/verb/infest()
	set category = "Borer"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		to_chat(src, "You are already within a host.")
		return
	if(stat)
		to_chat(src, "You cannot infest a target in your current state.")
		return
	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		var/obj/limb/head/head = H.get_limb("head")
		if(head.status & LIMB_ROBOT)
			continue
		if(isspeciesyautja(H) && !infect_hunter)
			continue
		if(H.stat != DEAD && Adjacent(H) && !H.has_brain_worms())
			choices += H
	var/mob/living/carbon/human/target = tgui_input_list(src, "Who do you wish to infest?", "Targets", choices)
	if(!target || !src)
		return
	if(!Adjacent(target))
		return
	if(target.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return
	if(is_mob_incapacitated())
		return
	to_chat(src, SPAN_NOTICE("You slither up [target] and begin probing at their ear canal..."))
	if(!do_after(src, 50, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_HOSTILE, target))
		to_chat(src, SPAN_WARNING("As [target] moves away, you are dislodged and fall to the ground."))
		return
	if(!target || !src)
		return
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot infest a target in your current state."))
		return
	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("That is not an appropriate target."))
		return
	if(target in view(1, src))
		to_chat(src, SPAN_NOTICE("You wiggle into [target]'s ear."))
		/*
		if(!target.stat)
			to_chat(target, "Something disgusting and slimy wiggles into your ear!")
		*/ // Let's see how stealthborers work out
		perform_infestation(target)
		return
	else
		to_chat(src, "They are no longer in range!")
		return

/mob/living/simple_animal/borer/proc/perform_infestation(mob/living/carbon/target)
	if(!target)
		return
	if(target.has_brain_worms())
		to_chat(src, SPAN_XENOWARNING("[target] is already infested!"))
		return
	host = target
	log_interact(src, host, "Borer: [key_name(src)] Infested [key_name(host)]")
	target.borer = src
	forceMove(target)
	host.status_flags |= PASSEMOTES
	host.verbs += /mob/living/proc/borer_comm
	RemoveBorerActions()
	GrantInfestActions()


//Brainslug abandons the host
/mob/living/simple_animal/borer/verb/release_host()
	set category = "Borer"
	set name = "Release Host"
	set desc = "Slither out of your host."
	if(!host)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot leave your host in your current state."))
		return
	if(docile)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return
	if(!host || !src)
		return
	if(leaving)
		leaving = FALSE
		to_chat(src, SPAN_XENOWARNING("You decide against leaving your host.</span>"))
		return
	to_chat(src, SPAN_XENOHIGHDANGER("You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."))
	leaving = TRUE
	addtimer(CALLBACK(src, PROC_REF(let_go)), 200)

/mob/living/simple_animal/borer/proc/let_go()
	if(!host || !src || QDELETED(host) || QDELETED(src))
		return
	if(!leaving)
		return
	if(controlling)
		return
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot release a target in your current state."))
		return

	to_chat(src, SPAN_XENOHIGHDANGER("You wiggle out of [host]'s ear and plop to the ground."))

	leaving = FALSE
	leave_host()

/mob/living/simple_animal/borer/proc/leave_host()
	if(!host)
		return
	if(controlling)
		detach()
	GrantBorerActions()
	RemoveInfestActions()
	forceMove(get_turf(host))

	host.reset_view(null)

	var/mob/living/carbon/H = host
	H.borer = null
	H.verbs -= /mob/living/proc/borer_comm
	action_talk_to_borer.remove_from(host)
	H.status_flags &= ~PASSEMOTES
	host = null
	return


//Brainslug takes control of the body
/mob/living/simple_animal/borer/verb/bond_brain()
	set category = "Borer"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(!host)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return

	if(host.stat == DEAD)
		to_chat(src, SPAN_XENODANGER("This host is in no condition to be controlled."))
		return

	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot do that in your current state."))
		return

	if(docile)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return

	if(bonding)
		bonding = FALSE
		to_chat(src, SPAN_XENOWARNING("You stop attempting to take control of your host."))
		return

	to_chat(src, "You begin delicately adjusting your connection to the host brain...")

	if(QDELETED(src) || QDELETED(host))
		return

	bonding = TRUE

	var/delay = 300+(host.getBrainLoss()*5)
	addtimer(CALLBACK(src, PROC_REF(assume_control)), delay)

/mob/living/simple_animal/borer/proc/assume_control()
	if(!host || !src || controlling)
		return
	if(!bonding)
		return
	if(docile)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return
	else
		to_chat(src, SPAN_XENOHIGHDANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
		to_chat(host, SPAN_HIGHDANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
		to_chat(host, SPAN_NOTICE("You can [SPAN_BOLD("resist")] this consciousness, but be warned you may suffer some degree of brain damage in the process!"))
		var/borer_key = src.key
		log_interact(src, host, "Borer: [key_name(src)] Assumed control of [key_name(host)]")
		// host -> brain
		var/h2b_id = host.computer_id
		var/h2b_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		qdel(host_brain)
		host_brain = new(src)

		host_brain.ckey = host.ckey

		host_brain.name = host.name

		if(!host_brain.computer_id)
			host_brain.computer_id = h2b_id

		if(!host_brain.lastKnownIP)
			host_brain.lastKnownIP = h2b_ip

		// self -> host
		var/s2h_id = src.computer_id
		var/s2h_ip= src.lastKnownIP
		src.computer_id = null
		src.lastKnownIP = null

		host.ckey = src.ckey

		if(!host.computer_id)
			host.computer_id = s2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = s2h_ip

		bonding = FALSE
		controlling = TRUE

		host.verbs += /mob/living/carbon/proc/release_control
		host.verbs += /mob/living/carbon/proc/punish_host
		host.verbs += /mob/living/carbon/proc/spawn_larvae
		host.verbs -= /mob/living/proc/borer_comm
		host.verbs += /mob/living/proc/trapped_mind_comm

		GrantControlActions()
		action_talk_to_borer.remove_from(host)
		host.med_hud_set_status()

		if(src && !src.key)
			src.key = "@[borer_key]"
		return

//Captive mind reclaims their body.
/mob/living/captive_brain/proc/return_control(mob/living/simple_animal/borer/B)
	if(!B || !B.controlling)
		return
	B.host.adjustBrainLoss(rand(5,10))
	to_chat(src, SPAN_DANGER("With an immense exertion of will, you regain control of your body!"))
	to_chat(B.host, SPAN_XENODANGER("You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
	B.detach()

///Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Borer"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		to_chat(src, SPAN_XENONOTICE("You withdraw your probosci, releasing control of [B.host_brain]"))

		B.detach()

	else
		log_debug(EXCEPTION("Missing borer or missing host brain upon borer release."), src)

/mob/living/simple_animal/borer/proc/detach()
	if(!host || !controlling)
		return

	controlling = FALSE
	reset_view(null)

	host.verbs -= /mob/living/carbon/proc/release_control
	host.verbs -= /mob/living/carbon/proc/punish_host
	host.verbs -= /mob/living/carbon/proc/spawn_larvae
	host.verbs += /mob/living/proc/borer_comm
	host.verbs -= /mob/living/proc/trapped_mind_comm

	RemoveControlActions()
	action_talk_to_borer.give_to(host)
	host.med_hud_set_status()
	sleeping = 0
	if(host_brain)
		log_interact(host, src, "Borer: [key_name(host)] Took control back")
		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null
		src.ckey = host.ckey
		if(!src.computer_id)
			src.computer_id = h2s_id
		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip = host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null
		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id
		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip
	qdel(host_brain)
	return

//Host Has died
/mob/living/simple_animal/borer/proc/host_death(perma = FALSE)
	if(!(host && loc == host))
		log_debug("Borer ([key_name(src)]) called host_death without being inside a host!")
		return
	if(controlling)
		detach()
		to_chat(src, SPAN_HIGHDANGER("You release your proboscis and flee as the psychic shock of your host's death washes over you!"))
	if(perma)
		to_chat(src, SPAN_HIGHDANGER("You flee your host in anguish!"))
		leave_host()

//############# External Ability Procs #############
/mob/living/simple_animal/borer/verb/hide_borer()
	set category = "Borer"
	set name = "Hide"
	set desc = "Become invisible to the common eye."

	if(host)
		to_chat(usr, SPAN_XENOWARNING("You cannot do this while you're inside a host."))
		return

	if(stat != CONSCIOUS)
		return

	if(!hiding)
		layer = TURF_LAYER+0.2
		to_chat(src, SPAN_XENONOTICE("You are now hiding."))
		hiding = TRUE
	else
		layer = MOB_LAYER
		to_chat(src, SPAN_XENONOTICE("You stop hiding."))
		hiding = FALSE

/mob/living/simple_animal/borer/verb/dominate_victim()
	set category = "Borer"
	set name = "Dominate Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_XENOWARNING("You cannot use that ability again so soon."))
		return
	if(host)
		to_chat(src, SPAN_XENOWARNING("You cannot do that from within a host body."))
		return
	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot do that in your current state."))
		return
	if(attempting_to_dominate)
		to_chat(src, SPAN_XENOWARNING("You're already targeting someone!"))
		return
	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3,src))
		if((C.stat != DEAD) && !(issynth(C)))
			choices += C
	if(world.time - used_dominate < 300)
		to_chat(src, SPAN_XENOWARNING("You cannot use that ability again so soon."))
		return
	attempting_to_dominate = TRUE
	var/mob/living/carbon/M = tgui_input_list(src, "Who do you wish to dominate?", "Targets", choices)
	if(!M)
		attempting_to_dominate = FALSE
		return
	if(!src) //different statement to avoid a runtime since if the source is deleted then attempting_to_dominate would also be deleted
		return
	if(M.has_brain_worms())
		to_chat(src, SPAN_XENOWARNING("You cannot dominate someone who is already infested!"))
		attempting_to_dominate = FALSE
		return
	if(is_mob_incapacitated())
		attempting_to_dominate = FALSE
		return
	if(get_dist(src, M) > 5) //to avoid people remotely doing from across the map etc, 7 is the default view range
		to_chat(src, SPAN_XENOWARNING("You're too far away!"))
		attempting_to_dominate = FALSE
		return
	to_chat(src, SPAN_XENONOTICE("You begin to focus your psychic lance on [M], this will take a few seconds."))
	if(!do_after(src, 30, INTERRUPT_OUT_OF_RANGE, NO_BUSY_ICON, M, max_dist = 5))
		to_chat(src, SPAN_XENODANGER("You are out of position to dominate [M], get closer!"))
		attempting_to_dominate = FALSE
		return

	to_chat(src, SPAN_XENOWARNING("You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_WARNING("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	M.KnockDown(3)
	used_dominate = world.time
	attempting_to_dominate = FALSE


//############# Internal Abiity Procs #############
/mob/living/carbon/proc/punish_host()
	set category = "Borer"
	set name = "Torment Host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain)
		to_chat(src, SPAN_XENONOTICE("You send a punishing spike of psychic agony lancing into your host's brain."))
		to_chat(B.host_brain, SPAN_XENOHIGHDANGER("Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!"))


/mob/living/carbon/proc/spawn_larvae()
	set category = "Borer"
	set name = "Reproduce"
	set desc = "Spawn a new borer."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return
	if(B.can_reproduce)
		if(B.enzymes >= BORER_LARVAE_COST)
			to_chat(src, SPAN_XENOWARNING("Your host twitches and quivers as you rapdly excrete a larva from your sluglike body.</span>"))
			visible_message(SPAN_WARNING("[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</span>"))
			B.enzymes = 0
			var/turf/T = get_turf(src)
			T.add_vomit_floor()
			B.contaminant = 0
			var/repro = max(B.can_reproduce - 1, 0)
			new /mob/living/simple_animal/borer(T, B.generation + 1, TRUE, repro)
		else
			to_chat(src, SPAN_XENONOTICE("You need at least [BORER_LARVAE_COST] enzymes to reproduce!"))
			return
	else
		to_chat(src, SPAN_XENOWARNING("You are not allowed to reproduce!"))



/mob/living/simple_animal/borer/verb/secrete_chemicals()
	set category = "Borer"
	set name = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(!host)
		to_chat(src, SPAN_XENOWARNING("You are not inside a host body."))
		return

	if(stat)
		to_chat(src, SPAN_XENOWARNING("You cannot secrete chemicals in your current state."))

	if(docile)
		to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
		return

	var/content = ""

	content += "<table>"

	if(ishuman(host))
		if(isspeciesyautja(host))
			for(var/datum in subtypesof(/datum/borer_chem/yautja))
				var/datum/borer_chem/C = datum
				var/chem = initial(C.chem_id)
				var/datum/reagent/R = chemical_reagents_list[chem]
				if(R)
					content += "<tr><td><a href='?_src_=\ref[src];src=\ref[src];borer_use_chem=[chem]'>[initial(C.quantity)] units of [R.name] ([initial(C.cost)] Enzymes)</a><p>[initial(C.desc)]</p></td></tr>"
		else
			for(var/datum in subtypesof(/datum/borer_chem/human))
				var/datum/borer_chem/C = datum
				var/chem = initial(C.chem_id)
				var/datum/reagent/R = chemical_reagents_list[chem]
				if(R)
					content += "<tr><td><a href='?_src_=\ref[src];src=\ref[src];borer_use_chem=[chem]'>[initial(C.quantity)] units of [R.name] ([initial(C.cost)] Enzymes)</a><p>[initial(C.desc)]</p></td></tr>"

	content += "</table>"

	var/html = get_html_template(content)

	usr << browse(null, "window=ViewBorer\ref[src]Chems;size=585x400")
	usr << browse(html, "window=ViewBorer\ref[src]Chems;size=585x400")

	return



//############# Communication Procs #############
/mob/living/simple_animal/borer/verb/Communicate()
	set category = "Borer"
	set name = "Converse with Host"
	set desc = "Send a silent message to your host."

	if(!host)
		to_chat(src, "You do not have a host to communicate with!")
		return

	if(host.stat == DEAD)
		to_chat(src, SPAN_XENODANGER("Not even you can commune with the dead."))
		return

	if(stat)
		to_chat(src, "You cannot do that in your current state.")
		return

	var/input = stripped_input(src, "Please enter a message to tell your host.", "Borer", "")
	if(!input)
		return

	if(src && !QDELETED(src) && !QDELETED(host))
		var/say_string = (docile) ? "slurs" :"states"
		if(host)
			to_chat(host, SPAN_XENO("[truename] [say_string]: [input]"), type = MESSAGE_TYPE_RADIO)
			log_say("BORER: ([key_name(src)] to [key_name(host)]) [input]", src)
			to_chat(src, SPAN_XENO("[truename] [say_string]: [input]"), type = MESSAGE_TYPE_RADIO)
			action_talk_to_borer.give_to(host)
			for (var/mob/dead in GLOB.dead_mob_list)
				var/track_host = " (<a href='byond://?src=\ref[dead];track=\ref[host]'>F</a>)"
				if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
					dead.show_message(SPAN_BORER("BORER: ([truename] to [host.real_name][track_host]) [say_string]: [input]"), SHOW_MESSAGE_VISIBLE)

/mob/living/simple_animal/borer/verb/toggle_silence_inside_host()
	set name = "Toggle speech inside Host"
	set category = "Borer"
	set desc = "Toggle whether you will be able to say audible messages while inside your host."

	if(talk_inside_host)
		talk_inside_host = FALSE
		to_chat(src, SPAN_XENONOTICE("You will no longer talk audibly while inside a host."))
	else
		talk_inside_host = TRUE
		to_chat(src, SPAN_XENONOTICE("You will now be able to audibly speak from inside of a host."))

/mob/living/proc/borer_comm()
	set name = "Converse with Borer"
	set category = "Borer"
	set desc = "Communicate mentally with your borer."


	var/mob/living/simple_animal/borer/B = has_brain_worms()
	if(!B)
		return

	if(stat == DEAD)
		to_chat(src, SPAN_XENODANGER("You're dead, Jim."))
		return

	var/input = stripped_input(src, "Please enter a message to tell the borer.", "Message", "")
	if(!input)
		return

	to_chat(B, SPAN_XENO("[src] says: [input]"), type = MESSAGE_TYPE_RADIO)
	log_say("BORER: ([key_name(src)] to [key_name(B)]) [input]", src)
	to_chat(src, SPAN_XENO("[src] says: [input]"), type = MESSAGE_TYPE_RADIO)
	for (var/mob/dead in GLOB.dead_mob_list)
		var/track_host = " (<a href='byond://?src=\ref[dead];track=\ref[B.host]'>F</a>)"
		if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
			dead.show_message(SPAN_BORER("BORER: ([name][track_host] to [B.truename]) says: [input]"), SHOW_MESSAGE_VISIBLE)

/mob/living/proc/trapped_mind_comm()
	set name = "Converse with Trapped Mind"
	set category = "Borer"
	set desc = "Communicate mentally with the trapped mind of your host."


	var/mob/living/simple_animal/borer/B = has_brain_worms()
	if(!B || !B.host_brain)
		return
	var/mob/living/captive_brain/CB = B.host_brain
	var/input = stripped_input(src, "Please enter a message to tell the trapped mind.", "Message", "")
	if(!input)
		return

	to_chat(CB, SPAN_XENO("[B.truename] says: [input]"), type = MESSAGE_TYPE_RADIO)
	log_say("BORER: ([key_name(src)] to [key_name(CB)]) [input]", B)
	to_chat(src, SPAN_XENO("[B.truename] says: [input]"), type = MESSAGE_TYPE_RADIO)
	for (var/mob/dead in GLOB.dead_mob_list)
		var/track_borer = " (<a href='byond://?src=\ref[dead];track=\ref[B.host]'>F</a>)"
		if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
			dead.show_message(SPAN_BORER("BORER: ([B.truename][track_borer] to [real_name] (trapped mind)) says: [input]"), SHOW_MESSAGE_VISIBLE)




//############# TOPIC #############
/mob/living/simple_animal/borer/Topic(href, href_list, hsrc)
	if(href_list["borer_use_chem"])
		locate(href_list["src"])
		if(!istype(src, /mob/living/simple_animal/borer))
			return
		if(docile)
			to_chat(src, SPAN_XENOWARNING("You are feeling far too docile to do that."))
			return

		var/topic_chem = href_list["borer_use_chem"]
		var/datum/borer_chem/C = null

		for(var/datum in typesof(/datum/borer_chem))
			var/datum/borer_chem/test = datum
			if(initial(test.chem_id) == topic_chem)
				C = new test()
				break

		if(!C || !host || controlling || !src || stat)
			return
		var/datum/reagent/R = chemical_reagents_list[C.chem_id]
		if(enzymes < C.cost)
			to_chat(src, SPAN_XENOWARNING("You need [C.cost] enzymes stored to secrete [R.name]!"))
			return
		var/contamination = round(C.cost / 10)
		if(C.impure && ((contaminant + contamination) > max_contaminant))
			to_chat(src, SPAN_XENOWARNING("You are too contaminated to secrete [R.name]!"))
			return
		to_chat(src, SPAN_XENONOTICE("You squirt a measure of [R.name] from your reservoirs into [host]'s bloodstream."))
		contaminant += contamination
		host.reagents.add_reagent(C.chem_id, C.quantity)
		enzymes -= C.cost
		log_interact(src, host, "[key_name(src)] has injected [C.quantity] units of [R.name] into their host, [key_name(host)]")

		// This is used because we use a static set of datums to determine what chems are available,
		// instead of a table or something. Thus, when we instance it, we can safely delete it
		qdel(C)
	..()
