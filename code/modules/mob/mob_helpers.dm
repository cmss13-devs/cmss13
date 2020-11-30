#define isdeaf(A) (ismob(A) && ((A?:sdisabilities & DEAF) || A?:ear_deaf))
#define areSameSpecies(A, B) 	(isliving(A) && isliving(B) && \
									((isXeno(A) && isXeno(B)) || \
										(ishuman(A) && ishuman(B) && !(isYautja(A) ^ isYautja(B))) \
									) \
								)
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
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
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

	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0)
	zone = check_zone(zone)

	// you can only miss if your target is standing and not restrained
	if(!target.buckled && !target.lying)
		var/miss_chance = 10
		if (zone in base_miss_chance)
			miss_chance = base_miss_chance[zone]
		miss_chance = max(miss_chance + miss_chance_mod, 0)
		if(prob(miss_chance))
			if(prob(70))
				return null
			return pick(base_miss_chance)

	return zone


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
		switch(rand(1,15))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
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


/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera)
		return
	M.shakecamera = 1
	spawn(1)
		if(!M.client)
			return

		var/atom/oldeye=M.client.eye
		var/aiEyeFlag = 0
		if(istype(oldeye, /mob/aiEye))
			aiEyeFlag = 1

		var/x
		for(x=0; x<duration, x++)
			if(!M) return //Might have died/logged out before it ended

			if(!M.client)
				M.shakecamera = 0
				return

			if(aiEyeFlag)
				M.client.eye = locate(dd_range(1,oldeye.loc.x+rand(-strength,strength),world.maxx),dd_range(1,oldeye.loc.y+rand(-strength,strength),world.maxy),oldeye.loc.z)
			else
				M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		if(M.client)
			M.client.eye=oldeye //Mighta disconnected
		M.shakecamera = 0


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

//can the mob be operated on?
/mob/proc/can_be_operated_on()
	return FALSE

//check if mob is lying down on something we can operate him on.
/mob/living/carbon/can_be_operated_on()
	if(!lying) return FALSE
	if(locate(/obj/structure/machinery/optable, loc) || locate(/obj/structure/bed/roller, loc))
		return TRUE
	var/obj/structure/surface/table/T = locate(/obj/structure/surface/table, loc)
	if(T && !T.flipped) return TRUE

/mob/living/carbon/hellhound/can_be_operated_on()
	return FALSE

/mob/living/carbon/Xenomorph/can_be_operated_on()
	return FALSE


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

	var/obj/screen/zone_sel/zone

	for(var/A in usr.client.screen)
		if(istype(A, /obj/screen/zone_sel))
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
			else if(skillcheck(src, SKILL_CQC, SKILL_CQC_MP))
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

		if(SKILL_SURGERY)
			if(skillcheck(src, SKILL_SURGERY, SKILL_SURGERY_EXPERT))
				return DURATION_MULTIPLIER_TIER_3
		//if(SKILL_RESEARCH)
		//if(SKILL_PILOT)
		//if(SKILL_POLICE)
		//if(SKILL_POWERLOADER)
		//if(SKILL_VEHICLE)
		else
			if(isYautja(src) || (isSynth(src) && !isEarlySynthetic(src)))
				return DURATION_MULTIPLIER_TIER_3 //Acceleration for things that don't fall under skills
