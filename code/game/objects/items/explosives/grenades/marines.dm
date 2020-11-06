
/*
//================================================
				Blast Grenades
//================================================
*/

#define GRENADE_FIRE_RESISTANCE_MIN 10
#define GRENADE_FIRE_RESISTANCE_MAX 40

/obj/item/explosive/grenade/HE
	name = "\improper M40 HEDP grenade"
	desc = "High-Explosive Dual-Purpose. A small, but deceptively strong blast grenade that has been phasing out the M15 HE grenades alongside the M40 HEFA. Capable of being loaded in the M92 Launcher, or thrown by hand."
	icon_state = "grenade"
	det_time = 40
	item_state = "grenade_hedp"
	dangerous = 1
	underslug_launchable = TRUE
	var/explosion_power = 100
	var/explosion_falloff = 25
	var/shrapnel_count = 0
	var/shrapnel_type = /datum/ammo/bullet/shrapnel
	var/fire_resistance = 30 //to prevent highly controlled massive explosions
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL

/obj/item/explosive/grenade/HE/New()
	..()

	fire_resistance = rand(GRENADE_FIRE_RESISTANCE_MIN, GRENADE_FIRE_RESISTANCE_MAX)

/obj/item/explosive/grenade/HE/prime()
	set waitfor = 0
	if(shrapnel_count)
		create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, initial(name), source_mob)
		sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, null, initial(name), source_mob)
	qdel(src)


/obj/item/explosive/grenade/HE/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)

/obj/item/explosive/grenade/HE/flamer_fire_act()
	fire_resistance--
	if(fire_resistance<=0)
		prime()

/obj/item/explosive/grenade/HE/PMC
	name = "\improper M12 blast grenade"
	desc = "A high-explosive grenade produced for private security firms. It explodes 3 seconds after the pin has been pulled."
	icon_state = "grenade_pmc"
	item_state = "grenade_ex"
	underslug_launchable = FALSE
	explosion_power = 130
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR



/obj/item/explosive/grenade/HE/stick
	name = "\improper Webley Mk15 stick grenade"
	desc = "A blast grenade produced in the colonies, most commonly using old designs and schematics. It explodes 3 seconds after the pin has been pulled."
	icon_state = "grenade_stick"
	item_state = "grenade_stick"
	force = 10
	w_class = SIZE_SMALL
	throwforce = 15
	throw_speed = SPEED_FAST
	throw_range = 7
	underslug_launchable = FALSE
	explosion_power = 100
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR


/*
//================================================
				Fragmentation Grenades
//================================================
*/
/obj/item/explosive/grenade/HE/frag
	name = "\improper M40 HEFA grenade"
	desc = "High-Explosive Fragmenting-Antipersonnel. A small, but deceptively strong fragmentation grenade that has been phasing out the M15 fragmentation grenades alongside the M40 HEDP. Capable of being loaded in the M92 Launcher, or thrown by hand."
	icon_state = "grenade_hefa"
	item_state = "grenade_hefa"
	explosion_power = 40
	shrapnel_count = 48
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR



/obj/item/explosive/grenade/HE/m15
	name = "\improper M15 fragmentation grenade"
	desc = "An outdated USCM Fragmentation Grenade. With decades of service in the USCM, the old M15 Fragmentation Grenade is slowly being replaced by the slightly safer M40-series grenades. It is set to detonate in 4 seconds."
	icon_state = "grenade_ex"
	item_state = "grenade_ex"
	throw_speed = SPEED_FAST
	throw_range = 6
	underslug_launchable = FALSE
	explosion_power = 120
	shrapnel_count = 48
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR



/obj/item/explosive/grenade/HE/upp
	name = "\improper Type 6 shrapnel grenade"
	desc = "A fragmentation grenade found within the ranks of the UPP. Designed to explode into shrapnel and rupture the bodies of opponents. It explodes 3 seconds after the pin has been pulled."
	icon_state = "grenade_upp"
	item_state = "grenade_upp"
	throw_speed = SPEED_FAST
	throw_range = 6
	underslug_launchable = FALSE
	explosion_power = 60
	shrapnel_count = 56
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/*
//================================================
				Airburst Grenades
//================================================
*/
// M74 are the launcher-only variant. Flag with hand_throwable = FALSE.
/obj/item/explosive/grenade/HE/airburst
	name = "\improper M74 AGM-F 40mm Grenade"
	desc = "M74 - Airburst Grenade Munition - Fragmentation. This grenade must be launched with a grenade launcher, and detonates once it reaches its destination. It disperse jagged shrapnel in a cone in front of itself, tearing through sinews and armor alike. Dispersion pattern is optimized against large target. Suffers from overpenetration on a direct hit."
	icon_state = "grenade_m74_airburst_f"
	item_state = "grenade_m74_airburst_f_active"
	explosion_power = 0
	explosion_falloff = 25
	shrapnel_count = 30
	det_time = 0 // Unused, because we don't use prime.
	hand_throwable = FALSE
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
	shrapnel_type = /datum/ammo/bullet/shrapnel/jagged
	var/direct_hit_shrapnel = 5
	var/dispersion_angle = 60

