

/mob/living/carbon/Xenomorph/proc/Pounce(atom/T)

	if(!T) return

	if(T.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(loc))
		to_chat(src, "<span class='xenowarning'>You can't pounce from here!</span>")
		return

	if(!check_state())
		return

	if(used_pounce)
		to_chat(src, "<span class='xenowarning'>You must wait before pouncing.</span>")
		return

	if(!check_plasma(10))
		return

	if(legcuffed)
		to_chat(src, "<span class='xenodanger'>You can't pounce with that thing on your leg!</span>")
		return

	if(layer == XENO_HIDING_LAYER) //Xeno is currently hiding, unhide him
		layer = MOB_LAYER

	if(m_intent == MOVE_INTENT_WALK && isXenoLurker(src)) //Hunter that is currently using its stealth ability, need to unstealth him
		toggle_mov_intent()

	visible_message("<span class='xenowarning'>\The [src] pounces at [T]!</span>", \
	"<span class='xenowarning'>You pounce at [T]!</span>")
	used_pounce = 1
	flags_pass = PASSTABLE
	use_plasma(10)
	throw_at(T, caste.charge_distance + mutators.pounce_boost, caste.charge_speed, src) //Victim, distance, speed
	spawn(6)
		if(!hardcore)
			flags_pass = initial(flags_pass) //Reset the passtable.
		else
			flags_pass = 0 //Reset the passtable.

	spawn(caste.pounce_delay)
		used_pounce = 0
		to_chat(src, SPAN_NOTICE("You get ready to pounce again."))
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

	return 1


