//Some debug variables. Toggle them to 1 in order to see the related debug messages. Helpful when testing out formulas.
#define DEBUG_HIT_CHANCE	0
#define DEBUG_HUMAN_DEFENSE	0
#define DEBUG_XENO_DEFENSE	0

//The actual bullet objects.
/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "bullet"
	density = 0
	unacidable = TRUE
	anchored = 1 //You will not have me, space wind!
	flags_atom = NOINTERACT //No real need for this, but whatever. Maybe this flag will do something useful in the future.
	mouse_opacity = 0
	invisibility = 100 // We want this thing to be invisible when it drops on a turf because it will be on the user's turf. We then want to make it visible as it travels.
	layer = FLY_LAYER

	var/datum/ammo/ammo //The ammo data which holds most of the actual info.

	var/def_zone = "chest"	//So we're not getting empty strings.

	var/yo = null
	var/xo = null

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/current 		 = null
	var/atom/shot_from 	 = null // the object which shot us
	var/atom/original 	 = null // the original target clicked
	var/atom/firer 		 = null // Who shot it

	var/turf/target_turf = null
	var/turf/starting 	 = null // the projectile's starting turf

	var/turf/path[]  	 = null
	var/permutated[] 	 = null // we've passed through these atoms, don't try to hit them again

	var/damage = 0
	var/accuracy = 85 //Base projectile accuracy. Can maybe be later taken from the mob if desired.

	var/damage_falloff = 0 //how much effectiveness in damage the projectile loses per tiles travelled beyond the effective range
	var/damage_buildup = 0 //how much effectiveness in damage the projectile loses before the effective range

	var/effective_range_min	= 0	//What minimum range the projectile deals full damage, builds up the closer you get. 0 for no minimum. Set by the weapon.
	var/effective_range_max	= 0	//What maximum range the projectile deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum. Set by the weapon.

	var/scatter = 0

	var/distance_travelled = 0
	var/in_flight = 0

	var/projectile_override_flags = 0

	var/is_shrapnel

	var/datum/cause_data/weapon_cause_data

	var/mob/living/homing_target = null

	var/list/bullet_traits

/obj/item/projectile/Initialize(mapload, var/datum/cause_data/cause_data)
	. = ..(mapload)
	path = list()
	permutated = list()
	weapon_cause_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)
	firer = cause_data?.resolve_mob()

/obj/item/projectile/Destroy()
	in_flight = 0
	ammo = null
	shot_from = null
	original = null
	target_turf = null
	starting = null
	permutated = null
	path = null
	weapon_cause_data = null
	firer = null
	return ..()

/obj/item/projectile/proc/apply_bullet_trait(list/entry)
	bullet_traits += list(entry.Copy())
	// Need to use the proc instead of the wrapper because each entry is a list
	_AddElement(entry)

/obj/item/projectile/proc/give_bullet_traits(obj/item/projectile/to_give)
	for(var/list/entry in bullet_traits)
		to_give.apply_bullet_trait(entry.Copy())

/obj/item/projectile/Collided(atom/movable/AM)
	if(AM && !(AM in permutated))
		scan_a_turf(AM.loc)

/obj/item/projectile/Crossed(atom/movable/AM)
	if(AM && !(AM in permutated))
		scan_a_turf(get_turf(AM))


/obj/item/projectile/ex_act()
	return FALSE //We do not want anything to delete these, simply to make sure that all the bullet references are not runtiming. Otherwise, constantly need to check if the bullet exists.

/obj/item/projectile/proc/generate_bullet(ammo_datum, bonus_damage = 0, special_flags = 0)
	ammo 		= ammo_datum
	name 		= ammo.name
	icon_state 	= ammo.icon_state
	damage 		= ammo.damage + bonus_damage //Mainly for emitters.
	scatter		= ammo.scatter
	accuracy   += ammo.accuracy
	accuracy   *= rand(PROJ_VARIANCE_LOW-ammo.accuracy_var_low, PROJ_VARIANCE_HIGH+ammo.accuracy_var_high) * PROJ_BASE_ACCURACY_MULT//Rand only works with integers.
	damage     *= rand(PROJ_VARIANCE_LOW-ammo.damage_var_low, PROJ_VARIANCE_HIGH+ammo.damage_var_high) * PROJ_BASE_DAMAGE_MULT
	damage_falloff = ammo.damage_falloff
	damage_buildup = ammo.damage_buildup
	projectile_override_flags = special_flags

	// Apply bullet traits from ammo
	for(var/entry in ammo.traits_to_give)
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = ammo.traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + ammo.traits_to_give[entry]
		// Need to use the proc instead of the wrapper because each entry is a list
		apply_bullet_trait(L)

/obj/item/projectile/proc/calculate_damage()
	if(effective_range_min && distance_travelled < effective_range_min)
		return max(0, damage - round((effective_range_min - distance_travelled) * damage_buildup))
	else if(distance_travelled > effective_range_max)
		return max(0, damage - round((distance_travelled - effective_range_max) * damage_falloff))
	return damage

