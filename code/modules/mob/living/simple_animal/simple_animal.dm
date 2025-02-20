#define OVERLAY_FIRE_LAYER -1

/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	///Higher speed is slower, negative speed is faster.
	speed = 0


	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "attacks"
	attack_sound = null
	//Attacktext is the mob deal 0 damaage.
	friendly = "nuzzles"
	can_crawl = FALSE
	black_market_value = 25
	dead_black_market_value = 0

	mobility_flags = MOBILITY_FLAGS_LYING_CAPABLE_DEFAULT

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null

	var/list/speak = list()
	var/speak_chance = 0
	///Emotes that can be heard by other mobs.
	var/list/emote_hear = list()
	///Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps.
	var/list/emote_see = list()

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = FALSE //No, just no.
	var/meat_amount = 0
	var/meat_type
	///Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/stop_automated_movement = 0
	///Does the mob wander around when idle?
	var/wander = 1
	///When set to 1 this stops the animal from moving when someone is pulling it.
	var/stop_automated_movement_when_pulled = 1

	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	///amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/heat_damage_per_tick = 3
	///same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/cold_damage_per_tick = 2

	///Will this mob be affected by fire/napalm? Set to FALSE for all mobs as the implications could be weird due to not being tested for all simple mobs.
	var/affected_by_fire = FALSE

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	//Leaving something at 0 means it's off - has no maximum
	var/min_oxy = 5
	var/max_oxy = 0
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	///This damage is taken when atmos doesn't fit all the requirements above
	var/unsuitable_atoms_damage = 2
	var/fire_overlay

/mob/living/simple_animal/Initialize()
	. = ..()
	SSmob.living_misc_mobs += src

/mob/living/simple_animal/Destroy()
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/simple_animal/Login()
	if(src && src.client)
		src.client.screen = null
	..()

/mob/living/simple_animal/updatehealth()
	return

/mob/living/simple_animal/rejuvenate()
	health = maxHealth
	SSmob.living_misc_mobs += src
	return ..()

/mob/living/simple_animal/get_examine_text(mob/user)
	. = ..()
	if(stat == DEAD)
		. += SPAN_BOLDWARNING("[user == src ? "You are" : "It is"] DEAD. Kicked the bucket.")
	else
		var/percent = floor((health / maxHealth * 100))
		switch(percent)
			if(95 to INFINITY)
				. += SPAN_NOTICE("[user == src ? "You look" : "It looks"] quite healthy.")
			if(75 to 94)
				. += SPAN_NOTICE("[user == src ? "You look" : "It looks"] slightly injured.")
			if(50 to 74)
				. += SPAN_DANGER("[user == src ? "You look" : "It looks"] injured.")
			if(25 to 49)
				. += SPAN_DANGER("[user == src ? "You are bleeding" : "It bleeds"] with gory wounds.")
			if(-INFINITY to 24)
				. += SPAN_BOLDWARNING("[user == src ? "You are" : "It is"] heavily injured and limping badly.")

/mob/living/simple_animal/handle_fire()
	if(..())
		return
	apply_damage(fire_reagent.intensityfire * 0.5, BURN)

/mob/living/simple_animal/IgniteMob()
	if(!affected_by_fire)
		return
	return ..()

/mob/living/simple_animal/update_fire()
	if(!on_fire)
		overlays -= fire_overlay
	if(on_fire && fire_reagent)
		var/image/fire_overlay_image
		if(mob_size >= MOB_SIZE_BIG)
			if((body_position != LYING_DOWN))
				fire_overlay_image = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire", "layer" = OVERLAY_FIRE_LAYER)
			else
				fire_overlay_image = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire_lying", "layer" = OVERLAY_FIRE_LAYER)
		else
			fire_overlay_image = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state"="alien_fire", "layer" = OVERLAY_FIRE_LAYER)

		fire_overlay_image.pixel_y -= pixel_y
		fire_overlay_image.pixel_x -= pixel_x
		fire_overlay_image.appearance_flags |= RESET_COLOR|RESET_ALPHA
		fire_overlay_image.color = fire_reagent.burncolor
		fire_overlay_image.color = fire_reagent.burncolor
		overlays += fire_overlay_image
		fire_overlay = fire_overlay_image

/mob/living/simple_animal/Life(delta_time)
	if(affected_by_fire)
		handle_fire()
	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			GLOB.dead_mob_list -= src
			GLOB.alive_mob_list += src
			set_stat(CONSCIOUS)
