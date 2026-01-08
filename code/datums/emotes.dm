/**
 * # Emote
 *
 * Most of the text that's not someone talking is based off of this.
 *
 * Yes, the displayed message is stored on the datum, it would cause problems
 * for emotes with a message that can vary, but that's handled differently in
 * run_emote(), so be sure to use can_message_change if you plan to have
 * different displayed messages from player to player.
 *
 */
/datum/emote
	/// What calls the emote.
	var/key = ""
	/// This will also call the emote.
	var/key_third_person = ""
	/// Message displayed when emote is used.
	var/message = ""
	///Message displayed for audible emotes if someone's deaf. Only use this if key_third_person can't be acceptably used.
	///ie. if someone says *medic and someone's deaf, they'd receive [X] calls for a medic! silently.,  which is not ideal.
	var/alt_message
	/// Message with %t at the end to allow adding params to the message, like for mobs doing an emote relatively to something else.
	var/message_param = ""
	/// Whether the emote is visible and/or audible bitflag
	var/emote_type = EMOTE_VISIBLE
	/// Checks if the mob can use its hands before performing the emote.
	var/hands_use_check = FALSE
	/// Will only work if the emote is EMOTE_AUDIBLE.
	var/muzzle_ignore = FALSE
	/// Types that are allowed to use that emote.
	var/list/mob_type_allowed_typecache = /mob
	/// Types that are NOT allowed to use that emote.
	var/list/mob_type_blacklist_typecache
	/// Types that can use this emote regardless of their state.
	var/list/mob_type_ignore_stat_typecache
	/// In which state can you use this emote? (Check stat.dm for a full list of them)
	var/stat_allowed = CONSCIOUS
	/// Sound to play when emote is called.
	var/sound
	/// Used for the honk borg emote.
	var/vary = FALSE
	/// Can only code call this event instead of the player.
	var/only_forced_audio = FALSE
	/// The cooldown between the uses of the emote.
	var/cooldown = 0.8 SECONDS
	/// Does this message have a message that can be modified by the user?
	var/can_message_change = FALSE
	/// How long is the cooldown on the audio of the emote, if it has one?
	var/audio_cooldown = 2 SECONDS
	/// What message to make the user send with the emote?
	var/say_message
	/// What volume should the sound be played at?
	var/volume = 50
	/// Should this emote generate a keybind?
	var/keybind = TRUE
	/// Does this emote have a custom keybind category?
	var/keybind_category = CATEGORY_EMOTE
	/// Should this emote replace pronouns?
	var/replace_pronouns = TRUE

/datum/emote/New()
	switch(mob_type_allowed_typecache)
		if(/mob)
			mob_type_allowed_typecache = GLOB.typecache_mob
		if(/mob/living)
			mob_type_allowed_typecache = GLOB.typecache_living
		else
			mob_type_allowed_typecache = typecacheof(mob_type_allowed_typecache)

	mob_type_blacklist_typecache = typecacheof(mob_type_blacklist_typecache)
	mob_type_ignore_stat_typecache = typecacheof(mob_type_ignore_stat_typecache)

/**
 * Handles the modifications and execution of emotes.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * params - Parameters added after the emote.
 * * type_override - Override to the current emote_type.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns TRUE if it was able to run the emote, FALSE otherwise.
 */
