/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/particle_effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	icon_state = ""
	opacity = FALSE
	time_to_live = 300
	anchored = TRUE
	smokeranking = SMOKE_RANK_HIGH
	alpha = 100

/obj/effect/particle_effect/smoke/chem/Initialize()
	. = ..()
	create_reagents(500)

/obj/effect/particle_effect/smoke/chem/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_SMOKE


/datum/effect_system/smoke_spread/chem
	smoke_type = /obj/effect/particle_effect/smoke/chem
	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density
	var/static/last_reaction_signature

/datum/effect_system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	chemholder.create_reagents(500)

//------------------------------------------
//Sets up the chem smoke effect
//
// Calculates the max range smoke can travel, then gets all turfs in that view range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to make
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/set_up(datum/reagents/carry = null, n = 10, c = 0, loca, direct, datum/cause_data/new_cause_data)
	cause_data = istype(new_cause_data) ? new_cause_data : cause_data
	range = n * 0.3
	cardinals = c
	carry.copy_to(chemholder, carry.total_volume)

	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(!location)
		return

	targetTurfs = new()

	//build affected area list
	FOR_DVIEW(var/turf/T, range, location, HIDE_INVISIBLE_OBSERVER)
		//cull turfs to circle
		if(cheap_pythag(T.x - location.x, T.y - location.y) <= range)
			targetTurfs += T
	FOR_DVIEW_END

	//make secondary list for reagents that affect walls
	if(chemholder.reagents.has_reagent("thermite") || chemholder.reagents.has_reagent("plantbgone"))
		wallList = new()

	//pathing check
	smokeFlow(location, targetTurfs, wallList)

	//set the density of the cloud - for diluting reagents
	density = max(1, length(targetTurfs) / 4) //clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = ""
	for(var/reagent in carry.reagent_list)
		contained += " [reagent] "
	if(contained)
		contained = "\[[contained]\]"
	var/area/A = get_area(location)

	var/reaction_signature = "[time2text(world.timeofday, "hh:mm")]: ([A.name])[contained] by [carry.my_atom.fingerprintslast]"
	if(last_reaction_signature == reaction_signature)
		return
	last_reaction_signature = reaction_signature

	var/where = "[A.name]|[location.x], [location.y]"
	var/whereLink = "<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

	if(carry.my_atom.fingerprintslast)
		msg_admin_niche("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
		log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
	else
		msg_admin_niche("A chemical smoke reaction has taken place in ([whereLink])[contained]. No associated key.")
		log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")


//------------------------------------------
//Runs the chem smoke effect
//
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the moment).
// Also calculates target locations to spawn the visual smoke effect on, so the whole area
// is covered fairly evenly.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/start()

	if(!location) //kill grenade if it somehow ends up in nullspace
		return

	//reagent application - only run if there are extra reagents in the smoke
	if(length(chemholder.reagents.reagent_list))
		for(var/datum/reagent/R in chemholder.reagents.reagent_list)
			var/proba = 100
			var/runs = 5

			//dilute the reagents according to cloud density
			R.volume /= density
			chemholder.reagents.update_total()

			//apply wall affecting reagents to walls
			if(R.id in list("thermite", "plantbgone"))
				for(var/turf/T in wallList)
					R.reaction_turf(T, R.volume)

			//reagents that should be applied to turfs in a random pattern
			if(R.id == "carbon")
				proba = 75
			else if(R.id in list("blood", "radium", "uranium"))
				proba = 25
			else if(istype(R, /datum/reagent/generated)) //ensures custom chemicals will apply turf effects
				proba = 100

			spawn(0)
				for(var/i = 0, i < runs, i++)
					for(var/turf/T in targetTurfs)
						if(prob(proba))
							R.reaction_turf(T, R.volume)
						for(var/atom/A in T.contents)
							if(istype(A, /obj/effect/particle_effect/smoke/chem)) //skip the item if it is chem smoke
								continue
							else if(istype(A, /mob))
								var/dist = cheap_pythag(T.x - location.x, T.y - location.y)
								if(!dist)
									dist = 1
								var/mob/living/carbon/human/human_in_smoke = A
								if(istype(human_in_smoke))
									if(human_in_smoke?.wear_mask?.flags_inventory & BLOCKGASEFFECT)
										continue
									if(human_in_smoke?.glasses?.flags_inventory & BLOCKGASEFFECT)
										continue
									if(human_in_smoke?.head?.flags_inventory & BLOCKGASEFFECT)
										continue
								R.reaction_mob(A, volume = R.volume * POTENCY_MULTIPLIER_VLOW / dist, permeable = FALSE)
							else if(istype(A, /obj))
								R.reaction_obj(A, R.volume)
					sleep(3 SECONDS)


	//build smoke icon
	var/color = mix_color_from_reagents(chemholder.reagents.reagent_list)
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi', "smoke")
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")


	//distance between each smoke cloud
