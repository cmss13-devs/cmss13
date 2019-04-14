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
	spawn()
		while(get_turf(src) != target_turf && num_turfs > 0)
			if(!forced && check_los()) //Something is looking at us now
				break
			if(!next_turf.CanPass(src, next_turf)) //We can't pass through our planned path
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
			for(var/obj/machinery/door/airlock/A in next_turf)
				if(A.welded || A.locked) //Snowflakey code to take in account bolts and welding
					break
				A.open()
				sleep(5)
			for(var/obj/machinery/door/D in next_turf)
				D.open()
				sleep(5)
			if(!next_turf.CanPass(src, next_turf)) //Once we cleared everything we could, check one last time if we can pass
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
		spawn()
			while(get_turf(src) != target_turf && num_turfs > 0)
				if(check_los()) //Something is looking at us now
					break
				if(!next_turf.CanPass(src, next_turf)) //We can't pass through our planned path
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
				for(var/obj/machinery/door/airlock/A in next_turf)
					if(A.welded || A.locked) //Snowflakey code to take in account bolts and welding
						break
					A.open()
					sleep(5)
				for(var/obj/machinery/door/D in next_turf)
					D.open()
					sleep(5)
				if(!next_turf.CanPass(src, next_turf)) //Once we cleared everything we could, check one last time if we can pass
					break
				forceMove(next_turf)
				dir = get_dir(src, target_turf)
				next_turf = get_step(src, get_dir(next_turf,target_turf))
				num_turfs--
		//Coding note : This is known to allow SCP to end up on tiles that contain obstructing structures (doors, machinery, etc)
		//Although he CAN'T pass through them during normal movement. Will look into a fix soon

	//Do we have a vent ? Good, let's take a look
	for(entry_vent in view(1, src))
		if(prob(90)) //10 % chance to consider a vent, to try and avoid constant vent switching
			return
		visible_message("<span class='danger'>\The [src] starts trying to slide itself into the vent!</span>")
		sleep(50) //Let's stop SCP-173 for five seconds to do his parking job
		..()
		if(entry_vent.network && entry_vent.network.normal_members.len)
			var/list/vents = list()
			for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in entry_vent.network.normal_members)
				vents.Add(temp_vent)
			if(!vents.len)
				entry_vent = null
				return
			if(check_los()) //Someone started looking at us
				return
			var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)
			spawn()
				visible_message("<span class='danger'>\The [src] suddenly disappears into the vent!</span>")
				loc = exit_vent
				var/travel_time = round(get_dist(loc, exit_vent.loc)/2)
				spawn(travel_time)
					if(!exit_vent || exit_vent.welded)
						forceMove(get_turf(entry_vent))
						entry_vent = null
						visible_message("<span class='danger'>\The [src] suddenly appears from the vent!</span>")
						return

					forceMove(get_turf(exit_vent))
					entry_vent = null
					visible_message("<span class='danger'>\The [src] suddenly appears from the vent!</span>")
		else
			entry_vent = null

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
		visible_message("<span class='danger'>[src] [response_snap] [target]!</span>")
		to_chat(target, "<span class='alert'><b>[response_snap_target]</b> Your vision fades away...</span>")

		target.death() //Immediately trigger death to avoid doublesnap during lag

		//Logging stuff
		target.attack_log += text("\[[time_stamp()]\] <font color='red'>Has had his neck snapped by [src]!</font>")
		log_admin("[target] ([target.ckey]) has had his neck snapped by an active [src].")
		message_admins("ALERT: <A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>[target.real_name]</a> has had his neck snapped by an active [src].")

/mob/living/simple_animal/scp/sculpture/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()

/mob/living/simple_animal/scp/sculpture/Topic(href, href_list)
	..()

/mob/living/simple_animal/scp/sculpture/Bump(atom/movable/AM as mob)
	if(check_los())
		snap_neck(AM)
	..()

/mob/living/simple_animal/scp/sculpture/Bumped(atom/movable/AM as mob, yes)
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
	var/obj/machinery/light/light //wall lights
	for(light in stuff)
		if(light.luminosity != 0)
			visible_message("<span class='notice'>[light.name] breaks suddenly.</span>")
			light.broken()
			return TRUE

	var/obj/item/device/flashlight/flashlight
	for(flashlight in stuff)
		if(flashlight.on)
			visible_message("<span class='notice'>[flashlight.name] goes off for some reason.</span>")
			flashlight.turn_off_light(wearer)
			return TRUE

	var/obj/item/clothing/suit/storage/marine/armor
	for(armor in stuff)
		if(armor.is_light_on())
			visible_message("<span class='notice'>[armor.name]'s light turns off for some reason.</span>")
			armor.toggle_armor_light(wearer)
			return TRUE

	var/mob/living/carbon/humanoid
	for(humanoid in stuff)
		if(snuff_out_light_in_list(humanoid, humanoid))
			return TRUE

	return FALSE //We haven't snuffed out a single light