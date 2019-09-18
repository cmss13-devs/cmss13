// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.KnockDown(rand(0.5,3))
	else
		src.KnockDown(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1)
	if(failed)
		src.KnockDown(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(SPAN_DANGER("<B>[src] [failed ? "tried to tackle" : "has tackled"] down [T]!</B>"), 1)

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 6) return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	src.visible_message(SPAN_WARNING("<b>\The [src]</b> leaps at [T]!"))
	src.throw_at(get_step(get_turf(T),get_turf(src)), 5, 1, src)
	playsound(src.loc, 'sound/voice/shriek1.ogg', 25, 1)

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, SPAN_DANGER("You miss!"))
		return

	T.KnockDown(5)

	//Only official cool kids get the grab and no self-prone.
	if(!(src.mind && src.mind.special_role))
		src.KnockDown(5)
		return

	if(T == src || T.anchored)
		return 0

	start_pulling(T)

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated(TRUE) || lying)
		to_chat(src, SPAN_DANGER("You cannot do that in your current state."))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_DANGER("You are not grabbing anyone."))
		return

	if(usr.grab_level < GRAB_AGGRESSIVE)
		to_chat(src, SPAN_DANGER("You must have an aggressive grab to gut your prey!"))
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>\The [src]</b> rips viciously at \the [G.grabbed_thing]'s body with its claws!"))

	if(istype(G.grabbed_thing,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.grabbed_thing
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib(H.last_damage_source)
	else
		var/mob/living/M = G.grabbed_thing
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib(M.last_damage_source)

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = trim(copytext(sanitize(text), 1, MAX_MESSAGE_LEN))

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/dead/observer) || M.stat == DEAD)
		to_chat(src, "Not even a [src.species.name] can speak to the dead.")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, SPAN_NOTICE(" Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		to_chat(H, SPAN_DANGER("Your nose begins to bleed..."))
		H.drip(1)

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, SPAN_XENOWARNING(" You hear a strange, alien voice in your head... \italic [msg]"))
		to_chat(src, SPAN_XENOWARNING(" You said: \"[msg]\" to [M]"))
	return

/mob/living/carbon/human/proc/issue_order(var/order)
	if(!skillcheck(src, SKILL_LEADERSHIP, SKILL_LEAD_TRAINED))
		to_chat(src, SPAN_WARNING("You are not competent enough in leadership to issue an order."))
		return

	if(stat)
		to_chat(src, SPAN_WARNING("You cannot give an order in your current state."))
		return

	if(!command_aura_available)
		to_chat(src, SPAN_WARNING("You have recently given an order. Calm down."))
		return

	if(!order)
		order = input(src, "Choose an order") in command_aura_allowed + "help" + "cancel"
		if(order == "help")
			to_chat(src, SPAN_NOTICE("<br>Orders give a buff to nearby soldiers for a short period of time, followed by a cooldown, as follows:<br><B>Move</B> - Increased mobility and chance to dodge projectiles.<br><B>Hold</B> - Increased resistance to pain and combat wounds.<br><B>Focus</B> - Increased gun accuracy and effective range.<br>"))
			return
		if(order == "cancel") return

		if(!command_aura_available)
			to_chat(src, SPAN_WARNING("You have recently given an order. Calm down."))
			return

	command_aura_available = FALSE
	command_aura = order

	// order lasts 20 seconds
	add_timer(CALLBACK(src, .proc/end_aura), command_aura_duration)
	// 1min cooldown on orders
	add_timer(CALLBACK(src, .proc/make_aura_available), command_aura_cooldown)

	var/message = ""
	switch(command_aura)
		if("move")
			message = pick(";GET MOVING!", ";GO, GO, GO!", ";WE ARE ON THE MOVE!", ";MOVE IT!", ";DOUBLE TIME!")
			say(message)
		if("hold")
			message = pick(";DUCK AND COVER!", ";HOLD THE LINE!", ";HOLD POSITION!", ";STAND YOUR GROUND!", ";STAND AND FIGHT!")
			say(message)
		if("focus")
			message = pick(";FOCUS FIRE!", ";PICK YOUR TARGETS!", ";CENTER MASS!", ";CONTROLLED BURSTS!", ";AIM YOUR SHOTS!")
			say(message)

/mob/living/carbon/human/proc/end_aura()
	to_chat(src, SPAN_NOTICE("The effects of your order wears off."))
	command_aura = null

/mob/living/carbon/human/proc/make_aura_available()
	to_chat(src, SPAN_NOTICE("You can issue an order again."))
	command_aura_available = TRUE


/mob/living/carbon/human/verb/issue_order_verb()

	set name = "Issue Order"
	set desc = "Issue an order to nearby humans, using your authority to strengthen their resolve."
	set category = "IC"

	issue_order()
