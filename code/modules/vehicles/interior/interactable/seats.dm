//regular vehicle seats for general vehicles.
/obj/structure/bed/chair/comfy/vehicle
	name = "seat"

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	//you want these chairs to not be easily obscured by objects
	layer = BELOW_MOB_LAYER

	// The vehicle this seat is tied to
	var/obj/vehicle/multitile/vehicle = null

	// Which seat this is in the vehicle
	var/seat = null

/obj/structure/bed/chair/comfy/vehicle/ex_act()
	return

/obj/structure/bed/chair/comfy/vehicle/handle_rotation()
	if(dir == NORTH)
		layer = FLY_LAYER
	else
		layer = BELOW_MOB_LAYER
	if(buckled_mob)
		buckled_mob.setDir(dir)

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
			to_chat(user, SPAN_WARNING("You have no idea how to drive this thing!"))
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
			to_chat(user, SPAN_WARNING("You have no idea how to operate the weapons on this thing!"))
		return FALSE

	for(var/obj/item/I in user.contents)		//prevents shooting while zoomed in, but zoom can still be activated and used without shooting
		if(I.zoom)
			I.zoom(user)

	return ..()

/obj/structure/bed/chair/comfy/vehicle/rotate()
	set hidden = TRUE

/obj/structure/bed/chair/comfy/vehicle/attackby(obj/item/W, mob/living/user)
	return

/obj/structure/bed/chair/comfy/vehicle/attack_alien(var/mob/living/carbon/Xenomorph/X, var/dam_bonus)

	if(X.is_mob_incapacitated() || !Adjacent(X))
		return

	if(buckled_mob)
		manual_unbuckle(X)
		return

//custom vehicle seats for armored vehicles
//spawners located in interior_landmarks

/obj/structure/bed/chair/comfy/vehicle/driver/armor
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/driver/armor/Initialize(mapload)
	over_image = image('icons/obj/vehicles/interiors/general.dmi', "armor_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/driver/armor/do_buckle(var/mob/target, var/mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/driver/armor/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

/obj/structure/bed/chair/comfy/vehicle/gunner/armor
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/Initialize(mapload)
	over_image = image('icons/obj/vehicles/interiors/general.dmi', "armor_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/do_buckle(var/mob/target, var/mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

//Armored vehicles passenger seats
/obj/structure/bed/chair/vehicle
	name = "passenger seat"
	desc = "A sturdy chair with a brace that lowers over your body. Holds you in place during vehicle movement. Fix with welding tool in case of damage."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "vehicle_seat"
	var/image/chairbar = null
	var/broken = FALSE
	buildstacktype = 0
	unslashable = FALSE
	unacidable = TRUE
	var/is_animating = 0

/obj/structure/bed/chair/vehicle/proc/break_seat()
	broken = TRUE
	if(buckled_mob)
		unbuckle()
	icon_state = "vehicle_seat_destroyed"

/obj/structure/bed/chair/vehicle/proc/repair_seat()
	broken = FALSE
	icon_state = "vehicle_seat"

/obj/structure/bed/chair/vehicle/rotate()
	return

/obj/structure/bed/chair/vehicle/ex_act(severity)
	if(broken || indestructible)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(20))
				break_seat()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(60))
				break_seat()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_seat()

/obj/structure/bed/chair/vehicle/Initialize()
	. = ..()
	chairbar = image('icons/obj/vehicles/interiors/general.dmi', "vehicle_bars")
	chairbar.layer = ABOVE_MOB_LAYER
	handle_rotation()

/obj/structure/bed/chair/vehicle/handle_rotation()
	if(dir == NORTH)
		layer = FLY_LAYER
	else
		layer = BELOW_MOB_LAYER
	if(buckled_mob)
		buckled_mob.setDir(dir)

/obj/structure/bed/chair/vehicle/afterbuckle()
	if(buckled_mob)
		icon_state = initial(icon_state) + "_buckled"
		overlays += chairbar
	else
		icon_state = initial(icon_state)
		overlays -= chairbar
	handle_rotation()

/obj/structure/bed/chair/vehicle/buckle_mob(mob/M, mob/user)
	if(broken)
		to_chat(user, SPAN_WARNING("\The [name] is broken and requires fixing with a welder!"))
		return
	..()

/obj/structure/bed/chair/vehicle/attack_alien(mob/living/user)
	if(!broken && !unslashable)
		user.visible_message(SPAN_WARNING("[user] smashes \the [src]!"),
		SPAN_WARNING("You smash \the [src]!"))
		playsound(loc, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)
		break_seat()

/obj/structure/bed/chair/vehicle/attackby(obj/item/W, mob/living/user)
	if((istype(W, /obj/item/tool/weldingtool) && broken))
		var/obj/item/tool/weldingtool/C = W
		if(C.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_WARNING("[user] begins repairing \the [src]."),
			SPAN_WARNING("You begin repairing \the [src]."))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && broken)
				user.visible_message(SPAN_WARNING("[user] repairs \the [src]."),
				SPAN_WARNING("You repair \the [src]."))
				repair_seat()
				return
