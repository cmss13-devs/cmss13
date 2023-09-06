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
	var/fire_sound = 'sound/weapons/gun_smartgun1.ogg'
	var/fire_delay = 0
	var/last_fire = 0
	var/burst = 1

	w_class = 12.0

	var/muzzle_flash 	= "muzzle_flash"
	var/muzzle_flash_lum = 3 //muzzle flash brightness

/obj/item/walker_gun/proc/get_icon_image(hardpoint)
	if(!owner)
		return

	return image(owner.icon, equip_state + hardpoint)

/obj/item/walker_gun/proc/active_effect(atom/target)
	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.seats[VEHICLE_DRIVER], "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		if(ammo)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
		return
	if(world.time < last_fire + fire_delay)
		to_chat(owner.seats[VEHICLE_DRIVER], "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return
	last_fire = world.time
	var/obj/item/projectile/P
	for(var/i = 1 to burst)
		if(!owner.firing_arc(target))
			if(i == 1)
				return
			to_chat(owner.seats[VEHICLE_DRIVER] , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] remaining!")
			visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")
			return
		P = new
		P.generate_bullet(new ammo.default_ammo)
		playsound(src, fire_sound, 60)
		target = simulate_scatter(target, P)
		P.fire_at(target, owner, src, P.ammo.max_range, P.ammo.shell_speed)
		ammo.current_rounds--
		if(ammo.current_rounds <= 0)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
			break
		sleep(3)
	to_chat(owner.seats[VEHICLE_DRIVER] , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] remaining!")
	visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")

	var/angle = round(Get_Angle(owner,target))
	muzzle_flash(angle)

	if(ammo.current_rounds <= 0)
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
	return TRUE

/obj/item/walker_gun/proc/muzzle_flash(angle, x_offset = 0, y_offset = 5)
	if(!muzzle_flash ||  isnull(angle))
		return //We have to check for null angle here, as 0 can also be an angle.
	if(!istype(owner) || !istype(owner.loc,/turf))
		return

	if(owner.luminosity <= muzzle_flash_lum)
		owner.set_light(muzzle_flash_lum)
		spawn(10)
			owner.set_light(-muzzle_flash_lum)

/obj/item/walker_gun/proc/simulate_scatter(atom/target, obj/item/projectile/projectile_to_fire)
	var/total_chance = projectile_to_fire.scatter
	if(total_chance <= 0)
		return target
	var/targdist = get_dist(target, owner)
	if(targdist <= (4 + rand(-1, 1)))
		return target
	if(burst > 1)
		total_chance += burst * 2

	var/turf/targloc = get_turf(target)
	if(prob(total_chance)) //Scattered!
		var/scatter_x = rand(-1,1)
		var/scatter_y = rand(-1,1)
		var/turf/new_target = locate(targloc.x + round(scatter_x),targloc.y + round(scatter_y),targloc.z) //Locate an adjacent turf.
		if(new_target)
			target = new_target//Looks like we found a turf.
	return target


/obj/item/walker_gun/smartgun
	name = "M56 Double-Barrel Mounted Smartgun"
	desc = "Modifyed version of standart USCM Smartgun System, mounted on military walkers"
	icon_state = "mecha_smartgun"
	equip_state = "mech-shot"
	magazine_type = /obj/item/ammo_magazine/walker/smartgun
	burst = 2
	fire_delay = 6

/obj/item/walker_gun/hmg
	name = "M30 Machine Gun"
	desc = "High-caliber machine gun firing small bursts of AP bullets, tearing into shreds unfortunate fellas on its way."
	icon_state = "mecha_machinegun"
	equip_state = "mech-gatt"
	fire_sound = 'sound/weapons/gun_minigun.ogg'
	magazine_type = /obj/item/ammo_magazine/walker/hmg
	fire_delay = 20
	burst = 3

/obj/item/walker_gun/flamer
	name = "F40 \"Hellfire\" Flamethower"
	desc = "Powerful flamethower, that can send any unprotected target straight to hell."
	icon_state = "mecha_flamer"
	equip_state = "mech-flam"
	fire_sound = 'sound/weapons/gun_flamethrower2.ogg'
	magazine_type = /obj/item/ammo_magazine/walker/flamer
	var/fuel_pressure = 1 //Pressure setting of the attached fueltank, controls how much fuel is used per tile
	var/max_range = 9 //9 tiles, 7 is screen range, controlled by the type of napalm in the canister. We max at 9 since diagonal bullshit.
	fire_delay = 30

/obj/item/walker_gun/flamer/proc/get_fire_sound()
	var/list/fire_sounds = list(
							'sound/weapons/gun_flamethrower1.ogg',
							'sound/weapons/gun_flamethrower2.ogg',
							'sound/weapons/gun_flamethrower3.ogg')
	return pick(fire_sounds)

/obj/item/walker_gun/flamer/active_effect(atom/target)
	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.seats[VEHICLE_DRIVER], "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		if(ammo)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
		return
	if(world.time < last_fire + fire_delay)
		to_chat(owner.seats[VEHICLE_DRIVER], "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return
	var/datum/reagent/R = ammo.reagents.reagent_list[1]

	var/flameshape = R.flameshape
	var/fire_type = R.fire_type

	R.intensityfire = Clamp(R.intensityfire, ammo.reagents.min_fire_int, ammo.reagents.max_fire_int)
	R.durationfire = Clamp(R.durationfire, ammo.reagents.min_fire_dur, ammo.reagents.max_fire_dur)
	R.rangefire = Clamp(R.rangefire, ammo.reagents.min_fire_rad, ammo.reagents.max_fire_rad)
	var/max_range = R.rangefire
	if (max_range < fuel_pressure) //Used for custom tanks, allows for higher ranges
		max_range = Clamp(fuel_pressure, 0, ammo.reagents.max_fire_rad)
	if(R.rangefire == -1)
		max_range = ammo.reagents.max_fire_rad

	var/turf/temp[] = getline2(get_turf(owner), get_turf(target))

	var/turf/to_fire = temp[2]

	var/obj/flamer_fire/fire = locate() in to_fire
	if(fire)
		qdel(fire)

	playsound(to_fire, src.get_fire_sound(), 50, TRUE)

	new /obj/flamer_fire(to_fire, create_cause_data(initial(name), owner.seats[VEHICLE_DRIVER]), R, max_range, ammo.reagents, flameshape, target, CALLBACK(src, PROC_REF(show_percentage), owner.seats[VEHICLE_DRIVER]), fuel_pressure, fire_type)

	to_chat(owner.seats[VEHICLE_DRIVER] , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] charges remaining!")

	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.seats[VEHICLE_DRIVER], "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
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
	w_class = 12.0

/obj/item/ammo_magazine/walker/smartgun
	name = "M56 Double-Barrel Magazine (Standard)"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "big_ammo_box"
	default_ammo = /datum/ammo/bullet/smartgun
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
	icon_state = "ua571c"
	max_rounds = 300
	default_ammo = /datum/ammo/bullet/machinegun
	gun_type = /obj/item/walker_gun/hmg

/obj/item/ammo_magazine/walker/flamer
	name = "F40 Canister"
	desc = "Canister for mounted flamethower"
	icon_state = "flametank_large"
	max_rounds = 500
	default_ammo = /datum/ammo/flamethrower
	gun_type = /obj/item/walker_gun/flamer

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

///////////////
// AMMO MAGS // END
///////////////
////////////////
// MEGALODON HARDPOINTS // END
////////////////