/datum/emote/proc/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = TRUE
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	var/msg = select_message_type(user, message, intentional)
	if(params && message_param)
		msg = select_param(user, params)



	if(replace_pronouns)
		msg = replace_pronoun(user, msg)

	if(say_message)
		user.say(say_message)

	var/tmp_sound = get_sound(user)
	if(TIMER_COOLDOWN_CHECK(user, type))
		to_chat(user, SPAN_NOTICE("You just did an emote. Wait awhile."))
		return
	else if(tmp_sound && should_play_sound(user, intentional))
		if(TIMER_COOLDOWN_CHECK(user, COOLDOWN_MOB_AUDIO))
			return
		if(!HAS_TRAIT(user, TRAIT_EMOTE_CD_EXEMPT))
			TIMER_COOLDOWN_START(user, type, audio_cooldown)
			S_TIMER_COOLDOWN_START(user, COOLDOWN_MOB_AUDIO, 20 SECONDS) // We won't ever want to stop this except during qdel
		playsound(user, tmp_sound, volume, vary)

	log_emote("[user.name]/[user.key] : [msg ? msg : key]")

	if(!msg)
		return

	var/paygrade = user.get_paygrade()
	var/formatted_message = "<b>[paygrade][user]</b> [msg]"
	var/user_turf = get_turf(user)
	var/list/seeing_obj = list()
	if (user.client)
		for(var/mob/ghost as anything in GLOB.dead_mob_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTSIGHT && !(ghost in viewers(user_turf, null)))
				ghost.show_message(formatted_message)
	if(emote_type & EMOTE_AUDIBLE) //emote is audible
		var/formatted_deaf_message = "<b>[paygrade][user]</b> [alt_message ? alt_message : key_third_person] silently."
		user.audible_message(formatted_message, deaf_message = formatted_deaf_message)
	else if(emote_type & EMOTE_VISIBLE)	//emote is visible
		user.visible_message(formatted_message, blind_message = SPAN_EMOTE("You see how <b>[user]</b> [msg]"))
	if(emote_type & EMOTE_IMPORTANT)
		for(var/mob/living/viewer in viewers())
			if(is_blind(viewer) && isdeaf(viewer))
				to_chat(viewer, msg)

	if(intentional)
		if(emote_type & EMOTE_VISIBLE)
			var/list/viewers = get_mobs_in_view(7, user)
			for(var/mob/current_mob in viewers)
				for(var/obj/object in current_mob.contents)
					if((object.flags_atom & USES_SEEING))
						seeing_obj |= object
				if(!(current_mob.client?.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES))
					viewers -= current_mob
			run_langchat(user, viewers)
		else if(emote_type & EMOTE_AUDIBLE)
			var/list/heard = get_mobs_in_view(7, user)
			for(var/mob/current_mob in heard)
				for(var/obj/object in current_mob.contents)
					if((object.flags_atom & USES_HEARING))
						seeing_obj |= object
				if(current_mob.ear_deaf)
					heard -= current_mob
					continue
				if(!(current_mob.client?.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES))
					heard -= current_mob
			run_langchat(user, heard)

	for(var/obj/object as anything in seeing_obj)
		object.see_emote(user, msg, (emote_type & EMOTE_AUDIBLE))

	SEND_SIGNAL(user, COMSIG_MOB_EMOTED(key))


/**
 * Handles above-head chat automatically running on an emote.
 *
 * Arguments:
 * * user - Person trying to send the emote
 * * group - The list of people that will see this emote being
 */
/datum/emote/proc/run_langchat(mob/user, list/group)
	var/adjusted_message = message
	if(replace_pronouns)
		adjusted_message = replace_pronoun(user, message)
	user.langchat_speech(adjusted_message, group, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("emote", "langchat_small"))

/**
 * For handling emote cooldown, return true to allow the emote to happen.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns FALSE if the cooldown is not over, TRUE if the cooldown is over.
 */
/datum/emote/proc/check_cooldown(mob/user, intentional)
	if(!intentional)
		return TRUE
	if(user.emotes_used && user.emotes_used[src] + cooldown > world.time)
		var/datum/emote/default_emote = /datum/emote
		if(cooldown > initial(default_emote.cooldown)) // only worry about longer-than-normal emotes
			to_chat(user, SPAN_DANGER("You must wait another [DisplayTimeText(user.emotes_used[src] - world.time + cooldown)] before using that emote."))
		return FALSE
	if(!user.emotes_used)
		user.emotes_used = list()
	user.emotes_used[src] = world.time
	return TRUE

/**
 * To get the sound that the emote plays, for special sound interactions depending on the mob.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 *
 * Returns the sound that will be made while sending the emote.
 */
/datum/emote/proc/get_sound(mob/living/user)
	return sound //by default just return this var.

