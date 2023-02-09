/datum/action/xeno_action/onclick/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro

/datum/action/xeno_action/onclick/build_tunnel/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/X = owner
	if(!istype(X))
		return FALSE
	if(X.tunnel_delay)
		return FALSE
	return ..()

/datum/action/xeno_action/onclick/build_tunnel/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, SPAN_XENOWARNING("You should finish up what you're doing before digging."))
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, SPAN_XENOWARNING("You can't do that from there."))
		return

	if(SSticker?.mode?.hardcore)
		to_chat(X, SPAN_XENOWARNING("A certain presence is preventing you from digging tunnels here."))
		return

	if(!T.can_dig_xeno_tunnel() || !is_ground_level(T.z))
		to_chat(X, SPAN_XENOWARNING("You scrape around, but you can't seem to dig through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in X.loc)
		to_chat(X, SPAN_XENOWARNING("There already is a tunnel here."))
		return

	if(X.tunnel_delay)
		to_chat(X, SPAN_XENOWARNING("You are not ready to dig a tunnel again."))
		return

	if(X.get_active_hand())
		to_chat(X, SPAN_XENOWARNING("You need an empty claw for this!"))
		return

	if(!X.check_plasma(plasma_cost))
		return

	var/area/AR = get_area(T)

	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	X.visible_message(SPAN_XENONOTICE("[X] begins digging out a tunnel entrance."), \
	SPAN_XENONOTICE("You begin digging out a tunnel entrance."), null, 5)
	if(!do_after(X, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(X, SPAN_WARNING("Your tunnel caves in as you stop digging it."))
		return
	if(!X.check_plasma(plasma_cost))
		return
	X.visible_message(SPAN_XENONOTICE("\The [X] digs out a tunnel entrance."), \
	SPAN_XENONOTICE("You dig out an entrance to the tunnel network."), null, 5)

	var/obj/structure/tunnel/tunnelobj = new(T, X.hivenumber)
	X.tunnel_delay = 1
	addtimer(CALLBACK(src, PROC_REF(cooldown_end)), 4 MINUTES)
	var/msg = strip_html(input("Add a description to the tunnel:", "Tunnel Description") as text|null)
	var/description
	if(msg)
		description = msg
		msg = "[msg] ([get_area_name(tunnelobj)])"
		log_admin("[key_name(X)] has named a new tunnel \"[msg]\".")
		msg_admin_niche("[X]/([key_name(X)]) has named a new tunnel \"[msg]\".")
		tunnelobj.tunnel_desc = "[msg]"

	if(X.hive.living_xeno_queen || X.hive.allow_no_queen_actions)
		for(var/mob/living/carbon/xenomorph/target_for_message as anything in X.hive.totalXenos)
			var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
			var/overwatch_src = XENO_OVERWATCH_SRC_HREF
			to_chat(target_for_message, SPAN_XENOANNOUNCE("Hive: A new tunnel[description ? " ([description])" : ""] has been created by [X] (<a href='byond://?src=\ref[target_for_message];[overwatch_target]=\ref[X];[overwatch_src]=\ref[target_for_message]'>watch</a>) at <b>[get_area_name(tunnelobj)]</b>."))

	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You will be ready to dig a new tunnel in 4 minutes."))
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)

/datum/action/xeno_action/onclick/build_tunnel/proc/cooldown_end()
	var/mob/living/carbon/xenomorph/X = owner
	to_chat(X, SPAN_NOTICE("You are ready to dig a tunnel again."))
	X.tunnel_delay = 0

//Queen Abilities
/datum/action/xeno_action/onclick/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 50 SECONDS
	plasma_cost = 250
	cooldown_message = "You feel your throat muscles vibrate. You are ready to screech again."
	no_cooldown_msg = FALSE // Needed for onclick actions
	ability_primacy = XENO_SCREECH

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
	xeno.create_shriekwave() //Adds the visual effect. Wom wom wom

	for(var/mob/mob in view())
		if(mob && mob.client)
			if(isxeno(mob))
				shake_camera(mob, 10, 1)
			else
				shake_camera(mob, 30, 1) //50 deciseconds, SORRY 5 seconds was way too long. 3 seconds now

	var/list/mobs_in_view = list()
	for(var/mob/living/carbon/M in oview(7, xeno))
		mobs_in_view += M
	for(var/mob/living/carbon/M in orange(10, xeno))
		if(SEND_SIGNAL(M, COMSIG_MOB_SCREECH_ACT, xeno) & COMPONENT_SCREECH_ACT_CANCEL)
			continue
		M.handle_queen_screech(xeno, mobs_in_view)

	apply_cooldown()

	..()

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	ability_name = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 MINUTES
	plasma_cost = 200
	cooldown_message = "You feel your anger return. You are ready to gut again."

/datum/action/xeno_action/activable/gut/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!action_cooldown_check())
		return
	if(xeno.queen_gut(target))
		apply_cooldown()
	..()

/datum/action/xeno_action/onclick/psychic_whisper
	name = "Psychic Whisper"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/onclick/psychic_whisper/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state(TRUE))
		return
	var/list/target_list = list()
	for(var/mob/living/possible_target in view(7, X))
		if(possible_target == X || !possible_target.client) continue
		target_list += possible_target

	var/mob/living/M = tgui_input_list(usr, "Target", "Send a Psychic Whisper to whom?", target_list, theme="hive_status")
	if(!M) return

	if(!X.check_state(TRUE))
		return

	var/msg = strip_html(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(X)]->[M.key] : [msg]")
		if(!istype(M, /mob/living/carbon/xenomorph))
			to_chat(M, SPAN_XENO("You hear a strange, alien voice in your head. \"[msg]\""))
		else
			to_chat(M, SPAN_XENO("You hear the voice of [X] resonate in your head. \"[msg]\""))
		to_chat(X, SPAN_XENONOTICE("You said: \"[msg]\" to [M]"))

/datum/action/xeno_action/onclick/psychic_radiance
	name = "Psychic Radiance"
	action_icon_state = "psychic_radiance"
	plasma_cost = 100

/datum/action/xeno_action/onclick/psychic_radiance/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state(TRUE))
		return
	var/list/target_list = list()
	var/msg = strip_html(input("Message:", "Psychic Radiance") as text|null)
	if(!msg || !X.check_state(TRUE))
		return
	for(var/mob/living/possible_target in view(12, X))
		if(possible_target == X || !possible_target.client)
			continue
		target_list += possible_target
		if(!istype(possible_target, /mob/living/carbon/xenomorph))
			to_chat(possible_target, SPAN_XENO("You hear a strange, alien voice in your head. \"[msg]\""))
		else
			to_chat(possible_target, SPAN_XENO("You hear the voice of [X] resonate in your head. \"[msg]\""))
	if(!length(target_list))
		return
	var/targetstring = english_list(target_list)
	to_chat(X, SPAN_XENONOTICE("You said: \"[msg]\" to [targetstring]"))
	log_say("PsychicRadiance: [key_name(X)]->[targetstring] : [msg]")

