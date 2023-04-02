/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"

/mob/living/captive_brain/say(message)
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (muted)."))
			return
		if(client.handle_spam_prevention(message, MUTE_IC))
			return

	if(istype(loc,/mob/living/carbon/cortical_borer))
		message = trim(sanitize(copytext(message, 1, MAX_MESSAGE_LEN)))
		if(!message)
			return
		if(stat == DEAD)
			return say_dead(message)
		var/mob/living/carbon/cortical_borer/B = loc
		to_chat(src, SPAN_BORER("You whisper silently, [message]"), type = MESSAGE_TYPE_RADIO)
		to_chat(B.host, SPAN_BORER("The captive mind of [src] whispers, \"[message]\""), type = MESSAGE_TYPE_RADIO)
		log_say("BORER: ([key_name(src)] to [key_name(B.host)]) [message]", src)
		for (var/mob/dead in GLOB.dead_mob_list)
			var/track_borer = " (<a href='byond://?src=\ref[dead];track=\ref[B.host]'>F</a>)"
			if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
				dead.show_message(SPAN_BORER("BORER: ([name] (trapped mind) to [B.truename][track_borer]) whispers: [message]"), SHOW_MESSAGE_VISIBLE)

/mob/living/captive_brain/say_understands(mob/other, datum/language/speaking = null)
	var/mob/living/carbon/cortical_borer/B = loc
	if(!istype(B))
		log_debug(EXCEPTION("Trapped mind found without a borer!"), src)
		return FALSE
	return B.host.say_understands(other, speaking)

/mob/living/captive_brain/emote(act, m_type = 1, message = null, intentional = FALSE, force_silence = FALSE)
	return

/mob/living/captive_brain/resist()
	var/mob/living/carbon/cortical_borer/B = loc
	if(!istype(B))
		log_debug(EXCEPTION("Trapped mind found without a borer!"), src)
		return FALSE

	to_chat(src, SPAN_DANGER("You begin doggedly resisting the parasite's control (this will take approximately sixty seconds)."))
	to_chat(B.host, SPAN_XENOWARNING("You feel the captive mind of [src] begin to resist your control."))

	var/delay = (rand(350,450) + B.host.getBrainLoss())
	addtimer(CALLBACK(src, PROC_REF(return_control), B), delay)
	return TRUE

/mob/living/carbon/cortical_borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	icon = 'icons/mob/brainslug.dmi'
	icon_state = "Borer"
	speed = 0
	a_intent = INTENT_HARM
	status_flags = CANPUSH
	attacktext = "nips"
	friendly = "prods"
	mob_size = MOB_SIZE_SMALL
	density = 0
	pass_flags = PASS_FLAGS_CRAWLER
	mob_size = MOB_SIZE_SMALL
	faction = list("creature")
	hud_possible = list(HEALTH_HUD,STATUS_HUD)
	universal_understand = TRUE

	holder_type = /obj/item/holder/borer

	var/generation = 1
	var/stealthy = FALSE
	var/static/list/borer_names = list(
			"Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary",
			"Septenary", "Octonary", "Novenary", "Decenary", "Undenary", "Duodenary",
			)
	var/talk_inside_host = FALSE			// So that borers don't accidentally give themselves away on a botched message
	var/used_dominate
	var/attempting_to_dominate = FALSE		// To prevent people from spam opening the Dominate Victim input

	var/enzymes = 10						// Enzymes used for chemical injection.
	var/max_enzymes = 500
	var/contaminant = 0						//Contaminant builds up on enzyme usage, roughly proportionate to cost of use.
	var/max_contaminant = 120				//Decreases through hibernation or reproduction.
	var/hibernating = FALSE					//Usable inside a host, but not when controlling. Allows clearing of impurities.

	var/mob/living/carbon/human/host		// Human host for the brain worm.
	var/truename							// Name used for brainworm-speak.
	var/mob/living/captive_brain/host_brain	// Used for swapping control of the body back and forth.
	var/controlling							// Used in human death check.
	var/docile = FALSE						// Anti-Parasite or Anti-Enzyme chemicals can stop borers from acting.
	var/bonding = FALSE
	var/leaving = FALSE
	var/hiding = FALSE
	var/can_reproduce = FALSE				// Locked to manual override to prevent things getting out of hand.

	var/infect_humans = TRUE				// Locked for normal use.
	var/infect_xenos = FALSE
	var/infect_yautja = FALSE

	var/list/datum/reagent/synthesized_chems

	var/current_actions = ACTION_SET_HOSTLESS
	var/list/actions_hostless = list(
		/datum/action/innate/borer/toggle_hide,
		/datum/action/innate/borer/freeze_victim,
		/datum/action/innate/borer/infest_host
	)
	var/list/actions_humanoidhost = list(
		/datum/action/innate/borer/take_control,
		/datum/action/innate/borer/talk_to_host,
		/datum/action/innate/borer/leave_body,
		/datum/action/innate/borer/hibernate,
		/datum/action/innate/borer/scan_chems,
		/datum/action/innate/borer/make_chems
	)
	var/list/actions_xenohost = list(
		/datum/action/innate/borer/take_control,
		/datum/action/innate/borer/talk_to_host,
		/datum/action/innate/borer/leave_body,
		/datum/action/innate/borer/hibernate
	)
	var/list/actions_control = list(
		/datum/action/innate/borer/give_back_control,
		/datum/action/innate/borer/make_larvae,
		/datum/action/innate/borer/talk_to_brain,
		/datum/action/innate/borer/torment
	)