/obj/item/explosive/grenade/HE/airburst/prime()
// We don't prime, we use launch_impact.

/obj/item/explosive/grenade/HE/airburst/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	var/turf/hit_turf = null
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom))
		hit_turf = hit_atom
		if(hit_turf.density && !rebounding)
			detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		if(hit_turf)
			for(var/mob/M in hit_turf)
				create_shrapnel(loc, direct_hit_shrapnel, last_move_dir , dispersion_angle ,shrapnel_type, initial(name), source_mob, FALSE, 100)
				M.Superslow(3.0)
				shrapnel_count -= direct_hit_shrapnel
				continue
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, last_move_dir , dispersion_angle ,shrapnel_type, initial(name), source_mob, FALSE, 0)
			sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
		apply_explosion_overlay()
		if(explosion_power)
			cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, last_move_dir, initial(name), source_mob)
		qdel(src)
/*
//================================================
				Incendiary Grenades
//================================================
*/

/obj/item/explosive/grenade/incendiary
	name = "\improper M40 HIDP incendiary grenade"
	desc = "The M40 HIDP is a small, but deceptively strong incendiary grenade. It is set to detonate in 4 seconds."
	icon_state = "grenade_fire"
	det_time = 40
	item_state = "grenade_fire"
	flags_equip_slot = SLOT_WAIST
	dangerous = 1
	underslug_launchable = TRUE
	var/flame_level = 20
	var/burn_level = 15
	var/flameshape = FLAMESHAPE_DEFAULT
	var/radius = 2

/obj/item/explosive/grenade/incendiary/prime()
	INVOKE_ASYNC(GLOBAL_PROC, .proc/flame_radius, initial(name), source_mob, radius, get_turf(src), flame_level, burn_level, flameshape, null)
	playsound(src.loc, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
	qdel(src)

/proc/flame_radius(var/source, var/source_mob, var/radius = 1, var/turf/T, var/flame_level = 14, var/burn_level = 15, var/flameshape = FLAMESHAPE_DEFAULT, var/target)
	if(!istype(T))
		return
	var/datum/reagent/R = new /datum/reagent/napalm/ut()
	if(burn_level >= BURN_LEVEL_TIER_7)
		R = new /datum/reagent/napalm/blue()
	else if(burn_level <= BURN_LEVEL_TIER_2)
		R = new /datum/reagent/napalm/green()

	R.durationfire = flame_level
	R.intensityfire = burn_level
	R.rangefire = radius

	new /obj/flamer_fire(T, source, source_mob, R, R.rangefire, null, flameshape, target)

/obj/item/explosive/grenade/incendiary/molotov
	name = "\improper improvised firebomb"
	desc = "A potent, improvised firebomb, coupled with a pinch of gunpowder. Cheap, very effective, and deadly in confined spaces. Commonly found in the hands of rebels and terrorists. It can be difficult to predict how many seconds you have before it goes off, so be careful. Chances are, it might explode in your face."
	icon_state = "molotov"
	item_state = "molotov"
	arm_sound = 'sound/items/Welder2.ogg'
	underslug_launchable = FALSE

/obj/item/explosive/grenade/incendiary/molotov/New(loc, custom_burn_level)
	det_time = rand(10,40) //Adds some risk to using this thing.
	if(custom_burn_level)
		burn_level = custom_burn_level
	..(loc)

/obj/item/explosive/grenade/incendiary/molotov/prime()
	playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 35, 1, 4)
	..()

/*
//================================================
				Airburst Incendiary Grenades
//================================================
*/
// M74 are the launcher-only variant. Flag with hand_throwable = FALSE.
/obj/item/explosive/grenade/incendiary/airburst
	name = "\improper M74 AGM-I 40mm Grenade"
	desc = "M74 - Airburst Grenade Munition - Incendiary. This grenade must be launched with a grenade launcher, and detonates once it reaches its destination. It disperse a cone of lingering flames in a small area in front of it. The warped pieces of the grenade can also set fire as they fly away."
	icon_state = "grenade_m74_airburst_i"
	item_state = "grenade_m74_airburst_i_active"
	det_time = 0 // Unused, because we don't use prime.
	hand_throwable = FALSE
	flame_level = 15
	burn_level = 20
	flameshape = FLAMESHAPE_TRIANGLE
	radius = 2
	var/shrapnel_count = 5
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/incendiary

/obj/item/explosive/grenade/incendiary/airburst/prime()
	
