/mob/proc/can_use_hands()
	return

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	if(job == "Cyborg" || job == "AI")
		return TRUE
	return isSilicon(src) || get_species() == "Machine"

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/get_gender()
	return gender

/proc/is_blind(A)
	if(isliving(A))
		var/mob/living/M = A
		return M.eye_blind
	return FALSE


/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

/// The base miss chance for the different defence zones
GLOBAL_LIST_INIT(base_miss_chance, list(
	"head" = 10,
	"chest" = 0,
	"groin" = 5,
	"l_leg" = 10,
	"r_leg" = 10,
	"l_arm" = 10,
	"r_arm" = 10,
	"l_hand" = 15,
	"r_hand" = 15,
	"l_foot" = 40,
	"r_foot" = 40,
	"eyes" = 20,
	"mouth" = 15,
))

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armor provides for covering that body part when calculating protection from full-body effects.
GLOBAL_LIST_INIT(organ_rel_size, list(
	"head" = 15,
	"chest" = 70,
	"groin" = 30,
	"l_leg" = 25,
	"r_leg" = 25,
	"l_arm" = 25,
	"r_arm" = 25,
	"l_hand" = 7,
	"r_hand" = 7,
	"l_foot" = 10,
	"r_foot" = 10,
	"eyes" = 5,
	"mouth" = 15,
))

// This is much faster than a string comparison
GLOBAL_LIST_INIT(limb_types_by_name, list(
	"head" = /obj/limb/head,
	"chest" = /obj/limb/chest,
	"groin" = /obj/limb/groin,
	"l_leg" = /obj/limb/leg/l_leg,
	"r_leg" = /obj/limb/leg/r_leg,
	"l_arm" = /obj/limb/arm/l_arm,
	"r_arm" = /obj/limb/arm/r_arm,
	"l_hand" = /obj/limb/hand/l_hand,
	"r_hand" = /obj/limb/hand/r_hand,
	"l_foot" = /obj/limb/foot/l_foot,
	"r_foot" = /obj/limb/foot/r_foot,
))

/proc/check_zone(zone)
	if(!zone)
		return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
/proc/rand_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/rand_zone = zone
	while (rand_zone == zone)
		rand_zone = pick (
			GLOB.organ_rel_size["head"]; "head",
			GLOB.organ_rel_size["chest"]; "chest",
			GLOB.organ_rel_size["groin"]; "groin",
			GLOB.organ_rel_size["l_arm"]; "l_arm",
			GLOB.organ_rel_size["r_arm"]; "r_arm",
			GLOB.organ_rel_size["l_leg"]; "l_leg",
			GLOB.organ_rel_size["r_leg"]; "r_leg",
			GLOB.organ_rel_size["l_hand"]; "l_hand",
			GLOB.organ_rel_size["r_hand"]; "r_hand",
			GLOB.organ_rel_size["l_foot"]; "l_foot",
			GLOB.organ_rel_size["r_foot"]; "r_foot",
		)

	return rand_zone

/proc/stars(message, clear_char_probability = 25)
	clear_char_probability = max(clear_char_probability, 0)
	if(clear_char_probability >= 100)
		return message

	var/output_message = ""
	var/message_length = length(message)
	var/index = 1
	while(index <= message_length)
		var/char = copytext(message, index, index + 1)
		if(char == " " || prob(clear_char_probability))
			output_message += char
		else
			output_message += "*"
		index++
	return output_message

/**
 * Summary: proc that parses an html input string and scrambles the non-html string contents.
 *
 * Arguments:
 * * message - an html string value to be parsed and modified.
 *
 * Return:
 * returns the parsed and modified html output with the text content being partially scrambled with asteriks
 */
