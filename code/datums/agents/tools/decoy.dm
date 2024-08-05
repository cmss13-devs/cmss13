/obj/item/explosive/grenade/decoy
	AUTOWIKI_SKIP(TRUE)

	name = "decoy grenade"
	desc = "A grenade typically used to distract the enemy. Emits a loud bang. Detonates in 5 seconds. Has 3 uses"

	icon_state = "training_grenade"
	item_state = "grenade_training"

	det_time = 5 SECONDS
	harmful = FALSE

	var/decoy_strength = 500
	var/uses = 3

/obj/item/explosive/grenade/decoy/prime(force)
	playsound(get_turf(loc), 'sound/effects/explosionfar.ogg', 100, 1, decoy_strength)
	playsound(get_turf(loc), "explosion", 90, 1, max(decoy_strength, 7))

	uses--

	if(!uses)
		qdel(src)
	else
		active = 0 //so we can reuse it
		overlays.Cut()
		icon_state = initial(icon_state)
		det_time = initial(det_time) //these can be modified when fired by UGL
		throw_range = initial(throw_range)
		w_class = initial(w_class)
