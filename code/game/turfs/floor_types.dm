



//Floors

/turf/open/floor/plating
	name = "plating"
	icon_state = "plating"
	intact_tile = FALSE
	tool_flags = NO_FLAGS

/turf/open/floor/plating/is_plating()
	return TRUE

/turf/open/floor/plating/is_plasteel_floor()
	return FALSE

/turf/open/floor/plating/is_light_floor()
	return FALSE

/turf/open/floor/plating/is_grass_floor()
	return FALSE

/turf/open/floor/plating/is_wood_floor()
	return FALSE

/turf/open/floor/plating/is_carpet_floor()
	return FALSE


/turf/open/floor/plating/attackby(obj/item/C, mob/user)
	if(istypestrict(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.get_amount() < 2)
			to_chat(user, SPAN_WARNING("You need more rods."))
			return
		to_chat(user, SPAN_NOTICE("You start reinforcing the floor."))
		var/current_type = type
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && current_type == type)
			if(!R)
				return
			if(R.use(2))
				ChangeTurf(/turf/open/floor/engine)
				playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		return
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	if(iswelder(C))
		if(!HAS_TRAIT(C, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/welder = C
		if(welder.isOn() && (turf_flags & TURF_BROKEN || turf_flags & TURF_BURNT))
			if(welder.remove_fuel(0, user))
				to_chat(user, SPAN_WARNING("You fix some dents on the broken plating."))
				playsound(src, 'sound/items/Welder.ogg', 25, 1)
				icon_state = "plating"
				turf_flags &= ~TURF_BURNT
				turf_flags &= ~TURF_BROKEN
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return
	if(istype(C, /obj/item/stack/tile))
		if(turf_flags & TURF_BROKEN || turf_flags & TURF_BURNT)
			to_chat(user, SPAN_NOTICE("This section is too damaged to support a tile. Use a welder to fix the damage."))
			return
		var/obj/item/stack/tile/T = C
		if(T.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		T.use(1)
		T.build(src)
		return
	if(istype(C, /obj/item/stack/catwalk))
		if(turf_flags & TURF_BROKEN || turf_flags & TURF_BURNT)
			to_chat(user, SPAN_NOTICE("This section is too damaged to support a catwalk. Use a welder to fix the damage."))
			return
		var/obj/item/stack/catwalk/T = C
		if(T.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		T.use(1)
		T.build(src)
		return
	return ..()

/turf/open/floor/plating/make_plating()
	return

/turf/open/floor/plating/burnt_platingdmg3
	icon_state = "platingdmg3"
	turf_flags = parent_type::turf_flags|TURF_BURNT

/turf/open/floor/plating/burnt_platingdmg3/west
	dir = WEST

/turf/open/floor/plating/asteroidwarning
	icon_state = "asteroidwarning"

/turf/open/floor/plating/asteroidwarning/southwest
	dir = SOUTHWEST

/turf/open/floor/plating/warnplate
	icon_state = "warnplate"

/turf/open/floor/plating/warnplate/southwest
	dir = SOUTHWEST

/turf/open/floor/plating/asteroidfloor
	icon_state = "asteroidfloor"

/turf/open/floor/plating/asteroidfloor/north
	dir = NORTH

/turf/open/floor/plating/asteroidwarning/north
	dir = NORTH

/turf/open/floor/plating/warnplate/north
	dir = NORTH

/turf/open/floor/plating/warnplatecorner
	icon_state = "warnplatecorner"

/turf/open/floor/plating/warnplatecorner/north
	dir = NORTH

/turf/open/floor/plating/asteroidwarning/east
	dir = EAST

/turf/open/floor/plating/warnplate/east
	dir = EAST

/turf/open/floor/plating/asteroidwarning/northeast
	dir = NORTHEAST

/turf/open/floor/plating/warnplate/northeast
	dir = NORTHEAST

/turf/open/floor/plating/asteroidwarning/southeast
	dir = SOUTHEAST

/turf/open/floor/plating/warnplate/southeast
	dir = SOUTHEAST

/turf/open/floor/plating/asteroidwarning/west
	dir = WEST

/turf/open/floor/plating/asteroidwarning/south
	dir = SOUTH

/turf/open/floor/plating/platingdmg2
	icon_state = "platingdmg2"

/turf/open/floor/plating/platingdmg2/west
	dir = WEST

/turf/open/floor/plating/platingdmg3
	icon_state = "platingdmg3"

/turf/open/floor/plating/platingdmg3/west
	dir = WEST

/turf/open/floor/plating/warnplate/west
	dir = WEST

/turf/open/floor/plating/asteroidwarning/northwest
	dir = NORTHWEST

/turf/open/floor/plating/warnplate/northwest
	dir = NORTHWEST

/turf/open/floor/plating/panelscorched
	icon_state = "panelscorched"

/turf/open/floor/plating/platebot
	icon_state = "platebot"

/turf/open/floor/plating/platebotc
	icon_state = "platebotc"

/turf/open/floor/plating/platingdmg1
	icon_state = "platingdmg1"

/turf/open/floor/plating/wood
	icon_state = "wood"

/turf/open/floor/plating/wood_broken2
	icon_state = "wood-broken2"

/turf/open/floor/plating/wood_broken3
	icon_state = "wood-broken3"

/turf/open/floor/plating/wood_broken4
	icon_state = "wood-broken4"

/turf/open/floor/plating/wood_broken5
	icon_state = "wood-broken5"

/turf/open/floor/plating/wood_broken6
	icon_state = "wood-broken6"

/turf/open/floor/plating/prison
	icon = 'icons/turf/floors/prison.dmi'

/turf/open/floor/plating/almayer
	icon = 'icons/turf/almayer.dmi'

/turf/open/floor/plating/almayer/no_build
	allow_construction = FALSE
	is_weedable = NOT_WEEDABLE

/turf/open/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"

/turf/open/floor/plating/airless/Initialize(mapload, ...)
	. = ..()
	name = "plating"

/turf/open/floor/plating/icefloor
	icon_state = "plating"
	name = "ice colony plating"

/turf/open/floor/plating/icefloor/Initialize(mapload, ...)
	. = ..()
	name = "plating"

/turf/open/floor/plating/icefloor/warnplate
	icon_state = "warnplate"

/turf/open/floor/plating/icefloor/warnplate/southwest
	dir = SOUTHWEST

/turf/open/floor/plating/icefloor/warnplate/north
	dir = NORTH

/turf/open/floor/plating/icefloor/warnplate/east
	dir = EAST

/turf/open/floor/plating/icefloor/warnplate/northeast
	dir = NORTHEAST

/turf/open/floor/plating/icefloor/warnplate/southeast
	dir = SOUTHEAST

/turf/open/floor/plating/icefloor/warnplate/west
	dir = WEST

/turf/open/floor/plating/icefloor/warnplate/northwest
	dir = NORTHWEST

/turf/open/floor/plating/icefloor/asteroidplating
	icon_state = "asteroidplating"

/// Visually like plating+catwalks but without overlaying or interactions - mainly for Reqs Elevator
/turf/open/floor/plating/bare_catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"

/turf/open/floor/plating/plating_catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"
	var/base_state = "plating" //Post mapping
	var/covered = TRUE
	var/covered_icon_state = "catwalk"

/turf/open/floor/plating/plating_catwalk/Initialize(mapload, ...)
	. = ..()

	icon_state = base_state
	update_icon()

/turf/open/floor/plating/plating_catwalk/update_icon()
	. = ..()
	if(covered)
		overlays += image(icon, src, covered_icon_state, CATWALK_LAYER)

/turf/open/floor/plating/plating_catwalk/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		if(covered)
			var/obj/item/stack/catwalk/R = new(src, 1, type)
			R.add_to_stacks(usr)
			covered = FALSE
			to_chat(user, SPAN_WARNING("You remove the top of the catwalk."))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			update_icon()
			return
	if(istype(W, /obj/item/stack/catwalk))
		if(!covered)
			var/obj/item/stack/catwalk/E = W
			E.use(1)
			covered = TRUE
			to_chat(user, SPAN_WARNING("You replace the top of the catwalk."))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			update_icon()
			return
	return ..()

/turf/open/floor/plating/plating_catwalk/break_tile()
	if(covered)
		covered = 0
		update_icon()
	..()

/turf/open/floor/plating/plating_catwalk/break_tile_to_plating()
	if(covered)
		covered = 0
		update_icon()
	..()

/turf/open/floor/plating/plating_catwalk/prison
	icon = 'icons/turf/floors/prison.dmi'

/turf/open/floor/plating/plating_catwalk/strata
	icon = 'icons/turf/floors/strata_floor.dmi'

/turf/open/floor/plating/plating_catwalk/shiva
	icon = 'icons/turf/floors/ice_colony/shiva_floor.dmi'

/turf/open/floor/plating/plating_catwalk/aicore
	icon = 'icons/turf/floors/aicore.dmi'
	icon_state = "ai_plating_catwalk"
	turf_flags = NO_FLAGS // platingdmg && panelscorched icon_state does not exist in this icon
	covered_icon_state = "ai_catwalk"

/turf/open/floor/plating/plating_catwalk/aicore/white
	icon_state = "w_ai_plating_catwalk"
	covered_icon_state = "w_ai_catwalk"

/turf/open/floor/plating/ironsand
	name = "Iron Sand"

/turf/open/floor/plating/ironsand/Initialize(mapload, ...)
	. = ..()
	icon_state = "ironsand[rand(1,15)]"



/turf/open/floor/plating/catwalk
	icon = 'icons/turf/floors/catwalks.dmi'
	icon_state = "catwalk0"
	name = "catwalk"
	desc = "Cats really don't like these things."
	turf_flags = NO_FLAGS // platingdmg && panelscorched icon_state does not exist in this icon

/turf/open/floor/plating/catwalk/Initialize(mapload, ...)
	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)

	. = ..()

/turf/open/floor/almayer
	icon = 'icons/turf/almayer.dmi'
	icon_state = "default"
	plating_type = /turf/open/floor/plating/almayer

/turf/open/floor/almayer/pod_landing_floor
	desc = "There's a hatch above it, presumably to allow pods to drop in."
	icon_state = "test_floor4"
	name = "pod landing floor"

// All BLUE tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/blue
	icon_state = "blue"

/turf/open/floor/almayer/blue/north
	dir = NORTH

/turf/open/floor/almayer/blue/south
	dir = SOUTH

/turf/open/floor/almayer/blue/east
	dir = EAST

/turf/open/floor/almayer/blue/west
	dir = WEST

/turf/open/floor/almayer/blue/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/blue/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/blue/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/blue/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/blue2
	icon_state = "blue2"

/turf/open/floor/almayer/blue2/north
	dir = NORTH

/turf/open/floor/almayer/blue2/south
	dir = SOUTH

/turf/open/floor/almayer/blue2/east
	dir = EAST

/turf/open/floor/almayer/blue2/west
	dir = WEST

/turf/open/floor/almayer/blue2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/blue2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/blue2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/blue2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/blue2smooth
	icon_state = "blue2_smooth"

/turf/open/floor/almayer/blue2smooth/north
	dir = NORTH

/turf/open/floor/almayer/blue2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/blue2smooth/east
	dir = EAST

/turf/open/floor/almayer/blue2smooth/west
	dir = WEST

/turf/open/floor/almayer/blue2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/blue2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/blue2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/blue2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/blue2smooth2
	icon_state = "blue2_smooth2"

/turf/open/floor/almayer/blue2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/blue2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/blue2smooth2/east
	dir = EAST

/turf/open/floor/almayer/blue2smooth2/west
	dir = WEST

/turf/open/floor/almayer/blue2smooth3
	icon_state = "blue2_smooth3"

/turf/open/floor/almayer/blue2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/blue2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/blue2smooth3/east
	dir = EAST

/turf/open/floor/almayer/blue2smooth3/west
	dir = WEST

/turf/open/floor/almayer/bluecorner
	icon_state = "bluecorner"

/turf/open/floor/almayer/bluecorner/north
	dir = NORTH

/turf/open/floor/almayer/bluecorner/south
	dir = SOUTH

/turf/open/floor/almayer/bluecorner/east
	dir = EAST

/turf/open/floor/almayer/bluecorner/west
	dir = WEST

/turf/open/floor/almayer/bluecornersmooth
	icon_state = "bluecorner_smooth"

/turf/open/floor/almayer/bluecornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/bluecornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/bluecornersmooth/east
	dir = EAST

/turf/open/floor/almayer/bluecornersmooth/west
	dir = WEST

/turf/open/floor/almayer/bluefull
	icon_state = "bluefull"

/turf/open/floor/almayer/bluefull2
	icon_state = "bluefull2"


// All RED tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/red
	icon_state = "red"

/turf/open/floor/almayer/red/north
	dir = NORTH

/turf/open/floor/almayer/red/south
	dir = SOUTH

/turf/open/floor/almayer/red/east
	dir = EAST

/turf/open/floor/almayer/red/west
	dir = WEST

/turf/open/floor/almayer/red/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/red/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/red/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/red/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/red2
	icon_state = "red2"

/turf/open/floor/almayer/red2/north
	dir = NORTH

/turf/open/floor/almayer/red2/south
	dir = SOUTH

/turf/open/floor/almayer/red2/east
	dir = EAST

/turf/open/floor/almayer/red2/west
	dir = WEST

/turf/open/floor/almayer/red2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/red2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/red2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/red2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/red2smooth
	icon_state = "red2_smooth"

/turf/open/floor/almayer/red2smooth/north
	dir = NORTH

/turf/open/floor/almayer/red2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/red2smooth/east
	dir = EAST

/turf/open/floor/almayer/red2smooth/west
	dir = WEST

/turf/open/floor/almayer/red2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/red2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/red2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/red2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/red2smooth2
	icon_state = "red2_smooth2"

/turf/open/floor/almayer/red2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/red2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/red2smooth2/east
	dir = EAST

/turf/open/floor/almayer/red2smooth2/west
	dir = WEST

/turf/open/floor/almayer/red2smooth3
	icon_state = "red2_smooth3"

/turf/open/floor/almayer/red2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/red2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/red2smooth3/east
	dir = EAST

/turf/open/floor/almayer/red2smooth3/west
	dir = WEST

/turf/open/floor/almayer/redcorner
	icon_state = "redcorner"

/turf/open/floor/almayer/redcorner/north
	dir = NORTH

/turf/open/floor/almayer/redcorner/south
	dir = SOUTH

/turf/open/floor/almayer/redcorner/east
	dir = EAST

/turf/open/floor/almayer/redcorner/west
	dir = WEST

/turf/open/floor/almayer/redcornersmooth
	icon_state = "redcorner_smooth"

/turf/open/floor/almayer/redcornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/redcornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/redcornersmooth/east
	dir = EAST

/turf/open/floor/almayer/redcornersmooth/west
	dir = WEST

/turf/open/floor/almayer/redfull
	icon_state = "redfull"

/turf/open/floor/almayer/redfull2
	icon_state = "redfull2"


// All EMERALD (not purple you fool, emerald) tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/emerald
	icon_state = "emerald"

/turf/open/floor/almayer/emerald/north
	dir = NORTH

/turf/open/floor/almayer/emerald/south
	dir = SOUTH

/turf/open/floor/almayer/emerald/east
	dir = EAST

/turf/open/floor/almayer/emerald/west
	dir = WEST

/turf/open/floor/almayer/emerald/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/emerald/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/emerald/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/emerald/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/emerald2
	icon_state = "emerald2"

/turf/open/floor/almayer/emerald2/north
	dir = NORTH

/turf/open/floor/almayer/emerald2/south
	dir = SOUTH

/turf/open/floor/almayer/emerald2/east
	dir = EAST

/turf/open/floor/almayer/emerald2/west
	dir = WEST

/turf/open/floor/almayer/emerald2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/emerald2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/emerald2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/emerald2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/emerald2smooth
	icon_state = "emerald2_smooth"

/turf/open/floor/almayer/emerald2smooth/north
	dir = NORTH

/turf/open/floor/almayer/emerald2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/emerald2smooth/east
	dir = EAST

/turf/open/floor/almayer/emerald2smooth/west
	dir = WEST

/turf/open/floor/almayer/emerald2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/emerald2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/emerald2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/emerald2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/emerald2smooth2
	icon_state = "emerald2_smooth2"

/turf/open/floor/almayer/emerald2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/emerald2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/emerald2smooth2/east
	dir = EAST

/turf/open/floor/almayer/emerald2smooth2/west
	dir = WEST

/turf/open/floor/almayer/emerald2smooth3
	icon_state = "emerald2_smooth3"

/turf/open/floor/almayer/emerald2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/emerald2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/emerald2smooth3/east
	dir = EAST

/turf/open/floor/almayer/emerald2smooth3/west
	dir = WEST

/turf/open/floor/almayer/emeraldcorner
	icon_state = "emeraldcorner"

/turf/open/floor/almayer/emeraldcorner/north
	dir = NORTH

/turf/open/floor/almayer/emeraldcorner/south
	dir = SOUTH

/turf/open/floor/almayer/emeraldcorner/east
	dir = EAST

/turf/open/floor/almayer/emeraldcorner/west
	dir = WEST

/turf/open/floor/almayer/emeraldcornersmooth
	icon_state = "emeraldcorner_smooth"

/turf/open/floor/almayer/emeraldcornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/emeraldcornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/emeraldcornersmooth/east
	dir = EAST

/turf/open/floor/almayer/emeraldcornersmooth/west
	dir = WEST

/turf/open/floor/almayer/emeraldfull
	icon_state = "emeraldfull"

/turf/open/floor/almayer/emeraldfull2
	icon_state = "emeraldfull2"


// All ORANGE (its called orange but its infact yellow, deal with it) tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/orange
	icon_state = "orange"

/turf/open/floor/almayer/orange/north
	dir = NORTH

/turf/open/floor/almayer/orange/south
	dir = SOUTH

/turf/open/floor/almayer/orange/east
	dir = EAST

/turf/open/floor/almayer/orange/west
	dir = WEST

/turf/open/floor/almayer/orange/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/orange/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/orange/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/orange/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/orange2
	icon_state = "orange2"

/turf/open/floor/almayer/orange2/north
	dir = NORTH

/turf/open/floor/almayer/orange2/south
	dir = SOUTH

/turf/open/floor/almayer/orange2/east
	dir = EAST

/turf/open/floor/almayer/orange2/west
	dir = WEST

/turf/open/floor/almayer/orange2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/orange2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/orange2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/orange2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/orange2smooth
	icon_state = "orange2_smooth"

/turf/open/floor/almayer/orange2smooth/north
	dir = NORTH

/turf/open/floor/almayer/orange2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/orange2smooth/east
	dir = EAST

/turf/open/floor/almayer/orange2smooth/west
	dir = WEST

/turf/open/floor/almayer/orange2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/orange2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/orange2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/orange2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/orange2smooth2
	icon_state = "orange2_smooth2"

/turf/open/floor/almayer/orange2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/orange2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/orange2smooth2/east
	dir = EAST

/turf/open/floor/almayer/orange2smooth2/west
	dir = WEST

/turf/open/floor/almayer/orange2smooth3
	icon_state = "orange2_smooth3"

/turf/open/floor/almayer/orange2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/orange2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/orange2smooth3/east
	dir = EAST

/turf/open/floor/almayer/orange2smooth3/west
	dir = WEST

/turf/open/floor/almayer/orangecorner
	icon_state = "orangecorner"

/turf/open/floor/almayer/orangecorner/north
	dir = NORTH

/turf/open/floor/almayer/orangecorner/south
	dir = SOUTH

/turf/open/floor/almayer/orangecorner/east
	dir = EAST

/turf/open/floor/almayer/orangecorner/west
	dir = WEST

/turf/open/floor/almayer/orangecornersmooth
	icon_state = "orangecorner_smooth"

/turf/open/floor/almayer/orangecornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/orangecornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/orangecornersmooth/east
	dir = EAST

/turf/open/floor/almayer/orangecornersmooth/west
	dir = WEST

/turf/open/floor/almayer/orangefull
	icon_state = "orangefull"

/turf/open/floor/almayer/orangefull2
	icon_state = "orangefull2"


// All GREEN tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/green
	icon_state = "green"

/turf/open/floor/almayer/green/north
	dir = NORTH

/turf/open/floor/almayer/green/south
	dir = SOUTH

/turf/open/floor/almayer/green/east
	dir = EAST

/turf/open/floor/almayer/green/west
	dir = WEST

/turf/open/floor/almayer/green/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/green/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/green/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/green/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/green2
	icon_state = "green2"

/turf/open/floor/almayer/green2/north
	dir = NORTH

/turf/open/floor/almayer/green2/south
	dir = SOUTH

/turf/open/floor/almayer/green2/east
	dir = EAST

/turf/open/floor/almayer/green2/west
	dir = WEST

/turf/open/floor/almayer/green2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/green2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/green2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/green2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/green2smooth
	icon_state = "green2_smooth"

/turf/open/floor/almayer/green2smooth/north
	dir = NORTH

/turf/open/floor/almayer/green2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/green2smooth/east
	dir = EAST

/turf/open/floor/almayer/green2smooth/west
	dir = WEST

/turf/open/floor/almayer/green2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/green2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/green2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/green2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/green2smooth2
	icon_state = "green2_smooth2"

/turf/open/floor/almayer/green2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/green2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/green2smooth2/east
	dir = EAST

/turf/open/floor/almayer/green2smooth2/west
	dir = WEST

/turf/open/floor/almayer/green2smooth3
	icon_state = "green2_smooth3"

/turf/open/floor/almayer/green2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/green2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/green2smooth3/east
	dir = EAST

/turf/open/floor/almayer/green2smooth3/west
	dir = WEST

/turf/open/floor/almayer/greencorner
	icon_state = "greencorner"

/turf/open/floor/almayer/greencorner/north
	dir = NORTH

/turf/open/floor/almayer/greencorner/south
	dir = SOUTH

/turf/open/floor/almayer/greencorner/east
	dir = EAST

/turf/open/floor/almayer/greencorner/west
	dir = WEST

/turf/open/floor/almayer/greencornersmooth
	icon_state = "greencorner_smooth"

/turf/open/floor/almayer/greencornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/greencornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/greencornersmooth/east
	dir = EAST

/turf/open/floor/almayer/greencornersmooth/west
	dir = WEST

/turf/open/floor/almayer/greenfull
	icon_state = "greenfull"

/turf/open/floor/almayer/greenfull2
	icon_state = "greenfull2"


// All SILVER tiles (normal, smooth edge, smooth borderless, smooth ends, corners, full, full smooth)

/turf/open/floor/almayer/silver
	icon_state = "silver"

/turf/open/floor/almayer/silver/north
	dir = NORTH

/turf/open/floor/almayer/silver/south
	dir = SOUTH

/turf/open/floor/almayer/silver/east
	dir = EAST

/turf/open/floor/almayer/silver/west
	dir = WEST

/turf/open/floor/almayer/silver/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/silver/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/silver/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/silver/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/silver2
	icon_state = "silver2"

/turf/open/floor/almayer/silver2/north
	dir = NORTH

/turf/open/floor/almayer/silver2/south
	dir = SOUTH

/turf/open/floor/almayer/silver2/east
	dir = EAST

/turf/open/floor/almayer/silver2/west
	dir = WEST

/turf/open/floor/almayer/silver2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/silver2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/silver2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/silver2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/silver2smooth
	icon_state = "silver2_smooth"

/turf/open/floor/almayer/silver2smooth/north
	dir = NORTH

/turf/open/floor/almayer/silver2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/silver2smooth/east
	dir = EAST

/turf/open/floor/almayer/silver2smooth/west
	dir = WEST

/turf/open/floor/almayer/silver2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/silver2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/silver2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/silver2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/silver2smooth2
	icon_state = "silver2_smooth2"

/turf/open/floor/almayer/silver2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/silver2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/silver2smooth2/east
	dir = EAST

/turf/open/floor/almayer/silver2smooth2/west
	dir = WEST

/turf/open/floor/almayer/silver2smooth3
	icon_state = "silver2_smooth3"

/turf/open/floor/almayer/silver2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/silver2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/silver2smooth3/east
	dir = EAST

/turf/open/floor/almayer/silver2smooth3/west
	dir = WEST

/turf/open/floor/almayer/silvercorner
	icon_state = "silvercorner"

/turf/open/floor/almayer/silvercorner/north
	dir = NORTH

/turf/open/floor/almayer/silvercorner/south
	dir = SOUTH

/turf/open/floor/almayer/silvercorner/east
	dir = EAST

/turf/open/floor/almayer/silvercorner/west
	dir = WEST

/turf/open/floor/almayer/silvercornersmooth
	icon_state = "silvercorner_smooth"

/turf/open/floor/almayer/silvercornersmooth/north
	dir = NORTH

/turf/open/floor/almayer/silvercornersmooth/south
	dir = SOUTH

/turf/open/floor/almayer/silvercornersmooth/east
	dir = EAST

/turf/open/floor/almayer/silvercornersmooth/west
	dir = WEST

/turf/open/floor/almayer/silverfull
	icon_state = "silverfull"

/turf/open/floor/almayer/silverfull2
	icon_state = "silverfull2"


// All WHITE tiles, unused no more (normal, smooth edge, corners, full, full smooth)

/turf/open/floor/almayer/white
	icon_state = "white"

/turf/open/floor/almayer/white/north
	dir = NORTH

/turf/open/floor/almayer/white/south
	dir = SOUTH

/turf/open/floor/almayer/white/east
	dir = EAST

/turf/open/floor/almayer/white/west
	dir = WEST

/turf/open/floor/almayer/white/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/white/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/white/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/white/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/white2
	icon_state = "white2"

/turf/open/floor/almayer/white2/north
	dir = NORTH

/turf/open/floor/almayer/white2/south
	dir = SOUTH

/turf/open/floor/almayer/white2/east
	dir = EAST

/turf/open/floor/almayer/white2/west
	dir = WEST

/turf/open/floor/almayer/white2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/white2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/white2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/white2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/whitecorner
	icon_state = "whitecorner"

/turf/open/floor/almayer/whitecorner/north
	dir = NORTH

/turf/open/floor/almayer/whitecorner/south
	dir = SOUTH

/turf/open/floor/almayer/whitecorner/east
	dir = EAST

/turf/open/floor/almayer/whitecorner/west
	dir = WEST

/turf/open/floor/almayer/whitefull
	icon_state = "whitefull"

/turf/open/floor/almayer/whitefull2
	icon_state = "whitefull2"


// All BLACK tiles, unused no more (normal, smooth edge, corners, full, full smooth)

/turf/open/floor/almayer/black
	icon_state = "black"

/turf/open/floor/almayer/black/north
	dir = NORTH

/turf/open/floor/almayer/black/south
	dir = SOUTH

/turf/open/floor/almayer/black/east
	dir = EAST

/turf/open/floor/almayer/black/west
	dir = WEST

/turf/open/floor/almayer/black/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/black/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/black/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/black/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/black2
	icon_state = "black2"

/turf/open/floor/almayer/black2/north
	dir = NORTH

/turf/open/floor/almayer/black2/south
	dir = SOUTH

/turf/open/floor/almayer/black2/east
	dir = EAST

/turf/open/floor/almayer/black2/west
	dir = WEST

/turf/open/floor/almayer/black2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/black2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/black2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/black2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/blackcorner
	icon_state = "blackcorner"

/turf/open/floor/almayer/blackcorner/north
	dir = NORTH

/turf/open/floor/almayer/blackcorner/south
	dir = SOUTH

/turf/open/floor/almayer/blackcorner/east
	dir = EAST

/turf/open/floor/almayer/blackcorner/west
	dir = WEST

/turf/open/floor/almayer/blackfull
	icon_state = "blackfull"

/turf/open/floor/almayer/blackfull/west
	dir = WEST

/turf/open/floor/almayer/blackfull2
	icon_state = "blackfull2"


// All PURPLE tiles, unused no more (normal, smooth edge, corners, full, full smooth)

/turf/open/floor/almayer/purple
	icon_state = "purple"

/turf/open/floor/almayer/purple/north
	dir = NORTH

/turf/open/floor/almayer/purple/south
	dir = SOUTH

/turf/open/floor/almayer/purple/east
	dir = EAST

/turf/open/floor/almayer/purple/west
	dir = WEST

/turf/open/floor/almayer/purple/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/purple/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/purple/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/purple/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/purple2
	icon_state = "purple2"

/turf/open/floor/almayer/purple2/north
	dir = NORTH

/turf/open/floor/almayer/purple2/south
	dir = SOUTH

/turf/open/floor/almayer/purple2/east
	dir = EAST

/turf/open/floor/almayer/purple2/west
	dir = WEST

/turf/open/floor/almayer/purple2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/purple2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/purple2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/purple2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/purple2smooth
	icon_state = "purple2_smooth"

/turf/open/floor/almayer/purple2smooth/north
	dir = NORTH

/turf/open/floor/almayer/purple2smooth/south
	dir = SOUTH

/turf/open/floor/almayer/purple2smooth/east
	dir = EAST

/turf/open/floor/almayer/purple2smooth/west
	dir = WEST

/turf/open/floor/almayer/purple2smooth/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/purple2smooth/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/purple2smooth/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/purple2smooth/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/purple2smooth2
	icon_state = "purple2_smooth2"

/turf/open/floor/almayer/purple2smooth2/north
	dir = NORTH

/turf/open/floor/almayer/purple2smooth2/south
	dir = SOUTH

/turf/open/floor/almayer/purple2smooth2/east
	dir = EAST

/turf/open/floor/almayer/purple2smooth2/west
	dir = WEST

/turf/open/floor/almayer/purple2smooth3
	icon_state = "purple2_smooth3"

/turf/open/floor/almayer/purple2smooth3/north
	dir = NORTH

/turf/open/floor/almayer/purple2smooth3/south
	dir = SOUTH

/turf/open/floor/almayer/purple2smooth3/east
	dir = EAST

/turf/open/floor/almayer/purple2smooth3/west
	dir = WEST

/turf/open/floor/almayer/purplecorner
	icon_state = "purplecorner"

/turf/open/floor/almayer/purplecorner/north
	dir = NORTH

/turf/open/floor/almayer/purplecorner/south
	dir = SOUTH

/turf/open/floor/almayer/purplecorner/east
	dir = EAST

/turf/open/floor/almayer/purplecorner/west
	dir = WEST

/turf/open/floor/almayer/purplefull
	icon_state = "purplefull"

/turf/open/floor/almayer/purplefull2
	icon_state = "purplefull2"

// Other stuff that ain't the tiles mentioned above

/turf/open/floor/almayer/cargo
	icon_state = "cargo"

/turf/open/floor/almayer/cargo/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/cargo_arrow
	icon_state = "cargo_arrow"

/turf/open/floor/almayer/cargo_arrow/north
	dir = NORTH

/turf/open/floor/almayer/cargo_arrow/east
	dir = EAST

/turf/open/floor/almayer/cargo_arrow/west
	dir = WEST

/turf/open/floor/almayer/plating
	icon_state = "plating"

/turf/open/floor/almayer/plating/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/plating2
	icon_state = "plating2"

/turf/open/floor/almayer/plating2/north
	dir = NORTH

/turf/open/floor/almayer/plating2/south
	dir = SOUTH

/turf/open/floor/almayer/plating2/east
	dir = EAST

/turf/open/floor/almayer/plating2/west
	dir = WEST

/turf/open/floor/almayer/plating2/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/plating2/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/plating2/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/plating2/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/plating_striped
	icon_state = "plating_striped"

/turf/open/floor/almayer/plating_striped/north
	dir = NORTH

/turf/open/floor/almayer/plating_striped/south
	dir = SOUTH

/turf/open/floor/almayer/plating_striped/east
	dir = EAST

/turf/open/floor/almayer/plating_striped/west
	dir = WEST

/turf/open/floor/almayer/plating_striped/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/plating_striped/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/plating_striped/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/plating_striped/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/plating_stripedcorner
	icon_state = "plating_striped_corner"

/turf/open/floor/almayer/plating_stripedcorner/north
	dir = NORTH

/turf/open/floor/almayer/plating_stripedcorner/south
	dir = SOUTH

/turf/open/floor/almayer/plating_stripedcorner/east
	dir = EAST

/turf/open/floor/almayer/plating_stripedcorner/west
	dir = WEST

/turf/open/floor/almayer/sterile_green_side
	icon_state = "sterile_green_side"

/turf/open/floor/almayer/sterile_green_side/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/sterile_green_side/east
	dir = EAST

/turf/open/floor/almayer/sterile_green_side/north
	dir = NORTH

/turf/open/floor/almayer/sterile_green_side/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/sterile_green_side/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/sterile_green_side/west
	dir = WEST

/turf/open/floor/almayer/sterile_green_side/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/sterile_green_corner
	icon_state = "sterile_green_corner"

/turf/open/floor/almayer/sterile_green_corner/north
	dir = NORTH

/turf/open/floor/almayer/sterile_green_corner/east
	dir = EAST

/turf/open/floor/almayer/sterile_green_corner/west
	dir = WEST

// All GREY tiles (full, smooth edge, smooth edge borderless, smooth edge corner, smooth edge ends)

/turf/open/floor/almayer/floor
	icon_state = "floor"

/turf/open/floor/almayer/flooredge
	icon_state = "floor_edge"

/turf/open/floor/almayer/flooredge/north
	dir = NORTH

/turf/open/floor/almayer/flooredge/south
	dir = SOUTH

/turf/open/floor/almayer/flooredge/east
	dir = EAST

/turf/open/floor/almayer/flooredge/west
	dir = WEST

/turf/open/floor/almayer/flooredge/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/flooredge/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/flooredge/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/flooredge/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/flooredgesmooth
	icon_state = "floor_edge_smooth"

/turf/open/floor/almayer/flooredgesmooth/north
	dir = NORTH

/turf/open/floor/almayer/flooredgesmooth/south
	dir = SOUTH

/turf/open/floor/almayer/flooredgesmooth/east
	dir = EAST

/turf/open/floor/almayer/flooredgesmooth/west
	dir = WEST

/turf/open/floor/almayer/flooredgesmooth/west
	dir = NORTHEAST

/turf/open/floor/almayer/flooredgesmooth/west
	dir = NORTHWEST

/turf/open/floor/almayer/flooredgesmooth/west
	dir = SOUTHEAST

/turf/open/floor/almayer/flooredgesmooth/west
	dir = SOUTHWEST

/turf/open/floor/almayer/flooredgesmooth2
	icon_state = "floor_edge_smooth2"

/turf/open/floor/almayer/flooredgesmooth2/north
	dir = NORTH

/turf/open/floor/almayer/flooredgesmooth2/south
	dir = SOUTH

/turf/open/floor/almayer/flooredgesmooth2/east
	dir = EAST

/turf/open/floor/almayer/flooredgesmooth2/west
	dir = WEST

/turf/open/floor/almayer/flooredgesmooth3
	icon_state = "floor_edge_smooth3"

/turf/open/floor/almayer/flooredgesmooth3/north
	dir = NORTH

/turf/open/floor/almayer/flooredgesmooth3/south
	dir = SOUTH

/turf/open/floor/almayer/flooredgesmooth3/east
	dir = EAST

/turf/open/floor/almayer/flooredgesmooth3/west
	dir = WEST

// ends here for now

/turf/open/floor/almayer/mono
	icon_state = "mono"

/turf/open/floor/almayer/plate
	icon_state = "plate"

/turf/open/floor/almayer/w_y0
	icon_state = "w-y0"

/turf/open/floor/almayer/w_y0/north
	dir = NORTH

/turf/open/floor/almayer/w_y1
	icon_state = "w-y1"

/turf/open/floor/almayer/w_y1/north
	dir = NORTH

/turf/open/floor/almayer/w_y2
	icon_state = "w-y2"

/turf/open/floor/almayer/w_y2/north
	dir = NORTH

/turf/open/floor/almayer/ai_floors
	icon_state = "ai_floors"

/turf/open/floor/almayer/dark_sterile
	icon_state = "dark_sterile"

/turf/open/floor/almayer/dark_sterile2
	icon_state = "dark_sterile2"

/turf/open/floor/almayer/sterile
	icon_state = "sterile"

/turf/open/floor/almayer/sterile_green
	icon_state = "sterile_green"

/turf/open/floor/almayer/sterile_green2
	icon_state = "sterile_green2"

/turf/open/floor/almayer/tcomms
	icon_state = "tcomms"

/turf/open/floor/almayer/test_floor4
	icon_state = "test_floor4"

/turf/open/floor/almayer/test_floor5
	icon_state = "test_floor5"

/turf/open/floor/almayer/test_floor6
	icon_state = "test_floor6"

/turf/open/floor/almayer/test_floor7
	icon_state = "test_floor7"


/// Admin level thunderdome floor. Doesn't get damaged by explosions and such for pristine testing
/turf/open/floor/tdome
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating"
	plating_type = /turf/open/floor/tdome
	turf_flags = TURF_HULL

/turf/open/floor/tdome/w_y0
	icon_state = "w-y0"

/turf/open/floor/tdome/w_y0/north
	dir = NORTH

/turf/open/floor/tdome/w_y1
	icon_state = "w-y1"

/turf/open/floor/tdome/w_y1/north
	dir = NORTH

/turf/open/floor/tdome/w_y2
	icon_state = "w-y2"

/turf/open/floor/tdome/w_y2/north
	dir = NORTH

/turf/open/floor/tdome/northeast
	dir = NORTHEAST

/turf/open/floor/tdome/bluefull
	icon_state = "bluefull"

/turf/open/floor/tdome/redfull
	icon_state = "redfull"

/turf/open/floor/tdome/tcomms
	icon_state = "tcomms"

/turf/open/floor/tdome/test_floor4
	icon_state = "test_floor4"

/// Base type of the requisitions and vehicle bay elevator pits.
/turf/open/floor/almayer/empty
	name = "\proper empty space"
	desc = "There seems to be an awful lot of machinery down below..."
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "black"
	is_weedable = NOT_WEEDABLE

/turf/open/floor/almayer/empty/ex_act(severity) //Should make it indestructible
	return

/turf/open/floor/almayer/empty/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/floor/almayer/empty/attackby() //This should fix everything else. No cables, etc
	return

/turf/open/floor/almayer/empty/Entered(atom/movable/AM)
	..()
	if(!isobserver(AM) && !istype(AM, /obj/effect/elevator) && !istype(AM, /obj/docking_port))
		addtimer(CALLBACK(src, PROC_REF(enter_depths), AM), 0.2 SECONDS)

/// Returns a list of turfs to be used as a destination for anyone unfortunate enough to fall into the pit.
/turf/open/floor/almayer/empty/proc/get_depths_turfs()
	// Empty proc to be overridden.
	return

/turf/open/floor/almayer/empty/proc/enter_depths(atom/movable/AM)
	if(AM.throwing == 0 && istype(get_turf(AM), /turf/open/floor/almayer/empty))
		AM.visible_message(SPAN_WARNING("[AM] falls into the depths!"), SPAN_WARNING("You fall into the depths!"))
		if(!ishuman(AM))
			qdel(AM)
			return
		var/mob/living/carbon/human/thrown_human = AM
		for(var/atom/computer as anything in GLOB.supply_controller.bound_supply_computer_list)
			computer.balloon_alert_to_viewers("you hear horrifying noises coming from the elevator!")

		var/list/depths_turfs = get_depths_turfs()
		if(!length(depths_turfs))
			// If this ever happens, something went wrong.
			CRASH("get_depths_turfs() didn't return anything!")

		thrown_human.forceMove(pick(depths_turfs))

		var/timer = 0.5 SECONDS
		for(var/index in 1 to 10)
			timer += 0.5 SECONDS
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(maul_human), thrown_human), timer)
		return

	else
		for(var/obj/effect/decal/cleanable/C in contents) //for the off chance of someone bleeding mid-flight
			qdel(C)

/// Requisitions pit.
/turf/open/floor/almayer/empty/requisitions

/turf/open/floor/almayer/empty/requisitions/Initialize(mapload, ...)
	. = ..()
	GLOB.asrs_empty_space_tiles_list += src

/turf/open/floor/almayer/empty/requisitions/Destroy(force)
	GLOB.asrs_empty_space_tiles_list -= src
	return ..()

/turf/open/floor/almayer/empty/requisitions/get_depths_turfs()
	var/area/elevator_area = GLOB.supply_controller.shuttle?.get_location_area()

	var/turf_list = list()
	for(var/turf/turf in elevator_area)
		turf_list |= turf
	return turf_list

/// Vehicle bay pit.
/turf/open/floor/almayer/empty/vehicle_bay

/turf/open/floor/almayer/empty/vehicle_bay/get_depths_turfs()
	return SSshuttle.vehicle_elevator.return_turfs()

//Others
/turf/open/floor/almayer/uscm
	icon_state = "logo_c"
	name = "\improper USCM Logo"

/turf/open/floor/almayer/uscm/directional
	icon_state = "logo_directional"

/turf/open/floor/almayer/uscm/directional/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer/uscm/directional/north
	dir = NORTH

/turf/open/floor/almayer/uscm/directional/east
	dir = EAST

/turf/open/floor/almayer/uscm/directional/northeast
	dir = NORTHEAST

/turf/open/floor/almayer/uscm/directional/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer/uscm/directional/logo_c
	icon_state = "logo_c"

/turf/open/floor/almayer/uscm/directional/logo_c/west
	dir = WEST

/turf/open/floor/almayer/uscm/directional/west
	dir = WEST

/turf/open/floor/almayer/uscm/directional/northwest
	dir = NORTHWEST

/turf/open/floor/almayer/no_build
	allow_construction = FALSE
	turf_flags = parent_type::turf_flags|TURF_HULL

/turf/open/floor/almayer/no_build/ai_floors
	icon_state = "ai_floors"

/turf/open/floor/almayer/no_build/plating
	icon_state = "plating"

/turf/open/floor/almayer/no_build/plate
	icon_state = "plate"

/turf/open/floor/almayer/no_build/test_floor4
	icon_state = "test_floor4"

/turf/open/floor/almayer/aicore
	icon = 'icons/turf/floors/aicore.dmi'
	icon_state = "ai_floor1"

/turf/open/floor/almayer/aicore/is_plasteel_floor()
	return FALSE

/turf/open/floor/almayer/aicore/glowing
	icon_state = "ai_floor2"
	light_color = "#d69c46"
	light_range = 3

/turf/open/floor/almayer/aicore/glowing/Initialize(mapload, ...)
	. = ..()
	set_light_on(TRUE)

	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LOCKDOWN, PROC_REF(start_emergency_light_on))
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LIFT, PROC_REF(start_emergency_light_off))

