/datum/effects/neurotoxin
	effect_name = "neurotoxin gas"
	duration = 0
	flags = NO_PROCESS_ON_DEATH | DEL_ON_DEATH
	var/strength = 0 // added in later
	var/msg = "Your whole body is feeling numb as you quickly tire out!"
	var/stumble = FALSE
	var/stumble_prob = 0	// Chance of stumbling per proc
	var/bloodcough_prob = 0	// Chance of blood_cough per proc (damaging)
	var/hallucinate = TRUE  // Whether or not we hallucinate. (small rng stun chance)
	var/chat_cd = 0			// Tick-based chat cooldown
	var/stam_dam = 7.5		// Stamina damage per tick

/datum/effects/neurotoxin/New(atom/A)
	..(A)
	cause_data = create_cause_data("neurotoxic gas")

/datum/effects/neurotoxin/validate_atom(atom/A)
	if(isxeno(A) || isobj(A))
		return FALSE


	. = ..()
/datum/effects/neurotoxin/process_mob() //yandere dev coding style
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/affected_mob = affected_atom
// General effects
	affected_mob.apply_stamina_damage(stam_dam)
	if(affected_mob.client)
		affected_mob.make_dizzy(10)

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
			msg = SPAN_DANGER("Your eyes sting, you can't see!")
			bloodcough_prob = 20
			stumble_prob = 5
		if(20 to 24) // 4 ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("Why am I here?"),SPAN_HIGHDANGER("Your entire body feels numb!"), SPAN_HIGHDANGER("You notice your movement is erratic!"), SPAN_HIGHDANGER("You panic as numbness takes over your body!"))
			bloodcough_prob = 25
			stumble_prob = 25
		if(25 to 999) // 5+ ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("What am I doing?"),SPAN_DANGER("Your hearing fades away, you can't hear anything!"),SPAN_HIGHDANGER("A sharp pain eminates from your abdomin!"),SPAN_HIGHDANGER("EVERYTHING IS HURTING!! AGH!!!"),SPAN_HIGHDANGER("Your entire body is numb, you can't feel anything!"),SPAN_HIGHDANGER("You can't feel your limbs at all!"),SPAN_HIGHDANGER("Your mind goes blank, you can't think of anything!"))

// Stacking effects below

	if(duration >= 10) // 2 ticks in smoke
		affected_mob.apply_effect(10,pick(SLUR,STUTTER))
		affected_mob.apply_effect(max(affected_mob.eye_blurry, strength), EYE_BLUR)
	if(duration > 14) // 3 ticks in smoke
		affected_mob.eye_blind = max(affected_mob.eye_blind, round(strength/4))
	if(duration > 18) // 4 ticks in smoke, neuro is affecting cereberal activity
		affected_mob.apply_effect(5,AGONY)  // Fake crit, a good way to induce panic
		affected_mob.make_jittery(15)
		if(affected_mob.client && ishuman(affected_mob) && hallucinate)
			var/mob/living/carbon/human/affected_human = affected_mob
			procces_hallucination(affected_human)
			hallucinate = FALSE
			addtimer(VARSET_CALLBACK(src,hallucinate,TRUE),rand(4 SECONDS,10 SECONDS))
	if(duration >= 27) // 5+ ticks in smoke, you are ODing now
		affected_mob.apply_effect(1, DAZE) // Unable to talk and weldervision
		affected_mob.apply_damage(2,TOX)
		affected_mob.SetEarDeafness(max(affected_mob.ear_deaf, round(strength*1.5))) //Paralysis of hearing system, aka deafness
	if(duration >= 50) // 10+ ticks, apply some semi-perm damage and end their suffering if they are somehow still alive by now
		affected_mob.apply_internal_damage(10,"liver")
		affected_mob.apply_damage(150,OXY)
	// Applying additonal effects and messages

	if(prob(stumble_prob) && affected_mob.client && affected_mob.stat && stumble)
		affected_mob.visible_message(SPAN_DANGER("[affected_mob] misteps in their confusion!")
		,SPAN_HIGHDANGER("You stumble!"))
		step(affected_mob, pick(CARDINAL_ALL_DIRS))
		affected_mob.apply_effect(5, DAZE) // Unable to talk and weldervision
		affected_mob.make_jittery(25)
		affected_mob.make_dizzy(55)
		affected_mob.emote("pain")
		stumble = FALSE
		addtimer(VARSET_CALLBACK(src,stumble ,TRUE),2 SECONDS)

	if(prob(bloodcough_prob && affected_mob.client))
		affected_mob.emote("cough")
		affected_mob.Slow(1)
		affected_mob.apply_damage(5,BRUTE, "chest")
		to_chat(affected_mob, SPAN_DANGER("You cough up blood!"))
	if(chat_cd <= 0)
		to_chat(affected_mob,msg)
		chat_cd++
	else chat_cd--

	return TRUE

