#define isdeaf(A) (ismob(A) && ((A?:sdisabilities & DISABILITY_DEAF) || A?:ear_deaf))
#define xeno_hivenumber(A) (isXeno(A) ? A?:hivenumber : FALSE)

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
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
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

/proc/stars(n, pr)
	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return t

proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,7))
			if(1,3,5)	newletter="[lowertext(newletter)]"
			if(2,4,6)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (ckey(n_letter) in alphabet_lowercase))
			if (prob(10))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		t = text("[t][n_letter]")//since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the next letter will be.
	return strip_html(t)


proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
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


/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return strip_html(t)

#define PIXELS_PER_STRENGTH_VAL 24

/proc/shake_camera(var/mob/M, var/steps = 1, var/strength = 1, var/time_per_step = 1)
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


/mob/proc/abiotic(var/full_body = 0)
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
	set hidden = 1

	if(intent)
		a_intent = intent
	else
		a_intent = a_intent < 8 ? a_intent << 1 : 1

	if(hud_used && hud_used.action_intent)
		hud_used.action_intent.icon_state = "intent_[intent_text(a_intent)]"

/mob/proc/is_mob_restrained()
	return

/mob/proc/is_mob_incapacitated(ignore_restrained)
	return (stat || stunned || knocked_down || knocked_out || (!ignore_restrained && is_mob_restrained()))


//returns how many non-destroyed legs the mob has (currently only useful for humans)
/mob/proc/has_legs()
	return 2

/mob/proc/get_eye_protection()
	return FALSE

/mob/verb/a_select_zone(input as text)
	set name = "a-select-zone"
	set hidden = 1

	var/atom/movable/screen/zone_sel/zone

	for(var/A in usr.client.screen)
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

/mob/proc/clear_chat_spam_mute(var/warn_level = 1, var/message = FALSE, var/increase_warn = FALSE)
	if(talked > warn_level)
		return
	talked = 0
	if(message)
		to_chat(src, SPAN_NOTICE("You may now speak again."))
	if(increase_warn)
		chatWarn++

#define DURATION_MULTIPLIER_TIER_1 0.75
#define DURATION_MULTIPLIER_TIER_2 0.5
#define DURATION_MULTIPLIER_TIER_3 0.25
/mob/proc/get_skill_duration_multiplier(var/skill)
	//Gets a multiplier for various tasks, based on the skill
	. = 1.0
	if(!skills)
		return
	switch(skill)
		if(SKILL_CQC)
			if(skillcheck(src, SKILL_CQC, SKILL_CQC_MASTER))
				return DURATION_MULTIPLIER_TIER_3
			else if(skillcheck(src, SKILL_CQC, SKILL_CQC_SKILLED))
				return DURATION_MULTIPLIER_TIER_2
			else if(skillcheck(src, SKILL_CQC, SKILL_CQC_TRAINED))
				return DURATION_MULTIPLIER_TIER_1
		//if(SKILL_MELEE_WEAPONS)
		//if(SKILL_FIREARMS)
		//if(SKILL_SPEC_WEAPONS)
		//if(SKILL_ENDURANCE)
		if(SKILL_ENGINEER)
			if(skillcheck(src, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
				return DURATION_MULTIPLIER_TIER_3
		if(SKILL_CONSTRUCTION)
			if(skillcheck(src, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_MASTER))
				return DURATION_MULTIPLIER_TIER_3
		//if(SKILL_LEADERSHIP)
		if(SKILL_MEDICAL)
			if(skillcheck(src, SKILL_MEDICAL, SKILL_MEDICAL_MASTER))
				return DURATION_MULTIPLIER_TIER_3
			else if(skillcheck(src, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR))
				return DURATION_MULTIPLIER_TIER_1

		if(SKILL_SURGERY) //Surgeons are the baseline.
			if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_EXPERT))
				return 0.6 //Synths are 40% faster. In the same conditions they work almost twice as quickly, and can perform surgeries in rough conditions or with improvised tools at full speed.
			if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_TRAINED))
				return 1
			else if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
				return 1.2 //Medic/nurse.

		if(SKILL_INTEL)
			if(skillcheck(src, SKILL_INTEL, SKILL_INTEL_EXPERT))
				return DURATION_MULTIPLIER_TIER_2
			if(skillcheck(src, SKILL_INTEL, SKILL_INTEL_TRAINED))
				return DURATION_MULTIPLIER_TIER_1
		//if(SKILL_RESEARCH)
		//if(SKILL_PILOT)
		//if(SKILL_POLICE)
		//if(SKILL_POWERLOADER)
		//if(SKILL_VEHICLE)
		if(SKILL_DOMESTIC)
			if(skillcheck(src, SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER))
				return 0.5
			if(skillcheck(src, SKILL_DOMESTIC, SKILL_DOMESTIC_TRAINED))
				return 1
			else
				return 2

/mob/proc/check_view_change(var/new_size, var/atom/source)
	return new_size

/mob/proc/can_be_pulled_by(var/mob/M)
	return TRUE

/mob/proc/can_see_reagents()
	return stat == DEAD || isSynth(src) ||HAS_TRAIT(src, TRAIT_REAGENT_SCANNER) //Dead guys and synths can always see reagents

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

/mob/proc/handle_blood_splatter(var/splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/human(loc, splatter_dir)

/proc/get_mobs_in_z_level_range(var/turf/starting_turf, var/range)
	var/list/mobs_in_range = list()
	var/z_level = starting_turf.z
	for(var/mob/mob as anything in GLOB.mob_list)
		if(mob.z != z_level)
			continue
		if(range && get_dist(starting_turf, mob) > range)
			continue
		mobs_in_range += mob
	return mobs_in_range
