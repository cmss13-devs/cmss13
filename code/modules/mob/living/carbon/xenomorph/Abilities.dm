/datum/action/xeno_action/activable/xeno_spit
	name = "Xeno Spit"
	action_icon_state = "xeno_spit"
	ability_name = "xeno spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	cooldown_message = "You feel your neurotoxin glands swell with ichor. You can spit again."
	xeno_cooldown = 60 SECONDS

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(src, SPAN_WARNING("You can't spit from here!"))
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(X)

	if(!current_turf)
		return

	plasma_cost = X.ammo.spit_cost

	if(!check_and_use_plasma_owner())
		return

	xeno_cooldown = X.caste.spit_delay + X.ammo.added_spit_delay

	X.visible_message(SPAN_XENOWARNING("[X] spits at [A]!"), \
	SPAN_XENOWARNING("You spit at [A]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(X.loc, sound_to_play, 25, 1)

	var/obj/item/projectile/P = new /obj/item/projectile(initial(X.caste_name), X, current_turf)
	P.generate_bullet(X.ammo)
	P.permutated += X
	P.def_zone = X.get_limbzone_target()
	P.fire_at(A, X, X, X.ammo.max_range, X.ammo.shell_speed)

	apply_cooldown()
	..()

//Carrier Abilities

/datum/action/xeno_action/activable/throw_hugger
	name = "Use/Throw Facehugger"
	action_icon_state = "throw_hugger"
	ability_name = "throw facehugger"
	macro_path = /datum/action/xeno_action/verb/verb_throw_facehugger
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.throw_hugger(A)
	..()

/datum/action/xeno_action/activable/throw_hugger/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	return !X.threw_a_hugger

/datum/action/xeno_action/activable/retrieve_egg
	name = "Retrieve Egg"
	action_icon_state = "retrieve_egg"
	ability_name = "retrieve egg"
	macro_path = /datum/action/xeno_action/verb/verb_retrieve_egg
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.retrieve_egg(A)
	..()

//Hivelord Abilities

/datum/action/xeno_action/onclick/toggle_speed
	name = "Resin Walker (50)"
	action_icon_state = "toggle_speed"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_resin_walker
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_speed/can_use_action()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.weedwalking_activated || X.plasma_stored >= plasma_cost))
		return TRUE

/datum/action/xeno_action/onclick/toggle_speed/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	X.recalculate_move_delay = TRUE

	if(X.weedwalking_activated)
		to_chat(X, SPAN_WARNING("You feel less in tune with the resin."))
		X.weedwalking_activated = 0
		return

	if(!X.check_plasma(plasma_cost))
		return
	X.weedwalking_activated = 1
	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You become one with the resin. You feel the urge to run!"))

/datum/action/xeno_action/onclick/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro

/datum/action/xeno_action/onclick/build_tunnel/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.tunnel_delay) return FALSE
	return ..()

/datum/action/xeno_action/onclick/build_tunnel/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, SPAN_XENOWARNING("You should finish up what you're doing before digging."))
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, SPAN_XENOWARNING("You can't do that from there."))
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
	X.start_dig = new /obj/structure/tunnel(T, X.hivenumber)
	X.tunnel_delay = 1
	addtimer(CALLBACK(src, .proc/cooldown_end), 4 MINUTES)
	var/msg = strip_html(input("Add a description to the tunnel:", "Tunnel Description") as text|null)
	if(msg)
		msg = "[msg] ([get_area_name(X.start_dig)])"
		log_admin("[key_name(X)] has named a new tunnel \"[msg]\".")
		msg_admin_niche("[X]/([key_name(X)]) has named a new tunnel \"[msg]\".")
		X.start_dig.tunnel_desc = "[msg]"

	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You will be ready to dig a new tunnel in 4 minutes."))
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)

/datum/action/xeno_action/onclick/build_tunnel/proc/cooldown_end()
	var/mob/living/carbon/Xenomorph/X = owner
	to_chat(X, SPAN_NOTICE("You are ready to dig a tunnel again."))
	X.tunnel_delay = 0

//Queen Abilities
/datum/action/xeno_action/activable/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 50 SECONDS
	plasma_cost = 250
	cooldown_message = "You feel your throat muscles vibrate. You are ready to screech again."

