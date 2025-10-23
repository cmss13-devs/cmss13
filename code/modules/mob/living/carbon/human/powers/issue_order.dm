/mob/living/carbon/human/proc/issue_order(order)
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
		if(!order || order == "cancel")
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
		if(!ishumansynth_strict(H))
			continue
		H.activate_order_buff(order, command_aura_strength, command_aura_duration)

	if(loc != T) //if we were inside something, the range() missed us.
		activate_order_buff(order, command_aura_strength, command_aura_duration)

	for(var/datum/action/A in actions)
		A.update_button_icon()

	// 1min cooldown on orders
	addtimer(CALLBACK(src, PROC_REF(make_aura_available)), COMMAND_ORDER_COOLDOWN)

	if(src.client?.prefs?.toggle_prefs & TOGGLE_LEADERSHIP_SPOKEN_ORDERS)
		var/spoken_order = ""
		switch(order)
			if(COMMAND_ORDER_MOVE)
				spoken_order = pick("*GET MOVING*!", "*GO, GO, GO*!", "*WE ARE ON THE MOVE*!", "*MOVE IT*!", "*DOUBLE TIME*!", "*KEEP UP LADIES*!", "*MOVE, MOVE, MOVE*!", "*ADVANCE*!", "*KICK YOUR FEET, TWINKLETOES*!", "*ON YOUR FEET SOLDIER, WE ARE LEAVING*!", "*WE ARE OSCAR MIKE*!", "*FORWARD*!", "*GET UP THERE*!", "*GET ON ME*!", "*CHARGE, FORWARD*!", "*ON ME MEN, LET'S MOVE*!", "*STEPPING OFF*!", "*STEP IT UP, LET'S ROLL*!", "*LET'S ROLL*!", "*STACK UP ON ME*!", "*FALL IN*!")
			if(COMMAND_ORDER_HOLD)
				spoken_order = pick("*DUCK AND COVER*!", "*HOLD THE LINE*!", "*HOLD POSITION*!", "*STAND YOUR GROUND*!", "*STAND AND FIGHT*!", "*HOLD YOUR GROUND*!", "*HUNKER*!", "*HUNKER DOWN*!", "*HOLD HERE*!", "*HOLD WITH ME*!", "*TO ME, HOLD*!", "*DEFENSIVE POSITIONS*!", "*TAKE COVER AND FIRE*!", "*STAND FAST*!", "*NOT ONE STEP BACK*!", "*HOLD FAST*!", "*DIG IN AND HOLD*!", "*BRACE*!", "*TO THE LAST MAN*!", "*KEEP YOUR NERVE, HOLD STRONG*!", "*NO RETREAT, STAND FIRM*!")
			if(COMMAND_ORDER_FOCUS)
				spoken_order = pick("*FOCUS FIRE*!", "*PICK YOUR TARGETS*!", "*CENTER MASS*!", "*SHORT-CONTROLLED BURSTS*!", "*AIM YOUR SHOTS*!", "*ON MY MARK*!", "*AIMED SHOTS*!", "*GO FOR THE KILL*!", "*SHOOT 'EM DEAD*!", "*KILL THEM ALL*!", "*SUPPRESSIVE FIRE*!", "*TIGHTEN YOUR SHOTS*!", "*LOCK AND LOAD*!", "*TARGET THEIR WEAK SPOTS*!", "*ZERO IN ON THE ENEMY*!", "*EYES ON THE PRIZE*!", "*LET'S ROCK*!", "*HIT 'EM WHERE IT HURTS*!", "*SLAUGHTER 'EM*!", "*BRING THE PAIN*!", "*STEADY YOUR AIM*!", "*EYES UP AND FIRE*!", "*FIRING LANES*!", "*CROSSHAIRS, PEOPLE*!", "*STRIKE*!")
		say(spoken_order) // if someone thinks about adding new lines, it'll be better to split the current ones we have into two different lists per order for readability, and have a coin flip pick between spoken_orders 1 or 2
	else
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


/mob/living/carbon/human/proc/activate_order_buff(order, strength, duration)
	if(!order || !strength)
		return

	switch(order)
		if(COMMAND_ORDER_MOVE)
			mobility_aura_count++
			mobility_aura = clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			protection_aura_count++
			protection_aura = clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
			pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			marksman_aura_count++
			marksman_aura = clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)

	hud_set_order()

	if(duration)
		addtimer(CALLBACK(src, PROC_REF(deactivate_order_buff), order), duration)


/mob/living/carbon/human/proc/deactivate_order_buff(order)
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
