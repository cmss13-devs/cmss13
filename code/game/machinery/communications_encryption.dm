#define MAX_OFFSET 26

// ----- Cipher Computer / Parent -----

/obj/structure/machinery/computer/almayer_encryption
	name = "encryption cipher computer"
	desc = "The IBM series 10 computer retrofitted to work as a encryption cipher computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
	icon_state = "sensor_comp2"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	deconstructible = FALSE
	/// The kind of skill used to check req_skill_level against
	var/req_skill = SKILL_INTEL
	/// The minimum skill to interact with this computer
	var/req_skill_level = SKILL_INTEL_TRAINED
	/// The faction that this computer affects for comms
	var/faction = FACTION_MARINE
	/// What tgui panel this computer will display
	var/tgui_mode = "cipher"
	/// How many punch cards to preload with
	var/preload_punchcards = 10
	/// The challenge length - set automatically via first entry for announcement_challenges
	var/static/cipher_length = 7
	COOLDOWN_DECLARE(print_cooldown)

/obj/structure/machinery/computer/almayer_encryption/Initialize()
	. = ..()
	var/phrases = CONFIG_GET(str_list/announcement_challenges)
	cipher_length = length(phrases[1])
	RegisterSignal(SSdcs, COMSIG_GLOB_CONFIG_LOADED, PROC_REF(on_config_load))

	// Preload some blank WY cards
	for(var/i in 1 to preload_punchcards)
		new /obj/item/paper/punch_card(src)

/// Called by COMSIG_GLOB_CONFIG_LOADED
/obj/structure/machinery/computer/almayer_encryption/proc/on_config_load()
	SIGNAL_HANDLER
	var/phrases = CONFIG_GET(str_list/announcement_challenges)
	cipher_length = length(phrases[1])

/obj/structure/machinery/computer/almayer_encryption/update_icon()
	icon_state = initial(icon_state)
	if(stat & NOPOWER)
		icon_state = initial(icon_state) + "_off"

/obj/structure/machinery/computer/almayer_encryption/set_broken()
	return

/obj/structure/machinery/computer/almayer_encryption/attackby(obj/item/thing, mob/living/user, list/mods)
	if(istype(thing, /obj/item/paper/punch_card))
		if(insert_punch_card(thing, user))
			return TRUE

	return ..()

/obj/structure/machinery/computer/almayer_encryption/attack_hand(mob/living/user)
	if(..())
		return TRUE

	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return TRUE

	tgui_interact(user)
	user.set_interaction(user)
	return TRUE

/obj/structure/machinery/computer/almayer_encryption/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ComsEncryption", capitalize_first_letters(name))
		ui.open()
		ui.send_update()
	return ui

/obj/structure/machinery/computer/almayer_encryption/ui_state(mob/user)
	return GLOB.powered_machinery_state

/obj/structure/machinery/computer/almayer_encryption/ui_static_data(mob/user)
	. = list()

	.["cipher_length"] = cipher_length
	.["mode"] = tgui_mode

/obj/structure/machinery/computer/almayer_encryption/ui_data(mob/user)
	. = list()

	.["cards"] = length(contents)

/obj/structure/machinery/computer/almayer_encryption/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("print")
			print(params["data"], ui.user)
			return TRUE

/// Attempts to print a punch card with the output of this computer after delay.
/obj/structure/machinery/computer/almayer_encryption/proc/print(list/data, mob/living/user)
	if(!islist(data))
		CRASH("Non-list print by [user]!")
	if(length(data) != cipher_length)
		CRASH("Invalid print by [user]!")

	if(length(contents) <= 0)
		to_chat(user, SPAN_WARNING("It looks like [src] is out of blank punch cards."))
		return

	if(!COOLDOWN_FINISHED(src, print_cooldown))
		to_chat(user, SPAN_WARNING("Slow down! You wouldn't want to break it."))
		return

	COOLDOWN_START(src, print_cooldown, 15 SECONDS)
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 15, vary=TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_print), data, user), 1 SECONDS)

/// Internal: Finalizes printing a punch card from print() with chances for a single failed punch.
/obj/structure/machinery/computer/almayer_encryption/proc/finish_print(list/data, mob/living/user)
	if(length(contents) <= 0)
		return

	var/obj/item/paper/punch_card/card = contents[1]

	// Mis-punch?
	for(var/i in 1 to length(data))
		if(prob(1))
			data[i] = 0 // It tried
			break

	card.punch_data(data, encoding=32)

	if(ishuman(user) && get_dist(user, src) < 2)
		user.put_in_hands(card)
	else
		card.forceMove(loc)

