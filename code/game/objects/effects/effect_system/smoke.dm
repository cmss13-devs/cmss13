/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	layer = ABOVE_MOB_LAYER + 0.1 //above mobs and barricades
	var/amount = 2
	var/spread_speed = 1 //time in decisecond for a smoke to spread one tile.
	var/time_to_live = 8
	var/smokeranking = SMOKE_RANK_HARMLESS //Override priority. A higher ranked smoke cloud will displace lower and equal ones on spreading.
	var/source = null
	var/source_mob = null

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/particle_effect/smoke/New(loc, oldamount, new_source, new_source_mob)
	..()
	if(oldamount)
		amount = oldamount - 1
	source = new_source
	source_mob = new_source_mob
	time_to_live += rand(-1,1)
	active_smoke_effects += src

/obj/effect/particle_effect/smoke/Destroy()
	. = ..()
	if(opacity)
		SetOpacity(0)
	active_smoke_effects -= src

/obj/effect/particle_effect/smoke/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_SMOKE

/obj/effect/particle_effect/smoke/process()
	time_to_live--
	if(time_to_live <= 0)
		qdel(src)
		return
	else if(time_to_live == 1)
		alpha = 180
		amount = 0
		SetOpacity(0)

	apply_smoke_effect(get_turf(src))

/obj/effect/particle_effect/smoke/ex_act(severity)
	if( prob(severity/EXPLOSION_THRESHOLD_LOW * 100) )
		qdel(src)

