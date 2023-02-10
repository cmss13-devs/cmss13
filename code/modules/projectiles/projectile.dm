//Some debug variables. Toggle them to 1 in order to see the related debug messages. Helpful when testing out formulas.
#define DEBUG_HIT_CHANCE 0
#define DEBUG_HUMAN_DEFENSE 0
#define DEBUG_XENO_DEFENSE 0

//The actual bullet objects.
/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	unacidable = TRUE
	anchored = TRUE //You will not have me, space wind!
	flags_atom = NOINTERACT //No real need for this, but whatever. Maybe this flag will do something useful in the future.
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 100 // We want this thing to be invisible when it drops on a turf because it will be on the user's turf. We then want to make it visible as it travels.
	layer = FLY_LAYER

	var/datum/ammo/ammo //The ammo data which holds most of the actual info.

	var/def_zone = "chest" //So we're not getting empty strings.
	var/p_x = 0
	var/p_y = 0 // the pixel location of the clicked/aimed location in target turf

	var/current  = null
	var/atom/shot_from  = null // the object which shot us
	var/atom/original  = null // the original target clicked
	var/atom/firer  = null // Who shot it

	var/turf/target_turf = null
	var/turf/starting  = null // the projectile's starting turf

	var/turf/path[]  = null
	var/permutated[]  = null // we've passed through these atoms, don't try to hit them again

	/// Additional ammo flags applied to the projectile
	var/projectile_override_flags = NONE
	/// Flags for behaviors of the projectile itself
	var/projectile_flags = NONE

	/// How much time has the projectile carried for fractional movement, in seconds (delta_time format)
	var/time_carry = 0
	/// How many turfs per 1ds the projectile travels
	var/speed = 0
	/// Direct angle at firing time, in degrees from BYOND NORTH, used for visual updates and path extension
	var/angle = 0
	/// Turfs traveled so far, for use in visual updates, in conjunction with angle for projection
	var/vis_travelled = 0
	/// Origin point for tracing and visual updates
	var/turf/vis_source

	var/damage = 0
	var/accuracy = 85 //Base projectile accuracy. Can maybe be later taken from the mob if desired.

	var/damage_falloff = 0 //how much effectiveness in damage the projectile loses per tiles travelled beyond the effective range
	var/damage_buildup = 0 //how much effectiveness in damage the projectile loses before the effective range

	var/effective_range_min = 0 //What minimum range the projectile deals full damage, builds up the closer you get. 0 for no minimum. Set by the weapon.
	var/effective_range_max = 0 //What maximum range the projectile deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum. Set by the weapon.

	var/scatter = 0
	var/distance_travelled = 0

	var/datum/cause_data/weapon_cause_data
	var/list/bullet_traits

	/// The beam linked to the projectile. Can be utilized for things like grappling hooks, harpoon guns, tripwire guns, etc..
	var/obj/effect/bound_beam

	/// The flicker that plays when a bullet hits a target. Usually red. Can be nulled so it doesn't show up at all.
	var/hit_effect_color = "#FF0000"

/obj/item/projectile/Initialize(mapload, datum/cause_data/cause_data)
	. = ..()
	path = list()
	permutated = list()
	weapon_cause_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)
	firer = cause_data?.resolve_mob()

/obj/item/projectile/Destroy()
	speed = 0
	ammo = null
	shot_from = null
	original = null
	target_turf = null
	starting = null
	permutated = null
	path = null
	weapon_cause_data = null
	firer = null
	QDEL_NULL(bound_beam)
	SSprojectiles.stop_projectile(src)
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
		if(scan_a_turf(AM.loc))
			SSprojectiles.stop_projectile(src)
			qdel(src)

/obj/item/projectile/Crossed(atom/movable/AM)
	/* Fun fact: Crossed is called for any contents involving operations.
	 * This notably means, inserting a magazing in a gun Crossed() it with the bullets in the gun. */
	if(!loc.z)
		return // Not on the map. Don't scan a turf. Don't shoot the poor guy reloading his gun.
	if(AM && !(AM in permutated))
		if(scan_a_turf(get_turf(AM)))
			SSprojectiles.stop_projectile(src)
			qdel(src)


