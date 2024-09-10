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
		"I sense a disturbance in my circuit board, as if a million people stopped breathing and were suddenly silent.",
		"It's a Dyer situation it is!"
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
			find_and_move_to_patient()


/obj/structure/machinery/bot/cprbot/start_processing()
	START_PROCESSING(SSobj, src)

/obj/structure/machinery/bot/cprbot/stop_processing()
	if (fast_processing)
		STOP_PROCESSING(SSfastobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/structure/machinery/bot/cprbot/Destroy()
	human = null

	stop_processing()
	return ..()

/obj/structure/machinery/bot/cprbot/proc/random_message()
	if (!COOLDOWN_FINISHED(src, message_cooldown))
		return // Exit if the cooldown period has not elapsed yet

	// Send a message based on the current state
	if (currently_healing)
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
	return patient.stat == DEAD && patient.check_tod() && patient.is_revivable() && patient.get_target_lock(iff_signal)

/obj/structure/machinery/bot/cprbot/proc/find_and_move_to_patient()
	var/list/potential_patients = list()
	has_said_to_patient = list()
	for (var/mob/living/carbon/human/patient in view(search_radius, src))
		if (valid_cpr_target(patient))
			potential_patients += patient

	for (var/obj/structure/machinery/bot/cprbot/another_cpr_bot in view(search_radius, src))
		if (another_cpr_bot == src)
			continue

		var/mob/living/carbon/human/another_bot_patient

		// sanity checks
		if (another_cpr_bot.human != null)
			another_bot_patient = another_cpr_bot.human.resolve()

		// sanity checks
		if (another_bot_patient == null)
			continue

		// Another CPR bot is targetting this patient, skip
		if (another_bot_patient in potential_patients)
			potential_patients.Remove(another_bot_patient)

	if (potential_patients.len)
		var/mob/living/carbon/human/patient = potential_patients[1]
		human = WEAKREF(patient)
		if (patient && !(patient in has_said_to_patient))
			visible_message("[patient] is injured! I'm coming!")
			has_said_to_patient += patient

		move_to_target()
	else
		// If no patients are found, check if owner is nearby and follow them if idle
		if (state == STATE_CPRBOT_IDLE && (owner && (owner in view(search_radius, src))))
			state = STATE_CPRBOT_FOLLOWING_OWNER
			walk_to(src, owner, 0, movement_delay)
		else if (state == STATE_CPRBOT_FOLLOWING_OWNER)
			// Continue following the owner if no patient is in sight
			walk_to(src, owner, 0, movement_delay)
		else
			go_idle()

/obj/structure/machinery/bot/cprbot/proc/can_still_see_patient()
	if (human == null)
		return FALSE

	var/mob/living/carbon/human/patient = human.resolve()
	if (patient == null)
		return FALSE

	return patient in view(search_radius, src)

/obj/structure/machinery/bot/cprbot/proc/patient_in_range()
	if (human == null)
		return FALSE

	var/mob/living/carbon/human/patient = human.resolve()
	if (patient == null)
		return FALSE

	return get_dist(src, patient) == 0

/obj/structure/machinery/bot/cprbot/proc/move_to_target()
	var/mob/living/carbon/human/patient = human.resolve()
	// If we cannot see them anymore then stop moving
	if (!can_still_see_patient())
		go_idle()
		return

	// It might not exist anymore or something
	if (patient == null)
		go_idle()
		return

	if (!patient_in_range())
		// We are already moving
		if (state == STATE_CPRBOT_MOVING)
			return

		state = STATE_CPRBOT_MOVING
		walk_to(src, patient, 0, movement_delay)
	else
		walk_to(src, 0) // make sure we stop walking
		state = STATE_CPRBOT_CPR
		switch_to_faster_processing()
		try_perform_cpr()

/obj/structure/machinery/bot/cprbot/proc/perform_cpr(mob/living/carbon/human/target)
	if (!cpr_ready)
		return

	currently_healing = TRUE

	update_icon()

	target.revive_grace_period += 4 SECONDS
	target.visible_message(SPAN_NOTICE("<b>[src]</b> automatically performs <b>CPR</b> on <b>[target]</b>."))
	target.balloon_alert_to_viewers("Performing CPR on [target], do not intervene!")
	currently_healing = TRUE
	playsound(loc, 'sound/CPRbot/CPR.ogg', 25, 1)
	cpr_ready = FALSE
	addtimer(VARSET_CALLBACK(src, cpr_ready, TRUE), 7 SECONDS)

/obj/structure/machinery/bot/cprbot/proc/try_perform_cpr()
	currently_healing = TRUE
	// Resolve the weak reference to check if the target still exists
	var/mob/living/carbon/human/target = human.resolve()

	if (!patient_in_range())
		go_idle()
		switch_to_slower_processing()
		return

	// Check if the target is valid and still needs CPR
	if ((target.stat != DEAD) || (target.stat == DEAD && !target.check_tod()))
		go_idle()
		switch_to_slower_processing()
		return

	perform_cpr(target)

/obj/structure/machinery/bot/cprbot/proc/self_destruct(mob/living/carbon/human/user = null)
	var/obj/item/cprbot_item/I = new /obj/item/cprbot_item(src.loc)

	if (user)
		if (!user.put_in_active_hand(I))
			if (!user.put_in_inactive_hand(I))
				I.forceMove(src.loc)
	else
		I.forceMove(src.loc)

	qdel(src)

/obj/structure/machinery/bot/cprbot/attack_hand(mob/user as mob)
	if (..())
		return TRUE

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		visible_message(SPAN_DANGER("<B>[user] fails to undeploy [src] </B>"))
		return FALSE

	SEND_SIGNAL(user, COMSIG_LIVING_ATTACKHAND_HUMAN, src)

	if (user != src)
		visible_message(SPAN_DANGER("<B>[user] begins to undeploy [src]!</B>"))
	src.self_destruct(user)
	return TRUE

/obj/structure/machinery/bot/cprbot/update_icon()
	. = ..()

	switch(state)
		if (STATE_CPRBOT_IDLE)
			icon_state = "cprbot0"
		if (STATE_CPRBOT_CPR)
			icon_state = "cprbot_active"

/obj/structure/machinery/bot/cprbot/explode()
	src.on = 0
	src.visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
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
