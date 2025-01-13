#define STATE_CPRBOT_IDLE "idle"
#define STATE_CPRBOT_MOVING "moving"
#define STATE_CPRBOT_CPR "cpr"
#define STATE_CPRBOT_FOLLOWING_OWNER "following_owner"


/obj/structure/machinery/bot/cprbot
	name = "\improper CPRbot"
	desc = "Designed for urgent medical intervention, this CPRbot offers high-tech support in a compact form."
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "cprbot0"
	density = FALSE
	anchored = FALSE
	health = 100
	maxhealth = 100
	req_access = list(ACCESS_MARINE_MEDBAY)

	/// Radius to search for patients
	var/static/search_radius = 7
	/// Radius to check for nearby CPRbots
	var/static/cprbot_proximity_check_radius = 2
	/// Current target for CPR (using weak reference)
	var/datum/weakref/human
	var/list/botcard_access = list(ACCESS_MARINE_MEDBAY)
	/// Indicates whether the bot is currently healing
	var/currently_healing = FALSE
	var/cpr_ready = TRUE
	/// IFF signal to check for valid targets
	var/iff_signal = FACTION_MARINE
	/// Cooldown for the random idle messages and medical facts
	var/cooldown_time = 60 SECONDS
	var/movement_delay = 4
	var/owner
	var/fast_processing = FALSE
	COOLDOWN_DECLARE(message_cooldown)

	var/state = STATE_CPRBOT_IDLE

	var/turf/last_location // used for pathfinding

	var/list/path = list()

	var/move_to_delay = 4

	var/static/list/medical_facts = list(
		"Did you know? The human heart beats over 100,000 times a day.",
		"Fun fact: Blood makes up about 7% of your body's weight.",
		"Medical trivia: Your brain uses 20% of the oxygen you breathe.",
		"Laughter really can increase your pain tolerance.",
		"Did you know? The human skeleton is made up of 206 bones.",
		"Fun fact: The average adult human body contains about 5 liters of blood.",
		"Medical trivia: The human body has around 37.2 trillion cells.",
		"The skin is the largest organ in the human body.",
		"Did you know? The liver can regenerate itself if a portion is removed.",
		"Fun fact: Your sense of smell is closely linked to your memory.",
		"The only muscle that never tires is that heart.",
		"Did you know? Not breathing can lead to a premature cessation of life!"
	)

	var/static/list/idle_messages = list(
		"Stay still, I'm assessing the situation.",
		"Just a routine check-up, don't worry.",
		"Scanning the area for any casualties.",
		"I’m ready to save lives, one compression at a time.",
		"I hope everyone is feeling alright today!",
		"It's not magic, it's CPR Buddy 9000!",
		"I should have been a plastic surgeon.",
		"What kind of medbay is this? Everyone’s dropping like flies.",
		"Each breath a day keeps me at bay!",
		"I sense a disturbance in my circuit board, as if a million people stopped breathing and were suddenly silent."
	)

	/// Message to display when performing CPR
	var/motivational_message = "Live! Live! Don't die on me now!"
	/// List of patients who have been warned
	var/list/has_said_to_patient = list()
	/// Tracks the last time a message was spoken
	var/last_message_time = 0

/obj/structure/machinery/bot/cprbot/Initialize(mapload, ...)
	. = ..()
	start_processing()
	playsound(loc, 'sound/CPRbot/CPRbot_poweron.ogg', 25, 1)
	src.botcard = new /obj/item/card/id(src)
	if(!LAZYLEN(src.botcard_access))
		var/datum/job/Job = GLOB.RoleAuthority ? GLOB.RoleAuthority.roles_by_path[/datum/job/civilian/doctor] : new /datum/job/civilian/doctor
		botcard.access = Job.get_access()
	else
		src.botcard.access = src.botcard_access

/obj/structure/machinery/bot/cprbot/process()
	if (health > 0)
		think()

		random_message()
	else
		stop_processing()