/obj/item/projectile/ex_act()
	return FALSE //We do not want anything to delete these, simply to make sure that all the bullet references are not runtiming. Otherwise, constantly need to check if the bullet exists.

/obj/item/projectile/proc/generate_bullet(datum/ammo/ammo_datum, bonus_damage = 0, special_flags = 0, mob/bullet_generator)
	ammo = ammo_datum
	name = ammo.name
	icon = ammo.icon
	icon_state = ammo.icon_state
	damage = ammo.damage + bonus_damage //Mainly for emitters.
	scatter = ammo.scatter
	accuracy   += ammo.accuracy
	accuracy   *= rand(PROJ_VARIANCE_LOW-ammo.accuracy_var_low, PROJ_VARIANCE_HIGH+ammo.accuracy_var_high) * PROJ_BASE_ACCURACY_MULT//Rand only works with integers.
	damage  *= rand(PROJ_VARIANCE_LOW-ammo.damage_var_low, PROJ_VARIANCE_HIGH+ammo.damage_var_high) * PROJ_BASE_DAMAGE_MULT
	damage_falloff = ammo.damage_falloff
	damage_buildup = ammo.damage_buildup
	hit_effect_color = ammo.hit_effect_color
	projectile_override_flags = special_flags

	ammo_datum.on_bullet_generation(src, bullet_generator)

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

// Target, firer, shot from (i.e. the gun), projectile range, projectile speed, original target (who was aimed at, not where projectile is going towards)
/obj/item/projectile/proc/fire_at(atom/target, atom/F, atom/S, range = 30, speed = 1, atom/original_override)
	SHOULD_NOT_SLEEP(TRUE)
	original = original || original_override || target
	if(!loc)
		if (!(projectile_flags & PROJECTILE_SHRAPNEL))
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

	if(F && !(projectile_flags & PROJECTILE_SHRAPNEL))
		permutated |= F //Don't hit the shooter (firer)
	else if (S && (projectile_flags & PROJECTILE_SHRAPNEL))
		permutated |= S

	permutated |= src //Don't try to hit self.
	shot_from = S

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

	path = getline2(starting, target_turf)
	p_x += Clamp((rand()-0.5)*scatter*3, -8, 8)
	p_y += Clamp((rand()-0.5)*scatter*3, -8, 8)
	update_angle(starting, target_turf)

	src.speed = speed
	// Randomize speed by a small factor to help bullet animations look okay
	// Otherwise you get a   s   t   r   e   a   m of warping bullets in same positions
	src.speed *= (1 + (rand()-0.5) * 0.30) // 15.0% variance either way
	src.speed = Clamp(src.speed, 0.1, 100) // Safety to avoid loop hazards

	// Also give it some headstart, flying it now ahead of tick
	var/delta_time = world.tick_lag * rand() * 0.4
	if(process(delta_time))
		return // Hit something already?!
	time_carry -= delta_time // Substract headstart from next tick

	// Finally queue it to Subsystem for further processing
	SSprojectiles.queue_projectile(src)

/obj/item/projectile/proc/update_angle(turf/source_turf, turf/aim_turf)
	p_x = Clamp(p_x, -16, 16)
	p_y = Clamp(p_y, -16, 16)

	if(source_turf != vis_source)
		vis_travelled = 0
	vis_source = source_turf

	angle = 0 // Stolen from Get_Angle() basically
	var/dx = p_x + aim_turf.x * 32 - source_turf.x * 32 // todo account for firer offsets
	var/dy = p_y + aim_turf.y * 32 - source_turf.y * 32
	if(!dy)
		if(dx >= 0)
			angle = 90
		else
			angle = 280
	else
		angle = arctan(dx/dy)
		if(dy < 0)
			angle += 180
		else if(dx < 0)
			angle += 360

	var/matrix/rotate = matrix() //Change the bullet angle.
	rotate.Turn(angle)
	apply_transform(rotate)

/obj/item/projectile/process(delta_time)
	. = PROC_RETURN_SLEEP

	// Keep going as long as we got speed and time
	while(speed > 0 && (speed * ((delta_time + time_carry)/10) >= 1))
		time_carry -= 1/speed*10
		if(time_carry < 0)
			delta_time += time_carry
			time_carry = 0
		if(fly())
			qdel(src)
			return PROCESS_KILL

	time_carry += delta_time
	return FALSE

