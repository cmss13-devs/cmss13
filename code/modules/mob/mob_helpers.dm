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

//The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
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
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armor provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
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
)

// This is much faster than a string comparison
var/global/list/limb_types_by_name = list(
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
)

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
			organ_rel_size["head"]; "head",
			organ_rel_size["chest"]; "chest",
			organ_rel_size["groin"]; "groin",
			organ_rel_size["l_arm"]; "l_arm",
			organ_rel_size["r_arm"]; "r_arm",
			organ_rel_size["l_leg"]; "l_leg",
			organ_rel_size["r_leg"]; "r_leg",
			organ_rel_size["l_hand"]; "l_hand",
			organ_rel_size["r_hand"]; "r_hand",
			organ_rel_size["l_foot"]; "l_foot",
			organ_rel_size["r_foot"]; "r_foot",
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

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o") newletter="u"
			if(lowertext(newletter)=="s") newletter="ch"
			if(lowertext(newletter)=="a") newletter="ah"
			if(lowertext(newletter)=="c") newletter="k"
		switch(rand(1,7))
			if(1,3,5) newletter="[lowertext(newletter)]"
			if(2,4,6) newletter="[uppertext(newletter)]"
			if(7) newletter+="'"
			//if(9,10) newletter="<b>[newletter]</b>"
			//if(11,12) newletter="<big>[newletter]</big>"
			//if(13) newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(phrase, strength = 1)
	if(strength < 1)
		return phrase
	else
		strength = Ceiling(strength/5)

	var/list/split_phrase = text2list(phrase," ") //Split it up into words.
	var/list/unstuttered_words = split_phrase.Copy()

	var/max_stutter = min(strength, split_phrase.len)
	var/stutters = rand(max(max_stutter - 3, 1), max_stutter)

	for(var/i = 0, i < stutters, i++)
		if (!unstuttered_words.len)
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

		if(prob(3 * strength) && index != unstuttered_words.len - 1) // stammer / pause - don't pause at the end of sentences!
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

#define PIXELS_PER_STRENGTH_VAL 24

/proc/shake_camera(mob/M, steps = 1, strength = 1, time_per_step = 1)
	if(!M?.client || (M.shakecamera > world.time))
		return

	M.shakecamera = world.time + steps * time_per_step
	strength = abs(strength)*PIXELS_PER_STRENGTH_VAL
	var/old_X = M.client.pixel_x
	var/old_y = M.client.pixel_y

	animate(M.client, pixel_x = old_X + rand(-(strength), strength), pixel_y = old_y + rand(-(strength), strength), easing = JUMP_EASING, time = time_per_step, flags = ANIMATION_PARALLEL)
	var/i = 1
	while(i < steps)
		animate(pixel_x = old_X + rand(-(strength), strength), pixel_y = old_y + rand(-(strength), strength), easing = JUMP_EASING, time = time_per_step)
		i++
	animate(pixel_x = old_X, pixel_y = old_y,time = Clamp(Floor(strength/PIXELS_PER_STRENGTH_VAL),2,4))//ease it back

#undef PIXELS_PER_STRENGTH_VAL

/proc/findname(msg)
	for(var/mob/M in GLOB.mob_list)
		if (M.real_name == text("[msg]"))
			return TRUE
	return FALSE


/mob/proc/abiotic(full_body = 0)
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

/mob/proc/is_mob_restrained()
	return

/mob/proc/is_mob_incapacitated(ignore_restrained)
	return (stat || stunned || knocked_down || knocked_out || (!ignore_restrained && is_mob_restrained()) || status_flags & FAKEDEATH)


//returns how many non-destroyed legs the mob has (currently only useful for humans)
/mob/proc/has_legs()
	return 2

/mob/proc/get_eye_protection()
	return EYE_PROTECTION_NONE

/mob/proc/a_select_zone(input, client/user)
	var/atom/movable/screen/zone_sel/zone

	for(var/A in user.screen)
		if(istype(A, /atom/movable/screen/zone_sel))
			zone = A

	if(!zone)
		return

	switch(input)
		if("head")
			switch(usr.zone_selected)
				if("head")
					zone.selecting = "eyes"
				if("eyes")
					zone.selecting = "mouth"
				if("mouth")
					zone.selecting = "head"
				else
					zone.selecting = "head"
		if("chest")
			zone.selecting = "chest"
		if("groin")
			zone.selecting = "groin"
		if("rarm")
			switch(usr.zone_selected)
				if("r_arm")
					zone.selecting = "r_hand"
				if("r_hand")
					zone.selecting = "r_arm"
				else
					zone.selecting = "r_arm"
		if("larm")
			switch(usr.zone_selected)
				if("l_arm")
					zone.selecting = "l_hand"
				if("l_hand")
					zone.selecting = "l_arm"
				else
					zone.selecting = "l_arm"
		if("rleg")
			switch(usr.zone_selected)
				if("r_leg")
					zone.selecting = "r_foot"
				if("r_foot")
					zone.selecting = "r_leg"
				else
					zone.selecting = "r_leg"
		if("lleg")
			switch(usr.zone_selected)
				if("l_leg")
					zone.selecting = "l_foot"
				if("l_foot")
					zone.selecting = "l_leg"
				else
					zone.selecting = "l_leg"
		if("next")
			zone.selecting = next_in_list(usr.zone_selected, DEFENSE_ZONES_LIVING)
		if("prev")
			zone.selecting = prev_in_list(usr.zone_selected, DEFENSE_ZONES_LIVING)
	zone.update_icon(usr)

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
				return DURATION_MULTIPLIER_TIER_2
			else if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				return DURATION_MULTIPLIER_TIER_1
// Construction
		if(SKILL_CONSTRUCTION)
			if(skillcheck(src, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_MASTER))
				return DURATION_MULTIPLIER_TIER_3
// Medical
		if(SKILL_MEDICAL)
			if(skillcheck(src, SKILL_MEDICAL, SKILL_MEDICAL_MASTER))
				return DURATION_MULTIPLIER_TIER_3
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
	return stat == DEAD || issynth(src) ||HAS_TRAIT(src, TRAIT_REAGENT_SCANNER) //Dead guys and synths can always see reagents

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/examinify as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	examinify.examine(src)

/mob/verb/pickup_item(obj/item/pickupify in oview(1, usr))
	set name = "Pick Up"
	set category = "Object"

	if(!canmove || stat || is_mob_restrained() || !Adjacent(pickupify))
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
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/human(loc, splatter_dir)

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
		ghost.notify_ghost(message, ghost_sound, enter_link, enter_text, source, alert_overlay, action, flashwindow, ignore_mapload, ignore_key, header, notify_volume, extra_large)

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

	screen_alert.overlays += alert_overlay

/mob/proc/reset_lighting_alpha()
	SIGNAL_HANDLER

	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	sync_lighting_plane_alpha()

