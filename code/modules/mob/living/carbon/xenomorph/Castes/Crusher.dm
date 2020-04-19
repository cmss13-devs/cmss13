/datum/caste_datum/crusher
	caste_name = "Crusher"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOWPLUS
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_HIGH
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_MEDIUM
	xeno_explosion_resistance = XENO_GIGA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_ULTRA_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_HIGH
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDHIGH
	speed_mod = XENO_SPEED_MOD_SMALL

	tackle_chance = 15
	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	caste_desc = "A huge tanky xenomorph."
	tail_chance = 0 //Inherited from old code. Tail's too big

/datum/caste_datum/crusher/mature
	upgrade_name = "Mature"
	caste_desc = "A huge tanky xenomorph. It looks a little more dangerous."
	upgrade = 1
	tackle_chance = 20

/datum/caste_datum/crusher/elder
	upgrade_name = "Elder"
	caste_desc = "A huge tanky xenomorph. It looks pretty strong."
	upgrade = 2
	tackle_chance = 25

/datum/caste_datum/crusher/ancient
	upgrade_name = "Ancient"
	caste_desc = "It always has the right of way."
	upgrade = 3
	tackle_chance = 28

/datum/caste_datum/crusher/primordial
	upgrade_name = "Primordial"
	caste_desc = "This thing could cause a tsunami just by walking. It's a literal freight train."
	upgrade = 4
	melee_damage_lower = 35
	melee_damage_upper = 45
	tackle_chance = 30
	plasma_gain = 0.080
	plasma_max = 600
	armor_deflection = 90
	max_health = XENO_UNIVERSAL_HPMULT * 400
	speed = -0.5

/mob/living/carbon/Xenomorph/Crusher
	caste_name = "Crusher"
	name = "Crusher"
	desc = "A huge alien with an enormous armored head crest."
	icon = 'icons/mob/xenos/2x2_Xenos.dmi'
	icon_size = 64
	icon_state = "Crusher Walking"
	plasma_types = list(PLASMA_CHITIN)
	tier = 3
	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG

	is_charging = 1 //Crushers start with charging enabled

	pixel_x = -16
	pixel_y = -3
	old_x = -16
	old_y = -3

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/stomp,
		/datum/action/xeno_action/ready_charge,
		)

	new_actions = list(
		/datum/action/xeno_action/activable/earthquake,
	)
	mutation_type = CRUSHER_NORMAL

	next_delay_delay = 2 // they need it for charge

/mob/living/carbon/Xenomorph/Crusher/proc/stomp()
	if(!check_state()) return

	if(world.time < has_screeched + CRUSHER_STOMP_COOLDOWN) //Sure, let's use this.
		to_chat(src, SPAN_XENOWARNING("You are not ready to stomp again."))
		return FALSE

	if(legcuffed)
		to_chat(src, SPAN_XENODANGER("You can't rear up to stomp with that thing on your leg!"))
		return

	if(!check_plasma(50)) return
	has_screeched = world.time
	use_plasma(50)

	playsound(loc, 'sound/effects/bang.ogg', 25, 0)
	visible_message(SPAN_XENODANGER("[src] smashes into the ground!"), \
	SPAN_XENODANGER("You smash into the ground!"))
	create_stomp() //Adds the visual effect. Wom wom wom

	var/i = 5
	for(var/mob/living/M in range(1,loc))
		if(!i) break
		if(!isXeno(M))
			if(M.loc == loc)
				if(M.stat == DEAD)
					continue
				if(!(M.status_flags & XENO_HOST) && !istype(M.buckled, /obj/structure/bed/nest))
					M.take_overall_damage(40) //The same as a full charge, but no more than that.
					M.last_damage_source = initial(name)
					M.last_damage_mob = src
					M.attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno stomped by [src] ([ckey])</font>")
					attack_log += text("\[[time_stamp()]\] <font color='red'>xeno stomped [M.name] ([M.ckey])</font>")
					log_attack("[src] ([ckey]) xeno stomped [M.name] ([M.ckey])")
				M.KnockDown(rand(2, 3))
				to_chat(M, SPAN_HIGHDANGER("You are stomped on by [src]!"))
			shake_camera(M, 2, 2)
		i--

