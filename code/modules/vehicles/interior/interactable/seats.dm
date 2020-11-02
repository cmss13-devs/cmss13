/obj/structure/bed/chair/comfy/vehicle
	name = "seat"

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The vehicle this seat is tied to
	var/obj/vehicle/multitile/vehicle = null

	// Which seat this is in the vehicle
	var/seat = null

/obj/structure/bed/chair/comfy/vehicle/ex_act()
	return

/obj/structure/bed/chair/comfy/vehicle/afterbuckle(var/mob/M)
	..()

	if(!vehicle)
		return

	if(QDELETED(buckled_mob))
		vehicle.set_seated_mob(seat, null)
		M.unset_interaction()
		if(M.client)
			M.client.change_view(7)
			M.client.pixel_x = 0
			M.client.pixel_y = 0
	else
		vehicle.set_seated_mob(seat, M)
		M.client.change_view(8)

// Pass movement relays to the vehicle
/obj/structure/bed/chair/comfy/vehicle/relaymove(mob/user, direction)
	vehicle.relaymove(user, direction)

// Driver's seat
/obj/structure/bed/chair/comfy/vehicle/driver
	name = "driver's seat"
	seat = VEHICLE_DRIVER

/obj/structure/bed/chair/comfy/vehicle/driver/do_buckle(var/mob/target, var/mob/user)
	if(!skillcheck(target, SKILL_VEHICLE, vehicle.required_skill))
		if(target == user)
			to_chat(user, SPAN_NOTICE("You have no idea how to drive this thing!"))
		return FALSE

	return ..()

// Gunner seat
/obj/structure/bed/chair/comfy/vehicle/gunner
	name = "gunner's seat"
	seat = VEHICLE_GUNNER

/obj/structure/bed/chair/comfy/vehicle/gunner/do_buckle(var/mob/target, var/mob/user)
	// Gunning always requires crewman-level skill
	if(!skillcheck(target, SKILL_VEHICLE, SKILL_VEHICLE_CREWMAN))
		if(target == user)
			to_chat(user, SPAN_NOTICE("You have no idea how to operate the weapons on this thing!"))
		return FALSE

	for(var/obj/item/I in user.contents)		//prevents shooting while zoomed in, but zoom can still be activated and used without shooting
		if(I.zoom)
			I.zoom(user)

	return ..()

/obj/structure/bed/chair/comfy/vehicle/rotate()
	set hidden = TRUE

/obj/structure/bed/chair/comfy/vehicle/attackby(obj/item/W, mob/living/user)
	return