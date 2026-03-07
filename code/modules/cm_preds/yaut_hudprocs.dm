/mob/living/carbon/human/proc/mark_panel()
	set name = "Mark Panel"
	set category = "Yautja.Marks"
	set desc = "Allows you to mark your prey."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	var/mob/living/carbon/human/target = src
	if(!isyautja(target))
		return

	var/list/options = list()
	var/list/optionsp = list(
		"Un-Mark as Thralled",
		"Mark as Blooded",
		"Mark as Honored",
		"Un-Mark as Honored",
		"Mark as Dishonorable",
		"Un-Mark as Dishonorable",
		"Mark as Gear Carrier",
		"Un-Mark as Gear Carrier",
		"Mark as Student",
		"Un-Mark as Student"
	)

	if(!target.hunter_data.prey)
		options += "Mark as Prey"
	else
		options += "Un-Mark as Prey"

	if(!target.hunter_data.thrall)
		options += "Mark as Thralled"

	options += optionsp

	var/input = tgui_input_list(usr, "Select which mark to apply", "Mark Panel", options)

	if(!input)
		return
	else if(input)

		switch(input)
			if("Mark as Prey")
				target.mark_for_hunt()
			if("Un-Mark as Prey")
				target.remove_from_hunt()
			if("Mark as Honored")
				target.mark_honored()
			if("Un-Mark as Honored")
				target.unmark_honored()
			if("Mark as Dishonorable")
				target.mark_dishonored()
			if("Un-Mark as Dishonorable")
				target.unmark_dishonored()
			if("Mark as Gear Carrier")
				target.mark_gear()
			if("Un-Mark as Gear Carrier")
				target.unmark_gear()
			if("Mark as Thralled")
				target.mark_thralled()
			if("Un-Mark as Thralled")
				target.unmark_thralled()
			if("Mark as Blooded")
				target.mark_blooded()
			if("Mark as Student")
				target.mark_youngblood()
			if("Un-Mark as Student")
				target.unmark_youngblood()

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

	if(!isyautja(src) && !isthrall(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	// List all possible preys
	// We only target living humans and xenos
	var/list/target_list = list()
	for(var/mob/living/prey in range(7, usr.client))
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

	if(!isyautja(src) && !isthrall(src))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
		if(ishuman_strict(target))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
		if(ishuman_strict(target) || isxeno(target))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
		if(ishuman(target))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
		if(ishuman(target))
			if(target.hunter_data.gear)
				target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!T)
		return
	if(!T.hunter_data.gear)
		to_chat(src, SPAN_YAUTJABOLD("[T] is not marked as a gear carrier!"))
		return


	log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as a Gear Carrier!")
	message_all_yautja("[real_name] has un-marked [T] as a Gear Carrier!'.")

	T.hunter_data.gear_set = null
	hunter_data.gear_targets -= T
	T.hunter_data.gear = FALSE
	T.hud_set_hunter()


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
	for(var/mob/living/carbon/target in range(7, usr.client))
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
	for(var/mob/living/carbon/target in range(7, usr.client))
		if(ishuman_strict(target))
			if(target.hunter_data.thralled)
				target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/human/thrall  = tgui_input_list(usr, "Target", "Choose a target.", target_list)

	if(!thrall)
		return
	if(!thrall.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[thrall] is not marked as thralled!"))
		return

	if(!thrall.hunter_data.thralled_set || src == thrall.hunter_data.thralled_set)

		log_interact(src, thrall, "[key_name(src)] has released [key_name(thrall)] from thralldom!")
		message_all_yautja("[real_name] has released [thrall] from thralldom!'.")

		thrall.set_species("Human")
		thrall.allow_gun_usage = TRUE
		thrall.hunter_data.thralled_set = null
		thrall.hunter_data.thralled = FALSE
		thrall.hunter_data.thralled_reason = null
		hunter_data.thrall = null
		thrall.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("You cannot undo the actions of a living brother or sister!"))

/mob/living/carbon/human/proc/mark_blooded() //No mark_unblooded, once a thrall becomes a blooded hunter, there is no going back.
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in long_range(7, usr))
		if(ishuman_strict(target) && target.stat != DEAD)
			target_list += target

	var/mob/living/carbon/newblood = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	if(!newblood)
		return
	if(newblood.hunter_data.blooded)
		to_chat(src, SPAN_YAUTJABOLD("[newblood] has already been blooded by [newblood.hunter_data.blooded_set.real_name] for '[newblood.hunter_data.blooded_reason]'!"))
		return
	if(newblood.faction == FACTION_YAUTJA_YOUNG || newblood.hunter_data.thralled) //Only youngbloods or thralls can become blooded hunters.

		var/reason = stripped_input(usr, "Enter the reason for marking your target as blooded.", "Mark as Blooded", "", 120)

		if(!reason)
			return

		log_interact(src, newblood, "[key_name(src)] has blooded [key_name(newblood)] for '[reason]'.")
		message_all_yautja("[real_name] has blooded [newblood] for '[reason]'.")

		ADD_TRAIT(newblood, TRAIT_YAUTJA_TECH, "Yautja Tech")
		to_chat(newblood, SPAN_YAUTJABOLD("You are a Blooded Thrall. Focus on interacting with Predators and developing your reputation. You should be observant and discreet while exercising discretionary restraint when hunting worthy prey. Learn Yautja lore and their Honor Code. If you have any questions, ask the whitelisted players in LOOC."))

		newblood.set_skills(/datum/skills/yautja/warrior) //Overrides exsiting skill path to allow for use of the medicomp. SKills never updated to proper hero mob status prior to this.
		newblood.hunter_data.blooded_set = src
		newblood.hunter_data.blooded = TRUE
		newblood.hunter_data.blooded_reason = reason
		hunter_data.newblood = newblood
		newblood.hud_set_hunter()

	if(newblood.faction == FACTION_YAUTJA_YOUNG)
		return

	else if(newblood.hunter_data.thralled)
		var/predtitle = (stripped_input(usr, "Enter the newblood's new name.", "Blooded Name", "" , MAX_NAME_LEN))
		change_real_name(newblood, html_decode(predtitle))
		GLOB.yautja_mob_list += newblood
		newblood.faction = FACTION_BLOODED_HUNTER
		newblood.faction_group = FACTION_LIST_YAUTJA

	else if(!newblood.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[newblood] has not proved themselves worthy of blooding."))
		return


/mob/living/carbon/human/proc/mark_youngblood() // Marks for designating a teacher for a youngblood
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(src.faction == FACTION_YAUTJA_YOUNG)
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in long_range(7, usr))
		if(target.faction == FACTION_YAUTJA_YOUNG && target.stat != DEAD)
			target_list[target.real_name] = target

	var/choice = tgui_input_list(usr, "Pupils", "Choose a youngblood to teach.", target_list)
	if(!choice)
		return

	var/mob/living/carbon/target_youngblood = target_list[choice]

	if(target_youngblood.hunter_data.youngblood_marked)
		to_chat(src, SPAN_WARNING("[target_youngblood] has already been claimed by [target_youngblood.hunter_data.youngblood_set.real_name]."))
		return
	if(target_youngblood.faction != FACTION_YAUTJA_YOUNG) //Only youngbloods can be marked as pupils.
		to_chat(src, SPAN_WARNING("[target_youngblood] is not a Youngblood."))
		return

	log_interact(src, target_youngblood, "[key_name(src)] has marked [key_name(target_youngblood)] as their pupil.")
	message_all_yautja("[real_name] has marked [target_youngblood] as their pupil.")

	to_chat(target_youngblood, SPAN_YAUTJABOLD("You have been marked as a Youngblood by [real_name]. Focus on learning from your mentor and developing your reputation. You should be observant and discreet while exercising discretionary restraint when hunting worthy prey. If you have any questions ask the whitelisted players either in character or LOOC."))

	target_youngblood.hunter_data.youngblood_set = src
	target_youngblood.hunter_data.youngblood_marked = TRUE
	hunter_data.youngblood = target_youngblood
	var/image/holder = hud_list[HUNTER_CLAN]
	if(src.client && src.client.clan_info && src.client.clan_info.clan_id)
		var/datum/entity/clan/player_clan = GET_CLAN(src.client.clan_info.clan_id)
		player_clan.sync()
		holder.color = player_clan.color
		var/image/youngblood_holder = target_youngblood.hud_list[HUNTER_CLAN]
		if(youngblood_holder)
			youngblood_holder.color = player_clan.color
	target_youngblood.hud_set_hunter()