// Target, firer, shot from (i.e. the gun), projectile range, projectile speed, original target (who was aimed at, not where projectile is going towards), is_shrapnel (whether it should miss the firer or not)
/obj/item/projectile/proc/fire_at(atom/target, atom/F, atom/S, range = 30, speed = 1, atom/original_override, is_shrapnel = FALSE)
	if(!original)
		original = istype(original_override) ? original_override : target
	src.is_shrapnel = is_shrapnel
	if(!loc)
		if (!is_shrapnel)
			var/move_turf = get_turf(F)
			if(move_turf)
				forceMove(move_turf)
		else
			var/move_turf = get_turf(S)
			if(move_turf)
				forceMove(move_turf)
	starting = get_turf(src)
	if(starting != loc)
		forceMove(starting) //Put us on the turf, if we're not.

	target_turf = get_turf(target)
	if(!target_turf || !starting || target_turf == starting) //This shouldn't happen, but it can.
		qdel(src)
		return
	firer = F

	if(F && !is_shrapnel)
		permutated |= F //Don't hit the shooter (firer)
	else if (S && is_shrapnel)
		permutated |= S

	permutated |= src //Don't try to hit self.
	shot_from = S
	in_flight = 1

	setDir(get_dir(loc, target_turf))

	var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags
	if(round_statistics && ammo_flags & AMMO_BALLISTIC)
		round_statistics.total_projectiles_fired++
		if(ammo.bonus_projectiles_amount)
			round_statistics.total_projectiles_fired += ammo.bonus_projectiles_amount
	if(firer && ismob(firer) && weapon_cause_data)
		var/mob/M = firer
		M.track_shot(weapon_cause_data.cause_name)

	//If we have the right kind of ammo, we can fire several projectiles at once.
	if(ammo.bonus_projectiles_amount && ammo.bonus_projectiles_type)
		ammo.fire_bonus_projectiles(src)

	path = getline2(starting,target_turf)

	var/change_x = target_turf.x - starting.x
	var/change_y = target_turf.y - starting.y

	var/angle = round(Get_Angle(starting,target_turf))

	var/matrix/rotate = matrix() //Change the bullet angle.
	rotate.Turn(angle)
	apply_transform(rotate)

	var/homing_projectile = homing_target && ammo_flags & AMMO_HOMING
	if(homing_projectile)
		var/mob/living/ht = homing_target //Dead or friendly target can't get it, so the homing get stucks.
		if(ht.is_dead())
			homing_target = null
			homing_projectile = FALSE
		if(ishuman(ht))
			var/mob/living/carbon/human/H = ht
			if(SEND_SIGNAL(src, COMSIG_BULLET_CHECK_MOB_SKIPPING, H) & COMPONENT_SKIP_MOB\
				|| runtime_iff_group && H.get_target_lock(runtime_iff_group)\
			)
				homing_target = null
				homing_projectile = FALSE

	follow_flightpath(speed,change_x,change_y,range, homing_projectile) //pyew!

/obj/item/projectile/proc/each_turf(speed = 1)
	var/new_speed = speed
	distance_travelled++
	if(invisibility && distance_travelled > 1) invisibility = 0 //Let there be light (visibility).
	if(distance_travelled == round(ammo.max_range / 2) && loc) ammo.do_at_half_range(src)
	var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags
	if(ammo_flags & AMMO_ROCKET) //Just rockets for now. Not all explosive ammo will travel like this.
		switch(speed) //Get more speed the longer it travels. Travels pretty quick at full swing.
			if(1)
				if(distance_travelled > 2) new_speed++
			if(2)
				if(distance_travelled > 8) new_speed++
	return new_speed //Need for speed.

/obj/item/projectile/proc/follow_flightpath(speed = 1, change_x, change_y, range, homing = FALSE) //Everytime we reach the end of the turf list, we slap a new one and keep going.
	set waitfor = 0

	var/dist_since_sleep = 5 //Just so we always see the bullet.

	var/turf/current_turf = get_turf(src)
	var/turf/next_turf
	var/this_iteration = 0
	in_flight = 1

	for(next_turf in path)
		if(!loc || QDELETED(src) || !in_flight || !ammo)
			return

		if(distance_travelled >= range)
			ammo.do_at_max_range(src)
			qdel(src)
			return

		var/proj_dir = get_dir(current_turf, next_turf)
		if(proj_dir & (proj_dir-1)) //diagonal direction
			if(!current_turf.Adjacent(next_turf)) //we can't reach the next turf
				ammo.on_hit_turf(current_turf,src)
				current_turf.bullet_act(src)
				in_flight = 0
				sleep(0)
				qdel(src)
				return

		if(scan_a_turf(next_turf, proj_dir)) //We hit something! Get out of all of this.
			in_flight = 0
			sleep(0)
			qdel(src)
			return

		forceMove(next_turf)
		speed = each_turf(speed)

		this_iteration++
		if(++dist_since_sleep >= speed)
			//TO DO: Adjust flight position every time we see the projectile.
			//I wonder if I can leave sleep out and just have it stall based on adjustment proc.
			//Might still be too fast though.
			dist_since_sleep = 0
			sleep(1)

		current_turf = get_turf(src)

		if(homing && !QDELETED(homing_target) && path && this_iteration >= (length(path)/ 2))
			path = getline2(current_turf, homing_target)
			speed *= 2 // Bullet needs to become inescapable quicker otherwise you get stuck with wonky projectiles just following people about.
			if(length(path) > 0 && src)

				if(length(path) < speed) // The projectile "should" connect with the target next tick. Either way, it loses guidances.
					homing = FALSE

				distance_travelled--
				follow_flightpath(speed, change_x, change_y, range, homing) //Onwards!
				return
		if(path && this_iteration == path.len)
			next_turf = locate(current_turf.x + change_x, current_turf.y + change_y, current_turf.z)
			if(current_turf && next_turf)
				path = getline2(current_turf,next_turf) //Build a new flight path.
				if(path.len && src) //TODO look into this. This should always be true, but it can fail, apparently, against DCed people who fall down. Better yet, redo this.
					distance_travelled-- //because the new follow_flightpath() repeats the last step.
					follow_flightpath(speed, change_x, change_y, range) //Onwards!
				else
					qdel(src)
					return
			else //To prevent bullets from getting stuck in maps like WO.
				qdel(src)
				return

