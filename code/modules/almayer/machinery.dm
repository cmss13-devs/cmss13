//-----USS Almayer Machinery file -----//
// Put any new machines in here before map is released and everything moved to their proper positions.



//-----USS Almayer Props -----//
//Put any props that don't function properly, they could function in the future but for now are for looks. This system could be expanded for other maps too. ~Art

/obj/item/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P03' IF SEEN IN ROUND WITH LOCATION"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "hangarbox"

/obj/item/prop/almayer/box
	name = "metal crate"
	desc = "A metal crate used often for storing small electronics that go into dropships"
	icon_state = "hangarbox"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flight_recorder
	name = "\improper FR-112 flight recorder"
	desc = "A small red box that contains flight data from a dropship while its on mission. Usually refered to the black box, although this one comes in bloody red."
	icon_state = "flight_recorder"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/lantern_pod
	name = "\improper LANTERN pod"
	desc = "A long green box mounted into a dropship to provide various optical support for its ground targeting systems."
	icon_state = "lantern_pod"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flare_launcher
	name = "\improper MJU-77/C case"
	desc = "A flare launcher that usually gets mounted onto dropships to help survivability against infrared tracking missiles."
	icon_state = "flare_launcher"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/chaff_launcher
	name = "\improper RR-247 Chaff case"
	desc = "A chaff launcher that usually gets mounted onto dropships to help survivability against radar tracking missiles."
	icon_state = "chaff_launcher"
	w_class = SIZE_MEDIUM

/obj/item/prop/almayer/handheld1
	name = "small handheld"
	desc = "A small piece of electronic doodads"
	icon_state = "handheld1"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/comp_closed
	name = "dropship maintenance computer"
	desc = "A closed dropship maintenance computer that technicans and pilots use to find out whats wrong with a dropship. It has various outlets for different systems."
	icon_state = "hangar_comp"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/comp_open
	name = "dropship maintenance computer"
	desc = "A opened dropship maintenance computer, it seems to be off however. Its used by technicans and pilots to find damaged or broken systems on a dropship. It has various outlets for different systems."
	icon_state = "hangar_comp_open"
	w_class = SIZE_LARGE

/obj/structure/machinery/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P01' IF SEEN IN ROUND WITH LOCATION"

/obj/structure/machinery/prop/almayer/hangar/dropship_part_fabricator
/obj/structure/machinery/prop/almayer/computer/PC
	name = "personal desktop"
	desc = "A small computer hooked up into the ship's computer network."
	icon_state = "terminal1"

/obj/structure/machinery/prop/almayer/computer
	name = "systems computer"
	desc = "A small computer hooked up into the ship's systems."

	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 20

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "terminal"

/obj/structure/machinery/prop/almayer/computer/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
			return

/obj/structure/machinery/prop/almayer/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/computer/power_change()
	..()
	update_icon()

/obj/structure/machinery/prop/almayer/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/NavCon
	name = "NavCon"
	desc = "Navigational console for ploting course and heading of the ship. Since the AI calculates all long range navigation, this is only used for in system curse corrections and orbital maneuvers. Don't touch it!"

	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 200

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "retro"

/obj/structure/machinery/prop/almayer/NavCon/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
			return

/obj/structure/machinery/prop/almayer/NavCon/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/NavCon/power_change()
	..()
	update_icon()

/obj/structure/machinery/prop/almayer/NavCon/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/NavCon2
	name = "NavCon 2"
	desc = "Navigational console for ploting course and heading of the ship. Since the AI calculates all long range navigation, this is only used for in system curse corrections and orbital maneuvers. Don't touch it!"

	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 200

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "retro2"

/obj/structure/machinery/prop/almayer/NavCon2/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
			return

/obj/structure/machinery/prop/almayer/NavCon2/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/NavCon2/power_change()
	..()
	update_icon()

/obj/structure/machinery/prop/almayer/NavCon2/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/CICmap
	name = "map table"
	desc = "A table that displays a map of the current target location"
	unacidable = TRUE
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	var/list/current_viewers = list()

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"

