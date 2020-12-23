
//if null is passed for def_zone, then this should return something appropriate for all zones (e.g. area effect damage)
/mob/living/proc/getarmor(var/def_zone, var/type)
	return 0

//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	flash_pain()

	if (stun_amount)
		Stun(stun_amount)
		KnockDown(stun_amount)
		apply_effect(STUTTER, stun_amount)
		apply_effect(EYE_BLUR, stun_amount)

	if (agony_amount)
		apply_damage(agony_amount, HALLOSS, def_zone, used_weapon)
		apply_effect(STUTTER, agony_amount/10)
		apply_effect(EYE_BLUR, agony_amount/10)

/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM)
	if(!isobj(AM))
		return

	var/obj/O = AM
	var/dtype = BRUTE
	if(istype(O, /obj/item/weapon))
		var/obj/item/weapon/W = O
		dtype = W.damtype
	var/impact_damage = (1 + O.throwforce*THROWFORCE_COEFF)*O.throwforce*THROW_SPEED_IMPACT_COEFF*O.cur_speed

	var/datum/launch_metadata/LM = O.launch_metadata
	var/dist = 2
	if(istype(LM))
		dist = LM.dist
	var/miss_chance = min(15*(dist - 2), 0)

	if (prob(miss_chance))
		visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"), null, null, 5)
		return

	src.visible_message(SPAN_DANGER("[src] has been hit by [O]."), null, null, 5)
	apply_armoured_damage(impact_damage, ARMOR_MELEE, dtype, null, , is_sharp(O), has_edge(O), null)

	O.throwing = 0		//it hit, so stop moving

	if(ismob(LM.thrower))
		var/mob/M = LM.thrower
		var/client/assailant = M.client
		if(assailant)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [key_name(M)]</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [key_name(src)] with a thrown [O]</font>")
			if(!istype(src,/mob/living/simple_animal/mouse))
				msg_admin_attack("[key_name(src)] was hit by a [O], thrown by [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

/mob/living/mob_launch_collision(var/mob/living/L)
	L.Move(get_step_away(L, src))

/mob/living/obj_launch_collision(var/obj/O)
	if ((!thrower || thrower != src) && \
		!rebounding
	)
		var/impact_damage = (1 + MOB_SIZE_COEFF/(mob_size + 1))*THROW_SPEED_DENSE_COEFF*cur_speed
		apply_damage(impact_damage)
		visible_message(SPAN_DANGER("\The [name] slams into [O]!"), null, null, 5) //feedback to know that you got slammed into a wall and it hurt
		var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
		playsound(O,S, 50, 1)
	..()

//This is called when the mob or human is thrown into a dense turf or wall
/mob/living/turf_launch_collision(var/turf/T)
	if (!rebounding)
		var/impact_damage = (1 + MOB_SIZE_COEFF/(mob_size + 1))*THROW_SPEED_DENSE_COEFF*cur_speed
		apply_damage(impact_damage)
		visible_message(SPAN_DANGER("\The [name] slams into [T]!"), null, null, 5) //feedback to know that you got slammed into a wall and it hurt
		var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
		playsound(T,S, 50, 1)
	..()

/mob/living/proc/near_wall(var/direction,var/distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i>0 && i<=distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return 0

// End BS12 momentum-transfer code.


//Mobs on Fire
/mob/living/proc/IgniteMob(force)
	if(!force && SEND_SIGNAL(src, COMSIG_LIVING_PREIGNITION) & COMPONENT_CANCEL_IGNITION)
		return FALSE
	if(fire_stacks > 0)
		if(on_fire)
			return TRUE
		on_fire = TRUE
		to_chat(src, SPAN_DANGER("You are on fire! Use Resist to put yourself out!"))
		update_fire()
		return TRUE
	return FALSE

/mob/living/carbon/human/IgniteMob()
	. = ..()
	if(.)
		if(!stat && pain.feels_pain)
			emote("scream")

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks, var/datum/reagent/R, var/min_stacks = MIN_FIRE_STACKS) //Adjusting the amount of fire_stacks we have on person
	if(R)
		if( \
			!on_fire || !fire_reagent || \
			R.durationfire > fire_stacks || \
			fire_reagent.intensityfire < R.intensityfire || \
			(!fire_reagent.fire_penetrating && R.fire_penetrating) \
		)
			fire_reagent = R
	else if(!fire_reagent)
		fire_reagent = new /datum/reagent/napalm/ut()

	var/max_stacks = min(fire_reagent.durationfire, MAX_FIRE_STACKS) // Fire stacks should not exceed MAX_FIRE_STACKS for reasonable resist amounts
	fire_stacks = Clamp(fire_stacks + add_fire_stacks, min_stacks, max_stacks)

	if(on_fire && fire_stacks <= 0)
		ExtinguishMob()

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks++ //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_stacks = min(0, fire_stacks)//So we dry ourselves back to default, nonflammable.
	if(!on_fire)
		return TRUE
	if(fire_stacks > 0)
		adjust_fire_stacks(-0.5, min_stacks = 0) //the fire is consumed slowly

/mob/living/fire_act()
	TryIgniteMob(2)

/mob/living/proc/TryIgniteMob(fire_stacks, datum/reagent/R)
	adjust_fire_stacks(fire_stacks, R)
	if (!IgniteMob())
		adjust_fire_stacks(-fire_stacks)
		return FALSE
	return TRUE

//Mobs on Fire end

/mob/living/proc/update_weather()
	// Only player mobs are affected by weather.
	if(!src.client)
		return

	if(!SSweather)
		return

	// Do this always
	clear_fullscreen("weather")
	remove_weather_effects()

	// Check if we're supposed to be something affected by weather
	if(SSweather.is_weather_event && SSweather.weather_event_instance && SSweather.weather_affects_check(src))
		// Ok, we're affected by weather.

		// Fullscreens
		if(SSweather.weather_event_instance.fullscreen_type)
			overlay_fullscreen("weather", SSweather.weather_event_instance.fullscreen_type)
		else
			clear_fullscreen("weather")

		// Effects
		if(SSweather.weather_event_instance.effect_type)
			new SSweather.weather_event_instance.effect_type(src)