// Praetorian acid spray
/mob/living/carbon/Xenomorph/proc/acid_spray_cone(atom/A)

	if (!A || !check_state())
		return

	if (used_acid_spray)
		to_chat(src, "<span class='xenowarning'>You must wait to produce enough acid to spray.</span>")
		return

	if (!check_plasma(200))
		to_chat(src, "<span class='xenowarning'>You must produce more plasma before doing this.</span>")
		return

	var/turf/target

	if (isturf(A))
		target = A
	else
		target = get_turf(A)

	if (target == loc)
		return

	if(!target)
		return

	if(action_busy)
		return

	if(!do_after(src, acid_spray_cooldown, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	if (used_acid_spray)
		return

	if (!check_plasma(200))
		return

	round_statistics.praetorian_acid_sprays++

	used_acid_spray = 1
	use_plasma(200)
	playsound(loc, 'sound/effects/refill.ogg', 25, 1)
	visible_message("<span class='xenowarning'>\The [src] spews forth a wide cone of acid!</span>", \
	"<span class='xenowarning'>You spew forth a cone of acid!</span>", null, 5)

	ability_speed_modifier += 2
	do_acid_spray_cone(target)
	spawn(rand(20,30))
		ability_speed_modifier = 0

	spawn(caste.acid_spray_cooldown)
		used_acid_spray = 0
		to_chat(src, SPAN_NOTICE("You have produced enough acid to spray again."))

/mob/living/carbon/Xenomorph/proc/do_acid_spray_cone(var/turf/T)
	set waitfor = 0

	var/facing = get_cardinal_dir(src, T)
	dir = facing

	T = loc
	for (var/i = 0, i < caste.acid_spray_range, i++)

		var/turf/next_T = get_step(T, facing)

		for (var/obj/O in T)
			if(!O.CheckExit(src, next_T))
				if(istype(O, /obj/structure/barricade))
					var/obj/structure/barricade/B = O
					B.health -= rand(20, 30)
					B.update_health(1)
				return

		T = next_T

		if (T.density)
			return

		for (var/obj/O in T)
			if(!O.CanPass(src, loc))
				if(istype(O, /obj/structure/barricade))
					var/obj/structure/barricade/B = O
					B.health -= rand(20, 30)
					B.update_health(1)
				return

		var/obj/effect/xenomorph/spray/S = acid_splat_turf(T)
		do_acid_spray_cone_normal(T, i, facing, S)
		sleep(3)

//Acid Spray
/mob/living/carbon/Xenomorph/proc/acid_spray(atom/T)
	if(!T) return

	if(!check_state())
		return

	if(acid_cooldown)
		return

	if(!isturf(loc) || istype(loc, /turf/open/space))
		to_chat(src, SPAN_WARNING("You can't do that from there.</span>"))
		return

	if(!check_plasma(10))
		return

	if(T)
		var/turf/target

		if(isturf(T))
			target = T
		else
			target = get_turf(T)

		if(!istype(target)) //Something went horribly wrong. Clicked off edge of map probably
			return

		if(target == loc)
			to_chat(src, "<span class='warning'>That's far too close!</span>")
			return

		if(!target)
			return

		acid_cooldown = 1
		use_plasma(10)
		playsound(src.loc, 'sound/effects/refill.ogg', 25, 1)
		visible_message("<span class='xenowarning'>\The [src] spews forth a virulent spray of acid!</span>", \
		"<span class='xenowarning'>You spew forth a spray of acid!</span>", null, 5)
		var/turflist = getline(src, target)
		spray_turfs(turflist)
		spawn(caste.acid_delay) //12 second cooldown.
			acid_cooldown = 0
			to_chat(src, "<span class='warning'>You feel your acid glands refill. You can spray <B>acid</b> again.</span>")
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()
	else
		to_chat(src, "<span class='warning'>You see nothing to spit at!</span>")


/mob/living/carbon/Xenomorph/proc/spray_turfs(list/turflist)
	set waitfor = 0

	if(isnull(turflist))
		return
	var/turf/prev_turf
	var/distance = 0
	var/distance_max = 5

	if(isXenoBoiler(src))
		distance_max = 7

	turf_loop:
		for(var/turf/T in turflist)
			distance++

			if(!prev_turf && turflist.len > 1)
				prev_turf = get_turf(src)
				continue //So we don't burn the tile we be standin on

			if(T.density || istype(T, /turf/open/space))
				break
			if(distance > distance_max)
				break

			if(locate(/obj/structure/girder, T))
				break //Nope.avi

			var/obj/machinery/M = locate() in T
			if(M)
				if(M.density)
					break

			if(prev_turf && LinkBlocked(prev_turf, T))
				break

			for(var/obj/structure/barricade/B in T)
				B.health -= rand(20, 30)
				B.update_health(TRUE)
				if(prev_turf)
					if(get_dir(B, prev_turf) & B.dir)
						break turf_loop

			if(!check_plasma(10))
				break
			plasma_stored -= 10
			prev_turf = T
			splat_turf(T)
			sleep(2)

/mob/living/carbon/Xenomorph/proc/splat_turf(var/turf/target)
	if(!istype(target) || istype(target,/turf/open/space))
		return

	if(!locate(/obj/effect/xenomorph/spray) in target) //No stacking flames!
		if(isXenoBoiler(src)) new /obj/effect/xenomorph/spray(target)
		if(isXenoSpitter(src)) new /obj/effect/xenomorph/spray/weak(target)
		for(var/mob/living/carbon/M in target)
			if(ishuman(M) || ismonkey(M))
				if((M.status_flags & XENO_HOST) && istype(M.buckled, /obj/structure/bed/nest))
					continue //nested infected hosts are not hurt by acid spray
				M.adjustFireLoss(rand(20 + 5 * upgrade, 30 + 5 * upgrade))
				to_chat(M, "<span class='xenodanger'>\The [src] showers you in corrosive acid!</span>")
				if(!isYautja(M))
					M.emote("scream")
					if(!isXenoSpitter(src))
						M.KnockDown(rand(3, 4))

// Normal refers to the mathematical normal
/mob/living/carbon/Xenomorph/proc/do_acid_spray_cone_normal(turf/T, distance, facing, obj/effect/xenomorph/spray/source_spray)
	if (!distance)
		return

	var/obj/effect/xenomorph/spray/left_S = source_spray
	var/obj/effect/xenomorph/spray/right_S = source_spray

	var/normal_dir = turn(facing, 90)
	var/inverse_normal_dir = turn(facing, -90)

	var/turf/normal_turf = T
	var/turf/inverse_normal_turf = T

	var/normal_density_flag = 0
	var/inverse_normal_density_flag = 0

	for (var/i = 0, i < distance, i++)
		if (normal_density_flag && inverse_normal_density_flag)
			return

		if (!normal_density_flag)
			var/next_normal_turf = get_step(normal_turf, normal_dir)

			for (var/obj/O in normal_turf)
				if(!O.CheckExit(left_S, next_normal_turf))
					if(istype(O, /obj/structure/barricade))
						var/obj/structure/barricade/B = O
						B.health -= rand(20, 30)
						B.update_health(1)
					normal_density_flag = 1
					break

			normal_turf = next_normal_turf

			if(!normal_density_flag)
				normal_density_flag = normal_turf.density

			if(!normal_density_flag)
				for (var/obj/O in normal_turf)
					if(!O.CanPass(left_S, left_S.loc))
						if(istype(O, /obj/structure/barricade))
							var/obj/structure/barricade/B = O
							B.health -= rand(20, 30)
							B.update_health(1)
						normal_density_flag = 1
						break

			if (!normal_density_flag)
				left_S = acid_splat_turf(normal_turf)


		if (!inverse_normal_density_flag)

			var/next_inverse_normal_turf = get_step(inverse_normal_turf, inverse_normal_dir)

			for (var/obj/O in inverse_normal_turf)
				if(!O.CheckExit(right_S, next_inverse_normal_turf))
					if(istype(O, /obj/structure/barricade))
						var/obj/structure/barricade/B = O
						B.health -= rand(20, 30)
						B.update_health(1)
					inverse_normal_density_flag = 1
					break

			inverse_normal_turf = next_inverse_normal_turf

			if(!inverse_normal_density_flag)
				inverse_normal_density_flag = inverse_normal_turf.density

			if(!inverse_normal_density_flag)
				for (var/obj/O in inverse_normal_turf)
					if(!O.CanPass(right_S, right_S.loc))
						if(istype(O, /obj/structure/barricade))
							var/obj/structure/barricade/B = O
							B.health -= rand(20, 30)
							B.update_health(1)
						inverse_normal_density_flag = 1
						break

			if (!inverse_normal_density_flag)
				right_S = acid_splat_turf(inverse_normal_turf)



/mob/living/carbon/Xenomorph/proc/acid_splat_turf(var/turf/T)
	. = locate(/obj/effect/xenomorph/spray) in T
	if(!.)
		. = new /obj/effect/xenomorph/spray(T)

		// This should probably be moved into obj/effect/xenomorph/spray or something
		for (var/obj/structure/barricade/B in T)
			B.health -= rand(20, 30)
			B.update_health(1)

		for (var/mob/living/carbon/C in T)
			if (!ishuman(C) && !ismonkey(C))
				continue

			if ((C.status_flags & XENO_HOST) && istype(C.buckled, /obj/structure/bed/nest))
				continue

			round_statistics.praetorian_spray_direct_hits++
			C.adjustFireLoss(rand(20,30) + 5 * upgrade)
			to_chat(C, "<span class='xenodanger'>\The [src] showers you in corrosive acid!</span>")

			if (!isYautja(C))
				C.emote("scream")
				C.KnockDown(rand(3, 4))


// Warrior Fling
/mob/living/carbon/Xenomorph/proc/fling(atom/A)

	if (!A || !istype(A, /mob/living/carbon/human))
		return

	if (!check_state() || agility)
		return

	if (used_fling)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before flinging something.</span>")
		return

	if (!check_plasma(10))
		return

	if (!Adjacent(A))
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return
	round_statistics.warrior_flings++

	visible_message("<span class='xenowarning'>\The [src] effortlessly flings [H] to the side!</span>", \
	"<span class='xenowarning'>You effortlessly fling [H] to the side!</span>")
	playsound(H,'sound/weapons/alien_claw_block.ogg', 75, 1)
	used_fling = 1
	use_plasma(10)
	H.apply_effects(1,2) 	// Stun
	shake_camera(H, 2, 1)

	var/facing = get_dir(src, H)
	var/fling_distance = 4
	var/turf/T = loc
	var/turf/temp = loc

	for (var/x = 0, x < fling_distance, x++)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.throw_at(T, fling_distance, 1, src, 1)

	spawn(caste.fling_cooldown)
		used_fling = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to fling something again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/punch(atom/A)

	if (!A || !ishuman(A))
		return

	if (!check_state() || agility)
		return

	if (used_punch)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before punching.</span>")
		return

	if (!check_plasma(10))
		return

	if (!Adjacent(A))
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return
	if(H.status_flags & XENO_HOST)
		to_chat(src, "<span class='xenowarning'>This would harm the embryo!</span>")
		return
	round_statistics.warrior_punches++
	var/datum/limb/L = H.get_limb(check_zone(zone_selected))

	if (!L || (L.status & LIMB_DESTROYED))
		return

	visible_message("<span class='xenowarning'>\The [src] hits [H] in the [L.display_name] with a devastatingly powerful punch!</span>", \
	"<span class='xenowarning'>You hit [H] in the [L.display_name] with a devastatingly powerful punch!</span>")
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	used_punch = 1
	use_plasma(10)

	if(!boxer)

		if(L.status & LIMB_SPLINTED) //If they have it splinted, the splint won't hold.
			L.status &= ~LIMB_SPLINTED
			to_chat(H, "<span class='danger'>The splint on your [L.display_name] comes apart!</span>")

		if(isYautja(H))
			L.take_damage(rand(8,12))
		else if(L.status & LIMB_ROBOT)
			L.take_damage(rand(30,40), 0, 0) // just do more damage
		else
			var/fracture_chance = 100
			switch(L.body_part)
				if(HEAD)
					fracture_chance = 20
				if(UPPER_TORSO)
					fracture_chance = 30
				if(LOWER_TORSO)
					fracture_chance = 40

			L.take_damage(rand(15,25), 0, 0)
			if(prob(fracture_chance))
				L.fracture()

		shake_camera(H, 2, 1)
		step_away(H, src, 2)

	if(boxer)
		if(isYautja(H))
			L.take_damage(rand(12, 16))
		else if(L.status & LIMB_ROBOT)
			L.take_damage(rand(40, 50), 0, 0) // just do more damage
		else
			L.take_damage(rand(25, 30), 0, 0)
			if(L.body_part == HEAD)
				var/knockdown_chance = 14
				if(prob(knockdown_chance))
					H.KnockDown(1)

		shake_camera(H, 3, 1)

		if(H.lying)
			step_away(H, src, 3)
			H.KnockDown(1)
		else
			step_away(H, src, 2)

	spawn(caste.punch_cooldown)
		used_punch = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to punch again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/jab(atom/A)

	if (!A || !ishuman(A))
		return

	if (!check_state())
		return

	if (used_jab)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before jabbing.</span>")
		return

	if (!check_plasma(10))
		return

	var/distance = get_dist(src, A)

	if (distance > 2)
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return
	if(H.status_flags & XENO_HOST)
		to_chat(src, "<span class='xenowarning'>This would harm the embryo!</span>")
		return

	if (distance > 1)
		step_towards(src, H, 1)

	if (!Adjacent(H))
		return

	round_statistics.warrior_punches++

	visible_message("<span class='xenowarning'>\The [src] hits [H] with a powerful jab!</span>", \
	"<span class='xenowarning'>You hit [H] with a powerful jab!</span>")
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	used_jab = 1
	use_plasma(10)

	if(!isYautja(H))
		H.KnockDown(0.1)

	if(agility)
		toggle_agility()

	if(used_punch)
		used_punch = FALSE

	shake_camera(H, 3, 1)
	step_away(H, src, 2)

	spawn(caste.jab_cooldown)
		used_jab = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to jab again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/lunge(atom/A)

	if (!A)
		return

	if (!isturf(loc))
		to_chat(src, "<span class='xenowarning'>You can't lunge from here!</span>")
		return

	if (!check_state() || agility)
		return

	if (used_lunge)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before lunging.</span>")
		return

	if (!check_plasma(10))
		return

	if(!isHumanStrict(A) && !ismonkey(A))
		used_lunge = 1
		spawn(15)
			used_lunge = 0
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	round_statistics.warrior_lunges++
	visible_message("<span class='xenowarning'>\The [src] lunges towards [H]!</span>", \
	"<span class='xenowarning'>You lunge at [H]!</span>")

	used_lunge = 1 // triggered by start_pulling
	use_plasma(10)
	throw_at(get_step_towards(A, src), 6, 2, src)

	if (Adjacent(H))
		start_pulling(H,1)

	if(used_lunge == 1)
		spawn(caste.lunge_cooldown)
			used_lunge = 0
			to_chat(src, SPAN_NOTICE("You get ready to lunge again."))
			for(var/X in actions)
				var/datum/action/act = X
				act.update_button_icon()

	return 1

// Called when pulling something and attacking yourself with the pull
/mob/living/carbon/Xenomorph/proc/pull_power(var/mob/M)
	if (isXenoWarrior(src) && !ripping_limb && M.stat != DEAD)
		if(M.status_flags & XENO_HOST)
			to_chat(src, "<span class='xenowarning'>This would harm the embryo!</span>")
			return
		ripping_limb = 1
		if(rip_limb(M))
			stop_pulling()
		ripping_limb = 0


// Warrior Rip Limb - called by pull_power()
/mob/living/carbon/Xenomorph/proc/rip_limb(var/mob/M)
	if (!istype(M, /mob/living/carbon/human))
		return 0

	if(action_busy) //can't stack the attempts
		return 0

	var/mob/living/carbon/human/H = M
	var/datum/limb/L = H.get_limb(check_zone(zone_selected))

	if (!L || L.body_part == UPPER_TORSO || L.body_part == LOWER_TORSO || (L.status & LIMB_DESTROYED)) //Only limbs and head.
		to_chat(src, "<span class='xenowarning'>You can't rip off that limb.</span>")
		return 0
	round_statistics.warrior_limb_rips++
	var/limb_time = rand(40,60)

	if (L.body_part == HEAD)
		limb_time = rand(90,110)

	visible_message("<span class='xenowarning'>\The [src] begins pulling on [M]'s [L.display_name] with incredible strength!</span>", \
	"<span class='xenowarning'>You begin to pull on [M]'s [L.display_name] with incredible strength!</span>")

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE) || M.stat == DEAD)
		to_chat(src, SPAN_NOTICE("You stop ripping off the limb."))
		return 0

	if(L.status & LIMB_DESTROYED)
		return 0

	if(L.status & LIMB_ROBOT)
		L.take_damage(rand(30,40), 0, 0) // just do more damage
		visible_message("<span class='xenowarning'>You hear [M]'s [L.display_name] being pulled beyond its load limits!</span>", \
		"<span class='xenowarning'>\The [M]'s [L.display_name] begins to tear apart!</span>")
	else
		visible_message("<span class='xenowarning'>You hear the bones in [M]'s [L.display_name] snap with a sickening crunch!</span>", \
		"<span class='xenowarning'>\The [M]'s [L.display_name] bones snap with a satisfying crunch!</span>")
		L.take_damage(rand(15,25), 0, 0)
		L.fracture()
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [L.display_name] off of [M.name] ([M.ckey]) 1/2 progress</font>")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [L.display_name] ripped off by [src.name] ([src.ckey]) 1/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [L.display_name] off of [M.name] ([M.ckey]) 1/2 progress")

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE)  || M.stat == DEAD || iszombie(M))
		to_chat(src, SPAN_NOTICE("You stop ripping off the limb."))
		return 0

	if(L.status & LIMB_DESTROYED)
		return 0

	visible_message("<span class='xenowarning'>\The [src] rips [M]'s [L.display_name] away from \his body!</span>", \
	"<span class='xenowarning'>\The [M]'s [L.display_name] rips away from \his body!</span>")
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [L.display_name] off of [M.name] ([M.ckey]) 2/2 progress</font>")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [L.display_name] ripped off by [src.name] ([src.ckey]) 2/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [L.display_name] off of [M.name] ([M.ckey]) 2/2 progress")

	L.droplimb()

	return 1