/datum/action/xeno_action/activable/screech/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	//screech is so powerful it kills huggers in our hands
	if(istype(X.r_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/FH = X.r_hand
		if(FH.stat != DEAD)
			FH.Die()

	if(istype(X.l_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/FH = X.l_hand
		if(FH.stat != DEAD)
			FH.Die()

	playsound(X.loc, X.screech_sound_effect, 75, 0, status = 0)
	X.visible_message(SPAN_XENOHIGHDANGER("[X] emits an ear-splitting guttural roar!"))
	X.create_shriekwave() //Adds the visual effect. Wom wom wom

	for(var/mob/M in view())
		if(M && M.client)
			if(isXeno(M))
				shake_camera(M, 10, 1)
			else
				shake_camera(M, 30, 1) //50 deciseconds, SORRY 5 seconds was way too long. 3 seconds now

	for(var/mob/living/carbon/M in oview(7, X))
		if(SEND_SIGNAL(M, COMSIG_MOB_SCREECH_ACT, X) & COMPONENT_SCREECH_ACT_CANCEL)
			continue

		M.scream_stun_timeout = 20 SECONDS
		var/dist = get_dist(X, M)
		if(dist <= 4)
			to_chat(M, SPAN_DANGER("An ear-splitting guttural roar shakes the ground beneath your feet!"))
			M.AdjustStunned(4)
			M.KnockDown(4)
			if(!M.ear_deaf)
				M.ear_deaf += 5 //Deafens them temporarily
		else if(dist >= 5 && dist < 7)
			M.AdjustStunned(3)
			if(!M.ear_deaf)
				M.ear_deaf += 2
			to_chat(M, SPAN_DANGER("The roar shakes your body to the core, freezing you in place!"))

	apply_cooldown()

	..()

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	ability_name = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/gut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.queen_gut(A)
	..()

/datum/action/xeno_action/onclick/psychic_whisper
	name = "Psychic Whisper"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/onclick/psychic_whisper/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/list/target_list = list()
	for(var/mob/living/possible_target in view(7, X))
		if(possible_target == X || !possible_target.client) continue
		target_list += possible_target

	var/mob/living/M = tgui_input_list(usr, "Target", "Send a Psychic Whisper to whom?", target_list)
	if(!M) return

	if(!X.check_state())
		return

	var/msg = strip_html(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(X)]->[M.key] : [msg]")
		to_chat(M, SPAN_XENO("You hear a strange, alien voice in your head. \"[msg]\""))
		to_chat(X, SPAN_XENONOTICE("You said: \"[msg]\" to [M]"))

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
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/Xenomorph/target = A
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
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
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

/datum/action/xeno_action/activable/place_construction
	name = "Order Construction (400)"
	action_icon_state = "morph_resin"
	ability_name = "order construction"
	macro_path = /datum/action/xeno_action/verb/place_construction
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/place_construction/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return FALSE

	//Make sure construction is unrestricted
	if(X.hive && X.hive.construction_allowed == XENO_LEADER && X.hive_pos == NORMAL_XENO)
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(X.hive && X.hive.construction_allowed == XENO_QUEEN && !istype(X.caste, /datum/caste_datum/queen))
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE

	var/turf/T = get_turf(A)

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	var/choice = XENO_STRUCTURE_CORE
	if(X.hive.has_structure(XENO_STRUCTURE_CORE) || !X.hive.can_build_structure(XENO_STRUCTURE_CORE))
		choice = tgui_input_list(X, "Choose a structure to build", "Build structure", X.hive.hive_structure_types + "help" + "cancel")
	if(choice == "help")
		var/message = "<br>Placing a construction node creates a template for special structures that can benefit the hive, which require the insertion of [MATERIAL_CRYSTAL] to construct the following:<br>"
		for(var/structure_name in X.hive.hive_structure_types)
			message += "[get_xeno_structure_desc(structure_name)]<br>"
		to_chat(X, SPAN_NOTICE(message))
		return
	if(choice == "cancel" || !X.check_state(1) || !X.check_plasma(400))
		return FALSE
	if(!do_after(X, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if((choice == XENO_STRUCTURE_CORE) && isXenoQueen(X) && X.hive.has_structure(XENO_STRUCTURE_CORE))
		if(X.hive.hive_location.hardcore)
			to_chat(X, SPAN_WARNING("You can't rebuild this structure"))
			return

		if(alert(X, "Are you sure that you want to move the hive and destroy the old hive core?", , "Yes", "No") == "No")
			return
		qdel(X.hive.hive_location)
	else if(!X.hive.can_build_structure(choice))
		to_chat(X, SPAN_WARNING("You can't build any more [choice]s for the hive."))
		return FALSE

	var/structure_type = X.hive.hive_structure_types[choice]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!X.hive.can_build_structure(structure_template.name) && !(choice == XENO_STRUCTURE_CORE))
		to_chat(X, SPAN_WARNING("You cannot build any more [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	if (QDELETED(T))
		to_chat(X, SPAN_WARNING("You cannot build here!"))
		qdel(structure_template)
		return FALSE

	var/queen_on_zlevel = !X.hive.living_xeno_queen || X.hive.living_xeno_queen.z == T.z
	if(!queen_on_zlevel)
		to_chat(X, SPAN_WARNING("Your link to the Queen is too weak here. She is on another world."))
		qdel(structure_template)
		return FALSE

	if(!T.is_weedable())
		to_chat(X, SPAN_WARNING("It's too early to be placing [structure_template.name] here!"))
		qdel(structure_template)
		return FALSE


	if(structure_template.requires_node)
		for(var/turf/TA in range(T, structure_template.block_range))
			if(TA.density)
				to_chat(X, SPAN_WARNING("You need more open space to build here."))
				qdel(structure_template)
				return FALSE

		if(!X.check_alien_construction(T))
			to_chat(X, SPAN_WARNING("You need more open space to build here."))
			qdel(structure_template)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in T
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.linked_hive.hivenumber != X.hivenumber)
			to_chat(X, SPAN_WARNING("You can only shape on [lowertext(GLOB.hive_datum[X.hivenumber].prefix)]hive weeds. Find a hive node or core before you start building!"))
			qdel(structure_template)
			return FALSE

	X.use_plasma(400)
	X.place_construction(T, structure_template)

/datum/action/xeno_action/deevolve
	name = "De-Evolve a Xenomorph"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 500

/datum/action/xeno_action/deevolve/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		if(!X.check_plasma(plasma_cost)) return

		if(T.is_ventcrawling)
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
			return

		if(!isturf(T.loc))
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
			return

		if(T.health <= 0)
			to_chat(X, SPAN_XENOWARNING("[T] is too weak to be deevolved."))
			return

		if(!T.caste.deevolves_to)
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved."))
			return

		var/newcaste = T.caste.deevolves_to
		if(newcaste == "Larva")
			to_chat(X, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
			return

		var/confirm = alert(X, "Are you sure you want to deevolve [T] from [T.caste.caste_name] to [newcaste]?", , "Yes", "No")
		if(confirm == "No")
			return

		var/reason = stripped_input(X, "Provide a reason for deevolving this xenomorph, [T]")
		if(isnull(reason))
			to_chat(X, SPAN_XENOWARNING("You must provide a reason for deevolving [T]."))
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T)
			return

		if(T.is_ventcrawling)
			return

		if(!isturf(T.loc))
			return

		if(T.health <= 0)
			return

		to_chat(T, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

		var/xeno_type

		switch(newcaste)
			if("Runner")
				xeno_type = /mob/living/carbon/Xenomorph/Runner
			if("Drone")
				xeno_type = /mob/living/carbon/Xenomorph/Drone
			if("Sentinel")
				xeno_type = /mob/living/carbon/Xenomorph/Sentinel
			if("Spitter")
				xeno_type = /mob/living/carbon/Xenomorph/Spitter
			if("Lurker")
				xeno_type = /mob/living/carbon/Xenomorph/Lurker
			if("Warrior")
				xeno_type = /mob/living/carbon/Xenomorph/Warrior
			if("Defender")
				xeno_type = /mob/living/carbon/Xenomorph/Defender
			if("Burrower")
				xeno_type = /mob/living/carbon/Xenomorph/Burrower

		//From there, the new xeno exists, hopefully
		var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(T), T)

		if(!istype(new_xeno))
			//Something went horribly wrong!
			to_chat(X, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
			if(new_xeno)
				qdel(new_xeno)
			return

		if(T.mind)
			T.mind.transfer_to(new_xeno)
		else
			new_xeno.key = T.key
			if(new_xeno.client)
				new_xeno.client.change_view(world_view_size)
				new_xeno.client.pixel_x = 0
				new_xeno.client.pixel_y = 0

		//Regenerate the new mob's name now that our player is inside
		new_xeno.generate_name()

		// If the player has self-deevolved before, don't allow them to do it again
		if(!(/mob/living/carbon/Xenomorph/verb/Deevolve in T.verbs))
			remove_verb(new_xeno, /mob/living/carbon/Xenomorph/verb/Deevolve)

		new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_name] emerges from the husk of \the [T]."), \
		SPAN_XENODANGER("[X] makes you regress into your previous form."))

		if(X.hive.living_xeno_queen && X.hive.living_xeno_queen.observed_xeno == T)
			X.hive.living_xeno_queen.overwatch(new_xeno)

		message_staff("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")

		if(round_statistics && !new_xeno.statistic_exempt)
			round_statistics.track_new_participant(T.faction, -1) //so an evolved xeno doesn't count as two.
		SSround_recording.recorder.track_player(new_xeno)
		qdel(T)
		X.use_plasma(plasma_cost)

	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))


/////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/Xenomorph/proc/add_abilities()
	if(actions && actions.len)
		for(var/action_path in actions)
			if(ispath(action_path))
				actions -= action_path
				var/datum/action/xeno_action/A = new action_path()
				A.give_action(src)
