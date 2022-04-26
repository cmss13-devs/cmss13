// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"Who do you wish to tackle?", "Tackle", choices)

	if(!T || !src || stat || !Adjacent(T))
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.KnockDown(rand(0.5,3))
	else
		KnockDown(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1)
	if(failed)
		KnockDown(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if((O.client && !( O.blinded )))
			O.show_message(SPAN_DANGER("<B>[src] [failed ? "tried to tackle" : "has tackled"] down [T]!</B>"), 1)

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"Who do you wish to leap at?", "Leap", choices)

	if(!T || !src || stat || get_dist(get_turf(T), get_turf(src)) > 6)
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	visible_message(SPAN_WARNING("<b>[src]</b> leaps at [T]!"))
	var/target = get_step(get_turf(T), get_turf(src))
	throw_atom(target, 5, SPEED_VERY_FAST, src)
	playsound(loc, 'sound/voice/shriek1.ogg', 25, 1)

	addtimer(CALLBACK(src, .proc/finish_leap, T), 5)

/mob/living/carbon/human/proc/finish_leap(mob/living/T)
	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!Adjacent(T))
		to_chat(src, SPAN_DANGER("You miss!"))
		return

	T.KnockDown(5)

	if(T == src || T.anchored)
		return FALSE

	start_pulling(T)

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated(TRUE) || lying)
		to_chat(src, SPAN_DANGER("You cannot do that in your current state."))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_DANGER("You are not grabbing anyone."))
		return

	if(usr.grab_level < GRAB_AGGRESSIVE)
		to_chat(src, SPAN_DANGER("You must have an aggressive grab to gut your prey!"))
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>[src]</b> rips viciously at [G.grabbed_thing]'s body with its claws!"))

	if(istype(G.grabbed_thing,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.grabbed_thing
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib(create_cause_data("gutting", usr))
	else
		var/mob/living/M = G.grabbed_thing
		if(!istype(M))
			return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib(create_cause_data("gutting", usr))

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = tgui_input_list(usr, "Select a creature!", "Speak to creature", targets)

	if(!target)
		return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = trim(strip_html(text))

	if(!text)
		return

	var/mob/M = targets[target]

	if(istype(M, /mob/dead/observer) || M.stat == DEAD)
		to_chat(src, "Not even a [species.name] can speak to the dead.")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, SPAN_NOTICE(" Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == species.name)
			return
		to_chat(H, SPAN_DANGER("Your nose begins to bleed..."))
		H.drip(1)

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = strip_html(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, SPAN_XENOWARNING(" You hear a strange, alien voice in your head... \italic [msg]"))
		to_chat(src, SPAN_XENOWARNING(" You said: \"[msg]\" to [M]"))
	return

/mob/living/carbon/human/proc/issue_order(var/order)
	if(!HAS_TRAIT(src, TRAIT_LEADERSHIP))
		to_chat(src, SPAN_WARNING("You are not qualified to issue orders!"))
		return

	if(stat)
		to_chat(src, SPAN_WARNING("You cannot give an order in your current state."))
		return

	if(!command_aura_available)
		to_chat(src, SPAN_WARNING("You have recently given an order. Calm down."))
		return

	if(!skills)
		return FALSE
	var/order_level = skills.get_skill_level(SKILL_LEADERSHIP)
	if(!order_level)
		order_level = SKILL_LEAD_TRAINED

	if(!order)
		order = tgui_input_list(src, "Choose an order", "Order to send", list(COMMAND_ORDER_MOVE, COMMAND_ORDER_HOLD, COMMAND_ORDER_FOCUS, "help", "cancel"))
		if(order == "help")
			to_chat(src, SPAN_NOTICE("<br>Orders give a buff to nearby soldiers for a short period of time, followed by a cooldown, as follows:<br><B>Move</B> - Increased mobility and chance to dodge projectiles.<br><B>Hold</B> - Increased resistance to pain and combat wounds.<br><B>Focus</B> - Increased gun accuracy and effective range.<br>"))
			return
		if(order == "cancel")
			return

		if(!command_aura_available)
			to_chat(src, SPAN_WARNING("You have recently given an order. Calm down."))
			return

	command_aura_available = FALSE
	var/command_aura_strength = order_level
	var/command_aura_duration = (order_level + 1) * 10 SECONDS

	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in range(COMMAND_ORDER_RANGE, T))
		if(H.stat == DEAD)
			continue
		H.activate_order_buff(order, command_aura_strength, command_aura_duration)

	if(loc != T) //if we were inside something, the range() missed us.
		activate_order_buff(order, command_aura_strength, command_aura_duration)

	for(var/datum/action/A in actions)
		A.update_button_icon()

	// 1min cooldown on orders
	addtimer(CALLBACK(src, .proc/make_aura_available), COMMAND_ORDER_COOLDOWN)

	visible_message(SPAN_BOLDNOTICE("[src] gives an order to [order]!"), SPAN_BOLDNOTICE("You give an order to [order]!"))

/mob/living/carbon/human/proc/make_aura_available()
	to_chat(src, SPAN_NOTICE("You can issue an order again."))
	command_aura_available = TRUE
	for(var/datum/action/A in actions)
		A.update_button_icon()


/mob/living/carbon/human/verb/issue_order_verb()
	set name = "Issue Order"
	set desc = "Issue an order to nearby humans, using your authority to strengthen their resolve."
	set category = "IC"

	issue_order()


/mob/living/carbon/human/proc/activate_order_buff(var/order, var/strength, var/duration)
	if(!order || !strength)
		return

	switch(order)
		if(COMMAND_ORDER_MOVE)
			mobility_aura_count++
			mobility_aura = Clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			protection_aura_count++
			protection_aura = Clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
			pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			marksman_aura_count++
			marksman_aura = Clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)

	hud_set_order()

	if(duration)
		addtimer(CALLBACK(src, .proc/deactivate_order_buff, order), duration)


/mob/living/carbon/human/proc/deactivate_order_buff(var/order)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			if(mobility_aura_count > 1)
				mobility_aura_count--
			else
				mobility_aura_count = 0
				mobility_aura = 0
		if(COMMAND_ORDER_HOLD)
			if(protection_aura_count > 1)
				protection_aura_count--
			else
				pain.reset_pain_reduction()
				protection_aura_count = 0
				protection_aura = 0
		if(COMMAND_ORDER_FOCUS)
			if(marksman_aura_count > 1)
				marksman_aura_count--
			else
				marksman_aura_count = 0
				marksman_aura = 0

	hud_set_order()

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	if(!resting)
		KnockDown(1) //so that the mob immediately falls over

	resting = !resting

	to_chat(src, SPAN_NOTICE("You are now [resting ? "resting." : "getting up."]"))

/mob/living/carbon/human/proc/toggle_inherent_nightvison()
	set category = "Synthetic"
	set name = "Toggle Nightvision"
	set desc = "Toggles inherent nightvision."

	if(usr.is_mob_incapacitated())
		return

	default_lighting_alpha = default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE : LIGHTING_PLANE_ALPHA_VISIBLE
	update_sight()

	to_chat(src, SPAN_NOTICE("Your vision is now set to <b>[default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? "Normal Vision" : "Nightvision"]</b>."))

// Used for synthetics
/mob/living/carbon/human/synthetic/proc/toggle_HUD()
	set category = "Synthetic"
	set name = "Toggle HUDs"
	set desc = "Toggles various HUDs."

	if(!isSynth(usr) || usr.is_mob_incapacitated())
		return

	var/hud_choice = tgui_input_list(usr, "Choose a HUD to toggle", "Toggle HUD", list("Medical HUD", "Security HUD"))
	if(usr.is_mob_incapacitated())
		return

	var/datum/mob_hud/H
	var/chosen_HUD = 1
	switch(hud_choice)
		if("Medical HUD")
			H = huds[MOB_HUD_MEDICAL_ADVANCED]
		if("Security HUD")
			H = huds[MOB_HUD_SECURITY_ADVANCED]
			chosen_HUD = 2
		else
			return

	if(synthetic_HUD_toggled[chosen_HUD])
		synthetic_HUD_toggled[chosen_HUD] = FALSE
		H.remove_hud_from(src)
		to_chat(src, SPAN_INFO("<B>[hud_choice] Disabled</B>"))
	else
		synthetic_HUD_toggled[chosen_HUD] = TRUE
		H.add_hud_to(src)
		to_chat(src, SPAN_INFO("<B>[hud_choice] Enabled</B>"))