/// Called by attackby when using a punch_card.
/// Will try_restock_punch_card if card is unused, otherwise tgui_interact, consume the card, and input its data after delay.
/obj/structure/machinery/computer/almayer_encryption/proc/insert_punch_card(obj/item/paper/punch_card/card, mob/living/user)
	if(QDELETED(card))
		return TRUE
	if(user.action_busy)
		return TRUE

	if(!card.data)
		try_restock_punch_card(card, user)
		return TRUE

	if(!do_after(user, 1 SECONDS, show_busy_icon=BUSY_ICON_GENERIC, target=src))
		return TRUE

	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 15, vary=TRUE)
	var/datum/tgui/ui = tgui_interact(user)
	if(!do_after(user, 5 DECISECONDS, show_busy_icon=BUSY_ICON_GENERIC, target=src))
		return TRUE

	user.drop_inv_item_to_loc(card, loc)

	if(length(card.data) == cipher_length)
		ui.send_update(list(
			"punch_card" = card.data
		))
	else
		var/trimmed_data = list()
		var/card_data_length = length(card.data)
		for(var/i in 1 to cipher_length)
			var/current = card.data[i]
			if(i <= card_data_length)
				if(!islist(current))
					trimmed_data += current // Single number
				else if(length(current) == 1)
					trimmed_data += current[1] // List with single number
				else
					trimmed_data += 0 // Multiple punch on the same row
			else
				trimmed_data += 0 // No data present for this row
		ui.send_update(list(
			"punch_card" = trimmed_data
		))

	playsound(user, 'sound/machines/outputclick1.ogg', 25, vary=TRUE)
	return TRUE

/// Called by insert_punch_card for unused punch_cards to restock if possible.
/obj/structure/machinery/computer/almayer_encryption/proc/try_restock_punch_card(obj/item/paper/punch_card/card, mob/living/user)
	if(length(contents) >= 20)
		to_chat(user, SPAN_NOTICE("It looks like the card holder for [src] is already full."))
		return FALSE
	if(card.data)
		return FALSE

	for(var/i in 1 to 4) // Give 4 extra blank
		new card.base_type(src)
	user.drop_inv_item_to_loc(card, src)
	to_chat(user, SPAN_NOTICE("You load several punch cards for [src]."))
	return TRUE


// ----- Encoder Computer -----

/obj/structure/machinery/computer/almayer_encryption/encoder
	name = "encryption encoder computer"
	desc = "The IBM series 10 computer retrofitted to work as a encryption encoder computer for the ship. While somewhat dated it still serves its purpose."
	icon_state = "sensor_comp1"
	tgui_mode = "encoder"
	preload_punchcards = 0 // Nothing to print

/obj/structure/machinery/computer/almayer_encryption/encoder/ui_data(mob/user)
	. = list()

	.["cards"] = 0
	.["clarity"] = SSradio.faction_coms_clarity[faction]

/obj/structure/machinery/computer/almayer_encryption/encoder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("submit")
			submit_solution(params["solution"], params["offset"], ui.user)
			playsound(src, "keyboard_alt", 15, vary=TRUE)
			return TRUE

/// Called by ui_act when submitting a code to attempt to update comms clarity
/obj/structure/machinery/computer/almayer_encryption/encoder/proc/submit_solution(list/attempt, offset, mob/user)
	if(!islist(attempt))
		CRASH("Non-list attempt submitted by [user||usr]!")

	// Try to see if the solution matches
	var/datum/encryption_sequence/solved = null
	for(var/datum/encryption_sequence/sequence as anything in SSradio.faction_coms_codes[faction])
		if(sequence.offset + offset != MAX_OFFSET + 1)
			continue
		solved = sequence
		for(var/i in 1 to length(sequence.solution))
			if(attempt[i] != sequence.solution[i])
				solved = null
				break
		if(solved)
			break

	var/decay_rate = CONFIG_GET(number/announcement_clarity_decay)
	var/solve_grace_time = CONFIG_GET(number/announcement_challenge_grace)
	var/clarity_min = CONFIG_GET(number/announcement_min_clarity)
	var/clarity_max = CONFIG_GET(number/announcement_max_clarity)

	if(solved)
		var/next_fire = world.time - SSradio.next_fire
		var/solve_time = max(world.time - (solved.time + solve_grace_time + next_fire), 0)
		var/new_clarity = 100 - ceil(solve_time / SSradio.wait) * decay_rate
		msg_admin_niche("Comms encryption success by [user] [SSradio.faction_coms_clarity[faction]] -> [new_clarity]")
		SSradio.faction_coms_clarity[faction] = clamp(new_clarity, clarity_min, clarity_max)
		return TRUE

	msg_admin_niche("Comms encryption failure by [user] [SSradio.faction_coms_clarity[faction]] -> [clarity_min]")
	SSradio.faction_coms_clarity[faction] = clarity_min
	return FALSE