/mob/living/carbon/human/proc/unmark_youngblood()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("You're not able to do that right now."))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("How did you get this verb?"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in long_range(7, usr))
		if(target.faction == FACTION_YAUTJA_YOUNG && target.stat != DEAD)
			target_list[target.real_name] = target

	var/choice = tgui_input_list(usr, "Target", "Choose a target.", target_list)
	var/mob/living/carbon/human/young_hunter = target_list[choice]

	if(!young_hunter)
		return
	if(!young_hunter.hunter_data.youngblood_marked)
		to_chat(src, SPAN_WARNING("[young_hunter] is not marked as a student!"))
		return

	if(!young_hunter.hunter_data.youngblood_set || src == young_hunter.hunter_data.youngblood_set)

		log_interact(src, young_hunter, "[key_name(src)] has un-marked [key_name(young_hunter)] as their student!")
		message_all_yautja("[real_name] has un-marked [young_hunter] as their student!'.")

		young_hunter.hunter_data.youngblood_set = null
		young_hunter.hunter_data.youngblood_marked = FALSE
		hunter_data.youngblood = null
		young_hunter.hud_set_hunter()
	else
		to_chat(src, SPAN_WARNING("You cannot undo the actions of a living hunter!"))

/mob/living/carbon/human/proc/call_combi()
	set name = "Yank combi-stick"
	set category = "Yautja.Weapons"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."

	if(usr.is_mob_incapacitated())
		return FALSE
	call_combi_internal(usr)

/mob/living/carbon/human/proc/call_combi_internal(mob/user, forced = FALSE)
	for(var/datum/effects/tethering/tether in user.effects_list)
		if(istype(tether.tethered.affected_atom, /obj/item/weapon/yautja/chained))
			var/obj/item/weapon/yautja/chained/stick = tether.tethered.affected_atom
			stick.recall()