// Warrior Agility
/mob/living/carbon/Xenomorph/proc/toggle_agility()
	if (!check_state(1))
		return

	if (used_toggle_agility)
		return

	agility = !agility

	round_statistics.warrior_agility_toggles++
	if (agility)
		to_chat(src, "<span class='xenowarning'>You lower yourself to all fours.</span>")
	else
		to_chat(src, "<span class='xenowarning'>You raise yourself to stand on two feet.</span>")
	recalculate_speed()
	update_icons()
	do_agility_cooldown()

/mob/living/carbon/Xenomorph/proc/do_agility_cooldown()
	spawn(caste.toggle_agility_cooldown)
		used_toggle_agility = 0
		to_chat(src, SPAN_NOTICE("You can [agility ? "raise yourself back up" : "lower yourself back down"] again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


// Defender Headbutt
/mob/living/carbon/Xenomorph/proc/headbutt(var/mob/M)
	if (!M || !istype(M, /mob/living/carbon/human))
		return

	if (fortify)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities while fortified.</span>")
		return

	if (crest_defense && !spiked)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities with your crest lowered.</span>")
		return

	if (!check_state())
		return

	if (used_headbutt)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before headbutting.</span>")
		return

	if (!check_plasma(10))
		return

	var/mob/living/carbon/human/H = M
	if(H.stat == DEAD)
		return

	var/distance = get_dist(src, H)

	var/max_distance = 2 + spiked

	if (distance > max_distance)
		return

	if (distance > 1)
		step_towards(src, H, max_distance)

	if (!Adjacent(H))
		return

	round_statistics.defender_headbutts++

	visible_message("<span class='xenowarning'>\The [src] rams [H] with it's armored crest!</span>", \
	"<span class='xenowarning'>You ram [H] with your armored crest!</span>")

	used_headbutt = 1
	use_plasma(10)

	if(H.stat != DEAD && (!(H.status_flags & XENO_HOST) || !istype(H.buckled, /obj/structure/bed/nest)) )
		var/h_damage = 20 + (spiked * 5)
		H.apply_damage(h_damage)
		shake_camera(H, 2, 1)

	var/facing = get_dir(src, H)
	var/headbutt_distance = spiked + 3
	var/turf/T = loc
	var/turf/temp = loc

	for (var/x = 0, x < headbutt_distance, x++)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.throw_at(T, headbutt_distance, 1, src)
	playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)
	spawn(caste.headbutt_cooldown)
		used_headbutt = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to headbutt again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


// Defender Tail Sweep
/mob/living/carbon/Xenomorph/proc/tail_sweep()
	if (fortify)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities while fortified.</span>")
		return

	if (crest_defense)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities with your crest lowered.</span>")
		return

	if (!check_state())
		return

	if (used_tail_sweep)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before tail sweeping.</span>")
		return

	if (!check_plasma(10))
		return

	round_statistics.defender_tail_sweeps++
	visible_message("<span class='xenowarning'>\The [src] sweeps it's tail in a wide circle!</span>", \
	"<span class='xenowarning'>You sweep your tail in a wide circle!</span>")

	spin_circle()

	var/sweep_range = 1
	var/list/L = orange(sweep_range)		// Not actually the fruit

	for (var/mob/living/carbon/human/H in L)
		if(H != H.handle_barriers(src)) continue
		if(H.stat == DEAD) continue
		if(istype(H.buckled, /obj/structure/bed/nest)) continue
		step_away(H, src, sweep_range, 2)
		H.apply_damage(10)
		round_statistics.defender_tail_sweep_hits++
		shake_camera(H, 2, 1)

		if(isXenoDefender(src))
			if (prob(50))
				H.KnockDown(2, 1)

		if(isXenoPraetorian(src))
			H.KnockDown(2, 1)

		to_chat(H, "<span class='xenowarning'>You are struck by \the [src]'s tail sweep!</span>")
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)
	used_tail_sweep = 1
	use_plasma(10)

	spawn(caste.tail_sweep_cooldown)
		used_tail_sweep = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to tail sweep again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