/obj/effect/particle_effect/smoke/Crossed(atom/movable/M)
	..()
	if(istype(M, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = M
		B.damage = (B.damage/2)
	if(iscarbon(M))
		affect(M)

/obj/effect/particle_effect/smoke/proc/apply_smoke_effect(turf/T)
	for(var/mob/living/L in T)
		affect(L)

/obj/effect/particle_effect/smoke/proc/spread_smoke(direction)
	set waitfor = 0
	sleep(spread_speed)
	if(QDELETED(src)) return
	var/turf/U = get_turf(src)
	if(!U) return
	for(var/i in cardinal)
		if(direction && i != direction)
			continue
		var/turf/T = get_step(U, i)
		if(check_airblock(U,T)) //smoke can't spread that way
			continue
		var/obj/effect/particle_effect/smoke/foundsmoke = locate() in T // Check for existing smoke and act accordingly
		if(foundsmoke)
			if(foundsmoke.smokeranking <= src.smokeranking)
				qdel(foundsmoke)
			else
				continue
		var/obj/effect/particle_effect/smoke/S = new type(T, amount, source, source_mob)
		S.dir = pick(cardinal)
		S.time_to_live = time_to_live
		if(S.amount>0)
			S.spread_smoke()


//proc to check if smoke can expand to another turf
/obj/effect/particle_effect/smoke/proc/check_airblock(turf/U, turf/T)
	if(!T)
		return FALSE
	if(T.density)
		return TRUE
	var/move_dir = 0
	for(var/obj/structure/obstacle in T)
		move_dir = get_dir(src, T)
		if(obstacle.BlockedPassDirs(src, move_dir))
			return TRUE


/obj/effect/particle_effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (istype(M))
		return 0
	return 1

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/bad
	time_to_live = 10
	smokeranking = SMOKE_RANK_LOW

/obj/effect/particle_effect/smoke/bad/Move()
	. = ..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/particle_effect/smoke/bad/affect(var/mob/living/carbon/M)
	..()
	if (M.internal != null && M.wear_mask && (M.wear_mask.flags_inventory & ALLOWINTERNALS))
		return
	else
		if(prob(20))
			M.drop_held_item()
		M.apply_damage(1, OXY)
		if(M.coughedtime != 1)
			M.coughedtime = 1
			if(ishuman(M)) //Humans only to avoid issues
				M.emote("cough")
			addtimer(VARSET_CALLBACK(M, coughedtime, 0), 2 SECONDS)

/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/sleepy
	smokeranking = SMOKE_RANK_MED

/obj/effect/particle_effect/smoke/sleepy/Move()
	. = ..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/particle_effect/smoke/sleepy/affect(mob/living/carbon/M as mob )
	if (!..())
		return 0

	M.drop_held_item()
	M:sleeping += 1
	if(M.coughedtime != 1)
		M.coughedtime = 1
		if(ishuman(M)) //Humans only to avoid issues
			M.emote("cough")
		addtimer(VARSET_CALLBACK(M, coughedtime, 0), 2 SECONDS)

/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"
	smokeranking = SMOKE_RANK_HIGH

/obj/effect/particle_effect/smoke/mustard/Move()
	. = ..()
	for(var/mob/living/carbon/human/R in get_turf(src))
		affect(R)

/obj/effect/particle_effect/smoke/mustard/affect(var/mob/living/carbon/human/R)
	..()
	R.burn_skin(0.75)
	if(R.coughedtime != 1)
		R.coughedtime = 1
		if(ishuman(R)) //Humans only to avoid issues
			R.emote("gasp")
		addtimer(VARSET_CALLBACK(R, coughedtime, 0), 2 SECONDS)
	R.updatehealth()
	return

/////////////////////////////////////////////
// Phosphorus Gas
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/phosphorus
	time_to_live = 10
	smokeranking = SMOKE_RANK_HIGH

/obj/effect/particle_effect/smoke/phosphorus/Move()
	. = ..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/particle_effect/smoke/phosphorus/affect(var/mob/living/carbon/M)
	..()
	if (M.internal != null && M.wear_mask && (M.wear_mask.flags_inventory & ALLOWINTERNALS))
		return
	else
		if(prob(20))
			M.drop_held_item()
		M.apply_damage(1, OXY)
		M.updatehealth()
		if(M.coughedtime != 1)
			M.coughedtime = 1
			if(ishuman(M)) //Humans only to avoid issues
				M.emote("cough")
			spawn (20)
				M.coughedtime = 0

	M.last_damage_source = source
	M.last_damage_mob = source_mob
	M.burn_skin(5)
	M.adjust_fire_stacks(5)
	M.IgniteMob()
	M.updatehealth()

//////////////////////////////////////
// FLASHBANG SMOKE
////////////////////////////////////

/obj/effect/particle_effect/smoke/flashbang
	name = "illumination"
	time_to_live = 4
	opacity = 0
	icon_state = "sparks"
	icon = 'icons/effects/effects.dmi'
	smokeranking = SMOKE_RANK_MED

/////////////////////////////////////////
// BOILER SMOKES
/////////////////////////////////////////

//Xeno acid smoke.
/obj/effect/particle_effect/smoke/xeno_burn
	time_to_live = 12
	color = "#86B028" //Mostly green?
	anchored = 1
	spread_speed = 7
	smokeranking = SMOKE_RANK_BOILER

	var/hivenumber = XENO_HIVE_NORMAL
	var/gas_damage = 20

/obj/effect/particle_effect/smoke/xeno_burn/Initialize(mapload, amount, source, source_mob)
	var/mob/living/carbon/Xenomorph/X = source_mob
	if (istype(X) && X.hivenumber)
		hivenumber = X.hivenumber

		set_hive_data(src, hivenumber)

	. = ..()


/obj/effect/particle_effect/smoke/xeno_burn/apply_smoke_effect(turf/T)
	..()
	for(var/obj/structure/barricade/B in T)
		B.take_acid_damage(XENO_ACID_BARRICADE_DAMAGE)

	for(var/obj/vehicle/multitile/R in T)
		R.take_damage_type(20, "acid")

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_burn/Crossed(mob/living/carbon/M as mob)
	return

/obj/effect/particle_effect/smoke/xeno_burn/affect(var/mob/living/carbon/M)
	..()

	if(M.allied_to_hivenumber(hivenumber))
		return

	if(isYautja(M) && prob(75))
		return
	if(M.stat == DEAD)
		return
	if(istype(M.buckled, /obj/structure/bed/nest) && M.status_flags & XENO_HOST)
		return

	M.last_damage_source = source
	M.last_damage_mob = source_mob

	M.apply_damage(3, OXY) //Basic oxyloss from "can't breathe"

	if(isXeno(M))
		M.apply_damage(gas_damage * XVX_ACID_DAMAGEMULT, BURN) //Inhalation damage
	else
		M.apply_damage(gas_damage, BURN) //Inhalation damage

	if(M.coughedtime != 1 && !M.stat && ishuman(M)) //Coughing/gasping
		M.coughedtime = 1
		if(prob(50))
			M.emote("cough")
		else
			M.emote("gasp")
		addtimer(VARSET_CALLBACK(M, coughedtime, 0), 1.5 SECONDS)

	//Topical damage (acid on exposed skin)
	to_chat(M, SPAN_DANGER("Your skin feels like it is melting away!"))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.apply_armoured_damage(amount*rand(15, 20), ARMOR_BIO, BURN) //Burn damage, randomizes between various parts //Amount corresponds to upgrade level, 1 to 2.5
	else
		M.burn_skin(5) //Failsafe for non-humans
	M.updatehealth()

//Xeno neurotox smoke.
/obj/effect/particle_effect/smoke/xeno_weak
	time_to_live = 12
	color = "#ffbf58" //Mustard orange?
	spread_speed = 7
	amount = 1 //Amount depends on Boiler upgrade!
	smokeranking = SMOKE_RANK_BOILER

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_weak/Crossed(mob/living/carbon/M as mob)
	return

/obj/effect/particle_effect/smoke/xeno_weak/affect(var/mob/living/carbon/M)
	..()
	if(isXeno(M))
		return
	if(isYautja(M) && prob(75))
		return
	if(M.stat == DEAD)
		return
	if(istype(M.buckled, /obj/structure/bed/nest) && M.status_flags & XENO_HOST)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return

	var/effect_amt = round(6 + amount*6)

	M.apply_damage(9, OXY) //Causes even more oxyloss damage due to neurotoxin locking up respiratory system
	M.ear_deaf = max(M.ear_deaf, round(effect_amt*1.5)) //Paralysis of hearing system, aka deafness
	if(!M.eye_blind) //Eye exposure damage
		to_chat(M, SPAN_DANGER("Your eyes sting. You can't see!"))
	M.eye_blurry = max(M.eye_blurry, effect_amt)
	M.eye_blind = max(M.eye_blind, round(effect_amt/3))
	if(M.coughedtime != 1 && !M.stat) //Coughing/gasping
		M.coughedtime = 1
		if(prob(50))
			M.emote("cough")
		else
			M.emote("gasp")
		addtimer(VARSET_CALLBACK(M, coughedtime, 0), 1.5 SECONDS)
	if (prob(20))
		M.KnockDown(1)

	//Topical damage (neurotoxin on exposed skin)
	to_chat(M, SPAN_DANGER("Your body is going numb, almost as if paralyzed!"))
	if(prob(40 + round(amount*15))) //Highly likely to drop items due to arms/hands seizing up
		M.drop_held_item()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.temporary_slowdown = max(H.temporary_slowdown, round(effect_amt*1.5)) //One tick every two second
		H.recalculate_move_delay = TRUE

/obj/effect/particle_effect/smoke/xeno_weak_fire
	time_to_live = 16
	color = "#b33e1e"
	spread_speed = 7
	amount = 1
	smokeranking = SMOKE_RANK_BOILER

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_weak_fire/Crossed(var/mob/living/carbon/M as mob)
	if(!istype(M))
		return

	M.ExtinguishMob()
	. = ..()

/obj/effect/particle_effect/smoke/xeno_weak_fire/affect(var/mob/living/carbon/M)
	..()
	if(isXeno(M))
		return
	if(isYautja(M) && prob(75))
		return
	if(M.stat == DEAD)
		return
	if(istype(M.buckled, /obj/structure/bed/nest) && M.status_flags & XENO_HOST)
		return

	var/effect_amt = round(6 + amount*6)

	M.apply_damage(9, OXY) // MUCH harsher
	M.ear_deaf = max(M.ear_deaf, round(effect_amt*1.5)) //Paralysis of hearing system, aka deafness
	if(!M.eye_blind) //Eye exposure damage
		to_chat(M, SPAN_DANGER("Your eyes sting. You can't see!"))
	M.eye_blind = max(M.eye_blind, round(effect_amt/3))
	if(M.coughedtime != 1 && !M.stat) //Coughing/gasping
		M.coughedtime = 1
		if(prob(50))
			M.emote("cough")
		else
			M.emote("gasp")
		addtimer(VARSET_CALLBACK(M, coughedtime, 0), 1.5 SECONDS)
	if (prob(20))
		M.KnockDown(1)

	//Topical damage (neurotoxin on exposed skin)
	to_chat(M, SPAN_DANGER("Your body is going numb, almost as if paralyzed!"))
	if(prob(40 + round(amount*15))) //Highly likely to drop items due to arms/hands seizing up
		M.drop_held_item()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.temporary_slowdown = max(H.temporary_slowdown, 4) //One tick every two second
		H.recalculate_move_delay = TRUE

/obj/effect/particle_effect/smoke/xeno_weak_fire/spread_smoke(direction)
	set waitfor = 0
	sleep(spread_speed)
	if(QDELETED(src)) return
	var/turf/U = get_turf(src)
	if(!U) return
	for(var/i in cardinal)
		if(direction && i != direction)
			continue
		var/turf/T = get_step(U, i)
		if(check_airblock(U,T)) //smoke can't spread that way
			continue
		var/obj/effect/particle_effect/smoke/foundsmoke = locate() in T // Check for existing smoke and act accordingly
		if(foundsmoke)
			if(foundsmoke.smokeranking <= src.smokeranking)
				qdel(foundsmoke)
			else
				continue
		var/obj/effect/particle_effect/smoke/S = new type(T, amount, source, source_mob)

		for (var/atom/A in T)
			if (istype(A, /mob/living))
				var/mob/living/M = A
				M.ExtinguishMob()
			if(istype(A, /obj/flamer_fire))
				qdel(A)

		S.dir = pick(cardinal)
		S.time_to_live = time_to_live
		if(S.amount>0)
			S.spread_smoke()


/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect_system/smoke_spread
	var/amount = 3
	var/smoke_type = /obj/effect/particle_effect/smoke
	var/direction
	var/lifetime
	var/source = null
	var/source_mob = null

/datum/effect_system/smoke_spread/Destroy()
	source = null
	source_mob = null
	. = ..()

/datum/effect_system/smoke_spread/set_up(radius = 2, c = 0, loca, direct, smoke_time)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct
	if(lifetime)
		lifetime = smoke_time
	radius = min(radius, 10)
	amount = radius

/datum/effect_system/smoke_spread/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/S = new smoke_type(location, amount+1, source, source_mob)
	if(lifetime)
		S.time_to_live = lifetime
	if(S.amount)
		S.spread_smoke(direction)

/datum/effect_system/smoke_spread/bad
	smoke_type = /obj/effect/particle_effect/smoke/bad

/datum/effect_system/smoke_spread/sleepy
	smoke_type = /obj/effect/particle_effect/smoke/sleepy

/datum/effect_system/smoke_spread/mustard
	smoke_type = /obj/effect/particle_effect/smoke/mustard

/datum/effect_system/smoke_spread/phosphorus
	smoke_type = /obj/effect/particle_effect/smoke/phosphorus

// XENO SMOKES

/datum/effect_system/smoke_spread/xeno_acid
	smoke_type = /obj/effect/particle_effect/smoke/xeno_burn

/datum/effect_system/smoke_spread/xeno_weaken
	smoke_type = /obj/effect/particle_effect/smoke/xeno_weak

/datum/effect_system/smoke_spread/xeno_extinguish_fire
	smoke_type = /obj/effect/particle_effect/smoke/xeno_weak_fire

/datum/effect_system/smoke_spread/xeno_extinguish_fire/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/S = new smoke_type(location, amount+1, source, source_mob)

	for (var/atom/A in location)
		if (istype(A, /mob/living))
			var/mob/living/M = A
			M.ExtinguishMob()
		if(istype(A, /obj/flamer_fire))
			qdel(A)

	if(lifetime)
		S.time_to_live = lifetime
	if(S.amount)
		S.spread_smoke(direction)