/obj/structure/machinery/prop/almayer/CICmap/Destroy()
	for(var/mob/living/L in current_viewers)
		to_chat(L, SPAN_NOTICE("You stop looking at the map."))
		close_browser(L,"marineminimap")
		current_viewers -= L
		continue
	return ..()

/obj/structure/machinery/prop/almayer/CICmap/examine(mob/living/user)
	if(ishuman(user) && get_dist(src,user) < 3 && powered())
		if(user in current_viewers)
			to_chat(user, SPAN_NOTICE("You stop looking at the map."))
			close_browser(user, "marineminimap")
			current_viewers -= user
			return
		current_viewers += user
		if(!istype(marine_mapview_overlay_5))
			overlay_marine_mapview()
		to_chat(user, SPAN_NOTICE("You start looking at the map."))
		user << browse_rsc(marine_mapview_overlay_5, "marine_minimap.png")
		show_browser(user, "<img src=marine_minimap.png>", "Tactical Map Table", "marineminimap", "size=[(map_sizes[1][1]*2)+50]x[(map_sizes[1][2]*2)+50]")
		onclose(user, "marineminimap", src, list("close" = 1, "viewer" = "\ref[user]"))
		return
	..()

/obj/structure/machinery/prop/almayer/CICmap/proc/update_mapview()
	if(!istype(marine_mapview_overlay_5))
		overlay_marine_mapview()
	for(var/mob/living/L in current_viewers)
		if(!powered() || get_dist(src,L) > 2)
			to_chat(L, SPAN_NOTICE("You stop looking at the map."))
			close_browser(L, "marineminimap")
			current_viewers -= L
			continue

		L << browse_rsc(marine_mapview_overlay_5, "marine_minimap.png")
		show_browser(L, "<img src=marine_minimap.png>", "Tactical Map Table", "marineminimap", "size=[(map_sizes[1][1]*2)+50]x[(map_sizes[1][2]*2)+50]")
		onclose(L, "marineminimap", src, list("close" = 1, "viewer" = "\ref[L]"))


/obj/structure/machinery/prop/almayer/CICmap/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if (href_list["close"])
		var/mob/living/L = locate(href_list["viewer"])
		if (!L)
			return
		to_chat(L, SPAN_NOTICE("You stop looking at the map."))
		close_browser(L, "marineminimap")
		current_viewers -= L

//Nonpower using props

/obj/structure/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P02' IF SEEN IN ROUND WITH LOCATION"
	density = 1
	anchored = 1

/obj/structure/prop/almayer/minigun_crate
	name = "30mm ammo crate"
	desc = "A crate full of 30mm bullets used on one of the weapon pod types for the dropship. Moving this will require some sort of lifter."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "30mm_crate"


/obj/structure/prop/almayer/computers
	var/hacked = FALSE

/obj/structure/prop/almayer/computers/update_icon()
	. = ..()

	overlays.Cut()

	if(hacked)
		overlays += "+hacked"

/obj/structure/prop/almayer/computers/mission_planning_system
	name = "\improper MPS IV computer"
	desc = "The Mission Planning System IV (MPS IV), a enhancement in mission planning and charting for dropship pilots across the USCM. Fully capable of customizing their flight paths and loadouts to suit their combat needs."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mps"

/obj/structure/prop/almayer/computers/mapping_computer
	name = "\improper CMPS II computer"
	desc = "The Common Mapping Production System version II allows for sensory imput from satellites and ship systems to derive planetary maps in a standardized fashion for all USCM pilots."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/almayer/computers/sensor_computer1
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/almayer/computers/sensor_computer2
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/almayer/computers/sensor_computer3
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp3"