/// Flies the projectile forward one single turf
/obj/item/projectile/proc/fly()
	SHOULD_NOT_SLEEP(TRUE)
	PRIVATE_PROC(TRUE)
	var/turf/current_turf = get_turf(src)
	var/turf/next_turf = popleft(path)

	// Terminal projectiles (about to hit) are handled first for retarget logic
	if((speed * world.tick_lag) >= get_dist(current_turf, target_turf))
		SEND_SIGNAL(src, COMSIG_BULLET_TERMINAL)

	// Check we can reach the turf at all based on pathed grid
	var/proj_dir = get_dir(current_turf, next_turf)
	if((proj_dir & (proj_dir - 1)) && !current_turf.Adjacent(next_turf))
		ammo.on_hit_turf(current_turf, src)
		current_turf.bullet_act(src)
		return TRUE

	// Check for hits that would occur when moving to turf, such as a blocking cade
	if(scan_a_turf(next_turf, proj_dir))
		return TRUE

	// Actually move
	forceMove(next_turf)
	distance_travelled++
	vis_travelled++
	if(distance_travelled > 1)
		invisibility = 0

	// Check we're still flying - in the highly unlikely but apparently possible case
	// we hit something through forceMove callbacks that we didn't pick up in scan_a_turf
	if(!speed)
		return TRUE

	// Process on move effects
	if(distance_travelled == round(ammo.max_range / 2))
		ammo.do_at_half_range(src)
	if(distance_travelled >= ammo.max_range)
		ammo.do_at_max_range(src)
		speed = 0
		return TRUE

	// Adjust computed path if we just missed our intended target
	if(!length(path))
		var/turf/aim_turf = get_angle_target_turf(src, angle, distance_travelled * 2 + 1)
		if(!aim_turf || aim_turf == loc) // Map border safety
			speed = 0
			return TRUE
		p_x *= 2
		p_y *= 2
		retarget(aim_turf, keep_angle = TRUE)

	// Nowe we update visual offset by tracing the bullet predicted location against real one
	//
	// Travelled real distance so far
	var/dist = vis_travelled * 32 + speed * (time_carry*10)
	// Compute where we should be
	var/vis_x = vis_source.x * 32 + sin(angle) * dist
	var/vis_y = vis_source.y * 32 + cos(angle) * dist
	// Get the difference with where we actually are
	var/dx = vis_x - loc.x * 32
	var/dy = vis_y - loc.y * 32
	// Clamp and set this as pixel offsets
	pixel_x = Clamp(dx, -16, 16)
	pixel_y = Clamp(dy, -16, 16)

/obj/item/projectile/proc/retarget(atom/new_target, keep_angle = FALSE)
	var/turf/current_turf = get_turf(src)
	path = getline2(current_turf, new_target)
	path.Cut(1, 2) // remove the turf we're already on
	var/atom/source = keep_angle ? original : current_turf
	update_angle(source, new_target)