//################### INIT & LIFE ###################//
/mob/living/carbon/cortical_borer/New(atom/newloc, gen=1, ERT = FALSE, reproduction = 0)
	..(newloc)
	SSmob.living_misc_mobs += src
	generation = gen
	add_language(LANGUAGE_BORER)
	var/mob_number = rand(1000,9999)
	real_name = "Cortical Borer [mob_number]"
	truename = "[borer_names[min(generation, borer_names.len)]] [mob_number]"
	can_reproduce = reproduction
	give_new_actions(ACTION_SET_HOSTLESS)
	//GrantBorerActions()
	GiveBorerHUD()
	if((!is_admin_level(z)) && ERT)
		summon()

/mob/living/carbon/cortical_borer/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		PF.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/cortical_borer/initialize_pain()
	pain = new /datum/pain/zombie(src)
/mob/living/carbon/cortical_borer/initialize_stamina()
	stamina = new /datum/stamina/none(src)

/mob/living/carbon/cortical_borer/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getFireLoss() - getBruteLoss() - getToxLoss() //Borer can only take brute, fire and tox damage.

	if(stat != DEAD && !gibbing)
		if(health <= -50) //dead
			death(last_damage_data)
			return
		else if(health <= 0) //in crit
			handle_crit()

/mob/living/carbon/cortical_borer/proc/handle_crit()
	if(stat == DEAD || gibbing)
		return

	sound_environment_override = SOUND_ENVIRONMENT_NONE
	set_stat(UNCONSCIOUS)
	blinded = TRUE
	if(layer != initial(layer)) //Unhide
		layer = initial(layer)
	recalculate_move_delay = TRUE
	if(!lying)
		update_canmove()
	update_icons()

/mob/living/carbon/cortical_borer/death()
	var/datum/language/corticalborer/c_link = GLOB.all_languages[LANGUAGE_BORER]
	c_link.broadcast(src, null, src.truename, TRUE)
	SSmob.living_misc_mobs -= src
	. = ..()

/mob/living/carbon/cortical_borer/rejuvenate()
	..()
	update_icons()
	update_canmove()
	SSmob.living_misc_mobs |= src

/mob/living/carbon/cortical_borer/Destroy()
	SSmob.living_misc_mobs -= src
	return ..()
//###################################################//

