/mob/living/carbon/hellhound
	name = "hellhound"
	desc = "A ferocious monster!"
	voice_name = "hellhound"
	speak_emote = list("roars","grunts","rumbles")
	icon = 'icons/mob/hellhound.dmi'
	icon_state = "hellhound"
	gender = NEUTER
	health = 120 //Kinda tough. They heal quickly.
	maxHealth = 120

	var/obj/item/device/radio/headset/yautja/radio
	var/obj/structure/machinery/camera/camera
	var/mob/living/carbon/human/master
	speed = -0.6
	var/attack_timer = 0

/mob/living/carbon/hellhound/Initialize()
	create_reagents(1000)

	add_language("Sainja") //They can only understand it though.

	if(name == initial(name))
		var/random_name = "[name] ([rand(1, 1000)])"
		change_real_name(src, random_name)

	radio = new /obj/item/device/radio/headset/yautja(src)
	camera = new /obj/structure/machinery/camera(src)
	camera.network = list("PRED")
	camera.c_tag = src.real_name
	..()

	sight |= SEE_MOBS
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8
	SSmob.living_misc_mobs += src
	GLOB.hellhound_list += src

	for(var/mob/dead/observer/M in GLOB.observer_list)
		to_chat(M, SPAN_WARNING("<B>A hellhound is now available to play!</b> Please be sure you can follow the rules."))
		to_chat(M, SPAN_WARNING("Click 'Join as hellhound' in the ghost panel to become one. First come first serve!"))
		to_chat(M, SPAN_WARNING("If you need help during play, click adminhelp and ask."))

/mob/living/carbon/hellhound/Destroy()
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/carbon/hellhound/Login()
	. = ..()
	to_chat(src, "<span style='font-weight: bold; color: red;'>Attention!! You are playing as a hellhound. You can get server banned if you are shitty so listen up!</span>")
	to_chat(src, "<span style='color: red;'>You MUST listen to and obey the Predator's commands at all times. Die if they demand it. Not following them is unthinkable to a hellhound.</span>")
	to_chat(src, "<span style='color: red;'>You are not here to go hog wild rambo. You're here to be part of something rare, a Predator hunt.</span>")
	to_chat(src, "<span style='color: red;'>The Predator players must follow a strict code of role-play and you are expected to as well.</span>")
	to_chat(src, "<span style='color: red;'>The Predators cannot understand your speech. They can only give you orders and expect you to follow them. They have a camera that allows them to see you remotely, so you are excellent for scouting missions.</span>")
	to_chat(src, "<span style='color: red;'>Hellhounds are fiercely protective of their masters and will never leave their side if under attack.</span>")
	to_chat(src, "<span style='color: red;'>Note that ANY Predator can give you orders. If they conflict, follow the latest one. If they dislike your performance they can ask for another ghost and everyone will mock you. So do a good job!</span>")

/mob/living/carbon/hellhound/proc/bite_human(var/mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(a_intent == INTENT_HELP)
		if(isYautja(H))
			visible_message("[src] licks [H].", "You slobber on [H].")
		else
			visible_message("[src] sniffs at [H].", "You sniff at [H].")
		return
	else if(a_intent == INTENT_GRAB)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("[src] has grabbed [H] in their jaws!"), 1)
		src.start_pulling(H)
	else
		if(isYautja(H))
			to_chat(src, "Your loyalty to the Yautja forbids you from harming them.")
			return

		var/dmg = rand(10,25)
		H.apply_damage(dmg,BRUTE,edge = 1) //Does NOT check armor.
		visible_message(SPAN_DANGER("<B>[src] mauls [H]!</b>"),SPAN_DANGER("<B>You maul [H]!</b>"))
		playsound(loc, 'sound/weapons/bite.ogg', 25, 1)
	return