/obj/item/projectile/proc/scan_a_turf(turf/T, proj_dir)
	. = TRUE // Sleep safeguard: stop the bullet

	//Not actually flying? Should not be hitting anything.
	if(!speed)
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
	if(firer && T == firer.loc && !(projectile_flags & PROJECTILE_SHRAPNEL))
		return FALSE
	var/ammo_flags = ammo.flags_ammo_behavior | projectile_override_flags

	var/hit_turf = FALSE
	// Explosive ammo always explodes on the turf of the clicked target
	// So does ammo that's flagged to always hit the target
	if(((ammo_flags & AMMO_EXPLOSIVE) || (ammo_flags & AMMO_HITS_TARGET_TURF)) && T == target_turf)
		hit_turf = TRUE

	for(var/atom/movable/clone/C in T) //Handle clones if there are any
		if(isobj(C.mstr) && handle_object(C.mstr))
			return TRUE
		if(isliving(C.mstr) && handle_mob(C.mstr))
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
	return FALSE

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
		if (istype(ammo, /datum/ammo/xeno) && isxeno(firer) && ammo.apply_delegate)
			var/mob/living/carbon/xenomorph/X = firer
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
	if((ammo.flags_ammo_behavior & AMMO_XENO) && L.stat == DEAD) //xeno ammo is NEVER meant to hit or damage dead people. If you want to add a xeno ammo that DOES then make a new flag that makes it ignore this check.
		return FALSE

	var/hit_chance = L.get_projectile_hit_chance(src)

	if(hit_chance) // Calculated from combination of both ammo accuracy and gun accuracy

		var/hit_roll = rand(1,100)

		if(original != L || hit_roll > hit_chance-base_miss_chance[def_zone]-20) // If hit roll is high or the firer wasn't aiming at this mob, we still hit but now we might hit the wrong body part
			def_zone = rand_zone()
		else
			SEND_SIGNAL(firer, COMSIG_BULLET_DIRECT_HIT, L)
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
				if (istype(ammo, /datum/ammo/xeno) && isxeno(firer) && L.stat != DEAD && ammo.apply_delegate)
					var/mob/living/carbon/xenomorph/X = firer
					if (X.behavior_delegate)
						var/datum/behavior_delegate/MD = X.behavior_delegate
						MD.ranged_attack_additional_effects_target(L)
						MD.ranged_attack_additional_effects_self(L)

				// If the thing we're hitting is a Xeno
				if (istype(L, /mob/living/carbon/xenomorph))
					var/mob/living/carbon/xenomorph/X = L
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
				// \\
				//  HITTING THE TARGET  \\
				// \\
				// \\
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
		effective_accuracy -= (distance_travelled - ammo.accurate_range) * ((ammo_flags & AMMO_SNIPER) ? 1.5 : 10) // Snipers have a smaller falloff constant due to longer max range

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
/obj/proc/calculate_cover_hit_boolean(obj/item/projectile/P, distance = 0, cade_direction_correct = FALSE)
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
	if(ammo_flags & AMMO_XENO)
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

/mob/living/carbon/xenomorph/get_projectile_hit_chance(obj/item/projectile/P)
	. = ..()
	if(.)
		var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
		if(SEND_SIGNAL(P, COMSIG_BULLET_CHECK_MOB_SKIPPING, src) & COMPONENT_SKIP_MOB\
			|| P.runtime_iff_group && get_target_lock(P.runtime_iff_group))
			return FALSE

		if(ammo_flags & AMMO_SKIPS_ALIENS)
			var/mob/living/carbon/xenomorph/X = P.firer
			if(!istype(X))
				return FALSE
			if(X.hivenumber == hivenumber)
				return FALSE

		if(mob_size >= MOB_SIZE_BIG) . += 10
		if(evasion > 0)
			. -= evasion

/mob/living/silicon/robot/drone/get_projectile_hit_chance(obj/item/projectile/P)
	return FALSE // just stop them getting hit by projectiles completely


/obj/item/projectile/proc/play_hit_effect(mob/hit_mob)
	if(ammo.sound_hit)
		playsound(hit_mob, ammo.sound_hit, 50, 1)
	if(hit_mob.stat != DEAD && !isnull(hit_effect_color))
		animation_flash_color(hit_mob, hit_effect_color)

/obj/item/projectile/proc/play_shielded_hit_effect(mob/hit_mob)
	if(ammo.sound_shield_hit)
		playsound(hit_mob, ammo.sound_shield_hit, 50, 1)
	if(hit_mob.stat != DEAD && !isnull(hit_effect_color))
		animation_flash_color(hit_mob, hit_effect_color)

//----------------------------------------------------------
				// \\
				// OTHER PROCS \\
				// \\
				// \\
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
		P.play_hit_effect(src)

	SEND_SIGNAL(P, COMSIG_BULLET_ACT_LIVING, src, damage, damage)


