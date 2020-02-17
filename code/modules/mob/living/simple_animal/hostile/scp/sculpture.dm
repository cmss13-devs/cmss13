//SCP-173, nothing more need be said
/mob/living/simple_animal/scp/sculpture
	name = "\improper sculpture"
	desc = "It's some kind of hastily-painted human-size stone sculpture. Just looking at it makes you feel nervous."
	layer = BELOW_MOB_LAYER
	icon_state = "sculpture"
	icon_living = "sculpture"
	icon_dead = "sculpture"
	emote_hear = list("makes a faint scraping sound")
	emote_see = list("twitches slightly", "shivers")
	see_in_dark = 8 //Needs to see in darkness to snap in darkness
	var/response_snap = "snapped the neck of" //Past tense because it "happened before you could see it"
	var/response_snap_target = "In the blink of an eye, something grabs you and snaps your neck!"
	var/snap_sound = list('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg','sound/scp/firstpersonsnap3.ogg')

/mob/living/simple_animal/scp/sculpture/Life()
	//If we are hibernating, just don't do anything
	if(hibernate)
		return

	if(check_los(TRUE))
		snuff_out_light() //When we are observed, we try to break lights to disable line of sight
		return

	//See if we're able to strangle anyone
	for(var/mob/living/carbon/M in get_turf(src))
		if(M.stat == CONSCIOUS && !check_los())
			snap_neck(M)
			break

	//Find out what mobs we can see for targetting purposes
	var/list/conscious = list()
	for(var/mob/living/carbon/H in view(7, src))
		if(H.stat == CONSCIOUS) //He's up and running
			conscious.Add(H)

	//Pick the nearest valid conscious target
	var/mob/living/carbon/target
	for(var/mob/living/carbon/H in conscious)
		if(!target || get_dist(src, H) < get_dist(src, target))
			target = H

	if(target)
		handle_target(target)
	else
		handle_idle()

/mob/living/simple_animal/scp/sculpture/handle_target(var/mob/living/carbon/target, var/forced = FALSE)
	if(!target) //Sanity
		return

	if(!forced && check_los())
		return

	var/turf/target_turf

	//Send the warning that SPC is homing in
	target_turf = get_turf(target)
	if(!scare_played) //Let's minimize the spam
		playsound(get_turf(src), pick(scare_sound), 50, 1)
		scare_played = 1
		spawn(50)
			scare_played = 0

	//Rampage along a path to get to them, in the blink of an eye
	var/turf/next_turf = get_step_towards(src, target)
	var/num_turfs = get_dist(src,target)
	var/move_dir = 0
	spawn()
		while(get_turf(src) != target_turf && num_turfs > 0)
			move_dir = get_dir(src, next_turf)
			if(!forced && check_los()) //Something is looking at us now
				break
			if(next_turf.BlockedPassDirs(src, move_dir)) //We can't pass through our planned path
				break
			for(var/obj/structure/window/W in next_turf)
				W.health -= 1000
				W.healthcheck(1, 1, 1, src)
				sleep(5)
			for(var/obj/structure/table/O in next_turf)
				O.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
				sleep(5)
			for(var/obj/structure/closet/C in next_turf)
				C.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
				sleep(5)
			for(var/obj/structure/grille/G in next_turf)
				G.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
				sleep(5)
			for(var/obj/structure/machinery/door/airlock/A in next_turf)
				if(A.welded || A.locked) //Snowflakey code to take in account bolts and welding
					break
				A.open()
				sleep(5)
			for(var/obj/structure/machinery/door/D in next_turf)
				D.open()
				sleep(5)
			if(next_turf.BlockedPassDirs(src, move_dir)) //Once we cleared everything we could, check one last time if we can pass
				break
			forceMove(next_turf, FALSE, forced)
			dir = get_dir(src, target)
			next_turf = get_step(src, get_dir(next_turf,target))
			num_turfs--

/mob/living/simple_animal/scp/sculpture/proc/handle_idle()
	if(check_los())
		return

	//If we're not strangling anyone, take a stroll
	if(prob(25)) //1 in 4 chance of checking out something new
		var/list/turfs = new/list()
		for(var/turf/T in view(7, src))
			if(!istype(T, /turf/open/floor))
				continue
			turfs += T
		var/turf/target_turf = safepick(turfs)
		if(!target_turf)
			return
		//Move to our new resting point with celerity
		var/turf/next_turf = get_step_towards(src, target_turf)
		var/num_turfs = get_dist(src, target_turf)
		var/move_dir = 0
		spawn()
			while(get_turf(src) != target_turf && num_turfs > 0)
				move_dir = get_dir(src, next_turf)
				if(check_los()) //Something is looking at us now
					break
				if(next_turf.BlockedPassDirs(src, move_dir)) //We can't pass through our planned path
					break
				for(var/obj/structure/window/W in next_turf)
					W.health -= 1000
					W.healthcheck(1, 1, 1, src)
					sleep(5)
				for(var/obj/structure/table/O in next_turf)
					O.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
					sleep(5)
				for(var/obj/structure/closet/C in next_turf)
					C.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
					sleep(5)
				for(var/obj/structure/grille/G in next_turf)
					G.ex_act(EXPLOSION_THRESHOLD_MEDIUM)
					sleep(5)
				for(var/obj/structure/machinery/door/airlock/A in next_turf)
					if(A.welded || A.locked) //Snowflakey code to take in account bolts and welding
						break
					A.open()
					sleep(5)
				for(var/obj/structure/machinery/door/D in next_turf)
					D.open()
					sleep(5)
				if(next_turf.BlockedPassDirs(src, move_dir)) //Once we cleared everything we could, check one last time if we can pass
					break
				forceMove(next_turf)
				dir = get_dir(src, target_turf)
				next_turf = get_step(src, get_dir(next_turf,target_turf))
				num_turfs--
		//Coding note : This is known to allow SCP to end up on tiles that contain obstructing structures (doors, machinery, etc)
		//Although he CAN'T pass through them during normal movement. Will look into a fix soon
	..()