/obj/item/projectile/proc/scan_a_turf(turf/T, proj_dir)
	//Not actually flying? Should not be hitting anything.
	if(!in_flight)
		return FALSE
	// Not a turf, keep moving
	if(!istype(T))
		return FALSE

	if(T.density) // Handle wall hit
		var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags

		if(SEND_SIGNAL(src, COMSIG_BULLET_PRE_HANDLE_TURF, T) & COMPONENT_BULLET_PASS_THROUGH)
			return FALSE

		if(T.bullet_act(src))
			return TRUE

		// If the ammo should hit the surface of the target and the next turf is dense
		// The current turf is the "surface" of the target
		if(ammo_flags & AMMO_STRIKES_SURFACE)
			// We "hit" the current turf but strike the actual blockage
			ammo.on_hit_turf(get_turf(src),src)
		else
			ammo.on_hit_turf(T,src)

		if(SEND_SIGNAL(src, COMSIG_BULLET_POST_HANDLE_TURF, T) & COMPONENT_BULLET_PASS_THROUGH)
			return FALSE

		return TRUE

	// Firer's turf, keep moving
	if(firer && T == firer.loc && !is_shrapnel)
		return FALSE
	var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags

	var/hit_turf = FALSE
	// Explosive ammo always explodes on the turf of the clicked target
	// So does ammo that's flagged to always hit the target
	if(((ammo_flags & AMMO_EXPLOSIVE) || (ammo_flags & AMMO_HITS_TARGET_TURF)) && T == target_turf)
		hit_turf = TRUE

	if(ammo_flags & AMMO_SCANS_NEARBY && proj_dir)
		//this thing scans depending on dir
		var/cardinal_dir = get_perpen_dir(proj_dir)
		if(!cardinal_dir)
			var/d1 = proj_dir&(proj_dir-1)		// eg west		(1+8)&(8) = 8
			var/d2 = proj_dir - d1			// eg north		(1+8) - 8 = 1
			cardinal_dir = list(d1,d2)

		var/remote_detonation = 0
		var/kill_proj = 0

		for(var/ddir in cardinal_dir)
			var/dloc = get_step(T, ddir)
			var/turf/dturf = get_turf(dloc)
			for(var/atom/movable/dA in dturf)
				if(!isliving(dA))
					continue
				var/mob/living/dL = dA
				if(dL.is_dead())
					continue
				if(SEND_SIGNAL(src, COMSIG_BULLET_CHECK_MOB_SKIPPING, dL) & COMPONENT_SKIP_MOB\
					|| runtime_iff_group && dL.get_target_lock(runtime_iff_group)\
				)
					continue

				if(ammo_flags & AMMO_SKIPS_ALIENS && isXeno(dL))
					var/mob/living/carbon/Xenomorph/X = dL
					var/mob/living/carbon/Xenomorph/F = firer

					if (!istype(F))
						continue
					if (F.can_not_harm(X))
						continue
				remote_detonation = 1
				kill_proj = ammo.on_near_target(T, src)
				break
			if(remote_detonation)
				break

		if(kill_proj)
			return TRUE

	// Empty turf, keep moving
	if(!T.contents.len && !hit_turf)
		return FALSE

	for(var/atom/movable/clone/C in T) //Handle clones if there are any
		if(C.mstr)
			if(istype(C.mstr, /obj))
				if(handle_object(C.mstr))
					return TRUE
			else if(istype(C.mstr, /mob/living))
				if(handle_mob(C.mstr))
					return TRUE

	for(var/obj/O in T) //check objects before checking mobs, so that barricades protect
		if(handle_object(O))
			return TRUE

	for(var/mob/living/L in T)
		if(handle_mob(L))
			return TRUE

	if(hit_turf)
		ammo.on_hit_turf(T, src)

		if(T && T.loc)
			T.bullet_act(src)

		return TRUE

/obj/item/projectile/proc/handle_object(obj/O)
	// If we've already handled this atom, don't do it again
	if(O in permutated)
		return FALSE
	permutated |= O

	var/hit_chance = O.get_projectile_hit_boolean(src)
	if(hit_chance) // Calculated from combination of both ammo accuracy and gun accuracy
		SEND_SIGNAL(src, COMSIG_BULLET_PRE_HANDLE_OBJ, O)
		var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags

		// If we are a xeno shooting something
		if (istype(ammo, /datum/ammo/xeno) && isXeno(firer) && ammo.apply_delegate)
			var/mob/living/carbon/Xenomorph/X = firer
			if (X.behavior_delegate)
				var/datum/behavior_delegate/MD = X.behavior_delegate
				MD.ranged_attack_additional_effects_target(O)
				MD.ranged_attack_additional_effects_self(O)

		// If the ammo should hit the surface of the target and there is an object blocking
		// The current turf is the "surface" of the target
		if(ammo_flags & AMMO_STRIKES_SURFACE)
			var/turf/T = get_turf(O)

			// We "hit" the current turf but strike the actual blockage
			ammo.on_hit_turf(get_turf(src),src)
			T.bullet_act(src)
		else
			ammo.on_hit_obj(O,src)
			if(O && O.loc)
				O.bullet_act(src)
		. = TRUE

	if(SEND_SIGNAL(src, COMSIG_BULLET_POST_HANDLE_OBJ, O, .) & COMPONENT_BULLET_PASS_THROUGH)
		return FALSE