/turf/open/floor/almayer/aicore/glowing/proc/start_emergency_light_on()
	set_light(l_color = "#c70f0f")

/turf/open/floor/almayer/aicore/glowing/proc/start_emergency_light_off()
	set_light(l_color = "#d69c46")

/turf/open/floor/almayer/aicore/no_build
	allow_construction = FALSE
	turf_flags = parent_type::turf_flags|TURF_HULL

/turf/open/floor/almayer/aicore/no_build/ai_arrow
	icon_state = "ai_arrow"

/turf/open/floor/almayer/aicore/no_build/ai_arrow/east
	dir = EAST

/turf/open/floor/almayer/aicore/no_build/ai_silver
	icon_state = "ai_silver"

/turf/open/floor/almayer/aicore/no_build/ai_silver/east
	dir = EAST

/turf/open/floor/almayer/aicore/no_build/ai_arrow/west
	dir = WEST

/turf/open/floor/almayer/aicore/no_build/ai_silver/west
	dir = WEST

/turf/open/floor/almayer/aicore/no_build/ai_cargo
	icon_state = "ai_cargo"

/turf/open/floor/almayer/aicore/no_build/ai_floor2
	icon_state = "ai_floor2"

/turf/open/floor/almayer/aicore/no_build/ai_plates
	icon_state = "ai_plates"

