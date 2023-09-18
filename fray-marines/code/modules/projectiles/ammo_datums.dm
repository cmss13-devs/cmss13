/datum/ammo/flamethrower/tank_flamer/buffed/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T)) return
	var/datum/reagent/napalm/blue/B = new()
	new /obj/flamer_fire(T, cause_data, B, 1)

/datum/ammo/rocket/ap/tank
	accurate_range = 8
	max_range = 10