// Defender Crest Defense
/mob/living/carbon/Xenomorph/proc/toggle_crest_defense()

	if (fortify)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities while fortified.</span>")
		return

	if (!check_state())
		return

	if (used_crest_defense)
		return

	crest_defense = !crest_defense
	used_crest_defense = 1

	if (crest_defense)
		round_statistics.defender_crest_lowerings++
		to_chat(src, "<span class='xenowarning'>You lower your crest.</span>")
		armor_deflection_buff += 15
		ability_speed_modifier += 0.7	// This is actually a slowdown but speed is dumb
		update_icons()
		do_crest_defense_cooldown()
		return

	round_statistics.defender_crest_raises++
	to_chat(src, "<span class='xenowarning'>You raise your crest.</span>")
	armor_deflection_buff -= 15
	ability_speed_modifier = 0
	update_icons()
	do_crest_defense_cooldown()

/mob/living/carbon/Xenomorph/proc/do_crest_defense_cooldown()
	spawn(caste.crest_defense_cooldown)
		used_crest_defense = 0
		to_chat(src, SPAN_NOTICE("You can [crest_defense ? "raise" : "lower"] your crest."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


// Defender Fortify
/mob/living/carbon/Xenomorph/proc/fortify()
	if(crest_defense && spiked)
		to_chat(src, "<span class='xenowarning'>You cannot fortify while your crest is already down!</span>")
		return

	if (crest_defense)
		to_chat(src, "<span class='xenowarning'>You cannot use abilities with your crest lowered.</span>")
		return

	if (!check_state())
		return

	if (used_fortify)
		return

	round_statistics.defender_fortifiy_toggles++

	fortify = !fortify
	used_fortify = 1

	if (fortify)
		to_chat(src, "<span class='xenowarning'>You tuck yourself into a defensive stance.</span>")
		armor_deflection_buff += 40
		armor_explosive_buff += 60
		if(!spiked)
			frozen = 1
			anchored = 1
			update_canmove()
		if(spiked)
			ability_speed_modifier += 2.5
		update_icons()
		do_fortify_cooldown()
		fortify_timer = world.timeofday + 90		// How long we can be fortified
		process_fortify()
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 30, 1)
		return

	fortify_off()
	do_fortify_cooldown()

/mob/living/carbon/Xenomorph/proc/process_fortify()
	set background = 1

	spawn while (fortify)
		if (world.timeofday > fortify_timer)
			fortify = 0
			fortify_off()
		sleep(10)	// Process every second.

/mob/living/carbon/Xenomorph/proc/fortify_off()
	to_chat(src, "<span class='xenowarning'>You resume your normal stance.</span>")
	armor_deflection_buff -= 40
	armor_explosive_buff -= 60
	frozen = 0
	anchored = 0
	if(spiked)
		ability_speed_modifier -= 2.5
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 30, 1)
	update_canmove()
	update_icons()

