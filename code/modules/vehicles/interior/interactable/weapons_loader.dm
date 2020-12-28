/obj/structure/weapons_loader
	name = "ammunition loader"
	desc = "A hefty piece of machinery that sorts, moves and loads various ammunition into the correct guns."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	var/obj/vehicle/multitile/vehicle = null

// Loading new magazines
/obj/structure/weapons_loader/attackby(var/obj/item/I, var/mob/user)
	if(!istype(I, /obj/item/ammo_magazine/hardpoint))
		return ..()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("You have no idea how to operate this thing!"))
		return

	// Check if any of the hardpoints accept the magazine
	var/obj/item/hardpoint/reloading_hardpoint = null
	for(var/obj/item/hardpoint/H in vehicle.get_hardpoints_with_ammo())
		if(QDELETED(H) || QDELETED(H.ammo))
			continue

		if(istype(I, H.ammo.type))
			reloading_hardpoint = H
			break

	if(isnull(reloading_hardpoint))
		return ..()

	// Reload the hardpoint
	reloading_hardpoint.try_add_clip(I, user)

// Hardpoint reloading
/obj/structure/weapons_loader/attack_hand(var/mob/living/carbon/human/user)

	if(!user || !istype(user))
		return

	handle_reload(user)

// Landmark for spawning the reloader
/obj/effect/landmark/interior/spawn/weapons_loader
	name = "vehicle weapons reloader spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"
	color = "blue"

/obj/effect/landmark/interior/spawn/weapons_loader/on_load(var/datum/interior/I)
	var/obj/structure/weapons_loader/R = new(loc)

	R.icon = icon
	R.icon_state = icon_state
	R.layer = layer
	R.pixel_x = pixel_x
	R.pixel_y = pixel_y
	R.vehicle = I.exterior
	R.dir = dir
	R.update_icon()

	qdel(src)

obj/structure/weapons_loader/proc/reload_ammo()
	set name = "A: Reload Ammo"
	set category = "Object"
	set src in range(1)

	var/mob/living/carbon/human/H = usr
	if(!H || !istype(H))
		return

	handle_reload(H)

/obj/structure/weapons_loader/proc/handle_reload(var/mob/living/carbon/human/user)

	//something went bad, try to reconnect to vehicle if user is currently buckled in and connected to vehicle
	if(!vehicle)
		if(isVehicle(user.interactee))
			vehicle = user.interactee
		if(!istype(vehicle))
			to_chat(user, SPAN_WARNING("Critical Error! Ahelp this! Code: T_VMIS"))
			return

	var/list/hps = vehicle.get_hardpoints_with_ammo()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("You have no idea how to operate this thing!"))
		return

	if(!LAZYLEN(hps))
		to_chat(user, SPAN_WARNING("None of the hardpoints can be reloaded!"))
		return

	var/chosen_hp = input("Select a hardpoint") in (hps + "Cancel")
	if(chosen_hp == "Cancel")
		return

	var/obj/item/hardpoint/HP = chosen_hp

	// If someone removed the hardpoint while their dialogue was open or something
	if(QDELETED(HP))
		to_chat(user, SPAN_WARNING("Error! Module not found!"))
		return

	if(!LAZYLEN(HP.backup_clips))
		to_chat(user, SPAN_WARNING("\The [HP] has no remaining backup magazines!"))
		return

	var/obj/item/ammo_magazine/M = LAZYACCESS(HP.backup_clips, 1)
	if(!M)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp this! Code: T_BMIS"))
		return

	to_chat(user, SPAN_NOTICE("You begin reloading \the [HP]."))

	if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("Something interrupted you while reloading \the [HP]."))
		return

	HP.ammo.forceMove(get_turf(src))
	HP.ammo.update_icon()
	HP.ammo = M
	LAZYREMOVE(HP.backup_clips, M)

	playsound(loc, 'sound/machines/hydraulics_3.ogg', 50)
	to_chat(user, SPAN_NOTICE("You reload \the [HP]. Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"))