/datum/effects/neurotoxin/proc/procces_hallucination(human)
	var/mob/living/carbon/human/victim = human
	var/probability = rand(0, 100)
	var/hallu_area = get_area(victim)
	switch(probability)
		if(0 to 5)
			if(hallu_area)
				for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
					to_chat(observer, SPAN_DEADSAY("<b>[victim]</b> has experienced a rare neuro-induced 'Schizo Lurker Pounce' hallucination (5% chance) at \the <b>[hallu_area]</b>" + " (<a href='?src=\ref[observer];jumptocoord=1;X=[victim.loc.x];Y=[victim.loc.y];Z=[victim.loc.z]'>JMP</a>)"))
			playsound_client(victim.client,pick('sound/voice/alien_pounce.ogg','sound/voice/alien_pounce.ogg'))
			victim.KnockDown(3)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1.5 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 2 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 2.5 SECONDS)
			victim.apply_effect(AGONY,10)
			victim.emote("pain")
		if(6 to 10)
			if(hallu_area)
				for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
					to_chat(observer, SPAN_DEADSAY("<b>[victim]</b> has experienced a rare neuro-induced 'OB' hallucination (4% chance) at \the <b>[hallu_area]</b>" + " (<a href='?src=\ref[observer];jumptocoord=1;X=[victim.loc.x];Y=[victim.loc.y];Z=[victim.loc.z]'>JMP</a>)"))
			playsound_client(victim.client,'sound/effects/ob_alert.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_orbital_travel.ogg'), 2 SECONDS)
		if(11 to 16)
			playsound_client(victim.client,'sound/voice/alien_queen_screech.ogg')
			victim.KnockDown(1)
		if(17 to 24)
			if(hallu_area)
				for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
					to_chat(observer, SPAN_DEADSAY("<b>[victim]</b> has experienced a rare neuro-induced 'Fake CAS firemission' hallucination (7% chance) at \the <b>[hallu_area]</b>" + " (<a href='?src=\ref[observer];jumptocoord=1;X=[victim.loc.x];Y=[victim.loc.y];Z=[victim.loc.z]'>JMP</a>)"))
			hallucination_fakecas(victim) //Not gonna spam a billion timers for this one so outsourcing to a proc with sleeps is a better async solution
		if(25 to 42)
			to_chat(victim,SPAN_HIGHDANGER("A SHELL IS ABOUT TO IMPACT [pick(SPAN_UNDERLINE("TOWARDS THE [pick("WEST","EAST","SOUTH","NORTH")]"),SPAN_UNDERLINE("RIGHT ONTOP OF YOU!"))]!"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_mortar_travel.ogg'), 1 SECONDS)
		if(43 to 69)
			victim.emote(pick("twitch","drool","moan","giggle"))
			victim.hallucination = 3
			victim.druggy = 3
		if(70 to 100) // sound based hallucination
			playsound_client(victim.client,pick('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg','sound/voice/alien_queen_breath1.ogg', 'sound/voice/4_xeno_roars.ogg','sound/misc/notice2.ogg',"bone_break","gun_pulse","metalbang","pry","shatter"))

/datum/effects/neurotoxin/proc/hallucination_fakecas(human) // lazy async solution
	var/mob/living/carbon/human/victim = human
	playsound_client(victim.client,'sound/weapons/dropship_sonic_boom.ogg')
	sleep(35)
	to_chat(victim,SPAN_HIGHDANGER("A DROPSHIP FIRES [pick(SPAN_UNDERLINE("RIGHT ABOVE YOU"),SPAN_UNDERLINE("TO YOUR WEST"))]!")) // Got lazy :/
	sleep(5)
	playsound_client(victim.client,'sound/effects/rocketpod_fire.ogg')
	sleep(10)
	playsound_client(victim.client,'sound/effects/gau.ogg')
	sleep(5)
	playsound_client(victim.client,'sound/effects/rocketpod_fire.ogg')
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(4)
	playsound_client(victim.client,"explosion")
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(5)
	playsound_client(victim.client,'sound/effects/rocketpod_fire.ogg')
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(1)
	playsound_client(victim.client,"explosion")
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(3)
	playsound_client(victim.client,"bigboom")
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(5)
	playsound_client(victim.client,'sound/effects/rocketpod_fire.ogg')
	sleep(6)
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(7)
	playsound_client(victim.client,'sound/effects/gauimpact.ogg')
	sleep(5)
	playsound_client(victim.client,"explosion")
	victim.emote("pain")