/datum/action/xeno_action/activable/queen_give_plasma
	name = "Give Plasma (400)"
	action_icon_state = "queen_give_plasma"
	ability_name = "give plasma"
	plasma_cost = 400
	macro_path = /datum/action/xeno_action/verb/verb_plasma_xeno
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 12 SECONDS

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
		to_chat(X, SPAN_XENOWARNING("You cannot give plasma to yourself!"))
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

/datum/action/xeno_action/onclick/queen_order
	name = "Give Order (100)"
	action_icon_state = "queen_order"
	plasma_cost = 100

/datum/action/xeno_action/onclick/queen_order/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/xenomorph/target = X.observed_xeno
		if(target.stat != DEAD && target.client)
			if(X.check_plasma(plasma_cost))
				var/input = stripped_input(X, "This message will be sent to the overwatched xeno.", "Queen Order", "")
				if(!input)
					return
				var/queen_order = SPAN_XENOANNOUNCE("<b>[X]</b> reaches you:\"[input]\"")
				if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					X.use_plasma(plasma_cost)
					to_chat(target, "[queen_order]")
					log_admin("[queen_order]")
					message_staff("[key_name_admin(X)] has given the following Queen order to [target]: \"[input]\"", 1)

	else
		to_chat(X, SPAN_WARNING("You must overwatch the Xenomorph you want to give orders to."))

/datum/action/xeno_action/onclick/queen_award
	name = "Give Royal Jelly (500)"
	action_icon_state = "queen_award"
	plasma_cost = 500

/datum/action/xeno_action/onclick/queen_award/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!xeno.check_state())
		return
	if(!xeno.check_plasma(plasma_cost))
		return
	if(give_jelly_award(xeno.hive))
		xeno.use_plasma(plasma_cost)

/datum/action/xeno_action/onclick/queen_word
	name = "Word of the Queen (50)"
	action_icon_state = "queen_word"
	plasma_cost = 50
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/onclick/queen_word/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	// We don't test or apply the cooldown here because the proc does it since verbs can activate it too
	xeno.hive_message()

/datum/action/xeno_action/onclick/queen_tacmap
	name = "View Xeno Tacmap"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0

/datum/action/xeno_action/onclick/queen_tacmap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	xeno.xeno_tacmap()

/////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/xenomorph/proc/add_abilities()
	if(!base_actions)
		return
	for(var/action_path in base_actions)
		give_action(src, action_path)
