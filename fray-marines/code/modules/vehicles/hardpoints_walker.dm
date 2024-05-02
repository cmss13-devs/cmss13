////////////////
// MEGALODON HARDPOINTS // START
////////////////

/obj/item/walker_gun
	name = "walker gun"
	icon = 'fray-marines/icons/obj/vehicles/mecha_guns.dmi'
	var/equip_state = ""
	w_class = 12.0
	var/obj/vehicle/walker/owner = null
	var/magazine_type = /obj/item/ammo_magazine/walker
	var/obj/item/ammo_magazine/walker/ammo = null
	var/list/fire_sound = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')
	var/fire_delay = 0
	var/last_fire = 0
	var/burst = 1

	w_class = 12.0

	var/muzzle_flash 	= "muzzle_flash"
	var/muzzle_flash_lum = 3 //muzzle flash brightness
	var/list/projectile_traits = list()
	var/automatic = TRUE
	var/shots_fired = 0
	var/fa_firing = FALSE

	var/atom/target = null
	var/scatter_value = 5

	var/autofire_slow_mult = 1

/obj/item/walker_gun/Initialize()
	. = ..()

	ammo = new magazine_type()

	if (automatic)
		AddComponent(/datum/component/automatedfire/autofire, fire_delay, fire_delay, burst, GUN_FIREMODE_AUTOMATIC, autofire_slow_mult, CALLBACK(src, PROC_REF(set_bursting)), CALLBACK(src, PROC_REF(reset_fire)), CALLBACK(src, PROC_REF(fire_wrapper)), CALLBACK(src, PROC_REF(display_ammo)), CALLBACK(src, PROC_REF(set_auto_firing))) //This should go after handle_starting_attachment() and setup_firemodes() to get the proper values set.

/obj/item/walker_gun/proc/register_signals(mob/user)
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(start_fire))
	RegisterSignal(user, COMSIG_MOB_MOUSEDRAG, PROC_REF(change_target))
	RegisterSignal(user, COMSIG_MOB_MOUSEUP, PROC_REF(stop_fire))

/obj/item/walker_gun/proc/unregister_signals(mob/user)
	UnregisterSignal(user, list(COMSIG_MOB_MOUSEUP, COMSIG_MOB_MOUSEDOWN, COMSIG_MOB_MOUSEDRAG))

/obj/item/walker_gun/proc/change_target(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	set_target(get_turf_on_clickcatcher(over_object, owner.seats[VEHICLE_DRIVER], params))

/obj/item/walker_gun/proc/start_fire(datum/source, atom/object, turf/location, control, params, bypass_checks = FALSE)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] || modifiers["middle"] || modifiers["right"])
		return

	// Don't allow doing anything else if inside a container of some sort, like a locker.
	if(!isturf(owner.loc))
		return

	if(istype(object, /atom/movable/screen))
		return

	if (!owner.firing_arc(object))
		return

	set_target(get_turf_on_clickcatcher(object, owner.seats[VEHICLE_DRIVER], params))

	SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/obj/item/walker_gun/proc/stop_fire()
	SIGNAL_HANDLER

	reset_fire()

/obj/item/walker_gun/proc/get_icon_image(hardpoint)
	if(!owner)
		return

	return image(owner.icon, equip_state + hardpoint)

/obj/item/walker_gun/proc/display_ammo(user)
	if(ammo)
		to_chat(user, SPAN_WARNING("[name] fired! [ammo.current_rounds]/[ammo.max_rounds] rounds remaining!"))
	else
		to_chat(user, SPAN_WARNING("[name] fired! NO rounds remaining!"))

/obj/item/walker_gun/proc/set_bursting(bursting = FALSE)
	return

/obj/item/walker_gun/proc/reset_fire()
	shots_fired = 0//Let's clean everything
	set_target(null)
	set_auto_firing(FALSE)
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)

/obj/item/walker_gun/proc/set_auto_firing(auto = FALSE)
	fa_firing = auto

/obj/item/walker_gun/proc/fire_wrapper(atom/target, mob/living/user, params, reflex = FALSE, dual_wield)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!target)
		target = src.target
	if(!user)
		user = owner.seats[VEHICLE_DRIVER]
	if(!target || !user || !owner.firing_arc(target))
		return NONE
	return active_effect(target, user)