/turf/open/floor/almayer/aicore/glowing/no_build
	allow_construction = FALSE
	turf_flags = parent_type::turf_flags|TURF_HULL

/turf/open/floor/almayer/aicore/glowing/no_build/ai_floor3_4range
	icon_state = "ai_floor3"
	light_range = 4

/turf/open/floor/almayer/aicore/glowing/no_build/ai_floor3
	icon_state = "ai_floor3"

// RESEARCH STUFF
/turf/open/floor/almayer/research/containment/entrance
	icon_state = "containment_entrance"

/turf/open/floor/almayer/research/containment/floor1
	icon_state = "containment_floor_1"

/turf/open/floor/almayer/research/containment/floor2
	icon_state = "containment_floor_2"

/turf/open/floor/almayer/research/containment/corner
	icon_state = "containment_corner"

/turf/open/floor/almayer/research/containment/corner1
	icon_state = "containment_corner_1"

/turf/open/floor/almayer/research/containment/corner2
	icon_state = "containment_corner_2"

/turf/open/floor/almayer/research/containment/corner3
	icon_state = "containment_corner_3"

/turf/open/floor/almayer/research/containment/corner4
	icon_state = "containment_corner_4"

/turf/open/floor/almayer/research/containment/corner_var1
	icon_state = "containment_corner_variant_1"