/proc/stars_decode_html(message)
	if(!length(message))
		return

	// boolean value to know if the current indexed element needs to be scrambled.
	var/parsing_message = FALSE

	// boolean values to know if we are currently inside a double or single quotation.
	var/in_single_quote = FALSE
	var/in_double_quote = FALSE

	// string of what tag we're currently in
	var/current_tag = ""
	var/escaped_tag = FALSE

	// string that will be scrambled
	var/current_string_to_scramble = ""

	// output string after parse
	var/output_message = ""
	for(var/character_index in 1 to length(message))
		var/current_char = message[character_index]

		// Apparent edge case safety, we only want to check the < and > on the edges of the tag.
		if(!parsing_message)
			if(current_char == "'")
				in_single_quote = !in_single_quote
			if(current_char == "\"")
				in_double_quote = !in_double_quote
			if(in_single_quote || in_double_quote)
				output_message += current_char
				continue

		if(current_char == ">")
			parsing_message = TRUE
			output_message += current_char
			current_tag += current_char
			if(findtext(current_tag, "<style>") == 1 || findtext(current_tag, "<style ") == 1) // findtext because HTML doesn't care about anything after whitespace
				escaped_tag = TRUE
			else if(escaped_tag && (findtext(current_tag, "</style>") == 1 || findtext(current_tag, "</style ") == 1)) // 1 for findtext because we only care about the start of the string matching
				escaped_tag = FALSE
			continue
		if(current_char == "<")
			parsing_message = FALSE
			current_tag = ""
			if(length(current_string_to_scramble))
				var/scrambled_string = stars(current_string_to_scramble)
				output_message += scrambled_string
				current_string_to_scramble = ""

		if(parsing_message && !escaped_tag)
			current_string_to_scramble += current_char
		else
			output_message += current_char
			current_tag += current_char
	return output_message

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")
				newletter="u"
			if(lowertext(newletter)=="s")
				newletter="ch"
			if(lowertext(newletter)=="a")
				newletter="ah"
			if(lowertext(newletter)=="c")
				newletter="k"
		switch(rand(1,7))
			if(1,3,5)
				newletter="[lowertext(newletter)]"
			if(2,4,6)
				newletter="[uppertext(newletter)]"
			if(7)
				newletter+="'"
			//if(9,10) newletter="<b>[newletter]</b>"
			//if(11,12) newletter="<big>[newletter]</big>"
			//if(13) newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(phrase, strength = 1)
	if(strength < 1)
		return phrase
	else
		strength = ceil(strength/5)

	var/list/split_phrase = text2list(phrase," ") //Split it up into words.
	var/list/unstuttered_words = split_phrase.Copy()

	var/max_stutter = min(strength, length(split_phrase))
	var/stutters = rand(max(max_stutter - 3, 1), max_stutter)

	for(var/i = 0, i < stutters, i++)
		if (!length(unstuttered_words))
			break

		var/word = pick(unstuttered_words)
		unstuttered_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.
		var/regex/R = regex("^(\\W*)((?:\[Tt\]|\[Cc\]|\[Ss\])\[Hh\]|\\w)(\\w*)(\\W*)$")
		var/regex/upper = regex("\[A-Z\]")

		if(!R.Find(word))
			continue

		if (length(word) > 1)
			if((prob(20) && strength > 1) || (prob(30) && strength > 4)) // stutter word instead
				var/stuttered = R.group[2] + R.group[3]
				if(upper.Find(stuttered) && !upper.Find(stuttered, 2)) // if they're screaming (all caps) or saying something like 'AI', keep the letter capitalized - else don't
					stuttered = lowertext(stuttered)
				word = R.Replace(word, "$1$2$3-[stuttered]$4")
			else if(prob(25) && strength > 1) // prolong word
				var/prolonged = ""
				var/prolong_amt = min(length(word), 5)
				prolong_amt = rand(1, prolong_amt)
				for(var/j = 0, j < prolong_amt, j++)
					prolonged += R.group[2]
				if(!upper.Find(R.group[3]))
					prolonged = lowertext(prolonged)
				word = R.Replace(word, "$1$2[prolonged]$3$4")
			else
				if(prob(5 * strength)) // harder stutter if stronger
					word = R.Replace(word, "$1$2-$2-$2-$2$3$4")
				else if(prob(10 * strength))
					word = R.Replace(word, "$1$2-$2-$2$3$4")
				else // normal stutter
					word = R.Replace(word, "$1$2-$2$3$4")

		if(prob(3 * strength) && index != length(unstuttered_words) - 1) // stammer / pause - don't pause at the end of sentences!
			word = R.Replace(word, "$0 ...")

		split_phrase[index] = word

	return jointext(split_phrase, " ")

/proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext

/**
 * Replaces S and similar sounds with 'th' and such. Stolen from tg.
 */
/proc/lisp_replace(message)
	var/static/regex/replace_s = new("s+h?h?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_S = new("S+H?H?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_z = new("z+h?h?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_Z = new("Z+H?H?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_x = new("x+h?h?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_X = new("X+H?H?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_ceci = new("ceh?|cih?", REGEX_FLAG_GLOBAL)
	var/static/regex/replace_CECI = new("CEH?|CIH?", REGEX_FLAG_GLOBAL)
	if(message[1] != "*")
		message = replace_s.Replace(message, "th")
		message = replace_S.Replace(message, "TH")
		message = replace_z.Replace(message, "th")
		message = replace_Z.Replace(message, "TH")
		message = replace_ceci.Replace(message, "th")
		message = replace_CECI.Replace(message, "TH")
		message = replace_x.Replace(message, "ckth")
		message = replace_X.Replace(message, "CKTH")
	return message

#define PIXELS_PER_STRENGTH_VAL 28

/proc/shake_camera(mob/M, steps = 1, strength = 1, time_per_step = 1)
	if(!M?.client || (M.shakecamera > world.time))
		return

	M.shakecamera = world.time + steps * time_per_step
	strength = abs(strength)*PIXELS_PER_STRENGTH_VAL
	var/old_X = M.client.pixel_x
	var/old_y = M.client.pixel_y

	animate(M.client, pixel_x = old_X + rand(-(strength), strength), pixel_y = old_y + rand(-(strength), strength), easing = CUBIC_EASING | EASE_IN, time = time_per_step, flags = ANIMATION_PARALLEL)
	var/i = 1
	while(i < steps)
		animate(pixel_x = old_X + rand(-(strength), strength), pixel_y = old_y + rand(-(strength), strength), easing = CUBIC_EASING | EASE_IN, time = time_per_step)
		i++
	animate(pixel_x = old_X, pixel_y = old_y,time = clamp(floor(strength/PIXELS_PER_STRENGTH_VAL),2,4))//ease it back

#undef PIXELS_PER_STRENGTH_VAL

/proc/findname(msg)
	for(var/mob/M in GLOB.mob_list)
		if (M.real_name == text("[msg]"))
			return TRUE
	return FALSE


/mob/proc/abiotic(full_body = FALSE)
	if(full_body && ((src.l_hand && !( src.l_hand.flags_item & ITEM_ABSTRACT )) || (src.r_hand && !( src.r_hand.flags_item & ITEM_ABSTRACT )) || (src.back || src.wear_mask)))
		return TRUE

	if((src.l_hand && !( src.l_hand.flags_item & ITEM_ABSTRACT )) || (src.r_hand && !( src.r_hand.flags_item & ITEM_ABSTRACT )))
		return TRUE

	return FALSE

/proc/intent_text(intent)
	switch(intent)
		if(INTENT_HELP)
			return "help"
		if(INTENT_DISARM)
			return "disarm"
		if(INTENT_GRAB)
			return "grab"
		if(INTENT_HARM)
			return "hurt"

/mob/verb/a_intent_change(intent as num)
	set name = "a-intent"
	set hidden = TRUE

	if(intent)
		a_intent = intent
	else
		a_intent = a_intent < 8 ? a_intent << 1 : 1

	if(hud_used && hud_used.action_intent)
		hud_used.action_intent.icon_state = "intent_[intent_text(a_intent)]"

	SEND_SIGNAL(src, COMSIG_MOB_INTENT_CHANGE, a_intent)

/mob/proc/is_mob_restrained()
	return

/// Returns if the mob is incapacitated and unable to perform general actions
/mob/proc/is_mob_incapacitated(ignore_restrained)
	return (stat || (!ignore_restrained && is_mob_restrained()) || (status_flags & FAKEDEATH) || HAS_TRAIT(src, TRAIT_INCAPACITATED))

/mob/proc/get_eye_protection()
	return EYE_PROTECTION_NONE

/// Change the mob's selected body zone to `target_zone`.
/mob/proc/select_body_zone(target_zone)
	if(!target_zone || !hud_used?.zone_sel)
		return

	// Update the mob's selected zone.
	zone_selected = target_zone
	// Update the HUD's selected zone.
	hud_used.zone_sel.selecting = target_zone
	hud_used.zone_sel.update_icon()

#define DURATION_MULTIPLIER_TIER_1 0.75
#define DURATION_MULTIPLIER_TIER_2 0.5
#define DURATION_MULTIPLIER_TIER_3 0.25
#define DURATION_MULTIPLIER_TIER_4 0.10
/mob/proc/get_skill_duration_multiplier(skill)
	//Gets a multiplier for various tasks, based on the skill
	. = 1
	if(!skills)
		return
	switch(skill)
// CQC
		if(SKILL_CQC)
			if(skillcheck(src, SKILL_CQC, SKILL_CQC_MASTER))
				return DURATION_MULTIPLIER_TIER_3
			else if(skillcheck(src, SKILL_CQC, SKILL_CQC_SKILLED))
				return DURATION_MULTIPLIER_TIER_2
			else if(skillcheck(src, SKILL_CQC, SKILL_CQC_TRAINED))
				return DURATION_MULTIPLIER_TIER_1
// Engineer
		if(SKILL_ENGINEER)
			if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
				return DURATION_MULTIPLIER_TIER_3
			else if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				return (DURATION_MULTIPLIER_TIER_3 + DURATION_MULTIPLIER_TIER_2) / 2
			else if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				return DURATION_MULTIPLIER_TIER_2
			else if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
				return DURATION_MULTIPLIER_TIER_1
// Construction
		if(SKILL_CONSTRUCTION)
			if(skillcheck(src, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_MASTER))
				return DURATION_MULTIPLIER_TIER_3
// Medical
		if(SKILL_MEDICAL)
			if(skillcheck(src, SKILL_MEDICAL, SKILL_MEDICAL_MASTER))
				return 0.35
			if(skillcheck(src, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR))
				return DURATION_MULTIPLIER_TIER_1
// Surgeon
		if(SKILL_SURGERY)
			if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_EXPERT))
				return 0.6
			if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_TRAINED))
				return 1
			else if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
				return 1.2
