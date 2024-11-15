/**
 * Space weapons it's self for ship to ship or PKO/Xeno PKO things
 */
/datum/space_weapon
	var/name = "SMP"
	var/list/possibly_ammunition = list()
	//add some useful things here and make it object... later... skill issue.

/datum/space_weapon/proc/on_shot(location, list/potential_ammo, intercept_chance, delay = 0)
	var/intercepted = 0
	var/missed = 0
	var/hits = 0
	for(var/turf/picked_atom in location)
		var/datum/space_weapon_ammo/ammo = GLOB.space_weapons_ammo[pick(potential_ammo)]
		var/accuracy = rand(1, 100)
		if(ammo.interceptable && intercept_chance > accuracy)
			ammo.miss_target(picked_atom, TRUE)
			intercepted++
		else if(ammo.base_miss_chance + intercept_chance > accuracy)
			ammo.miss_target(picked_atom, FALSE)
			missed++
		else
			ammo.hit_target(picked_atom)
			hits++
		sleep(delay)
	shipwide_ai_announcement("WARNING, [hits] HIT SHIP HULL, [missed] MISSED AND [intercepted] INTERCEPTED!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')

/datum/space_weapon/proc/shot_message(quantity, hit_eta)
	return

/datum/space_weapon/rail_gun
	name = "Railgun"
	possibly_ammunition = list(
		/datum/space_weapon_ammo/rail_gun,
		/datum/space_weapon_ammo/rail_gun/stronk,
	)

/datum/space_weapon/rail_gun/shot_message(quantity, hit_eta)
	shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING PROJECTILE[quantity > 1 ? "S" : ""]. BRACE, BRACE, BRACE. [quantity > 1 ? "SALVO SIZE: [quantity]," : ""] ESTIMATED TIME: [hit_eta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')

/datum/space_weapon/rocket_launcher
	name = "Rocket Launcher"
	possibly_ammunition = list(
		/datum/space_weapon_ammo/rocket_launcher,
		/datum/space_weapon_ammo/rocket_launcher/swing_rockets,
	)

/datum/space_weapon/rocket_launcher/shot_message(quantity, hit_eta)
	shipwide_ai_announcement("DANGER: MISSILE WARNING, LAUNCH DETECTED. BRACE, BRACE, BRACE. [quantity > 1 ? "SALVO SIZE: [quantity]," : ""] ESTIMATED TIME: [hit_eta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')

/**
 * Ammo datum for space weapons
 */
/datum/space_weapon_ammo
	var/name = "SMP"
	var/base_miss_chance = 25
	var/list/miss_sound = list()
	var/list/intercept_sound = list()
	var/list/hit_sound = list()
	var/interceptable = TRUE

/datum/space_weapon_ammo/proc/miss_target(picked_atom, intercepted)
	return

/datum/space_weapon_ammo/proc/hit_target(picked_atom)
	return

/datum/space_weapon_ammo/rail_gun
	name = "Piercing Near-Lightning Railgun Projectile"
	base_miss_chance = 35
	miss_sound = list('sound/effects/railgun_miss.ogg')
	intercept_sound = list('sound/effects/laser_point_defence_success.ogg')
	hit_sound = list('sound/effects/railgunhit.ogg')

/datum/space_weapon_ammo/rail_gun/miss_target(picked_atom, intercepted)
	var/list/echo_list = new /list(18)
	echo_list[ECHO_OBSTRUCTION] = -2500
	if(intercepted)
		playsound(picked_atom, pick(intercept_sound), 100, 1, 100, echo = echo_list)
	else
		playsound(picked_atom, pick(miss_sound), 5, 1, 100, echo = echo_list)
	shipwide_ai_announcement("[capitalize(name)] [intercepted ? "INTERCEPTED" : "MISSED"]!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')

/datum/space_weapon_ammo/rail_gun/hit_target(picked_atom)
	var/list/echo_list = new /list(18)
	echo_list[ECHO_OBSTRUCTION] = -500
	cell_explosion(picked_atom, 1000, 200, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data(name))
	shakeship(5, 5, FALSE, FALSE)
	playsound(picked_atom, "bigboom", 50, 1, 200, echo = echo_list)
	playsound(picked_atom, pick(hit_sound), 50, 1, 200, echo = echo_list)
	shipwide_ai_announcement("WARNING, [capitalize(name)] HIT SHIP HULL, CAUSED MASSIVE DAMAGE!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')

/datum/space_weapon_ammo/rail_gun/stronk
	name = "Piercing Near-Lightning Railgun Projectile of Increased Strength"
	base_miss_chance = 50
	interceptable = FALSE

/datum/space_weapon_ammo/rocket_launcher
	name = "Anti-Ship missile"
	base_miss_chance = 15
	miss_sound = list('sound/effects/metal_shatter.ogg')
	intercept_sound = list('sound/effects/laser_point_defence_success.ogg')
	hit_sound = list('sound/effects/metal_crash.ogg')

/datum/space_weapon_ammo/rocket_launcher/miss_target(picked_atom, intercepted)
	var/list/echo_list = new(18)
	echo_list[ECHO_OBSTRUCTION] = -2500
	if(intercepted)
		playsound(picked_atom, pick(intercept_sound), 100, 1, 100, echo = echo_list)
	else
		playsound(picked_atom, pick(miss_sound), 5, 1, 100, echo = echo_list)
	shipwide_ai_announcement("[capitalize(name)] [intercepted ? "INTERCEPTED" : "MISSED"]!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')

/datum/space_weapon_ammo/rocket_launcher/hit_target(picked_atom)
	var/list/echo_list = new(18)
	echo_list[ECHO_OBSTRUCTION] = -500
	cell_explosion(picked_atom, 500, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data(name))
	shakeship(5, 5, FALSE, FALSE)
	playsound(picked_atom, "bigboom", 50, 1, 200, echo = echo_list)
	playsound(picked_atom, pick(hit_sound), 50, 1, 200, echo = echo_list)
	playsound(picked_atom, "pry", 25, 1, 200, echo = echo_list)
	shipwide_ai_announcement("WARNING, [capitalize(name)] HIT SHIP HULL, CAUSED MASSIVE DAMAGE!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')

/datum/space_weapon_ammo/rocket_launcher/swing_rockets
	name = "Swing High Pierce Shreder Rockets"
	base_miss_chance = 0

/datum/space_weapon_ammo/rocket_launcher/swing_rockets/hit_target(picked_atom)
	var/list/echo_list = new /list(18)
	echo_list[ECHO_OBSTRUCTION] = -500
	var/list/turf_list = list()
	for(var/turf/turf in range(7, picked_atom))
		turf_list += turf

	playsound(picked_atom, "pry", 25, 1, 200, echo = echo_list)
	playsound(picked_atom, pick(hit_sound), 50, 1, 200, echo = echo_list)
	playsound(picked_atom, "bigboom", 50, 1, 200, echo = echo_list)
	for(var/i = 1 to 12)
		var/turf/turf = pick(turf_list)
		cell_explosion(turf, 100, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data(name))
		playsound(turf, "bigboom", 40, 1, 20, echo = echo_list)
		shakeship(2, 2, FALSE, FALSE)
		sleep(1)

	shipwide_ai_announcement("WARNING, [capitalize(name)] HIT SHIP HULL, CAUSED MASSIVE DOT DAMAGE!", MAIN_AI_SYSTEM, 'sound/effects/double_klaxon.ogg')
