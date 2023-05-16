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
/datum/effect_system/smoke_spread/chem/set_up(datum/reagents/carry = null, n = 10, c = 0, loca, direct)
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
	for(var/turf/current_turf in view(range, location))
		//cull turfs to circle
		if(cheap_pythag(current_turf.x - location.x, current_turf.y - location.y) <= range)
			targetTurfs += current_turf

	//make secondary list for reagents that affect walls
	if(chemholder.reagents.has_reagent("thermite") || chemholder.reagents.has_reagent("plantbgone"))
		wallList = new()

	//pathing check
	smokeFlow(location, targetTurfs, wallList)

	//set the density of the cloud - for diluting reagents
	density = max(1, targetTurfs.len / 4) //clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = ""
	for(var/reagent in carry.reagent_list)
		contained += " [reagent] "
	if(contained)
		contained = "\[[contained]\]"
	var/area/current_area = get_area(location)

	var/where = "[current_area.name]|[location.x], [location.y]"
	var/whereLink = "<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

	if(carry.my_atom.fingerprintslast)
		message_admins("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
		log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
	else
		message_admins("A chemical smoke reaction has taken place in ([whereLink]). No associated key.")
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
	if(chemholder.reagents.reagent_list.len)
		for(var/datum/reagent/chem in chemholder.reagents.reagent_list)
			var/proba = 100
			var/runs = 5

			//dilute the reagents according to cloud density
			chem.volume /= density
			chemholder.reagents.update_total()

			//apply wall affecting reagents to walls
			if(chem.id in list("thermite", "plantbgone"))
				for(var/turf/current_turf in wallList)
					chem.reaction_turf(current_turf, chem.volume)

			//reagents that should be applied to turfs in a random pattern
			if(chem.id == "carbon")
				proba = 75
			else if(chem.id in list("blood", "radium", "uranium"))
				proba = 25
			else if(istype(chem, /datum/reagent/generated)) //ensures custom chemicals will apply turf effects
				proba = 100

			spawn(0)
				for(var/i = 0, i < runs, i++)
					for(var/turf/current_turf in targetTurfs)
						if(prob(proba))
							chem.reaction_turf(current_turf, chem.volume)
						for(var/atom/current_atom in current_turf.contents)
							if(istype(current_atom, /obj/effect/particle_effect/smoke/chem)) //skip the item if it is chem smoke
								continue
							else if(istype(current_atom, /mob))
								var/dist = cheap_pythag(current_turf.x - location.x, current_turf.y - location.y)
								if(!dist)
									dist = 1
								chem.reaction_mob(current_atom, volume = chem.volume / dist)
							else if(istype(current_atom, /obj))
								chem.reaction_obj(current_atom, chem.volume)
					sleep(30)


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
		var/points = round((radius * 2 * PI) / arcLength)
		var/angle = round(ToDegrees(arcLength / radius), 1)

		if(!IsInteger(radius))
			offset = 45 //degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/current_turf = locate(x,y,location.z)
			if(!current_turf)
				continue
			if(current_turf in targetTurfs)
				INVOKE_ASYNC(src, PROC_REF(spawnSmoke), current_turf, I, range)

#undef arcLength


//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/proc/spawnSmoke(turf/current_turf, icon/I, dist = 1)
	var/obj/effect/particle_effect/smoke/chem/smoke = new(location)
	if(chemholder.reagents.reagent_list.len)
		chemholder.reagents.copy_to(smoke, chemholder.reagents.total_volume / dist, safety = 1) //copy reagents to the smoke so mob/breathe() can handle inhaling the reagents
	smoke.icon = I
	smoke.layer = FLY_LAYER
	smoke.setDir(pick(cardinal))
	smoke.pixel_x = -32 + rand(-8,8)
	smoke.pixel_y = -32 + rand(-8,8)
	walk_to(smoke, current_turf)
	smoke.SetOpacity(1) //switching opacity on after the smoke has spawned, and then
	sleep(150+rand(0,20)) // turning it off before it is deleted results in cleaner
	if(smoke.opacity)
		smoke.SetOpacity(0)
	fadeOut(smoke)
	qdel(smoke)

//------------------------------------------
// Fades out the smoke smoothly using it's alpha variable.
//------------------------------------------
/datum/effect_system/smoke_spread/chem/proc/fadeOut(atom/current_atom, frames = 16)
	var/step = current_atom.alpha / frames
	for(var/i = 0, i < frames, i++)
		current_atom.alpha -= step
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

	while(pending.len)
		for(var/turf/current in pending)
			for(var/D in cardinal)
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
				for(var/atom/movable/movable_atom in target)
					if(movable_atom.flags_atom & ON_BORDER)
						if(movable_atom.dir == get_dir(target, current))
							continue
					else if(movable_atom.density)
						continue
				pending += target

			pending -= current
			complete += current

	targetTurfs = complete

	return