/obj/item/projectile/proc/handle_mob(mob/living/L)
	// If we've already handled this atom, don't do it again

	if(SEND_SIGNAL(src, COMSIG_BULLET_PRE_HANDLE_MOB, L, .) & COMPONENT_BULLET_PASS_THROUGH)
		return FALSE

	if((MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_ATTACK_DEAD) && L.stat == DEAD) || (L in permutated))
		return FALSE
	permutated |= L
	if((ammo.flags_ammo_behavior & (AMMO_XENO_ACID|AMMO_XENO_TOX|AMMO_XENO_BONE)) && L.stat == DEAD) //xeno ammo is NEVER meant to hit or damage dead people. If you want to add a xeno ammo that DOES then make a new flag that makes it ignore this check.
		return FALSE

	var/hit_chance = L.get_projectile_hit_chance(src)

	if(hit_chance) // Calculated from combination of both ammo accuracy and gun accuracy

		var/hit_roll = rand(1,100)

		if(original != L || hit_roll > hit_chance-base_miss_chance[def_zone]-20)	// If hit roll is high or the firer wasn't aiming at this mob, we still hit but now we might hit the wrong body part
			def_zone = rand_zone()
		else
			SEND_SIGNAL(firer, COMSIG_DIRECT_BULLET_HIT, L)
		hit_chance -= base_miss_chance[def_zone] // Reduce accuracy based on spot.

		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([L]) Hit chance: [hit_chance] | Roll: [hit_roll]"))
		#endif

		if(hit_chance > hit_roll)
			#if DEBUG_HIT_CHANCE
			to_world(SPAN_DEBUG("([L]) Hit."))
			#endif
			var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags

			// If the ammo should hit the surface of the target and there is a mob blocking
			// The current turf is the "surface" of the target
			if(ammo_flags & AMMO_STRIKES_SURFACE)
				var/turf/T = get_turf(L)

				// We "hit" the current turf but strike the actual blockage
				ammo.on_hit_turf(get_turf(src),src)
				T.bullet_act(src)
			else if(L && L.loc && (L.bullet_act(src) != -1))
				ammo.on_hit_mob(L,src, firer)

				// If we are a xeno shooting something
				if (istype(ammo, /datum/ammo/xeno) && isXeno(firer) && L.stat != DEAD && ammo.apply_delegate)
					var/mob/living/carbon/Xenomorph/X = firer
					if (X.behavior_delegate)
						var/datum/behavior_delegate/MD = X.behavior_delegate
						MD.ranged_attack_additional_effects_target(L)
						MD.ranged_attack_additional_effects_self(L)

				// If the thing we're hitting is a Xeno
				if (istype(L, /mob/living/carbon/Xenomorph))
					var/mob/living/carbon/Xenomorph/X = L
					if (X.behavior_delegate)
						X.behavior_delegate.on_hitby_projectile(ammo)

			. = TRUE
		else if(!L.lying)
			animatation_displace_reset(L)
			if(ammo.sound_miss) playsound_client(L.client, ammo.sound_miss, get_turf(L), 75, TRUE)
			L.visible_message(SPAN_AVOIDHARM("[src] misses [L]!"),
				SPAN_AVOIDHARM("[src] narrowly misses you!"), null, 4, CHAT_TYPE_TAKING_HIT)
			log_attack("[src] narrowly missed [key_name(L)]")

			var/mob/living/carbon/shotby = firer
			if(istype(shotby))
				L.attack_log += "[time_stamp()]\] [src], fired by [key_name(firer)], narrowly missed [key_name(L)]"
				shotby.attack_log += "[time_stamp()]\] [src], fired by [key_name(shotby)], narrowly missed [key_name(L)]"


		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([L]) Missed."))
		#endif

	if(SEND_SIGNAL(src, COMSIG_BULLET_POST_HANDLE_MOB, L, .) & COMPONENT_BULLET_PASS_THROUGH)
		return FALSE

//----------------------------------------------------------
				//				    	\\
				//  HITTING THE TARGET  \\
				//						\\
				//						\\
//----------------------------------------------------------


/obj/item/projectile/proc/get_effective_accuracy()
	#if DEBUG_HIT_CHANCE
	to_world(SPAN_DEBUG("Base accuracy is <b>[accuracy]</b>; scatter: <b>[scatter]</b>; distance: <b>[distance_travelled]</b>"))
	#endif

	var/effective_accuracy = accuracy //We want a temporary variable so accuracy doesn't change every time the bullet misses.
	var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags
	if(distance_travelled <= ammo.accurate_range)
		if(distance_travelled <= ammo.accurate_range_min) // If bullet stays within max accurate range + random variance
			effective_accuracy -= (ammo.accurate_range_min - distance_travelled) * 10 // Snipers have accuracy falloff at closer range before point blank
	else
		effective_accuracy -= (ammo_flags & AMMO_SNIPER) ? (distance_travelled * 1.5) : (distance_travelled * 10) // Snipers have a smaller falloff constant due to longer max range

	effective_accuracy = max(5, effective_accuracy) //default hit chance is at least 5%.

	if(ishuman(firer))
		var/mob/living/carbon/human/shooter_human = firer
		if(shooter_human.marksman_aura)
			effective_accuracy += shooter_human.marksman_aura * 1.5 //Flat buff of 3 % accuracy per aura level
			effective_accuracy += distance_travelled * 0.35 * shooter_human.marksman_aura //Flat buff to accuracy per tile travelled

	#if DEBUG_HIT_CHANCE
	to_world(SPAN_DEBUG("Final accuracy is <b>[effective_accuracy]</b>"))
	#endif

	return effective_accuracy

//objects use get_projectile_hit_boolean unlike mobs, which use get_projectile_hit_chance
/obj/proc/get_projectile_hit_boolean(obj/item/projectile/P)
	if(!density)
		return FALSE

	if(!anchored && !health) //unanchored objects offer no protection. Unless they can be destroyed.
		return FALSE

	return TRUE

 //Used by machines and structures to calculate shooting past cover
/obj/proc/calculate_cover_hit_boolean(obj/item/projectile/P, var/distance = 0, var/cade_direction_correct = FALSE)
	if(istype(P.shot_from, /obj/item/hardpoint)) //anything shot from a tank gets a bonus to bypassing cover
		distance -= 3

	if(distance < 1 || (distance > 3 && cade_direction_correct))
		return FALSE

	//an object's "projectile_coverage" var indicates the maximum probability of blocking a projectile
	var/effective_accuracy = P.get_effective_accuracy()
	var/distance_limit = 6 //number of tiles needed to max out block probability
	var/accuracy_factor = 50 //degree to which accuracy affects probability   (if accuracy is 100, probability is unaffected. Lower accuracies will increase block chance)

	var/hitchance = min(projectile_coverage, (projectile_coverage * distance/distance_limit) + accuracy_factor * (1 - effective_accuracy/100))

	#if DEBUG_HIT_CHANCE
	to_world(SPAN_DEBUG("([name] as cover) Distance travelled: [P.distance_travelled]  |  Effective accuracy: [effective_accuracy]  |  Hit chance: [hitchance]"))
	#endif

	return prob(hitchance)

