/mob/living/carbon/hellhound/Life(delta_time)
	set invisibility = 0
	set background = 1

	..()

	if (stat != DEAD)

		//Chemicals in the body
		handle_chemicals_in_body(delta_time)

	blinded = null

	//Check if we're on fire
	handle_fire()

	//Status updates, death etc.
	handle_regular_status_updates()
	update_canmove()

	if(client)
		handle_regular_hud_updates()

	// Grabbing
	for(var/obj/item/grab/G in src)
		G.process()

	updatehealth()
	update_icons()

/mob/living/carbon/hellhound/proc/handle_chemicals_in_body(delta_time)

	reagent_move_delay_modifier = 0

	recalculate_move_delay = TRUE

	if(reagents && reagents.reagent_list.len)
		reagents.metabolize(src, delta_time=delta_time)

	if(confused)
		confused = 0

	if(resting)
		dizziness = 0
	else
		dizziness = max(0, dizziness - 1)



/mob/living/carbon/hellhound/handle_regular_status_updates(regular_update = TRUE)
	if(stat == DEAD)	//DEAD
		blinded = 1
		silent = 0
		return

	updatehealth()
	if(health < -100 || !has_brain())
		death(last_damage_data)
		blinded = 1
		stat = DEAD
		silent = 0
		return 1

	//They heal quickly.
	see_in_dark = 8
	if(regular_update)
		apply_damage(-5, BRUTE)
		apply_damage(-5, BURN)
		apply_damage(-10, OXY)
		apply_damage(-50, TOX)
		if(knocked_down) knocked_down -= 2
		if(knocked_down < 0) knocked_down = 0 //Just to be sure.
		if(stunned) stunned = 0
		if(dazed) dazed = 0

		//UNCONSCIOUS. NO-ONE IS HOME
		if(health < 0)
			if(health <= 10 && prob(1))
				INVOKE_ASYNC(src, /mob.proc/emote, "gasp")
			if(!reagents.has_reagent("inaprovaline"))
				apply_damage(11, OXY)
			KnockOut(3)

	if(knocked_out)
		AdjustKnockedout(-1)
		blinded = 1
		stat = UNCONSCIOUS
	else if(sleeping)
		if(regular_update)
			sleeping = max(sleeping-1, 0)
		blinded = 1
		stat = UNCONSCIOUS
		if(regular_update && prob(10) && health && !hal_crit)
			INVOKE_ASYNC(src, /mob.proc/emote, "snore")
	else
		stat = CONSCIOUS

/mob/living/carbon/hellhound/proc/handle_regular_hud_updates()
	if (hud_used && hud_used.healths)
		if (stat != 2)
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

	return 1