/mob/living/carbon/hellhound/proc/bite_xeno(var/mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return

	if(a_intent == INTENT_HELP)
		visible_message("[src] growls at [X].", "You growl at [X].")
		return
	else if(a_intent == INTENT_GRAB)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
		visible_message(SPAN_DANGER("<B>[src] grabs [X] in their jaws!</B>"),SPAN_DANGER("<B>You grab [X] in your jaws!</b>"))
		src.start_pulling(X)
	else
		var/dmg = rand(20,32)
		X.apply_damage(dmg,BRUTE,edge = 1) //Does NOT check armor.
		visible_message(SPAN_DANGER("<B>[src] mauls [X]!</b>"),SPAN_DANGER("<B>You maul [X]!</b>"))
		playsound(loc, 'sound/weapons/bite.ogg', 25, 1)
	return

/mob/living/carbon/hellhound/proc/bite_animal(var/mob/living/H)
	if(!istype(H))
		return

	if(a_intent == INTENT_HELP)
		visible_message("[src] growls at [H].", "You growl at [H].")
		return
	else if(a_intent == INTENT_DISARM)
		visible_message(SPAN_DANGER("[src] shoves at [H]!"),SPAN_DANGER("You shove at [H]!"))
		return
	else if(a_intent == INTENT_GRAB)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
		visible_message(SPAN_DANGER("<B>[src] grabs [H] in their jaws!</B>"),SPAN_DANGER("<B>You grab [H] in your jaws!</b>"))
		src.start_pulling(H)
		return
	else
		if(istype(H,/mob/living/simple_animal/corgi)) //Kek
			to_chat(src, "Awww.. it's so harmless. Better leave it alone.")
			return
		if(isYautja(H))
			return
		var/dmg = rand(3,8)
		H.apply_damage(dmg,BRUTE,edge = 1) //Does NOT check armor.
		visible_message(SPAN_DANGER("<B>[src] mauls [H]!</b>"),SPAN_DANGER("<B>You maul [H]!</b>"))
		playsound(loc, 'sound/weapons/bite.ogg', 25, 1)
	return

//punched by a hu-man
/mob/living/carbon/hellhound/attack_hand(mob/living/carbon/human/M as mob)
	if (!SSticker.mode)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if (M.a_intent == INTENT_HELP)
		help_shake_act(M)
	else
		if (M.a_intent == INTENT_HARM)
			var/datum/unarmed_attack/attack = M.species.unarmed
			if ((prob(75) && health > 0))
				visible_message(SPAN_DANGER("<B>[M] [pick(attack.attack_verb)]ed [src]!</B>"))

				playsound(loc, "punch", 25, 1)
				var/damage = rand(3, 7)

				apply_damage(damage, BRUTE)

				M.last_damage_data = create_cause_data(initial(name), src)
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [src.name] ([src.ckey])</font>")
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [M.name] ([M.ckey])</font>")
				msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z]).", M.loc.x, M.loc.y, M.loc.z)

				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1)
				visible_message(SPAN_DANGER("<B>[M] tried to [pick(attack.attack_verb)] [src]!</B>"))
		else
			if (M.a_intent == INTENT_GRAB)

				if(M == src || anchored)
					return 0
				M.start_pulling(src)
				return 1

			else
				if (!( knocked_out ))
					if (prob(25))
						KnockOut(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(SPAN_DANGER("<B>[M] has pushed down [name]!</B>"), 1)
					else
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(SPAN_DANGER("<B>[M] shoves at [name]!</B>"), 1)
	return

/mob/living/carbon/hellhound/attack_animal(mob/living/M as mob)

	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), 1)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [key_name(src)]</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [key_name(M)]</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		apply_damage(damage, BRUTE)
		updatehealth()

/mob/living/carbon/hellhound/IsAdvancedToolUser()
	return 0


/mob/living/carbon/hellhound/say(var/message)
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot speak in IC (Muted)."))
			return
	message =  trim(strip_html(message))
	if(stat == 2)
		return say_dead(message)

	if(stat) return //Unconscious? Nope.

	if(copytext(message,1,2) == "*") //Emotes.
		return emote(copytext(message,2))
	var/verb_used = pick("growls","rumbles","howls","grunts")
	if(length(message) >= 2 && radio)
		var/radio_prefix = copytext(message,1,2)
		if(radio_prefix == ":" || radio_prefix == ";") //Hellhounds do not actually get to talk on the radios, only listen.
			message = trim(copytext(message,2))
			if(!message) return
			for(var/mob/living/carbon/hellhound/M in GLOB.hellhound_list)
				to_chat(M, SPAN_NOTICE(" <B>\[RADIO\]</b>: [src.name] [verb_used], '<B>[message]<B>'."))
			return

	message = capitalize(trim_left(message))
	if(!message || stat)
		return

	to_chat(src, SPAN_NOTICE(" You say, '<B>[message]</b>'."))
	for(var/mob/living/carbon/hellhound/H in orange(9))
		to_chat(H, SPAN_NOTICE(" [src.name] [verb_used], '[message]'."))

	for(var/mob/living/carbon/C in orange(6))
		if(!istype(C,/mob/living/carbon/hellhound))
			to_chat(C, SPAN_NOTICE(" [src.name] [verb_used]."))
	return

/mob/living/carbon/hellhound/rejuvenate()
	..()
	GLOB.hellhound_list += src
	SSmob.living_misc_mobs += src