/mob/living/carbon/cortical_borer/proc/summon()
	var/datum/emergency_call/custom/em_call = new()
	em_call.name = real_name
	em_call.mob_max = 1
	em_call.players_to_offer = list(src)
	em_call.owner = null
	em_call.ert_message = "A new Cortical Borer has been birthed!"
	em_call.objectives = "Create enjoyable Roleplay. Do not kill your host. Do not take control unless granted permission or directed to by admins. Hivemind is :0 (That's Zero, not Oscar)"

	em_call.activate(announce = FALSE)

	message_admins("A new Cortical Borer has spawned at [get_area(loc)]")

/mob/living/carbon/cortical_borer/update_icons()
	if(stat == DEAD)
		icon_state = "Borer Dead"

	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Borer Resting"
		else
			icon_state = "Borer Stunned"
	else
		icon_state = "Borer"

/mob/living/carbon/cortical_borer/proc/GiveBorerHUD()
	var/datum/mob_hud/H = huds[MOB_HUD_BRAINWORM]
	H.add_hud_to(src)

/mob/living/carbon/cortical_borer/can_ventcrawl()
	return TRUE

/mob/living/carbon/cortical_borer/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		PF.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/cortical_borer/get_status_tab_items()
	. = ..()

	var/CR = "Yes"
	if(!can_reproduce)
		CR = "Forbidden"
	else if((enzymes < BORER_LARVAE_COST))
		CR = "No"

	. += ""
	. += "Borer:"
	. += "Name: [truename]"
	. += "Can Reproduce: [CR]"
	. += "Enzymes: [round(enzymes)]/[round(max_enzymes)]"
	. += "Contaminant: [round(contaminant)]/[round(max_contaminant)]"
	if(host)
		. += ""
		. += "Host Brain Damage: [host.brainloss]/100"

/mob/living/carbon/cortical_borer/say(message)//I need to parse the message properly so it doesn't look stupid
	var/datum/language/parsed_language = parse_language(message)
	var/new_message = message
	if(parsed_language)
		new_message = copytext(message, 3)
		if(istype(parsed_language, /datum/language/corticalborer))
			parsed_language.broadcast(src, new_message)
			return
	if(hibernating)
		to_chat(src, SPAN_WARNING("You cannot speak aloud while hibernating!"))
		return
	if(loc == host && !talk_inside_host)
		to_chat(src, SPAN_WARNING("You've disabled audible speech while inside a host! Re-enable it under the borer tab, or stick to borer communications."))
		return
	. = ..()


/mob/living/carbon/cortical_borer/Life(delta_time)
	..()
	update_canmove()
	update_icons()
	if(host)
		if(!stat && host.stat != DEAD)
			if(((host.chem_effect_flags & CHEM_EFFECT_ANTI_PARASITE) && !host.reagents.has_reagent("benzyme")) || host.reagents.has_reagent("bcure"))
				if(!docile)
					if(controlling)
						to_chat(host, SPAN_XENODANGER("You feel the flow of a soporific chemical in your host's blood, lulling you into docility."))
					else
						to_chat(src, SPAN_XENODANGER("You feel the flow of a soporific chemical in your host's blood, lulling you into docility."))
					docile = TRUE
			else
				if(docile)
					if(controlling)
						to_chat(host, SPAN_XENONOTICE("You shake off your lethargy as the chemical leaves your host's blood."))
					else
						to_chat(src, SPAN_XENONOTICE("You shake off your lethargy as the chemical leaves your host's blood."))
					docile = FALSE
			if(!hibernating && (enzymes < max_enzymes))
				enzymes++
			if(contaminant > 0)
				if(hibernating)
					contaminant = max(contaminant -= 1, 0)
				else
					contaminant = max(contaminant -= 0.1, 0)
			if(controlling)
				if(docile)
					to_chat(host, SPAN_XENOWARNING("You are feeling far too docile to continue controlling your host..."))
					host.release_control()
					return
	else
		if(contaminant > 0)
			if(!luminosity)
				SetLuminosity(2)
			contaminant = max(contaminant - 0.3, 0)
		else
			SetLuminosity(0)