/turf/open/floor/almayer/research/containment/corner_var2
	icon_state = "containment_corner_variant_2"

/turf/open/floor/almayer/research/containment/corner_var1/north
	dir = NORTH

/turf/open/floor/almayer/research/containment/corner_var1/east
	dir = EAST

/turf/open/floor/almayer/research/containment/corner_var1/containment_corner_variant_2
	icon_state = "containment_corner_variant_2"

/turf/open/floor/almayer/research/containment/corner/north
	dir = NORTH

/turf/open/floor/almayer/research/containment/corner/east
	dir = EAST

/turf/open/floor/almayer/research/containment/entrance/west
	dir = WEST

/turf/open/floor/almayer/research/containment/floor2/north
	dir = NORTH

/turf/open/floor/almayer/research/containment/floor2/west
	dir = WEST

/turf/open/floor/almayer/fake_outerhull
	icon_state = "outerhull"

/turf/open/floor/almayer/research/containment/yautja
	icon ='icons/turf/floors/corsat.dmi'
	icon_state = "box"

/turf/open/floor/almayer/research/containment/yautja/alt
	icon_state = "squares"

//Outerhull

/turf/open/floor/almayer_hull
	icon = 'icons/turf/almayer.dmi'
	icon_state = "outerhull"
	name = "hull"
	turf_flags = TURF_HULL
	allow_construction = FALSE
	is_weedable = NOT_WEEDABLE

/turf/open/floor/almayer_hull/outerhull_dir
	icon_state = "outerhull_dir"

/turf/open/floor/almayer_hull/outerhull_dir/southwest
	dir = SOUTHWEST

/turf/open/floor/almayer_hull/outerhull_dir/north
	dir = NORTH

/turf/open/floor/almayer_hull/outerhull_dir/east
	dir = EAST

/turf/open/floor/almayer_hull/outerhull_dir/northeast
	dir = NORTHEAST

/turf/open/floor/almayer_hull/outerhull_dir/southeast
	dir = SOUTHEAST

/turf/open/floor/almayer_hull/outerhull_dir/west
	dir = WEST

/turf/open/floor/almayer_hull/outerhull_dir/northwest
	dir = NORTHWEST



//////////////////////////////////////////////////////////////////////

//Outerhull UPP

/turf/open/floor/upp_hull_rostock
	icon = 'icons/turf/walls/upp_hull.dmi'
	icon_state = "outerhull_upp_rostock"
	name = "hull"
	turf_flags = TURF_HULL

/turf/open/floor/upp_hull_rostock/outerhull_dir
	icon_state = "outerhull_dir_upp_rostock"

/turf/open/floor/upp_hull_rostock/outerhull_dir/southwest
	dir = SOUTHWEST

/turf/open/floor/upp_hull_rostock/outerhull_dir/north
	dir = NORTH

/turf/open/floor/upp_hull_rostock/outerhull_dir/east
	dir = EAST

/turf/open/floor/upp_hull_rostock/outerhull_dir/northeast
	dir = NORTHEAST

/turf/open/floor/upp_hull_rostock/outerhull_dir/southeast
	dir = SOUTHEAST

/turf/open/floor/upp_hull_rostock/outerhull_dir/west
	dir = WEST

/turf/open/floor/upp_hull_rostock/outerhull_dir/northwest
	dir = NORTHWEST


//Outerhull Reskin Almayer UPP

/turf/open/floor/upp_hull
	icon = 'icons/turf/walls/upp_hull.dmi'
	icon_state = "outerhull_upp"
	name = "hull"
	turf_flags = TURF_HULL

/turf/open/floor/upp_hull/outerhull_dir
	icon_state = "outerhull_dir_upp"

/turf/open/floor/upp_hull/outerhull_dir/southwest
	dir = SOUTHWEST

/turf/open/floor/upp_hull/outerhull_dir/north
	dir = NORTH

/turf/open/floor/upp_hull/outerhull_dir/east
	dir = EAST

/turf/open/floor/upp_hull/outerhull_dir/northeast
	dir = NORTHEAST

/turf/open/floor/upp_hull/outerhull_dir/southeast
	dir = SOUTHEAST

/turf/open/floor/upp_hull/outerhull_dir/west
	dir = WEST

/turf/open/floor/upp_hull/outerhull_dir/northwest
	dir = NORTHWEST






//////////////////////////////////////////////////////////////////////




/turf/open/floor/airless
	icon_state = "floor"
	name = "airless floor"

/turf/open/floor/airless/Initialize(mapload, ...)
	. = ..()
	name = "floor"

/turf/open/floor/airless/asteroidfloor
	icon_state = "asteroidfloor"

/turf/open/floor/airless/asteroidfloor/northeast
	dir = NORTHEAST

/turf/open/floor/icefloor
	icon_state = "floor"
	name = "ice colony floor"
	plating_type = /turf/open/floor/plating/icefloor

/turf/open/floor/icefloor/is_plasteel_floor()
	return FALSE

/turf/open/floor/icefloor/shuttle_floor6
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor6"

/turf/open/floor/icefloor/shuttle_floor7
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor7"

/turf/open/floor/icefloor/shuttle_vfloor
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "vfloor"

/turf/open/floor/icefloor/ramptop
	icon_state = "ramptop"

/turf/open/floor/icefloor/rockvault
	icon_state = "rockvault"

/turf/open/floor/wood
	name = "wooden floor"
	icon_state = "wood"
	tile_type = /obj/item/stack/tile/wood
	tool_flags = BREAK_CROWBAR|REMOVE_SCREWDRIVER

/turf/open/floor/wood/is_wood_floor()
	return TRUE

/turf/open/floor/wood/ship
	name = "fake wooden floor"
	desc = "This metal floor has been painted to look like one made of wood. Unfortunately, wood and high-pressure internal atmosphere don't mix well. Wood is a major fire hazard don't'cha know."
	tile_type = /obj/item/stack/tile/wood/fake

/turf/open/floor/wood/wood_broken
	icon_state = "wood-broken"

/turf/open/floor/wood/wood_broken2
	icon_state = "wood-broken2"

/turf/open/floor/wood/wood_broken3
	icon_state = "wood-broken3"

/turf/open/floor/wood/wood_broken4
	icon_state = "wood-broken4"

/turf/open/floor/wood/wood_broken5
	icon_state = "wood-broken5"

/turf/open/floor/wood/wood_broken6
	icon_state = "wood-broken6"

/turf/open/floor/wood/wood_broken7
	icon_state = "wood-broken7"

/turf/open/floor/vault
	icon_state = "rockvault"

/turf/open/floor/vault/sandstone
	icon_state = "sandstonevault"

/turf/open/floor/vault/alien
	icon_state = "alienvault"

/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	intact_tile = 0
	turf_flags = NO_FLAGS
	baseturfs = /turf/open/floor

/turf/open/floor/engine/simulator_center
	color = "#AAAAAA"

/turf/open/floor/engine/make_plating()
	return

/turf/open/floor/engine/attackby(obj/item/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
		user.visible_message(SPAN_NOTICE("[user] starts removing [src]'s protective cover."),
		SPAN_NOTICE("You start removing [src]'s protective cover."))
		playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			new /obj/item/stack/rods(src, 2)
			var/turf/open/floor/F = ScrapeAway()
			if(istype(/turf/open/floor, F))
				F.make_plating()


/turf/open/floor/engine/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(25))
				break_tile_to_plating()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_tile_to_plating()


/turf/open/floor/engine/nitrogen

/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"


/turf/open/floor/engine/mars/exterior
	name = "floor"
	icon_state = "ironsand1"





/turf/open/floor/bluegrid
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "bcircuit"

/turf/open/floor/bluegrid/bcircuitoff
	icon_state = "bcircuitoff"

/turf/open/floor/bluegrid/damaged3
	icon_state = "damaged3"

/turf/open/floor/bluegrid/damaged4
	icon_state = "damaged4"

/turf/open/floor/bluegrid/damaged5
	icon_state = "damaged5"

/turf/open/floor/greengrid
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "gcircuit"


/turf/open/floor/grass
	name = "grass patch"
	icon_state = "grass1"
	tile_type = /obj/item/stack/tile/grass
	tool_flags = null