/mob/living/carbon/human/bullet_act(obj/item/projectile/P)
	if(!P)
		return

	if(isxeno(P.firer))
		var/mob/living/carbon/xenomorph/X = P.firer
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
			if(BRUTE)
				if(ammo_flags & AMMO_ROCKET)
					armor = getarmor_organ(organ, ARMOR_BOMB)
				else
					armor = getarmor_organ(organ, ARMOR_BULLET)
			if(BURN)
				if(ammo_flags & AMMO_ENERGY)
					armor = getarmor_organ(organ, ARMOR_ENERGY)
				else if(ammo_flags & AMMO_LASER)
					armor = getarmor_organ(organ, ARMOR_LASER)
				else
					armor = getarmor_organ(organ, ARMOR_BIO)
			if(TOX, OXY, CLONE)
				armor = getarmor_organ(organ, ARMOR_BIO)
			else
				armor = getarmor_organ(organ, ARMOR_ENERGY) //Won't be used, but just in case.

		damage_result = armor_damage_reduction(GLOB.marine_ranged, damage, armor, P.ammo.penetration)

		if(damage_result <= 5)
			to_chat(src,SPAN_XENONOTICE("Your armor absorbs the force of [P]!"))
		if(damage_result <= 3)
			damage_result = 0
			bullet_ping(P)
			visible_message(SPAN_AVOIDHARM("[src]'s armor deflects [P]!"))
			if(P.ammo.sound_armor) playsound(src, P.ammo.sound_armor, 50, 1)

	if(P.ammo.debilitate && stat != DEAD && ( damage || ( ammo_flags & AMMO_IGNORE_RESIST) ) )  //They can't be dead and damage must be inflicted (or it's a xeno toxin).
		//Predators and synths are immune to these effects to cut down on the stun spam. This should later be moved to their apply_effects proc, but right now they're just humans.
		if(!isspeciesyautja(src) && !isspeciessynth(src))
			apply_effects(arglist(P.ammo.debilitate))

	bullet_message(P) //We still want this, regardless of whether or not the bullet did damage. For griefers and such.

	if(SEND_SIGNAL(src, COMSIG_HUMAN_BULLET_ACT, damage_result, ammo_flags, P) & COMPONENT_CANCEL_BULLET_ACT)
		return

	P.play_hit_effect(src)
	if(damage || (ammo_flags & AMMO_SPECIAL_EMBED))

		var/splatter_dir = get_dir(P.starting, loc)
		handle_blood_splatter(splatter_dir)

		. = TRUE
		apply_damage(damage_result, P.ammo.damage_type, P.def_zone, firer = P.firer)

		if(P.ammo.shrapnel_chance > 0 && prob(P.ammo.shrapnel_chance + round(damage / 10)))
			if(ammo_flags & AMMO_SPECIAL_EMBED)
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
/mob/living/carbon/xenomorph/bullet_act(obj/item/projectile/P)
	if(!P || !istype(P))
		return

	var/damage = P.calculate_damage()
	var/damage_result = damage

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags

	if((ammo_flags & AMMO_FLAME) && (src.caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE|FIRE_IMMUNITY_NO_DAMAGE))
		to_chat(src, SPAN_AVOIDHARM("You shrug off the glob of flame."))
		return

	if(isxeno(P.firer))
		var/mob/living/carbon/xenomorph/X = P.firer
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

		apply_damage(damage_result,P.ammo.damage_type, P.def_zone) //Deal the damage.
		if(xeno_shields.len)
			P.play_shielded_hit_effect(src)
		else
			P.play_hit_effect(src)
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
		if(ammo_flags & AMMO_ACIDIC)
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
		deconstruct()
	return TRUE


//----------------------------------------------------------
					// \\
					// OTHER PROCS \\
					// \\
					// \\
//----------------------------------------------------------


//This is where the bullet bounces off.
/atom/proc/bullet_ping(obj/item/projectile/P, pixel_x_offset = 0, pixel_y_offset = 0)
	if(!P || !P.ammo.ping)
		return

	if(P.ammo.sound_bounce) playsound(src, P.ammo.sound_bounce, 50, 1)
	var/image/I = image('icons/obj/items/weapons/projectiles.dmi', src, P.ammo.ping, 10)
	var/offset_x = Clamp(P.pixel_x + pixel_x_offset, -10, 10)
	var/offset_y = Clamp(P.pixel_y + pixel_y_offset, -10, 10)
	I.pixel_x += round(rand(-4,4) + offset_x, 1)
	I.pixel_y += round(rand(-4,4) + offset_y, 1)

	var/matrix/rotate = matrix()
	rotate.Turn(P.angle)
	I.transform = rotate
	// Need to do this in order to prevent the ping from being deleted
	addtimer(CALLBACK(I, TYPE_PROC_REF(/image, flick_overlay), src, 3), 1)

/mob/proc/bullet_message(obj/item/projectile/P)
	if(!P)
		return
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