//			lying = 0
//			density = TRUE
			reload_fullscreens()
		return 0


	if(health < 1)
		death()

	if(health > maxHealth)
		health = maxHealth

	//Movement
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting && !buckled && (mobility_flags & MOBILITY_MOVE)) //This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
					var/move_dir = pick(GLOB.cardinals)
					Move(get_step(src, move_dir ))
					setDir(move_dir)
					turns_since_move = 0

	//Speaking
	if(!client && speak_chance)
		if(rand(0,200) < speak_chance)
			if(LAZYLEN(speak))
				if(LAZYLEN(emote_hear) || LAZYLEN(emote_see))
					var/length = length(speak)
					if(LAZYLEN(emote_hear))
						length += length(emote_hear)
					if(LAZYLEN(emote_see))
						length += length(emote_see)
					var/randomValue = rand(1,length)
					if(randomValue <= length(speak))
						INVOKE_ASYNC(src, PROC_REF(say), pick(speak))
					else
						randomValue -= length(speak)
						if(emote_see && randomValue <= length(emote_see))
							INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_see),1)
						else
							INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_hear),2)
				else
					INVOKE_ASYNC(src, PROC_REF(say), pick(speak))
			else
				if(!LAZYLEN(emote_hear) && LAZYLEN(emote_see))
					INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_see),1)
				if(LAZYLEN(emote_hear) && !LAZYLEN(emote_see))
					INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_hear),2)
				if(LAZYLEN(emote_hear) && LAZYLEN(emote_see))
					var/length = length(emote_hear) + length(emote_see)
					var/pick = rand(1,length)
					if(pick <= length(emote_see))
						INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_see),1)
					else
						INVOKE_ASYNC(src, PROC_REF(manual_emote), pick(emote_hear),2)


	//Atmos
	var/atmos_suitable = 1

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/env_temp = T.return_temperature()
		var/env_gas = T.return_gas()

		if( abs(env_temp - bodytemperature) > 40 )
			bodytemperature += ((env_temp - bodytemperature) / 5)
			recalculate_move_delay = TRUE

		if(min_oxy)
			if(env_gas != GAS_TYPE_AIR && env_gas != GAS_TYPE_OXYGEN)
				atmos_suitable = 0
		if(max_oxy)
			if(env_gas == GAS_TYPE_OXYGEN)
				atmos_suitable = 0
		if(min_tox)
			if(env_gas != GAS_TYPE_PHORON)
				atmos_suitable = 0
		if(max_tox)
			if(env_gas == GAS_TYPE_PHORON)
				atmos_suitable = 0
		if(min_n2)
			if(env_gas != GAS_TYPE_NITROGEN)
				atmos_suitable = 0
		if(max_n2)
			if(env_gas == GAS_TYPE_NITROGEN)
				atmos_suitable = 0
		if(min_co2)
			if(env_gas != GAS_TYPE_CO2)
				atmos_suitable = 0
		if(max_co2)
			if(env_gas == GAS_TYPE_CO2)
				atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		apply_damage(cold_damage_per_tick, BRUTE)
	else if(bodytemperature > maxbodytemp)
		apply_damage(heat_damage_per_tick, BRUTE)

	if(!atmos_suitable)
		apply_damage(unsuitable_atoms_damage, BRUTE)
	return 1

/mob/living/simple_animal/Collided(atom/movable/AM)
	if(!AM)
		return

	if(resting || buckled)
		return

	if(isturf(src.loc))
		if(ismob(AM))
			var/newamloc = src.loc
			src.forceMove(AM:loc)
			AM:loc = newamloc
		else
			..()


/mob/living/simple_animal/death()
	. = ..()
	if(!.)
		return //was already dead
	SSmob.living_misc_mobs -= src
	icon_state = icon_dead
	black_market_value = dead_black_market_value
	set_body_position(LYING_DOWN)


/mob/living/simple_animal/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	SSmob.living_misc_mobs -= src
	if(meat_amount && meat_type)
		for(var/i = 0; i < meat_amount; i++)
			new meat_type(src.loc)
	..(cause)

/mob/living/simple_animal/gib_animation()
	if(icon_gib)
		new /obj/effect/overlay/temp/gib_animation/animal(loc, src, icon_gib)