/**
 * To replace pronouns in the inputed string with the user's proper pronouns.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * msg - The string to modify.
 *
 * Returns the modified msg string.
 */
/datum/emote/proc/replace_pronoun(mob/user, msg)
	if(findtext(msg, "their"))
		msg = replacetext(msg, "their", user.p_their())
	if(findtext(msg, "them"))
		msg = replacetext(msg, "them", user.p_them())
	if(findtext(msg, "they"))
		msg = replacetext(msg, "they", user.p_they())
	if(findtext(msg, "%s"))
		msg = replacetext(msg, "%s", user.p_s())
	return msg

/**
 * Selects the message type to override the message with.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * msg - The string to modify.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns the new message, or msg directly, if no change was needed.
 */
/datum/emote/proc/select_message_type(mob/user, msg, intentional)
	// Basically, we don't care that the others can use datum variables, because they're never going to change.
	. = msg

/**
 * Replaces the %t in the message in message_param by params.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * params - Parameters added after the emote.
 *
 * Returns the modified string.
 */
/datum/emote/proc/select_param(mob/user, params)
	return replacetext(message_param, "%t", params)

/**
 * Check to see if the user is allowed to run the emote.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * status_check - Bool that says whether we should check their stat or not.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns a bool about whether or not the user can run the emote.
 */
/datum/emote/proc/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	if(!is_type_in_typecache(user, mob_type_allowed_typecache))
		return FALSE
	if(is_type_in_typecache(user, mob_type_blacklist_typecache))
		return FALSE
	if(intentional)
		if(emote_type & EMOTE_FORCED_AUDIO)
			return FALSE
	if(status_check && !is_type_in_typecache(user, mob_type_ignore_stat_typecache))
		if(user.stat > stat_allowed)
			if(!intentional)
				return FALSE
			switch(user.stat)
				if(UNCONSCIOUS)
					to_chat(user, SPAN_WARNING("You cannot [key] while unconscious!"))
				if(DEAD)
					to_chat(user, SPAN_WARNING("You cannot [key] while dead!"))
			return FALSE
		if(hands_use_check && (user.r_hand && user.l_hand))
			if(!intentional)
				return FALSE
			to_chat(user, SPAN_WARNING("You cannot use your hands to [key] right now!"))
			return FALSE

	return TRUE

/**
 * Check to see if the user should play a sound when performing the emote.
 *
 * Arguments:
 * * user - Person that is doing the emote.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns a bool about whether or not the user should play a sound when performing the emote.
 */
/datum/emote/proc/should_play_sound(mob/user, intentional = FALSE)
	if(emote_type & EMOTE_AUDIBLE && !muzzle_ignore)
		if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
			return FALSE

		if(istype(user.wear_mask, /obj/item/clothing/mask/facehugger))
			return FALSE

	if(only_forced_audio && intentional)
		return FALSE
	return TRUE

/**
* Allows the intrepid coder to send a basic emote
* Takes text as input, sends it out to those who need to know after some light parsing
* If you need something more complex, make it into a datum emote
* Arguments:
* * text - The text to send out
*
* Returns TRUE if it was able to run the emote, FALSE otherwise.
*/
/mob/proc/manual_emote(text) //Just override the song and dance
	. = TRUE
	if(stat != CONSCIOUS)
		return

	if(!text)
		CRASH("Someone passed nothing to manual_emote(), fix it")

	log_emote(text)

	var/paygrade = get_paygrade()

	var/rendered_text = "<b>[paygrade][src]</b> [text]"

	var/origin_turf = get_turf(src)
	if(client)
		for(var/mob/ghost as anything in GLOB.dead_mob_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTSIGHT && !(ghost in viewers(origin_turf, null)))
				to_chat(ghost, rendered_text)

	visible_message(rendered_text)
	var/list/viewers = get_mobs_in_view(7, src)
	for(var/mob/current_mob in viewers)
		if(!(current_mob.client?.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES))
			viewers -= current_mob
	langchat_speech(text, viewers, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("emote", "langchat_small"))