/obj/item/walker_gun/proc/set_target(atom/object)
	if(object == target || object == loc)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	if (!owner.firing_arc(object) && object != null)
		reset_fire()
		return
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

/obj/item/walker_gun/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/obj/item/walker_gun/proc/active_effect(atom/target, mob/living/user)
	if (!ammo)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		return FALSE
	if(ammo.current_rounds <= 0)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		return FALSE
	if(world.time < last_fire + fire_delay)
		to_chat(user, "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return FALSE
	last_fire = world.time
	var/obj/projectile/P
	for(var/i = 1 to burst)
		if(!owner.firing_arc(target))
			if(i == 1)
				return
			display_ammo(user)
			visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")
			return FALSE
		P = new
		P.generate_bullet(new ammo.default_ammo)
		for (var/trait in projectile_traits)
			GIVE_BULLET_TRAIT(P, trait, FACTION_MARINE)
		playsound(get_turf(owner), pick(fire_sound), 60)
		target = simulate_scatter(target, P)
		P.fire_at(target, owner, src, P.ammo.max_range, P.ammo.shell_speed)
		ammo.current_rounds--
		if(ammo.current_rounds <= 0)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
			break
		sleep(3)
	display_ammo(user)
	visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")

	var/angle = round(Get_Angle(owner, target))
	muzzle_flash(angle)

	if(ammo && ammo.current_rounds <= 0)
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
	return TRUE

/obj/item/walker_gun/proc/muzzle_flash(angle, x_offset = -9, y_offset = 5)
	if(!muzzle_flash ||  isnull(angle))
		return //We have to check for null angle here, as 0 can also be an angle.
	if(!istype(owner) || !istype(owner.loc,/turf))
		return

	var/prev_light = light_range
	if(!light_on && (light_range <= muzzle_flash_lum))
		set_light_range(muzzle_flash_lum)
		set_light_on(TRUE)
		addtimer(CALLBACK(src, PROC_REF(reset_light_range), prev_light), 0.5 SECONDS)

	var/image_layer = (owner && owner.dir == SOUTH) ? MOB_LAYER+0.1 : MOB_LAYER-0.1
	var/offset = 5

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',owner,muzzle_flash,image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(owner, 3)

/// called by a timer to remove the light range from muzzle flash
/obj/item/walker_gun/proc/reset_light_range(lightrange)
	set_light_range(lightrange)
	if(lightrange <= 0)
		set_light_on(FALSE)

/obj/item/walker_gun/proc/simulate_scatter(atom/target, obj/projectile/projectile_to_fire)
	var/fire_angle = Get_Angle(owner.loc, get_turf(target))
	var/total_scatter_angle = projectile_to_fire.scatter - rand(-scatter_value,scatter_value)

	//Not if the gun doesn't scatter at all, or negative scatter.
	if(total_scatter_angle > 0)
		fire_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(owner.loc, fire_angle, 30)

	return get_turf(target)

/obj/item/walker_gun/smartgun
	name = "M56 High-Caliber Mounted Smartgun"
	desc = "Modified version of standart USCM Smartgun System, mounted on military walkers"
	icon_state = "mech_smartgun_parts"
	equip_state = "redy_smartgun"
	magazine_type = /obj/item/ammo_magazine/walker/smartgun
	burst = 3
	fire_delay = 3

	projectile_traits = list(/datum/element/bullet_trait_iff)

/obj/item/walker_gun/hmg
	name = "M30 Machine Gun"
	desc = "High-caliber machine gun firing small bursts of AP bullets, tearing into shreds unfortunate fellas on its way."
	icon_state = "mech_minigun_parts"
	equip_state = "redy_minigun"
	fire_sound = list('sound/weapons/gun_minigun.ogg')
	magazine_type = /obj/item/ammo_magazine/walker/hmg
	fire_delay = 7
	burst = 3
	scatter_value = 25

	projectile_traits = list()

/obj/item/walker_gun/flamer
	name = "F40 \"Hellfire\" Flamethower"
	desc = "Powerful flamethower, that can send any unprotected target straight to hell."
	icon_state = "mech_flamer_parts"
	equip_state = "redy_flamer"
	fire_sound = 'sound/weapons/gun_flamethrower2.ogg'
	magazine_type = /obj/item/ammo_magazine/walker/flamer
	var/fuel_pressure = 1 //Pressure setting of the attached fueltank, controls how much fuel is used per tile
	var/max_range = 9 //9 tiles, 7 is screen range, controlled by the type of napalm in the canister. We max at 9 since diagonal bullshit.
	fire_delay = 4 SECONDS

	automatic = FALSE

/obj/item/walker_gun/flamer/proc/get_fire_sound()
	var/list/fire_sounds = list(
							'sound/weapons/gun_flamethrower1.ogg',
							'sound/weapons/gun_flamethrower2.ogg',
							'sound/weapons/gun_flamethrower3.ogg')
	return pick(fire_sounds)

/obj/item/walker_gun/flamer/active_effect(atom/target, mob/living/user)
	if (!ammo)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		return
	if(ammo.current_rounds <= 0)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
		return
	if(world.time < last_fire + fire_delay)
		to_chat(user, "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return
	last_fire = world.time
	if(!ammo.reagents.reagent_list.len)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.")
		return

	var/datum/reagent/R = ammo.reagents.reagent_list[1]

	var/flameshape = R.flameshape
	var/fire_type = R.fire_type

	R.intensityfire = clamp(R.intensityfire, ammo.reagents.min_fire_int, ammo.reagents.max_fire_int)
	R.durationfire = clamp(R.durationfire, ammo.reagents.min_fire_dur, ammo.reagents.max_fire_dur)
	R.rangefire = clamp(R.rangefire, ammo.reagents.min_fire_rad, ammo.reagents.max_fire_rad)
	var/max_range = R.rangefire
	if (max_range < fuel_pressure) //Used for custom tanks, allows for higher ranges
		max_range = clamp(fuel_pressure, 0, ammo.reagents.max_fire_rad)
	if(R.rangefire == -1)
		max_range = ammo.reagents.max_fire_rad

	var/turf/temp[] = get_line(get_turf(owner), get_turf(target))

	var/turf/to_fire = temp[2]

	var/obj/flamer_fire/fire = locate() in to_fire
	if(fire)
		qdel(fire)

	playsound(to_fire, src.get_fire_sound(), 50, TRUE)
	ammo.current_rounds = ammo.reagents.total_volume

	new /obj/flamer_fire(to_fire, create_cause_data(initial(name), user), R, max_range, ammo.reagents, flameshape, target, CALLBACK(src, PROC_REF(show_percentage), user), fuel_pressure, fire_type)

	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
		return

/obj/item/walker_gun/flamer/proc/show_percentage(mob/living/user)
	if(ammo)
		to_chat(user, SPAN_WARNING("System Report: <b>[round(ammo.get_ammo_percent())]</b>% fuel remains!"))

///////////////
// AMMO MAGS // START
///////////////

/obj/item/ammo_magazine/walker
	w_class = SIZE_LARGE
	icon = 'fray-marines/icons/obj/vehicles/mecha_guns.dmi'

/obj/item/ammo_magazine/walker/smartgun
	name = "M56 Double-Barrel Magazine (Standard)"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "mech_smartgun_ammo"
	default_ammo = /datum/ammo/bullet/walker/smartgun
	max_rounds = 700
	gun_type = /obj/item/walker_gun/smartgun

/*
/obj/item/ammo_magazine/walker/smartgun/ap
	name = "M56 Double-Barrel Magazine (AP)"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "big_ammo_box_ap"
	default_ammo = /datum/ammo/bullet/smartgun/walker/ap
	max_rounds = 500
	gun_type = /obj/item/walker_gun/smartgun
/obj/item/ammo_magazine/walker/smartgun/incendiary
	name = "M56 Double-Barrel \"Scorcher\" Magazine"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "ammoboxslug"
	default_ammo = /datum/ammo/bullet/smartgun/walker/incendiary
	max_rounds = 500
	gun_type = /obj/item/walker_gun/smartgun
*/

/obj/item/ammo_magazine/walker/hmg
	name = "M30 Machine Gun Magazine"
	desc = "A armament M30 magazine"
	icon_state = "mech_minigun_ammo"
	max_rounds = 400
	default_ammo = /datum/ammo/bullet/walker/machinegun
	gun_type = /obj/item/walker_gun/hmg

/obj/item/ammo_magazine/walker/flamer
	name = "F40 UT-Napthal Canister"
	desc = "Canister for mounted flamethower"
	icon_state = "mech_flamer_s_ammo"
	max_rounds = 300
	default_ammo = /datum/ammo/flamethrower
	gun_type = /obj/item/walker_gun/flamer
	flags_magazine = AMMUNITION_HIDE_AMMO

	var/flamer_chem = "utnapthal"

	var/max_intensity = 40
	var/max_range = 5
	var/max_duration = 30

	var/fuel_pressure = 1 //How much fuel is used per tile fired
	var/max_pressure = 10

/obj/item/ammo_magazine/walker/flamer/Initialize(mapload, ...)
	. = ..()
	create_reagents(max_rounds)

	if(flamer_chem)
		reagents.add_reagent(flamer_chem, max_rounds)

	reagents.min_fire_dur = 1
	reagents.min_fire_int = 1
	reagents.min_fire_rad = 1

	reagents.max_fire_dur = max_duration
	reagents.max_fire_rad = max_range
	reagents.max_fire_int = max_intensity

/obj/item/ammo_magazine/walker/flamer/get_ammo_percent()
	if(!reagents)
		return 0

	return 100 * (reagents.total_volume / max_rounds)

// /obj/item/ammo_magazine/walker/flamer/ex
// 	name = "F40 UT-Napthal EX-type Canister"
// 	desc = "Canister for mounted flamethower"
// 	icon_state = "mech_flamer_ex_ammo"
// 	max_rounds = 300
// 	default_ammo = /datum/ammo/flamethrower
// 	gun_type = /obj/item/walker_gun/flamer

// 	flamer_chem = "napalmex"

// 	max_intensity = 40
// 	max_range = 5
// 	max_duration = 30

// 	fuel_pressure = 1 //How much fuel is used per tile fired
// 	max_pressure = 10

/obj/item/ammo_magazine/walker/flamer/btype
	name = "F40 UT-Napthal B-type Canister"
	desc = "Canister for mounted flamethower"
	icon_state = "mech_flamer_b_ammo"
	max_rounds = 300
	default_ammo = /datum/ammo/flamethrower
	gun_type = /obj/item/walker_gun/flamer

	flamer_chem = "napalmb"

	max_intensity = 40
	max_range = 5
	max_duration = 30

	fuel_pressure = 1 //How much fuel is used per tile fired
	max_pressure = 10
///////////////
// AMMO MAGS // END
///////////////

/datum/ammo/bullet/walker/smartgun
	name = "smartgun bullet"
	icon_state = "redbullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	max_range = 24
	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_5
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_1

/datum/ammo/bullet/walker/machinegun
	name = "machinegun bullet"
	icon_state = "bullet"

	accurate_range = 6
	max_range = 12
	damage = 45
	penetration= ARMOR_PENETRATION_TIER_5
	accuracy = -HIT_ACCURACY_TIER_3

////////////////
// MEGALODON HARDPOINTS // END
////////////////

/datum/supply_packs/ammo_m56_walker
	name = "M56 Double-Barrel magazines (x2)"
	contains = list(
		/obj/item/ammo_magazine/walker/smartgun,
		/obj/item/ammo_magazine/walker/smartgun,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M56 Double-Barrel ammo crate"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_M30_walker
	name = "M30 Machine Gun magazines (x2)"
	contains = list(
		/obj/item/ammo_magazine/walker/hmg,
		/obj/item/ammo_magazine/walker/hmg,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M30 Machine Gun ammo crate"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_F40_walker
	name = "F40 Flamethower Mixed magazines (UT-Napthal x1, B-Type x1)"
	contains = list(
		/obj/item/ammo_magazine/walker/flamer,
		/obj/item/ammo_magazine/walker/flamer/btype,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "F40 Flamethower ammo crate"
	group = "Vehicle Ammo"

////////////////
// MEGALODON SUPPLYPACKS // END
////////////////
