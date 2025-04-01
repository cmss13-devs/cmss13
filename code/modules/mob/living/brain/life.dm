/mob/living/brain/Life(delta_time)
	set invisibility = 0
	set background = 1
	..()

	if(stat != DEAD)
		//Chemicals in the body
		handle_chemicals_in_body(delta_time)

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = FALSE

	//Handle temperature/pressure differences between body and environment
	handle_environment()

	//Status updates, death etc.
	handle_regular_status_updates()

	if(client)
		handle_regular_hud_updates()

/mob/living/brain/proc/handle_environment()
	if(!loc)
		return

	var/env_temperature = loc.return_temperature()

	if((env_temperature > (T0C + 50)) || (env_temperature < (T0C + 10)))
		handle_temperature_damage(env_temperature)



/mob/living/brain/proc/handle_temperature_damage(exposed_temperature)
	if(status_flags & GODMODE)
		return

	if(exposed_temperature > bodytemperature)
		var/discomfort = min( abs(exposed_temperature - bodytemperature)/100, 1.0)
		apply_damage(20.0*discomfort, BURN)

	else
		var/discomfort = min( abs(exposed_temperature - bodytemperature)/100, 1.0)
		apply_damage(5.0*discomfort, BURN)



/mob/living/brain/proc/handle_chemicals_in_body(delta_time)

	reagent_move_delay_modifier = 0

	if(reagents)
		reagents.metabolize(src, delta_time=delta_time)

	confused = max(0, confused - 1)
	// decrement dizziness counter, clamped to 0
	if(resting)
		dizziness = max(0, dizziness - 5)
	else
		dizziness = max(0, dizziness - 1)

	updatehealth()

	return //TODO: DEFERRED


/mob/living/brain/handle_regular_status_updates(regular_update = TRUE) //TODO: comment out the unused bits >_>
	updatehealth()

	if(stat == DEAD) //DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = TRUE
		silent = 0
	else //ALIVE. LIGHTS ARE ON
		if( !container && (health < HEALTH_THRESHOLD_DEAD || ((world.time - timeofhostdeath) > CONFIG_GET(number/revival_brain_life))) )
			death(last_damage_data)
			blinded = TRUE
			silent = 0
			return 1

		//Handling EMP effect in the Life(), it's made VERY simply, and has some additional effects handled elsewhere
		if(emp_damage && regular_update) //This is pretty much a damage type only used by MMIs, dished out by the emp_act
			if(!(container && istype(container, /obj/item/device/mmi)))
				emp_damage = 0
			else
				emp_damage = round(emp_damage,1)//Let's have some nice numbers to work with
			switch(emp_damage)
				if(31 to INFINITY)
					emp_damage = 30//Let's not overdo it
				if(21 to 30)//High level of EMP damage, unable to see, hear, or speak
					SetEyeBlind(1)
					blinded = TRUE
					SetEarDeafness(1)
					silent = 1
					if(!alert)//Sounds an alarm, but only once per 'level'
						INVOKE_ASYNC(src, PROC_REF(emote), "alarm")
						to_chat(src, SPAN_DANGER("Major electrical distruption detected: System rebooting."))
						alert = 1
					if(prob(75))
						emp_damage--
				if(20)
					alert = 0
					blinded = FALSE
					SetEyeBlind(0)
					SetEarDeafness(0)
					silent = 0
					emp_damage--
				if(11 to 19)//Moderate level of EMP damage, resulting in nearsightedness and ear damage
					AdjustEyeBlur(1)
					ear_damage = 1
					if(!alert)
						INVOKE_ASYNC(src, PROC_REF(emote), "alert")
						to_chat(src, SPAN_DANGER("Primary systems are now online."))
						alert = 1
					if(prob(50))
						emp_damage--
				if(10)
					alert = 0
					SetEyeBlur(0)
					ear_damage = 0
					emp_damage--
				if(2 to 9)//Low level of EMP damage, has few effects(handled elsewhere)
					if(!alert)
						INVOKE_ASYNC(src, PROC_REF(emote), "notice")
						to_chat(src, SPAN_DANGER("System reboot nearly complete."))
						alert = 1
					if(prob(25))
						emp_damage--
				if(1)
					alert = 0
					to_chat(src, SPAN_DANGER("All systems restored."))
					emp_damage--

		//Other
		if(regular_update)
			handle_statuses()
	return 1


/mob/living/brain/proc/handle_regular_hud_updates()
	if (hud_used && hud_used.healths)
		if (stat != DEAD)
			switch(health)
				if(100 to INFINITY)
					hud_used.healths.icon_state = "health0"
				if(80 to 100)
					hud_used.healths.icon_state = "health1"
				if(60 to 80)
					hud_used.healths.icon_state = "health2"
				if(40 to 60)
					hud_used.healths.icon_state = "health3"
				if(20 to 40)
					hud_used.healths.icon_state = "health4"
				if(0 to 20)
					hud_used.healths.icon_state = "health5"
				else
					hud_used.healths.icon_state = "health6"
		else
			hud_used.healths.icon_state = "health7"


	if(stat != DEAD) //the dead get zero fullscreens
		if(blinded)
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")

			if(eye_blurry)
				overlay_fullscreen("eye_blurry", /atom/movable/screen/fullscreen/impaired, 5)
			else
				clear_fullscreen("eye_blurry")

			if(druggy)
				overlay_fullscreen("high", /atom/movable/screen/fullscreen/high)
			else
				clear_fullscreen("high")


		if (interactee)
			interactee.check_eye(src)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1
