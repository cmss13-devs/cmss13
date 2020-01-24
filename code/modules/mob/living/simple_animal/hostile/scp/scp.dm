//SCP-related stuff
/mob/living/simple_animal/scp
	response_help  = "touches the"
	response_disarm = "pushes the"
	response_harm   = "hits the"
	flags_pass = PASS_FLAGS_CRAWLER
	var/hibernate = 0 //Disables SCP until toggled back to 0
	var/scare_played = 0 //Did we rape everyone's ears yet ?
	var/obj/structure/pipes/vents/pump/entry_vent //Graciously stolen from spider code
	var/scare_sound = list('sound/scp/scare1.ogg','sound/scp/scare2.ogg','sound/scp/scare3.ogg','sound/scp/scare4.ogg')	//Boo
	var/list/blink_list = list() //List of living things that blinked in our last check cycle

	var/hardcore = TRUE //If TRUE, the SCP will be harder to contain


//Function to call for each mob that is observing us
//Return FALSE if the target won't observe us, like through blinking or something
/mob/living/simple_animal/scp/proc/on_observed(var/mob/living/carbon/H)
	return TRUE

//Function to call for each mob that has eye contact with us (we are looking at it, it is looking at us)
/mob/living/simple_animal/scp/proc/on_eye_contact(var/mob/living/carbon/H)
	return TRUE

/mob/living/simple_animal/scp/proc/did_observer_blink(var/mob/living/carbon/H)
	if(hardcore && prob(20))
		H.custom_emote(1, "blinks", TRUE)
		blink_list += H
		return TRUE
	return FALSE

//Check if any carbon mob can see us
//Note that humans have a 180 degrees field of vision for the purposes of this proc
/mob/living/simple_animal/scp/proc/check_los(var/check_blink = FALSE)
	var/are_we_observed = FALSE
	if(check_blink) //Reset blink list. The new list will persist until next life cycle
		blink_list.Cut()
	for(var/mob/living/carbon/H in viewers(src, null))
		if(H.stat || H.blinded)
			continue
		if(H in blink_list)
			continue //target is in the middle of blinking, they don't see us!

		if(check_blink) //Only check this once per life cycle
			if(did_observer_blink(H))
				continue //They blinked, they are not watching us

		var/observed = FALSE
		var/eye_contact = FALSE

		var/x_diff = H.x - src.x
		var/y_diff = H.y - src.y
		if(y_diff != 0) //If we are not on the same vertical plane (up/down), mob is either above or below src
			if(y_diff < 0 && H.dir == NORTH) //Mob is below src and looking up
				observed = TRUE
				if(dir == SOUTH) //src is looking down
					eye_contact = TRUE
			else if(y_diff > 0 && H.dir == SOUTH) //Mob is above src and looking down
				observed = TRUE
				if(dir == NORTH) //src is looking up
					eye_contact = TRUE
		if(x_diff != 0) //If we are not on the same horizontal plane (left/right), mob is either left or right of src
			if(x_diff < 0 && H.dir == EAST) //Mob is left of src and looking right
				observed = TRUE
				if(dir == WEST) //src is looking left
					eye_contact = TRUE
			else if(x_diff > 0 && H.dir == WEST) //Mob is right of src and looking left
				observed = TRUE
				if(dir == EAST) //src is looking right
					eye_contact = TRUE

		are_we_observed |= observed
		if(observed)
			on_observed(H)
		if(eye_contact)
			on_eye_contact(H)

	return are_we_observed

/mob/living/simple_animal/scp/proc/handle_target(var/mob/living/carbon/target, var/forced = FALSE)

//When players are trying to be too clever, we lash out at them
/mob/living/simple_animal/scp/proc/lash_out()
	var/mob/target = null
	if(pulledby)
		//lash out at the person pulling us, they are probably the ones to blame!
		target = pulledby
	else
		//lash out at the closest victim, because why not
		for(var/mob/living/carbon/H in viewers(src, null))
			if(H.stat != DEAD)
				target = H
				break

	if(target)
		//lash out at the source of our ire!
		handle_target(target, TRUE)

/mob/living/simple_animal/scp/gib()
	//Can't gib SCPs!
	lash_out()

/mob/living/simple_animal/scp/proc/contain()
	//SCP has been contained!
	visible_message(SPAN_DANGER("[name] has been contained!"))
	log_admin("[name] has been contained!.")
	message_admins("ALERT: <A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>[name] has been contained!.")
	qdel(src)