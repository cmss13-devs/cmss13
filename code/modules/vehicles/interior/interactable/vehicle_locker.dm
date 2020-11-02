//WALL MOUNTED ~LOCKER~ STORAGE USED TO STORE SPECIFIC ITEMS IN IT
//changed from locker to structure with storage to stop
//littering up floor with opened locker and ramming objects

/obj/structure/vehicle_locker
	name = "wall-mounted storage compartment"
	desc = "Small storage unit allowing Vehicle Crewmen to store their personal possessions or weaponry ammunition. Only Vehicle Crewmen can access these."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "locker"
	anchored = TRUE
	density = FALSE
	layer = 3.2

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	var/list/role_restriction = list(JOB_CREWMAN)

	var/obj/item/storage/internal/container

/obj/structure/vehicle_locker/New()
	..()
	container = new/obj/item/storage/internal(src)
	container.storage_slots = null
	container.max_w_class = SIZE_MEDIUM
	container.w_class = SIZE_MASSIVE
	container.max_storage_space = 40
	container.bypass_w_limit = list(/obj/item/weapon/gun,
									/obj/item/storage/sparepouch,
									/obj/item/storage/large_holster/machete,
									/obj/item/storage/belt,
									/obj/item/storage/pouch,
									/obj/item/device/motiondetector,
									/obj/item/ammo_magazine/hardpoint,
									/obj/item/tool/weldpack
									)

/obj/structure/vehicle_locker/verb/empty_storage()
	set name = "Empty"
	set category = "Object"
	set src in range(0)

	var/mob/living/carbon/human/H = usr
	if (!ishuman(H) || H.is_mob_restrained())
		return

	if(!role_restriction.Find(H.job))
		to_chat(H, SPAN_WARNING("You cannot access \the [name]."))
		return

	empty(get_turf(H), H)

//regular storage's empty() proc doesn't work due to checks, so imitate it
/obj/structure/vehicle_locker/proc/empty(var/turf/T, var/mob/living/carbon/human/H)
	if(!container)
		to_chat(H, SPAN_WARNING("No internal storage found."))
		return

	H.visible_message(SPAN_NOTICE("[H] starts to empty \the [src]..."), SPAN_NOTICE("You start to empty \the [src]..."))
	if(!do_after(H, SECONDS_2, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_WARNING("[H] stops emptying \the [src]..."), SPAN_WARNING("You stop emptying \the [src]..."))
		return

	container.hide_from(H)
	for (var/obj/item/I in container.contents)
		container.remove_from_storage(I, T)
	H.visible_message(SPAN_NOTICE("[H] empties \the [src]."), SPAN_NOTICE("You empty \the [src]."))

	container.empty(H, get_turf(H))

/obj/structure/vehicle_locker/clicked(var/mob/living/carbon/human/user, var/list/mods)
	..()
	if(!istype(user))
		return

	if(user.is_mob_incapacitated())
		return

	if(user.get_active_hand())
		return

	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return

	if(Adjacent(user))
		container.open(user)
		return

//due to how /internal coded, this doesn't work, so we used workaround above
/obj/structure/vehicle_locker/attack_hand(var/mob/user)
	return

/obj/structure/vehicle_locker/MouseDrop(var/obj/over_object)
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return
	if (container.handle_mousedrop(user, over_object))
		..(over_object)

/obj/structure/vehicle_locker/attackby(var/obj/item/W, var/mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!istype(user))
		return
	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return
	return container.attackby(W, user)

/obj/structure/vehicle_locker/emp_act(var/severity)
	container.emp_act(severity)
	..()

/obj/structure/vehicle_locker/hear_talk(var/mob/M, var/msg)
	container.hear_talk(M, msg)
	..()

