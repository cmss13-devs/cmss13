/mob/living/carbon/human/proc/mark_panel()
	set name = "Mark Panel"
	set category = "Yautja.Marks"
	set desc = "Allows you to mark your prey."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	var/mob/living/carbon/human/T = src
	if(!isyautja(T))
		return

	var/list/options = list()
	var/list/optionsp = list(
		"Un-Mark as Thralled",
		"Mark as Honored",
		"Un-Mark as Honored",
		"Mark as Dishonorable",
		"Un-Mark as Dishonorable",
		"Mark as Gear Carrier",
		"Un-Mark as Gear Carrier"
	)

	if(!T.hunter_data.prey)
		options += "Mark as Prey"
	else
		options += "Un-Mark as Prey"

	if(!T.hunter_data.thrall)
		options += "Mark as Thralled"

	options += optionsp

	var/input = tgui_input_list(usr, "Select which mark to apply", "Mark Panel", options)

	if(!input)
		return
	else if(input)

		switch(input)
			if("Mark as Prey")
				T.mark_for_hunt()
			if("Un-Mark as Prey")
				T.remove_from_hunt()
			if("Mark as Honored")
				T.mark_honored()
			if("Un-Mark as Honored")
				T.unmark_honored()
			if("Mark as Dishonorable")
				T.mark_dishonored()
			if("Un-Mark as Dishonorable")
				T.unmark_dishonored()
			if("Mark as Gear Carrier")
				T.mark_gear()
			if("Un-Mark as Gear Carrier")
				T.unmark_gear()
			if("Mark as Thralled")
				T.mark_thralled()
			if("Un-Mark as Thralled")
				T.unmark_thralled()

	return

// Mark for Hunt verbs
// Add prey for hunt
/mob/living/carbon/human/proc/mark_for_hunt()
	set category = "Yautja.Marks"
	set name = "Mark for Hunt"
	set desc = "Mark a target for the hunt."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	// Only one prey per pred
	if(hunter_data.prey)
		to_chat(src, SPAN_DANGER("You're already hunting something."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	// List all possible preys
	// We only target living humans and xenos
	var/list/target_list = list()
	for(var/mob/living/prey in view(7, usr.client))
		if((ishuman_strict(prey) || isxeno(prey)) && prey.stat != DEAD)
			target_list += prey

	var/mob/living/carbon/M = tgui_input_list(usr, "Target", "Choose a prey.", target_list)
	if(!M)
		return
	if(M.hunter_data.hunter)
		to_chat(src, SPAN_YAUTJABOLD("[M] is already being hunted by [M.hunter_data.hunter.real_name]!"))
		return
	hunter_data.prey = M
	M.hunter_data.hunter = src
	M.hunter_data.hunted = TRUE
	M.hud_set_hunter()

	// Notify the pred
	to_chat(src, SPAN_YAUTJABOLD("You have chosen [hunter_data.prey] as your next prey."))

	// Notify other preds
	message_all_yautja("[real_name] has chosen [hunter_data.prey] ([max(hunter_data.prey.life_kills_total, hunter_data.prey.default_honor_value)] honor) as their next target at \the [get_area_name(hunter_data.prey)].")

	// log to server file
	log_interact(src, hunter_data.prey, "[key_name(src)] has marked [key_name(hunter_data.prey)] for the Hunt in [get_area(hunter_data.prey)] ([x],[y],[z]).")

// Removing prey from hunt (i.e. it died, it bugged, it left the game, etc.)
/mob/living/carbon/human/proc/remove_from_hunt()
	set category = "Yautja.Marks"
	set name = "Remove from Hunt"
	set desc = "Unmark your hunt target."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!hunter_data.prey)
		to_chat(src, SPAN_DANGER("You're not hunting anything right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	if (alert(usr, "Are you sure you want to abandon this prey?", "Remove from Hunt:", "Yes", "No") != "Yes")
		return
	var/mob/living/carbon/prey = hunter_data.prey
	to_chat(src, SPAN_YAUTJABOLD("You have removed [prey] from your hunt."))
	prey.hunter_data.hunter = null
	prey.hunter_data.hunted = FALSE
	log_interact(src, hunter_data.prey, "[key_name(src)] has un-marked [key_name(hunter_data.prey)] for the Hunt")
	hunter_data.prey = null
	prey.hud_set_hunter()



/mob/living/carbon/human/proc/mark_honored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && (target.stat != DEAD))
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(T.hunter_data.honored)
		to_chat(src, SPAN_YAUTJABOLD("[T] has already been honored by [T.hunter_data.honored_set.real_name] for '[T.hunter_data.honored_reason]'!"))
		return

	var/reason = stripped_input(usr, "Enter the reason for marking your target as honored.", "Mark as Honored", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as Honored for '[reason]'.")
	message_all_yautja("[real_name] has marked [T] as Honored for '[reason]'.")

	T.hunter_data.honored_set = src
	hunter_data.honored_targets += T
	T.hunter_data.honored = TRUE
	T.hunter_data.honored_reason = "[reason]' by '[src.real_name]"
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_honored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && (target.stat != DEAD))
			if(target.hunter_data.honored)
				target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(!T.hunter_data.honored)
		to_chat(src, SPAN_YAUTJABOLD("[T] is not marked as honored!"))
		return

	if(!T.hunter_data.honored_set || src == T.hunter_data.honored_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as honored!")
		message_all_yautja("[real_name] has un-marked [T] as honored!'.")

		T.hunter_data.honored_set = null
		hunter_data.honored_targets += T
		T.hunter_data.honored = FALSE
		T.hunter_data.honored_reason = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("You cannot undo the actions of a living brother or sister!"))



/mob/living/carbon/human/proc/mark_dishonored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) || isxeno(target)) && target.stat != DEAD)
			target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(T.hunter_data.dishonored)
		to_chat(src, SPAN_YAUTJABOLD("[T] has already been marked as dishonorable by [T.hunter_data.dishonored_set.real_name] for '[T.hunter_data.dishonored_reason]'!"))
		return

	var/reason = stripped_input(usr, "Enter the reason for marking your target as dishonorable.", "Mark as Dishonorable", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as Dishonorable for '[reason]'.")
	message_all_yautja("[real_name] has marked [T] as Dishonorable for '[reason]'.")

	T.hunter_data.dishonored_set = src
	hunter_data.dishonored_targets += T
	T.hunter_data.dishonored = TRUE
	T.hunter_data.dishonored_reason = "[reason]' by '[src.real_name]"
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_dishonored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) || isxeno(target)) && target.stat != DEAD)
			if(target.job != "Predalien" && target.job != "Predalien Larva")
				if(target.hunter_data.dishonored)
					target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(!T.hunter_data.dishonored)
		to_chat(src, SPAN_YAUTJABOLD("[T] is not marked as dishonorable!"))
		return

	if(!T.hunter_data.dishonored_set || src == T.hunter_data.dishonored_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as dishonorable!")
		message_all_yautja("[real_name] has un-marked [T] as dishonorable!'.")

		T.hunter_data.dishonored_set = null
		hunter_data.dishonored_targets -= T
		T.hunter_data.dishonored = FALSE
		T.hunter_data.dishonored_reason = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("You cannot undo the actions of a living brother or sister!"))



