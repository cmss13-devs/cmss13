/obj/item/hardpoint/gun/small_flamer
	name = "LZR-N Flamer Unit"
	desc = "A secondary weapon for tanks that spews hot fire."

	icon_state = "flamer"
	disp_icon = "tank"
	disp_icon_state = "flamer"
	firing_sounds = list('sound/weapons/tank_flamethrower.ogg')

	slot = HDPT_SECONDARY

	point_cost = 400
	health = 300
	damage_multiplier = 0.125
	cooldown = 40
	accuracy = 0.68
	firing_arc = 90

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/secondary_flamer
	
	use_muzzle_flash = FALSE

	var/max_range = 7

	px_offsets = list(
		"1" = list(2, 14),
		"2" = list(-2, 3),
		"4" = list(3, 0),
		"8" = list(-3, 18)
	)

/obj/item/hardpoint/gun/small_flamer/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	var/list/turf/turfs = getline2(origin_turf, A)
	var/distance = 0
	var/turf/prev_T

	for(var/turf/T in turfs)
		if(T == loc)
			prev_T = T
			continue
		if(!ammo.current_rounds) 	break
		if(distance >= max_range) 	break
		if(prev_T && LinkBlocked(prev_T, T))
			break
		ammo.current_rounds--
		flame_turf(T)
		distance++
		prev_T = T
		sleep(1)

/obj/item/hardpoint/gun/small_flamer/proc/flame_turf(turf/T)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		new/obj/flamer_fire(T, initial(name), user)