/obj/structure/machinery/get_projectile_hit_boolean(obj/item/projectile/P)

	if(src == P.original && layer > ATMOS_DEVICE_LAYER) //clicking on the object itself hits the object
		var/hitchance = P.get_effective_accuracy()

		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([name]) Distance travelled: [P.distance_travelled]  |  Effective accuracy: [hitchance]  |  Hit chance: [hitchance]"))
		#endif

		if(prob(hitchance))
			return TRUE

	if(!density)
		return FALSE

	if(!anchored && !health) //unanchored objects offer no protection. Unless they can be destroyed.
		return FALSE

	if(!throwpass)
		return TRUE
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_IGNORE_COVER)
		return FALSE

	var/distance = P.distance_travelled

	if(flags_atom & ON_BORDER) //windoors
		if(P.dir & reverse_direction(dir))
			distance-- //no bias towards "inner" side
			if(ammo_flags & AMMO_STOPPED_BY_COVER)
				return TRUE
		else if( !(P.dir & dir) )
			return FALSE //no effect if bullet direction is perpendicular to barricade
	else
		distance--

	return calculate_cover_hit_boolean(P, distance)


/obj/structure/get_projectile_hit_boolean(obj/item/projectile/P)
	if(src == P.original && layer > ATMOS_DEVICE_LAYER) //clicking on the object itself hits the object
		var/hitchance = P.get_effective_accuracy()

		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([name]) Distance travelled: [P.distance_travelled]  |  Effective accuracy: [hitchance]  |  Hit chance: [hitchance]"))
		#endif

		if( prob(hitchance) )
			return TRUE

	if(!density)
		return FALSE

	if(!anchored && !health) //unanchored objects offer no protection. Unless they can be destroyed.
		return FALSE

	if(!throwpass)
		return TRUE

	//At this point, all that's left is window frames, tables, and barricades
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_IGNORE_COVER && src != P.original)
		return FALSE

	var/distance = P.distance_travelled

	var/cade_direction_correct = TRUE
	if(flags_atom & ON_BORDER) //barricades, flipped tables
		if(P.dir & reverse_direction(dir))
			if(ammo_flags & AMMO_STOPPED_BY_COVER)
				return TRUE
			distance-- //no bias towards "inner" side
			cade_direction_correct = FALSE
		else if(!(P.dir & dir))
			return FALSE //no effect if bullet direction is perpendicular to barricade

	else
		distance--
		if(climbable)
			for(var/obj/structure/S in get_turf(P))
				if(S && S.climbable && !(S.flags_atom & ON_BORDER)) //if a projectile is coming from a window frame or table, it's guaranteed to pass the next window frame/table
					return FALSE
	return calculate_cover_hit_boolean(P, distance, cade_direction_correct)


/obj/item/get_projectile_hit_boolean(obj/item/projectile/P)

	if(P && src == P.original) //clicking on the object itself. Code copied from mob get_projectile_hit_chance

		var/hitchance = P.get_effective_accuracy()

		switch(w_class) //smaller items are harder to hit
			if(1)
				hitchance -= 50
			if(2)
				hitchance -= 30
			if(3)
				hitchance -= 20
			if(4)
				hitchance -= 10

		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([name]) Distance travelled: [P.distance_travelled]  |  Effective accuracy: [hitchance]  |  Hit chance: [hitchance]"))
		#endif

		if( prob(hitchance) )
			return TRUE

	if(!density)
		return FALSE

	if(!anchored && !health) //unanchored objects offer no protection. Unless they can be destroyed.
		return FALSE

	return TRUE


/obj/vehicle/get_projectile_hit_boolean(obj/item/projectile/P)

	if(src == P.original) //clicking on the object itself hits the object
		var/hitchance = P.get_effective_accuracy()

		#if DEBUG_HIT_CHANCE
		to_world(SPAN_DEBUG("([P.name]) Distance travelled: [P.distance_travelled]  |  Effective accuracy: [hitchance]  |  Hit chance: [hitchance]"))
		#endif

		if( prob(hitchance) )
			return TRUE

	if(!density)
		return FALSE

	if(!anchored && !health) //unanchored objects offer no protection.
		return FALSE

	return TRUE


/obj/structure/window/get_projectile_hit_boolean(obj/item/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_ENERGY)
		return FALSE
	else if(!(flags_atom & ON_BORDER) || (P.dir & dir) || (P.dir & reverse_direction(dir)))
		return TRUE

/obj/structure/machinery/door/poddoor/railing/get_projectile_hit_boolean(obj/item/projectile/P)
	return src == P.original

/obj/effect/alien/egg/get_projectile_hit_boolean(obj/item/projectile/P)
	return src == P.original

/obj/effect/alien/resin/trap/get_projectile_hit_boolean(obj/item/projectile/P)
	return src == P.original

/obj/item/clothing/mask/facehugger/get_projectile_hit_boolean(obj/item/projectile/P)
	return src == P.original



//mobs use get_projectile_hit_chance instead of get_projectile_hit_boolean

/mob/living/proc/get_projectile_hit_chance(obj/item/projectile/P)
	if(lying && src != P.original)
		return FALSE
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		if((status_flags & XENO_HOST) && HAS_TRAIT(src, TRAIT_NESTED))
			return FALSE

	. = P.get_effective_accuracy()

	if(lying && stat) . += 15 //Bonus hit against unconscious people.

	if(isliving(P.firer))
		var/mob/living/shooter_living = P.firer
		if(!can_see(shooter_living,src))
			. -= 15 //Can't see the target (Opaque thing between shooter and target)