/mob/living/carbon/human/proc/mark_gear()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) && target.stat != DEAD))
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(T.hunter_data.gear)
		to_chat(src, SPAN_YAUTJABOLD("[T] has already been marked as a gear carrier by [T.hunter_data.gear_set]!"))
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as a Gear Carrier!")
	message_all_yautja("[real_name] has marked [T] as a Gear Carrier!'.")

	T.hunter_data.gear_set = src
	hunter_data.gear_targets += T
	T.hunter_data.gear = TRUE
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_gear()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) && target.stat != DEAD))
			if(target.hunter_data.gear)
				target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(!T.hunter_data.gear)
		to_chat(src, SPAN_YAUTJABOLD("[T] is not marked as a gear carrier!"))
		return

	if(!T.hunter_data.gear_set || src == T.hunter_data.gear_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as a Gear Carrier!")
		message_all_yautja("[real_name] has un-marked [T] as a Gear Carrier!'.")

		T.hunter_data.gear_set = null
		hunter_data.gear_targets -= T
		T.hunter_data.gear = FALSE
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("You cannot undo the actions of a living brother or sister!"))


/mob/living/carbon/human/proc/mark_thralled()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	if(hunter_data.thrall)
		to_chat(src, SPAN_WARNING("You already have a thrall."))
		return

	// List all possible targets
	// We only target living humans
	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && target.stat != DEAD)
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(T.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[T] has already been thralled by [T.hunter_data.thralled_set.real_name] for '[T.hunter_data.thralled_reason]'!"))
		return

	var/reason = stripped_input(usr, "Enter the reason for marking your target as thralled.", "Mark as Thralled", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has taken [key_name(T)] as their Thrall for '[reason]'.")
	message_all_yautja("[real_name] has taken [T] as their Thrall for '[reason]'.")

	T.hunter_data.thralled_set = src
	T.hunter_data.thralled = TRUE
	T.hunter_data.thralled_reason = reason
	hunter_data.thrall = T
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_thralled()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	// List all possible targets
	// We only target living humans
	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && target.stat != DEAD)
			if(target.hunter_data.thralled)
				target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(!T.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[T] is not marked as thralled!"))
		return

	if(!T.hunter_data.thralled_set || src == T.hunter_data.thralled_set)

		log_interact(src, T, "[key_name(src)] has released [key_name(T)] from thralldom!")
		message_all_yautja("[real_name] has released [T] from thralldom!'.")

		T.hunter_data.thralled_set = null
		T.hunter_data.thralled = FALSE
		T.hunter_data.thralled_reason = null
		hunter_data.thrall = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("You cannot undo the actions of a living brother or sister!"))

/mob/living/carbon/human/proc/call_combi()
	set name = "Yank combi-stick"
	set category = "Yautja.Weapons"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."

	if(usr.is_mob_incapacitated())
		return FALSE
	call_combi_internal(usr)

/mob/living/carbon/human/proc/call_combi_internal(mob/caller, forced = FALSE)
	for(var/datum/effects/tethering/tether in caller.effects_list)
		if(istype(tether.tethered.affected_atom, /obj/item/weapon/yautja/combistick))
			var/obj/item/weapon/yautja/combistick/stick = tether.tethered.affected_atom
			stick.recall()