/datum/action/innate/borer
	icon_file = 'icons/mob/hud/actions_borer.dmi'

/datum/action/innate/borer/talk_to_host
	name = "Converse with Host"
	action_icon_state = "borer_whisper"

/datum/action/innate/borer/talk_to_host/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	B.Communicate()

/datum/action/innate/borer/infest_host
	name = "Infest"
	action_icon_state = "borer_infest"

/datum/action/innate/borer/infest_host/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	B.infest()

/datum/action/innate/borer/toggle_hide
	name = "Toggle Hide"
	action_icon_state = "borer_hiding_0"

/datum/action/innate/borer/toggle_hide/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	B.hide_borer()

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_borer.dmi', button, "borer_hiding_[B.hiding]")

/datum/action/innate/borer/talk_to_borer
	name = "Converse with Borer"
	action_icon_state = "borer_whisper"

/datum/action/innate/borer/talk_to_borer/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner.has_brain_worms()
	B.host = owner
	B.host.borer_comm()

/datum/action/innate/borer/talk_to_brain
	name = "Converse with Trapped Mind"
	action_icon_state = "borer_whisper"

/datum/action/innate/borer/talk_to_brain/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner.has_brain_worms()
	B.host = owner
	B.host.trapped_mind_comm()

/datum/action/innate/borer/take_control
	name = "Assume Control"
	action_icon_state = "borer_control"

/datum/action/innate/borer/take_control/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	if(B.hibernating)
		to_chat(B, SPAN_WARNING("You cannot do that while hibernating!"))
		return
	B.bond_brain()

/datum/action/innate/borer/give_back_control
	name = "Release Control"
	action_icon_state = "borer_leave"

/datum/action/innate/borer/give_back_control/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner.has_brain_worms()
	B.host = owner
	B.host.release_control()

/datum/action/innate/borer/leave_body
	name = "Leave Host"
	action_icon_state = "borer_leave"

/datum/action/innate/borer/leave_body/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	if(B.hibernating)
		to_chat(B, SPAN_WARNING("You cannot do that while hibernating!"))
		return
	B.release_host()

/datum/action/innate/borer/make_chems
	name = "Secrete Chemicals"
	action_icon_state = "borer_chems"

/datum/action/innate/borer/make_chems/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	if(B.hibernating)
		to_chat(B, SPAN_WARNING("You cannot do that while hibernating!"))
		return
	B.secrete_chemicals()

/datum/action/innate/borer/scan_chems
	name = "Scan Chemicals"
	action_icon_state = "borer_scan"

/datum/action/innate/borer/scan_chems/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	if(B.hibernating)
		to_chat(B, SPAN_WARNING("You cannot do that while hibernating!"))
		return
	borerscan(B, B.host)

/datum/action/innate/borer/make_larvae
	name = "Reproduce"
	action_icon_state = "borer_reproduce"

/datum/action/innate/borer/make_larvae/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner.has_brain_worms()
	B.host = owner
	B.host.spawn_larvae()

/datum/action/innate/borer/freeze_victim
	name = "Dominate Victim"
	action_icon_state = "borer_stun"

/datum/action/innate/borer/freeze_victim/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	B.dominate_victim()

/datum/action/innate/borer/torment
	name = "Torment Host"
	action_icon_state = "borer_torment"

/datum/action/innate/borer/torment/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner.has_brain_worms()
	B.host = owner
	B.host.punish_host()

/datum/action/innate/borer/hibernate
	name = "Toggle Hibernation"
	action_icon_state = "borer_sleeping_0"

/datum/action/innate/borer/hibernate/action_activate()
	var/mob/living/carbon/cortical_borer/B = owner
	B.hibernate()
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_borer.dmi', button, "borer_sleeping_[B.hibernating]")

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