/mob/living/carbon/human/get_projectile_hit_chance(obj/item/projectile/P)
	. = ..()
	if(.)
		var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
		if(SEND_SIGNAL(P, COMSIG_BULLET_CHECK_MOB_SKIPPING, src) & COMPONENT_SKIP_MOB\
			|| P.runtime_iff_group && get_target_lock(P.runtime_iff_group)\
		)
			return FALSE
		if(mobility_aura)
			. -= mobility_aura * 5
		var/mob/living/carbon/human/shooter_human = P.firer
		if(istype(shooter_human))
			if(shooter_human.faction == faction && !(ammo_flags & AMMO_ALWAYS_FF))
				. -= FF_hit_evade

			if(ammo_flags & AMMO_MP)
				if(criminal)
					. += FF_hit_evade
				else
					return FALSE

/mob/living/carbon/Xenomorph/get_projectile_hit_chance(obj/item/projectile/P)
	. = ..()
	if(.)
		var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
		if(SEND_SIGNAL(P, COMSIG_BULLET_CHECK_MOB_SKIPPING, src) & COMPONENT_SKIP_MOB\
			|| P.runtime_iff_group && get_target_lock(P.runtime_iff_group))
			return FALSE

		if(ammo_flags & AMMO_SKIPS_ALIENS)
			var/mob/living/carbon/Xenomorph/X = P.firer
			if(!istype(X))
				return FALSE
			if(X.hivenumber == hivenumber)
				return FALSE

		if(mob_size >= MOB_SIZE_BIG)	. += 10
		if(evasion > 0)
			. -= evasion

/mob/living/silicon/robot/drone/get_projectile_hit_chance(obj/item/projectile/P)
	return FALSE // just stop them getting hit by projectiles completely


/obj/item/projectile/proc/play_damage_effect(mob/M)
	if(ammo.sound_hit) playsound(M, ammo.sound_hit, 50, 1)
	if(M.stat != DEAD) animation_flash_color(M)

/obj/item/projectile/proc/play_shielded_damage_effect(mob/M)
	if(ammo.sound_shield_hit) playsound(M, ammo.sound_shield_hit, 50, 1)
	if(M.stat != DEAD) animation_flash_color(M)

//----------------------------------------------------------
				//				    \\
				//    OTHER PROCS	\\
				//					\\
				//					\\
//----------------------------------------------------------

/atom/proc/bullet_act(obj/item/projectile/P)
	return FALSE

/mob/dead/bullet_act(/obj/item/projectile/P)
	return FALSE

/mob/living/bullet_act(obj/item/projectile/P)
	if(!P)
		return

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	var/damage = P.calculate_damage()
	if(P.ammo.debilitate && stat != DEAD && ( damage || (ammo_flags & AMMO_IGNORE_RESIST) ) )
		apply_effects(arglist(P.ammo.debilitate))

	. = TRUE
	if(damage)
		bullet_message(P)
		apply_damage(damage, P.ammo.damage_type, P.def_zone, 0, 0, P)
		P.play_damage_effect(src)

	SEND_SIGNAL(P, COMSIG_BULLET_ACT_LIVING, src, damage, damage)


/mob/living/carbon/human/bullet_act(obj/item/projectile/P)
	if(!P)
		return

	if(isXeno(P.firer))
		var/mob/living/carbon/Xenomorph/X = P.firer
		if(X.can_not_harm(src))
			bullet_ping(P)
			return -1

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(P.weapon_cause_data && P.weapon_cause_data.cause_name)
		var/mob/M = P.weapon_cause_data.resolve_mob()
		if(istype(M))
			M.track_shot_hit(P.weapon_cause_data.cause_name, src)

	var/damage = P.calculate_damage()
	var/damage_result = damage

	if(SEND_SIGNAL(src, COMSIG_HUMAN_PRE_BULLET_ACT, P) & COMPONENT_CANCEL_BULLET_ACT)
		return

	flash_weak_pain()
	if(P.ammo.stamina_damage)
		apply_stamina_damage(P.ammo.stamina_damage, P.def_zone, ARMOR_ENERGY) // Stamina damage is energy

	//Shields
	if( !(ammo_flags & AMMO_ROCKET) ) //No, you can't block rockets.
		if(prob(75) && check_shields(damage * 0.65, "[P]") ) // Lower chance to block bullets
			P.ammo.on_shield_block(src)
			bullet_ping(P)
			return

	var/obj/limb/organ = get_limb(check_zone(P.def_zone)) //Let's finally get what organ we actually hit.
	if(!organ)
		return//Nope. Gotta shoot something!

	//Run armor check. We won't bother if there is no damage being done.
	if( damage > 0 && !(ammo_flags & AMMO_IGNORE_ARMOR) )
		var/armor //Damage types don't correspond to armor types. We are thus merging them.
		switch(P.ammo.damage_type)
			if(BRUTE) armor = ammo_flags & AMMO_ROCKET ? getarmor_organ(organ, ARMOR_BOMB) : getarmor_organ(organ, ARMOR_BULLET)
			if(BURN) armor = ammo_flags & AMMO_ENERGY ? getarmor_organ(organ, ARMOR_ENERGY) : getarmor_organ(organ, ARMOR_BIO)
			if(TOX, OXY, CLONE) armor = getarmor_organ(organ, ARMOR_BIO)
			else armor = getarmor_organ(organ, ARMOR_ENERGY) //Won't be used, but just in case.

		damage_result = armor_damage_reduction(GLOB.marine_ranged, damage, armor, P.ammo.penetration)

		if(damage_result <= 5)
			to_chat(src,SPAN_XENONOTICE("Your armor absorbs the force of [P]!"))
		if(damage_result <= 3)
			damage_result = 0
			bullet_ping(P)
			visible_message("<span class='avoidharm'>[src]'s armor deflects [P]!</span>")
			if(P.ammo.sound_armor) playsound(src, P.ammo.sound_armor, 50, 1)

	if(P.ammo.debilitate && stat != DEAD && ( damage || ( ammo_flags & AMMO_IGNORE_RESIST) ) )  //They can't be dead and damage must be inflicted (or it's a xeno toxin).
		//Predators and synths are immune to these effects to cut down on the stun spam. This should later be moved to their apply_effects proc, but right now they're just humans.
		if(!isSpeciesYautja(src) && !isSpeciesSynth(src))
			apply_effects(arglist(P.ammo.debilitate))

	bullet_message(P) //We still want this, regardless of whether or not the bullet did damage. For griefers and such.

	if(SEND_SIGNAL(src, COMSIG_HUMAN_BULLET_ACT, damage_result, ammo_flags, P) & COMPONENT_CANCEL_BULLET_ACT)
		return

	if(damage || (ammo_flags && AMMO_SPECIAL_EMBED))

		var/splatter_dir = get_dir(P.starting, loc)
		handle_blood_splatter(splatter_dir)

		. = TRUE
		apply_damage(damage_result, P.ammo.damage_type, P.def_zone, firer = P.firer)
		P.play_damage_effect(src)

		if(P.ammo.shrapnel_chance > 0 && prob(P.ammo.shrapnel_chance + round(damage / 10)))
			if(ammo_flags && AMMO_SPECIAL_EMBED)
				P.ammo.on_embed(src, organ)

			var/obj/item/shard/shrapnel/new_embed = new P.ammo.shrapnel_type
			var/obj/item/large_shrapnel/large_embed = new P.ammo.shrapnel_type
			if(istype(large_embed))
				large_embed.on_embed(src, organ)
			if(istype(new_embed))
				var/found_one = FALSE
				for(var/obj/item/shard/shrapnel/S in embedded_items)
					if(S.name == new_embed.name)
						S.count++
						qdel(new_embed)
						found_one = TRUE
						break

				if(!found_one)
					new_embed.on_embed(src, organ)

				if(!stat && pain.feels_pain)
					emote("scream")
					to_chat(src, SPAN_HIGHDANGER("You scream in pain as the impact sends <B>shrapnel</b> into the wound!"))
	SEND_SIGNAL(P, COMSIG_POST_BULLET_ACT_HUMAN, src, damage, damage_result)