/mob/living/simple_animal/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), SHOW_MESSAGE_VISIBLE)
		last_damage_data = create_cause_data(initial(M.name), M)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		apply_damage(damage, BRUTE)

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/attacking_mob)
	..()

	switch(attacking_mob.a_intent)
		if(INTENT_HELP)
			if (health > 0)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				visible_message(SPAN_NOTICE("[attacking_mob] [response_help] [src]."))
			return 1

		if(INTENT_GRAB)
			attacking_mob.start_pulling(src)
			return 1

		if(INTENT_DISARM)
			visible_message(SPAN_NOTICE("[attacking_mob] [response_disarm] [src]."))
			attacking_mob.animation_attack_on(src)
			attacking_mob.flick_attack_overlay(src, "disarm")
			return 1

		if(INTENT_HARM)
			var/datum/unarmed_attack/attack = attacking_mob.species.unarmed
			if(!attack.is_usable(attacking_mob))
				attack = attacking_mob.species.secondary_unarmed
				return 0

			attacking_mob.animation_attack_on(src)
			attacking_mob.flick_attack_overlay(src, "punch")

			var/extra_cqc_dmg = 0
			if(attacking_mob.skills)
				extra_cqc_dmg = attacking_mob.skills?.get_skill_level(SKILL_CQC)
			var/final_damage = 0

			playsound(loc, attack.attack_sound, 25, 1)
			visible_message(SPAN_DANGER("[attacking_mob] [response_harm] [src]!"), null, null, 5)

			final_damage = attack.damage + extra_cqc_dmg + harm_intent_damage
			apply_damage(final_damage, BRUTE, src, sharp = attack.sharp, edge = attack.edge)
			return 1

/mob/living/simple_animal/can_be_pulled_by(mob/pulling_mob)
	if(locate(/obj/item/explosive/plastic) in contents)
		to_chat(pulling_mob, SPAN_WARNING("You leave \the [src] alone. It's got live explosives on it!"))
		return FALSE
	return ..()

/mob/living/simple_animal/attackby(obj/item/O as obj, mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/stack/medical))

		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < maxHealth)
				if(MED.get_amount() >= 1)
					apply_damage(-MED.heal_brute, BRUTE)
					MED.use(1)
					for(var/mob/M as anything in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message(SPAN_NOTICE("[user] applies [MED] on [src]"), SHOW_MESSAGE_VISIBLE)
					return
		else
			to_chat(user, SPAN_NOTICE(" this [src] is dead, medical items won't bring it back to life."))
			return
	if(meat_type && (stat == DEAD)) //if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/tool/kitchen/knife) || istype(O, /obj/item/tool/kitchen/knife/butcher))
			new meat_type (get_turf(src))
			if(prob(95))
				qdel(src)
			else
				gib()
			return
	return ..()


/mob/living/simple_animal/movement_delay()
	. = ..()
	. += CONFIG_GET(number/animal_delay)

	move_delay = .


/mob/living/simple_animal/ex_act(severity, direction)

	if(severity >= 30)
		flash_eyes()

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gib()
		return

	apply_damage(severity, BRUTE)
	updatehealth()

	var/knock_value = min( round( severity*0.1 ,1) ,10)
	if(knock_value > 0)
		apply_effect(knock_value, WEAKEN)
		apply_effect(knock_value, PARALYZE)
		explosion_throw(severity, direction)

/mob/living/simple_animal/adjustBruteLoss(damage)
	health = clamp(health - damage, 0, maxHealth)

/mob/living/simple_animal/adjustFireLoss(damage)
	health = clamp(health - damage, 0, maxHealth)

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat)
			return (0)
	if (istype(target_mob,/obj/structure/machinery/bot))
		var/obj/structure/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return (1)

/mob/living/simple_animal/say(message)
	if(stat)
		return

	if(copytext(message,1,2) == "*")
		INVOKE_ASYNC(src, PROC_REF(emote), copytext(message,2))
		return

	if(stat)
		return

	var/verb = "says"

	if(length(speak_emote))
		verb = pick(speak_emote)

	message = capitalize(trim_left(message))

	..(message, null, verb, nolog = !ckey) //if the animal has a ckey then it will log the message

/mob/living/simple_animal/on_immobilized_trait_gain(datum/source)
	. = ..()
	stop_moving()

/mob/living/simple_animal/on_knockedout_trait_gain(datum/source)
	. = ..()
	stop_moving()

/mob/living/simple_animal/on_incapacitated_trait_gain(datum/source)
	. = ..()
	stop_moving()

/mob/living/simple_animal/proc/stop_moving()
	walk_to(src, 0) // stops us dead in our tracks

/mob/living/simple_animal/can_inject(mob/user, error_msg)
	if(user && error_msg)
		to_chat(user, SPAN_WARNING("You aren't sure how to inject this animal!"))
	return FALSE

#undef OVERLAY_FIRE_LAYER