#define arcLength 2.3559


	//calculate positions for smoke coverage - then spawn smoke
	for(var/i = 0, i < range, i++)
		var/radius = i * 1.5
		if(!radius)
			INVOKE_ASYNC(src, PROC_REF(spawnSmoke), location, I, 1)
			continue

		var/offset = 0
		var/points = floor((radius * 2 * PI) / arcLength)
		var/angle = round(ToDegrees(arcLength / radius), 1)

		if(!IsInteger(radius))
			offset = 45 //degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/T = locate(x,y,location.z)
			if(!T)
				continue
			if(T in targetTurfs)
				INVOKE_ASYNC(src, PROC_REF(spawnSmoke), T, I, range)

#undef arcLength


//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/proc/spawnSmoke(turf/T, icon/I, dist = 1)
	var/obj/effect/particle_effect/smoke/chem/smoke = new(location)
	if(length(chemholder.reagents.reagent_list))
		chemholder.reagents.copy_to(smoke, chemholder.reagents.total_volume / dist, safety = 1) //copy reagents to the smoke so mob/breathe() can handle inhaling the reagents
	smoke.icon = I
	smoke.layer = FLY_LAYER
	smoke.setDir(pick(GLOB.cardinals))
	smoke.pixel_x = -32 + rand(-8,8)
	smoke.pixel_y = -32 + rand(-8,8)
	walk_to(smoke, T)
	sleep(150+rand(0,20))
	fadeOut(smoke)
	qdel(smoke)

//------------------------------------------
// Fades out the smoke smoothly using it's alpha variable.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/proc/fadeOut(atom/A, frames = 16)
	var/step = A.alpha / frames
	for(var/i = 0, i < frames, i++)
		A.alpha -= step
		sleep(world.tick_lag)
	return

//------------------------------------------
// Smoke pathfinder. Uses a flood fill method based on zones to
// quickly check what turfs the smoke (airflow) can actually reach.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/proc/smokeFlow()

	var/list/pending = new()
	var/list/complete = new()

	pending += location

	while(length(pending))
		for(var/turf/current in pending)
			for(var/D in GLOB.cardinals)
				var/turf/target = get_step(current, D)
				if(wallList)
					if(istype(target, /turf/closed/wall))
						if(!(target in wallList))
							wallList += target
						continue

				if(target in pending)
					continue
				if(target in complete)
					continue
				if(!(target in targetTurfs))
					continue
				if(target.density) //this is needed to stop chemsmoke from passing through thin window walls
					continue
				for(var/atom/movable/M in target)
					if(M.flags_atom & ON_BORDER)
						if(M.dir == get_dir(target, current))
							continue
					else if(M.density)
						continue
				pending += target

			pending -= current
			complete += current

	targetTurfs = complete

	return

/obj/effect/particle_effect/smoke/chem/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(!length(reagents?.reagent_list))
		return FALSE

	var/mob/living/carbon/human/human_in_smoke = affected_mob
	if(istype(human_in_smoke))
		if(human_in_smoke?.wear_mask?.flags_inventory & BLOCKGASEFFECT)
			return FALSE
		if(human_in_smoke?.glasses?.flags_inventory & BLOCKGASEFFECT)
			return FALSE
		if(human_in_smoke?.head?.flags_inventory & BLOCKGASEFFECT)
			return FALSE
	for(var/datum/reagent/reagent in reagents.reagent_list)
		reagent.reaction_mob(affected_mob, volume = reagent.volume * POTENCY_MULTIPLIER_LOW, permeable = FALSE)
	return TRUE