//Deal with xeno bullets.
/mob/living/carbon/Xenomorph/bullet_act(obj/item/projectile/P)
	if(!P || !istype(P))
		return

	var/damage = P.calculate_damage()
	var/damage_result = damage

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags

	if(isXeno(P.firer))
		var/mob/living/carbon/Xenomorph/X = P.firer
		if(X.can_not_harm(src))
			bullet_ping(P)
			return -1
		else
			damage *= XVX_PROJECTILE_DAMAGEMULT
			damage_result = damage

	if(P.weapon_cause_data && P.weapon_cause_data.cause_name)
		var/mob/M = P.weapon_cause_data.resolve_mob()
		if(istype(M))
			M.track_shot_hit(P.weapon_cause_data.cause_name, src)

	flash_weak_pain()

	if(damage > 0 && !(ammo_flags & AMMO_IGNORE_ARMOR))
		var/armor = armor_deflection + armor_deflection_buff - armor_deflection_debuff

		var/list/damagedata = list(
			"damage" = damage,
			"armor" = armor,
			"penetration" = P.ammo.penetration,
			"armour_break_pr_pen" = P.ammo.pen_armor_punch,
			"armour_break_flat" = P.ammo.damage_armor_punch,
			"armor_integrity" = armor_integrity,
			"direction" = P.dir,
		)
		SEND_SIGNAL(src, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, damagedata)
		damage_result = armor_damage_reduction(GLOB.xeno_ranged, damagedata["damage"],
			damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
			damagedata["armour_break_flat"], damagedata["armor_integrity"])

		var/armor_punch = armor_break_calculation(GLOB.xeno_ranged, damagedata["damage"],
			damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
			damagedata["armour_break_flat"], damagedata["armor_integrity"])

		apply_armorbreak(armor_punch)

		if(damage <= 3)
			damage = 0
			bullet_ping(P)

	bullet_message(P) //Message us about the bullet, since damage was inflicted.



	if(SEND_SIGNAL(src, COMSIG_XENO_BULLET_ACT, damage_result, ammo_flags, P) & COMPONENT_CANCEL_BULLET_ACT)
		return

	if(damage)
		//only apply the blood splatter if we do damage
		handle_blood_splatter(get_dir(P.starting, loc))

		apply_damage(damage_result,P.ammo.damage_type, P.def_zone)	//Deal the damage.
		if(xeno_shields.len)
			P.play_shielded_damage_effect(src)
		else
			P.play_damage_effect(src)
		if(!stat && prob(5 + round(damage_result / 4)))
			var/pain_emote = prob(70) ? "hiss" : "roar"
			emote(pain_emote)
		updatehealth()

	SEND_SIGNAL(P, COMSIG_BULLET_ACT_XENO, src, damage, damage_result)

	return TRUE

/turf/bullet_act(obj/item/projectile/P)
	if(SEND_SIGNAL(src, COMSIG_TURF_BULLET_ACT, P) & COMPONENT_BULLET_ACT_OVERRIDE)
		return

	if(!P || !density)
		return //It's just an empty turf

	bullet_ping(P)

	var/list/mobs_list = list() //Let's built a list of mobs on the bullet turf and grab one.
	for(var/mob/living/L in src)
		if(L in P.permutated)
			continue
		if(prob(L.get_projectile_hit_chance(P)))
			mobs_list += L

	if(length(mobs_list))
		var/mob/living/picked_mob = pick(mobs_list) //Hit a mob, if there is one.
		if(istype(picked_mob))
			picked_mob.bullet_act(P)
			return
	return

// walls can get shot and damaged, but bullets (vs energy guns) do much less.
/turf/closed/wall/bullet_act(obj/item/projectile/P)
	. = ..()
	var/damage = P.damage
	if(damage < 1)
		return
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags

	switch(P.ammo.damage_type)
		if(BRUTE) //Rockets do extra damage to walls.
			if(ammo_flags & AMMO_ROCKET)
				damage = round(damage * 10)
		if(BURN)
			if(ammo_flags & AMMO_ENERGY)
				damage = round(damage * 7)
			else if(ammo_flags & AMMO_ANTISTRUCT) // Railgun does extra damage to turfs
				damage = round(damage * ANTISTRUCT_DMG_MULT_WALL)
	if(ammo_flags & AMMO_BALLISTIC)
		current_bulletholes++
	take_damage(damage, P.firer)

