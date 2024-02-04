/* Holograms!
 * Contains:
 * Hologram
 * Holopad
 * Other stuff
 */



/*
 * Hologram
 */

/obj/structure/machinery/hologram
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	var/obj/effect/overlay/hologram //The projection itself. If there is one, the instrument is on, off otherwise.

/obj/structure/machinery/hologram/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(5))
				qdel(src)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)

/obj/structure/machinery/hologram/Destroy()
	if(hologram)
		clear_holo()
	return ..()

/obj/structure/machinery/hologram/proc/clear_holo()
	if(hologram)
		qdel(hologram)
		hologram = null



/*
 * Holopad
 */

/obj/structure/machinery/hologram/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images. It is activated remotely."
	icon_state = "holopad0"

	layer = TURF_LAYER+0.1 //Preventing mice and drones from sneaking under them.
/*
 * Other Stuff: Is this even used?
 */
/obj/structure/machinery/hologram/projector
	name = "hologram projector"
	desc = "It makes a hologram appear...with magnets or something..."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "holopad0"