/turf/open/floor/grass/Initialize(mapload, ...)
	. = ..()
	icon_state = "grass[pick("1","2","3","4")]"
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/grass/LateInitialize()
	. = ..()
	for(var/direction in GLOB.cardinals)
		if(istype(get_step(src,direction),/turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() //so siding get updated properly

/turf/open/floor/grass/is_grass_floor()
	return TRUE

/turf/open/floor/grass/update_icon()
	. = ..()
	if(!(turf_flags & TURF_BROKEN) && !(turf_flags & TURF_BURNT))
		if(!(icon_state in list("grass1", "grass2", "grass3", "grass4")))
			icon_state = "grass[pick("1", "2", "3", "4")]"

/turf/open/floor/grass/make_plating()
	return

/turf/open/floor/carpet
	name = "carpet"
	desc = "Plush, waterproof carpet. Apparently it's fire resistant while remaining quite soft."
	icon_state = "carpet"
	tile_type = /obj/item/stack/tile/carpet
	tool_flags = REMOVE_SCREWDRIVER

/turf/open/floor/carpet/Initialize(mapload, ...)
	. = ..()
	if(!icon_state)
		icon_state = "carpet"
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/carpet/LateInitialize()
	. = ..()
	update_icon()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if(istype(get_step(src,direction),/turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() //so siding get updated properly

/turf/open/floor/carpet/is_carpet_floor()
	return TRUE

/turf/open/floor/carpet/update_icon()
	. = ..()
	if(!(turf_flags & TURF_BROKEN) && !(turf_flags & TURF_BURNT))
		if(icon_state != "carpetsymbol")
			var/connectdir = 0
			for(var/direction in GLOB.cardinals)
				if(istype(get_step(src, direction), /turf/open/floor))
					var/turf/open/floor/FF = get_step(src, direction)
					if(FF.is_carpet_floor())
						connectdir |= direction

			//Check the diagonal connections for corners, where you have, for example, connections both north and east
			//In this case it checks for a north-east connection to determine whether to add a corner marker or not.
			var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

			//Northeast
			if(connectdir & NORTH && connectdir & EAST)
				if(istype(get_step(src,NORTHEAST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,NORTHEAST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 1

			//Southeast
			if(connectdir & SOUTH && connectdir & EAST)
				if(istype(get_step(src,SOUTHEAST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,SOUTHEAST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 2

			//Northwest
			if(connectdir & NORTH && connectdir & WEST)
				if(istype(get_step(src,NORTHWEST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,NORTHWEST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 4

			//Southwest
			if(connectdir & SOUTH && connectdir & WEST)
				if(istype(get_step(src,SOUTHWEST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,SOUTHWEST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 8

			icon_state = "carpet[connectdir]-[diagonalconnect]"

/turf/open/floor/carpet/make_plating()
	for(var/direction in GLOB.alldirs)
		if(istype(get_step(src, direction), /turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() // So siding get updated properly
	return ..()

/turf/open/floor/carpet/bcarpet01
	icon_state = "bcarpet01"

/turf/open/floor/carpet/bcarpet02
	icon_state = "bcarpet02"

/turf/open/floor/carpet/bcarpet03
	icon_state = "bcarpet03"

/turf/open/floor/carpet/bcarpet07
	icon_state = "bcarpet07"

/turf/open/floor/carpet/bcarpet08
	icon_state = "bcarpet08"

/turf/open/floor/carpet/bcarpet09
	icon_state = "bcarpet09"

/turf/open/floor/carpet/edge
	icon_state = "carpetside"

/turf/open/floor/carpet/edge/southwest
	dir = SOUTHWEST

/turf/open/floor/carpet/edge/north
	dir = NORTH

/turf/open/floor/carpet/edge/east
	dir = EAST

/turf/open/floor/carpet/edge/northeast
	dir = NORTHEAST

/turf/open/floor/carpet/edge/southeast
	dir = SOUTHEAST

/turf/open/floor/carpet/edge/west
	dir = WEST

/turf/open/floor/carpet/edge/northwest
	dir = NORTHWEST

// Start Prison tiles

/turf/open/floor/prison
	icon = 'icons/turf/floors/prison.dmi'
	icon_state = "floor"
	plating_type = /turf/open/floor/plating/prison

/turf/open/floor/prison/trim/red
	icon_state = "darkred2"

/turf/open/floor/prison/chapel_carpet
	icon = 'icons/turf/floors/carpet_manual.dmi'//I dunno man, CM-ified carpet sprites are placed manually and I can't be bothered to write a new system for 'em.
	icon_state = "single"

/turf/open/floor/prison/chapel_carpet/doubleside
	icon_state = "doubleside"

/turf/open/floor/prison/chapel_carpet/doubleside/north
	dir = NORTH

/turf/open/floor/prison/blue
	icon_state = "blue"

/turf/open/floor/prison/blue/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/bright_clean
	icon_state = "bright_clean"

/turf/open/floor/prison/bright_clean/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/bright_clean2
	icon_state = "bright_clean2"

/turf/open/floor/prison/bright_clean2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/bright_clean_marked
	icon_state = "bright_clean_marked"

/turf/open/floor/prison/bright_clean_marked/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/damaged1
	icon_state = "damaged1"

/turf/open/floor/prison/damaged1/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/damaged2
	icon_state = "damaged2"

/turf/open/floor/prison/damaged2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkbrown2
	icon_state = "darkbrown2"

/turf/open/floor/prison/darkbrown2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkbrown3
	icon_state = "darkbrown3"

/turf/open/floor/prison/darkbrown3/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkbrown3/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/darkbrowncorners2
	icon_state = "darkbrowncorners2"

/turf/open/floor/prison/darkbrowncorners2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkpurple2
	icon_state = "darkpurple2"

/turf/open/floor/prison/darkpurple2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkred2
	icon_state = "darkred2"

/turf/open/floor/prison/darkred2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkredcorners2
	icon_state = "darkredcorners2"

/turf/open/floor/prison/darkredcorners2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkredfull2
	icon_state = "darkredfull2"

/turf/open/floor/prison/darkredfull2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkyellow2
	icon_state = "darkyellow2"

/turf/open/floor/prison/darkyellow2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/darkyellowcorners2
	icon_state = "darkyellowcorners2"

/turf/open/floor/prison/darkyellowcorners2/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/floor_marked
	icon_state = "floor_marked"

/turf/open/floor/prison/floor_marked/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/floor_plate
	icon_state = "floor_plate"

/turf/open/floor/prison/floor_plate/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/green
	icon_state = "green"

/turf/open/floor/prison/green/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/greenblue
	icon_state = "greenblue"

/turf/open/floor/prison/greenblue/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/kitchen
	icon_state = "kitchen"

/turf/open/floor/prison/kitchen/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/red
	icon_state = "red"

/turf/open/floor/prison/red/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/sterile_white
	icon_state = "sterile_white"

/turf/open/floor/prison/sterile_white/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/whitegreen
	icon_state = "whitegreen"

/turf/open/floor/prison/whitegreen/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/whitegreenfull
	icon_state = "whitegreenfull"

/turf/open/floor/prison/whitegreenfull/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/whitepurple
	icon_state = "whitepurple"

/turf/open/floor/prison/whitepurple/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/whitered
	icon_state = "whitered"

/turf/open/floor/prison/whitered/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/yellow
	icon_state = "yellow"

/turf/open/floor/prison/yellow/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/yellowfull
	icon_state = "yellowfull"

/turf/open/floor/prison/yellowfull/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/blue/north
	dir = NORTH

/turf/open/floor/prison/blue_plate
	icon_state = "blue_plate"

/turf/open/floor/prison/blue_plate/north
	dir = NORTH

/turf/open/floor/prison/bluecorner
	icon_state = "bluecorner"

/turf/open/floor/prison/bluecorner/north
	dir = NORTH

/turf/open/floor/prison/cell_stripe
	icon_state = "cell_stripe"

/turf/open/floor/prison/cell_stripe/north
	dir = NORTH

/turf/open/floor/prison/darkbrown2/north
	dir = NORTH

/turf/open/floor/prison/darkbrown3/north
	dir = NORTH

/turf/open/floor/prison/darkbrowncorners2/north
	dir = NORTH

/turf/open/floor/prison/darkbrowncorners3
	icon_state = "darkbrowncorners3"

/turf/open/floor/prison/darkbrowncorners3/north
	dir = NORTH

/turf/open/floor/prison/darkpurple2/north
	dir = NORTH

/turf/open/floor/prison/darkpurplecorners2
	icon_state = "darkpurplecorners2"

/turf/open/floor/prison/darkpurplecorners2/north
	dir = NORTH

/turf/open/floor/prison/darkred2/north
	dir = NORTH

/turf/open/floor/prison/darkredcorners2/north
	dir = NORTH

/turf/open/floor/prison/darkyellow2/north
	dir = NORTH

/turf/open/floor/prison/darkyellowcorners2/north
	dir = NORTH

/turf/open/floor/prison/green/north
	dir = NORTH

/turf/open/floor/prison/greenblue/north
	dir = NORTH

/turf/open/floor/prison/greenbluecorner
	icon_state = "greenbluecorner"

/turf/open/floor/prison/greenbluecorner/north
	dir = NORTH

/turf/open/floor/prison/greencorner
	icon_state = "greencorner"

/turf/open/floor/prison/greencorner/north
	dir = NORTH

/turf/open/floor/prison/rampbottom
	icon_state = "rampbottom"

/turf/open/floor/prison/rampbottom/north
	dir = NORTH

/turf/open/floor/prison/red/north
	dir = NORTH

/turf/open/floor/prison/redcorner
	icon_state = "redcorner"

/turf/open/floor/prison/redcorner/north
	dir = NORTH

/turf/open/floor/prison/whitegreen/north
	dir = NORTH

/turf/open/floor/prison/whitegreencorner
	icon_state = "whitegreencorner"

/turf/open/floor/prison/whitegreencorner/north
	dir = NORTH

/turf/open/floor/prison/whitepurple/north
	dir = NORTH

/turf/open/floor/prison/whitepurplecorner
	icon_state = "whitepurplecorner"

/turf/open/floor/prison/whitepurplecorner/north
	dir = NORTH

/turf/open/floor/prison/whitered/north
	dir = NORTH

/turf/open/floor/prison/yellow/north
	dir = NORTH

/turf/open/floor/prison/yellowcorner
	icon_state = "yellowcorner"

/turf/open/floor/prison/yellowcorner/north
	dir = NORTH

/turf/open/floor/prison/sterile_white/south
	dir = SOUTH

/turf/open/floor/prison/blue/east
	dir = EAST

/turf/open/floor/prison/blue_plate/east
	dir = EAST

/turf/open/floor/prison/bluecorner/east
	dir = EAST

/turf/open/floor/prison/cell_stripe/east
	dir = EAST

/turf/open/floor/prison/darkbrown2/east
	dir = EAST

/turf/open/floor/prison/darkbrown3/east
	dir = EAST

/turf/open/floor/prison/darkbrowncorners2/east
	dir = EAST

/turf/open/floor/prison/darkbrowncorners3/east
	dir = EAST

/turf/open/floor/prison/darkpurple2/east
	dir = EAST

/turf/open/floor/prison/darkpurplecorners2/east
	dir = EAST

/turf/open/floor/prison/darkred2/east
	dir = EAST

/turf/open/floor/prison/darkredcorners2/east
	dir = EAST

/turf/open/floor/prison/darkyellow2/east
	dir = EAST

/turf/open/floor/prison/darkyellowcorners2/east
	dir = EAST

/turf/open/floor/prison/darkyellowfull2
	icon_state = "darkyellowfull2"

/turf/open/floor/prison/darkyellowfull2/east
	dir = EAST

/turf/open/floor/prison/green/east
	dir = EAST

/turf/open/floor/prison/greenblue/east
	dir = EAST

/turf/open/floor/prison/greenbluecorner/east
	dir = EAST

/turf/open/floor/prison/greencorner/east
	dir = EAST

/turf/open/floor/prison/greenfull
	icon_state = "greenfull"

/turf/open/floor/prison/greenfull/east
	dir = EAST

/turf/open/floor/prison/rampbottom/east
	dir = EAST

/turf/open/floor/prison/red/east
	dir = EAST

/turf/open/floor/prison/redcorner/east
	dir = EAST

/turf/open/floor/prison/whitegreen/east
	dir = EAST

/turf/open/floor/prison/whitegreencorner/east
	dir = EAST

/turf/open/floor/prison/whitepurple/east
	dir = EAST

/turf/open/floor/prison/whitepurplecorner/east
	dir = EAST

/turf/open/floor/prison/whitered/east
	dir = EAST

/turf/open/floor/prison/whiteredcorner
	icon_state = "whiteredcorner"

/turf/open/floor/prison/whiteredcorner/east
	dir = EAST

/turf/open/floor/prison/yellow/east
	dir = EAST

/turf/open/floor/prison/yellowcorner/east
	dir = EAST

/turf/open/floor/prison/blue/northeast
	dir = NORTHEAST

/turf/open/floor/prison/darkbrown2/northeast
	dir = NORTHEAST

/turf/open/floor/prison/darkpurple2/northeast
	dir = NORTHEAST

/turf/open/floor/prison/darkred2/northeast
	dir = NORTHEAST

/turf/open/floor/prison/darkyellow2/northeast
	dir = NORTHEAST

/turf/open/floor/prison/green/northeast
	dir = NORTHEAST

/turf/open/floor/prison/greenblue/northeast
	dir = NORTHEAST

/turf/open/floor/prison/red/northeast
	dir = NORTHEAST

/turf/open/floor/prison/whitegreen/northeast
	dir = NORTHEAST

/turf/open/floor/prison/whitepurple/northeast
	dir = NORTHEAST

/turf/open/floor/prison/whitered/northeast
	dir = NORTHEAST

/turf/open/floor/prison/yellow/northeast
	dir = NORTHEAST

/turf/open/floor/prison/blue/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/darkbrown2/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/darkpurple2/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/darkred2/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/darkyellow2/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/green/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/greenblue/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/red/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/whitegreen/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/whitepurple/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/whitered/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/yellow/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/blue/west
	dir = WEST

/turf/open/floor/prison/blue_plate/west
	dir = WEST

/turf/open/floor/prison/bluecorner/west
	dir = WEST

/turf/open/floor/prison/bluefull
	icon_state = "bluefull"

/turf/open/floor/prison/bluefull/west
	dir = WEST

/turf/open/floor/prison/cell_stripe/west
	dir = WEST

/turf/open/floor/prison/darkbrown2/west
	dir = WEST

/turf/open/floor/prison/darkbrown3/west
	dir = WEST

/turf/open/floor/prison/darkbrowncorners2/west
	dir = WEST

/turf/open/floor/prison/darkbrowncorners3/west
	dir = WEST

/turf/open/floor/prison/darkpurple2/west
	dir = WEST

/turf/open/floor/prison/darkpurplecorners2/west
	dir = WEST

/turf/open/floor/prison/darkred2/west
	dir = WEST

/turf/open/floor/prison/darkredcorners2/west
	dir = WEST

/turf/open/floor/prison/darkyellow2/west
	dir = WEST

/turf/open/floor/prison/darkyellowcorners2/west
	dir = WEST

/turf/open/floor/prison/floor_marked/west
	dir = WEST

/turf/open/floor/prison/green/west
	dir = WEST

/turf/open/floor/prison/greenblue/west
	dir = WEST

/turf/open/floor/prison/greenbluecorner/west
	dir = WEST

/turf/open/floor/prison/greencorner/west
	dir = WEST

/turf/open/floor/prison/rampbottom/west
	dir = WEST

/turf/open/floor/prison/red/west
	dir = WEST

/turf/open/floor/prison/redcorner/west
	dir = WEST

/turf/open/floor/prison/sterile_white/west
	dir = WEST

/turf/open/floor/prison/whitegreen/west
	dir = WEST

/turf/open/floor/prison/whitegreencorner/west
	dir = WEST

/turf/open/floor/prison/whitepurple/west
	dir = WEST

/turf/open/floor/prison/whitepurplecorner/west
	dir = WEST

/turf/open/floor/prison/whitered/west
	dir = WEST

/turf/open/floor/prison/whiteredcorner/west
	dir = WEST

/turf/open/floor/prison/yellow/west
	dir = WEST

/turf/open/floor/prison/yellowcorner/west
	dir = WEST

/turf/open/floor/prison/west
	dir = WEST

/turf/open/floor/prison/blue/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkbrown2/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkbrown3/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkbrown3/northeast
	dir = NORTHEAST

/turf/open/floor/prison/darkpurple2/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkpurplefull2
	icon_state = "darkpurplefull2"

/turf/open/floor/prison/darkpurplefull2/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkred2/northwest
	dir = NORTHWEST

/turf/open/floor/prison/darkyellow2/northwest
	dir = NORTHWEST

/turf/open/floor/prison/green/northwest
	dir = NORTHWEST

/turf/open/floor/prison/greenblue/northwest
	dir = NORTHWEST

/turf/open/floor/prison/greenfull/northwest
	dir = NORTHWEST

/turf/open/floor/prison/red/northwest
	dir = NORTHWEST

/turf/open/floor/prison/whitegreen/northwest
	dir = NORTHWEST

/turf/open/floor/prison/whitepurple/northwest
	dir = NORTHWEST

/turf/open/floor/prison/whitered/northwest
	dir = NORTHWEST

/turf/open/floor/prison/yellow/northwest
	dir = NORTHWEST

/turf/open/floor/prison/damaged3
	icon_state = "damaged3"

/turf/open/floor/prison/darkbrownfull2
	icon_state = "darkbrownfull2"

/turf/open/floor/prison/floorscorched1
	icon_state = "floorscorched1"

/turf/open/floor/prison/floorscorched2
	icon_state = "floorscorched2"

/turf/open/floor/prison/greenblue/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/greenblue/north
	dir = NORTH

/turf/open/floor/prison/greenblue/east
	dir = EAST

/turf/open/floor/prison/greenblue/northeast
	dir = NORTHEAST

/turf/open/floor/prison/greenblue/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/greenblue/west
	dir = WEST

/turf/open/floor/prison/greenblue/northwest
	dir = NORTHWEST

/turf/open/floor/prison/greenbluecorner/east
	dir = EAST

/turf/open/floor/prison/panelscorched
	icon_state = "panelscorched"

/turf/open/floor/prison/platingdmg1
	icon_state = "platingdmg1"

/turf/open/floor/prison/platingdmg2
	icon_state = "platingdmg2"

/turf/open/floor/prison/platingdmg3
	icon_state = "platingdmg3"

/turf/open/floor/prison/red/southwest
	dir = SOUTHWEST

/turf/open/floor/prison/red/north
	dir = NORTH

/turf/open/floor/prison/red/east
	dir = EAST

/turf/open/floor/prison/red/northeast
	dir = NORTHEAST

/turf/open/floor/prison/red/southeast
	dir = SOUTHEAST

/turf/open/floor/prison/red/west
	dir = WEST

/turf/open/floor/prison/red/northwest
	dir = NORTHWEST

/turf/open/floor/prison/redcorner/north
	dir = NORTH

/turf/open/floor/prison/redcorner/east
	dir = EAST

/turf/open/floor/prison/redfull
	icon_state = "redfull"

/turf/open/floor/prison/whitepurplefull
	icon_state = "whitepurplefull"

/turf/open/floor/prison/ramptop
	icon_state = "ramptop"

/turf/open/floor/prison/ramptop/north
	dir = NORTH

/turf/open/floor/prison/ramptop/east
	dir = EAST

// Mechbay
/turf/open/floor/mech_bay_recharge_floor
	name = "Mech Bay Recharge Station"
	icon = 'icons/obj/structures/props/mech.dmi'
	icon_state = "recharge_floor"

/turf/open/floor/mech_bay_recharge_floor/break_tile()
	if(turf_flags & TURF_BROKEN)
		return
	ChangeTurf(/turf/open/floor/plating)
	turf_flags |= TURF_BROKEN

/turf/open/floor/mech_bay_recharge_floor/shuttle_landing_lights
	name = "shuttle landing lights"

/turf/open/floor/interior
	icon = 'icons/turf/floors/interior.dmi'
	icon_state = null

/turf/open/floor/interior/wood
	name = "wooden floor"
	icon_state = "oldwood1"
	tile_type = /obj/item/stack/tile/wood
	turf_flags = NO_FLAGS // platingdmg && panelscorched icon_state does not exist in this icon

/turf/open/floor/interior/wood/is_wood_floor()
	return TRUE

/turf/open/floor/interior/wood/alt
	icon_state = "oldwood2"

/turf/open/floor/interior/tatami
	name = "tatami flooring"
	desc = "A type of flooring often used in traditional Japanese-style housing."
	icon_state = "tatami"

/turf/open/floor/interior/plastic
	name = "plastic floor"
	icon_state = "plasticfloor1"

/turf/open/floor/interior/plastic/alt
	icon_state = "plasticfloor2"

// Biodome tiles

/turf/open/floor/corsat
	icon = 'icons/turf/floors/corsat.dmi'
	icon_state = "plating"

/turf/open/floor/corsat/blue
	icon_state = "blue"

/turf/open/floor/corsat/blue/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/bluegrey
	icon_state = "bluegrey"

/turf/open/floor/corsat/bluegrey/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/brown
	icon_state = "brown"

/turf/open/floor/corsat/brown/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/corsat_teleporter_static
	icon_state = "corsat_teleporter_static"

/turf/open/floor/corsat/corsat_teleporter_static/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/darkgreen
	icon_state = "darkgreen"

/turf/open/floor/corsat/darkgreen/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/green
	icon_state = "green"

/turf/open/floor/corsat/green/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/greenwhite
	icon_state = "greenwhite"

/turf/open/floor/corsat/greenwhite/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/purple
	icon_state = "purple"

/turf/open/floor/corsat/purple/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/purplewhite
	icon_state = "purplewhite"

/turf/open/floor/corsat/purplewhite/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/red
	icon_state = "red"

/turf/open/floor/corsat/red/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/tcomms
	icon_state = "tcomms"

/turf/open/floor/corsat/tcomms/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/white
	icon_state = "white"

/turf/open/floor/corsat/white/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/whitebluefull
	icon_state = "whitebluefull"

/turf/open/floor/corsat/whitebluefull/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/whitetan
	icon_state = "whitetan"

/turf/open/floor/corsat/whitetan/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/yellow
	icon_state = "yellow"

/turf/open/floor/corsat/yellow/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/blue/north
	dir = NORTH

/turf/open/floor/corsat/bluecorner
	icon_state = "bluecorner"

/turf/open/floor/corsat/bluecorner/north
	dir = NORTH

/turf/open/floor/corsat/bluegrey/north
	dir = NORTH

/turf/open/floor/corsat/bluegreycorner
	icon_state = "bluegreycorner"

/turf/open/floor/corsat/bluegreycorner/north
	dir = NORTH

/turf/open/floor/corsat/brown/north
	dir = NORTH

/turf/open/floor/corsat/browncorner
	icon_state = "browncorner"

/turf/open/floor/corsat/browncorner/north
	dir = NORTH

/turf/open/floor/corsat/darkgreen/north
	dir = NORTH

/turf/open/floor/corsat/darkgreencorner
	icon_state = "darkgreencorner"

/turf/open/floor/corsat/darkgreencorner/north
	dir = NORTH

/turf/open/floor/corsat/green/north
	dir = NORTH

/turf/open/floor/corsat/greencorner
	icon_state = "greencorner"

/turf/open/floor/corsat/greencorner/north
	dir = NORTH

/turf/open/floor/corsat/greenwhite/north
	dir = NORTH

/turf/open/floor/corsat/greenwhitecorner
	icon_state = "greenwhitecorner"

/turf/open/floor/corsat/greenwhitecorner/north
	dir = NORTH

/turf/open/floor/corsat/purple/north
	dir = NORTH

/turf/open/floor/corsat/purplecorner
	icon_state = "purplecorner"

/turf/open/floor/corsat/purplecorner/north
	dir = NORTH

/turf/open/floor/corsat/purplewhite/north
	dir = NORTH

/turf/open/floor/corsat/purplewhitecorner
	icon_state = "purplewhitecorner"

/turf/open/floor/corsat/purplewhitecorner/north
	dir = NORTH

/turf/open/floor/corsat/red/north
	dir = NORTH

/turf/open/floor/corsat/redcorner
	icon_state = "redcorner"

/turf/open/floor/corsat/redcorner/north
	dir = NORTH

/turf/open/floor/corsat/squareswood
	icon_state = "squareswood"

/turf/open/floor/corsat/squareswood/north
	dir = NORTH

/turf/open/floor/corsat/tan
	icon_state = "tan"

/turf/open/floor/corsat/tan/north
	dir = NORTH

/turf/open/floor/corsat/white/north
	dir = NORTH

/turf/open/floor/corsat/whitecorner
	icon_state = "whitecorner"

/turf/open/floor/corsat/whitecorner/north
	dir = NORTH

/turf/open/floor/corsat/whitetan/north
	dir = NORTH

/turf/open/floor/corsat/whitetancorner
	icon_state = "whitetancorner"

/turf/open/floor/corsat/whitetancorner/north
	dir = NORTH

/turf/open/floor/corsat/yellow/north
	dir = NORTH

/turf/open/floor/corsat/yellowcorner
	icon_state = "yellowcorner"

/turf/open/floor/corsat/yellowcorner/north
	dir = NORTH

/turf/open/floor/corsat/blue/east
	dir = EAST

/turf/open/floor/corsat/bluecorner/east
	dir = EAST

/turf/open/floor/corsat/bluegrey/east
	dir = EAST

/turf/open/floor/corsat/bluegreycorner/east
	dir = EAST

/turf/open/floor/corsat/brown/east
	dir = EAST

/turf/open/floor/corsat/browncorner/east
	dir = EAST

/turf/open/floor/corsat/darkgreen/east
	dir = EAST

/turf/open/floor/corsat/darkgreencorner/east
	dir = EAST

/turf/open/floor/corsat/green/east
	dir = EAST

/turf/open/floor/corsat/greencorner/east
	dir = EAST

/turf/open/floor/corsat/greenwhite/east
	dir = EAST

/turf/open/floor/corsat/greenwhitecorner/east
	dir = EAST

/turf/open/floor/corsat/purple/east
	dir = EAST

/turf/open/floor/corsat/purplecorner/east
	dir = EAST

/turf/open/floor/corsat/purplewhite/east
	dir = EAST

/turf/open/floor/corsat/purplewhitecorner/east
	dir = EAST

/turf/open/floor/corsat/red/east
	dir = EAST

/turf/open/floor/corsat/redcorner/east
	dir = EAST

/turf/open/floor/corsat/white/east
	dir = EAST

/turf/open/floor/corsat/whitecorner/east
	dir = EAST

/turf/open/floor/corsat/whitetan/east
	dir = EAST

/turf/open/floor/corsat/whitetancorner/east
	dir = EAST

/turf/open/floor/corsat/yellow/east
	dir = EAST

/turf/open/floor/corsat/yellowcorner/east
	dir = EAST

/turf/open/floor/corsat/blue/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/bluegrey/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/brown/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/darkgreen/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/green/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/greenwhite/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/purple/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/purplewhite/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/red/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/white/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/whitetan/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/yellow/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/blue/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/bluegrey/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/brown/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/darkgreen/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/green/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/greenwhite/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/purple/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/purplewhite/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/red/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/white/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/whitetan/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/yellow/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/blue/west
	dir = WEST

/turf/open/floor/corsat/bluecorner/west
	dir = WEST

/turf/open/floor/corsat/bluegrey/west
	dir = WEST

/turf/open/floor/corsat/bluegreycorner/west
	dir = WEST

/turf/open/floor/corsat/brown/west
	dir = WEST

/turf/open/floor/corsat/browncorner/west
	dir = WEST

/turf/open/floor/corsat/darkgreen/west
	dir = WEST

/turf/open/floor/corsat/darkgreencorner/west
	dir = WEST

/turf/open/floor/corsat/green/west
	dir = WEST

/turf/open/floor/corsat/greencorner/west
	dir = WEST

/turf/open/floor/corsat/greenwhite/west
	dir = WEST

/turf/open/floor/corsat/greenwhitecorner/west
	dir = WEST

/turf/open/floor/corsat/purple/west
	dir = WEST

/turf/open/floor/corsat/purplecorner/west
	dir = WEST

/turf/open/floor/corsat/purplewhite/west
	dir = WEST

/turf/open/floor/corsat/purplewhitecorner/west
	dir = WEST

/turf/open/floor/corsat/red/west
	dir = WEST

/turf/open/floor/corsat/redcorner/west
	dir = WEST

/turf/open/floor/corsat/white/west
	dir = WEST

/turf/open/floor/corsat/whitecorner/west
	dir = WEST

/turf/open/floor/corsat/whitetan/west
	dir = WEST

/turf/open/floor/corsat/whitetancorner/west
	dir = WEST

/turf/open/floor/corsat/yellow/west
	dir = WEST

/turf/open/floor/corsat/yellowcorner/west
	dir = WEST

/turf/open/floor/corsat/blue/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/bluegrey/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/brown/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/darkgreen/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/green/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/greenwhite/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/purple/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/purplewhite/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/red/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/white/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/whitetan/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/yellow/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/arrow_east
	icon_state = "arrow_east"

/turf/open/floor/corsat/arrow_north
	icon_state = "arrow_north"

/turf/open/floor/corsat/arrow_south
	icon_state = "arrow_south"

/turf/open/floor/corsat/arrow_west
	icon_state = "arrow_west"

/turf/open/floor/corsat/cargo
	icon_state = "cargo"

/turf/open/floor/corsat/damaged1
	icon_state = "damaged1"

/turf/open/floor/corsat/gamma
	icon_state = "gamma"

/turf/open/floor/corsat/lightplate
	icon_state = "lightplate"

/turf/open/floor/corsat/marked
	icon_state = "marked"

/turf/open/floor/corsat/officesquares
	icon_state = "officesquares"

/turf/open/floor/corsat/omega
	icon_state = "omega"

/turf/open/floor/corsat/plate
	icon_state = "plate"

/turf/open/floor/corsat/red/southwest
	dir = SOUTHWEST

/turf/open/floor/corsat/red/north
	dir = NORTH

/turf/open/floor/corsat/red/east
	dir = EAST

/turf/open/floor/corsat/red/northeast
	dir = NORTHEAST

/turf/open/floor/corsat/red/southeast
	dir = SOUTHEAST

/turf/open/floor/corsat/red/west
	dir = WEST

/turf/open/floor/corsat/red/northwest
	dir = NORTHWEST

/turf/open/floor/corsat/redcorner/north
	dir = NORTH

/turf/open/floor/corsat/redcorner/east
	dir = EAST

/turf/open/floor/corsat/retrosquares
	icon_state = "retrosquares"

/turf/open/floor/corsat/retrosquareslight
	icon_state = "retrosquareslight"

/turf/open/floor/corsat/sigma
	icon_state = "sigma"

/turf/open/floor/corsat/spiralplate
	icon_state = "spiralplate"

/turf/open/floor/corsat/spiralwoodalt
	icon_state = "spiralwoodalt"

/turf/open/floor/corsat/squares
	icon_state = "squares"

/turf/open/floor/corsat/sterileplate
	icon_state = "sterileplate"

/turf/open/floor/corsat/theta
	icon_state = "theta"

/turf/open/floor/corsat/yellow/north
	dir = NORTH

/turf/open/floor/corsat/yellow/east
	dir = EAST

/turf/open/floor/corsat/yellowcorner/east
	dir = EAST

/turf/open/floor/corsat/box
	icon_state = "box"

/turf/open/floor/corsat/officetiles
	icon_state = "officetiles"

/turf/open/floor/corsat/spiralblueoffice
	icon_state = "spiralblueoffice"
	light_color = "#0090ff"
	light_on = 1
	light_power = 2
	light_range = 4

/turf/open/floor/grey_dark2
	color = "#525151"
	icon_state = "dark2"

/turf/open/floor/solarpanel
	desc = "A sophisticated device that captures and converts light from the system's star into energy for the station."
	icon_state = "solarpanel"
	name = "solarpanel"

/turf/open/floor/asteroidwarning
	icon_state = "asteroidwarning"

/turf/open/floor/asteroidwarning/southwest
	dir = SOUTHWEST

/turf/open/floor/darkblue2
	icon_state = "darkblue2"

/turf/open/floor/darkblue2/southwest
	dir = SOUTHWEST

/turf/open/floor/darkbrown2
	icon_state = "darkbrown2"

/turf/open/floor/darkbrown2/southwest
	dir = SOUTHWEST

/turf/open/floor/darkgreen2
	icon_state = "darkgreen2"

/turf/open/floor/darkgreen2/southwest
	dir = SOUTHWEST

/turf/open/floor/darkpurple2
	icon_state = "darkpurple2"

/turf/open/floor/darkpurple2/southwest
	dir = SOUTHWEST

/turf/open/floor/darkred2
	icon_state = "darkred2"

/turf/open/floor/darkred2/southwest
	dir = SOUTHWEST

/turf/open/floor/darkyellow2
	icon_state = "darkyellow2"

/turf/open/floor/darkyellow2/southwest
	dir = SOUTHWEST

/turf/open/floor/podhatch
	icon_state = "podhatch"

/turf/open/floor/podhatch/southwest
	dir = SOUTHWEST

/turf/open/floor/purple
	icon_state = "purple"

/turf/open/floor/purple/southwest
	dir = SOUTHWEST

/turf/open/floor/red
	icon_state = "red"

/turf/open/floor/red/southwest
	dir = SOUTHWEST

/turf/open/floor/warning
	icon_state = "warning"

/turf/open/floor/warning/southwest
	dir = SOUTHWEST

/turf/open/floor/warnwhite
	icon_state = "warnwhite"

/turf/open/floor/warnwhite/southwest
	dir = SOUTHWEST

/turf/open/floor/whiteblue
	icon_state = "whiteblue"

/turf/open/floor/whiteblue/southwest
	dir = SOUTHWEST

/turf/open/floor/whitegreen
	icon_state = "whitegreen"

/turf/open/floor/whitegreen/southwest
	dir = SOUTHWEST

/turf/open/floor/whitepurple
	icon_state = "whitepurple"

/turf/open/floor/whitepurple/southwest
	dir = SOUTHWEST

/turf/open/floor/whitered
	icon_state = "whitered"

/turf/open/floor/whitered/southwest
	dir = SOUTHWEST

/turf/open/floor/whiteyellow
	icon_state = "whiteyellow"

/turf/open/floor/whiteyellow/southwest
	dir = SOUTHWEST

/turf/open/floor/asteroidfloor
	icon_state = "asteroidfloor"

/turf/open/floor/asteroidfloor/north
	dir = NORTH

/turf/open/floor/asteroidwarning/north
	dir = NORTH

/turf/open/floor/bot
	icon_state = "bot"

/turf/open/floor/bot/north
	dir = NORTH

/turf/open/floor/chapel
	icon_state = "chapel"

/turf/open/floor/chapel/north
	dir = NORTH

/turf/open/floor/darkblue2/north
	dir = NORTH

/turf/open/floor/darkbrown2/north
	dir = NORTH

/turf/open/floor/darkbrowncorners2
	icon_state = "darkbrowncorners2"

/turf/open/floor/darkbrowncorners2/north
	dir = NORTH

/turf/open/floor/darkgreen2/north
	dir = NORTH

/turf/open/floor/darkgreencorners2
	icon_state = "darkgreencorners2"

/turf/open/floor/darkgreencorners2/north
	dir = NORTH

/turf/open/floor/darkpurple2/north
	dir = NORTH

/turf/open/floor/darkpurplecorners2
	icon_state = "darkpurplecorners2"

/turf/open/floor/darkpurplecorners2/north
	dir = NORTH

/turf/open/floor/darkred2/north
	dir = NORTH

/turf/open/floor/darkredcorners2
	icon_state = "darkredcorners2"

/turf/open/floor/darkredcorners2/north
	dir = NORTH

/turf/open/floor/darkyellow2/north
	dir = NORTH

/turf/open/floor/darkyellowcorners2
	icon_state = "darkyellowcorners2"

/turf/open/floor/darkyellowcorners2/north
	dir = NORTH

/turf/open/floor/elevatorshaft
	icon_state = "elevatorshaft"

/turf/open/floor/elevatorshaft/north
	dir = NORTH

/turf/open/floor/green
	icon_state = "green"

/turf/open/floor/green/north
	dir = NORTH

/turf/open/floor/loadingarea
	icon_state = "loadingarea"

/turf/open/floor/loadingarea/north
	dir = NORTH

/turf/open/floor/podhatch/north
	dir = NORTH

/turf/open/floor/podhatchfloor
	icon_state = "podhatchfloor"

/turf/open/floor/podhatchfloor/north
	dir = NORTH

/turf/open/floor/purple/north
	dir = NORTH

/turf/open/floor/rampbottom
	icon_state = "rampbottom"

/turf/open/floor/rampbottom/north
	dir = NORTH

/turf/open/floor/red/north
	dir = NORTH

/turf/open/floor/redcorner
	icon_state = "redcorner"

/turf/open/floor/redcorner/north
	dir = NORTH

/turf/open/floor/vault2
	icon_state = "vault"

/turf/open/floor/vault2/north
	dir = NORTH

/turf/open/floor/warning/north
	dir = NORTH

/turf/open/floor/warningcorner
	icon_state = "warningcorner"

/turf/open/floor/warningcorner/north
	dir = NORTH

/turf/open/floor/warnwhite/north
	dir = NORTH

/turf/open/floor/whiteblue/north
	dir = NORTH

/turf/open/floor/whitebluecorner
	icon_state = "whitebluecorner"

/turf/open/floor/whitebluecorner/north
	dir = NORTH

/turf/open/floor/whitegreen/north
	dir = NORTH

/turf/open/floor/whitegreencorner
	icon_state = "whitegreencorner"

/turf/open/floor/whitegreencorner/north
	dir = NORTH

/turf/open/floor/whitepurple/north
	dir = NORTH

/turf/open/floor/whitepurplecorner
	icon_state = "whitepurplecorner"

/turf/open/floor/whitepurplecorner/north
	dir = NORTH

/turf/open/floor/whitered/north
	dir = NORTH

/turf/open/floor/whiteredcorner
	icon_state = "whiteredcorner"

/turf/open/floor/whiteredcorner/north
	dir = NORTH

/turf/open/floor/whiteyellow/north
	dir = NORTH

/turf/open/floor/whiteyellowcorner
	icon_state = "whiteyellowcorner"

/turf/open/floor/whiteyellowcorner/north
	dir = NORTH

/turf/open/floor/asteroidwarning/east
	dir = EAST

/turf/open/floor/chapel/east
	dir = EAST

/turf/open/floor/darkblue2/east
	dir = EAST

/turf/open/floor/darkbrown2/east
	dir = EAST

/turf/open/floor/darkbrowncorners2/east
	dir = EAST

/turf/open/floor/darkgreen2/east
	dir = EAST

/turf/open/floor/darkgreencorners2/east
	dir = EAST

/turf/open/floor/darkpurple2/east
	dir = EAST

/turf/open/floor/darkpurplecorners2/east
	dir = EAST

/turf/open/floor/darkred2/east
	dir = EAST

/turf/open/floor/darkredcorners2/east
	dir = EAST

/turf/open/floor/darkyellow2/east
	dir = EAST

/turf/open/floor/darkyellowcorners2/east
	dir = EAST

/turf/open/floor/loadingarea/east
	dir = EAST

/turf/open/floor/purple/east
	dir = EAST

/turf/open/floor/red/east
	dir = EAST

/turf/open/floor/redcorner/east
	dir = EAST

/turf/open/floor/warning/east
	dir = EAST

/turf/open/floor/warningcorner/east
	dir = EAST

/turf/open/floor/warnwhite/east
	dir = EAST

/turf/open/floor/whiteblue/east
	dir = EAST

/turf/open/floor/whitebluecorner/east
	dir = EAST

/turf/open/floor/whitegreen/east
	dir = EAST

/turf/open/floor/whitegreencorner/east
	dir = EAST

/turf/open/floor/whitepurple/east
	dir = EAST

/turf/open/floor/whitepurplecorner/east
	dir = EAST

/turf/open/floor/whitered/east
	dir = EAST

/turf/open/floor/whiteredcorner/east
	dir = EAST

/turf/open/floor/whiteyellow/east
	dir = EAST

/turf/open/floor/whiteyellowcorner/east
	dir = EAST

/turf/open/floor/whiteyellowfull
	icon_state = "whiteyellowfull"

/turf/open/floor/whiteyellowfull/east
	dir = EAST

/turf/open/floor/asteroidwarning/northeast
	dir = NORTHEAST

/turf/open/floor/chapel/northeast
	dir = NORTHEAST

/turf/open/floor/darkblue2/northeast
	dir = NORTHEAST

/turf/open/floor/darkbrown2/northeast
	dir = NORTHEAST

/turf/open/floor/darkgreen2/northeast
	dir = NORTHEAST

/turf/open/floor/darkpurple2/northeast
	dir = NORTHEAST

/turf/open/floor/darkred2/northeast
	dir = NORTHEAST

/turf/open/floor/darkyellow2/northeast
	dir = NORTHEAST

/turf/open/floor/podhatch/northeast
	dir = NORTHEAST

/turf/open/floor/purple/northeast
	dir = NORTHEAST

/turf/open/floor/red/northeast
	dir = NORTHEAST

/turf/open/floor/vault2/northeast
	dir = NORTHEAST

/turf/open/floor/warning/northeast
	dir = NORTHEAST

/turf/open/floor/warnwhite/northeast
	dir = NORTHEAST

/turf/open/floor/whiteblue/northeast
	dir = NORTHEAST

/turf/open/floor/whitebluefull
	icon_state = "whitebluefull"

/turf/open/floor/whitebluefull/northeast
	dir = NORTHEAST

/turf/open/floor/whitegreen/northeast
	dir = NORTHEAST

/turf/open/floor/whitegreen_v
	icon_state = "whitegreen_v"

/turf/open/floor/whitegreen_v/northeast
	dir = NORTHEAST

/turf/open/floor/whitegreenfull
	icon_state = "whitegreenfull"

/turf/open/floor/whitegreenfull/northeast
	dir = NORTHEAST

/turf/open/floor/whitepurple/northeast
	dir = NORTHEAST

/turf/open/floor/whitered/northeast
	dir = NORTHEAST

/turf/open/floor/whiteyellow/northeast
	dir = NORTHEAST

/turf/open/floor/asteroidwarning/southeast
	dir = SOUTHEAST

/turf/open/floor/darkblue2/southeast
	dir = SOUTHEAST

/turf/open/floor/darkbrown2/southeast
	dir = SOUTHEAST

/turf/open/floor/darkgreen2/southeast
	dir = SOUTHEAST

/turf/open/floor/darkpurple2/southeast
	dir = SOUTHEAST

/turf/open/floor/darkred2/southeast
	dir = SOUTHEAST

/turf/open/floor/darkyellow2/southeast
	dir = SOUTHEAST

/turf/open/floor/podhatch/southeast
	dir = SOUTHEAST

/turf/open/floor/purple/southeast
	dir = SOUTHEAST

/turf/open/floor/red/southeast
	dir = SOUTHEAST

/turf/open/floor/warning/southeast
	dir = SOUTHEAST

/turf/open/floor/warnwhite/southeast
	dir = SOUTHEAST

/turf/open/floor/whiteblue/southeast
	dir = SOUTHEAST

/turf/open/floor/whitegreen/southeast
	dir = SOUTHEAST

/turf/open/floor/whitepurple/southeast
	dir = SOUTHEAST

/turf/open/floor/whitered/southeast
	dir = SOUTHEAST

/turf/open/floor/whiteyellow/southeast
	dir = SOUTHEAST

/turf/open/floor/asteroidwarning/west
	dir = WEST

/turf/open/floor/barber
	icon_state = "barber"

/turf/open/floor/barber/west
	dir = WEST

/turf/open/floor/carpet10_8
	icon_state = "carpet10-8"

/turf/open/floor/carpet10_8/west
	dir = WEST

/turf/open/floor/carpet11_12
	icon_state = "carpet11-12"

/turf/open/floor/carpet11_12/west
	dir = WEST

/turf/open/floor/carpet13_5
	icon_state = "carpet13-5"

/turf/open/floor/carpet13_5/west
	dir = WEST

/turf/open/floor/carpet14_10
	icon_state = "carpet14-10"

/turf/open/floor/carpet14_10/west
	dir = WEST

/turf/open/floor/carpet15_15
	icon_state = "carpet15-15"

/turf/open/floor/carpet15_15/west
	dir = WEST

/turf/open/floor/carpet5_1
	icon_state = "carpet5-1"

/turf/open/floor/carpet5_1/west
	dir = WEST

/turf/open/floor/carpet6_2
	icon_state = "carpet6-2"

/turf/open/floor/carpet6_2/west
	dir = WEST

/turf/open/floor/carpet7_3
	icon_state = "carpet7-3"

/turf/open/floor/carpet7_3/west
	dir = WEST

/turf/open/floor/carpet9_4
	icon_state = "carpet9-4"

/turf/open/floor/carpet9_4/west
	dir = WEST

/turf/open/floor/carpetside
	icon_state = "carpetside"

/turf/open/floor/carpetside/southwest
	dir = SOUTHWEST

/turf/open/floor/carpetside/north
	dir = NORTH

/turf/open/floor/carpetside/east
	dir = EAST

/turf/open/floor/carpetside/northeast
	dir = NORTHEAST

/turf/open/floor/carpetside/southeast
	dir = SOUTHEAST

/turf/open/floor/carpetside/west
	dir = WEST

/turf/open/floor/carpetside/northwest
	dir = NORTHWEST

/turf/open/floor/bcarpet01
	icon_state = "bcarpet01"

/turf/open/floor/bcarpet01/southeast
	dir = SOUTHEAST

/turf/open/floor/bcarpet02
	icon_state = "bcarpet02"

/turf/open/floor/bcarpet02/southeast
	dir = SOUTHEAST

/turf/open/floor/bcarpet03
	icon_state = "bcarpet03"

/turf/open/floor/bcarpet03/southeast
	dir = SOUTHEAST

/turf/open/floor/bcarpet07
	icon_state = "bcarpet07"

/turf/open/floor/bcarpet07/southeast
	dir = SOUTHEAST

/turf/open/floor/bcarpet08
	icon_state = "bcarpet08"

/turf/open/floor/bcarpet08/southeast
	dir = SOUTHEAST

/turf/open/floor/bcarpet09
	icon_state = "bcarpet09"

/turf/open/floor/bcarpet09/southeast
	dir = SOUTHEAST

/turf/open/floor/chapel/west
	dir = WEST

/turf/open/floor/damaged2
	icon_state = "damaged2"

/turf/open/floor/damaged2/west
	dir = WEST

/turf/open/floor/damaged3
	icon_state = "damaged3"

/turf/open/floor/damaged3/west
	dir = WEST

/turf/open/floor/damaged4
	icon_state = "damaged4"

/turf/open/floor/damaged4/west
	dir = WEST

/turf/open/floor/damaged5
	icon_state = "damaged5"

/turf/open/floor/damaged5/west
	dir = WEST

/turf/open/floor/darkblue2/west
	dir = WEST

/turf/open/floor/darkbrown2/west
	dir = WEST

/turf/open/floor/darkbrowncorners2/west
	dir = WEST

/turf/open/floor/darkgreen2/west
	dir = WEST

/turf/open/floor/darkgreencorners2/west
	dir = WEST

/turf/open/floor/darkpurple2/west
	dir = WEST

/turf/open/floor/darkpurplecorners2/west
	dir = WEST

/turf/open/floor/darkred2/west
	dir = WEST

/turf/open/floor/darkredcorners2/west
	dir = WEST

/turf/open/floor/darkyellow2/west
	dir = WEST

/turf/open/floor/darkyellowcorners2/west
	dir = WEST

/turf/open/floor/loadingarea/west
	dir = WEST

/turf/open/floor/purple/west
	dir = WEST

/turf/open/floor/purplecorner
	icon_state = "purplecorner"

/turf/open/floor/purplecorner/west
	dir = WEST

/turf/open/floor/red/west
	dir = WEST

/turf/open/floor/redcorner/west
	dir = WEST

/turf/open/floor/vault2/west
	dir = WEST

/turf/open/floor/warning/west
	dir = WEST

/turf/open/floor/warningcorner/west
	dir = WEST

/turf/open/floor/warnwhite/west
	dir = WEST

/turf/open/floor/whiteblue/west
	dir = WEST

/turf/open/floor/whitebluecorner/west
	dir = WEST

/turf/open/floor/whitegreen/west
	dir = WEST

/turf/open/floor/whitegreencorner/west
	dir = WEST

/turf/open/floor/whitepurple/west
	dir = WEST

/turf/open/floor/whitepurplecorner/west
	dir = WEST

/turf/open/floor/whitered/west
	dir = WEST

/turf/open/floor/whiteredcorner/west
	dir = WEST

/turf/open/floor/whiteyellow/west
	dir = WEST

/turf/open/floor/whiteyellowcorner/west
	dir = WEST

/turf/open/floor/asteroidwarning/northwest
	dir = NORTHWEST

/turf/open/floor/brown
	icon_state = "brown"

/turf/open/floor/brown/northwest
	dir = NORTHWEST

/turf/open/floor/darkblue2/northwest
	dir = NORTHWEST

/turf/open/floor/darkbrown2/northwest
	dir = NORTHWEST

/turf/open/floor/darkgreen2/northwest
	dir = NORTHWEST

/turf/open/floor/darkpurple2/northwest
	dir = NORTHWEST

/turf/open/floor/darkred2/northwest
	dir = NORTHWEST

/turf/open/floor/darkyellow2/northwest
	dir = NORTHWEST

/turf/open/floor/green/northwest
	dir = NORTHWEST

/turf/open/floor/podhatch/northwest
	dir = NORTHWEST

/turf/open/floor/purple/northwest
	dir = NORTHWEST

/turf/open/floor/red/northwest
	dir = NORTHWEST

/turf/open/floor/redfull
	icon_state = "redfull"

/turf/open/floor/redfull/northwest
	dir = NORTHWEST

/turf/open/floor/warning/northwest
	dir = NORTHWEST

/turf/open/floor/warnwhite/northwest
	dir = NORTHWEST

/turf/open/floor/whiteblue/northwest
	dir = NORTHWEST

/turf/open/floor/whitegreen/northwest
	dir = NORTHWEST

/turf/open/floor/whitegreen_v/northwest
	dir = NORTHWEST

/turf/open/floor/whitepurple/northwest
	dir = NORTHWEST

/turf/open/floor/whitered/northwest
	dir = NORTHWEST

/turf/open/floor/whiteyellow/northwest
	dir = NORTHWEST

/turf/open/floor/asteroid
	icon_state = "asteroid"

/turf/open/floor/asteroidfloor/north
	dir = NORTH

/turf/open/floor/asteroidplating
	icon_state = "asteroidplating"

/turf/open/floor/asteroidwarning/southwest
	dir = SOUTHWEST

/turf/open/floor/asteroidwarning/north
	dir = NORTH

/turf/open/floor/asteroidwarning/east
	dir = EAST

/turf/open/floor/asteroidwarning/northeast
	dir = NORTHEAST

/turf/open/floor/asteroidwarning/southeast
	dir = SOUTHEAST

/turf/open/floor/asteroidwarning/west
	dir = WEST

/turf/open/floor/asteroidwarning/northwest
	dir = NORTHWEST

/turf/open/floor/bar
	icon_state = "bar"

/turf/open/floor/bcircuit
	icon_state = "bcircuit"

/turf/open/floor/bluecorner
	icon_state = "bluecorner"

/turf/open/floor/blueyellowfull
	icon_state = "blueyellowfull"

/turf/open/floor/cafeteria
	icon_state = "cafeteriaold"

/turf/open/floor/cmo
	icon_state = "cmo"

/turf/open/floor/cult
	icon_state = "cult"

/turf/open/floor/dark
	icon_state = "dark"

/turf/open/floor/dark2
	icon_state = "dark2"

/turf/open/floor/darkbluecorners2
	icon_state = "darkbluecorners2"

/turf/open/floor/darkish
	icon_state = "darkish"

/turf/open/floor/delivery
	icon_state = "delivery"

/turf/open/floor/floor4
	icon_state = "floor4"

/turf/open/floor/floorscorched1
	icon_state = "floorscorched1"

/turf/open/floor/floorscorched2
	icon_state = "floorscorched2"

/turf/open/floor/freezerfloor
	icon_state = "freezerfloor"

/turf/open/floor/grimy
	icon_state = "grimy"

/turf/open/floor/hydrofloor
	icon_state = "hydrofloor"

/turf/open/floor/neutral
	icon_state = "neutral"

/turf/open/floor/panelscorched
	icon_state = "panelscorched"

/turf/open/floor/platebot
	icon_state = "platebot"

/turf/open/floor/platingdmg1
	icon_state = "platingdmg1"

/turf/open/floor/platingdmg3
	icon_state = "platingdmg3"

/turf/open/floor/redyellowfull
	icon_state = "redyellowfull"

/turf/open/floor/wall_thermite
	icon_state = "wall_thermite"

/turf/open/floor/warnwhite/north
	dir = NORTH

/turf/open/floor/white
	icon_state = "white"

/turf/open/floor/whitepurplefull
	icon_state = "whitepurplefull"

/turf/open/floor/whiteredfull
	icon_state = "whiteredfull"

/turf/open/floor/wood
	icon_state = "wood"

/turf/open/floor/yellowfull
	icon_state = "yellowfull"

/turf/open/floor/corsat/squareswood/pred
	icon_state = "squareswood"

/turf/open/floor/corsat/squareswood/pred/north
	dir = NORTH

/turf/open/floor/strata/gray_multi_tiles/pred
	color = "#5e5d5d"
	icon_state = "multi_tiles"

/turf/open/floor/strata/gray_multi_tiles/south/pred
	dir = SOUTH

/turf/open/floor/cult/pred
	icon_state = "cult"

/turf/open/gm/grass/grass2/pred
	icon_state = "grass2"