// Intel
		if(SKILL_INTEL)
			if(skillcheck(src, SKILL_INTEL, SKILL_INTEL_EXPERT))
				return DURATION_MULTIPLIER_TIER_2
			if(skillcheck(src, SKILL_INTEL, SKILL_INTEL_TRAINED))
				return DURATION_MULTIPLIER_TIER_1
// Domestic
		if(SKILL_DOMESTIC)
			if(skillcheck(src, SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER))
				return 0.5
			if(skillcheck(src, SKILL_DOMESTIC, SKILL_DOMESTIC_TRAINED))
				return 1
			else
				return 2
// Fireman
		if(SKILL_FIREMAN)
			if(skillcheck(src, SKILL_FIREMAN, SKILL_FIREMAN_MAX))
				return DURATION_MULTIPLIER_TIER_4
			if(skillcheck(src, SKILL_FIREMAN, SKILL_FIREMAN_MASTER))
				return DURATION_MULTIPLIER_TIER_3
			if(skillcheck(src, SKILL_FIREMAN, SKILL_FIREMAN_EXPERT))
				return DURATION_MULTIPLIER_TIER_2
			if(skillcheck(src, SKILL_FIREMAN, SKILL_FIREMAN_SKILLED))
				return DURATION_MULTIPLIER_TIER_1