/obj/structure/machinery/computer/almayer_encryption/encoder/try_restock_punch_card(obj/item/paper/punch_card/card, mob/living/user)
	return FALSE // Nothing to print


// ----- Decoder Computer -----

/obj/structure/machinery/computer/almayer_encryption/decoder
	name = "encryption decoder computer"
	desc = "The IBM series 10 computer retrofitted to work as an encryption decoder computer for the ship. While somewhat dated it still serves its purpose."
	icon_state = "sensor_comp3"
	tgui_mode = "decoder"

/obj/structure/machinery/computer/almayer_encryption/decoder/ui_data(mob/user)
	. = list()

	.["cards"] = length(contents)
	var/challenge_count = length(SSradio.faction_coms_codes[faction])
	if(!challenge_count)
		// No challenges, just plug in zeros
		var/blank = list()
		for(var/i in 1 to cipher_length)
			blank += 0
		.["challenge"] = blank
	else
		// Get the latest challenge
		var/datum/encryption_sequence/sequence = SSradio.faction_coms_codes[faction][challenge_count]
		.["challenge"] = sequence.challenge

/obj/structure/machinery/computer/almayer_encryption/decoder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("generate")
			generate_challenge()
			playsound(src, "keyboard_alt", 15, vary=TRUE)
			return TRUE

/obj/structure/machinery/computer/almayer_encryption/decoder/insert_punch_card(obj/item/paper/punch_card/card, mob/living/user)
	if(QDELETED(card))
		return TRUE
	if(user.action_busy)
		return TRUE

	if(!card.data)
		try_restock_punch_card(card, user)
		return TRUE

	return FALSE

/// Creates a new challenge in SSradio.faction_coms_codes[faction] if there wasn't one made already recently.
/obj/structure/machinery/computer/almayer_encryption/decoder/proc/generate_challenge()
	var/challenge_count = length(SSradio.faction_coms_codes[faction])
	if(challenge_count)
		// Spam protection
		var/solve_grace_time = CONFIG_GET(number/announcement_challenge_grace)
		var/datum/encryption_sequence/last = SSradio.faction_coms_codes[faction][challenge_count]
		if(world.time - (last.time + solve_grace_time * 0.5) <= 0)
			return

	var/datum/encryption_sequence/new_sequence = new
	SSradio.faction_coms_codes[faction] += new_sequence


// ----- Encryption Challenges -----

/datum/encryption_sequence
	/// When the challenge was created
	var/time = 0
	/// The random offset for this challenge
	var/offset = 0
	/// The zero-indexed phrase challenge number (offset)
	var/list/challenge = list()
	/// The zero-indexed correct phrase number
	var/list/solution = list()

/datum/encryption_sequence/New()
	. = ..()
	time = world.time
	offset = rand(1, MAX_OFFSET)

	var/phrases = CONFIG_GET(str_list/announcement_challenges)
	var/length = length(phrases[1])
	var/phrase = pick(phrases)
	for(var/i in 1 to length)
		var/phrase_ascii = text2ascii(phrase[i])
		if(phrase_ascii < 65 || phrase_ascii > 91) // Symbol detection (or already on the snowflake ASCII)
			phrase_ascii = 91 // [ the snowflake for displaying -
		var/zero_indexed_char = phrase_ascii - 65
		solution += zero_indexed_char
		challenge += (zero_indexed_char + offset) % (MAX_OFFSET + 1) // Wrap the offset value

#undef MAX_OFFSET
