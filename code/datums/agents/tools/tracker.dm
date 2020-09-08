/obj/item/device/tracker
	name = "OoI tracker"
	desc = "A tracker that tracks Objects of Interest, it is not widely avaliable."
	icon_state = "tracker"
	item_state = "tracker"
	var/active = FALSE
	var/ping_speed = 20
	var/ping_duration = 20
	var/obj/item/tracked_object

/obj/item/device/tracker/update_icon()
	overlays.Cut()

	if(active && tracked_object)
		overlays += icon(icon, "+tracker_arrow", get_dir(src, tracked_object))

/obj/item/device/tracker/attack_self(var/mob/user)
	if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
		return ..()
	
	if(isnull(tracked_object))
		select_object(user)
		return

	to_chat(user, SPAN_NOTICE("You start tracking the [tracked_object.name]."))
	if(!do_after(user, ping_speed, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	active = TRUE
	update_icon()

	add_timer(CALLBACK(src, .proc/deactive), ping_duration)

/obj/item/device/tracker/proc/deactive()
	active = FALSE
	update_icon()

/obj/item/device/tracker/clicked(mob/user, list/mods)
	if(!ishuman(user) || !skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
		return ..()

	if(mods["alt"])
		select_object(user)
		return TRUE

	return ..()

/obj/item/device/tracker/proc/select_object(var/mob/user)
	if(!LAZYLEN(objects_of_interest))
		to_chat(user, SPAN_WARNING("There are nothing of interest to track."))
		return

	var/list/object_choices = list()
	for(var/obj/O in objects_of_interest)
		var/z_level_to_compare_from = O.z
		if(istype(O.loc, /obj/structure/surface))
			z_level_to_compare_from = O.loc.z

		if(z_level_to_compare_from == user.z)
			object_choices += O
	
	if(!length(object_choices))
		to_chat(user, SPAN_WARNING("There are nothing of interest to track."))
		return

	tracked_object = input("What Object of Interest do you want to track?", "Object type", null) in object_choices

	to_chat(user, SPAN_WARNING("New interest to track selected as [tracked_object.name]."))

/obj/item/device/tracker/Dispose()
	if(tracked_object)
		tracked_object = null
	. = ..()