/mob/proc/check_view_change(new_size, atom/source)
	return new_size

/mob/proc/can_be_pulled_by(mob/M)
	return TRUE

/mob/proc/can_see_reagents()
	return stat == DEAD || issynth(src) || HAS_TRAIT(src, TRAIT_REAGENT_SCANNER) //Dead guys and synths can always see reagents

/// Returns TRUE if this mob is an ally of another, depending on the `faction` and `faction_group` variables, FALSE otherwise
/mob/proc/is_ally_of(mob/potential_ally)
	. = FALSE

	if(faction == potential_ally.faction)
		return TRUE

	if(faction in potential_ally.faction_group)
		return TRUE

	if(potential_ally.faction in faction_group)
		return TRUE

	if(length(faction_group & potential_ally.faction_group))
		return TRUE

	return FALSE

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/examinify as mob|obj|turf in view(28, usr))
	set name = "Examine"
	set category = "IC"

	examinify.examine(src)

/mob/verb/pickup_item(obj/item/pickupify in oview(1, usr))
	set name = "Pick Up"
	set category = "Object"

	if(is_mob_incapacitated() || !Adjacent(pickupify))
		return

	if(world.time <= next_move)
		return

	if(!hand && r_hand)
		to_chat(usr, SPAN_DANGER("Your right hand is full."))
		return
	if(hand && l_hand)
		to_chat(usr, SPAN_DANGER("Your left hand is full."))
		return

	if(pickupify.anchored)
		to_chat(usr, SPAN_DANGER("You can't pick that up!"))
		return
	if(!isturf(pickupify.loc))
		to_chat(usr, SPAN_DANGER("You can't pick that up!"))
		return

	next_move += 6 // stop insane pickup speed
	UnarmedAttack(pickupify)

/mob/verb/pull_item(atom/movable/pullify in view(1, usr))
	set name = "Pull"
	set category = "Object"

	if(Adjacent(pullify))
		start_pulling(pullify)

/mob/proc/handle_blood_splatter(splatter_dir)
	new /obj/effect/bloodsplatter/human(loc, splatter_dir)

/proc/get_mobs_in_z_level_range(turf/starting_turf, range)
	var/list/mobs_in_range = list()
	var/z_level = starting_turf.z
	for(var/mob/mob as anything in GLOB.mob_list)
		if(mob.z != z_level)
			continue
		if(range && get_dist(starting_turf, mob) > range)
			continue
		mobs_in_range += mob
	return mobs_in_range

/mob/proc/alter_ghost(mob/dead/observer/ghost)
	return

/mob/proc/get_paygrade()
	return


/proc/notify_ghosts(message, ghost_sound = null, enter_link = null, enter_text = null, atom/source = null, mutable_appearance/alert_overlay = null, action = NOTIFY_JUMP, flashwindow = FALSE, ignore_mapload = TRUE, ignore_key, header = null, notify_volume = 100, extra_large = FALSE) //Easy notification of ghosts.
	if(ignore_mapload && SSatoms.initialized != INITIALIZATION_INNEW_REGULAR)	//don't notify for objects created during a map load
		return
	for(var/mob/dead/observer/ghost as anything in GLOB.observer_list)
		if(!ghost.client)
			continue
		var/specific_ghost_sound = ghost_sound
		if(!(ghost.client?.prefs?.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS))
			specific_ghost_sound = null
		ghost.notify_ghost(message, specific_ghost_sound, enter_link, enter_text, source, alert_overlay, action, flashwindow, ignore_mapload, ignore_key, header, notify_volume, extra_large)