/obj/structure/machinery/bot/cprbot/proc/think()
	switch (state)
		if (STATE_CPRBOT_IDLE)
			find_and_move_to_patient()
		if (STATE_CPRBOT_MOVING)
			move_to_target()
		if (STATE_CPRBOT_CPR)
			try_perform_cpr()
		if (STATE_CPRBOT_FOLLOWING_OWNER)
			follow_owner()

/obj/structure/machinery/bot/cprbot/proc/follow_owner()
	if (!owner || isnull(owner))
		go_idle()
		return

	// Check if the owner is in range of the bot's view
	if (!(owner in view(search_radius, src)))
		go_idle()
		return

	// If the bot has a path, proceed with walking along it
	if (length(path))
		var/turf/next = path[1]
		if (loc == next)
			path -= next // Remove the turf from the path once reached

		walk_to(src, next, 0, move_to_delay)
		return

	// If the owner is not in range, move towards them directly
	if (!patient_in_range(owner))
		// If the bot is already moving, just return
		if (state == STATE_CPRBOT_MOVING)
			return

		// Set the state to moving and walk directly to the owner's location
		state = STATE_CPRBOT_MOVING
		walk_to(src, owner, 0, movement_delay)
	else
		go_idle()

/obj/structure/machinery/bot/cprbot/start_processing()
	START_PROCESSING(SSobj, src)