/obj/structure/prop/almayer/missile_tube
	name = "\improper Mk 33 ASAT launcher system"
	desc = "Cold launch tubes that can fire a few varieties of missiles out of them The most common being the ASAT-21 Rapier IV missile used against satellites and other spacecraft and the BGM-227 Sledgehammer missile which is used for ground attack."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "missiletubenorth"
	bound_width = 32
	bound_height = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/ship_memorial
	name = "slab of victory"
	desc = "A ship memorial dedicated to the triumphs of the USCM and the fallen marines of this ship. On the left there are grand tales of victory etched into the slab. On the right there is a list of famous marines who have fallen in combat serving the USCM."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "ship_memorial"
	bound_width = 64
	bound_height = 32
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/ship_memorial/centcomm
	name = "slab of remembrance"
	desc = "A memorial to all Development Team members that have retired from working on CM. No mentor names are present."


/obj/structure/prop/almayer/ship_memorial/centcomm/admin
	desc = "A memorial to all Admins and Moderators who have retired from CM. No mentor names are present."


/obj/structure/prop/almayer/ship_memorial/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		if(D.fallen_names)
			to_chat(user, SPAN_NOTICE("You add [D] to [src]."))
			fallen_list += D.fallen_names
			qdel(D)
		return TRUE
	else
		. = ..()

/obj/structure/prop/almayer/ship_memorial/examine(mob/user)
	..()
	if((isobserver(user) || ishuman(user)) && fallen_list)
		var/faltext = ""
		for(var/i = 1 to fallen_list.len)
			if(i != fallen_list.len)
				faltext += "[fallen_list[i]], "
			else
				faltext += fallen_list[i]
		to_chat(user, SPAN_NOTICE("To our fallen soldiers: <b>[faltext]</b>."))

/obj/structure/prop/almayer/particle_cannon
	name = "\improper 75cm/140 Mark 74 General Atomics railgun"
	desc = "The Mark 74 Railgun is top of the line for space based weaponry. Capable of firing a round with a diameter of 3/4ths of a meter at 24 kilometers per second. It also is capable of using a variety of round types which can be interchanged at anytime with its newly designed feed system."
	icon = 'icons/obj/structures/machinery/artillery.dmi'
	icon_state = "1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/name_stencil
	name = "USS Almayer"
	desc = "The name of the ship stenciled on the hull."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "almayer0"
	density = 0 //dunno who would walk on it, but you know.
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/hangar_stencil
	name = "floor"
	desc = "A large number stenciled on the hangar floor used to designate which dropship it is."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "dropship1"
	density = 0
	layer = ABOVE_TURF_LAYER


/obj/structure/prop/almayer/cannon_cables
	name = "\improper Cannon cables"
	desc = "Some large cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cables"
	density = 0
	mouse_opacity = 0
	layer = LADDER_LAYER
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cables/ex_act()
	return

/obj/structure/prop/almayer/cannon_cables/bullet_act()
	return


/obj/structure/prop/almayer/cannon_cable_connector
	name = "\improper Cannon cable connector"
	desc = "A connector for the large cannon cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cable_connector"
	density = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cable_connector/ex_act()
	return

/obj/structure/prop/almayer/cannon_cable_connector/bullet_act()
	return








//------- Cryobag Recycler -------//
// Wanted to put this in, but since we still have extra time until tomorrow and this is really simple thing. It just recycles opened cryobags to make it nice-r for medics.
// Also the lack of sleep makes me keep typing cyro instead of cryo. FFS ~Art

/obj/structure/machinery/cryobag_recycler
	name = "cryogenic bag recycler"
	desc = "A small tomb like structure. Capable of taking in used and opened cryobags and refill the liner and attach new sealants."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "recycler"

	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20

//What is this even doing? Why is it making a new item?
/obj/structure/machinery/cryobag_recycler/attackby(obj/item/W, mob/user) //Hope this works. Don't see why not.
	..()
	if (istype(W, /obj/item))
		if(W.name == "used stasis bag") //possiblity for abuse, but fairly low considering its near impossible to rename something without VV
			var/obj/item/bodybag/cryobag/R = new /obj/item/bodybag/cryobag //lets give them the bag considering having it unfolded would be a pain in the ass.
			R.add_fingerprint(user)
			user.temp_drop_inv_item(W)
			qdel(W)
			user.put_in_hands(R)
			return TRUE
	..()

/obj/structure/closet/basketball
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/basketball/Initialize()
	. = ..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