/mob/dead/observer/proc/notify_ghost(message, ghost_sound, enter_link, enter_text, atom/source, mutable_appearance/alert_overlay, action = NOTIFY_JUMP, flashwindow = FALSE, ignore_mapload = TRUE, ignore_key, header, notify_volume = 100, extra_large = FALSE) //Easy notification of a single ghosts.
	if(ignore_mapload && SSatoms.initialized != INITIALIZATION_INNEW_REGULAR)	//don't notify for objects created during a map load
		return
	if(!client)
		return
	var/track_link
	if (source && action == NOTIFY_ORBIT)
		track_link = " <a href='byond://?src=[REF(src)];track=[REF(source)]'>(Follow)</a>"
	if (source && action == NOTIFY_JUMP)
		var/turf/T = get_turf(source)
		track_link = " <a href='byond://?src=[REF(src)];jumptocoord=1;X=[T.x];Y=[T.y];Z=[T.z]'>(Jump)</a>"
	var/full_enter_link
	if (enter_link)
		full_enter_link = "<a href='byond://?src=[REF(src)];[enter_link]'>[(enter_text) ? "[enter_text]" : "(Claim)"]</a>"
	to_chat(src, "[(extra_large) ? "<br><hr>" : ""][SPAN_DEADSAY("[message][(enter_link) ? " [full_enter_link]" : ""][track_link]")][(extra_large) ? "<hr><br>" : ""]")
	if(ghost_sound)
		SEND_SOUND(src, sound(ghost_sound, volume = notify_volume, channel = SOUND_CHANNEL_NOTIFY))
	if(flashwindow)
		window_flash(client)

	if(!source)
		return

	var/atom/movable/screen/alert/notify_action/screen_alert = throw_alert("[REF(source)]_notify_action", /atom/movable/screen/alert/notify_action)
	if(!screen_alert)
		return
	if (header)
		screen_alert.name = header
	screen_alert.desc = message
	screen_alert.action = action
	screen_alert.target = source
	if(!alert_overlay)
		alert_overlay = new(source)
		var/icon/source_icon = icon(source.icon)
		var/iheight = source_icon.Height()
		var/iwidth = source_icon.Width()
		var/higher_power = (iheight > iwidth) ? iheight : iwidth
		alert_overlay.pixel_y = initial(source.pixel_y)
		alert_overlay.pixel_x = initial(source.pixel_x)
		if(higher_power > 32)
			var/diff = 32 / higher_power
			alert_overlay.transform = alert_overlay.transform.Scale(diff, diff)
			if(higher_power > 48)
				alert_overlay.pixel_y = -(iheight * 0.5) * diff
				alert_overlay.pixel_x = -(iwidth * 0.5) * diff


	alert_overlay.layer = FLOAT_LAYER
	alert_overlay.plane = FLOAT_PLANE
	alert_overlay.underlays.Cut()
	screen_alert.overlays += alert_overlay

/mob/proc/reset_lighting_alpha()
	SIGNAL_HANDLER

	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	sync_lighting_plane_alpha()

/mob/proc/get_ability_mouse_key()
	if(!client)
		return XENO_ABILITY_CLICK_MIDDLE

	return client.prefs.xeno_ability_click_mode

/proc/xeno_ability_mouse_pref_to_string(preference_value)
	switch(preference_value)
		if(XENO_ABILITY_CLICK_MIDDLE)
			return "middle click"
		if(XENO_ABILITY_CLICK_RIGHT)
			return "right click"
		if(XENO_ABILITY_CLICK_SHIFT)
			return "shift click"
	return "middle click"

/mob/proc/get_ability_mouse_name()
	var/ability = get_ability_mouse_key()

	return xeno_ability_mouse_pref_to_string(ability)