/obj/item/explosive/grenade/incendiary/airburst/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	var/turf/hit_turf = null
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom))
		hit_turf = hit_atom
		if(hit_turf.density && !rebounding)
			detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		var/angle = dir2angle(last_move_dir)
		var/turf/target = locate(src.loc.x + sin(angle)*radius, src.loc.y + cos(angle)*radius, src.loc.z)
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, last_move_dir , 30 ,shrapnel_type, initial(name), source_mob, FALSE, 0)
		if(target)
			INVOKE_ASYNC(GLOBAL_PROC, .proc/flame_radius, initial(name), source_mob, radius, get_turf(src), flame_level, burn_level, flameshape, target)
		else
			//Not stellar, but if we can't find a direction, fall back to HIDP behaviour.
			INVOKE_ASYNC(GLOBAL_PROC, .proc/flame_radius, initial(name), source_mob, radius, get_turf(src), flame_level, burn_level, FLAMESHAPE_DEFAULT, target)
		playsound(src.loc, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
		qdel(src)

/*
//================================================
				Smoke Grenades
//================================================
*/

/obj/item/explosive/grenade/smokebomb
	name = "\improper M40 HSDP smoke grenade"
	desc = "The M40 HSDP is a small, but powerful smoke grenade. Based off the same platform as the M40 HEDP. It is set to detonate in 2 seconds."
	icon_state = "grenade_smoke"
	det_time = 20
	item_state = "grenade_smoke"
	underslug_launchable = TRUE
	var/datum/effect_system/smoke_spread/bad/smoke

/obj/item/explosive/grenade/smokebomb/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/bad
	smoke.attach(src)

/obj/item/explosive/grenade/smokebomb/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	smoke.set_up(3, 0, get_turf(src), null, 6)
	smoke.start()
	qdel(src)

/obj/item/explosive/grenade/phosphorus
	name = "\improper M40 HPDP grenade"
	desc = "The M40 HPDP is a small, but powerful phosphorus grenade. It is set to detonate in 2 seconds."
	icon_state = "grenade_phos"
	det_time = 20
	item_state = "grenade_phos"
	underslug_launchable = TRUE
	var/datum/effect_system/smoke_spread/phosphorus/smoke
	dangerous = 1
	harmful = TRUE

/obj/item/explosive/grenade/phosphorus/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/phosphorus
	smoke.attach(src)

/obj/item/explosive/grenade/phosphorus/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	smoke.set_up(3, 0, get_turf(src))
	smoke.start()
	qdel(src)

/obj/item/explosive/grenade/phosphorus/upp
	name = "\improper Type 8 WP grenade"
	desc = "A deadly gas grenade found within the ranks of the UPP. Designed to spill white phosporus on the target. It explodes 2 seconds after the pin has been pulled."
	icon_state = "grenade_upp_wp"
	item_state = "grenade_upp_wp"

/obj/item/explosive/grenade/phosphorus/clf
	name = "\improper improvised phosphorus bomb"
	desc = "An improvised version of gas grenade designed to spill white phosporus on the target. It explodes 2 seconds after the pin has been pulled."
	icon_state = "grenade_clf_wp"
	item_state = "grenade_clf_wp"

/*
//================================================
					Other
//================================================
*/

/obj/item/explosive/grenade/HE/training
	name = "M07 training grenade"
	desc = "A harmless reusable version of the M40 HEDP, used for training. Capable of being loaded in the M92 Launcher, or thrown by hand."
	icon_state = "training_grenade"
	item_state = "grenade_training"
	dangerous = 0
	harmful = FALSE

/obj/item/explosive/grenade/HE/training/prime()
	spawn(0)
		playsound(loc, 'sound/items/detector.ogg', 80, 0, 7)
		active = 0 //so we can reuse it
		overlays.Cut()
		icon_state = initial(icon_state)
		det_time = initial(det_time) //these can be modified when fired by UGL
		throw_range = initial(throw_range)
		w_class = initial(w_class)


/obj/item/explosive/grenade/HE/training/flamer_fire_act()
	return

/obj/item/explosive/grenade/HE/holy_hand_grenade
	name = "\improper Holy Hand Grenade of Antioch"
	desc = "And Saint Attila raised the hand grenade up on high, saying, \"O LORD, bless this Thy hand grenade that with it Thou mayest blow Thine enemies to tiny bits, in Thy mercy.\" And the LORD did grin and the people did feast upon the lambs and sloths and carp and anchovies... And the LORD spake, saying, \"First shalt thou take out the Holy Pin, then shalt thou count to three, no more, no less. Three shall be the number thou shalt count, and the number of the counting shall be three. Four shalt thou not count, neither count thou two, excepting that thou then proceed to three. Five is right out. Once the number three, being the third number, be reached, then lobbest thou thy Holy Hand Grenade of Antioch towards thy foe, who, being naughty in My sight, shall snuff it.\""
	icon_state = "grenade_antioch"
	item_state = "grenade_antioch"
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	underslug_launchable = FALSE
	explosion_power = 300
	det_time = 50
	unacidable = TRUE
	arm_sound = 'sound/voice/holy_chorus.ogg'//https://www.youtube.com/watch?v=hNV5sPZFuGg
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
