/datum/effects/neurotoxin
	effect_name = "neurotoxin gas"
	/// Duration of the effect. Also used for intensity aswell
	duration = 0
	// We don't want to damage people when they die
	flags = NO_PROCESS_ON_DEATH | DEL_ON_DEATH
	/// Multiplier for effects. Inputted in directly.
	var/strength = 0
	/// Default per proc message
	var/msg = "Your whole body is feeling numb as you quickly tire out!"
	/// Should we stumble on next tick? Changed automatically
	var/stumble = TRUE
	/// Probability of stumbling per proc. Changed by code.
	var/stumble_prob = 0
	/// Chance of blood_cough per proc (damaging)
	var/bloodcough_prob = 0
	/// Whether or not we hallucinate. (small rng stun chance)
	var/hallucinate = TRUE
	// Tick-based chat cooldown so it doesn't get too spammy
	var/chat_cd = 0
	/// Stamina damage per tick. Major balance number.
	var/stam_dam = 7
	/// Stimulant drain per tick.
	var/stim_drain = 2

/datum/effects/neurotoxin/New(atom/thing, mob/from = null)
	..(thing, from, effect_name)

/datum/effects/neurotoxin/validate_atom(atom/thing)
	if(isxeno(thing) || isobj(thing))
		return FALSE

	return ..()

/datum/effects/neurotoxin/process_mob() //yandere dev coding style
	. = ..()
	var/mob/living/carbon/affected_mob = affected_atom
	if(!.)
		return FALSE
	if(affected_mob.stat == DEAD)
		return

	if(issynth(affected_atom))
		return

// General effects
	affected_mob.last_damage_data = cause_data
	affected_mob.apply_stamina_damage(stam_dam)
	affected_mob.make_dizzy(8)
	for(var/datum/reagent/generated/stim in affected_mob.reagents.reagent_list)
		affected_mob.reagents.remove_reagent(stim.id, stim_drain, TRUE)

// Effect levels (shit that doesn't stack)
	switch(duration)

		if(0 to 9)
			msg = initial(msg)
			bloodcough_prob = initial(bloodcough_prob)
			stumble_prob = initial(stumble_prob)

		if(10 to 14) // 2 ticks in smoke
			msg = SPAN_DANGER("You body starts feeling numb, you can't feel your fingers!")
			bloodcough_prob = 10

		if(15 to 19) // 3 ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("Why am I here?"),SPAN_HIGHDANGER("Your entire body feels numb!"), SPAN_HIGHDANGER("You notice your movement is erratic!"), SPAN_HIGHDANGER("You panic as numbness takes over your body!"))
			bloodcough_prob = 20
			stumble_prob = 5

		if(20 to 24) // 4 ticks in smoke
			msg = SPAN_DANGER("Your eyes sting, you can't see!")
			bloodcough_prob = 25
			stumble_prob = 25

		if(25 to INFINITY) // 5+ ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("What am I doing?"),SPAN_DANGER("Your hearing fades away, you can't hear anything!"),SPAN_HIGHDANGER("A sharp pain eminates from your abdomen!"),SPAN_HIGHDANGER("EVERYTHING IS HURTING!! AGH!!!"),SPAN_HIGHDANGER("Your entire body is numb, you can't feel anything!"),SPAN_HIGHDANGER("You can't feel your limbs at all!"),SPAN_HIGHDANGER("Your mind goes blank, you can't think of anything!"))

