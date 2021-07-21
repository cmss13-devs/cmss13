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

	var/list/role_restriction = list(JOB_CREWMAN, JOB_UPP_CREWMAN)

	var/obj/item/storage/internal/container

/obj/structure/vehicle_locker/Initialize()
	. = ..()
	container = new(src)
	container.storage_slots = null
	container.max_w_class = SIZE_MEDIUM
	container.w_class = SIZE_MASSIVE
	container.max_storage_space = 40
	container.use_sound = null
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
	if(!do_after(H, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_WARNING("[H] stops emptying \the [src]..."), SPAN_WARNING("You stop emptying \the [src]..."))
		return

	for(var/mob/M in container.content_watchers)
		container.storage_close(M)
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

//Cosmetically opens/closes the the locker when its storage window is accessed or closed. Only makes sound when not already open/closed.
/obj/structure/vehicle_locker/on_pocket_open(first_open)
	if(first_open)
		icon_state = "locker_open"
		playsound(src.loc, 'sound/handling/hinge_squeak1.ogg', 25, TRUE, 3)

/obj/structure/vehicle_locker/on_pocket_close(watchers)
	if(!watchers)
		icon_state = "locker"
		playsound(src.loc, "toolbox", 25, TRUE, 3)

/obj/structure/vehicle_locker/med
	name = "wall-mounted surgery kit storage"
	desc = "A small locker that securely stores a full surgical kit. ID-locked to surgeons."
	icon_state = "locker_med"
	role_restriction = list(JOB_CMO, JOB_DOCTOR, JOB_RESEARCHER, JOB_SYNTH, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_SEA, JOB_CLF_MEDIC, "Colonial Doctor", "Sorokyne Strata Doctor")

	var/has_tray = TRUE

/obj/structure/vehicle_locker/med/on_pocket_open(first_open)
	if(first_open)
		playsound(src.loc, 'sound/handling/hinge_squeak1.ogg', 25, TRUE, 3)

/obj/structure/vehicle_locker/med/on_pocket_close(watchers)
	if(!watchers)
		playsound(src.loc, "toolbox", 25, TRUE, 3)

/obj/structure/vehicle_locker/med/update_icon()
	if(has_tray)
		icon_state = initial(icon_state)
	else
		icon_state = "locker_open"

/obj/structure/vehicle_locker/med/Initialize()
	. = ..()
	container.max_storage_space = 24
	container.can_hold = list(
							/obj/item/tool/surgery,
							/obj/item/stack/medical/advanced/bruise_pack,
							/obj/item/stack/nanopaste
							)

	new /obj/item/tool/surgery/scalpel/manager(container)
	new /obj/item/tool/surgery/scalpel(container)
	new /obj/item/tool/surgery/hemostat(container)
	new /obj/item/tool/surgery/retractor(container)
	new /obj/item/stack/medical/advanced/bruise_pack(container)
	new /obj/item/tool/surgery/cautery(container)
	new /obj/item/tool/surgery/circular_saw(container)
	new /obj/item/tool/surgery/surgicaldrill(container)
	new /obj/item/tool/surgery/bonegel(container)
	new /obj/item/tool/surgery/bonesetter(container)
	new /obj/item/tool/surgery/FixOVein(container)
	new /obj/item/stack/nanopaste(container)

/obj/structure/vehicle_locker/med/examine(mob/user)
	..()
	to_chat(user, has_tray ? SPAN_HELPFUL("Right-click to remove the surgical tray from the locker.") : SPAN_WARNING("The surgical tray has been removed."))

/obj/structure/vehicle_locker/med/attackby(var/obj/item/W, var/mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!istype(user))
		return
	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return
	if(istype(W, /obj/item/storage/surgical_tray))
		add_tray(user, W)
		return
	if(!has_tray)
		to_chat(user, SPAN_WARNING("\The [name] doesn't have a surgical tray installed!"))
		return
	return container.attackby(W, user)

/obj/structure/vehicle_locker/med/clicked(var/mob/living/carbon/human/user, var/list/mods)
	if(!istype(user))
		return

	if(user.is_mob_incapacitated())
		return

	if(user.get_active_hand())
		return

	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return

	if(!has_tray)
		to_chat(user, SPAN_WARNING("\The [name] doesn't have a surgical tray installed!"))
		return

	if(Adjacent(user))
		container.open(user)
		return

/obj/structure/vehicle_locker/med/MouseDrop(var/obj/over_object)
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!role_restriction.Find(user.job))
		to_chat(user, SPAN_WARNING("You cannot access \the [name]."))
		return
	if(!has_tray)
		to_chat(user, SPAN_WARNING("\The [name] doesn't have a surgical tray installed!"))
		return
	if (container.handle_mousedrop(user, over_object))
		..(over_object)


/obj/structure/vehicle_locker/med/verb/remove_surgical_tray()
	set name = "Remove Surgical Tray"
	set category = "Object"
	set src in oview(1)

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(H.is_mob_incapacitated())
		return

	if(!role_restriction.Find(H.job))
		to_chat(H, SPAN_WARNING("You cannot access \the [name]."))
		return

	remove_tray(H)

/obj/structure/vehicle_locker/med/proc/remove_tray(var/mob/living/carbon/human/H)
	if(!has_tray)
		to_chat(H, SPAN_WARNING("The surgical tray was already removed!"))
		return

	H.visible_message(SPAN_NOTICE("[H] starts removing the surgical tray from \the [src]."), SPAN_NOTICE("You start removing the surgical tray from \the [src]."))
	if(!do_after(H, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_NOTICE("[H] stops removing the surgical tray from \the [src]."), SPAN_WARNING("You stop removing the surgical tray from \the [src]."))
		return

	var/obj/item/storage/surgical_tray/empty/tray = new(loc)
	var/turf/T = get_turf(src)
	for(var/obj/item/O in container.contents)
		container.remove_from_storage(O, T)
		tray.handle_item_insertion(O, TRUE)

	has_tray = FALSE
	update_icon()
	H.put_in_hands(tray)
	container.storage_close(H)
	H.visible_message(SPAN_NOTICE("[H] removes the surgical tray from \the [src]."), SPAN_NOTICE("You remove the surgical tray from \the [src]."))

/obj/structure/vehicle_locker/med/proc/add_tray(var/mob/living/carbon/human/H, var/obj/item/storage/surgical_tray/tray)
	if(has_tray)
		to_chat(H, SPAN_WARNING("\The [src] already has a surgical tray installed!"))
		return

	H.visible_message(SPAN_NOTICE("[H] starts installing \the [tray] into \the [src]."), SPAN_NOTICE("You start installing \the [tray] into \the [src]."))
	if(!do_after(H, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_NOTICE("[H] stops installing \the [tray] into \the [src]."), SPAN_WARNING("You stop installing \the [tray] into \the [src]."))
		return

	var/turf/T = get_turf(src)
	for(var/obj/item/O in tray.contents)
		tray.remove_from_storage(O, T)
		container.handle_item_insertion(O, TRUE)
	H.drop_held_item(tray)
	qdel(tray)
	has_tray = TRUE
	update_icon()
	H.visible_message(SPAN_NOTICE("[H] installs \the [tray] into \the [src]."), SPAN_NOTICE("You install \the [tray] into \the [src]."))