/turf/closed/wall/almayer/research/containment/bullet_act(obj/item/projectile/P)
	if(P)
		var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
		if(ammo_flags & AMMO_XENO_ACID)
			return //immune to acid spit
	. = ..()




//Hitting an object. These are too numerous so they're staying in their files.
//Why are there special cases listed here? Oh well, whatever. ~N
/obj/bullet_act(obj/item/projectile/P)
	bullet_ping(P)
	return TRUE

/obj/item/bullet_act(obj/item/projectile/P)
	bullet_ping(P)
	if(P.ammo.damage_type == BRUTE)
		explosion_throw(P.damage/2, P.dir, 4)
	return TRUE

/obj/structure/surface/table/bullet_act(obj/item/projectile/P)
	bullet_ping(P)
	health -= round(P.damage/2)
	if(health < 0)
		visible_message(SPAN_WARNING("[src] breaks down!"))
		destroy()
	return TRUE


//----------------------------------------------------------
					//				    \\
					//    OTHER PROCS	\\
					//					\\
					//					\\
//----------------------------------------------------------


//This is where the bullet bounces off.
/atom/proc/bullet_ping(obj/item/projectile/P, var/pixel_x_offset, var/pixel_y_offset)
	if(!P || !P.ammo.ping)
		return

	if(P.ammo.sound_bounce) playsound(src, P.ammo.sound_bounce, 50, 1)
	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',src,P.ammo.ping,10, pixel_x = pixel_x_offset, pixel_y = pixel_y_offset)
	var/angle = (P.firer && prob(60)) ? round(Get_Angle(P.firer,src)) : round(rand(1,359))
	I.pixel_x += rand(-6,6)
	I.pixel_y += rand(-6,6)

	var/matrix/rotate = matrix()
	rotate.Turn(angle)
	I.transform = rotate
	// Need to do this in order to prevent the ping from being deleted
	addtimer(CALLBACK(I, /image/.proc/flick_overlay, src, 3), 1)

/mob/proc/bullet_message(obj/item/projectile/P)
	if(!P)
		return
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_IS_SILENCED)
		var/hit_msg = "You've been shot in the [parse_zone(P.def_zone)] by [P.name]!"
		to_chat(src, isXeno(src) ? SPAN_XENODANGER("[hit_msg]"):SPAN_HIGHDANGER("[hit_msg]"))
	else
		visible_message(SPAN_DANGER("[src] is hit by the [P.name] in the [parse_zone(P.def_zone)]!"), \
						SPAN_HIGHDANGER("You are hit by the [P.name] in the [parse_zone(P.def_zone)]!"), null, 4, CHAT_TYPE_TAKING_HIT)

	last_damage_data = P.weapon_cause_data
	if(P.firer && ismob(P.firer))
		var/mob/firingMob = P.firer
		var/area/A = get_area(src)
		if(ishuman(firingMob) && ishuman(src) && faction == firingMob.faction && !A?.statistic_exempt) //One human shot another, be worried about it but do everything basically the same //special_role should be null or an empty string if done correctly
			if(!istype(P.ammo, /datum/ammo/energy/taser))
				round_statistics.total_friendly_fire_instances++
				var/ff_msg = "[key_name(firingMob)] shot [key_name(src)] with \a [P.name] in [get_area(firingMob)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[firingMob.x];Y=[firingMob.y];Z=[firingMob.z]'>JMP</a>) ([firingMob.client ? "<a href='?priv_msg=[firingMob.client.ckey]'>PM</a>" : "NO CLIENT"])"
				var/ff_living = TRUE
				if(src.stat == DEAD)
					ff_living = FALSE
				msg_admin_ff(ff_msg, ff_living)
				if(ishuman(firingMob) && P.weapon_cause_data)
					var/mob/living/carbon/human/H = firingMob
					H.track_friendly_fire(P.weapon_cause_data.cause_name)
			else
				msg_admin_attack("[key_name(firingMob)] tased [key_name(src)] in [get_area(firingMob)] ([firingMob.x],[firingMob.y],[firingMob.z]).", firingMob.x, firingMob.y, firingMob.z)
		else
			msg_admin_attack("[key_name(firingMob)] shot [key_name(src)] with \a [P.name] in [get_area(firingMob)] ([firingMob.x],[firingMob.y],[firingMob.z]).", firingMob.x, firingMob.y, firingMob.z)
		attack_log += "\[[time_stamp()]\] <b>[key_name(firingMob)]</b> shot <b>[key_name(src)]</b> with \a <b>[P]</b> in [get_area(firingMob)]."
		firingMob.attack_log += "\[[time_stamp()]\] <b>[key_name(firingMob)]</b> shot <b>[key_name(src)]</b> with \a <b>[P]</b> in [get_area(firingMob)]."
		return

	attack_log += "\[[time_stamp()]\] <b>SOMETHING??</b> shot <b>[key_name(src)]</b> with a <b>[P]</b>"
	msg_admin_attack("SOMETHING?? shot [key_name(src)] with a [P] in [get_area(src)] ([loc.x],[loc.y],[loc.z]).", loc.x, loc.y, loc.z)

//Abby -- Just check if they're 1 tile horizontal or vertical, no diagonals
/proc/get_adj_simple(atom/Loc1,atom/Loc2)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	if(dx == 0) //left or down of you
		if(dy == -1 || dy == 1)
			return TRUE
	if(dy == 0) //above or below you
		if(dx == -1 || dx == 1)
			return TRUE

#undef DEBUG_HIT_CHANCE
#undef DEBUG_HUMAN_DEFENSE
#undef DEBUG_XENO_DEFENSE