// Stacking effects below

	if(duration >= 10) // 2 ticks in smoke
		affected_mob.apply_effect(10,pick(SLUR,STUTTER))
		affected_mob.apply_effect(max(affected_mob.eye_blurry, strength), EYE_BLUR)

	if(duration > 14) // 3 ticks in smoke
		affected_mob.apply_effect(5,AGONY)  // Fake crit, a good way to induce panic
		affected_mob.make_jittery(15)
		if(affected_mob.client && ishuman(affected_mob) && hallucinate)
			var/mob/living/carbon/human/affected_human = affected_mob
			process_hallucination(affected_human)
			hallucinate = FALSE
			addtimer(VARSET_CALLBACK(src,hallucinate,TRUE),rand(4 SECONDS,10 SECONDS))

	if(duration > 19) // 4 ticks in smoke, neuro is affecting cereberal activity
		affected_mob.eye_blind = max(affected_mob.eye_blind, floor(strength/4))

	if(duration >= 27) // 5+ ticks in smoke, you are ODing now
		affected_mob.apply_effect(1, DAZE) // Unable to talk and weldervision
		affected_mob.apply_damage(2,TOX)
		affected_mob.SetEarDeafness(max(affected_mob.ear_deaf, floor(strength*1.5))) //Paralysis of hearing system, aka deafness

	if(duration >= 50) // 10+ ticks, apply some semi-perm damage and end their suffering if they are somehow still alive by now
		affected_mob.apply_internal_damage(10,"liver")
		affected_mob.apply_damage(150,OXY)
	// Applying additonal effects and messages
	if(prob(stumble_prob) && stumble)
		if(affected_mob.is_mob_incapacitated())
			return
		affected_mob.visible_message(SPAN_DANGER("[affected_mob] misteps in their confusion!")
						,SPAN_HIGHDANGER("You stumble!"))
		step(affected_mob, pick(CARDINAL_ALL_DIRS))
		affected_mob.apply_effect(5, DAZE) // Unable to talk and weldervision
		affected_mob.make_jittery(25)
		affected_mob.make_dizzy(55)
		affected_mob.emote("pain")
		stumble = FALSE
		addtimer(VARSET_CALLBACK(src,stumble,TRUE),3 SECONDS)
		duration++

	if(prob(bloodcough_prob))
		affected_mob.emote("cough")
		affected_mob.Slow(1)
		affected_mob.apply_damage(5,BRUTE, "chest")
		to_chat(affected_mob, SPAN_DANGER("You cough up blood!"))

	if(chat_cd <= 0)
		to_chat(affected_mob,msg)
		chat_cd++
	else
		chat_cd--

	return TRUE

/datum/effects/neurotoxin/proc/process_hallucination(mob/living/carbon/human/victim)
	switch(rand(0, 100))
		if(0 to 5)
			playsound_client(victim?.client,pick('sound/voice/alien_pounce.ogg','sound/voice/alien_pounce.ogg'))
			victim.KnockDown(3)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1.5 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 2 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 2.5 SECONDS)
			victim.apply_effect(AGONY,10)
			victim.emote("pain")
		if(6 to 10)
			playsound_client(victim.client,'sound/effects/ob_alert.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_orbital_travel.ogg'), 2 SECONDS)
		if(11 to 16)
			playsound_client(victim.client,'sound/voice/alien_queen_screech.ogg')
			victim.KnockDown(1)
		if(17 to 24)
			hallucination_fakecas_sequence(victim) //Not gonna spam a billion timers for this one so outsourcing to a proc with sleeps is a better async solution
		if(25 to 42)
			to_chat(victim,SPAN_HIGHDANGER("A SHELL IS ABOUT TO IMPACT [pick(SPAN_UNDERLINE("TOWARDS THE [pick("WEST","EAST","SOUTH","NORTH")]"),SPAN_UNDERLINE("RIGHT ONTOP OF YOU!"))]!"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_mortar_travel.ogg'), 1 SECONDS)
		if(43 to 69)
			victim.emote(pick("twitch","drool","moan","giggle"))
			victim.hallucination = 3
			victim.druggy = 3
		if(70 to 100) // sound based hallucination
			playsound_client(client = victim.client, soundin = pick('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg','sound/voice/alien_queen_breath1.ogg', 'sound/voice/4_xeno_roars.ogg','sound/misc/notice2.ogg',"bone_break","gun_pulse","metalbang","pry","shatter"),vol = 65)



/datum/effects/neurotoxin/proc/hallucination_fakecas_sequence(mob/living/carbon/human/victim)

	playsound_client(victim.client,'sound/weapons/dropship_sonic_boom.ogg')
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), victim,"A DROPSHIP FIRES [pick(SPAN_UNDERLINE("TOWARDS THE [pick("WEST","EAST","SOUTH","NORTH")]"),SPAN_UNDERLINE("RIGHT ONTOP OF YOU!"))]!"), 3.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 4 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gau.ogg'), 5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 5.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 6.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 6.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 7.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 7.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 8.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bigboom"), 9 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 9 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 9.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 10.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 11 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 11 SECONDS)
	victim.emote("pain")