//This performs an immediate neck snap check, meant to avoid people cheesing SCP-173 by just running faster than Life() refresh
/mob/living/simple_animal/scp/sculpture/proc/check_snap_neck(var/forced = FALSE)
	//See if we're able to strangle anyone
	for(var/mob/living/carbon/M in get_turf(src))
		if(M.stat == CONSCIOUS && (forced || !check_los()))
			snap_neck(M, forced)
			break

/mob/living/simple_animal/scp/sculpture/forceMove(atom/destination, var/no_tp = 0, var/forced = FALSE)
	..()
	check_snap_neck(forced)

	//Spawn some blood when we move
	if(prob(50))
		if(prob(50))
			new /obj/effect/decal/cleanable/blood(destination)
		else
			new /obj/effect/decal/cleanable/blood/splatter(destination)


/mob/living/simple_animal/scp/sculpture/proc/snap_neck(var/mob/living/target, var/forced = FALSE)
	if(!forced && check_los())
		return

	if(target)
		//To prevent movement cheese, SCP snaps necks the second it ends up on the same turf as someone
		//Or in other terms, if SCP decides it had a clean shot for a neck snap at the moment this proc fired, you're good as dead
		target.apply_damage(50, BRUTE, "head")
		target.apply_damage(160, OXY)
		playsound(target.loc, pick(snap_sound), 50, 1)

		//Warn everyone
		visible_message(SPAN_DANGER("[src] [response_snap] [target]!"))
		to_chat(target, SPAN_WARNING("<b>[response_snap_target]</b> Your vision fades away..."))

		target.death() //Immediately trigger death to avoid doublesnap during lag

		//Logging stuff
		target.last_damage_source = initial(name)
		target.last_damage_mob = src
		target.attack_log += text("\[[time_stamp()]\] <font color='red'>Has had his neck snapped by [src]!</font>")
		message_admins("ALERT: <A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>[target.real_name]</a> has had his neck snapped by an active [src].")

/mob/living/simple_animal/scp/sculpture/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()

/mob/living/simple_animal/scp/sculpture/Topic(href, href_list)
	..()

/mob/living/simple_animal/scp/sculpture/Collide(atom/A)
	if(check_los())
		snap_neck(A)
	..()

/mob/living/simple_animal/scp/sculpture/Collided(atom/movable/AM)
	if(check_los())
		snap_neck(AM)

//You cannot destroy SCP-173, fool!
/mob/living/simple_animal/scp/sculpture/ex_act(var/severity)
	lash_out()

/mob/living/simple_animal/scp/sculpture/bullet_act(obj/item/projectile/P)
	if(!P) return
	bullet_ping(P)
	return 1

//Periodically disable lights
/mob/living/simple_animal/scp/sculpture/proc/snuff_out_light()
	if(hardcore && prob(5))
		var/list/stuff = view(10, src)
		snuff_out_light_in_list(stuff)

/mob/living/simple_animal/scp/sculpture/proc/snuff_out_light_in_list(var/list/stuff, var/mob/wearer = null)
	var/obj/structure/machinery/light/light //wall lights
	for(light in stuff)
		if(light.luminosity != 0)
			visible_message(SPAN_NOTICE("[light.name] breaks suddenly."))
			light.broken()
			return TRUE

	var/obj/item/device/flashlight/flashlight
	for(flashlight in stuff)
		if(flashlight.on)
			visible_message(SPAN_NOTICE("[flashlight.name] goes off for some reason."))
			flashlight.turn_off_light(wearer)
			return TRUE

	var/obj/item/clothing/suit/storage/marine/armor
	for(armor in stuff)
		if(armor.is_light_on())
			visible_message(SPAN_NOTICE("[armor.name]'s light turns off for some reason."))
			armor.toggle_armor_light(wearer)
			return TRUE

	var/mob/living/carbon/humanoid
	for(humanoid in stuff)
		if(snuff_out_light_in_list(humanoid, humanoid))
			return TRUE

	return FALSE //We haven't snuffed out a single light