/obj/structure/machinery/bot/cprbot/stop_processing()
	if (fast_processing)
		STOP_PROCESSING(SSfastobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/structure/machinery/bot/cprbot/Destroy()
	human = null
	path = null
	botcard_access = null

	stop_processing()
	return ..()

/obj/structure/machinery/bot/cprbot/proc/random_message()
	if (!COOLDOWN_FINISHED(src, message_cooldown))
		return // Exit if the cooldown period has not elapsed yet

	// Send a message based on the current state
	if (currently_healing)
		if (prob(50))
			speak(motivational_message)
	else
		if (prob(50))
			speak(pick(medical_facts))
		else
			speak(pick(idle_messages))


	// Start the cooldown timer for the next message
	COOLDOWN_START(src, message_cooldown, cooldown_time)

/obj/structure/machinery/bot/cprbot/proc/speak(message)
	if (!message)
		return
	visible_message("[src] beeps, \"[message]\"")
	playsound(loc, 'sound/CPRbot/CPRbot_beep.ogg', 25, 1)

/obj/structure/machinery/bot/cprbot/proc/go_idle()
	human = null
	state = STATE_CPRBOT_IDLE
	cpr_ready = TRUE
	currently_healing = FALSE
	walk_to(src, 0) // make sure we stop walking
	update_icon()

/obj/structure/machinery/bot/cprbot/proc/valid_cpr_target(mob/living/carbon/human/patient)
	// Check if the patient is a valid target for CPR
	return patient.stat == DEAD && patient.check_tod() && patient.is_revivable() && patient.get_target_lock(iff_signal) && ishuman_strict(patient)

/obj/structure/machinery/bot/cprbot/proc/find_and_move_to_patient()
	var/list/potential_patients = list()

	// Find all valid CPR targets within the bot's view range
	for (var/mob/living/carbon/human/patient in view(search_radius, src))
		if (valid_cpr_target(patient))
			potential_patients += patient

	// Remove patients already being targeted by other CPR bots
	for (var/obj/structure/machinery/bot/cprbot/other_cpr_bot in view(search_radius, src))
		if (other_cpr_bot == src)
			continue // Skip self-check

		var/mob/living/carbon/human/other_bot_patient

		// Resolve the other bot's patient target (sanity checks included)
		if (!isnull(other_cpr_bot.human))
			other_bot_patient = other_cpr_bot.human?.resolve()

		if (!isnull(other_bot_patient) && (other_bot_patient in potential_patients))
			potential_patients.Remove(other_bot_patient) // Remove the patient targeted by another bot

	// If potential patients are found, target the first one
	if (length(potential_patients))
		var/mob/living/carbon/human/patient = potential_patients[1]
		human = WEAKREF(patient)

		if (patient && !(patient in has_said_to_patient))
			visible_message("[patient] is injured! I'm coming!")
			has_said_to_patient += patient

		move_to_target()
	else
		// If no patients are found, follow the owner if idle
		if (state == STATE_CPRBOT_IDLE && owner && (owner in view(search_radius, src)))
			state = STATE_CPRBOT_FOLLOWING_OWNER
			walk_to(src, owner, 0, movement_delay)
		else if (state == STATE_CPRBOT_FOLLOWING_OWNER)
			return
		else
			// Default to idle state
			go_idle()

/obj/structure/machinery/bot/cprbot/proc/call_astar_pathfinding()
	var/mob/living/carbon/human/patient = human?.resolve()
	if (isnull(patient))
		return FALSE

	var/turf/target_turf = get_turf(patient)

	if (!target_turf)
		return

	// Calculate the path using your A* function
	path = AStar(loc, target_turf, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id=botcard)

	if (!length(path))
		return

	// Delete the straight line sections since walk_to moves better without that.
	var/list/path_new = list()
	var/turf/last = path[length(path)]

	if (!istype(last, /turf)) // Ensure last is a turf before accessing it
		return

	path_new.Add(path[1])

	for (var/i = 2; i < length(path); i++)
		if (istype(path[i], /turf) && istype(path[i + 1], /turf))
			var/turf/current_turf = path[i]
			var/turf/next_turf = path[i + 1]

			if ((next_turf.x == current_turf.x) || (next_turf.y == current_turf.y)) // We have a straight line, scan for more to cut down
				path_new.Add(current_turf)
				for (var/j = i + 1; j < path.len; j++)
					if (istype(path[j + 1], /turf))
						var/turf/next_next_turf = path[j + 1]
						var/turf/prev_turf = path[j - 1]

						// This is a corner and the endpoint of our line
						if ((next_next_turf.x != prev_turf.x) && (next_next_turf.y != prev_turf.y))
							path_new.Add(path[j])
							i = j + 1
							break



					if (j == path.len - 1)
						path = list()
						path = path_new.Copy()
						path.Add(last)
						return


			else
				path_new.Add(current_turf)

	path = list()
	path = path_new.Copy()
	path.Add(last)

	if (!path || length(path) == 0)
		human = null
		currently_healing = FALSE
		return

	// Start moving
	state = STATE_CPRBOT_MOVING
	move_to_target()
	return

/obj/structure/machinery/bot/cprbot/proc/can_still_see_patient()
	var/mob/living/carbon/human/patient = human?.resolve()
	if (isnull(patient))
		return FALSE

	return patient in view(search_radius, src)

/obj/structure/machinery/bot/cprbot/proc/patient_in_range(mob/living/carbon/human/patient = null)
	if (isnull(human))
		return FALSE

	if (isnull(patient))
		patient = human?.resolve()

	if (isnull(patient))
		return FALSE

	return get_dist(src, patient) == 0

/obj/structure/machinery/bot/cprbot/proc/move_to_target()
	var/mob/living/carbon/human/patient = human?.resolve()
	// If we cannot see them anymore then stop moving
	if (!can_still_see_patient())
		go_idle()
		return

	// It might not exist anymore or something
	if (isnull(patient))
		go_idle()
		return
	if (is_no_longer_valid(patient))
		go_idle()
		return

	if (length(path))
		var/turf/next = path[1]
		if(loc == next)
			path -= next

			if (length(path))
				walk_to(src, path[1], 0, move_to_delay)
			else
				walk_to(src, 0)
				state = STATE_CPRBOT_CPR
				switch_to_faster_processing()
				try_perform_cpr()
			return

		walk_to(src, next, 0, move_to_delay)
		return

	if (!patient_in_range())
		if (last_location == loc)
			walk_to(src, 0)
			call_astar_pathfinding()
			return

		// We are already moving
		if (state == STATE_CPRBOT_MOVING)
			last_location = loc
			return

		state = STATE_CPRBOT_MOVING
		walk_to(src, patient, 0, movement_delay)
	else
		walk_to(src, 0) // make sure we stop walking
		state = STATE_CPRBOT_CPR
		switch_to_faster_processing()
		try_perform_cpr()

/obj/structure/machinery/bot/cprbot/proc/is_no_longer_valid(mob/living/carbon/human/target)
	return (target.stat != DEAD) || (target.stat == DEAD && !target.check_tod())

/obj/structure/machinery/bot/cprbot/proc/perform_cpr(mob/living/carbon/human/target)
	if (!cpr_ready)
		return

	currently_healing = TRUE

	update_icon()

	target.revive_grace_period += 4 SECONDS
	target.visible_message(SPAN_NOTICE("<b>[src]</b> automatically performs <b>CPR</b> on <b>[target]</b>."))
	target.balloon_alert_to_viewers("Performing CPR, stay clear!")
	currently_healing = TRUE
	playsound(loc, 'sound/CPRbot/CPR.ogg', 25, 1)
	cpr_ready = FALSE
	addtimer(VARSET_CALLBACK(src, cpr_ready, TRUE), 7 SECONDS)

/obj/structure/machinery/bot/cprbot/proc/try_perform_cpr()
	currently_healing = TRUE
	// Resolve the weak reference to check if the target still exists
	var/mob/living/carbon/human/target = human?.resolve()

	if (!patient_in_range())
		go_idle()
		switch_to_slower_processing()
		return

	// Check if the target is valid and still needs CPR
	if (is_no_longer_valid(target))
		go_idle()
		switch_to_slower_processing()
		return

	perform_cpr(target)

/obj/structure/machinery/bot/cprbot/proc/self_destruct(mob/living/carbon/human/user = null)
	var/obj/item/cprbot_item = new /obj/item/cprbot_item(loc)

	playsound(loc, 'sound/CPRbot/CPRbot_poweroff.ogg', 25, 1)
	qdel(src)
	if (!user)
		cprbot_item.forceMove(loc)
		return
	if(user.put_in_active_hand(cprbot_item))
		return
	if(!user.put_in_inactive_hand(cprbot_item))
		cprbot_item.forceMove(loc)

/obj/structure/machinery/bot/cprbot/attack_hand(mob/user)
	if (..())
		return TRUE

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You have no idea how to undeploy [src]."))
		return FALSE

	SEND_SIGNAL(user, COMSIG_LIVING_ATTACKHAND_HUMAN, src)

	to_chat(user, SPAN_WARNING("You undeploy [src]."))
	self_destruct(user)
	return TRUE

/obj/structure/machinery/bot/cprbot/update_icon()
	. = ..()

	switch(state)
		if (STATE_CPRBOT_IDLE)
			icon_state = "cprbot0"
		if (STATE_CPRBOT_CPR)
			icon_state = "cprbot_active"

/obj/structure/machinery/bot/cprbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/cprbot_broken(Tsec)

	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(3, 1, src)
	spark.start()

	qdel(src)
	return

/obj/structure/machinery/bot/cprbot/proc/switch_to_faster_processing()
	STOP_PROCESSING(SSobj, src)
	START_PROCESSING(SSfastobj, src)
	fast_processing = TRUE

/obj/structure/machinery/bot/cprbot/proc/switch_to_slower_processing()
	STOP_PROCESSING(SSfastobj, src)
	START_PROCESSING(SSobj, src)
	fast_processing = FALSE

/obj/structure/machinery/bot/cprbot/Collide(atom/collided_atom) //Leave no door unopened!
	if ((istype(collided_atom, /obj/structure/machinery/door)) && (!isnull(botcard)))
		var/obj/structure/machinery/door/collided_door = collided_atom
		if (!istype(collided_door, /obj/structure/machinery/door/firedoor) && collided_door.check_access(botcard) && !istype(collided_door,/obj/structure/machinery/door/poddoor))
			collided_door.open()
	else if ((istype(collided_atom, /mob/living/)) && (!anchored))
		forceMove(collided_atom.loc)
	else if ((istype(collided_atom, /mob/living/)) && (!anchored))
		forceMove(collided_atom.loc)
#undef STATE_CPRBOT_IDLE
#undef STATE_CPRBOT_MOVING
#undef STATE_CPRBOT_CPR
#undef STATE_CPRBOT_FOLLOWING_OWNER