/mob/living/carbon/Xenomorph/proc/do_fortify_cooldown()
	spawn(caste.fortify_cooldown)
		used_fortify = 0
		to_chat(src, SPAN_NOTICE("You can [fortify ? "stand up" : "fortify"] again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


//Burrower Abilities
/mob/living/carbon/Xenomorph/proc/burrow()
	if (!check_state())
		return

	if (used_burrow || tunnel)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	if(istype(T, /turf/open/floor/almayer/research/containment))
		to_chat(src, "<span class='xenowarning'>You can't escape this cell!</span>")
		return

	used_burrow = 1

	if (!burrow)
		to_chat(src, "<span class='xenowarning'>You begin burrowing yourself into the ground.</span>")
		if(!do_after(src, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			do_burrow_cooldown()
			return
		// TODO Make immune to all damage here.
		to_chat(src, "<span class='xenowarning'>You burrow yourself into the ground.</span>")
		burrow = 1
		frozen = 1
		invisibility = 101
		anchored = 1
		density = 0
		update_canmove()
		update_icons()
		do_burrow_cooldown()
		burrow_timer = world.timeofday + 90		// How long we can be burrowed
		process_burrow()
		return

	burrow_off()

/mob/living/carbon/Xenomorph/proc/process_burrow()
	set background = 1

	spawn while (burrow)
		if (world.timeofday > burrow_timer && !tunnel)
			burrow = 0
			burrow_off()
		sleep(10)	// Process every second.

/mob/living/carbon/Xenomorph/proc/burrow_off()

	to_chat(src, SPAN_NOTICE("You resurface."))
	frozen = 0
	invisibility = 0
	anchored = 0
	density = 1
	for(var/mob/living/carbon/human/H in loc)
		H.KnockDown(2)
	do_burrow_cooldown()
	update_canmove()
	update_icons()

/mob/living/carbon/Xenomorph/proc/do_burrow_cooldown()
	spawn(caste.burrow_cooldown)
		used_burrow = 0
		to_chat(src, SPAN_NOTICE("You can now surface."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()


/mob/living/carbon/Xenomorph/proc/tunnel(var/turf/T)
	if (!burrow)
		to_chat(src, SPAN_NOTICE("You must be burrowed to do this."))
		return

	if (used_tunnel)
		to_chat(src, SPAN_NOTICE("You must wait some time to do this."))
		return

	if (!T) //Not sure how we'd end up here, but we did have this happen, so sanity check!
		to_chat(src, SPAN_NOTICE("You can't tunnel there!"))
		return

	if(!(T.z in SURFACE_Z_LEVELS)) //Can't burrow on Almayer or in the dropships, also not in the admin level. Pretty much only surface!
		to_chat(src, "<span class='xenowarning'>The decking is too hard to tunnel through!</span>")
		return

	if(T.density)
		to_chat(src, "<span class='xenowarning'>You can't tunnel into a solid wall!</span>")
		return

	if(istype(T, /turf/open/space))
		to_chat(src, "<span class='xenowarning'>You can't tunnel there!</span>")
		return

	for(var/obj/O in T.contents)
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				continue
			to_chat(src, "<span class='warning'>There's something solid there to stop you emerging.</span>")
			return

	if (tunnel)
		tunnel = 0
		to_chat(src, SPAN_NOTICE("You stop tunneling."))
		used_tunnel = 1
		do_tunnel_cooldown()
		return

	if (!T || T.density)
		to_chat(src, SPAN_NOTICE("You cannot tunnel to there!"))
	//to_world("process_tunnel")
	tunnel = 1
	to_chat(src, SPAN_NOTICE("You start tunneling!"))
	tunnel_timer = (get_dist(src, T)*10) + world.timeofday
	process_tunnel(T)


/mob/living/carbon/Xenomorph/proc/process_tunnel(var/turf/T)
	set background = 1

	spawn while (tunnel && T)
		if (world.timeofday > tunnel_timer)
			tunnel = 0
			do_tunnel(T)
		sleep(10)	// Process every second.

/mob/living/carbon/Xenomorph/proc/do_tunnel(var/turf/T)
	to_chat(src, SPAN_NOTICE("You tunnel to your destination."))
	anchored = 0
	frozen = 0
	update_canmove()
	//to_world("do_tunnel from [loc.x],[loc.y],[loc.z] to [T.x],[T.y],[T.z]")
	forceMove(T)
	burrow = 0
	burrow_off()

/mob/living/carbon/Xenomorph/proc/do_tunnel_cooldown()
	spawn(caste.tunnel_cooldown)
		used_tunnel = 0
		to_chat(src, SPAN_NOTICE("You can now tunnel while burrowed."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
	if(burrow)
		to_chat(src, SPAN_NOTICE("You must be above ground to do this."))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, "<span class='xenowarning'>Your aren't ready to cause more tremors yet!</span>")
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message("<span class='xenodanger'>[src] digs itself into the ground and shakes the earth itself, causing violent tremors!</span>", \
	"<span class='xenodanger'>You dig into the ground and shake it around, causing violent tremors!</span>")
	create_stomp() //Adds the visual effect. Wom wom wom
	used_tremor = 1

	for(var/mob/living/carbon/M in range(7, loc))
		to_chat(M, "<span class='warning'>You struggle to remain on your feet as the ground shakes beneath your feet!</span>")
		shake_camera(M, 2, 3)

	for(var/mob/living/carbon/human/H in range(3, loc))
		to_chat(H, "<span class='warning'>The violent tremors make you lose your footing!</span>")
		H.KnockDown(1)

	spawn(caste.tremor_cooldown)
		used_tremor = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to cause more tremors again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

// Ravager spin slash
/mob/living/carbon/Xenomorph/proc/spin_slash()
	var/datum/caste_datum/ravager/rCaste = src.caste

	if (!check_state())
		return

	if (used_lunge)
		to_chat(src, SPAN_XENOWARNING("You must gather your strength before using your spin slash again."))
		return

	if (!check_plasma(60))
		to_chat(src, SPAN_XENOWARNING("You don't have enough plasma! You need [60-src.plasma_stored] more.</span>"))
		return
	
	visible_message(SPAN_XENOWARNING("[src] lashes out with its sycthe-like claws!"), SPAN_XENOWARNING("You unleash a flurry of slashes around you!"))

	spin_circle()

	var/sweep_range = 1
	var/list/L = orange(sweep_range)	
	// Spook patrol 
	src.emote("roar")	

	for (var/mob/living/carbon/human/H in L)
		if(H != H.handle_barriers(src)) continue
		if(H.stat == DEAD) continue
		if(istype(H.buckled, /obj/structure/bed/nest)) continue
		step_away(H, src, sweep_range, 3)
		
		// MOST of the time, hit our target zone. 
		var/target_zone = ran_zone("chest", 75)
		var/armor = H.getarmor(target_zone, ARMOR_MELEE)
		var/damage = armor_damage_reduction(config.marine_melee, rand(rCaste.melee_damage_lower, rCaste.melee_damage_upper)+rCaste.spin_damage_offset, armor, 10)
		
		H.apply_damage(damage, BRUTE, target_zone)
		shake_camera(H, 2, 1)
		H.KnockDown(2, 1)

		to_chat(H, SPAN_DANGER("You are slashed by \the [src]'s claws!"))
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	used_lunge = 1
	use_plasma(60)

	spawn(rCaste.spin_cooldown)
		used_lunge = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to use your spin slash again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()



// Vent Crawl
/mob/living/carbon/Xenomorph/proc/vent_crawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Alien"
	if(!check_state() || !can_ventcrawl())
		return
	var/pipe = start_ventcrawl()
	if(pipe)
		handle_ventcrawl(pipe)


/mob/living/carbon/Xenomorph/proc/xeno_transfer_plasma(atom/A, amount = 50, transfer_delay = 20, max_range = 2)
	if(!istype(A, /mob/living/carbon/Xenomorph))
		return
	var/mob/living/carbon/Xenomorph/target = A

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't transfer plasma from here!</span>")
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, "<span class='warning'>You need to be closer to [target].</span>")
		return

	to_chat(src, SPAN_NOTICE("You start focusing your plasma towards [target]."))
	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't transfer plasma from here!</span>")
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, "<span class='warning'>You need to be closer to [target].</span>")
		return

	if(plasma_stored < amount)
		amount = plasma_stored //Just use all of it
	use_plasma(amount)
	target.gain_plasma(amount)
	to_chat(target, "<span class='xenowarning'>\The [src] has transfered [amount] plasma to you. You now have [target.plasma_stored].</span>")
	to_chat(src, "<span class='xenowarning'>You have transferred [amount] plasma to \the [target]. You now have [plasma_stored].</span>")
	playsound(src, "alien_drool", 25)

/mob/living/carbon/Xenomorph/proc/xeno_transfer_health(atom/A, amount = 40, transfer_delay = 50, max_range = 1)
	if(!istype(A, /mob/living/carbon/Xenomorph))
		return
	var/mob/living/carbon/Xenomorph/target = A

	if(target == src)
		to_chat(src, "You can't heal yourself!")
		return

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't transfer health from here!</span>")
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, "<span class='warning'>You need to be closer to [target].</span>")
		return

	to_chat(src, SPAN_NOTICE("You start transfering some of your health towards [target]."))
	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 10))
		return

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't transfer health from here!</span>")
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, "<span class='warning'>You need to be closer to [target].</span>")
		return

	bruteloss += amount * 1.5
	target.gain_health(amount)
	to_chat(target, "<span class='xenowarning'>\The [src] has transfered some of their health to you. You feel reinvigorated!</span>")
	to_chat(src, "<span class='xenowarning'>You have transferred some of your health to \the [target]. You feel weakened...</span>")
	playsound(src, "alien_drool", 25)


//Note: All the neurotoxin projectile items are stored in XenoProcs.dm
/mob/living/carbon/Xenomorph/proc/xeno_spit(atom/T)

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't spit from here!</span>")
		return

	if(has_spat > world.time)
		to_chat(src, "<span class='warning'>You must wait for your spit glands to refill.</span>")
		return

	if(!check_plasma(ammo.spit_cost))
		return

	var/turf/current_turf = get_turf(src)

	if(!current_turf)
		return

	visible_message("<span class='xenowarning'>\The [src] spits at \the [T]!</span>", \
	"<span class='xenowarning'>You spit at \the [T]!</span>" )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(src.loc, sound_to_play, 25, 1)

	var/obj/item/projectile/A = new /obj/item/projectile(current_turf)
	A.generate_bullet(ammo)
	A.permutated += src
	A.def_zone = get_limbzone_target()
	A.fire_at(T, src, null, ammo.max_range, ammo.shell_speed)
	has_spat = world.time + caste.spit_delay + ammo.added_spit_delay
	use_plasma(ammo.spit_cost)
	cooldown_notification(caste.spit_delay + ammo.added_spit_delay, "spit")

	return TRUE

/mob/living/carbon/Xenomorph/proc/cooldown_notification(cooldown, message)
	set waitfor = 0
	sleep(cooldown)
	switch(message)
		if("spit")
			to_chat(src, SPAN_NOTICE("You feel your neurotoxin glands swell with ichor. You can spit again."))
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()



/mob/living/carbon/Xenomorph/proc/build_resin(atom/A, resin_plasma_cost)
	if (action_busy)
		return
	if (!check_state())
		return
	if (!check_plasma(resin_plasma_cost))
		return

	var/turf/current_turf = get_turf(A)

	if (get_dist(src, A) > src.caste.max_build_dist) // Hivelords have max_build_dist of 1, drones and queens 0
		current_turf = get_turf(src)
	else if (isXenoHivelord(src)) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(A, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/WR = A
			if(WR.walltype == WALL_RESIN)
				var/prev_old_turf = WR.old_turf
				WR.ChangeTurf(/turf/closed/wall/resin/thick)
				WR.old_turf = prev_old_turf
			else if(WR.walltype == WALL_MEMBRANE)
				var/prev_old_turf = WR.old_turf
				WR.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				WR.old_turf = prev_old_turf
			else
				to_chat(src, SPAN_XENOWARNING("[WR] can't be made thicker."))
				return
			thickened = TRUE

		else if(istype(A, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/DR = A
			if(DR.hardness == 1.5) //non thickened
				var/oldloc = DR.loc
				qdel(DR)
				new /obj/structure/mineral_door/resin/thick (oldloc)
			else
				to_chat(src, SPAN_XENOWARNING("[DR] can't be made thicker."))
				return
			thickened = TRUE

		if (thickened)
			visible_message(SPAN_XENONOTICE("\The [src] regurgitates a thick substance and thickens [A]."), \
				SPAN_XENONOTICE("You regurgitate some resin and thicken [A]."), null, 5)
			use_plasma(resin_plasma_cost)
			playsound(loc, "alien_resin_build", 25)
			A.add_hiddenprint(src) //so admins know who thickened the walls
			return

	var/mob/living/carbon/Xenomorph/blocker = locate() in current_turf
	if(blocker && blocker != src && blocker.stat != DEAD)
		to_chat(src, SPAN_WARNING("Can't do that with [blocker] in the way!"))
		return

	if(!istype(current_turf) || !current_turf.is_weedable())
		to_chat(src, SPAN_WARNING("You can't do that here."))
		return

	var/area/AR = get_area(current_turf)
	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2)) //Bandaid for atmospherics bug when Xenos build around the shuttles
		to_chat(src, SPAN_WARNING("You sense this is not a suitable area for expanding the hive."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(src, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return

	if(!check_alien_construction(current_turf))
		return

	if(selected_resin == RESIN_DOOR)
		var/wall_support = FALSE
		for(var/D in cardinal)
			var/turf/T = get_step(current_turf,D)
			if(T)
				if(T.density)
					wall_support = TRUE
					break
				else if(locate(/obj/structure/mineral_door/resin) in T)
					wall_support = TRUE
					break
		if(!wall_support)
			to_chat(src, SPAN_WARNING("Resin doors need a wall or resin door next to them to stand up."))
			return

	var/wait_time = src.caste.build_time

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	blocker = locate() in current_turf
	if(blocker && blocker != src && blocker.stat != DEAD)
		return

	if(!check_state())
		return
	if(!check_plasma(resin_plasma_cost))
		return

	if(!istype(current_turf) || !current_turf.is_weedable())
		return

	AR = get_area(current_turf)
	if(istype(AR,/area/shuttle/drop1/lz1 || istype(AR,/area/shuttle/drop2/lz2))) //Bandaid for atmospherics bug when Xenos build around the shuttles
		return

	alien_weeds = locate() in current_turf
	if(!alien_weeds)
		return

	if(!check_alien_construction(current_turf))
		return

	if(selected_resin == RESIN_DOOR)
		var/wall_support = FALSE
		for(var/D in cardinal)
			var/turf/T = get_step(current_turf,D)
			if(T)
				if(T.density)
					wall_support = TRUE
					break
				else if(locate(/obj/structure/mineral_door/resin) in T)
					wall_support = TRUE
					break
		if(!wall_support)
			to_chat(src, SPAN_WARNING("Resin doors need a wall or resin door next to them to stand up."))
			return

	use_plasma(resin_plasma_cost)
	visible_message(SPAN_XENONOTICE("\The [src] regurgitates a thick substance and shapes it into \a [resin2text(selected_resin, isXenoHivelord(src))]!"), \
		SPAN_XENONOTICE("You regurgitate some resin and shape it into \a [resin2text(selected_resin, isXenoHivelord(src))]."), null, 5)
	playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin

	switch(selected_resin)
		if(RESIN_DOOR)
			if (isXenoHivelord(src))
				new_resin = new /obj/structure/mineral_door/resin/thick(current_turf)
			else
				new_resin = new /obj/structure/mineral_door/resin(current_turf)
		if(RESIN_WALL)
			if (isXenoHivelord(src))
				current_turf.ChangeTurf(/turf/closed/wall/resin/thick)
			else
				current_turf.ChangeTurf(/turf/closed/wall/resin)
			new_resin = current_turf
		if(RESIN_MEMBRANE)
			if (isXenoHivelord(src))
				current_turf.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				current_turf.ChangeTurf(/turf/closed/wall/resin/membrane)
			new_resin = current_turf
		if(RESIN_NEST)
			new_resin = new /obj/structure/bed/nest(current_turf)
		if(RESIN_STICKY)
			new_resin = new /obj/effect/alien/resin/sticky(current_turf)

	new_resin.add_hiddenprint(src) //so admins know who placed it


//Corrosive acid is consolidated -- it checks for specific castes for strength now, but works identically to each other.
//The acid items are stored in XenoProcs.
/mob/living/carbon/Xenomorph/proc/corrosive_acid(atom/O, acid_type, plasma_cost)

	if(!O.Adjacent(src))
		to_chat(src, "<span class='warning'>\The [O] is too far away.</span>")
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You can't melt [O] from here!</span>")
		return

	face_atom(O)

	var/wait_time = 10

	//OBJ CHECK
	if(isobj(O))
		var/obj/I = O

		if(I.unacidable || istype(I, /obj/machinery/computer) || istype(I, /obj/effect)) //So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
			to_chat(src, "<span class='warning'>You cannot dissolve \the [I].</span>") // ^^ Note for obj/effect.. this might check for unwanted stuff. Oh well
			return
		if(istype(O, /obj/structure/window_frame))
			var/obj/structure/window_frame/WF = O
			if(WF.reinforced && acid_type != /obj/effect/xenomorph/acid/strong)
				to_chat(src, "<span class='warning'>This [O.name] is too tough to be melted by your weak acid.</span>")
				return

		if(O.density || istype(O, /obj/structure))
			wait_time = 40 //dense objects are big, so takes longer to melt.

	//TURF CHECK
	else if(isturf(O))
		var/turf/T = O

		if(istype(O, /turf/closed/wall))
			var/turf/closed/wall/wall_target = O
			if (wall_target.acided_hole)
				to_chat(src, "<span class='warning'>[O] is already weakened.</span>")
				return

		var/dissolvability = T.can_be_dissolved()
		switch(dissolvability)
			if(0)
				to_chat(src, "<span class='warning'>You cannot dissolve \the [T].</span>")
				return
			if(1)
				wait_time = 50
			if(2)
				if(acid_type != /obj/effect/xenomorph/acid/strong)
					to_chat(src, "<span class='warning'>This [T.name] is too tough to be melted by your weak acid.</span>")
					return
				wait_time = 100
			else
				return
		to_chat(src, "<span class='xenowarning'>You begin generating enough acid to melt through \the [T].</span>")
	else
		to_chat(src, "<span class='warning'>You cannot dissolve \the [O].</span>")
		return

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	if(!check_state())
		return

	if(!O || !get_turf(O)) //Some logic.
		return

	if(!check_plasma(plasma_cost))
		return

	if(!O.Adjacent(src))
		return

	use_plasma(plasma_cost)

	var/obj/effect/xenomorph/acid/A = new acid_type(get_turf(O), O)

	if(istype(O, /obj/vehicle/multitile/root/cm_armored))
		var/obj/vehicle/multitile/root/cm_armored/R = O
		R.take_damage_type( (1 / A.acid_strength) * 20, "acid", src)
		visible_message("<span class='xenowarning'>\The [src] vomits globs of vile stuff at \the [O]. It sizzles under the bubbling mess of acid!</span>", \
			"<span class='xenowarning'>You vomit globs of vile stuff at \the [O]. It sizzles under the bubbling mess of acid!</span>", null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		sleep(20)
		qdel(A)
		return

	if(isturf(O))
		A.icon_state += "_wall"

	if(istype(O, /obj/structure) || istype(O, /obj/machinery)) //Always appears above machinery
		A.layer = O.layer + 0.1
	else //If not, appear on the floor or on an item
		A.layer = LOWER_ITEM_LAYER //below any item, above BELOW_OBJ_LAYER (smartfridge)

	A.add_hiddenprint(src)

	if(!isturf(O))
		msg_admin_attack("[src.name] ([src.ckey]) spat acid on [O].")
		attack_log += text("\[[time_stamp()]\] <font color='green'>Spat acid on [O]</font>")
	visible_message("<span class='xenowarning'>\The [src] vomits globs of vile stuff all over \the [O]. It begins to sizzle and melt under the bubbling mess of acid!</span>", \
	"<span class='xenowarning'>You vomit globs of vile stuff all over \the [O]. It begins to sizzle and melt under the bubbling mess of acid!</span>", null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)

/mob/living/carbon/Xenomorph/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of your current hive."
	set category = "Alien"

	if(!hive.living_xeno_queen)
		to_chat(src, "<span class='warning'>There is no Queen. You are alone.</span>")
		return

	if(isXenoQueen(src) && anchored)
		check_hive_status(src, anchored)
	else
		check_hive_status(src)


/proc/check_hive_status(mob/living/carbon/Xenomorph/user, var/anchored = 0)
	var/hivenumber = XENO_HIVE_NORMAL
	if(istype(user)) // cover calling it without parameters
		hivenumber = user.hivenumber
	var/dat = "<html><head><title>Hive Status</title></head><body>"

	var/count = 0
	var/queen_list = ""
	//var/exotic_list = ""
	//var/exotic_count = 0
	var/boiler_list = ""
	var/boiler_count = 0
	var/burrower_list = ""
	var/burrower_count = 0
	var/crusher_list = ""
	var/crusher_count = 0
	var/praetorian_list = ""
	var/praetorian_count = 0
	var/ravager_list = ""
	var/ravager_count = 0
	var/carrier_list = ""
	var/carrier_count = 0
	var/hivelord_list = ""
	var/hivelord_count = 0
	var/warrior_list = ""
	var/warrior_count = 0
	var/hunter_list = ""
	var/hunter_count = 0
	var/spitter_list = ""
	var/spitter_count = 0
	var/drone_list = ""
	var/drone_count = 0
	var/runner_list = ""
	var/runner_count = 0
	var/sentinel_list = ""
	var/sentinel_count = 0
	var/defender_list = ""
	var/defender_count = 0
	var/larva_list = ""
	var/larva_count = 0
	var/stored_larva_count = hive_datum[hivenumber].stored_larva
	var/leader_list = ""

	for(var/mob/living/carbon/Xenomorph/X in living_mob_list)
		if(!istype(X)) continue //ignore non-xenos, just in case
		if(X.z == ADMIN_Z_LEVEL) continue //don't show xenos in the thunderdome when admins test stuff.
		if(istype(user)) // cover calling it without parameters
			if(X.hivenumber != hivenumber)
				continue // not our hive
		var/area/A = get_area(X)

		var/leader = ""

		if(X in X.hive.xeno_leader_list)
			leader = "<b>(-L-)</b>"

		var/xenoinfo
		if(user && anchored && X != user)
			xenoinfo = "<tr><td>[leader]<a href=?src=\ref[user];watch_xeno_number=[X.nicknumber]>[X.name]</a> "
		else if(user && isobserver(user))
			xenoinfo = "<tr><td>[leader]<a href=?src=\ref[user];track=\ref[X]>[X.name]</a> "
		else
			xenoinfo = "<tr><td>[leader][X.name] "
		if(!X.client) xenoinfo += " <i>(SSD)</i>"

		count++ //Dead players shouldn't be on this list
		xenoinfo += " <b><font color=green>([A ? A.name : null])</b></td></tr>"

		if(leader != "")
			leader_list += xenoinfo

		switch(X.caste.caste_name)
			if("Queen")
				queen_list += xenoinfo
			if("Boiler")
				if(leader == "") boiler_list += xenoinfo
				boiler_count++
			if("Burrower")
				if(leader == "") burrower_list += xenoinfo
				burrower_count++
			if("Crusher")
				if(leader == "") crusher_list += xenoinfo
				crusher_count++
			if("Praetorian")
				if(leader == "") praetorian_list += xenoinfo
				praetorian_count++
			if("Ravager")
				if(leader == "") ravager_list += xenoinfo
				ravager_count++
			if("Carrier")
				if(leader == "") carrier_list += xenoinfo
				carrier_count++
			if("Hivelord")
				if(leader == "") hivelord_list += xenoinfo
				hivelord_count++
			if ("Warrior")
				if (leader == "") warrior_list += xenoinfo
				warrior_count++
			if("Lurker")
				if(leader == "") hunter_list += xenoinfo
				hunter_count++
			if("Spitter")
				if(leader == "") spitter_list += xenoinfo
				spitter_count++
			if("Drone")
				if(leader == "") drone_list += xenoinfo
				drone_count++
			if("Runner")
				if(leader == "") runner_list += xenoinfo
				runner_count++
			if("Sentinel")
				if(leader == "") sentinel_list += xenoinfo
				sentinel_count++
			if ("Defender")
				if (leader == "")
					defender_list += xenoinfo
				defender_count++
			if("Bloody Larva") // all larva are caste = blood larva
				if(leader == "") larva_list += xenoinfo
				larva_count++

	dat += "<b>Total Living Sisters: [count]</b><BR>"
	//if(exotic_count != 0) //Exotic Xenos in the Hive like Predalien or Xenoborg
		//dat += "<b>Ultimate Tier:</b> [exotic_count] Sisters</b><BR>"
	dat += "<b>Tier 3: [boiler_count + crusher_count + praetorian_count + ravager_count] Sisters</b> | Boilers: [boiler_count] | Crushers: [crusher_count] | Praetorians: [praetorian_count] | Ravagers: [ravager_count]<BR>"
	dat += "<b>Tier 2: [carrier_count + burrower_count + hivelord_count + hunter_count + spitter_count + warrior_count] Sisters</b> | Burrowers: [burrower_count] | Carriers: [carrier_count] | Hivelords: [hivelord_count] | Warriors: [warrior_count] | Lurkers: [hunter_count] | Spitters: [spitter_count]<BR>"
	dat += "<b>Tier 1: [drone_count + runner_count + sentinel_count + defender_count] Sisters</b> | Drones: [drone_count] | Runners: [runner_count] | Sentinels: [sentinel_count] | Defenders: [defender_count]<BR>"
	dat += "<b>Larvas: [larva_count] Sisters</b><BR>"
	dat += "<b>Burrowed Larva: [stored_larva_count] Sisters</b><BR>"
	dat += "<table cellspacing=4>"
	dat += queen_list + leader_list + boiler_list + burrower_list + crusher_list + praetorian_list + ravager_list + carrier_list + hivelord_list + warrior_list + hunter_list + spitter_list + drone_list + runner_list + sentinel_list + defender_list + larva_list
	dat += "</table></body>"


	dat += "<b>Hive mutators:</b><BR>"
	if(!hive_datum[hivenumber].mutators.purchased_mutators || !hive_datum[hivenumber].mutators.purchased_mutators.len)
		dat += "-<BR>"
	else
		for(var/m in hive_datum[hivenumber].mutators.purchased_mutators)
			dat += "- [m]<BR>"
	usr << browse(dat, "window=roundstatus;size=500x500")


/mob/living/carbon/Xenomorph/verb/toggle_xeno_mobhud()
	set name = "Toggle Xeno Status HUD"
	set desc = "Toggles the health and plasma hud appearing above Xenomorphs."
	set category = "Alien"

	xeno_mobhud = !xeno_mobhud
	var/datum/mob_hud/H = huds[MOB_HUD_XENO_STATUS]
	if(xeno_mobhud)
		H.add_hud_to(usr)
	else
		H.remove_hud_from(usr)


/mob/living/carbon/Xenomorph/verb/middle_mousetoggle()
	set name = "Toggle Middle/Shift Clicking"
	set desc = "Toggles between using middle mouse click and shift click for selected abilitiy use."
	set category = "Alien"

	middle_mouse_toggle = !middle_mouse_toggle
	if(!middle_mouse_toggle)
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with shift clicking."))
	else
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with middle mouse clicking."))

/mob/living/carbon/Xenomorph/verb/directional_attacktoggle()
	set name = "Toggle Directional Attacks"
	set desc = "Toggles the use of directional assist attacks."
	set category = "Alien"

	directional_attack_toggle = !directional_attack_toggle
	if(!directional_attack_toggle)
		to_chat(src, SPAN_NOTICE("Attacks will no longer use directional assist."))
	else
		to_chat(src, SPAN_NOTICE("Attacks will now use directional assist."))