/mob/living/carbon/Xenomorph/Crusher/proc/earthquake()

	if(!check_state()) return

	if(world.time < has_screeched + CRUSHER_EARTHQUAKE_COOLDOWN) //Sure, let's use this.
		to_chat(src, SPAN_XENOWARNING("You are not ready to cause an earthquake yet."))
		return FALSE

	if(legcuffed)
		to_chat(src, SPAN_XENODANGER("You can't rear up to stomp the ground with that thing on your leg!"))
		return

	if(!check_plasma(100)) return
	has_screeched = world.time
	use_plasma(100)

	playsound(loc, 'sound/effects/bang.ogg', 25, 0)
	visible_message(SPAN_XENODANGER("[src] smashes into the ground, causing a violent earthquake!"), \
	SPAN_XENODANGER("You smash into the ground, causing a violent earthquake!"))
	create_stomp() //Adds the visual effect. Wom wom wom

	var/i = 5
	for(var/mob/living/M in range(1,loc))
		if(!i) break
		if(!isXeno(M))
			if(M.loc == loc)
				if(M.stat == DEAD)
					continue
				if(!(M.status_flags & XENO_HOST) && !istype(M.buckled, /obj/structure/bed/nest))
					M.take_overall_damage(40) //The same as a full charge, but no more than that.
					M.last_damage_source = initial(name)
					M.last_damage_mob = src
					M.attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno stomped by [src] ([ckey])</font>")
					attack_log += text("\[[time_stamp()]\] <font color='red'>xeno stomped [M.name] ([M.ckey])</font>")
					log_attack("[src] ([ckey]) xeno stomped [M.name] ([M.ckey])")
				M.KnockDown(rand(2, 3))
				to_chat(M, SPAN_HIGHDANGER("You are stomped on by [src]!"))
			shake_camera(M, 2, 2)
		i--

	for(var/mob/living/carbon/human/M in range(5, loc))
		to_chat(M, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(M, 3, 3)

	for(var/mob/living/carbon/human/H in range(2, loc))
		to_chat(H, SPAN_WARNING("You are knocked down by the violent earthquake beneath your feet!"))
		H.KnockDown(3)

//The atom collided with is passed to this proc, all types of collisions are dealt with here.
//The atom does not tell the Crusher how to handle a collision, the Crusher is an independant
//Xeno who don't need no atom. ~Bmc777
/mob/living/carbon/Xenomorph/proc/handle_collision(atom/target)
	if(!target)
		return FALSE

	//Barricade collision
	if(istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/B = target
		if(charge_speed > charge_speed_buildup * charge_turfs_to_charge)
			visible_message(SPAN_DANGER("[src] rams into [B] and skids to a halt!"),
			SPAN_XENOWARNING("You ram into [B] and skid to a halt!"))
			flags_pass = NO_FLAGS
			update_icons()
			B.Collided(src)
			stop_momentum(charge_dir)
			return TRUE
		else
			stop_momentum(charge_dir)
			return FALSE

	else if(istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/H = target
		if(charge_speed > charge_speed_buildup * charge_turfs_to_charge)
			visible_message(SPAN_DANGER("[src] rams into [H] and skids to a halt!"),
			SPAN_XENOWARNING("You ram into [H] and skid to a halt!"))
			flags_pass = NO_FLAGS
			update_icons()
			H.Collided(src)
			stop_momentum(charge_dir)
			return TRUE
		else
			stop_momentum(charge_dir)
			return FALSE

	else if(istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/HMG = target
		if(charge_speed > charge_speed_buildup * charge_turfs_to_charge)
			visible_message(SPAN_DANGER("[src] rams [HMG]!"),
				SPAN_XENODANGER("You ram [HMG]!"))
			playsound(loc, "punch", 25, 1)
			update_icons()
			HMG.Collided()
			stop_momentum(charge_dir)
			return TRUE
		else
			stop_momentum(charge_dir)
			return FALSE

/atom/proc/charge_act(mob/living/carbon/Xenomorph/X)
	return TRUE

//Catch-all, basically. Collide() isn't going to catch anything non-dense, so this is fine.
/obj/charge_act(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(.)
		if(unacidable)
			X.stop_momentum(X.charge_dir)
			return FALSE

		if(anchored)
			if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
				X.stop_momentum(X.charge_dir)
				return FALSE
			else
				X.visible_message(SPAN_DANGER("[X] crushes [src]!"),
				SPAN_XENODANGER("You crush [src]!"))
				if(contents.len) //Hopefully won't auto-delete things inside crushed stuff.
					var/turf/T = get_turf(src)
					for(var/atom/movable/S in contents) S.loc = T
				qdel(src)
				X.charge_speed -= X.charge_speed_buildup * 3 //Lose three turfs worth of speed
		else
			if(X.charge_speed > X.charge_speed_buildup * X.charge_turfs_to_charge)
				if(buckled_mob)
					unbuckle()
				X.visible_message(SPAN_WARNING("[X] knocks [src] aside!"),
				SPAN_XENOWARNING("You knock [src] aside.")) //Canisters, crates etc. go flying.
				playsound(loc, "punch", 25, 1)
				var/impact_range = min(round(X.charge_speed) + 1, 3)
				var/turf/TA = X.get_diagonal_step(src, X.dir)
				TA = get_step_away(TA, X)
				var/launch_speed = X.charge_speed
				launch_towards(TA, impact_range, launch_speed)
				X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed
			else
				X.stop_momentum(X.charge_dir)
				return FALSE

//Beginning special object overrides.

//**READ ME**
//NO MORE SPECIAL OBJECT OVERRIDES! Do not create another charge_act.
//For all future collisions, add to the body of handle_collision().
//We do not want to add Crusher specific procs to objects, all Crusher
//related code should be handled by Crusher code. The object collided with
//should handle it's own damage (and deletion if needed) through it's
//Collided() proc. ~Bmc777

/obj/structure/window/charge_act(mob/living/carbon/Xenomorph/X)
	if(unacidable)
		X.stop_momentum(X.charge_dir)
		return FALSE
	if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
		X.stop_momentum(X.charge_dir)
		return FALSE
	health -= X.charge_speed * 80 //Should generally smash it unless not moving very fast.
	healthcheck(user = X)

	X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed

	return TRUE

/obj/structure/machinery/door/airlock/charge_act(mob/living/carbon/Xenomorph/X)
	if(unacidable)
		X.stop_momentum(X.charge_dir)
		return FALSE
	if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
		X.stop_momentum(X.charge_dir)
		return FALSE

	destroy_airlock()
	X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed
	return TRUE

/obj/structure/grille/charge_act(mob/living/carbon/Xenomorph/X)
	if(unacidable)
		X.stop_momentum(X.charge_dir)
		return FALSE
	if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
		X.stop_momentum(X.charge_dir)
		return FALSE
	health -= X.charge_speed * 40 //Usually knocks it down.
	healthcheck()

	X.charge_speed -= X.charge_speed_buildup //Lose one turf worth of speed

	return TRUE

/obj/structure/machinery/vending/charge_act(mob/living/carbon/Xenomorph/X)
	if(X.charge_speed > X.charge_speed_max/2) //Halfway to full speed or more
		if(unacidable)
			X.stop_momentum(X.charge_dir, TRUE)
			return FALSE
		X.visible_message(SPAN_DANGER("[X] smashes straight into [src]!"),
		SPAN_XENODANGER("You smash straight into [src]!"))
		playsound(loc, "punch", 25, 1)
		tip_over()
		var/impact_range = 1
		var/turf/TA = X.get_diagonal_step(src, X.dir)
		TA = get_step_away(TA, X)
		var/launch_speed = X.charge_speed
		launch_towards(TA, impact_range, launch_speed)
		X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed
		return TRUE
	else
		X.stop_momentum(X.charge_dir)
		return FALSE

/obj/structure/machinery/defenses/sentry/charge_act(mob/living/carbon/Xenomorph/X)
	if(unacidable)
		X.stop_momentum(X.charge_dir, TRUE)
		return FALSE
	if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
		X.stop_momentum(X.charge_dir)
		return FALSE
	X.visible_message(SPAN_DANGER("[X] rams [src]!"),
	SPAN_XENODANGER("You ram [src]!"))
	playsound(loc, "punch", 25, 1)
	stat = 1
	turned_on = FALSE
	update_icon()
	update_health(X.charge_speed * 20)
	X.charge_speed -= X.charge_speed_buildup * 3 //Lose three turfs worth of speed
	return TRUE

/obj/structure/mineral_door/resin/charge_act(mob/living/carbon/Xenomorph/X)
	TryToSwitchState(X)

	if(X.charge_speed < X.charge_speed_buildup * X.charge_turfs_to_charge)
		X.stop_momentum(X.charge_dir)
		return FALSE
	else
		X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed
		return TRUE

/obj/structure/table/charge_act(mob/living/carbon/Xenomorph/X)
	Crossed(X)
	return TRUE

/mob/living/carbon/charge_act(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(. && X.charge_speed > X.charge_speed_buildup * X.charge_turfs_to_charge)
		if(anchored)
			X.stop_momentum(X.charge_dir)
			return FALSE
		playsound(loc, "punch", 25, 1)
		if(stat == DEAD)
			var/count = 0
			var/turf/TU = get_turf(src)
			for(var/mob/living/carbon/C in TU)
				if(C.stat == DEAD)
					count++
			if(count)
				X.charge_speed -= X.charge_speed_buildup / (count * 2) // half normal slowdown regardless of number of corpses.
		else if(!(status_flags & XENO_HOST) && !istype(buckled, /obj/structure/bed/nest))
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [X.name] ([X.ckey])</font>")
			X.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src.name] ([src.ckey])</font>")
			log_attack("[X.name] ([X.ckey]) xeno charged [src.name] ([src.ckey])")
			apply_damage(X.charge_speed * 40, BRUTE)
			X.visible_message(SPAN_DANGER("[X] rams [src]!"),
			SPAN_XENODANGER("You ram [src]!"))
		KnockDown(X.charge_speed * 4)
		animation_flash_color(src)
		var/impact_range = min(round(X.charge_speed) + 1, 2)
		var/turf/TA = X.get_diagonal_step(src, X.dir)
		TA = get_step_away(TA, X)
		var/launch_speed = X.charge_speed
		launch_towards(TA, impact_range, launch_speed) // Distance and speed of being thrown to the side are dependent on speed of crusher
		X.charge_speed -= X.charge_speed_buildup //Lose one turf worth of speed
		return TRUE

//Special override case.
/mob/living/carbon/Xenomorph/charge_act(mob/living/carbon/Xenomorph/X)
	if(X.charge_speed > X.charge_speed_buildup * X.charge_turfs_to_charge)
		playsound(loc, "punch", 25, 1)
		if(hivenumber != X.hivenumber)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [X.name] ([X.ckey])</font>")
			X.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src.name] ([src.ckey])</font>")
			log_attack("[X.name] ([X.ckey]) xeno charged [src.name] ([src.ckey])")
			apply_damage(X.charge_speed * 20, BRUTE) // half damage to avoid sillyness
		if(anchored) //Ovipositor queen can't be pushed
			X.stop_momentum(X.charge_dir, TRUE)
			return TRUE
		var/impact_range = 1
		var/turf/TA = X.get_diagonal_step(src, X.dir)
		launch_towards(TA, impact_range, SPEED_INSTANT)
		X.charge_speed -= X.charge_speed_buildup * 2 //Lose two turfs worth of speed
		return TRUE
	else
		X.stop_momentum(X.charge_dir)
		return FALSE

/turf/charge_act(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(. && density) //We don't care if it's non dense.
		if(X.charge_speed < X.charge_speed_max)
			X.stop_momentum(X.charge_dir)
			return FALSE
		else
			ex_act(EXPLOSION_THRESHOLD_MEDIUM) //Should dismantle, or at least heavily damage it.
			X.stop_momentum(X.charge_dir)
			return TRUE

//Custom bump for crushers. This overwrites normal bumpcode from carbon.dm
/mob/living/carbon/Xenomorph/Crusher/Collide(atom/A)
	set waitfor = 0

	if(charge_speed < charge_speed_buildup * charge_turfs_to_charge || !is_charging)
		return ..()

	if(stat || !istype(A) || A == src)
		return FALSE

	if(now_pushing)
		return FALSE // Just a plain ol turf, let's return.

	if(dir != charge_dir) //We aren't facing the way we're charging.
		stop_momentum()
		return ..()

	if(!handle_collision(A))
		if(!A.charge_act(src)) //charge_act is depricated and only here to handle cases that have not been refactored as of yet.
			return ..()

	var/turf/T = get_step(src, dir)
	if(!T || !get_step_to(src, T)) //If it still exists, try to push it.
		return ..()

	lastturf = null //Reset this so we can properly continue with momentum.
	return TRUE

/mob/living/carbon/Xenomorph/Crusher/update_icons()
	if(stat == DEAD)
		icon_state = "Crusher Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Crusher Sleeping"
		else
			icon_state = "Crusher Knocked Down"
	else
		if(m_intent == MOVE_INTENT_RUN)
			if(charge_speed > charge_speed_buildup * charge_turfs_to_charge) //Let it build up a bit so we're not changing icons every single turf
				icon_state = "Crusher Charging"
			else
				icon_state = "Crusher Running"

		else
			icon_state = "Crusher Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
