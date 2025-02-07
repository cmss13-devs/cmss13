
//if null is passed for def_zone, then this should return something appropriate for all zones (e.g. area effect damage)
/mob/living/proc/getarmor(def_zone, type)
	return 0

//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(stun_amount, agony_amount, def_zone, used_weapon=null)
	flash_pain()

	if (stun_amount)
		apply_effect(stun_amount, STUN)
		apply_effect(stun_amount, WEAKEN)
		apply_effect(STUTTER, stun_amount)
		apply_effect(EYE_BLUR, stun_amount)

	if (agony_amount)
		apply_damage(agony_amount, HALLOSS, def_zone, used_weapon)
		apply_effect(STUTTER, agony_amount/10)
		apply_effect(EYE_BLUR, agony_amount/10)

/mob/living/proc/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0)
	return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	. = ..()
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)

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
	var/launch_meta_valid = istype(LM)

	var/dist = 2
	if(launch_meta_valid)
		dist = LM.dist
	var/miss_chance = min(15*(dist - 2), 0)

	if (prob(miss_chance))
		visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"), null, null, 5)
		return

	src.visible_message(SPAN_DANGER("[src] has been hit by [O]."), null, null, 5)
	var/damage_done = apply_armoured_damage(impact_damage, ARMOR_MELEE, dtype, null, , is_sharp(O), has_edge(O), null)

	var/last_damage_source
	if (damage_done > 5)
		last_damage_source = initial(O.name)
		animation_flash_color(src)
		var/obj/item/I = O
		if(istype(I) && I.sharp) //Hilarious is_sharp only returns true if it's sharp AND edged, while a bunch of things don't have edge to limit embeds.
			playsound(loc, 'sound/effects/spike_hit.ogg', 20, TRUE, falloff = 2)
		else
			playsound(loc, 'sound/effects/thud.ogg', 25, TRUE, falloff = 2)

	O.throwing = 0 //it hit, so stop moving

	var/mob/M
	if(launch_meta_valid && ismob(LM.thrower))
		M = LM.thrower
		if(damage_done > 5)
			M.track_hit(initial(O.name))
			if (M.faction == faction)
				M.track_friendly_fire(initial(O.name))
		var/client/assailant = M.client
		if(assailant)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with \a [O], thrown by [key_name(M)]</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [key_name(src)] with a thrown [O]</font>")
			if(!istype(src,/mob/living/simple_animal/mouse))
				if(src.loc)
					msg_admin_attack("[key_name(src)] was hit by \a [O], thrown by [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
				else
					msg_admin_attack("[key_name(src)] was hit by \a [O], thrown by [key_name(M)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z]).", M.loc.x, M.loc.y, M.loc.z)
	if(last_damage_source)
		last_damage_data = create_cause_data(last_damage_source, M)

/mob/living/mob_launch_collision(mob/living/L)
	if(!L.anchored)
		L.Move(get_step_away(L, src))

/mob/living/obj_launch_collision(obj/O)
	var/datum/launch_metadata/LM = launch_metadata
	var/launch_meta_valid = istype(LM)
	if(!rebounding && (!launch_meta_valid || LM.thrower != src))
		var/impact_damage = (1 + MOB_SIZE_COEFF/(mob_size + 1))*THROW_SPEED_DENSE_COEFF*cur_speed
		apply_damage(impact_damage)
		visible_message(SPAN_DANGER("\The [name] slams into [O]!"), null, null, 5) //feedback to know that you got slammed into a wall and it hurt
		playsound(O,"slam", 50, 1)
	..()

//This is called when the mob or human is thrown into a dense turf or wall
/mob/living/turf_launch_collision(turf/T)
	var/datum/launch_metadata/LM = launch_metadata
	var/launch_meta_valid = istype(LM)
	if(!rebounding && (!launch_meta_valid || LM.thrower != src))
		if(LM.thrower)
			last_damage_data = create_cause_data("wall tossing", LM.thrower)
		var/impact_damage = (1 + MOB_SIZE_COEFF/(mob_size + 1))*THROW_SPEED_DENSE_COEFF*cur_speed
		apply_damage(impact_damage)
		visible_message(SPAN_DANGER("\The [name] slams into [T]!"), null, null, 5) //feedback to know that you got slammed into a wall and it hurt
		playsound(T,"slam", 50, 1)
	..()

/mob/living/proc/near_wall(direction, distance=1)
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
		return IGNITE_FAILED
	if(fire_stacks > 0)
		if(on_fire)
			return IGNITE_ON_FIRE
		on_fire = TRUE
		to_chat(src, SPAN_DANGER("You are on fire! Use Resist to put yourself out!"))
		update_fire()
		SEND_SIGNAL(src, COMSIG_LIVING_IGNITION)
		return IGNITE_IGNITED
	return IGNITE_FAILED

/mob/living/carbon/human/IgniteMob()
	. = ..()
	if((. & IGNITE_IGNITED) && !stat && pain.feels_pain)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "scream")

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = FALSE
		fire_stacks = 0
		update_fire()
		return TRUE
	return FALSE

/mob/living/carbon/human/ExtinguishMob()
	. = ..()
	SEND_SIGNAL(src, COMSIG_HUMAN_EXTINGUISH)

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks, datum/reagent/R, min_stacks = MIN_FIRE_STACKS) //Adjusting the amount of fire_stacks we have on person
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
	switch(fire_reagent.fire_type)
		if(FIRE_VARIANT_TYPE_B)
			max_stacks = 10 //Armor Shredding Greenfire caps at 1 resist/pat
	fire_stacks = clamp(fire_stacks + add_fire_stacks, min_stacks, max_stacks)

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
	if(current_weather_effect_type && SSweather && SSweather.weather_event_instance)
		adjust_fire_stacks(-SSweather.weather_event_instance.fire_smothering_strength, min_stacks = 0)

/mob/living/fire_act()
	TryIgniteMob(2)

/mob/living/proc/TryIgniteMob(fire_stacks, datum/reagent/R)
	adjust_fire_stacks(fire_stacks, R)
	if (!IgniteMob())
		adjust_fire_stacks(-fire_stacks)
		return FALSE
	return TRUE

//Mobs on Fire end

/mob/living/proc/handle_weather(delta_time = 1)
	var/starting_weather_type = current_weather_effect_type
	var/area/area = get_area(src)
	// Check if we're supposed to be something affected by weather
	if(!SSweather.weather_event_instance || !SSweather.map_holder.should_affect_area(area) || !area.weather_enabled)
		current_weather_effect_type = null
	else
		current_weather_effect_type = SSweather.weather_event_type
		SSweather.weather_event_instance.process_mob_effect(src, delta_time)

	if(current_weather_effect_type != starting_weather_type)
		if(current_weather_effect_type)
			overlay_fullscreen("weather", SSweather.weather_event_instance.fullscreen_type)
		else
			clear_fullscreen("weather")

/mob/living/handle_flamer_fire(obj/flamer_fire/fire, damage, delta_time)
	. = ..()
	fire.set_on_fire(src)

/mob/living/handle_flamer_fire_crossed(obj/flamer_fire/fire)
	. = ..()
	fire.set_on_fire(src)
