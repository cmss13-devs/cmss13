/mob/living/silicon/robot/Life(delta_time)
	set invisibility = 0
	set background = 1

	if (src.monkeyizing)
		return

	src.blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()

	if(client)
		handle_regular_hud_updates()
		update_items()
	if (src.stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
	update_canmove()

/mob/living/silicon/robot/proc/clamp_values()

//	SetStunned(min(stunned, 30))
	SetKnockedout(min(knocked_out, 30))
//	SetKnockeddown(min(knocked_down, 20))
	sleeping = 0
	apply_damage(0, BRUTE)
	apply_damage(0, TOX)
	apply_damage(0, OXY)
	apply_damage(0, BURN)

/mob/living/silicon/robot/proc/use_power()
	// Debug only
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && src.cell.charge > 0 )
		if(src.module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(src.module_state_2)
			cell_use_power(50)
		if(src.module_state_3)
			cell_use_power(50)

		if(lights_on)
			cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.

		src.has_power = 1
	else
		if (src.has_power)
			to_chat(src, SPAN_DANGER("You are now running on emergency backup power."))
		src.has_power = 0
		if(lights_on) // Light is on but there is no power!
			lights_on = 0
			SetLuminosity(0)

/mob/living/silicon/robot/handle_regular_status_updates(regular_update = TRUE)

	if(src.camera && !scrambledcodes)
		if(src.stat == 2 || isWireCut(5))
			src.camera.status = 0
		else
			src.camera.status = 1

	updatehealth()

	if(regular_update && src.sleeping)
		KnockOut(3)
		src.sleeping--

	if(regular_update && src.resting)
		KnockDown(5)

	if(health < HEALTH_THRESHOLD_DEAD && stat != DEAD) //die only once
		death()

	if (stat != DEAD) //Alive.
		if (knocked_out || stunned || knocked_down || !has_power) //Stunned etc.
			stat = UNCONSCIOUS
			if(regular_update)
				if (src.stunned > 0)
					AdjustStunned(-1)
				if (src.knocked_down > 0)
					AdjustKnockeddown(-1)
				if (src.knocked_out > 0)
					AdjustKnockedout(-1)
					src.blinded = 1
				else
					src.blinded = 0

		else	//Not stunned.
			src.stat = 0

	else //Dead.
		src.blinded = 1
		src.stat = 2

	if(!regular_update)
		return

	if (src.stuttering) src.stuttering--

	if (src.eye_blind)
		src.eye_blind--
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf--
	if (src.ear_damage < 25)
		src.ear_damage -= 0.05
		src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )

	if ((src.sdisabilities & DISABILITY_BLIND))
		src.blinded = 1
	if ((src.sdisabilities & DISABILITY_DEAF))
		SetEarDeafness(1)

	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)

	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)

	//update the state of modules and components here
	if (src.stat != 0)
		uneq_all()

	if(!is_component_functioning("radio"))
		radio.on = 0
	else
		radio.on = 1

	if(is_component_functioning("camera"))
		src.blinded = 0
	else
		src.blinded = 1

	return 1

/mob/living/silicon/robot/proc/handle_regular_hud_updates()

	if (hud_used && hud_used.healths)
		if (src.stat != DEAD)
			if(ismaintdrone(src))
				switch(round(health * 100 / maxHealth))
					if(100 to INFINITY)
						hud_used.healths.icon_state = "health0"
					if(75 to 99)
						hud_used.healths.icon_state = "health1"
					if(50 to 74)
						hud_used.healths.icon_state = "health2"
					if(25 to 49)
						hud_used.healths.icon_state = "health3"
					if(10 to 24)
						hud_used.healths.icon_state = "health4"
					if(0 to 9)
						hud_used.healths.icon_state = "health5"
					else
						hud_used.healths.icon_state = "health6"
			else
				switch(round(health * 100 / maxHealth))
					if(100 to INFINITY)
						hud_used.healths.icon_state = "health0"
					if(75 to 99)
						hud_used.healths.icon_state = "health1"
					if(50 to 74)
						hud_used.healths.icon_state = "health2"
					if(25 to 49)
						hud_used.healths.icon_state = "health3"
					if(10 to 24)
						hud_used.healths.icon_state = "health4"
					if(0 to 9)
						hud_used.healths.icon_state = "health5"
					else
						hud_used.healths.icon_state = "health6"
		else
			hud_used.healths.icon_state = "health7"

	if (src.cells)
		if (src.cell)
			var/cellcharge = src.cell.charge/src.cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					src.cells.icon_state = "charge4"
				if(0.5 to 0.75)
					src.cells.icon_state = "charge3"
				if(0.25 to 0.5)
					src.cells.icon_state = "charge2"
				if(0 to 0.25)
					src.cells.icon_state = "charge1"
				else
					src.cells.icon_state = "charge0"
		else
			src.cells.icon_state = "charge-empty"

	if(hud_used && hud_used.bodytemp_icon)
		switch(src.bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				hud_used.bodytemp_icon.icon_state = "temp2"
			if(320 to 335)
				hud_used.bodytemp_icon.icon_state = "temp1"
			if(300 to 320)
				hud_used.bodytemp_icon.icon_state = "temp0"
			if(260 to 300)
				hud_used.bodytemp_icon.icon_state = "temp-1"
			else
				hud_used.bodytemp_icon.icon_state = "temp-2"


//Oxygen and fire does nothing yet!!
//	if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
//	if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"

	if(stat != DEAD) //the dead get zero fullscreens
		if(blinded)
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")

		if (eye_blurry)
			overlay_fullscreen("eye_blurry", /atom/movable/screen/fullscreen/impaired, 5)
		else
			clear_fullscreen("eye_blurry")

		if(druggy)
			overlay_fullscreen("high", /atom/movable/screen/fullscreen/high)
		else
			clear_fullscreen("high")


		if(interactee)
			interactee.check_eye(src)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1

/mob/living/silicon/robot/proc/update_items()
	if (client)
		client.screen -= contents
		for(var/obj/I in contents)
			if(I && !(istype(I,/obj/item/cell) || istype(I,/obj/item/device/radio)  || istype(I,/obj/structure/machinery/camera) || istype(I,/obj/item/device/mmi)))
				client.screen += I
	var/datum/custom_hud/robot/ui_datum = GLOB.custom_huds_list[HUD_ROBOT]
	if(module_state_1)
		module_state_1.screen_loc = ui_datum.ui_inv1
	if(module_state_2)
		module_state_2.screen_loc = ui_datum.ui_inv2
	if(module_state_3)
		module_state_3.screen_loc = ui_datum.ui_inv3
	update_icons()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(src.client)
				to_chat(src, SPAN_DANGER("<B>Killswitch Activated"))
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client)
				to_chat(src, SPAN_DANGER("<B>Weapon Lock Timed Out!"))
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/robot/update_canmove()
	if(knocked_out || stunned || knocked_down || buckled || lockcharge || !is_component_functioning("actuator")) canmove = 0
	else canmove = 1
	return canmove
